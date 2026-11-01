"""Run the production interlock state machine with deterministic time, no ROS."""
import ast
import copy
from collections import deque
import math
from pathlib import Path
import threading
from types import SimpleNamespace
import unittest
from unittest.mock import Mock

SOURCE = Path(__file__).resolve().parents[1]/'context/src/yahboomcar_nav/scripts/navigation_guard.py'


class NavigationRecoveryTests(unittest.TestCase):
    def setUp(self):
        tree = ast.parse(SOURCE.read_text())
        tree.body = [node for node in tree.body if isinstance(node, ast.ClassDef)]
        self.rospy = SimpleNamespace(is_shutdown=lambda: False, Duration=lambda value: value)
        self.rospy.Subscriber = Mock()
        self.rospy.Time = SimpleNamespace(now=lambda: SimpleNamespace(to_sec=lambda: 10.))
        self.now = 10.
        self.steps = 0
        self.on_step = lambda: None
        def sleep(_):
            self.steps += 1
            if self.steps > 300:
                raise AssertionError('Execute did not terminate within bounded fake time')
            self.now += .05
            self.on_step()
        namespace = {'Twist': lambda: 'zero', 'TriggerResponse': lambda *args: args,
                     'MoveBaseResult': Mock, 'rospy': self.rospy,
                      'copy': copy, 'time': SimpleNamespace(time=lambda: self.now, sleep=sleep),
                      'yaw': lambda _: 0.,
                     'finite': lambda values: all(math.isfinite(v) for v in values),
                      'GoalStatus': SimpleNamespace(PREEMPTED=2, SUCCEEDED=3, ABORTED=4,
                                                    REJECTED=5, RECALLED=8, LOST=9)}
        exec(compile(tree, str(SOURCE), 'exec'), namespace)
        self.guard = namespace['NavigationGuard'].__new__(namespace['NavigationGuard'])
        g = self.guard
        g.lock = threading.RLock()
        g.initial = (0., 0., 0.)
        g.initial_time = 1.
        g.confirmed = g.ready = True
        g.confirmed_time = 2.
        g.good_since = 1.
        g.fault_since = None
        g.stable_seconds, g.transient_timeout = 2., 5.
        g.localization_epoch = 0
        g.active_epoch = 0
        g.task_epoch = 0
        g.task_active = g.task_paused = False
        g.task_state, g.task_reason = 'idle', ''
        g.resume_count, g.max_auto_resumes = 0, 2
        g.resume_deadline = None
        g.planner_outstanding = False
        g.last_motion_cmd = 0.
        g.cmd_sub = Mock()
        g.planner_events = deque()
        g.previous_correction = (0., 0., 0.)
        g.command, g.last_cmd = 'old-nonzero-speed', 9.
        g.output, g.ready_pub, g.client, g.server = Mock(), Mock(), Mock(), Mock()
        g.reason = 'ready'
        g.server.is_preempt_requested.return_value = False
        g.client.get_state.return_value = 1
        g.client.send_goal.side_effect = lambda goal, active_cb, feedback_cb: active_cb()
        self.goal = SimpleNamespace(target_pose=SimpleNamespace(header=SimpleNamespace(
            frame_id='map', stamp=SimpleNamespace(to_sec=lambda: 9.)),
            pose=SimpleNamespace(position=SimpleNamespace(x=1., y=1.), orientation=None)))

    def test_transient_covariance_stops_and_requires_stable_recovery(self):
        g = self.guard
        g.update_readiness('high_pose_uncertainty', 10., 10.)
        self.assertFalse(g.ready)
        self.assertTrue(g.confirmed)
        self.assertIsNotNone(g.initial)
        g.client.cancel_all_goals.assert_called_once_with()
        g.output.publish.assert_called_once_with('zero')
        self.assertEqual(g.last_cmd, 0.)
        self.assertEqual(g.command, 'zero')
        g.update_readiness('', 10.2, 10.2)
        g.update_readiness('', 12.19, 12.19)
        self.assertFalse(g.ready)
        g.update_readiness('', 12.21, 12.21)
        self.assertTrue(g.ready)
        self.assertIsNone(g.fault_since)
        self.assertEqual(g.confirmed_time, 12.21)
        g.client.send_goal.assert_not_called()

    def test_flapping_health_resets_stability_and_eventually_latches(self):
        g = self.guard
        for reason, wall in [('stale_scan', 10.), ('', 10.1), ('stale_tf', 11.9),
                             ('', 12.), ('high_pose_uncertainty', 13.9), ('', 14.), ('', 15.)]:
            g.update_readiness(reason, wall, wall)
            self.assertFalse(g.ready)
        self.assertIsNone(g.initial)
        self.assertIn('initial_pose_required', g.reason)

    def test_timeout_cannot_be_cleared_by_one_late_good_tick(self):
        g = self.guard
        g.update_readiness('stale_scan', 10., 10.)
        g.update_readiness('', 10.1, 10.1)
        g.update_readiness('', 15.1, 15.1)
        self.assertFalse(g.ready)
        self.assertIsNone(g.initial)

    def test_sustained_uncertainty_latches_even_when_covariance_recovers(self):
        g = self.guard
        g.update_readiness('high_pose_uncertainty', 10., 10.)
        g.update_readiness('high_pose_uncertainty', 15., 15.)
        g.update_readiness('', 20., 20.)
        self.assertFalse(g.ready)
        self.assertIsNone(g.initial)
        self.assertEqual(g.reason, 'high_pose_uncertainty_initial_pose_required')

    def test_localization_jump_latches_during_transient_recovery(self):
        g = self.guard
        g.update_readiness('stale_tf', 10., 10.)
        g.update_readiness('localization_jump', 10.2, 10.2)
        self.assertFalse(g.confirmed)
        self.assertIsNone(g.initial)
        self.assertEqual(g.reason, 'localization_jump_initial_pose_required')

    def test_cold_start_never_confirms_without_initial_pose(self):
        g = self.guard
        g.invalidate('initial_pose_required')
        g.update_readiness('', 10., 10.)
        g.update_readiness('', 20., 20.)
        self.assertFalse(g.ready)
        self.assertFalse(g.confirmed)

    def test_same_session_stop_preserves_pose_and_does_not_restart_goals(self):
        g = self.guard
        pose = g.initial
        self.assertTrue(g.stop(None)[0])
        self.assertTrue(g.ready)
        self.assertIs(g.initial, pose)
        self.assertEqual(g.localization_epoch, 1)
        self.assertEqual(g.confirmed_time, 10.)
        g.client.cancel_all_goals.assert_called_once_with()
        g.client.send_goal.assert_not_called()

    def test_manual_reset_still_revokes_confirmation(self):
        g = self.guard
        g.reset(None)
        self.assertIsNone(g.initial)
        self.assertFalse(g.ready)

    def test_planner_velocity_after_session_stop_cannot_restart_motion(self):
        g = self.guard
        g.stop(None)
        g.server.is_active.return_value = True
        command = SimpleNamespace(linear=SimpleNamespace(x=.2, y=0., z=0.),
                                  angular=SimpleNamespace(x=0., y=0., z=.3))
        g.on_cmd(command)
        self.assertEqual(g.command, 'zero')
        self.assertEqual(g.last_cmd, 0.)

    def test_cancelled_epoch_cannot_report_success_after_recovery(self):
        g = self.guard
        def cancelled_result():
            g.stop(None)
            g.client.get_state.return_value = 3
        self.on_step = cancelled_result
        g.execute(self.goal)
        g.server.set_succeeded.assert_not_called()
        g.server.set_preempted.assert_called_once()

    def transient(self, terminal=2):
        g = self.guard
        g.update_readiness('stale_scan', self.now, self.now)
        self.assertTrue(g.task_paused)
        self.assertEqual(g.command, 'zero')
        g.client.get_state.return_value = terminal
        g.update_readiness('', self.now+.1, self.now+.1)
        self.now += 2.2
        g.update_readiness('', self.now, self.now)
        self.assertTrue(g.ready)

    def test_one_public_goal_resumes_with_same_pose_and_ignores_cancelled_success(self):
        g = self.guard
        def step():
            if self.steps == 1:
                self.transient(terminal=3)  # Old attempt succeeded during cancellation.
            else:
                g.client.get_state.return_value = 3
        self.on_step = step
        g.execute(self.goal)
        self.assertEqual(g.client.send_goal.call_count, 2)
        for call in g.client.send_goal.call_args_list:
            self.assertEqual(call.args[0].target_pose.pose, self.goal.target_pose.pose)
        self.assertEqual(g.resume_count, 1)
        g.server.set_succeeded.assert_called_once()

    def test_cancel_stop_reset_and_jump_during_pause_never_resume(self):
        for action in ('cancel', 'stop', 'reset', 'jump'):
            with self.subTest(action=action):
                self.setUp()
                g = self.guard
                def step():
                    g.update_readiness('stale_scan', self.now, self.now)
                    if action == 'cancel':
                        g.server.is_preempt_requested.return_value = True
                    elif action == 'jump':
                        g.update_readiness('localization_jump', self.now, self.now)
                    else:
                        getattr(g, action)(None)
                    g.client.get_state.return_value = 3
                self.on_step = step
                g.execute(self.goal)
                self.assertEqual(g.client.send_goal.call_count, 1)
                g.server.set_succeeded.assert_not_called()
                self.assertFalse(g.task_active)

    def test_resume_waits_for_terminal_ack_and_rejects_late_velocity(self):
        g = self.guard
        command = SimpleNamespace(linear=SimpleNamespace(x=.2, y=0., z=0.),
                                  angular=SimpleNamespace(x=0., y=0., z=.3))
        def step():
            if self.steps == 1:
                self.transient(terminal=1)
            elif self.steps < 5:
                g.on_cmd(command)
                self.assertEqual(g.command, 'zero')
                self.assertEqual(g.client.send_goal.call_count, 1)
            elif self.steps < 12:
                g.client.get_state.return_value = 2
            else:
                g.client.get_state.return_value = 3
        self.on_step = step
        g.execute(self.goal)
        self.assertEqual(g.client.send_goal.call_count, 2)
        old_callback = g.client.send_goal.call_args_list[0].kwargs['active_cb']
        old_callback()
        self.assertIsNone(g.active_epoch)

    def test_unacknowledged_cancel_times_out_instead_of_resuming(self):
        g = self.guard
        self.on_step = lambda: self.transient(terminal=1) if self.steps == 1 else None
        g.execute(self.goal)
        self.assertEqual(g.client.send_goal.call_count, 1)
        g.server.set_aborted.assert_called_once()
        self.assertEqual(g.task_reason, 'automatic_resume_timeout')

    def test_repeated_dropouts_have_bounded_resume_count(self):
        g = self.guard
        def step():
            g.update_readiness('stale_scan', self.now, self.now)
            g.client.get_state.return_value = 2
            g.update_readiness('', self.now+.1, self.now+.1)
            self.now += 2.2
            g.update_readiness('', self.now, self.now)
        self.on_step = step
        g.execute(self.goal)
        self.assertEqual(g.client.send_goal.call_count, 3)
        self.assertEqual(g.resume_count, 2)
        self.assertEqual(g.task_reason, 'automatic_resume_limit')
        g.server.set_aborted.assert_called_once()

    def test_planner_abort_is_not_automatically_retried(self):
        g = self.guard
        g.client.get_state.return_value = 4
        g.execute(self.goal)
        self.assertEqual(g.client.send_goal.call_count, 1)
        g.server.set_aborted.assert_called_once()


if __name__ == '__main__':
    unittest.main()