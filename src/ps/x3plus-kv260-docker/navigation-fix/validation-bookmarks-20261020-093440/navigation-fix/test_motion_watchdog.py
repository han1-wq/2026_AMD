"""Run real driver methods with an inert serial transport (no ROS/hardware)."""
import ast
import math
from pathlib import Path
import threading
from types import SimpleNamespace
import unittest
from unittest.mock import Mock

SOURCE = Path(__file__).resolve().parents[1] / 'context/src/yahboomcar_bringup/scripts/Mcnamu_X3plus.py'


class Twist:
    def __init__(self, x=0., y=0., angular=0.):
        self.linear = SimpleNamespace(x=x, y=y)
        self.angular = SimpleNamespace(z=angular)


class WatchdogTests(unittest.TestCase):
    def setUp(self):
        tree = ast.parse(SOURCE.read_text())
        tree.body = [node for node in tree.body if isinstance(node, ast.ClassDef)]
        namespace = {'math': math, 'Twist': Twist}
        exec(compile(tree, str(SOURCE), 'exec'), namespace)
        cls = namespace['yahboomcar_driver']
        self.driver = cls.__new__(cls)
        self.driver.car = Mock()
        self.driver.motion_lock = threading.RLock()
        self.driver.motion_stop = threading.Event()
        self.now = 100.
        self.driver.motion_clock = lambda: self.now
        self.driver.last_motion = 0.

    def test_recent_command_passes_then_timeout_sends_zero(self):
        self.driver.cmd_vel_callback(Twist(.2, -.1, .3))
        self.driver.car.set_car_motion.assert_called_with(.2, -.1, .3)
        self.driver.car.reset_mock()
        self.now += .49
        self.driver.motion_watchdog_step()
        self.driver.car.set_car_motion.assert_not_called()
        self.now += .02
        self.driver.motion_watchdog_step()
        self.driver.car.set_car_motion.assert_called_once_with(0, 0, 0)

    def test_invalid_command_stops_instead_of_reaching_serial(self):
        for value in (float('nan'), float('inf'), float('-inf')):
            self.driver.cmd_vel_callback(Twist(value))
            self.driver.car.set_car_motion.assert_called_with(0, 0, 0)
            self.assertEqual(self.driver.last_motion, 0.)

    def test_clock_reset_and_no_command_both_stop(self):
        self.driver.motion_watchdog_step()
        self.driver.car.set_car_motion.assert_called_with(0, 0, 0)
        self.driver.cmd_vel_callback(Twist(.1))
        self.now = 50.
        self.driver.motion_watchdog_step()
        self.driver.car.set_car_motion.assert_called_with(0, 0, 0)

    def test_shutdown_rejects_queued_commands(self):
        self.driver.motion_stop.set()
        self.driver.cmd_vel_callback(Twist(.2))
        self.driver.car.set_car_motion.assert_called_with(0, 0, 0)


if __name__ == '__main__':
    unittest.main()