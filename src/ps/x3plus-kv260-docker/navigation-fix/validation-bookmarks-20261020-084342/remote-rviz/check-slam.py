#!/usr/bin/env python
"""Receive SLAM data on the PC; never publish robot commands."""
from __future__ import print_function
import json
import math
import time
import rospy
import tf
from nav_msgs.msg import OccupancyGrid, Odometry
from sensor_msgs.msg import LaserScan

rospy.init_node('pc_slam_check', anonymous=True, disable_signals=True)
listener = tf.TransformListener()
scan = rospy.wait_for_message('/scan', LaserScan, timeout=15)
odom = rospy.wait_for_message('/odom', Odometry, timeout=15)
grid = rospy.wait_for_message('/map', OccupancyGrid, timeout=30)
listener.waitForTransform('map', 'laser', rospy.Time(0), rospy.Duration(10))
position, rotation = listener.lookupTransform('map', 'base_footprint', rospy.Time(0))
counts = {'scan': 0, 'map': 0}
stamps = []

def on_scan(message):
    counts['scan'] += 1
    stamps.append(message.header.stamp.to_sec())

def on_map(message):
    counts['map'] += 1

sub_scan = rospy.Subscriber('/scan', LaserScan, on_scan)
sub_map = rospy.Subscriber('/map', OccupancyGrid, on_map)
started = time.time()
time.sleep(8)
elapsed = time.time() - started
result = {
    'master': rospy.get_master().getUri(),
    'scan_frame': scan.header.frame_id,
    'scan_samples': len(scan.ranges),
    'scan_valid_ranges': sum(1 for r in scan.ranges if not math.isinf(r) and not math.isnan(r)),
    'scan_hz': counts['scan'] / elapsed,
    'scan_stamps_advance': len(stamps) > 1 and stamps[-1] > stamps[0],
    'odom_frame': odom.header.frame_id,
    'map_frame': grid.header.frame_id,
    'map_size': [grid.info.width, grid.info.height],
    'map_resolution': grid.info.resolution,
    'known_cells': sum(1 for cell in grid.data if cell >= 0),
    'occupied_cells': sum(1 for cell in grid.data if cell > 50),
    'map_messages_in_8s': counts['map'],
    'map_to_laser_tf': True,
    'robot_position_in_map': position,
}
print(json.dumps(result, indent=2))
if not result['known_cells'] or not result['scan_stamps_advance']:
    raise SystemExit('Map or live scan check failed')