#!/usr/bin/env python3

import argparse
import math
import time
from pathlib import Path

import cv2
import numpy as np
from pynq_dpu import DpuOverlay


# ============================================================
# 默认路径
# ============================================================

BASE_DIR = Path(__file__).resolve().parent

DEFAULT_BITFILE = BASE_DIR / "overlay" / "dpu.bit"

DEFAULT_XMODEL = (
    BASE_DIR
    / "compiled"
    / "ofa_yolo_pruned_0_30_pt.xmodel"
)

DEFAULT_IMAGE = (
    BASE_DIR
    / "coco_test_images"
    / "000000064359.jpg"
)

DEFAULT_RESULT = BASE_DIR / "result_ofa_yolo.jpg"


# ============================================================
# OFA-YOLO 34.72G 参数
# ============================================================

INPUT_W = 640
INPUT_H = 640

# 来自官方 prototxt，约等于 1/255
INPUT_SCALE = 0.00392156

CONF_THRESHOLD = 0.40
NMS_THRESHOLD = 0.65

NUM_CLASSES = 80
ANCHOR_COUNT = 3
VALUES_PER_ANCHOR = NUM_CLASSES + 5
OUTPUT_CHANNELS = ANCHOR_COUNT * VALUES_PER_ANCHOR

MAX_CANDIDATES = 30000
MAX_DETECTIONS = 300

# YOLOv5 常用 letterbox 填充值。
LETTERBOX_FILL_VALUE = 114


# ============================================================
# COCO 80 类
# ============================================================

CLASS_NAMES = [
    "person", "bicycle", "car", "motorcycle", "airplane",
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
    "donut", "cake", "chair", "couch", "potted plant",
    "bed", "dining table", "toilet", "tv", "laptop",
    "mouse", "remote", "keyboard", "cell phone", "microwave",
    "oven", "toaster", "sink", "refrigerator", "book",
    "clock", "vase", "scissors", "teddy bear", "hair drier",
    "toothbrush",
]


# ============================================================
# 官方 prototxt 中的 anchors
# ============================================================

ANCHORS_BY_STRIDE = {
    8: np.asarray(
        [
            [10.0, 13.0],
            [16.0, 30.0],
            [33.0, 23.0],
        ],
        dtype=np.float32,
    ),

    16: np.asarray(
        [
            [30.0, 61.0],
            [62.0, 45.0],
            [59.0, 119.0],
        ],
        dtype=np.float32,
    ),

    32: np.asarray(
        [
            [116.0, 90.0],
            [156.0, 198.0],
            [373.0, 326.0],
        ],
        dtype=np.float32,
    ),
}


# 缓存每个 stride 对应的扁平化 grid 和 anchor。
DECODE_CACHE = {}


def sigmoid(x):
    """数值稳定的 sigmoid。"""
    x = np.clip(x, -30.0, 30.0)
    return 1.0 / (1.0 + np.exp(-x))


def get_tensor_dims(tensor):
    return tuple(int(value) for value in tensor.dims)


def get_fix_point(tensor):
    return int(tensor.get_attr("fix_point"))


def letterbox_image(
    image_bgr,
    target_w=INPUT_W,
    target_h=INPUT_H,
    fill_value=LETTERBOX_FILL_VALUE,
):
    """
    保持宽高比，将 BGR 图像填充到模型输入尺寸。

    对 640x480 摄像头：
      scale = 1
      pad_x = 0
      pad_y = 80
    """
    if image_bgr is None:
        raise ValueError("Input image is None")

    original_h, original_w = image_bgr.shape[:2]

    if original_h <= 0 or original_w <= 0:
        raise ValueError(
            "Invalid image size: {}x{}".format(
                original_w,
                original_h,
            )
        )

    scale = min(
        target_w / float(original_w),
        target_h / float(original_h),
    )

    resized_w = int(round(original_w * scale))
    resized_h = int(round(original_h * scale))

    if resized_w == original_w and resized_h == original_h:
        resized = image_bgr
    else:
        resized = cv2.resize(
            image_bgr,
            (resized_w, resized_h),
            interpolation=cv2.INTER_LINEAR,
        )

    canvas = np.full(
        (target_h, target_w, 3),
        fill_value,
        dtype=np.uint8,
    )

    pad_x = (target_w - resized_w) // 2
    pad_y = (target_h - resized_h) // 2

    canvas[
        pad_y:pad_y + resized_h,
        pad_x:pad_x + resized_w,
    ] = resized

    image_rgb = cv2.cvtColor(
        canvas,
        cv2.COLOR_BGR2RGB,
    )

    return image_rgb, scale, pad_x, pad_y


def quantize_input(image_rgb, input_tensor):
    """
    将 RGB uint8 图像转换为 DPU INT8 输入。

    real = pixel * INPUT_SCALE
    int8 = round(real * 2^fix_point)
    """
    dims = get_tensor_dims(input_tensor)
    fix_point = get_fix_point(input_tensor)

    if len(dims) != 4:
        raise RuntimeError(
            "Unsupported input dimensions: {}".format(dims)
        )

    quant_scale = float(2 ** fix_point)

    # 合并浮点缩放，减少中间运算。
    combined_scale = INPUT_SCALE * quant_scale

    image_int8 = np.rint(
        image_rgb.astype(np.float32) * combined_scale
    )

    image_int8 = np.clip(
        image_int8,
        -128,
        127,
    ).astype(np.int8)

    # NHWC
    if dims[-1] == 3:
        input_data = image_int8[np.newaxis, ...]

    # NCHW
    elif dims[1] == 3:
        input_data = np.transpose(
            image_int8,
            (2, 0, 1),
        )[np.newaxis, ...]

    else:
        raise RuntimeError(
            "Cannot determine input layout from {}".format(dims)
        )

    if tuple(input_data.shape) != dims:
        raise RuntimeError(
            "Prepared input shape {} does not match {}".format(
                tuple(input_data.shape),
                dims,
            )
        )

    return np.ascontiguousarray(input_data)


def normalize_output_layout(output):
    """
    将输出统一转换为 [H,W,3,85]。

    当前实际输出为：
      [1,80,80,255]
      [1,40,40,255]
      [1,20,20,255]
    """
    output = np.asarray(output)

    if output.shape[0] != 1:
        raise RuntimeError(
            "Only batch size 1 is supported: {}".format(
                output.shape
            )
        )

    output = output[0]

    # [H,W,255]
    if output.ndim == 3 and output.shape[-1] == OUTPUT_CHANNELS:
        grid_h, grid_w, _ = output.shape

        return output.reshape(
            grid_h,
            grid_w,
            ANCHOR_COUNT,
            VALUES_PER_ANCHOR,
        )

    # [255,H,W]
    if output.ndim == 3 and output.shape[0] == OUTPUT_CHANNELS:
        output = np.transpose(output, (1, 2, 0))
        grid_h, grid_w, _ = output.shape

        return output.reshape(
            grid_h,
            grid_w,
            ANCHOR_COUNT,
            VALUES_PER_ANCHOR,
        )

    # [H,W,3,85]
    if (
        output.ndim == 4
        and output.shape[-2] == ANCHOR_COUNT
        and output.shape[-1] == VALUES_PER_ANCHOR
    ):
        return output

    # [3,H,W,85]
    if (
        output.ndim == 4
        and output.shape[0] == ANCHOR_COUNT
        and output.shape[-1] == VALUES_PER_ANCHOR
    ):
        return np.transpose(output, (1, 2, 0, 3))

    # [3,85,H,W]
    if (
        output.ndim == 4
        and output.shape[0] == ANCHOR_COUNT
        and output.shape[1] == VALUES_PER_ANCHOR
    ):
        return np.transpose(output, (2, 3, 0, 1))

    raise RuntimeError(
        "Unsupported output layout: {}".format(output.shape)
    )


def infer_stride_from_output(output):
    prediction = normalize_output_layout(output)
    grid_h, grid_w = prediction.shape[:2]

    if INPUT_H % grid_h != 0 or INPUT_W % grid_w != 0:
        raise RuntimeError(
            "Cannot infer stride from grid {}x{}".format(
                grid_w,
                grid_h,
            )
        )

    stride_h = INPUT_H // grid_h
    stride_w = INPUT_W // grid_w

    if stride_h != stride_w:
        raise RuntimeError(
            "Different horizontal/vertical strides: {}, {}".format(
                stride_w,
                stride_h,
            )
        )

    stride = int(stride_h)

    if stride not in ANCHORS_BY_STRIDE:
        raise RuntimeError(
            "Unsupported stride {}".format(stride)
        )

    return stride


def get_decode_cache(grid_h, grid_w, stride):
    """
    只生成一次 grid 和 anchor，后续每帧重复使用。
    """
    key = (grid_h, grid_w, stride)

    if key in DECODE_CACHE:
        return DECODE_CACHE[key]

    grid_x, grid_y = np.meshgrid(
        np.arange(grid_w, dtype=np.float32),
        np.arange(grid_h, dtype=np.float32),
    )

    grid = np.stack(
        [grid_x, grid_y],
        axis=-1,
    )

    grid = np.expand_dims(grid, axis=2)

    grid = np.broadcast_to(
        grid,
        (grid_h, grid_w, ANCHOR_COUNT, 2),
    ).reshape(-1, 2).copy()

    anchors = ANCHORS_BY_STRIDE[stride]

    anchors_flat = np.broadcast_to(
        anchors.reshape(1, 1, ANCHOR_COUNT, 2),
        (grid_h, grid_w, ANCHOR_COUNT, 2),
    ).reshape(-1, 2).copy()

    DECODE_CACHE[key] = (
        grid.astype(np.float32),
        anchors_flat.astype(np.float32),
    )

    return DECODE_CACHE[key]


def decode_yolov5_output(
    output,
    stride,
    conf_threshold=CONF_THRESHOLD,
):
    """
    优化版 YOLOv5 解码。

    优化点：
      1. 先检查 objectness；
      2. 只对通过 objectness 的候选计算 80 类 sigmoid；
      3. 只解码最终通过置信度的候选框；
      4. grid 和 anchor 只生成一次。
    """
    prediction = normalize_output_layout(output)

    grid_h, grid_w, anchor_count, value_count = prediction.shape

    if anchor_count != ANCHOR_COUNT:
        raise RuntimeError(
            "Unexpected anchor count: {}".format(anchor_count)
        )

    if value_count != VALUES_PER_ANCHOR:
        raise RuntimeError(
            "Unexpected values per anchor: {}".format(value_count)
        )

    raw = prediction.reshape(
        -1,
        VALUES_PER_ANCHOR,
    )

    # sigmoid(raw_objectness) >= conf_threshold 等价于：
    # raw_objectness >= log(conf / (1-conf))
    objectness_logit_threshold = math.log(
        conf_threshold / (1.0 - conf_threshold)
    )

    candidate_indices = np.flatnonzero(
        raw[:, 4] >= objectness_logit_threshold
    )

    if candidate_indices.size == 0:
        return (
            np.empty((0, 4), dtype=np.float32),
            np.empty((0,), dtype=np.float32),
            np.empty((0,), dtype=np.int32),
        )

    candidate_raw = raw[candidate_indices]

    candidate_objectness = sigmoid(
        candidate_raw[:, 4]
    )

    # 仅对 objectness 足够高的候选计算 80 类概率。
    class_probabilities = sigmoid(
        candidate_raw[:, 5:]
    )

    class_ids = np.argmax(
        class_probabilities,
        axis=1,
    )

    best_class_probabilities = np.max(
        class_probabilities,
        axis=1,
    )

    candidate_scores = (
        candidate_objectness
        * best_class_probabilities
    )

    final_mask = candidate_scores >= conf_threshold

    if not np.any(final_mask):
        return (
            np.empty((0, 4), dtype=np.float32),
            np.empty((0,), dtype=np.float32),
            np.empty((0,), dtype=np.int32),
        )

    final_indices = candidate_indices[final_mask]
    final_raw = raw[final_indices]

    selected_scores = candidate_scores[
        final_mask
    ].astype(np.float32)

    selected_classes = class_ids[
        final_mask
    ].astype(np.int32)

    grid_flat, anchors_flat = get_decode_cache(
        grid_h,
        grid_w,
        stride,
    )

    selected_grid = grid_flat[final_indices]
    selected_anchors = anchors_flat[final_indices]

    activated_xy = sigmoid(
        final_raw[:, 0:2]
    )

    activated_wh = sigmoid(
        final_raw[:, 2:4]
    )

    # YOLOv5 坐标解码。
    box_xy = (
        activated_xy * 2.0
        - 0.5
        + selected_grid
    ) * float(stride)

    box_wh = (
        activated_wh * 2.0
    ) ** 2

    box_wh *= selected_anchors

    x1 = box_xy[:, 0] - box_wh[:, 0] * 0.5
    y1 = box_xy[:, 1] - box_wh[:, 1] * 0.5
    x2 = box_xy[:, 0] + box_wh[:, 0] * 0.5
    y2 = box_xy[:, 1] + box_wh[:, 1] * 0.5

    boxes = np.stack(
        [x1, y1, x2, y2],
        axis=1,
    ).astype(np.float32)

    return boxes, selected_scores, selected_classes


def limit_candidates(
    boxes,
    scores,
    classes,
    max_candidates=MAX_CANDIDATES,
):
    if max_candidates is None or len(scores) <= max_candidates:
        return boxes, scores, classes

    selected = np.argpartition(
        scores,
        -max_candidates,
    )[-max_candidates:]

    selected = selected[
        np.argsort(scores[selected])[::-1]
    ]

    return (
        boxes[selected],
        scores[selected],
        classes[selected],
    )


def nms_single_class(boxes, scores, threshold):
    if len(boxes) == 0:
        return []

    x1 = boxes[:, 0]
    y1 = boxes[:, 1]
    x2 = boxes[:, 2]
    y2 = boxes[:, 3]

    areas = (
        np.maximum(0.0, x2 - x1)
        * np.maximum(0.0, y2 - y1)
    )

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

        intersection = (
            np.maximum(0.0, xx2 - xx1)
            * np.maximum(0.0, yy2 - yy1)
        )

        union = (
            areas[current]
            + areas[remaining]
            - intersection
            + 1e-9
        )

        iou = intersection / union

        order = remaining[
            np.where(iou <= threshold)[0]
        ]

    return keep


def classwise_nms(
    boxes,
    scores,
    classes,
    threshold=NMS_THRESHOLD,
    max_detections=MAX_DETECTIONS,
):
    if len(boxes) == 0:
        return np.empty((0,), dtype=np.int32)

    final_indices = []

    for class_id in np.unique(classes):
        class_indices = np.where(
            classes == class_id
        )[0]

        selected_local = nms_single_class(
            boxes[class_indices],
            scores[class_indices],
            threshold,
        )

        final_indices.extend(
            class_indices[selected_local].tolist()
        )

    final_indices.sort(
        key=lambda index: float(scores[index]),
        reverse=True,
    )

    final_indices = final_indices[:max_detections]

    return np.asarray(
        final_indices,
        dtype=np.int32,
    )


def map_boxes_to_original(
    boxes,
    scale,
    pad_x,
    pad_y,
    original_w,
    original_h,
):
    if len(boxes) == 0:
        return boxes.astype(np.float32, copy=True)

    mapped = boxes.astype(
        np.float32,
        copy=True,
    )

    mapped[:, [0, 2]] -= float(pad_x)
    mapped[:, [1, 3]] -= float(pad_y)

    mapped[:, [0, 2]] /= float(scale)
    mapped[:, [1, 3]] /= float(scale)

    mapped[:, 0] = np.clip(
        mapped[:, 0], 0, original_w - 1
    )
    mapped[:, 1] = np.clip(
        mapped[:, 1], 0, original_h - 1
    )
    mapped[:, 2] = np.clip(
        mapped[:, 2], 0, original_w - 1
    )
    mapped[:, 3] = np.clip(
        mapped[:, 3], 0, original_h - 1
    )

    return mapped


def color_for_class(class_id):
    return (
        int((37 * class_id + 80) % 255),
        int((17 * class_id + 160) % 255),
        int((29 * class_id + 220) % 255),
    )


def draw_detections(
    image,
    boxes,
    scores,
    classes,
    verbose=False,
):
    valid_count = 0

    for box, score, class_id in zip(
        boxes,
        scores,
        classes,
    ):
        x1, y1, x2, y2 = box.astype(np.int32)

        x1 = int(np.clip(x1, 0, image.shape[1] - 1))
        y1 = int(np.clip(y1, 0, image.shape[0] - 1))
        x2 = int(np.clip(x2, 0, image.shape[1] - 1))
        y2 = int(np.clip(y2, 0, image.shape[0] - 1))

        if x2 <= x1 or y2 <= y1:
            continue

        class_id = int(class_id)
        score = float(score)

        if 0 <= class_id < len(CLASS_NAMES):
            class_name = CLASS_NAMES[class_id]
        else:
            class_name = "class_{}".format(class_id)

        if verbose:
            print(
                "{} {:.6f} {} {} {} {}".format(
                    class_name,
                    score,
                    x1,
                    y1,
                    x2,
                    y2,
                )
            )

        color = color_for_class(class_id)

        cv2.rectangle(
            image,
            (x1, y1),
            (x2, y2),
            color,
            2,
        )

        label = "{} {:.2f}".format(
            class_name,
            score,
        )

        (text_w, text_h), baseline = cv2.getTextSize(
            label,
            cv2.FONT_HERSHEY_SIMPLEX,
            0.50,
            1,
        )

        label_top = max(
            0,
            y1 - text_h - baseline - 4,
        )

        label_right = min(
            image.shape[1] - 1,
            x1 + text_w + 4,
        )

        cv2.rectangle(
            image,
            (x1, label_top),
            (label_right, y1),
            color,
            -1,
        )

        cv2.putText(
            image,
            label,
            (
                x1 + 2,
                max(text_h + 1, y1 - baseline - 2),
            ),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.50,
            (255, 255, 255),
            1,
            cv2.LINE_AA,
        )

        valid_count += 1

    return valid_count


def allocate_output_buffers(output_tensors):
    return [
        np.empty(
            get_tensor_dims(tensor),
            dtype=np.int8,
        )
        for tensor in output_tensors
    ]


def print_tensor_information(
    input_tensors,
    output_tensors,
):
    print("\nInput tensors:")

    for tensor in input_tensors:
        print(
            "  name={} dims={} fix_point={}".format(
                tensor.name,
                get_tensor_dims(tensor),
                get_fix_point(tensor),
            )
        )

    print("\nOutput tensors:")

    for tensor in output_tensors:
        print(
            "  name={} dims={} fix_point={}".format(
                tensor.name,
                get_tensor_dims(tensor),
                get_fix_point(tensor),
            )
        )


def validate_model_tensors(
    input_tensors,
    output_tensors,
):
    if len(input_tensors) != 1:
        raise RuntimeError(
            "Expected one input tensor, got {}".format(
                len(input_tensors)
            )
        )

    if len(output_tensors) != 3:
        raise RuntimeError(
            "Expected three output tensors, got {}".format(
                len(output_tensors)
            )
        )

    input_dims = get_tensor_dims(input_tensors[0])

    valid_nhwc = (
        input_dims == (1, INPUT_H, INPUT_W, 3)
    )

    valid_nchw = (
        input_dims == (1, 3, INPUT_H, INPUT_W)
    )

    if not valid_nhwc and not valid_nchw:
        raise RuntimeError(
            "Unexpected input dimensions: {}".format(
                input_dims
            )
        )


def infer_frame(
    frame,
    runner,
    input_tensor,
    output_tensors,
    output_buffers,
):
    """
    执行一帧完整推理。

    返回：
      boxes
      scores
      classes
      timing

    timing 包含：
      preprocess
      dpu
      postprocess
      total
    """
    total_start = time.perf_counter()

    original_h, original_w = frame.shape[:2]

    # --------------------------------------------------------
    # 预处理
    # --------------------------------------------------------

    preprocess_start = time.perf_counter()

    image_rgb, scale, pad_x, pad_y = letterbox_image(
        frame,
        INPUT_W,
        INPUT_H,
    )

    input_buffer = quantize_input(
        image_rgb,
        input_tensor,
    )

    preprocess_time = (
        time.perf_counter() - preprocess_start
    )

    # --------------------------------------------------------
    # DPU
    # --------------------------------------------------------

    dpu_start = time.perf_counter()

    job_id = runner.execute_async(
        [input_buffer],
        output_buffers,
    )

    runner.wait(job_id)

    dpu_time = (
        time.perf_counter() - dpu_start
    )

    # --------------------------------------------------------
    # 后处理
    # --------------------------------------------------------

    postprocess_start = time.perf_counter()

    all_boxes = []
    all_scores = []
    all_classes = []

    for index, tensor in enumerate(output_tensors):
        output_fix_point = get_fix_point(tensor)

        output_float = (
            output_buffers[index].astype(np.float32)
            * (2.0 ** (-output_fix_point))
        )

        stride = infer_stride_from_output(
            output_float
        )

        boxes, scores, classes = decode_yolov5_output(
            output_float,
            stride,
            CONF_THRESHOLD,
        )

        all_boxes.append(boxes)
        all_scores.append(scores)
        all_classes.append(classes)

    boxes = np.concatenate(
        all_boxes,
        axis=0,
    )

    scores = np.concatenate(
        all_scores,
        axis=0,
    )

    classes = np.concatenate(
        all_classes,
        axis=0,
    )

    if len(boxes) > 0:
        boxes, scores, classes = limit_candidates(
            boxes,
            scores,
            classes,
            MAX_CANDIDATES,
        )

        selected = classwise_nms(
            boxes,
            scores,
            classes,
            NMS_THRESHOLD,
            MAX_DETECTIONS,
        )

        boxes = boxes[selected]
        scores = scores[selected]
        classes = classes[selected]

        boxes = map_boxes_to_original(
            boxes,
            scale,
            pad_x,
            pad_y,
            original_w,
            original_h,
        )

    postprocess_time = (
        time.perf_counter() - postprocess_start
    )

    total_time = (
        time.perf_counter() - total_start
    )

    timing = {
        "preprocess": preprocess_time,
        "dpu": dpu_time,
        "postprocess": postprocess_time,
        "total": total_time,
    }

    return boxes, scores, classes, timing


def main():
    parser = argparse.ArgumentParser(
        description="KV260 OFA-YOLO single-image inference"
    )

    parser.add_argument(
        "--bitfile",
        default=str(DEFAULT_BITFILE),
    )

    parser.add_argument(
        "--xmodel",
        default=str(DEFAULT_XMODEL),
    )

    parser.add_argument(
        "--image",
        default=str(DEFAULT_IMAGE),
    )

    parser.add_argument(
        "--result",
        default=str(DEFAULT_RESULT),
    )

    parser.add_argument(
        "--iterations",
        type=int,
        default=10,
        help="Number of measured DPU inference iterations",
    )

    args = parser.parse_args()

    for name, path in [
        ("bitfile", Path(args.bitfile)),
        ("xmodel", Path(args.xmodel)),
        ("image", Path(args.image)),
    ]:
        if not path.is_file():
            raise FileNotFoundError(
                "{} does not exist: {}".format(
                    name,
                    path,
                )
            )

    image = cv2.imread(args.image)

    if image is None:
        raise RuntimeError(
            "Cannot read image: {}".format(args.image)
        )

    print("Input image:")
    print("  path:", args.image)
    print("  shape:", image.shape)

    print("\nLoading B4096 DPU overlay:")
    print(" ", args.bitfile)

    overlay = DpuOverlay(args.bitfile)

    print("DPU overlay loaded")

    print("\nLoading OFA-YOLO XModel:")
    print(" ", args.xmodel)

    overlay.load_model(args.xmodel)

    print("XModel loaded")

    runner = overlay.runner

    input_tensors = runner.get_input_tensors()
    output_tensors = runner.get_output_tensors()

    validate_model_tensors(
        input_tensors,
        output_tensors,
    )

    print_tensor_information(
        input_tensors,
        output_tensors,
    )

    input_tensor = input_tensors[0]

    output_buffers = allocate_output_buffers(
        output_tensors
    )

    print("\nWarming up DPU...")

    infer_frame(
        image,
        runner,
        input_tensor,
        output_tensors,
        output_buffers,
    )

    print("DPU warm-up completed")

    timing_results = []
    boxes = None
    scores = None
    classes = None

    iterations = max(1, args.iterations)

    for _ in range(iterations):
        boxes, scores, classes, timing = infer_frame(
            image,
            runner,
            input_tensor,
            output_tensors,
            output_buffers,
        )

        timing_results.append(timing)

    average_preprocess = np.mean(
        [item["preprocess"] for item in timing_results]
    )

    average_dpu = np.mean(
        [item["dpu"] for item in timing_results]
    )

    average_postprocess = np.mean(
        [item["postprocess"] for item in timing_results]
    )

    average_total = np.mean(
        [item["total"] for item in timing_results]
    )

    print("\nAverage performance over {} iterations:".format(
        iterations
    ))

    print(
        "  preprocess: {:7.2f} ms".format(
            average_preprocess * 1000.0
        )
    )

    print(
        "  DPU:        {:7.2f} ms ({:.2f} FPS)".format(
            average_dpu * 1000.0,
            1.0 / average_dpu,
        )
    )

    print(
        "  postprocess:{:7.2f} ms".format(
            average_postprocess * 1000.0
        )
    )

    print(
        "  total:      {:7.2f} ms ({:.2f} FPS)".format(
            average_total * 1000.0,
            1.0 / average_total,
        )
    )

    print(
        "  objects: {}".format(len(boxes))
    )

    result = image.copy()

    draw_detections(
        result,
        boxes,
        scores,
        classes,
        verbose=True,
    )

    result_path = Path(args.result)

    if not cv2.imwrite(
        str(result_path),
        result,
    ):
        raise RuntimeError(
            "Cannot save result: {}".format(result_path)
        )

    print("\nResult saved to:")
    print(" ", result_path)


if __name__ == "__main__":
    main()

