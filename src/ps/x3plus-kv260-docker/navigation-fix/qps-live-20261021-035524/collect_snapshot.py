#!/usr/bin/env python
"""Read-only, bounded ROS snapshot. Compatible with robot Python 2.7."""
from __future__ import print_function
import copy
import json
import math
import threading
import time

import rospy
import tf
from geometry_msgs.msg import Twist
from map_msgs.msg import OccupancyGridUpdate
from nav_msgs.msg import OccupancyGrid
from sensor_msgs.msg import LaserScan
from std_msgs.msg import String

rospy.init_node('qps_readonly_snapshot', anonymous=True, disable_signals=True)
listener = tf.TransformListener()
lock = threading.RLock()
state = {'scans': [], 'costmap': None, 'updates': 0, 'status': None,
         'cmd_count': 0, 'nonzero_cmd_count': 0}


def scan_callback(msg):
    with lock:
        state['scans'].append(msg)
        state['scans'] = state['scans'][-20:]


def full_callback(msg):
    with lock:
        state['costmap'] = copy.deepcopy(msg)
        state['costmap'].data = list(msg.data)


def update_callback(msg):
    with lock:
        grid = state['costmap']
        if grid is None or msg.header.frame_id != grid.header.frame_id:
            return
        if msg.x + msg.width > grid.info.width or msg.y + msg.height > grid.info.height:
            return
        for row in range(msg.height):
            start = (msg.y + row) * grid.info.width + msg.x
            grid.data[start:start + msg.width] = msg.data[row * msg.width:(row + 1) * msg.width]
        grid.header.stamp = msg.header.stamp
        state['updates'] += 1


def status_callback(msg):
    with lock:
        state['status'] = json.loads(msg.data)


def cmd_callback(msg):
    with lock:
        state['cmd_count'] += 1
        values = (msg.linear.x, msg.linear.y, msg.linear.z,
                  msg.angular.x, msg.angular.y, msg.angular.z)
        state['nonzero_cmd_count'] += int(any(abs(v) > 1e-8 for v in values))


subscriptions = [
    rospy.Subscriber('/scan', LaserScan, scan_callback, queue_size=20),
    rospy.Subscriber('/move_base/local_costmap/costmap', OccupancyGrid, full_callback, queue_size=1),
    rospy.Subscriber('/move_base/local_costmap/costmap_updates', OccupancyGridUpdate, update_callback, queue_size=20),
    rospy.Subscriber('/navigation/localization_status', String, status_callback, queue_size=1),
    rospy.Subscriber('/cmd_vel', Twist, cmd_callback, queue_size=20)]
started = time.time()
while time.time() - started < 8 and not rospy.is_shutdown():
    time.sleep(.05)


def transform_xy(point, trans, quat):
    matrix = tf.transformations.quaternion_matrix(quat)
    return [trans[0] + matrix[0, 0] * point[0] + matrix[0, 1] * point[1],
            trans[1] + matrix[1, 0] * point[0] + matrix[1, 1] * point[1]]


with lock:
    scans = list(state['scans'])
    grid = copy.deepcopy(state['costmap'])
    result = {key: state[key] for key in ('status', 'updates', 'cmd_count', 'nonzero_cmd_count')}
result['collected_wall_time'] = time.time()
result['parameters'] = {name: rospy.get_param(name, None) for name in (
    '/navigation_guard', '/move_base/local_costmap', '/move_base/DWAPlannerROS',
    '/ydlidar_lidar_publisher')}
result['scans'] = []
for scan in scans:
    item = {'stamp': scan.header.stamp.to_sec(), 'frame': scan.header.frame_id,
            'angle_min': scan.angle_min, 'angle_max': scan.angle_max,
            'angle_increment': scan.angle_increment, 'range_min': scan.range_min,
            'range_max': scan.range_max, 'count': len(scan.ranges), 'returns': []}
    item['range_counts'] = {
        'nan': sum(math.isnan(v) for v in scan.ranges),
        'positive_inf': sum(math.isinf(v) and v > 0 for v in scan.ranges),
        'below_min': sum(v < scan.range_min for v in scan.ranges),
        'above_max_finite': sum(not math.isinf(v) and v > scan.range_max for v in scan.ranges)}
    try:
        trans, quat = listener.lookupTransform('base_footprint', scan.header.frame_id, scan.header.stamp)
        item['laser_to_base'] = [trans, quat]
        for i, distance in enumerate(scan.ranges):
            if math.isnan(distance) or math.isinf(distance) or not scan.range_min <= distance <= scan.range_max:
                continue
            angle = scan.angle_min + i * scan.angle_increment
            base = transform_xy((distance * math.cos(angle), distance * math.sin(angle)), trans, quat)
            item['returns'].append({'angle_deg': math.degrees(angle), 'range': distance, 'base_xy': base})
    except tf.Exception as exc:
        item['tf_error'] = str(exc)
    result['scans'].append(item)
if grid is not None:
    info = grid.info
    result['costmap'] = {'frame': grid.header.frame_id, 'stamp': grid.header.stamp.to_sec(),
                         'width': info.width, 'height': info.height, 'resolution': info.resolution,
                         'origin_xy': [info.origin.position.x, info.origin.position.y],
                         'data': list(grid.data)}
    try:
        trans, quat = listener.lookupTransform('base_footprint', grid.header.frame_id, rospy.Time(0))
        result['costmap']['frame_to_base'] = [trans, quat]
        result['costmap']['lethal_base_xy'] = [
            transform_xy((info.origin.position.x + (index % info.width + .5) * info.resolution,
                          info.origin.position.y + (index // info.width + .5) * info.resolution), trans, quat)
            for index, value in enumerate(grid.data) if value == 100]
    except tf.Exception as exc:
        result['costmap']['tf_error'] = str(exc)
print(json.dumps(result, allow_nan=False, sort_keys=True))
for subscription in subscriptions:
    subscription.unregister()
rospy.signal_shutdown('read-only snapshot complete')
time.sleep(.2)