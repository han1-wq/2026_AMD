"""ROS-free geometry tests, run with the test image's existing numpy."""
from __future__ import division
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


if __name__ == '__main__':
    unittest.main()