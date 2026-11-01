#!/usr/bin/env python
"""Real AMCL + production guard + inert action server; no hardware drivers."""
from __future__ import print_function
import json
import math
import os
import signal
import subprocess
import threading
import time

import actionlib
import numpy as np
import rospy
import tf
from actionlib_msgs.msg import GoalStatus
from geometry_msgs.msg import PoseStamped, PoseWithCovarianceStamped, Twist
from move_base_msgs.msg import MoveBaseAction, MoveBaseGoal, MoveBaseResult
from nav_msgs.msg import OccupancyGrid
from sensor_msgs.msg import LaserScan
from std_msgs.msg import String
from std_srvs.srv import Trigger

root = '/project'
package = root + '/context/src/yahboomcar_nav'
grid = np.zeros((200, 240), dtype=np.int8)
grid[:2, :] = grid[-2:, :] = 100
grid[:, :2] = grid[:, -2:] = 100
grid[40:90, 80:86] = 100
grid[135:140, 140:195] = 100
grid[25:45, 185:205] = 100
truth = (2., 1., .6)
odom = (4., -2., 1.)
msg_map = OccupancyGrid()
msg_map.header.frame_id = 'map'
msg_map.info.resolution = .05
msg_map.info.width, msg_map.info.height = 240, 200
msg_map.info.origin.position.x = msg_map.info.origin.position.y = -4.
msg_map.info.origin.orientation.w = 1.
msg_map.data = grid.ravel().tolist()
scan = LaserScan()
scan.header.frame_id = 'laser'
scan.angle_min = -math.pi
scan.angle_increment = 2*math.pi/360
scan.angle_max = scan.angle_min + 359*scan.angle_increment
scan.range_min, scan.range_max, scan.scan_time = .05, 12., .1
ranges = []
for i in range(360):
    angle = truth[2] + scan.angle_min + i*scan.angle_increment
    distance = 12.
    for r in np.arange(.05, 12., .025):
        x = int((truth[0]+r*math.cos(angle)+4.)/.05)
        y = int((truth[1]+r*math.sin(angle)+4.)/.05)
        if x < 0 or y < 0 or x >= 240 or y >= 200 or grid[y, x]:
            distance = float(r)
            break
    ranges.append(distance)
scan.ranges = ranges
map_pub = rospy.Publisher('/map', OccupancyGrid, queue_size=1, latch=True)
scan_pub = rospy.Publisher('/scan', LaserScan, queue_size=1)
init_pub = rospy.Publisher('/initialpose', PoseWithCovarianceStamped, queue_size=1)
simple_pub = rospy.Publisher('/move_base_simple/goal', PoseStamped, queue_size=1)
raw_pub = rospy.Publisher('/navigation_internal/cmd_vel', Twist, queue_size=1)
pose_pub = rospy.Publisher('/amcl_pose', PoseWithCovarianceStamped, queue_size=1)
br = tf.TransformBroadcaster()
state = {'ready': False}
poses, output, forwarded, results, processes = [], [], [], [], []
mode = {'scan': True, 'tf': True, 'bad_scan': False, 'quit': False}


def on_status(m):
    state.clear()
    state.update(json.loads(m.data))


rospy.Subscriber('/navigation/localization_status', String, on_status, queue_size=1)
rospy.Subscriber('/amcl_pose', PoseWithCovarianceStamped, lambda m: poses.append(m), queue_size=1)
rospy.Subscriber('/cmd_vel', Twist, lambda m: output.append((time.time(), m.linear.x)), queue_size=100)


def environment():
    while not mode['quit'] and not rospy.is_shutdown():
        now = rospy.Time.now()
        if mode['tf']:
            br.sendTransform((odom[0], odom[1], 0), tf.transformations.quaternion_from_euler(0, 0, odom[2]), now, 'base_footprint', 'odom')
            br.sendTransform((0, 0, 0), (0, 0, 0, 1), now, 'laser', 'base_footprint')
        if mode['scan']:
            scan.header.stamp = now
            scan.ranges = [1.]*360 if mode['bad_scan'] else ranges
            scan_pub.publish(scan)
        time.sleep(.05)

