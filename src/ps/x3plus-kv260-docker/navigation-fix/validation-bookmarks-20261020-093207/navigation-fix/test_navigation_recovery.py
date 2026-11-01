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
        # Legacy-policy cases remain useful with explicit parameter overrides.
        g.initial_stable_seconds = 2.
        g.quality_fault_seconds, g.quality_clear_seconds = 0., .5
        g.quality_fault_since = g.quality_good_since = None
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

    def relaxed_defaults(self):
        """Use actual production parameter defaults, not duplicated test values."""
        tree = ast.parse(SOURCE.read_text())
        for node in ast.walk(tree):
            if (isinstance(node, ast.Assign) and isinstance(node.value, ast.Call)
                    and isinstance(node.value.func, ast.Attribute)
                    and node.value.func.attr == 'get_param'):
                setattr(self.guard, node.targets[0].attr, ast.literal_eval(node.value.args[1]))

    def test_short_quality_noise_preserves_attempt_and_velocity(self):
        self.relaxed_defaults()
        g = self.guard
        for reason in ('scan_map_mismatch', 'high_pose_uncertainty',
                       'scan_ray_obstructed', 'insufficient_scan_returns'):
            g.update_readiness(reason, 10., 10.)
            g.update_readiness(reason, 10.7, 10.7)
            self.assertTrue(g.ready)
            self.assertEqual(g.reason, 'quality_warning')
            self.assertEqual(g.command, 'old-nonzero-speed')
            g.update_readiness('', 10.71, 10.71)
            g.update_readiness('', 11.3, 11.3)
            self.assertIsNone(g.quality_fault_since)
        g.client.cancel_all_goals.assert_not_called()
        self.assertEqual(g.localization_epoch, 0)

    def test_sustained_quality_failure_pauses_retained_task(self):
        self.relaxed_defaults()
        g = self.guard
        g.task_active = True
        g.update_readiness('scan_map_mismatch', 10., 10.)
        g.update_readiness('scan_map_mismatch', 10.81, 10.81)
        self.assertFalse(g.ready)
        self.assertTrue(g.task_paused)
        self.assertIsNotNone(g.initial)
        self.assertEqual(g.command, 'zero')
        self.assertAlmostEqual(g.resume_deadline, 25.81)
        g.client.cancel_all_goals.assert_called_once_with()

    def test_alternating_quality_reasons_and_single_good_frames_do_not_evade_stop(self):
        self.relaxed_defaults()
        g = self.guard
        for reason, wall in [('scan_map_mismatch', 10.), ('', 10.2),
                             ('insufficient_scan_returns', 10.4), ('', 10.6),
                             ('high_pose_uncertainty', 10.9)]:
            g.update_readiness(reason, wall, wall)
        self.assertFalse(g.ready)
        self.assertEqual(g.command, 'zero')

    def test_sparse_scans_are_not_accepted_as_recovery_evidence(self):
        self.relaxed_defaults()
        g = self.guard
        g.update_readiness('insufficient_scan_returns', 10., 10.)
        g.update_readiness('insufficient_scan_returns', 10.81, 10.81)
        for wall in (11., 15., 25.):
            g.update_readiness('insufficient_scan_returns', wall, wall)
            self.assertFalse(g.ready)
            self.assertIsNotNone(g.initial)
        g.update_readiness('insufficient_scan_returns', 25.82, 25.82)
        self.assertIsNone(g.initial)

    def test_stale_data_and_hard_faults_bypass_pending_quality_warning(self):
        for reason in ('stale_scan', 'stale_tf', 'stale_amcl_pose',
                       'localization_jump', 'invalid_pose_covariance', 'invalid_scan_or_tf: invalid_scan'):
            with self.subTest(reason=reason):
                self.setUp()
                self.relaxed_defaults()
                g = self.guard
                g.update_readiness('scan_map_mismatch', 10., 10.)
                g.update_readiness(reason, 10.1, 10.1)
                self.assertFalse(g.ready)
                self.assertEqual(g.command, 'zero')
                self.assertIsNone(g.quality_fault_since)

    def test_initial_confirmation_remains_strict_and_needs_two_seconds(self):
        self.relaxed_defaults()
        g = self.guard
        g.confirmed = g.ready = False
        g.update_readiness('insufficient_scan_returns', 10., 10.)
        self.assertFalse(g.ready)
        g.update_readiness('', 11., 11.)
        g.update_readiness('', 12.1, 12.1)
        self.assertFalse(g.ready)
        g.update_readiness('', 13.01, 13.01)
        self.assertTrue(g.ready)

    def test_default_recovery_is_one_second_within_fifteen(self):
        self.relaxed_defaults()
        g = self.guard
        g.update_readiness('stale_scan', 10., 10.)
        g.update_readiness('stale_scan', 20., 20.)
        self.assertIsNotNone(g.initial)
        g.update_readiness('', 20.1, 20.1)
        g.update_readiness('', 21., 21.)
        self.assertFalse(g.ready)
        g.update_readiness('', 21.11, 21.11)
        self.assertTrue(g.ready)

    def test_recovery_oscillation_still_has_bounded_deadline(self):
        self.relaxed_defaults()
        g = self.guard
        g.update_readiness('stale_scan', 10., 10.)
        for wall in range(11, 25):
            g.update_readiness('', float(wall), float(wall))
            g.update_readiness('scan_map_mismatch', wall+.2, wall+.2)
            self.assertFalse(g.ready)
        g.update_readiness('', 25., 25.)
        self.assertIsNone(g.initial)

    def test_default_resume_limit_allows_five_not_unlimited(self):
        self.relaxed_defaults()
        g = self.guard
        self.assertEqual(g.max_auto_resumes, 5)
        g.task_active = True
        g.resume_count = 5
        g.update_readiness('stale_scan', 10., 10.)
        self.assertFalse(g.task_active)
        self.assertEqual(g.task_reason, 'automatic_resume_limit')

    def test_cancel_during_quality_warning_does_not_restart_task(self):
        self.relaxed_defaults()
        g = self.guard
        def step():
            g.update_readiness('scan_map_mismatch', self.now, self.now)
            g.server.is_preempt_requested.return_value = True
            g.client.get_state.return_value = 3
        self.on_step = step
        g.execute(self.goal)
        self.assertEqual(g.client.send_goal.call_count, 1)
        self.assertFalse(g.task_active)
        g.server.set_succeeded.assert_not_called()
        g.server.set_preempted.assert_called_once()

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

    def test_stale_velocity_activation_and_feedback_cannot_enter_new_attempt(self):
        g = self.guard
        g.task_active = True
        g.task_epoch, g.localization_epoch, g.active_epoch = 2, 4, 4
        command = SimpleNamespace(linear=SimpleNamespace(x=.2, y=0., z=0.),
                                  angular=SimpleNamespace(x=0., y=0., z=.3))
        g.command = 'zero'
        g.on_cmd(command, 3)
        g.activate_attempt(1, 3)
        g.forward_feedback(1, 3, 'stale')
        self.assertEqual(g.command, 'zero')
        self.assertEqual(g.active_epoch, 4)
        g.server.publish_feedback.assert_not_called()
        g.on_cmd(command, 4)
        self.assertIs(g.command, command)

    def test_persistent_fault_terminates_retained_task(self):
        g = self.guard
        def step():
            g.update_readiness('stale_scan', self.now, self.now)
        self.on_step = step
        g.execute(self.goal)
        self.assertEqual(g.client.send_goal.call_count, 1)
        self.assertFalse(g.task_active)
        self.assertIsNone(g.initial)
        g.server.set_aborted.assert_called_once()

    def test_map_change_and_amcl_restart_terminate_paused_task(self):
        for reason in ('map_changed_initial_pose_required', 'amcl_restarted_initial_pose_required'):
            with self.subTest(reason=reason):
                self.setUp()
                g = self.guard
                def step():
                    self.transient()
                    g.invalidate(reason)
                self.on_step = step
                g.execute(self.goal)
                self.assertEqual(g.client.send_goal.call_count, 1)
                g.server.set_aborted.assert_called_once()

    def test_replacement_during_pause_only_forwards_new_destination(self):
        g = self.guard
        def replace():
            g.update_readiness('stale_scan', self.now, self.now)
            g.server.is_preempt_requested.return_value = True
            g.client.get_state.return_value = 2
        self.on_step = replace
        g.execute(self.goal)
        g.server.set_preempted.assert_called_once()
        new_goal = copy.deepcopy(self.goal)
        new_goal.target_pose.pose.position.x = 8.
        g.server.is_preempt_requested.return_value = False
        self.steps = 0
        def recover():
            if self.steps == 1:
                g.update_readiness('', self.now, self.now)
                self.now += 2.1
                g.update_readiness('', self.now, self.now)
            else:
                g.client.get_state.return_value = 3
        self.on_step = recover
        g.execute(new_goal)
        self.assertEqual(g.client.send_goal.call_count, 2)
        self.assertEqual(g.client.send_goal.call_args.args[0].target_pose.pose.position.x, 8.)
        g.server.set_succeeded.assert_called_once()

    def test_zero_resume_limit_aborts_on_first_fault(self):
        g = self.guard
        g.max_auto_resumes = 0
        self.on_step = lambda: g.update_readiness('stale_tf', self.now, self.now)
        g.execute(self.goal)
        self.assertEqual(g.client.send_goal.call_count, 1)
        self.assertEqual(g.task_reason, 'automatic_resume_limit')

    def test_lost_planner_is_not_a_cancellation_ack(self):
        g = self.guard
        self.on_step = lambda: self.transient(terminal=9)
        g.execute(self.goal)
        self.assertEqual(g.client.send_goal.call_count, 1)
        self.assertEqual(g.task_reason, 'planner action lost')


if __name__ == '__main__':
    unittest.main()