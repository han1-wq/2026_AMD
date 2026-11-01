"""ROS-free geometry tests, run with the test image's existing numpy."""
from __future__ import division
import ast
import math
import os
import sys
import unittest

import numpy as np
sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                              'context/src/yahboomcar_nav/scripts'))
from navigation_quality import map_identity, ray_conflicts


class GeometryTests(unittest.TestCase):
    def test_near_endpoint_does_not_excuse_intervening_wall(self):
        grid = np.zeros((80, 100), dtype=np.int8)
        grid[:, 40] = grid[:, 90] = 100
        self.assertEqual(ray_conflicts(grid, .1, [1., 4.], np.array([[9.], [4.]]), .2), 1.)
        self.assertEqual(ray_conflicts(grid, .1, [1., 4.], np.array([[4.], [4.]]), .2), 0.)

    def test_multiple_origins_headings_and_thin_walls(self):
        grid = np.zeros((100, 100), dtype=np.int8)
        grid[:, 50] = 100
        for y in (1., 4., 8.):
            for offset in (-.3, 0., .3):
                self.assertEqual(ray_conflicts(grid, .1, [2., y], np.array([[8.], [y+offset]]), .2), 1.)
                self.assertEqual(ray_conflicts(grid, .1, [8., y], np.array([[2.], [y+offset]]), .2), 1.)

    def test_unknown_is_not_a_wall_and_extreme_ranges_fail_closed(self):
        grid = np.full((50, 50), -1, dtype=np.int8)
        self.assertEqual(ray_conflicts(grid, .1, [1., 1.], np.array([[3.], [3.]]), .2), 0.)
        with self.assertRaises(ValueError):
            ray_conflicts(grid, .001, [1., 1.], np.array([[100.], [100.]]), .2)

    def test_symmetric_map_cannot_prove_heading(self):
        # Deliberate limitation: in an empty symmetric room the pi hypotheses
        # generate identical scan evidence. Never advertise this as uniqueness.
        grid = np.zeros((101, 101), dtype=np.int8)
        grid[0, :] = grid[-1, :] = grid[:, 0] = grid[:, -1] = 100
        origin = np.array([5.05, 5.05])
        angles = np.arange(120)*math.pi/60
        distances = 5./np.maximum(np.abs(np.cos(angles)), np.abs(np.sin(angles)))
        endpoints = origin[:, None] + np.vstack((np.cos(angles), np.sin(angles)))*distances
        forward = ray_conflicts(grid, .1, origin, endpoints, .2)
        reverse = ray_conflicts(grid, .1, origin, 2*origin[:, None]-endpoints, .2)
        self.assertEqual(forward, 0.)
        self.assertEqual(forward, reverse)

    def test_fingerprint_includes_grid_resolution_and_origin_not_timestamp(self):
        class Info(object):
            width, height, resolution = 2, 2, .05
            class origin(object):
                class position(object):
                    x, y = 0., 0.
        info = Info()
        first = map_identity(info, 0., [0, 0, 0, 100])
        self.assertEqual(first, map_identity(info, 0., [0, 0, 0, 100]))
        self.assertNotEqual(first, map_identity(info, 0., [0, 0, 100, 100]))
        self.assertNotEqual(first, map_identity(info, .1, [0, 0, 0, 100]))
        info.resolution = .1
        self.assertNotEqual(first, map_identity(info, 0., [0, 0, 0, 100]))

    def test_raycast_consistency_at_multiple_positions_and_headings(self):
        grid = np.zeros((200, 240), dtype=np.int8)
        grid[:2, :] = grid[-2:, :] = 100
        grid[:, :2] = grid[:, -2:] = 100
        grid[40:90, 80:86] = 100
        grid[135:140, 140:195] = 100
        grid[25:45, 185:205] = 100
        distances = np.arange(.05, 12., .025)
        for px, py in ((2., 1.), (1., -1.), (4., 4.)):
            for yaw in (-2., 0., .6, 2.):
                angles = yaw+np.arange(120)*math.pi/60
                x = np.floor((px+4.+np.cos(angles[:, None])*distances)/.05).astype(int)
                y = np.floor((py+4.+np.sin(angles[:, None])*distances)/.05).astype(int)
                inside = (x >= 0) & (y >= 0) & (x < 240) & (y < 200)
                occupied = ~inside | (grid[np.clip(y, 0, 199), np.clip(x, 0, 239)] >= 65)
                returns = distances[occupied.argmax(axis=1)]
                origin = np.array([px+4., py+4.])
                points = origin[:, None] + np.vstack((np.cos(angles), np.sin(angles)))*returns
                score = ray_conflicts(grid, .05, origin, points, .2)
                self.assertEqual(score, 0., 'correct raycast pose rejected')
                if (px, py) == (2., 1.):
                    reversed_score = ray_conflicts(grid, .05, origin, 2*origin[:, None]-points, .2)
                    self.assertGreater(reversed_score, .08, 'known reversed-heading case not rejected')


class Fields(object):
    def __init__(self, **values):
        self.__dict__.update(values)


class Stamp(object):
    def __init__(self, seconds):
        self.seconds = seconds

    def to_sec(self):
        return self.seconds

    def __sub__(self, other):
        return Stamp(self.seconds-other.seconds)


class GuardQualityTests(unittest.TestCase):
    """Actual guard checks and numpy geometry, without a ROS master."""
    def setUp(self):
        source = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                              'context/src/yahboomcar_nav/scripts/navigation_guard.py')
        with open(source) as handle:
            tree = ast.parse(handle.read())
        tree.body = [node for node in tree.body if isinstance(node, ast.ClassDef)]
        self.tf_age = .1
        self.correction = 0.
        namespace = {'np': np, 'math': math, 'ray_conflicts': ray_conflicts,
                     'finite': lambda values: all(not math.isnan(v) and not math.isinf(v) for v in values),
                     'yaw': lambda q: 0., 'time': Fields(time=lambda: 10.),
                     'rospy': Fields(Time=Fields(now=lambda: Stamp(10.))),
                     'tf': Fields(Exception=RuntimeError, transformations=Fields(
                         euler_from_quaternion=lambda q: [0., 0., 0.],
                         quaternion_matrix=lambda q: np.eye(4)))}
        code = compile(tree, source, 'exec')
        eval(code, namespace)
        cls = namespace['NavigationGuard']
        self.g = g = cls.__new__(cls)
        for node in ast.walk(tree):
            if (isinstance(node, ast.Assign) and isinstance(node.value, ast.Call)
                    and isinstance(node.value.func, ast.Attribute)
                    and node.value.func.attr == 'get_param'):
                setattr(g, node.targets[0].attr, ast.literal_eval(node.value.args[1]))
        g.initial, g.initial_time, g.confirmed = (0., 0., 0.), 1., True
        g.previous_correction = (0., 0., 0.)
        g.grid, g.raw_grid = np.ones((40, 40), dtype=bool), np.zeros((40, 40), dtype=np.int8)
        g.map_angle = 0.
        g.map_info = Fields(width=40, height=40, resolution=.1,
                            origin=Fields(position=Fields(x=-2., y=-2.)))
        g.scan_wall = g.pose_wall = 9.9
        g.scan = Fields(header=Fields(stamp=Stamp(9.9), frame_id='laser'),
                        angle_min=-math.pi, angle_increment=math.pi/60.,
                        range_min=.05, range_max=12., ranges=[1.]*120)
        covariance = [0.]*36
        covariance[0] = covariance[7] = covariance[35] = .01
        g.pose = Fields(header=Fields(stamp=Stamp(9.9), frame_id='map'),
                        pose=Fields(pose=Fields(position=Fields(x=0., y=0.), orientation=None),
                                    covariance=covariance))
        g.listener = Fields(getLatestCommonTime=lambda *args: Stamp(10.-self.tf_age),
                            lookupTransform=lambda *args: ([self.correction, 0., 0.], [0., 0., 0., 1.]))

    def score(self, match, conflict):
        def evaluate():
            self.g.ray_conflict = conflict
            return match
        self.g.scan_match = evaluate

    def test_twelve_returns_track_but_do_not_confirm_initial_pose(self):
        g = self.g
        g.scan.ranges = [1.]*12+[float('inf')]*108
        self.assertEqual(g.check(), '')
        self.assertEqual(g.valid_returns, 12)
        g.confirmed = False
        self.assertEqual(g.check(), 'insufficient_scan_returns')
        self.assertIsNone(g.match)

    def test_eleven_returns_and_empty_scans_are_insufficient_not_healthy(self):
        for returns in ([1.]*11+[float('inf')]*109, [], [float('nan')]*120):
            self.g.scan.ranges = returns
            self.assertEqual(self.g.check(), 'insufficient_scan_returns')
            self.assertIsNone(self.g.match)

    def test_tracking_match_and_conflict_are_relaxed_but_bounded(self):
        self.score(.50, .15)
        self.assertEqual(self.g.check(), '')
        self.g.confirmed = False
        self.assertEqual(self.g.check(), 'scan_map_mismatch')
        self.score(.9, .15)
        self.assertEqual(self.g.check(), 'scan_ray_obstructed')
        self.g.confirmed = True
        self.score(.44, .0)
        self.assertEqual(self.g.check(), 'scan_map_mismatch')
        self.score(.9, .21)
        self.assertEqual(self.g.check(), 'scan_ray_obstructed')

    def test_tracking_uncertainty_limits_and_invalid_covariance(self):
        g = self.g
        g.pose.pose.covariance[0] = .5**2
        g.pose.pose.covariance[35] = .45**2
        self.assertEqual(g.check(), '')
        g.confirmed = False
        self.assertEqual(g.check(), 'high_pose_uncertainty')
        g.confirmed = True
        g.pose.pose.covariance[0] = .56**2
        self.assertEqual(g.check(), 'high_pose_uncertainty')
        g.pose.pose.covariance[0] = -1.
        self.assertEqual(g.check(), 'invalid_amcl_pose')

    def test_hard_jump_and_stale_tf_are_not_masked_by_soft_quality(self):
        g = self.g
        g.pose.pose.covariance[0] = 1.
        self.score(.1, .9)
        self.tf_age = 1.6
        self.assertEqual(g.check(), 'stale_tf')
        self.tf_age = .1
        self.correction = .6
        self.assertEqual(g.check(), 'localization_jump')

    def test_sensor_and_pose_age_limits_and_no_cached_quality(self):
        g = self.g
        g.scan.header.stamp, g.scan_wall = Stamp(8.6), 8.6
        g.pose.header.stamp, g.pose_wall = Stamp(5.1), 5.1
        self.assertEqual(g.check(), '')
        g.scan.header.stamp = Stamp(8.4)
        self.assertEqual(g.check(), 'stale_scan')
        self.assertIsNone(g.match)
        g.scan.header.stamp = Stamp(9.9)
        g.pose.header.stamp = Stamp(4.9)
        self.assertEqual(g.check(), 'stale_amcl_pose')


if __name__ == '__main__':
    unittest.main()