"""Read-only ROS subscriber streamed to python stdin over SSH; no deployment."""
import base64
from collections import deque
import json
import sys
import time
import zlib

import cv2
import numpy as np
import rclpy
from rclpy.qos import qos_profile_sensor_data
from sensor_msgs.msg import Image
from std_msgs.msg import String


def stamp(msg):
    return msg.header.stamp.sec + msg.header.stamp.nanosec / 1e9


def main():
    rclpy.init()
    node = rclpy.create_node('local_console_vision_reader')
    frames, depths, results = deque(maxlen=8), deque(maxlen=16), deque(maxlen=8)
    node.create_subscription(Image, '/yolov4/image', frames.append, qos_profile_sensor_data)
    node.create_subscription(Image, '/camera/depth/image_raw', depths.append, qos_profile_sensor_data)
    node.create_subscription(String, '/yolov4/detections', lambda m: results.append(json.loads(m.data)), 10)
    last, sent = 0.0, 0.0
    try:
        while rclpy.ok():
            rclpy.spin_once(node, timeout_sec=.02)
            if not frames or not depths or not results or time.monotonic() - sent < .18:
                continue
            image = frames[-1]
            ts = stamp(image)
            if ts <= last:
                continue
            depth = min(depths, key=lambda d: abs(stamp(d) - ts))
            result = min(results, key=lambda d: abs(d['stamp']['sec'] + d['stamp']['nanosec']/1e9-ts))
            result_ts = result['stamp']['sec'] + result['stamp']['nanosec']/1e9
            if abs(stamp(depth)-ts) > .2 or abs(result_ts-ts) > .02 or time.time()-ts > 2:
                continue
            if image.encoding not in ('bgr8', 'rgb8') or depth.encoding != '16UC1':
                raise ValueError('Unsupported camera encoding')
            rgb = np.frombuffer(bytes(image.data), np.uint8).reshape(image.height, image.step)
            rgb = rgb[:, :image.width*3].reshape(image.height, image.width, 3)
            if image.encoding == 'rgb8':
                rgb = cv2.cvtColor(rgb, cv2.COLOR_RGB2BGR)
            ok, jpeg = cv2.imencode('.jpg', rgb, [cv2.IMWRITE_JPEG_QUALITY, 78])
            if not ok:
                continue
            payload = dict(kind='frame', stamp=ts, source_age_s=time.time()-ts,
                           depth_stamp=stamp(depth), detections=result,
                           width=image.width, height=image.height,
                           jpeg=base64.b64encode(jpeg).decode(),
                           depth=dict(width=depth.width, height=depth.height, step=depth.step,
                                      bigendian=bool(depth.is_bigendian), encoding=depth.encoding,
                                      zlib=base64.b64encode(zlib.compress(bytes(depth.data), 1)).decode()))
            print(json.dumps(payload, separators=(',', ':')), flush=True)
            last, sent = ts, time.monotonic()
    except (BrokenPipeError, KeyboardInterrupt):
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()