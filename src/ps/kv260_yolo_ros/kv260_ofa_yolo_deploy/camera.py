#!/usr/bin/env python3

import argparse
import threading
import time
from pathlib import Path

import cv2
import numpy as np
from pynq_dpu import DpuOverlay

import infer_ofa_yolo as yolo
from sort_tracker import SortLikeTracker


# ============================================================
# 减少 OpenCV 内部线程与采集、推理和显示线程之间的竞争
# ============================================================

cv2.setNumThreads(1)

try:
    cv2.ocl.setUseOpenCL(False)
except Exception:
    pass


# ============================================================
# 默认文件路径
# ============================================================

BASE_DIR = Path(__file__).resolve().parent

DEFAULT_BITFILE = (
    BASE_DIR
    / "overlay"
    / "dpu.bit"
)

DEFAULT_XMODEL = (
    BASE_DIR
    / "compiled"
    / "ofa_yolo_pruned_0_30_pt.xmodel"
)

WINDOW_NAME = "KV260 OFA-YOLO + SORT Tracking"


# ============================================================
# 最新摄像头帧
# ============================================================

class LatestFrame:
    """
    线程安全的最新摄像头帧缓冲区。

    只保存最新一帧，不保存历史帧，防止摄像头帧积压。
    """

    def __init__(self):
        self.lock = threading.Lock()

        self.frame = None
        self.sequence = 0
        self.timestamp = 0.0
        self.capture_fps = 0.0
        self.failed = False

    def update(
        self,
        frame,
        timestamp,
        capture_fps,
    ):
        with self.lock:
            self.frame = frame
            self.timestamp = float(timestamp)
            self.capture_fps = float(capture_fps)
            self.sequence += 1

    def get(self, copy_frame=True):
        with self.lock:
            if self.frame is None:
                return (
                    None,
                    self.sequence,
                    self.timestamp,
                    self.capture_fps,
                )

            if copy_frame:
                frame = self.frame.copy()
            else:
                frame = self.frame

            return (
                frame,
                self.sequence,
                self.timestamp,
                self.capture_fps,
            )

    def set_failed(self):
        with self.lock:
            self.failed = True

    def has_failed(self):
        with self.lock:
            return self.failed


# ============================================================
# 最新 YOLO 检测结果
# ============================================================

class LatestDetection:
    """
    线程安全的最新 YOLO 检测结果。
    """

    def __init__(self):
        self.lock = threading.Lock()

        self.boxes = np.empty(
            (0, 4),
            dtype=np.float32,
        )

        self.scores = np.empty(
            (0,),
            dtype=np.float32,
        )

        self.classes = np.empty(
            (0,),
            dtype=np.int32,
        )

        self.source_sequence = -1
        self.source_timestamp = 0.0
        self.completion_timestamp = 0.0
        self.inference_count = 0

        self.timing = {
            "preprocess": 0.0,
            "dpu": 0.0,
            "postprocess": 0.0,
            "total": 0.0,
        }

    def update(
        self,
        boxes,
        scores,
        classes,
        source_sequence,
        source_timestamp,
        completion_timestamp,
        timing,
    ):
        with self.lock:
            self.boxes = np.asarray(
                boxes,
                dtype=np.float32,
            ).copy()

            self.scores = np.asarray(
                scores,
                dtype=np.float32,
            ).copy()

            self.classes = np.asarray(
                classes,
                dtype=np.int32,
            ).copy()

            self.source_sequence = int(
                source_sequence
            )

            self.source_timestamp = float(
                source_timestamp
            )

            self.completion_timestamp = float(
                completion_timestamp
            )

            self.timing = dict(timing)
            self.inference_count += 1

    def get(self):
        with self.lock:
            return (
                self.boxes.copy(),
                self.scores.copy(),
                self.classes.copy(),
                self.source_sequence,
                self.source_timestamp,
                self.completion_timestamp,
                dict(self.timing),
                self.inference_count,
            )


# ============================================================
# 兼容新旧 infer_ofa_yolo.py 返回格式
# ============================================================

def normalize_timing(
    timing_result,
    measured_total,
):
    """
    新版 infer_frame() 返回 timing 字典：

      {
          "preprocess": ...,
          "dpu": ...,
          "postprocess": ...,
          "total": ...
      }

    旧版 infer_frame() 可能只返回 dpu_time 浮点数。
    """

    if isinstance(timing_result, dict):
        return {
            "preprocess": float(
                timing_result.get(
                    "preprocess",
                    0.0,
                )
            ),

            "dpu": float(
                timing_result.get(
                    "dpu",
                    0.0,
                )
            ),

            "postprocess": float(
                timing_result.get(
                    "postprocess",
                    0.0,
                )
            ),

            "total": float(
                timing_result.get(
                    "total",
                    measured_total,
                )
            ),
        }

    dpu_time = float(timing_result)

    return {
        "preprocess": 0.0,
        "dpu": dpu_time,
        "postprocess": max(
            0.0,
            measured_total - dpu_time,
        ),
        "total": measured_total,
    }


# ============================================================
# 打开 USB 摄像头
# ============================================================

def open_camera(
    device,
    width,
    height,
    fps,
):
    """
    使用 V4L2 打开 USB 摄像头，并设置为 MJPEG。
    """

    print(
        "\nOpening USB camera /dev/video{}...".format(
            device
        )
    )

    capture = cv2.VideoCapture(
        device,
        cv2.CAP_V4L2,
    )

    if not capture.isOpened():
        raise RuntimeError(
            "Cannot open /dev/video{}".format(
                device
            )
        )

    capture.set(
        cv2.CAP_PROP_FOURCC,
        cv2.VideoWriter_fourcc(*"MJPG"),
    )

    capture.set(
        cv2.CAP_PROP_FRAME_WIDTH,
        width,
    )

    capture.set(
        cv2.CAP_PROP_FRAME_HEIGHT,
        height,
    )

    capture.set(
        cv2.CAP_PROP_FPS,
        fps,
    )

    # 尽可能减小摄像头缓冲带来的延迟。
    capture.set(
        cv2.CAP_PROP_BUFFERSIZE,
        1,
    )

    actual_width = int(
        capture.get(
            cv2.CAP_PROP_FRAME_WIDTH
        )
    )

    actual_height = int(
        capture.get(
            cv2.CAP_PROP_FRAME_HEIGHT
        )
    )

    actual_fps = float(
        capture.get(
            cv2.CAP_PROP_FPS
        )
    )

    fourcc_value = int(
        capture.get(
            cv2.CAP_PROP_FOURCC
        )
    )

    actual_fourcc = "".join(
        chr(
            (
                fourcc_value
                >> (8 * index)
            )
            & 0xFF
        )
        for index in range(4)
    )

    print(
        "Camera opened: {}x{} @ {:.1f} FPS, format={}".format(
            actual_width,
            actual_height,
            actual_fps,
            actual_fourcc,
        )
    )

    return capture


# ============================================================
# 摄像头采集线程
# ============================================================

def capture_worker(
    capture,
    latest_frame,
    stop_event,
):
    """
    独立摄像头采集线程。

    始终读取摄像头并覆盖旧帧，只保存最新一帧。
    """

    previous_timestamp = time.perf_counter()

    smooth_capture_fps = 0.0
    consecutive_failures = 0

    while not stop_event.is_set():
        ok, frame = capture.read()

        timestamp = time.perf_counter()

        if not ok or frame is None:
            consecutive_failures += 1

            print(
                "Camera capture failed ({}/30)".format(
                    consecutive_failures
                )
            )

            if consecutive_failures >= 30:
                latest_frame.set_failed()
                stop_event.set()
                break

            time.sleep(0.02)
            continue

        consecutive_failures = 0

        elapsed = (
            timestamp
            - previous_timestamp
        )

        previous_timestamp = timestamp

        if elapsed > 0.0:
            current_fps = 1.0 / elapsed

            if smooth_capture_fps == 0.0:
                smooth_capture_fps = current_fps
            else:
                smooth_capture_fps = (
                    smooth_capture_fps * 0.90
                    + current_fps * 0.10
                )

        latest_frame.update(
            frame,
            timestamp,
            smooth_capture_fps,
        )


# ============================================================
# DPU 推理线程
# ============================================================

def inference_worker(
    latest_frame,
    latest_detection,
    stop_event,
    runner,
    input_tensor,
    output_tensors,
    output_buffers,
):
    """
    独立 DPU 推理线程。

    每次只处理当前最新帧。推理期间产生的旧帧不会排队。
    """

    last_processed_sequence = -1

    while not stop_event.is_set():
        (
            frame,
            sequence,
            frame_timestamp,
            _,
        ) = latest_frame.get(
            copy_frame=True
        )

        if frame is None:
            time.sleep(0.002)
            continue

        if sequence == last_processed_sequence:
            time.sleep(0.001)
            continue

        last_processed_sequence = sequence

        try:
            inference_start = (
                time.perf_counter()
            )

            (
                boxes,
                scores,
                classes,
                timing_result,
            ) = yolo.infer_frame(
                frame,
                runner,
                input_tensor,
                output_tensors,
                output_buffers,
            )

            completion_timestamp = (
                time.perf_counter()
            )

            measured_total = (
                completion_timestamp
                - inference_start
            )

            timing = normalize_timing(
                timing_result,
                measured_total,
            )

            latest_detection.update(
                boxes=boxes,
                scores=scores,
                classes=classes,
                source_sequence=sequence,
                source_timestamp=frame_timestamp,
                completion_timestamp=(
                    completion_timestamp
                ),
                timing=timing,
            )

        except Exception as error:
            print(
                "Inference worker error:",
                repr(error),
            )

            stop_event.set()
            break


# ============================================================
# 颜色
# ============================================================

def color_for_object(
    class_id,
    track_id,
    color_mode="class",
):
    """
    返回 OpenCV BGR 颜色。

    color_mode="class":
      颜色只由类别决定。
      同一类别永久使用同一种颜色，即使 Track ID 变化也不会变色。

    color_mode="track":
      颜色由类别和 Track ID 共同决定。
      不同轨迹使用不同颜色，但 ID 变化时颜色可能变化。
    """

    class_id = int(class_id)
    track_id = int(track_id)

    if color_mode == "class":
        seed = class_id + 1

    elif color_mode == "track":
        seed = (
            class_id * 97
            + track_id * 53
            + 1
        )

    else:
        raise ValueError(
            "Unsupported color mode: {}".format(
                color_mode
            )
        )

    blue = int(
        (seed * 37 + 80) % 255
    )

    green = int(
        (seed * 17 + 160) % 255
    )

    red = int(
        (seed * 29 + 220) % 255
    )

    # 避免生成过暗的颜色。
    blue = max(50, blue)
    green = max(50, green)
    red = max(50, red)

    return blue, green, red


# ============================================================
# 绘制检测框和 Track ID
# ============================================================

def draw_tracks(
    frame,
    boxes,
    scores,
    classes,
    track_ids,
    color_mode="class",
):
    """
    在摄像头画面中绘制检测框、类别、Track ID 和置信度。
    """

    valid_count = 0

    image_height, image_width = (
        frame.shape[:2]
    )

    for (
        box,
        score,
        class_id,
        track_id,
    ) in zip(
        boxes,
        scores,
        classes,
        track_ids,
    ):
        x1, y1, x2, y2 = (
            box.astype(np.int32)
        )

        x1 = int(np.clip(
            x1,
            0,
            image_width - 1,
        ))

        y1 = int(np.clip(
            y1,
            0,
            image_height - 1,
        ))

        x2 = int(np.clip(
            x2,
            0,
            image_width - 1,
        ))

        y2 = int(np.clip(
            y2,
            0,
            image_height - 1,
        ))

        if x2 <= x1 or y2 <= y1:
            continue

        class_id = int(class_id)
        track_id = int(track_id)
        score = float(score)

        if (
            0 <= class_id
            < len(yolo.CLASS_NAMES)
        ):
            class_name = (
                yolo.CLASS_NAMES[class_id]
            )
        else:
            class_name = (
                "class_{}".format(
                    class_id
                )
            )

        color = color_for_object(
            class_id,
            track_id,
            color_mode=color_mode,
        )

        cv2.rectangle(
            frame,
            (x1, y1),
            (x2, y2),
            color,
            2,
        )

        label = "{} #{} {:.2f}".format(
            class_name,
            track_id,
            score,
        )

        (
            (text_width, text_height),
            baseline,
        ) = cv2.getTextSize(
            label,
            cv2.FONT_HERSHEY_SIMPLEX,
            0.48,
            1,
        )

        label_top = max(
            0,
            y1
            - text_height
            - baseline
            - 4,
        )

        label_right = min(
            image_width - 1,
            x1 + text_width + 4,
        )

        cv2.rectangle(
            frame,
            (x1, label_top),
            (label_right, y1),
            color,
            -1,
        )

        cv2.putText(
            frame,
            label,
            (
                x1 + 2,
                max(
                    text_height + 1,
                    y1 - baseline - 2,
                ),
            ),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.48,
            (255, 255, 255),
            1,
            cv2.LINE_AA,
        )

        valid_count += 1

    return valid_count


# ============================================================
# 绘制状态栏
# ============================================================

def draw_status(
    frame,
    capture_fps,
    display_fps,
    timing,
    object_count,
    frame_lag,
    result_age,
    color_mode,
):
    """
    在画面顶部绘制性能信息。
    """

    dpu_fps = (
        1.0 / timing["dpu"]
        if timing["dpu"] > 0.0
        else 0.0
    )

    detection_fps = (
        1.0 / timing["total"]
        if timing["total"] > 0.0
        else 0.0
    )

    status_line_1 = (
        "Capture {:.1f} | Display {:.1f} | "
        "Detect {:.1f} | DPU {:.1f} FPS"
    ).format(
        capture_fps,
        display_fps,
        detection_fps,
        dpu_fps,
    )

    status_line_2 = (
        "Pre {:.1f} | DPU {:.1f} | Post {:.1f} ms | "
        "Tracks {} | Lag {} | Age {:.0f} ms | Color {}"
    ).format(
        timing["preprocess"] * 1000.0,
        timing["dpu"] * 1000.0,
        timing["postprocess"] * 1000.0,
        object_count,
        max(0, int(frame_lag)),
        max(0.0, result_age * 1000.0),
        color_mode,
    )

    cv2.rectangle(
        frame,
        (0, 0),
        (frame.shape[1], 70),
        (0, 0, 0),
        -1,
    )

    cv2.putText(
        frame,
        status_line_1,
        (8, 27),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.45,
        (0, 255, 0),
        1,
        cv2.LINE_AA,
    )

    cv2.putText(
        frame,
        status_line_2,
        (8, 55),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.37,
        (0, 255, 255),
        1,
        cv2.LINE_AA,
    )


# ============================================================
# 将画面适配到屏幕尺寸
# ============================================================

def prepare_display_frame(
    frame,
    windowed,
    screen_width,
    screen_height,
):
    """
    窗口模式：
      保持原始摄像头画面尺寸。

    全屏模式：
      显式缩放到屏幕分辨率。

    对当前系统：
      640x480 -> 1024x768

    两者都是 4:3，因此不会产生宽高比形变。
    """

    if windowed:
        return frame

    return cv2.resize(
        frame,
        (
            int(screen_width),
            int(screen_height),
        ),
        interpolation=cv2.INTER_LINEAR,
    )


# ============================================================
# 主程序
# ============================================================

def main():
    parser = argparse.ArgumentParser(
        description=(
            "KV260 OFA-YOLO with "
            "SORT-like tracking"
        )
    )

    parser.add_argument(
        "--bitfile",
        default=str(DEFAULT_BITFILE),
        help="Path to dpu.bit",
    )

    parser.add_argument(
        "--xmodel",
        default=str(DEFAULT_XMODEL),
        help="Path to compiled OFA-YOLO xmodel",
    )

    parser.add_argument(
        "--camera",
        type=int,
        default=0,
        help="Camera device number",
    )

    parser.add_argument(
        "--width",
        type=int,
        default=640,
        help="Camera capture width",
    )

    parser.add_argument(
        "--height",
        type=int,
        default=480,
        help="Camera capture height",
    )

    parser.add_argument(
        "--fps",
        type=int,
        default=30,
        help="Requested camera FPS",
    )

    parser.add_argument(
        "--display-fps",
        type=float,
        default=30.0,
        help="Maximum display refresh FPS",
    )

    parser.add_argument(
        "--screen-width",
        type=int,
        default=1024,
        help="Fullscreen display width",
    )

    parser.add_argument(
        "--screen-height",
        type=int,
        default=768,
        help="Fullscreen display height",
    )

    parser.add_argument(
        "--windowed",
        action="store_true",
        help="Use normal window instead of fullscreen",
    )

    parser.add_argument(
        "--no-display",
        action="store_true",
        help="Run without cv2.imshow",
    )

    parser.add_argument(
        "--no-tracker",
        action="store_true",
        help="Disable SORT-like tracking",
    )

    parser.add_argument(
        "--color-mode",
        choices=[
            "class",
            "track",
        ],
        default="class",
        help=(
            "'class': fixed color per class; "
            "'track': fixed color per Track ID"
        ),
    )

    args = parser.parse_args()

    bitfile_path = Path(
        args.bitfile
    )

    xmodel_path = Path(
        args.xmodel
    )

    if not bitfile_path.is_file():
        raise FileNotFoundError(
            "Missing bitfile: {}".format(
                bitfile_path
            )
        )

    if not xmodel_path.is_file():
        raise FileNotFoundError(
            "Missing xmodel: {}".format(
                xmodel_path
            )
        )

    # ========================================================
    # 加载 DPU
    # ========================================================

    print("Loading B4096 DPU overlay:")
    print(" ", bitfile_path)

    overlay = DpuOverlay(
        str(bitfile_path)
    )

    print("DPU overlay loaded")

    print("\nLoading OFA-YOLO XModel:")
    print(" ", xmodel_path)

    overlay.load_model(
        str(xmodel_path)
    )

    print("XModel loaded")

    runner = overlay.runner

    input_tensors = (
        runner.get_input_tensors()
    )

    output_tensors = (
        runner.get_output_tensors()
    )

    yolo.validate_model_tensors(
        input_tensors,
        output_tensors,
    )

    yolo.print_tensor_information(
        input_tensors,
        output_tensors,
    )

    input_tensor = input_tensors[0]

    output_buffers = (
        yolo.allocate_output_buffers(
            output_tensors
        )
    )

    # ========================================================
    # 打开摄像头
    # ========================================================

    capture = open_camera(
        args.camera,
        args.width,
        args.height,
        args.fps,
    )

    ok, warmup_frame = capture.read()

    if not ok or warmup_frame is None:
        capture.release()

        raise RuntimeError(
            "Cannot capture warm-up frame"
        )

    print("\nWarming up DPU...")

    yolo.infer_frame(
        warmup_frame,
        runner,
        input_tensor,
        output_tensors,
        output_buffers,
    )

    print("DPU warm-up completed")

    # ========================================================
    # 共享数据和跟踪器
    # ========================================================

    stop_event = threading.Event()

    latest_frame = LatestFrame()
    latest_detection = LatestDetection()

    latest_frame.update(
        warmup_frame,
        time.perf_counter(),
        0.0,
    )

    tracker = SortLikeTracker(
        # 快速移动目标可能只有较低的相邻帧 IoU。
        iou_threshold=0.15,

        # 提高新轨迹创建阈值，减少重复轨迹。
        new_track_threshold=0.45,

        # 轨迹在内部最多保留 0.30 秒。
        max_age_seconds=0.30,

        # 没有新检测确认时，最多继续显示 0.12 秒。
        max_output_age_seconds=0.12,

        # 至少连续确认两次才显示。
        min_hits=2,

        # 更快地跟随最新检测框。
        position_alpha=0.85,

        # 更快更新速度估计。
        velocity_alpha=0.50,
    )

    last_tracker_inference_count = -1

    # ========================================================
    # 启动采集和推理线程
    # ========================================================

    capture_thread = threading.Thread(
        target=capture_worker,
        args=(
            capture,
            latest_frame,
            stop_event,
        ),
        name="camera-capture",
        daemon=True,
    )

    inference_thread = threading.Thread(
        target=inference_worker,
        args=(
            latest_frame,
            latest_detection,
            stop_event,
            runner,
            input_tensor,
            output_tensors,
            output_buffers,
        ),
        name="dpu-inference",
        daemon=False,
    )

    capture_thread.start()
    inference_thread.start()

    # ========================================================
    # 创建显示窗口
    # ========================================================

    use_display = not args.no_display
    use_tracker = not args.no_tracker

    if use_display:
        cv2.namedWindow(
            WINDOW_NAME,
            cv2.WINDOW_NORMAL,
        )

        if args.windowed:
            cv2.resizeWindow(
                WINDOW_NAME,
                args.width,
                args.height,
            )

            print(
                "\nWindow mode: {}x{}".format(
                    args.width,
                    args.height,
                )
            )

        else:
            # 将窗口移到屏幕左上角。
            cv2.moveWindow(
                WINDOW_NAME,
                0,
                0,
            )

            # 先设置窗口大小，再请求全屏。
            cv2.resizeWindow(
                WINDOW_NAME,
                args.screen_width,
                args.screen_height,
            )

            cv2.setWindowProperty(
                WINDOW_NAME,
                cv2.WND_PROP_FULLSCREEN,
                cv2.WINDOW_FULLSCREEN,
            )

            print(
                "\nFullscreen mode: {}x{}".format(
                    args.screen_width,
                    args.screen_height,
                )
            )

        print("\nControls:")
        print("  q / ESC : exit")
        print("  s       : save current 640x480 frame")
        print("  r       : reset tracker")

    else:
        print("\nRunning without display")
        print("Press Ctrl+C to stop")

    # ========================================================
    # 限制显示刷新率
    # ========================================================

    display_fps_limit = max(
        1.0,
        float(args.display_fps),
    )

    display_interval = (
        1.0 / display_fps_limit
    )

    next_display_time = (
        time.perf_counter()
    )

    previous_display_timestamp = (
        time.perf_counter()
    )

    smooth_display_fps = 0.0

    previous_log_timestamp = (
        time.perf_counter()
    )

    saved_index = 0

    try:
        while not stop_event.is_set():
            current_timestamp = (
                time.perf_counter()
            )

            sleep_time = (
                next_display_time
                - current_timestamp
            )

            if sleep_time > 0.0:
                time.sleep(sleep_time)

            current_timestamp = (
                time.perf_counter()
            )

            next_display_time = (
                current_timestamp
                + display_interval
            )

            (
                frame,
                frame_sequence,
                _,
                capture_fps,
            ) = latest_frame.get(
                copy_frame=True
            )

            if frame is None:
                time.sleep(0.002)
                continue

            (
                detection_boxes,
                detection_scores,
                detection_classes,
                detection_sequence,
                _,
                completion_timestamp,
                timing,
                inference_count,
            ) = latest_detection.get()

            tracker_timestamp = (
                time.perf_counter()
            )

            # =================================================
            # 跟踪
            # =================================================

            if use_tracker:
                if (
                    inference_count
                    != last_tracker_inference_count
                ):
                    (
                        display_boxes,
                        display_scores,
                        display_classes,
                        track_ids,
                    ) = tracker.update(
                        detection_boxes,
                        detection_scores,
                        detection_classes,
                        timestamp=tracker_timestamp,
                    )

                    last_tracker_inference_count = (
                        inference_count
                    )

                else:
                    (
                        display_boxes,
                        display_scores,
                        display_classes,
                        track_ids,
                    ) = tracker.predict(
                        timestamp=tracker_timestamp
                    )

            else:
                display_boxes = detection_boxes
                display_scores = detection_scores
                display_classes = detection_classes

                track_ids = np.arange(
                    1,
                    len(display_boxes) + 1,
                    dtype=np.int32,
                )

            # =================================================
            # 绘制检测框
            # =================================================

            object_count = draw_tracks(
                frame,
                display_boxes,
                display_scores,
                display_classes,
                track_ids,
                color_mode=args.color_mode,
            )

            # =================================================
            # 计算显示 FPS
            # =================================================

            display_elapsed = (
                current_timestamp
                - previous_display_timestamp
            )

            previous_display_timestamp = (
                current_timestamp
            )

            if display_elapsed > 0.0:
                current_display_fps = (
                    1.0 / display_elapsed
                )

                if smooth_display_fps == 0.0:
                    smooth_display_fps = (
                        current_display_fps
                    )
                else:
                    smooth_display_fps = (
                        smooth_display_fps * 0.90
                        + current_display_fps * 0.10
                    )

            frame_lag = (
                frame_sequence
                - detection_sequence
                if detection_sequence >= 0
                else 0
            )

            result_age = (
                current_timestamp
                - completion_timestamp
                if completion_timestamp > 0.0
                else 0.0
            )

            draw_status(
                frame=frame,
                capture_fps=capture_fps,
                display_fps=smooth_display_fps,
                timing=timing,
                object_count=object_count,
                frame_lag=frame_lag,
                result_age=result_age,
                color_mode=args.color_mode,
            )

            # =================================================
            # 显示
            # =================================================

            if use_display:
                # 全屏模式下显式把 640x480 放大到屏幕分辨率。
                display_frame = prepare_display_frame(
                    frame=frame,
                    windowed=args.windowed,
                    screen_width=args.screen_width,
                    screen_height=args.screen_height,
                )

                cv2.imshow(
                    WINDOW_NAME,
                    display_frame,
                )

                key = (
                    cv2.waitKey(1)
                    & 0xFF
                )

                if (
                    key == ord("q")
                    or key == 27
                ):
                    stop_event.set()
                    break

                if key == ord("s"):
                    saved_index += 1

                    save_path = (
                        BASE_DIR
                        / "camera_result_{:04d}.jpg".format(
                            saved_index
                        )
                    )

                    # 保存原始 640x480 检测画面，而不是放大后的画面。
                    if cv2.imwrite(
                        str(save_path),
                        frame,
                    ):
                        print(
                            "Saved:",
                            save_path,
                        )
                    else:
                        print(
                            "Cannot save:",
                            save_path,
                        )

                if key == ord("r"):
                    tracker.reset()
                    last_tracker_inference_count = -1

                    print(
                        "Tracker reset"
                    )

            # =================================================
            # 无窗口日志
            # =================================================

            else:
                if (
                    current_timestamp
                    - previous_log_timestamp
                    >= 1.0
                ):
                    previous_log_timestamp = (
                        current_timestamp
                    )

                    dpu_fps = (
                        1.0 / timing["dpu"]
                        if timing["dpu"] > 0.0
                        else 0.0
                    )

                    detection_fps = (
                        1.0 / timing["total"]
                        if timing["total"] > 0.0
                        else 0.0
                    )

                    print(
                        "Capture={:.1f} "
                        "Display={:.1f} "
                        "Detect={:.1f} "
                        "DPU={:.1f} FPS "
                        "Pre={:.1f} "
                        "DPU={:.1f} "
                        "Post={:.1f} ms "
                        "Tracks={} "
                        "Lag={} "
                        "Age={:.0f} ms "
                        "Color={}".format(
                            capture_fps,
                            smooth_display_fps,
                            detection_fps,
                            dpu_fps,
                            timing["preprocess"]
                            * 1000.0,
                            timing["dpu"]
                            * 1000.0,
                            timing["postprocess"]
                            * 1000.0,
                            object_count,
                            frame_lag,
                            result_age
                            * 1000.0,
                            args.color_mode,
                        )
                    )

    except KeyboardInterrupt:
        print(
            "\nStop requested"
        )

        stop_event.set()

    finally:
        stop_event.set()

        # 等待当前 DPU 调用完成，避免中断 xclExecWait。
        inference_thread.join(
            timeout=5.0
        )

        capture.release()

        capture_thread.join(
            timeout=2.0
        )

        if use_display:
            cv2.destroyAllWindows()

        print(
            "Camera, tracker, DPU worker "
            "and display closed"
        )


if __name__ == "__main__":
    main()
