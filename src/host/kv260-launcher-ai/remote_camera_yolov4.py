#!/usr/bin/env python3
"""ROS2 Astra RGB-D + KV260 DPU YOLOv4 desktop application.

The existing desktop launcher still invokes this file.  The USB V4L camera
input has been replaced by the bundled OpenNI2 Astra ROS2 publisher.
"""

import json
import os
import signal
import subprocess
import sys
import threading
import time

# Preserve the existing fixed sudo entry point. Dispatch only fixed B3136
# commands; never accept an executable, path or shell expression from the GUI.
if os.environ.get('KV260_B3136_ACTION') in ('run', 'stop', 'test'):
    _action = os.environ['KV260_B3136_ACTION']
    if _action == 'stop':
        _target = '/home/ubuntu/kv260_B3136/vision_hls.py'
        for _entry in os.listdir('/proc'):
            if not _entry.isdigit():
                continue
            try:
                with open('/proc/' + _entry + '/cmdline', 'rb') as _stream:
                    _args = _stream.read().split(b'\0')
                if len(_args) > 1 and _args[1].decode() == _target:
                    os.kill(int(_entry), signal.SIGINT)
            except (OSError, UnicodeError):
                pass
        raise SystemExit(0)
    _command = ['/bin/bash', '/home/ubuntu/kv260_B3136/run_vision.sh', '--headless',
                '--control-dir', '/run/user/1000/kv260-b3136-ui']
    if _action == 'test':
        _command += ['--self-test']
    os.execv('/bin/bash', _command)

# sudo may sanitize ROS2/PYNQ environment variables. The dynamic loader reads
# LD_LIBRARY_PATH before Python starts, so set it and re-exec this same fixed
# program once before importing rclpy/cv_bridge. This keeps the sudoers rule
# narrow while making ROS2 C extensions available to the privileged process.
_runtime_library_paths = (
    "/opt/ros/humble/lib",
    "/home/ubuntu/kv260_astra_ws/install/astra_openni2/lib",
)
_existing_library_path = os.environ.get("LD_LIBRARY_PATH", "")
_library_path_entries = [
    path for path in _existing_library_path.split(":") if path
]
if any(path not in _library_path_entries for path in _runtime_library_paths):
    _reexec_environment = os.environ.copy()
    _reexec_environment["LD_LIBRARY_PATH"] = ":".join(
        path
        for path in (*_runtime_library_paths, *_library_path_entries)
        if path
    )
    os.execvpe(
        sys.executable,
        [sys.executable, *sys.argv],
        _reexec_environment,
    )

# sudo may sanitize PYTHONPATH even when the command is allowed with SETENV.
# Add the installed ROS2 Python locations before importing rclpy/cv_bridge so
# the privileged PYNQ interpreter uses the same ROS2 modules as the user shell.
for _ros_python_path in (
    "/opt/ros/humble/lib/python3.10/site-packages",
    "/opt/ros/humble/local/lib/python3.10/dist-packages",
):
    if _ros_python_path not in sys.path:
        sys.path.insert(0, _ros_python_path)

import cv2
import numpy as np

import rclpy
from cv_bridge import CvBridge
from rclpy.executors import MultiThreadedExecutor
from rclpy.node import Node
from rclpy.qos import QoSProfile, ReliabilityPolicy
from sensor_msgs.msg import Image
from std_msgs.msg import Header, String

# ============================================================
# KV260 DPU and ROS2/Astra paths
# ============================================================

BITFILE = "/home/ubuntu/kv260_yolov4_deploy/overlay/dpu.bit"
XMODEL = (
    "/home/ubuntu/kv260_yolov4_deploy/compiled/"
    "yolov4_leaky_416_tf.xmodel"
)

ASTRA_NODE = (
    "/home/ubuntu/kv260_astra_ws/install/astra_openni2/lib/"
    "astra_openni2/astra_openni2_node"
)
OPENNI2_REDIST = (
    "/home/ubuntu/x3plus-kv260-docker/context/src/astra_camera/"
    "include/openni2_redist/arm64"
)

# One physical Astra Pro exposes two interfaces: OpenNI2 depth (0403) and its
# own UVC RGB endpoint (0501). Use udev's persistent by-id index0 capture node
# so the volatile /dev/videoN number is not used by default.
CAMERA_WIDTH = int(os.environ.get("ASTRA_COLOR_WIDTH", "640"))
CAMERA_HEIGHT = int(os.environ.get("ASTRA_COLOR_HEIGHT", "480"))
CAMERA_FPS = int(os.environ.get("ASTRA_COLOR_FPS", "30"))
COLOR_DEVICE = os.environ.get(
    "ASTRA_COLOR_DEVICE",
    "/dev/v4l/by-id/usb-Astra_Pro_HD_Camera_Astra_Pro_HD_Camera-video-index0",
)
DEPTH_WIDTH = int(os.environ.get("ASTRA_DEPTH_WIDTH", "320"))
DEPTH_HEIGHT = int(os.environ.get("ASTRA_DEPTH_HEIGHT", "240"))
DEPTH_FPS = int(os.environ.get("ASTRA_DEPTH_FPS", "30"))
# An empty URI lets OpenNI2 select the currently enumerated Astra device.
# USB bus/device numbers are not stable across reconnects. Keep the
# environment override for installations with multiple OpenNI devices.
ASTRA_DEVICE_URI = os.environ.get("ASTRA_DEVICE_URI", "").strip()
ASTRA_DEPTH_START_RETRIES = max(
    1, int(os.environ.get("ASTRA_DEPTH_START_RETRIES", "5"))
)
ASTRA_DEPTH_START_DELAY = max(
    0.5, float(os.environ.get("ASTRA_DEPTH_START_DELAY", "2.0"))
)
ASTRA_DEPTH_READY_TIMEOUT = max(
    5.0, float(os.environ.get("ASTRA_DEPTH_READY_TIMEOUT", "15"))
)
CAMERA_TEST_SECONDS = int(os.environ.get("ASTRA_CAMERA_TEST_SECONDS", "30"))
MIN_COLOR_FPS = float(os.environ.get("ASTRA_MIN_COLOR_FPS", "20"))
MIN_DEPTH_FPS = float(os.environ.get("ASTRA_MIN_DEPTH_FPS", "20"))
WINDOW_NAME = "KV260 YOLOv4 Astra RGB-D"
FULLSCREEN = False
STOP_REQUEST_FILE = os.environ.get(
    "YOLO_STOP_REQUEST_FILE",
    "/run/user/1000/kv260-astra-rgbd-yolov4.stop",
)

DEPTH_TOPIC = "/camera/depth/image_raw"
DETECTION_TOPIC = "/yolov4/detections"
ANNOTATED_IMAGE_TOPIC = "/yolov4/image"

SYNC_TOLERANCE_MS = float(os.environ.get("YOLO_SYNC_TOLERANCE_MS", "50"))
DEPTH_MAX_MM = int(os.environ.get("YOLO_DEPTH_MAX_MM", "10000"))
DEPTH_ROI_MARGIN = float(os.environ.get("YOLO_DEPTH_ROI_MARGIN", "0.20"))
DEPTH_UNIT = "mm"


class StopRequested(Exception):
    """Raised when the unprivileged desktop launcher requests a clean exit."""


def stop_requested():
    return os.path.exists(STOP_REQUEST_FILE)


def clear_stop_request():
    try:
        os.unlink(STOP_REQUEST_FILE)
    except FileNotFoundError:
        pass
    except OSError as error:
        print("Warning: could not remove stop request: {}".format(error), flush=True)


def find_running_instances():
    """Return PIDs running this exact script, excluding this helper process."""
    script_path = os.path.realpath(__file__)
    own_pid = os.getpid()
    process_ids = []
    for entry in os.listdir("/proc"):
        if not entry.isdigit() or int(entry) == own_pid:
            continue
        try:
            with open("/proc/{}/cmdline".format(entry), "rb") as stream:
                arguments = [
                    item.decode("utf-8", "surrogateescape")
                    for item in stream.read().split(b"\0")
                    if item
                ]
            if len(arguments) >= 2 and os.path.realpath(arguments[1]) == script_path:
                process_ids.append(int(entry))
        except (FileNotFoundError, PermissionError, ProcessLookupError):
            continue
    return process_ids


def request_running_instances_stop():
    """Signal an older/root instance through the fixed sudo-authorized script."""
    process_ids = find_running_instances()
    if not process_ids:
        print("Astra RGB-D + DPU YOLOv4 is not running", flush=True)
        return 0

    for process_id in process_ids:
        try:
            os.kill(process_id, signal.SIGINT)
            print("Sent SIGINT to YOLO process {}".format(process_id), flush=True)
        except ProcessLookupError:
            pass

    deadline = time.monotonic() + 12.0
    while time.monotonic() < deadline:
        if not find_running_instances():
            print("YOLO process completed its cleanup", flush=True)
            return 0
        time.sleep(0.1)
    print("YOLO process did not stop within 12 seconds", file=sys.stderr, flush=True)
    return 1


HEADLESS = os.environ.get("KV260_YOLO_HEADLESS", "0") == "1"
TEST_FRAMES = int(os.environ.get("KV260_YOLO_TEST_FRAMES", "0"))
TEST_SECONDS = max(0.0, float(os.environ.get("KV260_YOLO_TEST_SECONDS", "0")))
RESULT_LOG = os.environ.get("YOLO_RESULT_LOG", "")

# Lightweight temporal stabilization.  This deliberately avoids a second
# neural network or a heavyweight tracker so the KV260 CPU remains focused on
# camera/display work while the DPU handles YOLO inference.
TRACK_IOU_THRESHOLD = float(os.environ.get("YOLO_TRACK_IOU_THRESHOLD", "0.35"))
TRACK_MAX_AGE_SEC = max(
    0.1, float(os.environ.get("YOLO_TRACK_MAX_AGE_MS", "500")) / 1000.0
)
TRACK_MAX_MISSES = max(0, int(os.environ.get("YOLO_TRACK_MAX_MISSES", "3")))
TRACK_BOX_ALPHA = min(
    1.0, max(0.0, float(os.environ.get("YOLO_TRACK_BOX_ALPHA", "0.65")))
)
TRACK_SCORE_ALPHA = min(
    1.0, max(0.0, float(os.environ.get("YOLO_TRACK_SCORE_ALPHA", "0.70")))
)
TRACK_MAX_PREDICT_SEC = min(
    TRACK_MAX_AGE_SEC,
    max(0.0, float(os.environ.get("YOLO_TRACK_MAX_PREDICT_MS", "200")) / 1000.0),
)
DEPTH_STALE_SEC = min(
    TRACK_MAX_AGE_SEC,
    max(0.05, float(os.environ.get("YOLO_DEPTH_STALE_MS", "300")) / 1000.0),
)


class AstraFrameSubscriber(Node):
    """Publish UVC RGB and keep the newest OpenNI2 depth frame."""

    def __init__(self):
        super().__init__("kv260_yolov4")
        self.bridge = CvBridge()
        self._lock = threading.Lock()
        self._depth_ready = threading.Condition(self._lock)
        self._latest_depth = None
        self._last_depth_stamp_ns = None
        self._last_processed_depth_stamp_ns = None
        self._depth_callback_count = 0
        self._depth_conversion_errors = 0
        self._color_frames = 0
        self._depth_frames_taken = 0
        self._sync_rejected = 0
        self._last_sync_ms = None
        self._max_sync_ms = 0.0
        image_qos = QoSProfile(
            depth=4,
            reliability=ReliabilityPolicy.BEST_EFFORT,
        )
        self.color_pub = self.create_publisher(
            Image, "/camera/color/image_raw", image_qos
        )
        depth_qos = QoSProfile(depth=4, reliability=ReliabilityPolicy.RELIABLE)
        self.depth_sub = self.create_subscription(
            Image,
            DEPTH_TOPIC,
            self._depth_callback,
            depth_qos,
        )
        self.detection_pub = self.create_publisher(
            String,
            DETECTION_TOPIC,
            10,
        )
        self.annotated_pub = self.create_publisher(
            Image, ANNOTATED_IMAGE_TOPIC, image_qos
        )

    @staticmethod
    def _stamp_ns(message):
        return (
            int(message.header.stamp.sec) * 1_000_000_000
            + int(message.header.stamp.nanosec)
        )

    def _depth_callback(self, message):
        with self._lock:
            stamp_ns = self._stamp_ns(message)
            # Keep the callback trivial: image decoding happens in the main
            # loop, so DDS delivery is never held up by NumPy/buffer work.
            self._latest_depth = (stamp_ns, message.header, message)
            self._last_depth_stamp_ns = stamp_ns
            self._depth_callback_count += 1
            self._depth_ready.notify_all()

    def wait_for_depth_frame(self, timeout):
        """Wait until the ROS executor has delivered at least one depth image."""
        deadline = time.monotonic() + timeout
        with self._depth_ready:
            while self._latest_depth is None:
                remaining = deadline - time.monotonic()
                if remaining <= 0:
                    return False
                self._depth_ready.wait(timeout=min(remaining, 0.2))
            return True

    def take_depth(self):
        with self._lock:
            record = self._latest_depth
            if record is None or record[0] == self._last_processed_depth_stamp_ns:
                return None
            self._last_processed_depth_stamp_ns = record[0]

        stamp_ns, header, message = record
        try:
            if message.encoding != "16UC1":
                raise ValueError(
                    "expected 16UC1 depth, got {}".format(message.encoding)
                )
            row_words = int(message.step) // np.dtype(np.uint16).itemsize
            expected_words = int(message.height) * row_words
            raw = np.frombuffer(message.data, dtype=np.uint16)
            if row_words < int(message.width) or raw.size < expected_words:
                raise ValueError(
                    "invalid depth buffer: width={} height={} step={} bytes={}".format(
                        message.width,
                        message.height,
                        message.step,
                        len(message.data),
                    )
                )
            depth = raw[:expected_words].reshape(int(message.height), row_words)
            depth = depth[:, :int(message.width)]
            if message.is_bigendian:
                depth = depth.byteswap()
        except Exception as error:
            self._depth_conversion_errors += 1
            self.get_logger().warning("Depth conversion failed: %s", error)
            return None
        self._depth_frames_taken += 1
        return stamp_ns, depth, header

    def record_color_frame(self):
        self._color_frames += 1

    def record_sync(self, sync_ms):
        self._last_sync_ms = sync_ms
        self._max_sync_ms = max(self._max_sync_ms, sync_ms)

    def record_sync_rejection(self):
        self._sync_rejected += 1

    def publish_color(self, image, stamp_ns):
        """Publish RGB only when a ROS consumer is present and return its header."""
        header = Header()
        header.stamp.sec = int(stamp_ns // 1_000_000_000)
        header.stamp.nanosec = int(stamp_ns % 1_000_000_000)
        header.frame_id = "camera_color_optical_frame"
        if self.color_pub.get_subscription_count() == 0:
            return header
        message = self.bridge.cv2_to_imgmsg(image, encoding="bgr8")
        message.header = header
        self.color_pub.publish(message)
        return header

    def publish_result(self, image, header, result):
        detection_message = String()
        detection_message.data = json.dumps(
            result,
            ensure_ascii=False,
            separators=(",", ":"),
        )
        self.detection_pub.publish(detection_message)

        if RESULT_LOG:
            with open(RESULT_LOG, "a", encoding="utf-8") as result_file:
                result_file.write(detection_message.data + "\n")

        if image is not None and self.annotated_pub.get_subscription_count() > 0:
            image_message = self.bridge.cv2_to_imgmsg(image, encoding="bgr8")
            image_message.header = header
            self.annotated_pub.publish(image_message)

    def has_annotated_image_subscriber(self):
        return self.annotated_pub.get_subscription_count() > 0


def stop_stale_probe_processes():
    """Remove only the temporary probe left by hardware diagnostics."""
    proc_root = "/proc"
    try:
        pids = os.listdir(proc_root)
    except OSError:
        return

    for pid_text in pids:
        if not pid_text.isdigit():
            continue
        cmdline_path = os.path.join(proc_root, pid_text, "cmdline")
        try:
            with open(cmdline_path, "rb") as cmdline_file:
                command = cmdline_file.read().replace(b"\0", b" ").strip()
            if command == b"/tmp/openni_probe":
                os.kill(int(pid_text), signal.SIGTERM)
                time.sleep(0.1)
                try:
                    os.kill(int(pid_text), signal.SIGKILL)
                except ProcessLookupError:
                    pass
        except (FileNotFoundError, PermissionError, ProcessLookupError, OSError):
            continue


def start_astra_node():
    if not os.path.isfile(ASTRA_NODE):
        raise RuntimeError("Astra ROS2 node is missing: {}".format(ASTRA_NODE))

    stop_stale_probe_processes()

    environment = os.environ.copy()
    environment["OPENNI2_REDIST"] = OPENNI2_REDIST
    environment["LD_LIBRARY_PATH"] = ":".join(
        value
        for value in (
            OPENNI2_REDIST,
            os.path.join(OPENNI2_REDIST, "OpenNI2", "Drivers"),
            environment.get("LD_LIBRARY_PATH", ""),
        )
        if value
    )

    # Keep the application and its ROS2 child in the same root process
    # context. Mixing a root Python DDS participant with an ubuntu child can
    # expose the endpoints in the graph while preventing data delivery on the
    # KV260's DDS transport. The retry loop handles transient OpenNI2 release
    # timing without changing the proven root launcher context.
    command = [ASTRA_NODE, "--ros-args"]
    if ASTRA_DEVICE_URI:
        command.extend(["-p", "device_uri:={}".format(ASTRA_DEVICE_URI)])
    command.extend([
        "-p",
        "depth_width:={}".format(DEPTH_WIDTH),
        "-p",
        "depth_height:={}".format(DEPTH_HEIGHT),
        "-p",
        "depth_fps:={}".format(DEPTH_FPS),
    ])

    print("Starting Astra ROS2 node in the application ROS2 context:")
    print("  {}".format(ASTRA_NODE))
    print("  OPENNI2_REDIST={}".format(OPENNI2_REDIST))
    print("  device_uri={}".format(ASTRA_DEVICE_URI or "<auto>"))

    last_process = None
    for attempt in range(1, ASTRA_DEPTH_START_RETRIES + 1):
        print(
            "  depth start attempt {}/{}".format(
                attempt, ASTRA_DEPTH_START_RETRIES
            ),
            flush=True,
        )
        process = subprocess.Popen(
            command,
            env=environment,
            start_new_session=True,
        )
        last_process = process
        deadline = time.monotonic() + ASTRA_DEPTH_START_DELAY
        while process.poll() is None and time.monotonic() < deadline:
            time.sleep(0.1)
        if process.poll() is None:
            return process
        if attempt < ASTRA_DEPTH_START_RETRIES:
            time.sleep(ASTRA_DEPTH_START_DELAY)

    raise RuntimeError(
        "Astra ROS2 node failed after {} attempts (last exit code {})".format(
            ASTRA_DEPTH_START_RETRIES,
            last_process.returncode if last_process is not None else "unknown",
        )
    )


def wait_for_depth_ready(node, camera_process):
    """Require a real 16UC1 ROS depth frame before starting inference."""
    deadline = time.monotonic() + ASTRA_DEPTH_READY_TIMEOUT
    while time.monotonic() < deadline and rclpy.ok():
        if stop_requested():
            raise StopRequested("stop requested while waiting for Astra depth")
        if camera_process.poll() is not None:
            raise RuntimeError(
                "Astra ROS2 node exited with code {} before its first depth frame".format(
                    camera_process.returncode
                )
            )
        remaining = max(0.05, deadline - time.monotonic())
        if node.wait_for_depth_frame(min(remaining, 0.2)):
            with node._lock:
                _, _, message = node._latest_depth
                width = int(message.width)
                height = int(message.height)
                encoding = message.encoding
            if encoding != "16UC1":
                raise RuntimeError(
                    "Unexpected depth encoding before inference: {}".format(
                        encoding
                    )
                )
            print(
                "Astra depth ready: {}x{} {}".format(width, height, encoding),
                flush=True,
            )
            return
    raise RuntimeError(
        "Timed out after {:.1f}s waiting for /camera/depth/image_raw".format(
            ASTRA_DEPTH_READY_TIMEOUT
        )
    )


def stop_astra_node(process):
    """Terminate the Astra node and every process in its session."""
    if process is None:
        return
    if process.poll() is None:
        try:
            os.killpg(process.pid, signal.SIGTERM)
        except ProcessLookupError:
            pass
    try:
        process.wait(timeout=3)
    except subprocess.TimeoutExpired:
        try:
            os.killpg(process.pid, signal.SIGKILL)
        except ProcessLookupError:
            pass
        process.wait(timeout=3)


def start_ros_executor(node):
    """Spin ROS callbacks independently of RGB capture and DPU inference."""
    executor = MultiThreadedExecutor(num_threads=2)
    executor.add_node(node)
    thread = threading.Thread(target=executor.spin, name="ros2-executor", daemon=True)
    thread.start()
    return executor, thread


def stop_ros_executor(executor, thread):
    if executor is not None:
        executor.shutdown()
    if thread is not None:
        thread.join(timeout=3.0)


def run_dpu_inference(
    frame,
    runner,
    input_tensor,
    output_tensors,
    output_buffers,
):
    """Run the existing KV260 YOLOv4 DPU preprocessing and decode path."""
    original_h, original_w = frame.shape[:2]

    image_rgb, scale, pad_x, pad_y = yolo.letterbox_image(
        frame,
        yolo.INPUT_W,
        yolo.INPUT_H,
    )

    input_fix_point = input_tensor.get_attr("fix_point")
    input_buffer = yolo.quantize_input(image_rgb, input_fix_point)

    start_time = time.perf_counter()
    job_id = runner.execute_async([input_buffer], output_buffers)
    runner.wait(job_id)
    dpu_time = time.perf_counter() - start_time

    all_boxes = []
    all_scores = []
    all_classes = []

    for index, tensor in enumerate(output_tensors):
        dims = tuple(tensor.dims)
        grid_h = dims[1]
        if grid_h not in yolo.ANCHORS:
            raise RuntimeError("No anchors configured for grid {}".format(grid_h))

        output_fix_point = tensor.get_attr("fix_point")
        boxes, scores, classes = yolo.decode_yolo_output(
            output_buffers[index],
            yolo.ANCHORS[grid_h],
            yolo.CONF_THRESHOLD,
            quant_scale=2.0 ** (-output_fix_point),
        )
        all_boxes.append(boxes)
        all_scores.append(scores)
        all_classes.append(classes)

    if not all_boxes:
        return np.empty((0, 4)), np.empty((0,)), np.empty((0,)), dpu_time

    boxes = np.concatenate(all_boxes, axis=0)
    scores = np.concatenate(all_scores, axis=0)
    classes = np.concatenate(all_classes, axis=0)

    if len(boxes) > 0:
        selected = yolo.classwise_nms(
            boxes,
            scores,
            classes,
            yolo.NMS_THRESHOLD,
        )
        boxes = boxes[selected]
        scores = scores[selected]
        classes = classes[selected]
        boxes = yolo.map_boxes_to_original(
            boxes,
            scale,
            pad_x,
            pad_y,
            original_w,
            original_h,
        )

    return boxes, scores, classes, dpu_time


def sample_detection_depth(depth_image, box, color_shape):
    """Return depth and sampling metadata for one RGB bounding box.

    The Astra depth publisher emits OpenNI DEPTH_1_MM (16UC1), while the
    Astra RGB endpoint is 640x480 and depth is 320x240.  The two streams do
    not currently carry calibrated registration data, so this function uses
    the corresponding normalized image coordinates and a central ROI.  It is
    deliberately explicit about that approximation in the returned metadata.
    """
    color_h, color_w = color_shape[:2]
    depth_h, depth_w = depth_image.shape[:2]
    scale_x = depth_w / float(color_w)
    scale_y = depth_h / float(color_h)

    x1, y1, x2, y2 = [float(value) for value in box]
    x1 = int(np.floor(x1 * scale_x))
    y1 = int(np.floor(y1 * scale_y))
    x2 = int(np.ceil(x2 * scale_x))
    y2 = int(np.ceil(y2 * scale_y))

    x1 = max(0, min(depth_w - 1, x1))
    y1 = max(0, min(depth_h - 1, y1))
    x2 = max(x1 + 1, min(depth_w, x2))
    y2 = max(y1 + 1, min(depth_h, y2))

    margin_x = max(1, int((x2 - x1) * DEPTH_ROI_MARGIN))
    margin_y = max(1, int((y2 - y1) * DEPTH_ROI_MARGIN))
    inner_x1 = min(x2 - 1, x1 + margin_x)
    inner_y1 = min(y2 - 1, y1 + margin_y)
    inner_x2 = max(inner_x1 + 1, x2 - margin_x)
    inner_y2 = max(inner_y1 + 1, y2 - margin_y)

    region = depth_image[inner_y1:inner_y2, inner_x1:inner_x2]
    valid = region[(region > 0) & (region <= DEPTH_MAX_MM)]
    if valid.size == 0:
        return None, 0, {
            "x1": inner_x1,
            "y1": inner_y1,
            "x2": inner_x2,
            "y2": inner_y2,
        }

    return float(np.median(valid)), int(valid.size), {
        "x1": inner_x1,
        "y1": inner_y1,
        "x2": inner_x2,
        "y2": inner_y2,
    }


def detection_bbox(detection):
    bbox = detection["bbox"]
    return np.array(
        [bbox["x1"], bbox["y1"], bbox["x2"], bbox["y2"],],
        dtype=np.float32,
    )


def bbox_iou(first, second):
    """Return intersection-over-union for two x1/y1/x2/y2 boxes."""
    x1 = max(float(first[0]), float(second[0]))
    y1 = max(float(first[1]), float(second[1]))
    x2 = min(float(first[2]), float(second[2]))
    y2 = min(float(first[3]), float(second[3]))
    intersection = max(0.0, x2 - x1) * max(0.0, y2 - y1)
    if intersection <= 0.0:
        return 0.0
    first_area = max(0.0, float(first[2] - first[0])) * max(
        0.0, float(first[3] - first[1])
    )
    second_area = max(0.0, float(second[2] - second[0])) * max(
        0.0, float(second[3] - second[1])
    )
    union = first_area + second_area - intersection
    return intersection / union if union > 0.0 else 0.0


def copy_detection(detection):
    copied = dict(detection)
    copied["bbox"] = dict(detection["bbox"])
    return copied


class DetectionTracker:
    """Small IoU tracker that stabilizes intermittent YOLO detections."""

    def __init__(self):
        self._tracks = []
        self._next_id = 1

    @staticmethod
    def _set_bbox(detection, box):
        detection["bbox"] = {
            "x1": int(round(float(box[0]))),
            "y1": int(round(float(box[1]))),
            "x2": int(round(float(box[2]))),
            "y2": int(round(float(box[3]))),
        }

    @staticmethod
    def _set_depth(detection, track, now):
        if track["depth_m"] is None or now - track["depth_at"] > DEPTH_STALE_SEC:
            detection["depth_valid"] = False
            detection["depth_mm"] = None
            detection["depth_m"] = None
            detection["depth_stale"] = True
        else:
            detection["depth_valid"] = True
            detection["depth_mm"] = round(track["depth_m"] * 1000.0, 1)
            detection["depth_m"] = round(track["depth_m"], 3)
            detection["depth_stale"] = False

    def _new_track(self, detection, now):
        box = detection_bbox(detection)
        depth_m = detection.get("depth_m")
        track = {
            "track_id": self._next_id,
            "class_id": int(detection["class_id"]),
            "bbox": box,
            "velocity": np.zeros(4, dtype=np.float32),
            "confidence": float(detection["confidence"]),
            "depth_m": float(depth_m) if depth_m is not None else None,
            "depth_at": now if depth_m is not None else 0.0,
            "last_seen": now,
            "miss_count": 0,
        }
        self._next_id += 1
        result = copy_detection(detection)
        self._set_bbox(result, box)
        result["confidence"] = round(track["confidence"], 6)
        result["track_id"] = track["track_id"]
        result["tracking_state"] = "new"
        result["held"] = False
        self._set_depth(result, track, now)
        return track, result

    def update(self, detections, now=None):
        now = time.monotonic() if now is None else now
        detections = list(detections)
        matches = []
        used_tracks = set()
        used_detections = set()
        candidates = []
        for track_index, track in enumerate(self._tracks):
            for detection_index, detection in enumerate(detections):
                if track["class_id"] != int(detection["class_id"]):
                    continue
                score = bbox_iou(track["bbox"], detection_bbox(detection))
                if score >= TRACK_IOU_THRESHOLD:
                    candidates.append((score, track_index, detection_index))
        for _, track_index, detection_index in sorted(candidates, reverse=True):
            if track_index in used_tracks or detection_index in used_detections:
                continue
            used_tracks.add(track_index)
            used_detections.add(detection_index)
            matches.append((track_index, detection_index))

        tracked = []
        for track_index, detection_index in matches:
            track = self._tracks[track_index]
            detection = detections[detection_index]
            raw_box = detection_bbox(detection)
            elapsed = max(0.001, now - track["last_seen"])
            previous_box = track["bbox"].copy()
            stable_box = (
                TRACK_BOX_ALPHA * raw_box
                + (1.0 - TRACK_BOX_ALPHA) * previous_box
            )
            track["velocity"] = (stable_box - previous_box) / elapsed
            track["bbox"] = stable_box
            track["confidence"] = (
                TRACK_SCORE_ALPHA * float(detection["confidence"])
                + (1.0 - TRACK_SCORE_ALPHA) * track["confidence"]
            )
            depth_m = detection.get("depth_m")
            if depth_m is not None:
                track["depth_m"] = float(depth_m)
                track["depth_at"] = now
            track["last_seen"] = now
            track["miss_count"] = 0

            result = copy_detection(detection)
            self._set_bbox(result, stable_box)
            result["confidence"] = round(track["confidence"], 6)
            result["track_id"] = track["track_id"]
            result["tracking_state"] = "confirmed"
            result["held"] = False
            self._set_depth(result, track, now)
            tracked.append(result)

        new_tracks = []
        for detection_index, detection in enumerate(detections):
            if detection_index not in used_detections:
                track, result = self._new_track(detection, now)
                new_tracks.append(track)
                tracked.append(result)

        retained_tracks = []
        matched_track_indices = {track_index for track_index, _ in matches}
        for track_index, track in enumerate(self._tracks):
            if track_index in matched_track_indices:
                retained_tracks.append(track)
                continue
            track["miss_count"] += 1
            age = now - track["last_seen"]
            if track["miss_count"] > TRACK_MAX_MISSES or age > TRACK_MAX_AGE_SEC:
                continue
            predicted_box = track["bbox"] + track["velocity"] * min(
                age, TRACK_MAX_PREDICT_SEC
            )
            result = {
                "class_id": track["class_id"],
                "class_name": (
                    yolo.CLASS_NAMES[track["class_id"]]
                    if 0 <= track["class_id"] < len(yolo.CLASS_NAMES)
                    else "class_{}".format(track["class_id"])
                ),
                "confidence": round(track["confidence"], 6),
                "bbox": {},
                "depth_unit": DEPTH_UNIT,
                "depth_image_size": None,
                "depth_sample_roi": None,
                "valid_depth_pixels": 0,
                "track_id": track["track_id"],
                "tracking_state": "held",
                "held": True,
            }
            self._set_bbox(result, predicted_box)
            self._set_depth(result, track, now)
            retained_tracks.append(track)
            tracked.append(result)

        self._tracks = retained_tracks + new_tracks
        tracked.sort(key=lambda item: int(item["track_id"]))
        return tracked


def render_detections(frame, detections):
    """Render stable detections onto the newest display frame."""
    for detection in detections:
        bbox = detection["bbox"]
        x1 = int(bbox["x1"])
        y1 = int(bbox["y1"])
        x2 = int(bbox["x2"])
        y2 = int(bbox["y2"])
        class_id = int(detection["class_id"])
        class_name = detection["class_name"]
        score = float(detection["confidence"])
        depth_m = detection.get("depth_m")

        color = (
            (0, 200, 255)
            if detection.get("held", False)
            else yolo.color_for_class(class_id)
        )
        cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
        if depth_m is not None:
            label = "{} {:.2f} {:.2f}m".format(class_name, score, depth_m)
        else:
            label = "{} {:.2f} depth--".format(class_name, score)
        if detection.get("held", False):
            label += " hold"

        (text_w, text_h), baseline = cv2.getTextSize(
            label,
            cv2.FONT_HERSHEY_SIMPLEX,
            0.50,
            1,
        )
        label_top = max(0, y1 - text_h - baseline - 4)
        cv2.rectangle(
            frame,
            (x1, label_top),
            (x1 + text_w + 4, y1),
            color,
            -1,
        )
        cv2.putText(
            frame,
            label,
            (x1 + 2, max(text_h + 1, y1 - baseline - 2)),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.50,
            (255, 255, 255),
            1,
            cv2.LINE_AA,
        )


def draw_detections(frame, depth_image, boxes, scores, classes):
    detections = []

    for box, score, class_id in zip(boxes, scores, classes):
        x1, y1, x2, y2 = box.astype(np.int32)
        x1 = max(0, min(frame.shape[1] - 1, x1))
        y1 = max(0, min(frame.shape[0] - 1, y1))
        x2 = max(0, min(frame.shape[1] - 1, x2))
        y2 = max(0, min(frame.shape[0] - 1, y2))
        if x2 <= x1 or y2 <= y1:
            continue

        class_id = int(class_id)
        score = float(score)
        if 0 <= class_id < len(yolo.CLASS_NAMES):
            class_name = yolo.CLASS_NAMES[class_id]
        else:
            class_name = "class_{}".format(class_id)

        depth_mm, valid_depth_pixels, depth_roi = sample_detection_depth(
            depth_image,
            (x1, y1, x2, y2),
            frame.shape,
        )
        depth_valid = depth_mm is not None
        depth_m = depth_mm / 1000.0 if depth_valid else None

        detection = {
            "class_id": class_id,
            "class_name": class_name,
            "confidence": round(score, 6),
            "bbox": {
                "x1": int(x1),
                "y1": int(y1),
                "x2": int(x2),
                "y2": int(y2),
            },
            "depth_valid": depth_valid,
            "depth_mm": round(depth_mm, 1) if depth_valid else None,
            "depth_m": round(depth_m, 3) if depth_valid else None,
            "depth_unit": DEPTH_UNIT,
            "depth_image_size": {
                "width": int(depth_image.shape[1]),
                "height": int(depth_image.shape[0]),
            },
            "depth_sample_roi": depth_roi,
            "valid_depth_pixels": valid_depth_pixels,
        }
        detections.append(detection)
    return detections


def make_dpu_context():
    global yolo
    from pynq_dpu import DpuOverlay
    import infer_yolov4 as yolo

    print("Loading custom DPU Overlay:")
    print(BITFILE)
    overlay = DpuOverlay(BITFILE)
    print("DPU Overlay loaded")
    overlay.load_model(XMODEL)
    print("XModel loaded:", XMODEL)

    runner = overlay.runner
    input_tensors = runner.get_input_tensors()
    output_tensors = runner.get_output_tensors()
    if len(input_tensors) != 1:
        raise RuntimeError(
            "Expected one input tensor, got {}".format(len(input_tensors))
        )

    input_tensor = input_tensors[0]
    print("Input tensor:", input_tensor.name, input_tensor.dims)
    print("Input fix_point:", input_tensor.get_attr("fix_point"))
    for tensor in output_tensors:
        print(
            "Output tensor:",
            tensor.name,
            tensor.dims,
            "fix_point=",
            tensor.get_attr("fix_point"),
        )

    output_buffers = [
        np.empty(tuple(tensor.dims), dtype=np.int8)
        for tensor in output_tensors
    ]
    return overlay, runner, input_tensor, output_tensors, output_buffers


def run_camera_only():
    """Hardware smoke-test mode used without loading the DPU overlay."""
    rclpy.init()
    node = AstraFrameSubscriber()
    executor = None
    executor_thread = None
    camera_process = None
    cap = None
    try:
        executor, executor_thread = start_ros_executor(node)
        camera_process = start_astra_node()
        print("Opening Astra HD UVC RGB {}...".format(COLOR_DEVICE))
        cap = open_color_camera()
        deadline = time.monotonic() + CAMERA_TEST_SECONDS
        test_start = time.monotonic()
        color_count = depth_count = 0
        last_report = time.monotonic()
        last_color_report = 0
        last_depth_report = 0
        while time.monotonic() < deadline and rclpy.ok():
            if camera_process.poll() is not None:
                raise RuntimeError("Astra depth node exited")
            ok, frame = cap.read()
            color_stamp_ns = time.time_ns()
            if ok and frame is not None:
                color_count += 1
                node.record_color_frame()
                node.publish_color(frame, color_stamp_ns)
            depth_record = node.take_depth()
            if depth_record is not None:
                depth_count += 1
                depth_stamp_ns, _, _ = depth_record
                sync_ms = abs(color_stamp_ns - depth_stamp_ns) / 1_000_000.0
                node.record_sync(sync_ms)
                if sync_ms > SYNC_TOLERANCE_MS:
                    node.record_sync_rejection()
            now = time.monotonic()
            interval = now - last_report
            if interval >= 1.0:
                print(
                    "RGBD interval: color={:.2f} FPS depth={:.2f} FPS "
                    "depth_callbacks={} conversions={} device={}".format(
                        (color_count - last_color_report) / interval,
                        (depth_count - last_depth_report) / interval,
                        node._depth_callback_count,
                        node._depth_conversion_errors,
                        COLOR_DEVICE,
                    ),
                    flush=True,
                )
                last_color_report = color_count
                last_depth_report = depth_count
                last_report = now
        elapsed = max(1.0, time.monotonic() - test_start)
        color_fps = color_count / elapsed
        depth_fps = depth_count / elapsed
        if (
            color_count < 10
            or depth_count < 10
            or color_fps < MIN_COLOR_FPS
            or depth_fps < MIN_DEPTH_FPS
            or node._depth_conversion_errors > 0
        ):
            raise RuntimeError(
                "RGB/depth test failed: color={} ({:.2f} FPS) depth={} "
                "({:.2f} FPS) required>={:.2f}/{:.2f} FPS "
                "depth_callbacks={} conversion_errors={}".format(
                    color_count,
                    color_fps,
                    depth_count,
                    depth_fps,
                    MIN_COLOR_FPS,
                    MIN_DEPTH_FPS,
                    node._depth_callback_count,
                    node._depth_conversion_errors,
                )
            )
        if node._last_sync_ms is not None:
            sync_summary = "last_sync={:.2f}ms max_sync={:.2f}ms rejected={}".format(
                node._last_sync_ms, node._max_sync_ms, node._sync_rejected
            )
        else:
            sync_summary = "last_sync=unavailable"
        print(
            "Astra RGB/depth {:.1f}s test passed: color={} ({:.2f} FPS) "
            "depth={} ({:.2f} FPS) device={} depth_mode={}x{}@{} {}".format(
                elapsed,
                color_count,
                color_fps,
                depth_count,
                depth_fps,
                COLOR_DEVICE,
                DEPTH_WIDTH,
                DEPTH_HEIGHT,
                DEPTH_FPS,
                sync_summary,
            ),
            flush=True,
        )
    finally:
        if cap is not None:
            cap.release()
        if camera_process is not None:
            stop_astra_node(camera_process)
        stop_ros_executor(executor, executor_thread)
        node.destroy_node()
        rclpy.shutdown()


def open_color_camera():
    cap = cv2.VideoCapture(COLOR_DEVICE, cv2.CAP_V4L2)
    if not cap.isOpened():
        raise RuntimeError("Cannot open Astra HD RGB device {}".format(COLOR_DEVICE))
    cap.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc(*"MJPG"))
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, CAMERA_WIDTH)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, CAMERA_HEIGHT)
    cap.set(cv2.CAP_PROP_FPS, CAMERA_FPS)
    actual_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    actual_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    actual_fps = cap.get(cv2.CAP_PROP_FPS)
    print(
        "Astra UVC opened: device={} requested={}x{}@{} actual={}x{}@{:.2f}".format(
            COLOR_DEVICE,
            CAMERA_WIDTH,
            CAMERA_HEIGHT,
            CAMERA_FPS,
            actual_width,
            actual_height,
            actual_fps,
        ),
        flush=True,
    )
    return cap


class LatestInferenceSlot:
    """A one-element, newest-frame-wins inference queue."""

    def __init__(self):
        self._condition = threading.Condition()
        self._item = None
        self._closed = False
        self.dropped = 0

    def put(self, item):
        with self._condition:
            if self._closed:
                return
            if self._item is not None:
                self.dropped += 1
            self._item = item
            self._condition.notify()

    def get(self, timeout=0.2):
        deadline = time.monotonic() + timeout
        with self._condition:
            while self._item is None and not self._closed:
                remaining = deadline - time.monotonic()
                if remaining <= 0:
                    return None
                self._condition.wait(timeout=remaining)
            item = self._item
            self._item = None
            return item

    def close(self):
        with self._condition:
            self._closed = True
            self._item = None
            self._condition.notify_all()


class InferenceState:
    """Thread-safe latest completed inference and display statistics."""

    def __init__(self):
        self.lock = threading.Lock()
        self.detections = []
        self.raw_detections = []
        self.result = None
        self.completed_at = None
        self.inference_count = 0
        self.inference_fps = 0.0
        self.last_dpu_ms = 0.0
        self.error = None

    def snapshot(self):
        with self.lock:
            age = (
                time.monotonic() - self.completed_at
                if self.completed_at is not None
                else None
            )
            return (
                list(self.detections),
                list(self.raw_detections),
                self.result,
                age,
                self.inference_count,
                self.inference_fps,
                self.last_dpu_ms,
                self.error,
            )


def inference_worker(
    input_slot,
    state,
    stop_event,
    node,
    tracker,
    runner,
    input_tensor,
    output_tensors,
    output_buffers,
):
    """Run DPU inference independently from the HDMI refresh loop."""
    last_completed_at = None
    while not stop_event.is_set():
        packet = input_slot.get()
        if packet is None:
            continue

        (
            frame,
            depth_image,
            _depth_stamp_ns,
            color_header,
            sync_ms,
        ) = packet
        try:
            boxes, scores, classes, dpu_time = run_dpu_inference(
                frame,
                runner,
                input_tensor,
                output_tensors,
                output_buffers,
            )
            detections = draw_detections(
                frame,
                depth_image,
                boxes,
                scores,
                classes,
            )
            tracked_detections = tracker.update(detections)
            held_count = sum(
                1 for detection in tracked_detections if detection.get("held", False)
            )
            completed_at = time.monotonic()
            if last_completed_at is None:
                inference_fps = 0.0
            else:
                interval = completed_at - last_completed_at
                inference_fps = 1.0 / interval if interval > 0 else 0.0
            last_completed_at = completed_at

            result = {
                "stamp": {
                    "sec": int(color_header.stamp.sec),
                    "nanosec": int(color_header.stamp.nanosec),
                },
                "frame_id": color_header.frame_id,
                "image_width": int(frame.shape[1]),
                "image_height": int(frame.shape[0]),
                "sync_delta_ms": round(sync_ms, 3),
                "dpu_ms": round(dpu_time * 1000.0, 3),
                "depth": {
                    "topic": DEPTH_TOPIC,
                    "encoding": "16UC1",
                    "unit": DEPTH_UNIT,
                    "width": int(depth_image.shape[1]),
                    "height": int(depth_image.shape[0]),
                    "mapping": "normalized_rgb_coordinates_without_calibration",
                },
                "detections": detections,
                "tracked_detections": tracked_detections,
                "tracking": {
                    "enabled": True,
                    "held_count": held_count,
                    "iou_threshold": TRACK_IOU_THRESHOLD,
                    "max_age_ms": int(TRACK_MAX_AGE_SEC * 1000.0),
                    "depth_stale_ms": int(DEPTH_STALE_SEC * 1000.0),
                },
            }

            annotated = None
            if node.has_annotated_image_subscriber():
                annotated = frame.copy()
                render_detections(annotated, tracked_detections)
            node.publish_result(annotated, color_header, result)
            with state.lock:
                state.detections = tracked_detections
                state.raw_detections = detections
                state.result = result
                state.completed_at = completed_at
                state.inference_count += 1
                state.inference_fps = inference_fps
                state.last_dpu_ms = dpu_time * 1000.0
            print(
                "YOLO frame {}: detections={} depths={}".format(
                    state.inference_count,
                    len(tracked_detections),
                    [d["depth_m"] for d in tracked_detections],
                ),
                flush=True,
            )
            if TEST_FRAMES > 0 and state.inference_count >= TEST_FRAMES:
                stop_event.set()
        except Exception as error:
            with state.lock:
                state.error = error
            stop_event.set()


def main():
    if os.environ.get("KV260_YOLO_STOP_ONLY") == "1":
        return request_running_instances_stop()
    if os.environ.get("KV260_YOLO_CAMERA_ONLY") == "1":
        run_camera_only()
        return 0

    rclpy.init()
    node = AstraFrameSubscriber()
    camera_process = None
    cap = None
    executor = None
    executor_thread = None
    overlay = None
    saved_index = 0
    processed_frames = 0
    test_deadline = None

    try:
        if stop_requested():
            raise StopRequested("stop requested before startup")
        executor, executor_thread = start_ros_executor(node)
        camera_process = start_astra_node()
        if stop_requested():
            raise StopRequested("stop requested during startup")
        overlay, runner, input_tensor, output_tensors, output_buffers = (
            make_dpu_context()
        )

        print("Opening Astra HD UVC RGB {}...".format(COLOR_DEVICE))
        cap = open_color_camera()
        wait_for_depth_ready(node, camera_process)

        if not HEADLESS:
            cv2.namedWindow(WINDOW_NAME, cv2.WINDOW_NORMAL)
            if FULLSCREEN:
                cv2.setWindowProperty(
                    WINDOW_NAME,
                    cv2.WND_PROP_FULLSCREEN,
                    cv2.WINDOW_FULLSCREEN,
                )
            else:
                cv2.resizeWindow(WINDOW_NAME, CAMERA_WIDTH, CAMERA_HEIGHT)

        if not HEADLESS:
            print("Controls:")
            print("  q / ESC : exit")
            print("  s       : save current annotated frame")
            print("  Ctrl+C  : exit from terminal")

        input_slot = LatestInferenceSlot()
        inference_state = InferenceState()
        tracker = DetectionTracker()
        stop_event = threading.Event()
        worker_thread = threading.Thread(
            target=inference_worker,
            args=(
                input_slot,
                inference_state,
                stop_event,
                node,
                tracker,
                runner,
                input_tensor,
                output_tensors,
                output_buffers,
            ),
            name="dpu-inference",
            daemon=True,
        )
        worker_thread.start()
        if TEST_SECONDS > 0.0:
            test_deadline = time.monotonic() + TEST_SECONDS

        last_display_time = time.perf_counter()
        display_fps = 0.0
        display_frames = 0

        while rclpy.ok():
            if stop_requested():
                print("Stop requested from the desktop launcher", flush=True)
                break
            if not HEADLESS and display_frames > 0:
                try:
                    window_visible = cv2.getWindowProperty(
                        WINDOW_NAME, cv2.WND_PROP_VISIBLE
                    )
                except cv2.error:
                    window_visible = -1
                if window_visible < 1:
                    print("Display window was closed", flush=True)
                    break
            if camera_process.poll() is not None:
                raise RuntimeError(
                    "Astra ROS2 node exited with code {}".format(
                        camera_process.returncode
                    )
                )
            with inference_state.lock:
                worker_error = inference_state.error
                inference_count = inference_state.inference_count
            if worker_error is not None:
                raise RuntimeError("DPU inference worker failed: {}".format(worker_error))
            if (
                stop_event.is_set()
                and TEST_FRAMES > 0
                and inference_count >= TEST_FRAMES
            ):
                break
            if test_deadline is not None and time.monotonic() >= test_deadline:
                print("YOLO test duration reached: {:.1f}s".format(TEST_SECONDS))
                break

            ok, frame = cap.read()
            if not ok or frame is None:
                if not HEADLESS:
                    cv2.waitKey(1)
                continue
            color_stamp_ns = time.time_ns()
            node.record_color_frame()
            color_header = node.publish_color(frame, color_stamp_ns)
            depth_record = node.take_depth()
            if depth_record is not None:
                depth_stamp_ns, depth_image, depth_header = depth_record
                sync_ms = abs(color_stamp_ns - depth_stamp_ns) / 1_000_000.0
                node.record_sync(sync_ms)
                if sync_ms <= SYNC_TOLERANCE_MS:
                    input_slot.put(
                        (
                            frame.copy(),
                            depth_image.copy(),
                            depth_stamp_ns,
                            color_header,
                            sync_ms,
                        )
                    )
                else:
                    node.record_sync_rejection()

            display_frame = frame.copy()
            (
                detections,
                _raw_detections,
                _last_result,
                result_age,
                inference_count,
                dpu_fps,
                dpu_ms,
                worker_error,
            ) = inference_state.snapshot()
            if worker_error is not None:
                raise RuntimeError("DPU inference worker failed: {}".format(worker_error))
            render_detections(display_frame, detections)

            current_time = time.perf_counter()
            frame_time = current_time - last_display_time
            last_display_time = current_time
            current_fps = 1.0 / frame_time if frame_time > 0 else 0.0
            display_fps = (
                current_fps
                if display_fps == 0.0
                else display_fps * 0.9 + current_fps * 0.1
            )
            age_text = "--" if result_age is None else "{:.2f}s".format(result_age)
            status = (
                "Display {:.1f} FPS | DPU {:.1f} FPS ({:.0f}ms) | "
                "Result age {} | Objects {} | Held {} | Drop {}"
            ).format(
                display_fps,
                dpu_fps,
                dpu_ms,
                age_text,
                len(detections),
                sum(1 for detection in detections if detection.get("held", False)),
                input_slot.dropped,
            )
            cv2.rectangle(
                display_frame,
                (0, 0),
                (display_frame.shape[1], 42),
                (0, 0, 0),
                -1,
            )
            cv2.putText(
                display_frame,
                status,
                (10, 28),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.50,
                (0, 255, 0),
                2,
                cv2.LINE_AA,
            )
            display_frames += 1

            if not HEADLESS:
                cv2.imshow(WINDOW_NAME, display_frame)
                key = cv2.waitKey(1) & 0xFF
                if key == ord("q") or key == 27:
                    stop_event.set()
                    break
                if key == ord("s"):
                    saved_index += 1
                    save_path = (
                        "/home/ubuntu/kv260_yolov4_deploy/"
                        "camera_result_{:04d}.jpg"
                    ).format(saved_index)
                    if cv2.imwrite(save_path, display_frame):
                        print("Saved:", save_path)
                    else:
                        print("Failed to save:", save_path)

            if (
                stop_event.is_set()
                and TEST_FRAMES > 0
                and inference_count >= TEST_FRAMES
            ):
                print("YOLO test frame limit reached:", inference_count)
                break

    except StopRequested as error:
        print("Stop requested: {}".format(error), flush=True)
    except KeyboardInterrupt:
        print("\nInterrupted from terminal")
    finally:
        if "stop_event" in locals():
            stop_event.set()
        if "input_slot" in locals():
            input_slot.close()
        if "worker_thread" in locals():
            worker_thread.join(timeout=5.0)
        if cap is not None:
            cap.release()
        if not HEADLESS:
            cv2.destroyAllWindows()
        if camera_process is not None:
            stop_astra_node(camera_process)
        stop_ros_executor(executor, executor_thread)
        node.destroy_node()
        rclpy.shutdown()
        clear_stop_request()
        print("Astra camera, ROS2 subscriptions, and display closed")
    return 0


if __name__ == "__main__":
    sys.exit(main())