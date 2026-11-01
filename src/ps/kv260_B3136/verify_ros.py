#!/usr/bin/env python3
"""Independently verify the published B3136 detection stream for a bounded time."""
import argparse
import json
import math
from pathlib import Path
import time

import rclpy
from rclpy.node import Node
from rclpy.qos import QoSProfile, ReliabilityPolicy
from std_msgs.msg import String


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--seconds', type=float, default=45)
    parser.add_argument('--summary', type=Path, required=True)
    args = parser.parse_args()
    if not 0 < args.seconds <= 300:
        parser.error('--seconds must be in (0, 300]')
    rclpy.init()
    node = Node('b3136_detection_verifier')
    report = dict(messages=0, paired_messages=0, hls_post_messages=0,
                  detections=0, depth_detections=0, errors=[], last_message=None)
    last_sequence = -1

    def receive(msg):
        nonlocal last_sequence
        try:
            data = json.loads(msg.data)
            sequence = data['sequence']
            if type(sequence) is not int or sequence <= last_sequence:
                raise ValueError('sequence did not increase')
            last_sequence = sequence
            if data['depth_registration'] != 'uncalibrated_normalized_roi':
                raise ValueError('unexpected depth registration claim')
            if data['depth_unit'] != 'm' or data['rgb_timestamp'] != 'host_after_v4l2_read':
                raise ValueError('unexpected timestamp or depth unit')
            if not math.isfinite(data['latency_ms']) or data['latency_ms'] < 0:
                raise ValueError('invalid latency')
            if data['depth_stamp_ns'] is not None:
                expected = (data['rgb_stamp_ns'] - data['depth_stamp_ns']) / 1e6
                if abs(expected - data['depth_skew_ms']) > 1e-6:
                    raise ValueError('inconsistent depth timestamp/skew')
                report['paired_messages'] += 1
            report['hls_post_messages'] += int(data['hls_post_used'])
            for detection in data['detections']:
                x1, y1, x2, y2 = detection['bbox']
                if not (0 <= x1 < x2 <= 639 and 0 <= y1 < y2 <= 479):
                    raise ValueError('invalid bounding box')
                if not (0 <= detection['class_id'] < 80 and 0 <= detection['score'] <= 1):
                    raise ValueError('invalid class or score')
                report['detections'] += 1
                if detection['depth_m'] is not None:
                    if not (0 < detection['depth_m'] <= 10 and detection['valid_depth_pixels'] >= 5):
                        raise ValueError('invalid depth estimate')
                    report['depth_detections'] += 1
            report['messages'] += 1
            report['last_message'] = data
        except (ValueError, KeyError, TypeError) as exc:
            if len(report['errors']) < 10:
                report['errors'].append(str(exc))

    subscription = node.create_subscription(
        String, '/yolov4_b3136/detections', receive,
        QoSProfile(depth=1, reliability=ReliabilityPolicy.BEST_EFFORT))
    try:
        deadline = time.monotonic() + args.seconds
        while time.monotonic() < deadline:
            rclpy.spin_once(node, timeout_sec=.1)
    finally:
        node.destroy_subscription(subscription)
        node.destroy_node()
        rclpy.shutdown()
    report['success'] = bool(report['messages'] and report['paired_messages']
                             and report['hls_post_messages'] and not report['errors'])
    args.summary.parent.mkdir(parents=True, exist_ok=True)
    args.summary.write_text(json.dumps(report, indent=2) + '\n')
    print('ROS_VERIFY ' + json.dumps(report), flush=True)
    if not report['success']:
        raise SystemExit(1)


if __name__ == '__main__':
    main()