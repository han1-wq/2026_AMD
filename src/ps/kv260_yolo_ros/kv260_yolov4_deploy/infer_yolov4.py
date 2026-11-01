import time
import cv2
import numpy as np
from pynq_dpu import DpuOverlay


# ============================================================
# 路径和参数
# ============================================================

BITFILE = "/home/ubuntu/kv260_yolov4_deploy/overlay/dpu.bit"
XMODEL = "/home/ubuntu/kv260_yolov4_deploy/compiled/yolov4_leaky_416_tf.xmodel"
IMAGE_PATH = "/home/ubuntu/kv260_yolov4_deploy/dog.jpg"
RESULT_PATH = "/home/ubuntu/kv260_yolov4_deploy/result.jpg"

INPUT_W = 416
INPUT_H = 416

CONF_THRESHOLD = 0.30
NMS_THRESHOLD = 0.60


# COCO 80 类，名称顺序与该 YOLOv4 工程保持一致
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


# 按输出网格大小分配 anchors
# 52x52：小目标
# 26x26：中目标
# 13x13：大目标
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
    image_float = image_rgb.astype(np.float32) / 256.0
    quant_scale = float(2 ** input_fix_point)

    image_int8 = np.round(image_float * quant_scale)
    image_int8 = np.clip(image_int8, -128, 127).astype(np.int8)

    # 增加 batch 维度
    return np.expand_dims(image_int8, axis=0)


def decode_yolo_output(output, anchors, conf_threshold):
    """
    output 形状：
      [1, H, W, 255]

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

    # [H, W, 3, 85]
    prediction = output.reshape(
        grid_h,
        grid_w,
        3,
        85
    )

    # 网格坐标
    grid_x, grid_y = np.meshgrid(
        np.arange(grid_w, dtype=np.float32),
        np.arange(grid_h, dtype=np.float32)
    )

    grid = np.stack([grid_x, grid_y], axis=-1)
    grid = np.expand_dims(grid, axis=2)  # [H,W,1,2]

    # 中心坐标
    box_xy = sigmoid(prediction[..., 0:2])
    box_xy = box_xy + grid
    box_xy[..., 0] /= float(grid_w)
    box_xy[..., 1] /= float(grid_h)

    # 宽高
    # 防止错误输出导致指数溢出
    box_wh_raw = np.clip(prediction[..., 2:4], -10.0, 10.0)
    box_wh = np.exp(box_wh_raw)

    anchors_reshaped = anchors.reshape(1, 1, 3, 2)
    box_wh = box_wh * anchors_reshaped

    box_wh[..., 0] /= float(INPUT_W)
    box_wh[..., 1] /= float(INPUT_H)

    objectness = sigmoid(prediction[..., 4:5])
    class_probabilities = sigmoid(prediction[..., 5:])

    class_scores = objectness * class_probabilities

    class_ids = np.argmax(class_scores, axis=-1)
    scores = np.max(class_scores, axis=-1)

    mask = scores >= conf_threshold

    if not np.any(mask):
        return (
            np.empty((0, 4), dtype=np.float32),
            np.empty((0,), dtype=np.float32),
            np.empty((0,), dtype=np.int32)
        )

    selected_xy = box_xy[mask]
    selected_wh = box_wh[mask]
    selected_scores = scores[mask]
    selected_classes = class_ids[mask].astype(np.int32)

    x1 = (selected_xy[:, 0] - selected_wh[:, 0] / 2.0) * INPUT_W
    y1 = (selected_xy[:, 1] - selected_wh[:, 1] / 2.0) * INPUT_H
    x2 = (selected_xy[:, 0] + selected_wh[:, 0] / 2.0) * INPUT_W
    y2 = (selected_xy[:, 1] + selected_wh[:, 1] / 2.0) * INPUT_H

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


def main():
    print("Loading image:", IMAGE_PATH)

    original_image = cv2.imread(IMAGE_PATH)

    if original_image is None:
        raise RuntimeError("Failed to load image: " + IMAGE_PATH)

    original_h, original_w = original_image.shape[:2]

    print("Original image shape:", original_image.shape)

    print("\nLoading DPU overlay...")
    overlay = DpuOverlay(BITFILE)
    print("DPU overlay loaded")

    print("Loading XModel...")
    overlay.load_model(XMODEL)
    print("XModel loaded")

    runner = overlay.runner

    input_tensors = runner.get_input_tensors()
    output_tensors = runner.get_output_tensors()

    if len(input_tensors) != 1:
        raise RuntimeError(
            "Expected one input tensor, got {}".format(len(input_tensors))
        )

    input_tensor = input_tensors[0]
    input_fix_point = input_tensor.get_attr("fix_point")

    print("\nInput tensor:")
    print("  name:", input_tensor.name)
    print("  dims:", input_tensor.dims)
    print("  fix_point:", input_fix_point)

    # 图片预处理
    image_rgb, scale, pad_x, pad_y = letterbox_image(
        original_image,
        INPUT_W,
        INPUT_H
    )

    input_data = quantize_input(
        image_rgb,
        input_fix_point
    )

    print("\nPreprocessing:")
    print("  scale:", scale)
    print("  pad_x:", pad_x)
    print("  pad_y:", pad_y)
    print("  input int8 min/max:",
          int(input_data.min()),
          int(input_data.max()))

    # 按 runner 输出形状分配 int8 缓冲区
    output_data = [
        np.empty(tuple(tensor.dims), dtype=np.int8)
        for tensor in output_tensors
    ]

    print("\nRunning DPU inference...")

    start_time = time.time()

    job_id = runner.execute_async(
        [input_data],
        output_data
    )

    runner.wait(job_id)

    elapsed = time.time() - start_time

    print("DPU inference completed")
    print("DPU elapsed time: {:.6f} seconds".format(elapsed))
    print("DPU FPS (single inference): {:.2f}".format(1.0 / elapsed))

    all_boxes = []
    all_scores = []
    all_classes = []

    # 对每一个输出进行反量化和解码
    for index, tensor in enumerate(output_tensors):
        dims = tuple(tensor.dims)
        grid_h = dims[1]
        grid_w = dims[2]
        output_fix_point = tensor.get_attr("fix_point")

        print("\nOutput {}:".format(index))
        print("  name:", tensor.name)
        print("  dims:", dims)
        print("  fix_point:", output_fix_point)
        print("  int8 min/max:",
              int(output_data[index].min()),
              int(output_data[index].max()))

        if grid_h not in ANCHORS:
            raise RuntimeError(
                "No anchors configured for output grid {}".format(grid_h)
            )

        # 反量化：real = int8 * 2^(-fix_point)
        output_float = (
            output_data[index].astype(np.float32)
            * (2.0 ** (-output_fix_point))
        )

        boxes, scores, classes = decode_yolo_output(
            output_float,
            ANCHORS[grid_h],
            CONF_THRESHOLD
        )

        print("  candidates above threshold:", len(boxes))

        all_boxes.append(boxes)
        all_scores.append(scores)
        all_classes.append(classes)

    if len(all_boxes) == 0:
        print("No output tensors decoded")
        cv2.imwrite(RESULT_PATH, original_image)
        return

    boxes = np.concatenate(all_boxes, axis=0)
    scores = np.concatenate(all_scores, axis=0)
    classes = np.concatenate(all_classes, axis=0)

    print("\nTotal candidates before NMS:", len(boxes))

    if len(boxes) == 0:
        print("No objects detected above confidence threshold")
        cv2.imwrite(RESULT_PATH, original_image)
        print("Saved unchanged image to:", RESULT_PATH)
        return

    selected_indices = classwise_nms(
        boxes,
        scores,
        classes,
        NMS_THRESHOLD
    )

    boxes = boxes[selected_indices]
    scores = scores[selected_indices]
    classes = classes[selected_indices]

    boxes = map_boxes_to_original(
        boxes,
        scale,
        pad_x,
        pad_y,
        original_w,
        original_h
    )

    print("Objects after NMS:", len(boxes))

    result_image = original_image.copy()

    for box, score, class_id in zip(boxes, scores, classes):
        x1, y1, x2, y2 = box.astype(np.int32)

        # 忽略无效框
        if x2 <= x1 or y2 <= y1:
            continue

        class_id = int(class_id)
        score = float(score)

        if 0 <= class_id < len(CLASS_NAMES):
            class_name = CLASS_NAMES[class_id]
        else:
            class_name = "class_{}".format(class_id)

        print(
            "{} {:.6f} {} {} {} {}".format(
                class_name,
                score,
                x1,
                y1,
                x2,
                y2
            )
        )

        color = color_for_class(class_id)

        cv2.rectangle(
            result_image,
            (x1, y1),
            (x2, y2),
            color,
            2
        )

        label = "{} {:.2f}".format(class_name, score)

        (text_w, text_h), baseline = cv2.getTextSize(
            label,
            cv2.FONT_HERSHEY_SIMPLEX,
            0.5,
            1
        )

        label_y1 = max(0, y1 - text_h - baseline - 4)

        cv2.rectangle(
            result_image,
            (x1, label_y1),
            (x1 + text_w + 4, y1),
            color,
            -1
        )

        cv2.putText(
            result_image,
            label,
            (x1 + 2, max(text_h + 1, y1 - baseline - 2)),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.5,
            (255, 255, 255),
            1,
            cv2.LINE_AA
        )

    if not cv2.imwrite(RESULT_PATH, result_image):
        raise RuntimeError("Failed to save result image")

    print("\nResult saved to:")
    print(RESULT_PATH)


if __name__ == "__main__":
    main()
    
