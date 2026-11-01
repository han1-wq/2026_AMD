"""Viewer configuration checks; no ROS master, Docker or robot required."""
from pathlib import Path
import unittest
import xml.etree.ElementTree as ET

import yaml


BASE = Path(__file__).resolve().parent


class ViewerConfigTests(unittest.TestCase):
    def config(self, mode):
        return yaml.safe_load((BASE / (mode + '.rviz')).read_text())['Visualization Manager']

    def test_both_modes_enable_robot_visuals(self):
        for mode in ('slam', 'navigation'):
            with self.subTest(mode=mode):
                models = [item for item in self.config(mode)['Displays']
                          if item['Class'] == 'rviz/RobotModel']
                self.assertEqual(len(models), 1)
                model = models[0]
                self.assertTrue(model['Enabled'])
                self.assertTrue(model['Visual Enabled'])
                self.assertFalse(model['Collision Enabled'])
                self.assertEqual(model['Alpha'], 1)
                self.assertEqual(model['Robot Description'].lstrip('/'), 'robot_description')
                self.assertEqual(model['TF Prefix'], '')
                self.assertTrue(model['Links']['All Links Enabled'])

    def test_slam_preserves_map_scan_and_position_axes(self):
        manager = self.config('slam')
        displays = {item['Class']: item for item in manager['Displays']}
        self.assertEqual(manager['Global Options']['Fixed Frame'], 'map')
        for kind, topic in (('rviz/Map', '/map'), ('rviz/LaserScan', '/scan')):
            self.assertTrue(displays[kind]['Enabled'])
            self.assertEqual(displays[kind]['Topic'], topic)
        self.assertTrue(displays['rviz/Axes']['Enabled'])
        self.assertEqual(displays['rviz/Axes']['Reference Frame'], 'base_footprint')

    def test_slam_tools_remain_observation_only(self):
        tools = {item['Class'] for item in self.config('slam')['Tools']}
        self.assertEqual(tools, {'rviz/Interact', 'rviz/MoveCamera',
                                 'rviz/Select', 'rviz/Measure'})

    def test_navigation_pose_and_goal_topics_are_unchanged(self):
        tools = {item['Class']: item for item in self.config('navigation')['Tools']}
        self.assertEqual(tools['rviz/SetInitialPose']['Topic'], '/initialpose')
        self.assertEqual(tools['rviz/SetGoal']['Topic'], '/move_base_simple/goal')

    def test_navigation_start_pose_marker_is_observation_only(self):
        markers = [item for item in self.config('navigation')['Displays']
                   if item['Class'] == 'rviz/MarkerArray']
        self.assertEqual(len(markers), 1)
        self.assertTrue(markers[0]['Enabled'])
        self.assertEqual(markers[0]['Marker Topic'], '/navigation/start_pose')

    def test_launchers_only_start_viewer_with_matching_config(self):
        for mode in ('slam', 'navigation'):
            with self.subTest(mode=mode):
                launch = ET.parse(str(BASE / (mode + '-view.launch'))).getroot()
                self.assertEqual([child.tag for child in launch], ['node'])
                node = launch.find('node')
                self.assertEqual((node.get('pkg'), node.get('type')), ('rviz', 'rviz'))
                self.assertEqual(node.get('args'), '-d /pc-rviz/' + mode + '.rviz')


if __name__ == '__main__':
    unittest.main()