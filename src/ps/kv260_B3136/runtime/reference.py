"""CPU reference/overflow fallback copied from the existing board YOLOv4 implementation."""

import cv2

import numpy as np

INPUT_W = INPUT_H = 416

_QUANTIZE_LUT_CACHE = {}

CLASS_NAMES = [
    "person", "bicycle", "car", "motorbike", "aeroplane",
    "bus", "train", "truck", "boat", "traffic light",
    "fire hydrant", "stop sign", "parking meter", "bench", "bird",
    "cat", "dog", "horse", "sheep", "cow",
    "elephant", "bear", "zebra", "giraffe", "backpack",
    "umbrella", "handbag", "tie", "suitcase", "frisbee",
    "skis", "snowboard", "sports ball", "kite", "baseball bat",
    "baseball glove", "skateboard", "surfboard", "tennis racket",
    "bottle", "wine glass", "cup", "fork", "knife",
    "spoon", "bowl", "banana", "apple", "sandwich",
    "orange", "broccoli", "carrot", "hot dog", "pizza",
    "donut", "cake", "chair", "sofa", "pottedplant",
    "bed", "diningtable", "toilet", "tvmonitor", "laptop",
    "mouse", "remote", "keyboard", "cell phone", "microwave",
    "oven", "toaster", "sink", "refrigerator", "book",
    "clock", "vase", "scissors", "teddy bear", "hair drier",
    "toothbrush"
]

ANCHORS = {
    52: np.array([
        [10.0, 13.0],
        [16.0, 30.0],
        [33.0, 23.0]
    ], dtype=np.float32),

    26: np.array([
        [30.0, 61.0],
        [62.0, 45.0],
        [59.0, 119.0]
    ], dtype=np.float32),

    13: np.array([
        [116.0, 90.0],
        [156.0, 198.0],
        [373.0, 326.0]
    ], dtype=np.float32)
}

def sigmoid(x):
    # 防止 exp() 溢出
    x = np.clip(x, -30.0, 30.0)
    return 1.0 / (1.0 + np.exp(-x))

def letterbox_image(image_bgr, target_w=416, target_h=416):
    """
    保持宽高比缩放，并用灰色填充到 416x416。

    返回：
      RGB 图像
      缩放比例
      左侧填充宽度
      顶部填充高度
    """
    original_h, original_w = image_bgr.shape[:2]

    scale = min(
        target_w / float(original_w),
        target_h / float(original_h)
    )

    resized_w = int(round(original_w * scale))
    resized_h = int(round(original_h * scale))

    resized = cv2.resize(
        image_bgr,
        (resized_w, resized_h),
        interpolation=cv2.INTER_LINEAR
    )

    # Darknet/YOLO 常用灰色填充
    canvas = np.full(
        (target_h, target_w, 3),
        128,
        dtype=np.uint8
    )

    pad_x = (target_w - resized_w) // 2
    pad_y = (target_h - resized_h) // 2

    canvas[
        pad_y:pad_y + resized_h,
        pad_x:pad_x + resized_w
    ] = resized

    # TensorFlow/Keras YOLO 模型一般使用 RGB
    canvas_rgb = cv2.cvtColor(canvas, cv2.COLOR_BGR2RGB)

    return canvas_rgb, scale, pad_x, pad_y

def quantize_input(image_rgb, input_fix_point):
    """
    prototxt 中：
      mean  = 0
      scale = 0.00390625 = 1/256

    浮点输入：
      pixel / 256

    DPU 输入 fix_point=6：
      quantized = round(float_value * 2^6)
                = round(pixel / 4)
    """
    input_fix_point = int(input_fix_point)
    image_int8_lut = _QUANTIZE_LUT_CACHE.get(input_fix_point)

    if image_int8_lut is None:
        pixel_values = np.arange(256, dtype=np.float32)
        quant_scale = float(2 ** input_fix_point)
        image_int8_lut = np.clip(
            np.round((pixel_values / 256.0) * quant_scale),
            -128,
            127
        ).astype(np.int8)
        _QUANTIZE_LUT_CACHE[input_fix_point] = image_int8_lut

    image_int8 = image_int8_lut[image_rgb]

    # 增加 batch 维度
    return np.expand_dims(image_int8, axis=0)

def decode_yolo_output(
    output,
    anchors,
    conf_threshold,
    quant_scale=None
):
    """
    output 形状：
      [1, H, W, 255]

    quant_scale:
      None 表示 output 已经是反量化后的浮点数据；否则 output 是
      DPU int8 数据，实际值为 output * quant_scale。

    255 = 3 * (4 box + 1 objectness + 80 classes)

    返回：
      boxes  : 416x416 letterbox 图像中的 x1,y1,x2,y2
      scores
      classes
    """
    output = output[0]

    grid_h, grid_w, channels = output.shape

    if channels != 255:
        raise RuntimeError(
            "Unexpected output channels: {}, expected 255".format(channels)
        )

    # [H, W, 3, 85]。先保留 DPU int8 数据，不再无条件把完整的
    # 10647x85 个值转换成 float32。
    prediction = output.reshape(
        grid_h,
        grid_w,
        3,
        85
    )

    if quant_scale is None:
        objectness_logits = prediction[..., 4].astype(
            np.float32,
            copy=False
        )
    else:
        objectness_logits = (
            prediction[..., 4].astype(np.float32)
            * float(quant_scale)
        )

    objectness = sigmoid(objectness_logits)

    # class_probability 最大为 1，所以 objectness < conf_threshold 的
    # anchor 不可能通过最终阈值。先安全剔除这些 anchor，再只对少量
    # 候选计算 80 个类别，避免 ARM CPU 每帧执行约 85 万次无用 sigmoid。
    objectness_mask = objectness >= conf_threshold

    if not np.any(objectness_mask):
        return (
            np.empty((0, 4), dtype=np.float32),
            np.empty((0,), dtype=np.float32),
            np.empty((0,), dtype=np.int32)
        )

    grid_y, grid_x, anchor_id = np.nonzero(objectness_mask)
    selected_prediction = prediction[objectness_mask].astype(
        np.float32,
        copy=False
    )

    if quant_scale is not None:
        selected_prediction = selected_prediction * float(quant_scale)

    selected_objectness = objectness[objectness_mask]
    class_probabilities = sigmoid(selected_prediction[:, 5:])
    class_scores = selected_objectness[:, None] * class_probabilities
    selected_classes = np.argmax(class_scores, axis=1).astype(np.int32)
    selected_scores = np.max(class_scores, axis=1)

    score_mask = selected_scores >= conf_threshold

    if not np.any(score_mask):
        return (
            np.empty((0, 4), dtype=np.float32),
            np.empty((0,), dtype=np.float32),
            np.empty((0,), dtype=np.int32)
        )

    selected_prediction = selected_prediction[score_mask]
    selected_scores = selected_scores[score_mask]
    selected_classes = selected_classes[score_mask]
    grid_x = grid_x[score_mask].astype(np.float32)
    grid_y = grid_y[score_mask].astype(np.float32)
    anchor_id = anchor_id[score_mask]

    box_xy = sigmoid(selected_prediction[:, 0:2])
    box_xy[:, 0] = (box_xy[:, 0] + grid_x) / float(grid_w)
    box_xy[:, 1] = (box_xy[:, 1] + grid_y) / float(grid_h)

    # 防止错误输出导致指数溢出。
    box_wh = np.exp(
        np.clip(selected_prediction[:, 2:4], -10.0, 10.0)
    )
    box_wh *= anchors[anchor_id]
    box_wh[:, 0] /= float(INPUT_W)
    box_wh[:, 1] /= float(INPUT_H)

    x1 = (box_xy[:, 0] - box_wh[:, 0] / 2.0) * INPUT_W
    y1 = (box_xy[:, 1] - box_wh[:, 1] / 2.0) * INPUT_H
    x2 = (box_xy[:, 0] + box_wh[:, 0] / 2.0) * INPUT_W
    y2 = (box_xy[:, 1] + box_wh[:, 1] / 2.0) * INPUT_H

    boxes = np.stack([x1, y1, x2, y2], axis=-1)

    return boxes, selected_scores, selected_classes

def nms_single_class(boxes, scores, threshold):
    """
    对单一类别执行 NMS。
    boxes: [N,4], 格式 x1,y1,x2,y2
    """
    if len(boxes) == 0:
        return []

    x1 = boxes[:, 0]
    y1 = boxes[:, 1]
    x2 = boxes[:, 2]
    y2 = boxes[:, 3]

    areas = np.maximum(0.0, x2 - x1) * np.maximum(0.0, y2 - y1)
    order = scores.argsort()[::-1]

    keep = []

    while order.size > 0:
        current = int(order[0])
        keep.append(current)

        if order.size == 1:
            break

        remaining = order[1:]

        xx1 = np.maximum(x1[current], x1[remaining])
        yy1 = np.maximum(y1[current], y1[remaining])
        xx2 = np.minimum(x2[current], x2[remaining])
        yy2 = np.minimum(y2[current], y2[remaining])

        intersection_w = np.maximum(0.0, xx2 - xx1)
        intersection_h = np.maximum(0.0, yy2 - yy1)
        intersection = intersection_w * intersection_h

        union = (
            areas[current]
            + areas[remaining]
            - intersection
            + 1e-9
        )

        iou = intersection / union

        remaining_keep = np.where(iou <= threshold)[0]
        order = remaining[remaining_keep]

    return keep

def classwise_nms(boxes, scores, classes, threshold):
    """
    分类别执行 NMS。
    """
    final_indices = []

    for class_id in np.unique(classes):
        class_indices = np.where(classes == class_id)[0]

        class_boxes = boxes[class_indices]
        class_scores = scores[class_indices]

        selected_local = nms_single_class(
            class_boxes,
            class_scores,
            threshold
        )

        final_indices.extend(
            class_indices[selected_local].tolist()
        )

    final_indices.sort(
        key=lambda index: float(scores[index]),
        reverse=True
    )

    return np.array(final_indices, dtype=np.int32)

def map_boxes_to_original(
    boxes,
    scale,
    pad_x,
    pad_y,
    original_w,
    original_h
):
    """
    将 letterbox 416x416 坐标映射回原图。
    """
    mapped = boxes.copy()

    mapped[:, [0, 2]] -= float(pad_x)
    mapped[:, [1, 3]] -= float(pad_y)

    mapped[:, [0, 2]] /= scale
    mapped[:, [1, 3]] /= scale

    mapped[:, 0] = np.clip(mapped[:, 0], 0, original_w - 1)
    mapped[:, 1] = np.clip(mapped[:, 1], 0, original_h - 1)
    mapped[:, 2] = np.clip(mapped[:, 2], 0, original_w - 1)
    mapped[:, 3] = np.clip(mapped[:, 3], 0, original_h - 1)

    return mapped

def color_for_class(class_id):
    """
    为每个类别生成固定颜色。
    OpenCV 颜色顺序是 BGR。
    """
    return (
        int((37 * class_id + 80) % 255),
        int((17 * class_id + 160) % 255),
        int((29 * class_id + 220) % 255)
    )
