#!/usr/bin/env python
# coding: utf-8
"""ROS Melodic navigation interlock; all navigation actions and velocity pass here."""
from __future__ import division
import json
import math
import threading
import time
from collections import deque

import actionlib
import numpy as np
import rospy
import tf
from actionlib_msgs.msg import GoalStatus
from geometry_msgs.msg import PoseStamped, PoseWithCovarianceStamped, Twist
from move_base_msgs.msg import MoveBaseAction, MoveBaseActionGoal, MoveBaseResult
from nav_msgs.msg import OccupancyGrid
from sensor_msgs.msg import LaserScan
from std_msgs.msg import Bool, String
from std_srvs.srv import Empty, Trigger, TriggerResponse
from navigation_quality import map_identity, ray_conflicts
from navigation_bookmarks import NavigationBookmarks


def finite(values):
    return all(not math.isnan(v) and not math.isinf(v) for v in values)


def yaw(q):
    values = [q.x, q.y, q.z, q.w]
    if not finite(values) or abs(sum(v*v for v in values) - 1) > .02:
        raise ValueError('invalid quaternion')
    return tf.transformations.euler_from_quaternion(values)[2]


class NavigationGuard(object):
    def __init__(self):
        self.lock = threading.RLock()
        self.listener = tf.TransformListener()
        self.max_age = rospy.get_param('~sensor_max_age', .7)
        self.pose_max_age = rospy.get_param('~pose_max_age', 3.)
        self.min_match = rospy.get_param('~min_scan_match', .65)
        self.match_distance = rospy.get_param('~match_distance', .20)
        self.max_ray_conflict = rospy.get_param('~max_ray_conflict', .08)
        self.ray_conflict = 0.
        self.max_position_std = rospy.get_param('~max_position_std', .35)
        self.max_yaw_std = rospy.get_param('~max_yaw_std', .30)
        self.stable_seconds = rospy.get_param('~stable_seconds', 2.)
        self.transient_timeout = rospy.get_param('~transient_timeout', 5.)
        if not 0 < self.stable_seconds < self.transient_timeout:
            raise ValueError('Require 0 < stable_seconds < transient_timeout')
        self.fault_since = None
        self.map_key = None
        self.grid = None
        self.scan = self.pose = None
        self.scans = deque(maxlen=10)
        self.pose_sequence = None
        self.scan_wall = self.pose_wall = 0.
        self.initial = None
        self.initial_time = 0.
        self.confirmed = self.ready = False
        self.confirmed_time = 0.
        self.good_since = None
        self.match = 0.
        self.reason = 'initial_pose_required'
        self.last_cmd = 0.
        self.command = Twist()
        self.bookmarks = None
        self.last_clock = rospy.Time.now().to_sec()
        self.previous_correction = None
        self.localization_epoch = 0
        self.active_epoch = None
        self.output = rospy.Publisher('/cmd_vel', Twist, queue_size=1)
        self.ready_pub = rospy.Publisher('/navigation/ready', Bool, queue_size=1, latch=True)
        self.status_pub = rospy.Publisher('/navigation/localization_status', String, queue_size=1)
        self.goal_pub = rospy.Publisher('/move_base/goal', MoveBaseActionGoal, queue_size=1)
        self.client = actionlib.SimpleActionClient('/navigation_internal/move_base', MoveBaseAction)
        self.server = actionlib.SimpleActionServer('/move_base', MoveBaseAction,
                                                   execute_cb=self.execute, auto_start=False)
        self.subs = [rospy.Subscriber('/map', OccupancyGrid, self.on_map, queue_size=1),
                     rospy.Subscriber('/scan', LaserScan, self.on_scan, queue_size=1),
                     rospy.Subscriber('/amcl_pose', PoseWithCovarianceStamped, self.on_pose, queue_size=1),
                     rospy.Subscriber('/initialpose', PoseWithCovarianceStamped, self.on_initial, queue_size=1),
                     rospy.Subscriber('/navigation_internal/cmd_vel', Twist, self.on_cmd, queue_size=1),
                     rospy.Subscriber('/move_base_simple/goal', PoseStamped, self.on_goal, queue_size=1)]
        self.reset_service = rospy.Service('/navigation_guard/reset', Trigger, self.reset)
        self.stop_service = rospy.Service('/navigation_guard/stop', Trigger, self.stop)
        self.bookmarks = NavigationBookmarks(self)
        self.server.start()
        rospy.on_shutdown(self.shutdown)
        worker = threading.Thread(target=self.nomotion, name='amcl-stationary-update')
        worker.daemon = True
        worker.start()

    def fresh(self, stamp, wall, limit):
        age = (rospy.Time.now() - stamp).to_sec()
        return stamp.to_sec() > 0 and -.15 <= age <= limit and 0 <= time.time()-wall <= limit

    def stop_motion(self):
        self.localization_epoch += 1
        self.active_epoch = None
        self.last_cmd = 0.
        self.command = Twist()
        self.output.publish(Twist())
        self.client.cancel_all_goals()

    def invalidate(self, reason):
        self.stop_motion()
        self.confirmed = self.ready = False
        self.good_since = None
        self.fault_since = None
        self.initial = None
        self.reason = reason
        self.previous_correction = None
        self.ready_pub.publish(False)

    def stop(self, request):
        with self.lock:
            self.stop_motion()
            if self.confirmed:
                self.confirmed_time = rospy.Time.now().to_sec()
        return TriggerResponse(True, 'Goals cancelled; current localization retained.')

    def reset(self, request):
        with self.lock:
            self.invalidate('initial_pose_required')
        return TriggerResponse(True, 'Set a new 2D Pose Estimate in map frame.')

    def on_map(self, msg):
        with self.lock:
            try:
                info = msg.info
                angle = yaw(info.origin.orientation)
                if (msg.header.frame_id.lstrip('/') != 'map' or not finite([info.resolution,
                        info.origin.position.x, info.origin.position.y]) or info.resolution <= 0
                        or info.width <= 0 or info.height <= 0):
                    raise ValueError('invalid map')
                key = (info.width, info.height, info.resolution, info.origin.position.x,
                       info.origin.position.y, angle, hash(tuple(msg.data)))
                if key == self.map_key:
                    return
                grid = np.asarray(msg.data).reshape(info.height, info.width)
                if ((grid < -1) | (grid > 100)).any():
                    raise ValueError('invalid occupancy')
                occupied = grid >= 65
                near = occupied.copy()
                radius = int(math.ceil(self.match_distance/info.resolution))
                for dy in range(-radius, radius+1):
                    for dx in range(-radius, radius+1):
                        if math.hypot(dx, dy)*info.resolution > self.match_distance:
                            continue
                        sy, sx = max(0, -dy), max(0, -dx)
                        ey, ex = min(info.height, info.height-dy), min(info.width, info.width-dx)
                        if ey > sy and ex > sx:
                            near[sy+dy:ey+dy, sx+dx:ex+dx] |= occupied[sy:ey, sx:ex]
                self.grid, self.map_info, self.map_angle = near, info, angle
                self.raw_grid = grid
                self.map_identity = map_identity(info, angle, msg.data)
                self.map_key = key
                if self.bookmarks is not None:
                    self.bookmarks.reset_map()
                self.invalidate('map_changed_initial_pose_required')
            except (ValueError, TypeError):
                self.grid = None
                self.map_key = None
                if self.bookmarks is not None:
                    self.bookmarks.reset_map()
                self.invalidate('invalid_map')

    def on_scan(self, msg):
        with self.lock:
            self.scan, self.scan_wall = msg, time.time()
            self.scans.append((self.scan, self.scan_wall))

    def on_pose(self, msg):
        with self.lock:
            if self.initial is not None and self.pose_sequence is not None and msg.header.seq < self.pose_sequence:
                self.invalidate('amcl_restarted_initial_pose_required')
            self.pose_sequence = msg.header.seq
            self.pose, self.pose_wall = msg, time.time()

    def on_initial(self, msg):
        with self.lock:
            self.invalidate('checking_initial_pose')
            try:
                p = msg.pose.pose
                a = yaw(p.orientation)
                if (msg.header.frame_id.lstrip('/') != 'map' or
                        not finite([p.position.x, p.position.y] + list(msg.pose.covariance)) or
                        any(msg.pose.covariance[i] < 0 for i in (0, 7, 35)) or
                        not self.fresh(msg.header.stamp, time.time(), 2.)):
                    raise ValueError('initial pose must be new, finite, and in map frame')
                self.initial = (p.position.x, p.position.y, a)
                self.initial_time = msg.header.stamp.to_sec()
            except ValueError:
                self.reason = 'invalid_initial_pose'

    def scan_match(self):
        scan, info = self.scan, self.map_info
        if not finite([scan.angle_min, scan.angle_increment, scan.range_min, scan.range_max]) or scan.angle_increment == 0 or scan.range_max <= scan.range_min:
            raise ValueError('invalid_scan')
        n = len(scan.ranges)
        indices = np.arange(0, n, max(1, n//120))
        distances = np.asarray(scan.ranges)[indices]
        good = np.isfinite(distances) & (distances > scan.range_min) & (distances < scan.range_max*.98)
        if int(good.sum()) < 30:
            raise ValueError('insufficient_scan_returns')
        angles = scan.angle_min + indices[good]*scan.angle_increment
        distances = distances[good]
        trans, rotation = self.listener.lookupTransform('map', scan.header.frame_id, scan.header.stamp)
        matrix = tf.transformations.quaternion_matrix(rotation)
        points = np.vstack((distances*np.cos(angles), distances*np.sin(angles), np.zeros(len(angles))))
        points = np.dot(matrix[:3, :3], points) + np.asarray(trans).reshape(3, 1)
        x, y = points[0]-info.origin.position.x, points[1]-info.origin.position.y
        c, s = math.cos(self.map_angle), math.sin(self.map_angle)
        ix = np.floor((c*x+s*y)/info.resolution).astype(int)
        iy = np.floor((-s*x+c*y)/info.resolution).astype(int)
        inside = (ix >= 0) & (iy >= 0) & (ix < info.width) & (iy < info.height)
        ox, oy = trans[0]-info.origin.position.x, trans[1]-info.origin.position.y
        self.ray_conflict = ray_conflicts(self.raw_grid, info.resolution,
            [c*ox+s*oy, -s*ox+c*oy], np.vstack((c*x+s*y, -s*x+c*y)), self.match_distance)
        return float(self.grid[iy[inside], ix[inside]].sum())/len(distances)

    def check(self, require_initial=True):
        if self.initial is None and require_initial:
            return self.reason
        if self.grid is None or self.scan is None or self.pose is None:
            return 'waiting_map_scan_pose'
        if not self.fresh(self.scan.header.stamp, self.scan_wall, self.max_age):
            return 'stale_scan'
        if not self.fresh(self.pose.header.stamp, self.pose_wall, self.pose_max_age):
            return 'stale_amcl_pose'
        if self.initial is not None and self.pose.header.stamp.to_sec() <= self.initial_time:
            return 'waiting_new_amcl_pose'
        try:
            p = self.pose.pose.pose
            a = yaw(p.orientation)
            cov = self.pose.pose.covariance
            if (self.pose.header.frame_id.lstrip('/') != 'map' or
                    not finite([p.position.x, p.position.y] + list(cov)) or
                    any(cov[i] < 0 for i in (0, 7, 35))):
                return 'invalid_amcl_pose'
            xy = np.array([[cov[0], cov[1]], [cov[6], cov[7]]])
            if abs(cov[1]-cov[6]) > 1e-5 or np.linalg.eigvalsh(xy).min() < -1e-6:
                return 'invalid_pose_covariance'
            if np.linalg.eigvalsh(xy).max() > self.max_position_std**2 or cov[35] > self.max_yaw_std**2:
                return 'high_pose_uncertainty'
            if self.initial is not None and not self.confirmed and (math.hypot(p.position.x-self.initial[0], p.position.y-self.initial[1]) > .5 or
                    abs(math.atan2(math.sin(a-self.initial[2]), math.cos(a-self.initial[2]))) > .5):
                return 'initial_pose_disagreement'
            for target, source in [('odom', 'base_footprint'), ('map', 'odom')]:
                stamp = self.listener.getLatestCommonTime(target, source)
                age = (rospy.Time.now()-stamp).to_sec()
                # AMCL intentionally future-dates map->odom by transform_tolerance.
                future = 1.2 if target == 'map' else .15
                if not -future <= age <= self.max_age:
                    return 'stale_tf'
                self.listener.lookupTransform(target, source, self.scan.header.stamp)
            self.match = self.scan_match()
            if self.match < self.min_match:
                return 'scan_map_mismatch'
            if self.ray_conflict > self.max_ray_conflict:
                return 'scan_ray_obstructed'
            trans, q = self.listener.lookupTransform('map', 'odom', self.scan.header.stamp)
            correction = (trans[0], trans[1], tf.transformations.euler_from_quaternion(q)[2])
            previous = self.previous_correction
            if self.confirmed and previous is not None and (math.hypot(correction[0]-previous[0], correction[1]-previous[1]) > .5 or
                    abs(math.atan2(math.sin(correction[2]-previous[2]), math.cos(correction[2]-previous[2]))) > .5):
                return 'localization_jump'
            self.previous_correction = correction
        except (tf.Exception, ValueError, IndexError, TypeError) as exc:
            return 'invalid_scan_or_tf: ' + str(exc)
        return ''

    def on_cmd(self, msg):
        with self.lock:
            values = [msg.linear.x, msg.linear.y, msg.linear.z, msg.angular.x, msg.angular.y, msg.angular.z]
            if (self.ready and self.active_epoch == self.localization_epoch and
                    self.server.is_active() and finite(values)):
                self.command, self.last_cmd = msg, time.time()

    def on_goal(self, msg):
        with self.lock:
            if not self.ready:
                rospy.logwarn('Navigation goal refused: %s', self.reason)
                return
            goal = MoveBaseActionGoal()
            goal.header.stamp = goal.goal_id.stamp = rospy.Time.now()
            goal.goal_id.id = 'rviz-%s' % goal.header.stamp.to_nsec()
            goal.goal.target_pose = msg
            self.goal_pub.publish(goal)

    def execute(self, goal):
        with self.lock:
            if not self.ready:
                self.server.set_aborted(MoveBaseResult(), self.reason)
                return
            if goal.target_pose.header.frame_id.lstrip('/') != 'map':
                self.server.set_aborted(MoveBaseResult(), 'goal must use map frame')
                return
            stamp = goal.target_pose.header.stamp.to_sec()
            age = rospy.Time.now().to_sec()-stamp
            if stamp <= self.confirmed_time or not -.15 <= age <= 30.:
                self.server.set_aborted(MoveBaseResult(), 'send a fresh goal after localization confirmation')
                return
            p = goal.target_pose.pose
            try:
                yaw(p.orientation)
                if not finite([p.position.x, p.position.y]):
                    raise ValueError('nonfinite goal')
            except ValueError as exc:
                self.server.set_aborted(MoveBaseResult(), str(exc))
                return
            epoch = self.localization_epoch
        if not self.client.wait_for_server(rospy.Duration(2.)):
            self.server.set_aborted(MoveBaseResult(), 'planner unavailable')
            return
        with self.lock:
            if (not self.ready or self.localization_epoch != epoch or
                    self.server.is_preempt_requested()):
                self.server.set_preempted(MoveBaseResult(), 'goal cancelled before forwarding')
                return
            self.last_cmd = 0.
            self.active_epoch = epoch
            self.client.send_goal(goal, feedback_cb=self.server.publish_feedback)
        while not rospy.is_shutdown():
            with self.lock:
                if (not self.ready or self.localization_epoch != epoch or
                        self.server.is_preempt_requested()):
                    self.client.cancel_goal()
                    self.active_epoch = None
                    self.last_cmd = 0.
                    self.output.publish(Twist())
                    self.server.set_preempted(MoveBaseResult(), self.reason)
                    return
            if self.client.wait_for_result(rospy.Duration(.1)):
                with self.lock:
                    self.active_epoch = None
                    self.last_cmd = 0.
                    self.output.publish(Twist())
                    state = self.client.get_state()
                    if not self.ready or self.localization_epoch != epoch or self.server.is_preempt_requested():
                        self.server.set_preempted(MoveBaseResult(), self.reason)
                    elif state == GoalStatus.SUCCEEDED:
                        self.server.set_succeeded(MoveBaseResult())
                    else:
                        self.server.set_aborted(MoveBaseResult(), 'planner state %s' % state)
                return

    def nomotion(self):
        while not rospy.is_shutdown():
            try:
                rospy.wait_for_service('/request_nomotion_update', timeout=1.)
                rospy.ServiceProxy('/request_nomotion_update', Empty)()
            except (rospy.ROSException, rospy.ServiceException):
                pass
            time.sleep(.5)

    def update_readiness(self, reason, wall, clock):
        """Stop on every fault; only bounded faults retain the operator's pose."""
        if self.initial is None:
            self.ready = False
            return
        if self.fault_since is not None and wall-self.fault_since >= self.transient_timeout:
            self.invalidate((reason or 'unstable_localization') + '_initial_pose_required')
            return
        if reason:
            self.good_since = None
            recoverable = reason in ('stale_scan', 'stale_amcl_pose', 'stale_tf',
                                     'high_pose_uncertainty', 'scan_map_mismatch', 'scan_ray_obstructed') or reason.startswith('invalid_scan_or_tf:')
            if self.confirmed:
                if not recoverable:
                    self.invalidate(reason + '_initial_pose_required')
                    return
                if self.fault_since is None:
                    self.fault_since = wall
                    self.stop_motion()
                self.ready = False
                self.reason = reason
            else:
                self.ready = False
                self.reason = reason
        else:
            if self.good_since is None:
                self.good_since = wall
            was_ready = self.ready
            self.ready = wall-self.good_since >= self.stable_seconds
            if self.ready:
                if not was_ready:
                    self.confirmed_time = clock
                self.confirmed = True
                self.fault_since = None
            self.reason = 'ready' if self.ready else ('recovering_localization' if self.confirmed else 'verifying_scan_match')
    def tick(self):
        with self.lock:
            clock = rospy.Time.now().to_sec()
            if clock < self.last_clock:
                self.invalidate('clock_reset_initial_pose_required')
            self.last_clock = clock
            # TCPROS scan and TF arrive on different connections. Use the newest
            # scan whose exact-time transform has arrived, within the same age limit.
            for scan, wall in reversed(self.scans):
                if self.fresh(scan.header.stamp, wall, self.max_age) and self.listener.canTransform('map', scan.header.frame_id, scan.header.stamp):
                    self.scan, self.scan_wall = scan, wall
                    break
            # Keep live sensor health separate from a historical manual-reset latch.
            reason = self.check(require_initial=False)
            self.update_readiness(reason, time.time(), clock)
            command_fresh = 0 <= time.time()-self.last_cmd < .3
            self.output.publish(self.command if self.ready and self.active_epoch == self.localization_epoch
                                and self.server.is_active() and command_fresh else Twist())
            self.ready_pub.publish(self.ready)
            self.status_pub.publish(json.dumps({'ready': self.ready, 'reason': self.reason,
                'current_fault': reason, 'initial_pose_required': self.initial is None,
                'latched_reason': self.reason if self.initial is None else '',
                'recovery_remaining_s': max(0., self.stable_seconds-(time.time()-self.good_since)) if self.good_since is not None and not self.ready else 0.,
                'scan_match': self.match, 'ray_conflict': self.ray_conflict, 'stamp': clock}))

    def shutdown(self):
        with self.lock:
            self.invalidate('shutdown')


if __name__ == '__main__':
    rospy.init_node('navigation_guard')
    guard = NavigationGuard()
    while not rospy.is_shutdown():
        guard.tick()
        time.sleep(.1)