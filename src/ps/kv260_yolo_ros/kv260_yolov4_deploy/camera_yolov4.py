import time
import cv2
import numpy as np

from pynq_dpu import DpuOverlay
import infer_yolov4 as yolo


# ============================================================
# 硬件、模型和摄像头参数
# ============================================================

BITFILE = "/home/ubuntu/kv260_yolov4_deploy/overlay/dpu.bit"

XMODEL = (
    "/home/ubuntu/kv260_yolov4_deploy/compiled/"
    "yolov4_leaky_416_tf.xmodel"
)

CAMERA_DEVICE = 0
CAMERA_WIDTH = 640
CAMERA_HEIGHT = 480
CAMERA_FPS = 30

WINDOW_NAME = "KV260 YOLOv4 USB Camera"

# 当前显示器是 1024x768，摄像头是 640x480，都是 4:3
FULLSCREEN = True


def run_dpu_inference(
    frame,
    runner,
    input_tensor,
    output_tensors,
    output_buffers
):
    """
    对一帧摄像头图像执行：
      letterbox
      输入量化
      DPU 推理
      输出反量化
      YOLO 解码
      NMS
      坐标映射
    """
    original_h, original_w = frame.shape[:2]

    # 与单张图片推理一致的预处理
    image_rgb, scale, pad_x, pad_y = yolo.letterbox_image(
        frame,
        yolo.INPUT_W,
        yolo.INPUT_H
    )

    input_fix_point = input_tensor.get_attr("fix_point")

    input_buffer = yolo.quantize_input(
        image_rgb,
        input_fix_point
    )

    # 只测量 DPU execute_async + wait 时间
    start_time = time.time()

    job_id = runner.execute_async(
        [input_buffer],
        output_buffers
    )
    runner.wait(job_id)

    dpu_time = time.time() - start_time

    all_boxes = []
    all_scores = []
    all_classes = []

    # 处理三个尺度的 YOLO 输出
    for index, tensor in enumerate(output_tensors):
        dims = tuple(tensor.dims)
        grid_h = dims[1]

        if grid_h not in yolo.ANCHORS:
            raise RuntimeError(
                "No anchors configured for grid {}".format(grid_h)
            )

        output_fix_point = tensor.get_attr("fix_point")

        # 反量化：real = int8 * 2^(-fix_point)
        output_float = (
            output_buffers[index].astype(np.float32)
            * (2.0 ** (-output_fix_point))
        )

        boxes, scores, classes = yolo.decode_yolo_output(
            output_float,
            yolo.ANCHORS[grid_h],
            yolo.CONF_THRESHOLD
        )

        all_boxes.append(boxes)
        all_scores.append(scores)
        all_classes.append(classes)

    boxes = np.concatenate(all_boxes, axis=0)
    scores = np.concatenate(all_scores, axis=0)
    classes = np.concatenate(all_classes, axis=0)

    # 分类别执行 NMS
    if len(boxes) > 0:
        selected = yolo.classwise_nms(
            boxes,
            scores,
            classes,
            yolo.NMS_THRESHOLD
        )

        boxes = boxes[selected]
        scores = scores[selected]
        classes = classes[selected]

        # 映射回摄像头原始分辨率
        boxes = yolo.map_boxes_to_original(
            boxes,
            scale,
            pad_x,
            pad_y,
            original_w,
            original_h
        )

    return boxes, scores, classes, dpu_time


def draw_detections(frame, boxes, scores, classes):
    """
    在摄像头图像上绘制检测框、类别和置信度。
    """
    valid_count = 0

    for box, score, class_id in zip(
        boxes,
        scores,
        classes
    ):
        x1, y1, x2, y2 = box.astype(np.int32)

        if x2 <= x1 or y2 <= y1:
            continue

        class_id = int(class_id)
        score = float(score)

        if 0 <= class_id < len(yolo.CLASS_NAMES):
            class_name = yolo.CLASS_NAMES[class_id]
        else:
            class_name = "class_{}".format(class_id)

        color = yolo.color_for_class(class_id)

        cv2.rectangle(
            frame,
            (x1, y1),
            (x2, y2),
            color,
            2
        )

        label = "{} {:.2f}".format(
            class_name,
            score
        )

        (text_w, text_h), baseline = cv2.getTextSize(
            label,
            cv2.FONT_HERSHEY_SIMPLEX,
            0.55,
            1
        )

        label_top = max(
            0,
            y1 - text_h - baseline - 4
        )

        cv2.rectangle(
            frame,
            (x1, label_top),
            (x1 + text_w + 4, y1),
            color,
            -1
        )

        cv2.putText(
            frame,
            label,
            (x1 + 2, max(text_h + 1, y1 - baseline - 2)),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.55,
            (255, 255, 255),
            1,
            cv2.LINE_AA
        )

        valid_count += 1

    return valid_count


def main():
    # ========================================================
    # 加载你的 FPGA DPU Overlay
    # ========================================================

    print("Loading custom DPU Overlay:")
    print(BITFILE)

    overlay = DpuOverlay(BITFILE)

    print("DPU Overlay loaded")

    print("Available IPs:")
    for name in overlay.ip_dict:
        print("  ", name)

    # ========================================================
    # 加载针对该 DPU arch.json 编译的 XModel
    # ========================================================

    print("\nLoading XModel:")
    print(XMODEL)

    overlay.load_model(XMODEL)

    print("XModel loaded")

    runner = overlay.runner

    input_tensors = runner.get_input_tensors()
    output_tensors = runner.get_output_tensors()

    if len(input_tensors) != 1:
        raise RuntimeError(
            "Expected one input tensor, got {}".format(
                len(input_tensors)
            )
        )

    input_tensor = input_tensors[0]

    print("\nInput tensor:")
    print("  name:", input_tensor.name)
    print("  dims:", input_tensor.dims)
    print("  fix_point:", input_tensor.get_attr("fix_point"))

    print("\nOutput tensors:")
    for tensor in output_tensors:
        print(
            "  ",
            tensor.name,
            tensor.dims,
            "fix_point=",
            tensor.get_attr("fix_point")
        )

    # 输出缓冲区只分配一次，循环中反复使用
    output_buffers = [
        np.empty(
            tuple(tensor.dims),
            dtype=np.int8
        )
        for tensor in output_tensors
    ]

    # ========================================================
    # 打开 USB 摄像头
    # ========================================================

    print("\nOpening USB camera /dev/video{}...".format(
        CAMERA_DEVICE
    ))

    cap = cv2.VideoCapture(
        CAMERA_DEVICE,
        cv2.CAP_V4L2
    )

    if not cap.isOpened():
        raise RuntimeError(
            "Cannot open /dev/video{}".format(
                CAMERA_DEVICE
            )
        )

    # 使用 MJPEG，降低 USB 带宽
    cap.set(
        cv2.CAP_PROP_FOURCC,
        cv2.VideoWriter_fourcc(*"MJPG")
    )
    cap.set(
        cv2.CAP_PROP_FRAME_WIDTH,
        CAMERA_WIDTH
    )
    cap.set(
        cv2.CAP_PROP_FRAME_HEIGHT,
        CAMERA_HEIGHT
    )
    cap.set(
        cv2.CAP_PROP_FPS,
        CAMERA_FPS
    )
    cap.set(
        cv2.CAP_PROP_BUFFERSIZE,
        1
    )

    actual_width = int(
        cap.get(cv2.CAP_PROP_FRAME_WIDTH)
    )
    actual_height = int(
        cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
    )
    actual_fps = cap.get(
        cv2.CAP_PROP_FPS
    )

    print(
        "Camera opened: {}x{} @ {:.1f} FPS".format(
            actual_width,
            actual_height,
            actual_fps
        )
    )

    # ========================================================
    # 创建显示窗口
    # ========================================================

    cv2.namedWindow(
        WINDOW_NAME,
        cv2.WINDOW_NORMAL
    )

    if FULLSCREEN:
        cv2.setWindowProperty(
            WINDOW_NAME,
            cv2.WND_PROP_FULLSCREEN,
            cv2.WINDOW_FULLSCREEN
        )
    else:
        cv2.resizeWindow(
            WINDOW_NAME,
            CAMERA_WIDTH,
            CAMERA_HEIGHT
        )

    print("\nControls:")
    print("  q / ESC : exit")
    print("  s       : save current frame")
    print("  Ctrl+C  : exit from serial terminal")

    last_frame_time = time.time()
    smooth_display_fps = 0.0
    saved_index = 0

    try:
        while True:
            ok, frame = cap.read()

            if not ok or frame is None:
                print("Failed to capture camera frame")
                break

            boxes, scores, classes, dpu_time = run_dpu_inference(
                frame,
                runner,
                input_tensor,
                output_tensors,
                output_buffers
            )

            object_count = draw_detections(
                frame,
                boxes,
                scores,
                classes
            )

            current_time = time.time()
            frame_time = current_time - last_frame_time
            last_frame_time = current_time

            if frame_time > 0:
                current_display_fps = 1.0 / frame_time

                if smooth_display_fps == 0.0:
                    smooth_display_fps = current_display_fps
                else:
                    smooth_display_fps = (
                        smooth_display_fps * 0.9
                        + current_display_fps * 0.1
                    )

            dpu_fps = (
                1.0 / dpu_time
                if dpu_time > 0
                else 0.0
            )

            status = (
                "DPU {:.1f} FPS | Display {:.1f} FPS | Objects {}"
            ).format(
                dpu_fps,
                smooth_display_fps,
                object_count
            )

            # 状态文字加黑色底框，提高可读性
            cv2.rectangle(
                frame,
                (0, 0),
                (frame.shape[1], 42),
                (0, 0, 0),
                -1
            )

            cv2.putText(
                frame,
                status,
                (10, 28),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.55,
                (0, 255, 0),
                2,
                cv2.LINE_AA
            )

            cv2.imshow(
                WINDOW_NAME,
                frame
            )

            key = cv2.waitKey(1) & 0xFF

            if key == ord("q") or key == 27:
                break

            if key == ord("s"):
                saved_index += 1

                save_path = (
                    "/home/ubuntu/kv260_yolov4_deploy/"
                    "camera_result_{:04d}.jpg"
                ).format(saved_index)

                if cv2.imwrite(save_path, frame):
                    print("Saved:", save_path)
                else:
                    print("Failed to save:", save_path)

    except KeyboardInterrupt:
        print("\nInterrupted from terminal")

    finally:
        cap.release()
        cv2.destroyAllWindows()
        print("Camera and display closed")


if __name__ == "__main__":
    main()
