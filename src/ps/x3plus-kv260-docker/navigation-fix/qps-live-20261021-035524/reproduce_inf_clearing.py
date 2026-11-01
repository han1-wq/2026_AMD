#!/usr/bin/env python
"""Reproduce LaserScan infinity clearing on isolated real ROS costmaps."""
from __future__ import print_function
import json
import math
import os
import subprocess
import threading
import time

import rospy
import tf
from nav_msgs.msg import OccupancyGrid
from sensor_msgs.msg import LaserScan

os.environ['ROS_MASTER_URI'] = 'http://127.0.0.1:11311'
os.environ['ROS_IP'] = '127.0.0.1'
os.environ['ROS_HOSTNAME'] = '127.0.0.1'
children = []
logs = []
running = [True]


def spawn(arguments, name):
    log = open('/evidence/inf-' + name + '.log', 'w')
    logs.append(log)
    child = subprocess.Popen(arguments, stdout=log, stderr=subprocess.STDOUT)
    children.append(child)
    return child


def wait_for(predicate, seconds, reason):
    deadline = time.time() + seconds
    while time.time() < deadline:
        if predicate():
            return
        if any(child.poll() is not None for child in children):
            raise RuntimeError('ROS subprocess exited: ' + reason)
        time.sleep(.1)
    raise RuntimeError('Timed out: ' + reason)


spawn(['roscore'], 'roscore')
try:
    import rosgraph

    def master_ready():
        try:
            rosgraph.Master('/check').getPid()
            return True
        except Exception:
            return False

    wait_for(master_ready, 12, 'master')
    rospy.init_node('inf_clearing_reproduction', disable_signals=True)
    pub = rospy.Publisher('/synthetic_scan', LaserScan, queue_size=1)
    broadcaster = tf.TransformBroadcaster()
    phase = {'range': 1.}
    lock = threading.RLock()
    latest = {}

    def receive(msg, name):
        with lock:
            latest[name] = {'lethal': sum(v == 100 for v in msg.data),
                            'stamp': msg.header.stamp.to_sec()}

    subscriptions = []
    for name, valid in [('default_inf', None), ('valid_inf', True)]:
        prefix = '/' + name
        rospy.set_param(prefix + '/planner_frequency', 0.)
        rospy.set_param(prefix + '/recovery_behavior_enabled', False)
        for costmap in ['global_costmap', 'local_costmap']:
            config = {
                'global_frame': 'odom', 'robot_base_frame': 'base_footprint',
                'rolling_window': True, 'width': 4., 'height': 4., 'resolution': .05,
                'update_frequency': 10., 'publish_frequency': 10.,
                'always_send_full_costmap': True, 'transform_tolerance': .5,
                'footprint': [[-.15, -.12], [-.15, .12], [.15, .12], [.15, -.12]],
                'plugins': [{'name': 'obstacle_layer', 'type': 'costmap_2d::ObstacleLayer'}],
                'obstacle_layer': {
                    'track_unknown_space': False, 'obstacle_range': 3., 'raytrace_range': 3.5,
                    'observation_sources': 'scan',
                    'scan': {'topic': '/synthetic_scan', 'sensor_frame': 'laser',
                             'data_type': 'LaserScan', 'marking': True, 'clearing': True}}}
            if valid is not None:
                config['obstacle_layer']['scan']['inf_is_valid'] = valid
            rospy.set_param(prefix + '/' + costmap, config)
        subscriptions.append(rospy.Subscriber(prefix + '/local_costmap/costmap', OccupancyGrid,
                                              receive, callback_args=name, queue_size=1))
        spawn(['rosrun', 'move_base', 'move_base', '__name:=' + name,
               'cmd_vel:=' + prefix + '/unused_cmd_vel'], name)

    def environment():
        while running[0] and not rospy.is_shutdown():
            stamp = rospy.Time.now()
            broadcaster.sendTransform((0, 0, 0), (0, 0, 0, 1), stamp, 'base_footprint', 'odom')
            broadcaster.sendTransform((0, 0, .12), (0, 0, 0, 1), stamp, 'laser', 'base_footprint')
            scan = LaserScan()
            scan.header.stamp, scan.header.frame_id = stamp, 'laser'
            scan.angle_min, scan.angle_max, scan.angle_increment = -.2, .2, .01
            scan.range_min, scan.range_max, scan.scan_time = .01, 50., .05
            scan.ranges = [phase['range']] * 41
            pub.publish(scan)
            time.sleep(.05)

    worker = threading.Thread(target=environment)
    worker.daemon = True
    worker.start()
    wait_for(lambda: all(latest.get(n, {}).get('lethal', 0) > 0
                         for n in ('default_inf', 'valid_inf')), 18, 'finite obstacle marked in both maps')
    with lock:
        before = dict(latest)
    phase['range'] = float('inf')
    changed_at = time.time()
    wait_for(lambda: latest.get('valid_inf', {}).get('lethal', -1) == 0, 8, 'valid infinity clears obstacle')
    time.sleep(1.)
    with lock:
        after = dict(latest)
    assert after['default_inf']['lethal'] > 0, 'Default unexpectedly cleared infinite rays'
    assert after['valid_inf']['lethal'] == 0, 'Configured infinite rays failed to clear'
    phase['range'] = 1.
    wait_for(lambda: all(latest.get(n, {}).get('lethal', 0) > 0
                         for n in ('default_inf', 'valid_inf')), 8, 'finite obstacle reappears in both maps')
    with lock:
        reappeared = dict(latest)
    versions = subprocess.check_output(['dpkg-query', '-W', 'ros-melodic-costmap-2d',
                                        'ros-melodic-laser-geometry']).decode()
    result = {'passed': True, 'versions': versions, 'before': before, 'after': after,
              'finite_obstacle_reappeared': reappeared,
              'seconds_after_inf': time.time() - changed_at,
              'scope': 'Network none, no devices; two real move_base costmaps; synthetic LaserScan and TF'}
    with open('/evidence/inf-clearing-result.json', 'w') as output:
        json.dump(result, output, indent=2, sort_keys=True)
    print(json.dumps(result, sort_keys=True))
finally:
    running[0] = False
    for child in reversed(children):
        if child.poll() is None:
            child.terminate()
    if rospy.core.is_initialized():
        rospy.signal_shutdown('isolated test complete')
    for child in reversed(children):
        for unused in range(20):
            if child.poll() is not None:
                break
            time.sleep(.05)
        if child.poll() is None:
            child.kill()
    for log in logs:
        log.close()