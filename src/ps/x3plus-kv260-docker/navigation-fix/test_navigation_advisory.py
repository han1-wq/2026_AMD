"""Default quality policy: warnings must not cancel navigation or latch goals."""
import unittest

from test_navigation_recovery import NavigationRecoveryTests as Fixture


class AdvisoryPolicyTests(unittest.TestCase):
    def setUp(self):
        Fixture.setUp(self)
        Fixture.relaxed_defaults(self)
        self.guard.quality_interlock = False

    def test_production_default_disables_quality_interlock(self):
        Fixture.relaxed_defaults(self)
        # relaxed_defaults explicitly opts into legacy behavior for its suite.
        import ast
        from test_navigation_recovery import SOURCE
        tree = ast.parse(SOURCE.read_text())
        values = [node.value.args[1] for node in ast.walk(tree)
                  if isinstance(node, ast.Assign) and isinstance(node.targets[0], ast.Attribute)
                  and node.targets[0].attr == 'quality_interlock']
        self.assertIs(ast.literal_eval(values[0]), False)

    def test_persistent_quality_faults_do_not_stop_cancel_or_consume_retries(self):
        g = self.guard
        g.task_active = True
        for reason in ('scan_map_mismatch', 'high_pose_uncertainty',
                       'scan_ray_obstructed', 'insufficient_scan_returns',
                       'stale_amcl_pose', 'localization_jump'):
            for wall in (10., 11., 26., 100.):
                g.update_readiness(reason, wall, wall)
                self.assertTrue(g.ready, reason)
                self.assertTrue(g.task_active)
                self.assertFalse(g.task_paused)
                self.assertEqual(g.command, 'old-nonzero-speed')
        self.assertEqual(g.resume_count, 0)
        self.assertIsNone(g.fault_since)
        g.client.cancel_all_goals.assert_not_called()
        g.output.publish.assert_not_called()

    def test_quality_warning_during_execute_keeps_one_attempt_until_success(self):
        g = self.guard
        def step():
            g.update_readiness('scan_map_mismatch', self.now, self.now)
            if self.steps == 60:
                g.client.get_state.return_value = 3
        self.on_step = step
        g.execute(self.goal)
        self.assertEqual(g.client.send_goal.call_count, 1)
        g.server.set_succeeded.assert_called_once()
        self.assertEqual(g.resume_count, 0)

    def test_initial_confirmation_still_rejects_bad_quality(self):
        g = self.guard
        g.confirmed = g.ready = False
        for wall in (10., 15., 30.):
            g.update_readiness('scan_map_mismatch', wall, wall)
            self.assertFalse(g.ready)
        g.update_readiness('', 31., 31.)
        g.update_readiness('', 33.1, 33.1)
        self.assertTrue(g.ready)

    def test_sensor_loss_stops_immediately_and_recovers_without_initial_pose(self):
        for reason in ('stale_scan', 'stale_tf', 'invalid_scan_or_tf: missing transform'):
            with self.subTest(reason=reason):
                self.setUp()
                g = self.guard
                g.task_active = True
                g.update_readiness(reason, 10., 10.)
                self.assertFalse(g.ready)
                self.assertTrue(g.task_paused)
                self.assertEqual(g.command, 'zero')
                g.client.cancel_all_goals.assert_called_once()
                g.update_readiness(reason, 26., 26.)
                self.assertFalse(g.task_active)
                self.assertEqual(g.task_reason, 'sensor_recovery_timeout')
                self.assertTrue(g.confirmed)
                self.assertIsNotNone(g.initial)
                g.update_readiness('scan_map_mismatch', 27., 27.)
                g.update_readiness('scan_map_mismatch', 28.1, 28.1)
                self.assertTrue(g.ready)
                self.assertFalse(g.task_active)  # Expired task cannot resume itself.

    def test_new_goal_after_sensor_timeout_reaches_planner_without_reinitialization(self):
        g = self.guard
        def fail():
            g.update_readiness('stale_scan', self.now, self.now)
            self.now += 16.
            g.update_readiness('stale_scan', self.now, self.now)
        self.on_step = fail
        g.execute(self.goal)
        g.server.set_aborted.assert_called_once()
        self.assertIsNotNone(g.initial)
        g.update_readiness('', self.now, self.now)
        self.now += 1.1
        g.update_readiness('', self.now, self.now)
        # A new goal arrives after confirmation, with ROS and wall clocks aligned.
        # The fixture otherwise keeps ROS time at 10 while wall time reaches 27.
        from types import SimpleNamespace
        self.now += .01
        stamp = self.now
        self.rospy.Time.now = lambda: SimpleNamespace(to_sec=lambda: stamp)
        self.goal.target_pose.header.stamp = self.rospy.Time.now()
        self.steps = 0
        g.client.get_state.return_value = 3
        self.on_step = lambda: None
        g.execute(self.goal)
        self.assertEqual(g.client.send_goal.call_count, 2)
        g.server.set_succeeded.assert_called_once()

    def test_quality_warning_cannot_hide_later_laser_loss(self):
        g = self.guard
        g.task_active = True
        g.update_readiness('scan_ray_obstructed', 10., 10.)
        self.assertTrue(g.ready)
        g.update_readiness('stale_scan', 10.1, 10.1)
        self.assertFalse(g.ready)
        self.assertTrue(g.task_paused)
        self.assertEqual(g.command, 'zero')
        g.client.cancel_all_goals.assert_called_once()
        g.output.publish.assert_called_with('zero')

    def test_manual_stop_and_nonrecoverable_faults_still_cancel(self):
        for reason in ('invalid_amcl_pose', 'invalid_pose_covariance'):
            with self.subTest(reason=reason):
                self.setUp()
                g = self.guard
                g.task_active = True
                g.update_readiness(reason, 10., 10.)
                self.assertFalse(g.ready)
                self.assertIsNone(g.initial)
                self.assertFalse(g.task_active)
        self.setUp()
        self.guard.task_active = True
        self.guard.stop(None)
        self.assertFalse(self.guard.task_active)
        self.assertEqual(self.guard.command, 'zero')


if __name__ == '__main__':
    unittest.main()