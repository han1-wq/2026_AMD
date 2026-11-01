#!/usr/bin/env python3
"""Bounded, read-only RGB-D/YOLO subscriber for the board's ROS 2 environment."""
import argparse
import json
import sys
import time

for path in ('/opt/ros/humble/lib/python3.10/site-packages',
             '/opt/ros/humble/local/lib/python3.10/dist-packages'):
    if path not in sys.path:
        sys.path.insert(0, path)

import rclpy
from rclpy.qos import qos_profile_sensor_data
from sensor_msgs.msg import Image
from std_msgs.msg import String


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--seconds', type=float, default=80)
    args = parser.parse_args()
    if not 0 < args.seconds <= 120:
        parser.error('seconds must be in (0, 120]')
    rclpy.init()
    node = rclpy.create_node('kv260_validation_subscriber')
    received = {}
    subscriptions = []

    def callback(message, topic):
        item = received.setdefault(topic, {'count': 0})
        item['count'] += 1
        if isinstance(message, Image):
            item.update(width=message.width, height=message.height, encoding=message.encoding,
                        bytes=len(message.data))
        else:
            try:
                item['sample'] = json.loads(message.data)
            except ValueError:
                item['sample'] = message.data[:1000]

    topics = ('/camera/color/image_raw', '/camera/depth/image_raw', '/yolov4/image', '/yolov4/detections')
    for topic in topics:
        kind = String if topic.endswith('detections') else Image
        subscriptions.append(node.create_subscription(kind, topic,
                             lambda message, name=topic: callback(message, name), qos_profile_sensor_data))
    deadline = time.monotonic() + args.seconds
    try:
        while time.monotonic() < deadline:
            rclpy.spin_once(node, timeout_sec=0.2)
            if all(received.get(topic, {}).get('count', 0) >= 20 for topic in topics):
                break
        result = {'ok': all(received.get(topic, {}).get('count', 0) >= 20 for topic in topics),
                  'received': received}
        print(json.dumps(result, ensure_ascii=False))
    finally:
        node.destroy_node()
        rclpy.shutdown()
    return 0 if result['ok'] else 1


if __name__ == '__main__':
    raise SystemExit(main())