#!/usr/bin/env python3
"""Capture a fresh B3136 desktop frame or an optional legacy ROS2 image."""
import argparse
import hashlib
import json
import math
import os
from pathlib import Path
import time


CONTROL_DIR = Path('/run/user/1000/kv260-b3136-ui')


def capture_desktop(path, directory=CONTROL_DIR, timeout=15):
    import cv2
    import numpy as np
    started = time.time_ns()
    deadline = time.monotonic() + timeout
    status_path, frame_path = directory / 'status.json', directory / 'frame.ppm'
    reason = 'AI 视觉尚未启动；请先在 AI 视觉界面点击“启动视觉”'
    while time.monotonic() < deadline:
        try:
            before = status_path.read_bytes()
            status = json.loads(before)
            if status.get('state') in ('stopped', 'error', 'draining'):
                raise RuntimeError('AI 视觉已停止或正在退出；请先启动视觉再拍照')
            if status.get('state') != 'running' or status['updated'] * 1e9 < started:
                time.sleep(.03)
                continue
            stat = frame_path.stat()
            data = frame_path.read_bytes()
            after = status_path.read_bytes()
            current = frame_path.stat()
            # The producer replaces the image, then status. Reject the gap
            # between those writes, as well as frames from before the click.
            if (before != after or stat.st_ino != current.st_ino or
                    stat.st_mtime_ns < started or stat.st_mtime_ns > status['updated'] * 1e9):
                time.sleep(.03)
                continue
            if len(data) > 16 * 1024 * 1024:
                raise ValueError('AI 视觉帧超过 16 MiB')
            image = cv2.imdecode(np.frombuffer(data, dtype=np.uint8), cv2.IMREAD_COLOR)
            if image is None or image.shape != (480, 640, 3):
                raise ValueError('AI 视觉帧不是有效的 640×480 RGB 图像')
            ok, png = cv2.imencode('.png', image)
            if not ok:
                raise ValueError('AI 视觉 PNG 编码失败')
            payload = png.tobytes()
            temporary = path.with_name(path.name + '.part')
            temporary.write_bytes(payload)
            os.replace(temporary, path)
            metadata = dict(source='B3136 HLS RGB-D annotated desktop image',
                            control_dir=str(directory), captured_at=time.time(),
                            frame_updated=status['updated'], width=640, height=480,
                            bytes=len(payload), sha256=hashlib.sha256(payload).hexdigest(),
                            display_mode=status.get('display_mode'), message=status['message'])
            path.with_suffix('.json').write_text(json.dumps(metadata, ensure_ascii=False, indent=2) + '\n')
            print(json.dumps(metadata, ensure_ascii=False), flush=True)
            return metadata
        except FileNotFoundError:
            pass
        time.sleep(.03)
    raise TimeoutError(reason + '；未收到点击后的新帧（也可能是视觉进程已失去响应）')


def save_frame(message, path):
    import cv2
    import numpy as np
    if message.encoding not in ('bgr8', 'rgb8'):
        raise ValueError('Expected bgr8/rgb8 YOLO image, got ' + message.encoding)
    width, height, step = int(message.width), int(message.height), int(message.step)
    if not (0 < width <= 8192 and 0 < height <= 8192 and width * 3 <= step <= 32768):
        raise ValueError('Invalid image dimensions/stride')
    if len(message.data) != height * step:
        raise ValueError('Invalid image buffer length')
    image = np.frombuffer(bytes(message.data), dtype=np.uint8).reshape(height, step)
    image = image[:, :width * 3].reshape(height, width, 3)
    if message.encoding == 'rgb8':
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
    ok, png = cv2.imencode('.png', image)
    if not ok or not 1 <= len(png) <= 16 * 1024 * 1024:
        raise ValueError('PNG encoding failed or exceeds 16 MiB')
    data = png.tobytes()
    temporary = path.with_name(path.name + '.part')
    temporary.write_bytes(data)
    os.replace(temporary, path)
    return dict(width=width, height=height, bytes=len(data),
                sha256=hashlib.sha256(data).hexdigest(),
                stamp_sec=message.header.stamp.sec,
                stamp_nanosec=message.header.stamp.nanosec,
                frame_id=message.header.frame_id)


def capture(path, topic='/yolov4/image', timeout=15):
    # YOLO runs as root; Fast DDS SHM segments are not writable by the
    # desktop user. Use UDP for this subscriber, without changing YOLO.
    os.environ['FASTRTPS_DEFAULT_PROFILES_FILE'] = str(Path(__file__).with_name('ofdm_ros_udp.xml'))
    os.environ['FASTDDS_DEFAULT_PROFILES_FILE'] = os.environ['FASTRTPS_DEFAULT_PROFILES_FILE']
    import rclpy
    from rclpy.qos import qos_profile_sensor_data
    from sensor_msgs.msg import Image
    rclpy.init(args=[])
    node = rclpy.create_node('ofdm_yolo_snapshot_' + str(os.getpid()))
    frames = []
    started = time.time()

    def receive(message):
        stamp = message.header.stamp.sec + message.header.stamp.nanosec / 1e9
        if started - 2 <= stamp <= time.time() + 2:
            frames[:] = [message]

    subscription = node.create_subscription(Image, topic, receive, qos_profile_sensor_data)
    try:
        deadline = time.monotonic() + timeout
        while not frames and time.monotonic() < deadline:
            rclpy.spin_once(node, timeout_sec=min(.2, max(0, deadline - time.monotonic())))
        if not frames:
            raise TimeoutError('No fresh YOLO frame on ' + topic + '; start Astra RGB-D YOLO first')
        metadata = save_frame(frames[0], path)
        metadata.update(topic=topic, captured_at=time.time(), source='Astra RGB-D YOLO annotated image')
        path.with_suffix('.json').write_text(json.dumps(metadata, indent=2) + '\n')
        print(json.dumps(metadata), flush=True)
        return metadata
    finally:
        node.destroy_subscription(subscription)
        node.destroy_node()
        rclpy.shutdown()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('output', type=Path)
    parser.add_argument('--topic', help='Explicit legacy ROS2 image topic; default uses B3136 desktop IPC')
    parser.add_argument('--control-dir', type=Path, default=CONTROL_DIR)
    parser.add_argument('--timeout', type=float, default=15)
    args = parser.parse_args()
    if not math.isfinite(args.timeout) or args.timeout <= 0:
        parser.error('timeout must be positive and finite')
    try:
        if args.topic:
            capture(args.output, args.topic, args.timeout)
        else:
            capture_desktop(args.output, args.control_dir, args.timeout)
    except Exception as exc:
        parser.exit(1, str(exc) + '\n')


if __name__ == '__main__':
    main()