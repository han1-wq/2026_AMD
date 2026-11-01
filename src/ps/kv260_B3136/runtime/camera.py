"""Existing Astra ROS2 depth node plus UVC RGB, with bounded recent-frame storage."""
import os
import signal
import subprocess
import threading
import time

import cv2
import numpy as np
import rclpy
from rclpy.node import Node
from rclpy.executors import SingleThreadedExecutor
from rclpy.qos import QoSProfile, ReliabilityPolicy
from rclpy.signals import SignalHandlerOptions
from sensor_msgs.msg import Image
from std_msgs.msg import String

ASTRA_NODE = '/home/ubuntu/kv260_astra_ws/install/astra_openni2/lib/astra_openni2/astra_openni2_node'
OPENNI = '/home/ubuntu/x3plus-kv260-docker/context/src/astra_camera/include/openni2_redist/arm64'
COLOR_DEVICE = '/dev/v4l/by-id/usb-Astra_Pro_HD_Camera_Astra_Pro_HD_Camera-video-index0'


class DepthNode(Node):
    def __init__(self):
        super().__init__('b3136_yolo_rgbd')
        self.lock = threading.Lock()
        self.latest = None
        self.count = 0
        self.invalid = 0
        qos = QoSProfile(depth=1, reliability=ReliabilityPolicy.BEST_EFFORT)
        self.subscription = self.create_subscription(Image, '/camera/depth/image_raw', self.receive, qos)
        self.publisher = self.create_publisher(String, '/yolov4_b3136/detections', qos)

    def receive(self, msg):
        if (msg.encoding != '16UC1' or not 0 < msg.width <= 1920 or
                not 0 < msg.height <= 1080 or msg.step < msg.width * 2 or
                msg.step % 2 or len(msg.data) < msg.step * msg.height):
            self.invalid += 1
            return
        stamp = msg.header.stamp.sec * 10**9 + msg.header.stamp.nanosec
        with self.lock:
            # Retain the ROS message, rather than copy a full depth image.
            self.latest = (msg, stamp, time.monotonic())
            self.count += 1

    def snapshot(self, stamp_ns, max_skew_ms):
        with self.lock:
            record = self.latest
        if record is None:
            return None
        msg, stamp, received = record
        skew_ms = (stamp_ns - stamp) / 1e6
        if abs(skew_ms) > max_skew_ms or time.monotonic() - received > .25:
            return None
        return msg, skew_ms


class Camera:
    def __init__(self, device=COLOR_DEVICE, external_depth=False):
        self.process = self.cap = self.node = self.executor = self.thread = None
        self.device = device
        self.external_depth = external_depth

    def start(self):
        # The application owns SIGINT/SIGTERM and drains accelerators before
        # shutting down DDS. ROS must not invalidate the executor during drain.
        rclpy.init(signal_handler_options=SignalHandlerOptions.NO)
        self.node = DepthNode()
        self.executor = SingleThreadedExecutor()
        self.executor.add_node(self.node)
        self.thread = threading.Thread(target=self.executor.spin, name='ros-depth', daemon=True)
        self.thread.start()
        if not self.external_depth:
            existing = subprocess.run(['pgrep', '-x', '-f', ASTRA_NODE + '.*'], capture_output=True, text=True)
            if existing.returncode == 0:
                raise RuntimeError('Astra depth node already running; use --external-depth to subscribe')
        env = os.environ.copy()
        env['OPENNI2_REDIST'] = OPENNI
        env['LD_LIBRARY_PATH'] = ':'.join([OPENNI, OPENNI + '/OpenNI2/Drivers', env.get('LD_LIBRARY_PATH', '')])
        for attempt in range(3):
            if not self.external_depth:
                cmd = [ASTRA_NODE, '--ros-args', '-p', 'depth_width:=320',
                       '-p', 'depth_height:=240', '-p', 'depth_fps:=30']
                if os.environ.get('ASTRA_DEVICE_URI'):
                    cmd += ['-p', 'device_uri:=' + os.environ['ASTRA_DEVICE_URI']]
                self.process = subprocess.Popen(cmd, env=env, start_new_session=True)
            deadline = time.monotonic() + 15
            while time.monotonic() < deadline:
                if self.process and self.process.poll() is not None:
                    break
                if self.node.latest is not None:
                    break
                time.sleep(.1)
            if self.node.latest is not None:
                break
            self.stop_child()
            if self.external_depth:
                break
            time.sleep(.5)
        if self.node.latest is None:
            raise RuntimeError('No valid ROS2 16UC1 depth frame within startup timeout')
        self.cap = cv2.VideoCapture(self.device, cv2.CAP_V4L2)
        if not self.cap.isOpened():
            raise RuntimeError('Cannot open RGB: ' + self.device)
        self.cap.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc(*'MJPG'))
        self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
        self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
        self.cap.set(cv2.CAP_PROP_FPS, 30)
        self.cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)
        if (int(self.cap.get(cv2.CAP_PROP_FRAME_WIDTH)), int(self.cap.get(cv2.CAP_PROP_FRAME_HEIGHT))) != (640, 480):
            raise RuntimeError('HLS pipeline requires RGB 640x480')
        print('CAMERA_READY RGB=640x480 MJPG depth=320x240 16UC1/mm ROS2', flush=True)

    def stop_child(self):
        if self.process and self.process.poll() is None:
            os.killpg(self.process.pid, signal.SIGINT)
            try:
                self.process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                os.killpg(self.process.pid, signal.SIGTERM)
                try:
                    self.process.wait(timeout=3)
                except subprocess.TimeoutExpired:
                    os.killpg(self.process.pid, signal.SIGKILL)
                    self.process.wait(timeout=3)
        self.process = None

    def close(self):
        self.stop_child()
        if self.cap:
            self.cap.release()
        if self.executor:
            self.executor.shutdown(timeout_sec=2)
        if self.thread:
            self.thread.join(timeout=2)
        if self.node:
            self.node.destroy_node()
        if rclpy.ok():
            rclpy.shutdown()


def sample_depth(record, box):
    """Normalized central ROI; no calibration/registration is assumed."""
    if record is None:
        return None, 0
    msg, _ = record
    dtype = '>u2' if msg.is_bigendian else '<u2'
    depth = np.ndarray((msg.height, msg.width), dtype=dtype, buffer=msg.data,
                       strides=(msg.step, 2))
    x1, y1, x2, y2 = box
    dx, dy = (x2-x1)*.3, (y2-y1)*.3
    left = max(0, min(msg.width-1, int((x1+dx)*msg.width/640)))
    top = max(0, min(msg.height-1, int((y1+dy)*msg.height/480)))
    right = max(left+1, min(msg.width, int(np.ceil((x2-dx)*msg.width/640))))
    bottom = max(top+1, min(msg.height, int(np.ceil((y2-dy)*msg.height/480))))
    roi = depth[top:bottom, left:right]
    values = roi[(roi > 0) & (roi <= 10000)]
    return (float(np.median(values))/1000, int(values.size)) if values.size >= 5 else (None, int(values.size))