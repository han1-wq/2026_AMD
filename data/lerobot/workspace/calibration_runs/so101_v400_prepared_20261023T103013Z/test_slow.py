import copy
import json
import signal
import tempfile
import time
import unittest
from pathlib import Path
from unittest.mock import patch

import calibrate_slow as target


class FakeBus:
    def __init__(self, before):
        self.values = {name: copy.deepcopy(data['registers']) for name, data in before.items()}
        self.writes = []
        self.is_connected = True
        self.fail_read = None
        self.fail_write = None
        self.ignore_write = None
        self.calibration_writes = []

    def read(self, register, name, *args, **kwargs):
        if self.fail_read == (register, name):
            raise RuntimeError('Overload error!')
        return self.values[name][register]

    def write(self, register, name, value, *args, **kwargs):
        self.writes.append((register, name, value))
        if self.fail_write == (register, name):
            raise RuntimeError('Overload error!')
        if self.ignore_write == (register, name):
            return
        self.values[name][register] = value

    def write_calibration(self, calibration, *args, **kwargs):
        self.calibration_writes.append(calibration)

    def disconnect(self, disable_torque=False):
        self.is_connected = False


class GuardTests(unittest.TestCase):
    def setUp(self):
        self.before = json.loads(Path('/run_artifacts/offline_before_fixture.json').read_text())
        self.bus = FakeBus(self.before)
        target.install_guards(self.bus, self.before)
        self.previous_handler = signal.signal(signal.SIGALRM, target.abort)

    def tearDown(self):
        signal.setitimer(signal.ITIMER_REAL, 0)
        signal.signal(signal.SIGALRM, self.previous_handler)

    def test_readonly_health_checks(self):
        target.verify_health(self.bus, self.before)
        self.assertEqual(self.bus.writes, [])

    def test_speed_limit_latches(self):
        self.bus.write('Goal_Velocity', 'elbow_flex', 400)
        with self.assertRaises(target.MotionFault):
            self.bus.write('Goal_Velocity', 'elbow_flex', 401)
        with self.assertRaises(target.MotionFault):
            self.bus.write('Torque_Enable', 'elbow_flex', 1)
        self.assertEqual(self.bus.writes, [('Goal_Velocity', 'elbow_flex', 400)])

    def test_negative_speed_limit(self):
        with self.assertRaises(target.MotionFault):
            self.bus.write('Goal_Velocity', 'shoulder_lift', -401)

    def test_torque_caps(self):
        for name in target.EXPECTED:
            for register in ['Torque_Limit', 'Max_Torque_Limit']:
                self.bus.write(register, name, 1000)
                self.assertEqual(self.bus.values[name][register], 300 if name in ['gripper', 'wrist_roll'] else 600)

    def test_protections_preserved(self):
        for name in target.EXPECTED:
            for register in ['Overload_Torque', 'Protection_Current', 'Protection_Time',
                             'Protective_Torque', 'Unloading_Condition', 'Over_Current_Protection_Time']:
                self.bus.write(register, name, 255)
                self.assertEqual(self.bus.values[name][register], self.before[name]['registers'][register])

    def test_unexpected_position_mode_enable_blocked(self):
        with self.assertRaises(target.MotionFault):
            self.bus.write('Torque_Enable', 'shoulder_lift', 1)
        self.assertEqual(self.bus.writes, [])

    def test_velocity_mode_enable_allowed(self):
        self.bus.write('Operating_Mode', 'elbow_flex', 1)
        self.bus.write('Torque_Enable', 'elbow_flex', 1)
        self.assertEqual(self.bus.values['elbow_flex']['Torque_Enable'], 1)

    def test_stale_velocity_enable_blocked(self):
        self.bus.values['shoulder_lift'].update(Operating_Mode=1, Goal_Velocity=150)
        with self.assertRaises(target.MotionFault):
            self.bus.write('Torque_Enable', 'shoulder_lift', 1)

    def test_position_command_blocked(self):
        with self.assertRaises(target.MotionFault):
            self.bus.write('Goal_Position', 'shoulder_lift', 2048)

    def test_acceleration_change_blocked(self):
        with self.assertRaises(target.MotionFault):
            self.bus.write('Acceleration', 'shoulder_lift', 254)

    def test_read_overload_latches_and_not_runtimeerror(self):
        self.bus.fail_read = ('Present_Position', 'shoulder_lift')
        with self.assertRaises(target.MotionFault) as raised:
            self.bus.read('Present_Position', 'shoulder_lift')
        self.assertNotIsInstance(raised.exception, RuntimeError)
        with self.assertRaises(target.MotionFault):
            self.bus.write('Goal_Velocity', 'elbow_flex', 150)

    def test_write_overload_latches(self):
        self.bus.fail_write = ('Goal_Velocity', 'shoulder_lift')
        with self.assertRaises(target.MotionFault):
            self.bus.write('Goal_Velocity', 'shoulder_lift', 0)
        self.assertTrue(self.bus.motion_fault)

    def test_temperature_voltage_status_trip(self):
        for register, value in [('Status', 32), ('Present_Temperature', 50), ('Present_Voltage', 255)]:
            bus = FakeBus(self.before)
            target.install_guards(bus, self.before)
            bus.values['shoulder_lift'][register] = value
            with self.assertRaises(target.MotionFault):
                bus.read('Present_Position', 'elbow_flex')
            self.assertTrue(bus.motion_fault)

    def test_upstream_exploration_aborts_overload(self):
        self.bus.fail_read = ('Present_Position', 'shoulder_lift')
        cfg = target.auto.AutoCalibrateConfig(robot=None, explore_velocity=target.SPEED_LIMIT)
        with self.assertRaises(target.MotionFault):
            target.auto.explore_literal_limit(self.bus, 'shoulder_lift', target.auto.Direction.ANTI_CLOCKWISE, cfg)
        self.assertEqual(self.bus.writes, [])

    def test_recovery_uses_same_speed(self):
        cfg = target.auto.AutoCalibrateConfig(robot=None, explore_velocity=target.SPEED_LIMIT)
        with patch.object(target.auto, 'explore_literal_limit') as explore:
            for name in target.EXPECTED:
                target.auto.run_matching_actions(self.bus, name, target.auto.POST_CALIBRATION_ACTIONS, cfg)
            self.assertEqual(explore.call_count, 3)
            self.assertTrue(all(call.args[3].explore_velocity == 400 for call in explore.call_args_list))

    def test_phase_and_overall_watchdogs(self):
        deadline = time.monotonic() + 0.3
        self.assertEqual(target.bounded(lambda: 7, 0.1, deadline)(), 7)
        remaining, _ = signal.getitimer(signal.ITIMER_REAL)
        self.assertGreater(remaining, 0)
        with self.assertRaises(target.WatchdogAbort):
            target.bounded(lambda: time.sleep(1), 0.02, deadline)()
        with self.assertRaises(target.WatchdogAbort):
            target.bounded(lambda: None, 1, time.monotonic() - 1)()

    def test_cleanup_operation_times_out(self):
        with self.assertRaises(TimeoutError):
            target.cleanup_call(time.sleep, time.monotonic() + 0.02, 1)

    def test_shutdown_bypasses_fault_and_verifies(self):
        self.bus.motion_fault = 'latched overload'
        with tempfile.TemporaryDirectory() as directory, patch.object(target, 'ARTIFACTS', Path(directory)):
            errors = target.shutdown(self.bus, self.before)
            self.assertEqual(errors, [])
            state = json.loads((Path(directory) / 'stopped.json').read_text())
            self.assertEqual(len(state), 6)
            self.assertTrue(all(v == 0 for regs in state.values() for v in regs.values()))
            self.assertTrue((Path(directory) / 'after.json').exists())
            self.assertFalse(self.bus.is_connected)

    def test_stop_continues_after_one_motor_error(self):
        bus = FakeBus(self.before)
        bus.fail_write = ('Torque_Enable', 'shoulder_lift')
        errors = target.safe_stop(bus, time.monotonic() + 3)
        self.assertEqual(len(errors), 1)
        self.assertEqual(len(bus.writes), 18)
        self.assertEqual([r for r, n, v in bus.writes[:6]], ['Torque_Enable'] * 6)

    def test_cleanup_never_switches_mode_if_torque_off_failed(self):
        bus = FakeBus(self.before)
        bus.values['shoulder_lift']['Torque_Enable'] = 1
        bus.fail_write = ('Torque_Enable', 'shoulder_lift')
        errors = target.safe_stop(bus, time.monotonic() + 3)
        self.assertEqual(len(errors), 2)
        self.assertNotIn(('Operating_Mode', 'shoulder_lift', 0), bus.writes)

    def test_speed_is_exactly_requested_400(self):
        self.assertEqual(target.SPEED_LIMIT, 400)
        self.bus.write('Goal_Velocity', 'shoulder_lift', -400)
        self.assertEqual(self.bus.values['shoulder_lift']['Goal_Velocity'], -400)

    def test_acknowledged_but_ignored_write_latches_fault(self):
        self.bus.ignore_write = ('Goal_Velocity', 'elbow_flex')
        with self.assertRaisesRegex(target.MotionFault, 'readback mismatch'):
            self.bus.write('Goal_Velocity', 'elbow_flex', 400)
        self.assertTrue(self.bus.motion_fault)
        with self.assertRaises(target.MotionFault):
            self.bus.write('Operating_Mode', 'shoulder_lift', 1)

    def test_ignored_homing_offset_write_aborts(self):
        self.bus.ignore_write = ('Homing_Offset', 'elbow_flex')
        with self.assertRaisesRegex(target.MotionFault, 'readback mismatch'):
            self.bus.write('Homing_Offset', 'elbow_flex', 0)

    def test_valid_range_passes(self):
        target.validate_joint('elbow_flex', dict(id=3, drive_mode=0,
            homing_offset=0, range_min=500, range_max=3500))

    def test_invalid_ranges_and_identity_rejected(self):
        valid = dict(id=3, drive_mode=0, homing_offset=0, range_min=500, range_max=3500)
        for changed in [dict(range_max=500), dict(range_max=600), dict(range_max=400),
                        dict(range_min=-1), dict(range_max=4096), dict(id=4),
                        dict(homing_offset=2048), dict(drive_mode=1)]:
            with self.subTest(changed=changed), self.assertRaises(target.MotionFault):
                target.validate_joint('elbow_flex', dict(valid, **changed))

    def test_zero_span_rejected_before_midpoint(self):
        result = target.auto.LimitExplorationResult(0, 255, 0, 255)
        wrapped = target.validated_limits(lambda *args: result)
        with self.assertRaisesRegex(target.MotionFault, 'before midpoint'):
            wrapped(self.bus, 'elbow_flex', None, target.auto.get_joint_behavior('elbow_flex'))
        self.assertTrue(self.bus.motion_fault)

    def test_upstream_joint_stops_before_midpoint_for_zero_span(self):
        result = target.auto.LimitExplorationResult(0, 255, 0, 255)
        motor = type('Motor', (), {'id': 3, 'model': 'sts3215'})()
        self.bus.motors = {'elbow_flex': motor}
        self.bus.model_resolution_table = {'sts3215': 4096}
        cfg = target.auto.AutoCalibrateConfig(robot=None, explore_velocity=400)
        sequence = target.validated_limits(lambda *args: result)
        with patch.object(target.auto, 'run_limit_exploration_sequence', sequence), patch.object(target.auto, 'move_motor_to_midpoint') as midpoint:
            with self.assertRaises(target.MotionFault):
                target.auto.auto_calibrate_single_joint(self.bus, 'elbow_flex', cfg)
            midpoint.assert_not_called()

    def test_invalid_joint_never_enters_provisional_results(self):
        result = target.auto.MotorCalibration(id=3, drive_mode=0, homing_offset=0, range_min=2047, range_max=2047)
        provisional = {}
        wrapped = target.validated_joint(lambda *args: result, provisional)
        with tempfile.TemporaryDirectory() as directory, patch.object(target, 'ARTIFACTS', Path(directory)):
            with self.assertRaises(target.MotionFault):
                wrapped(self.bus, 'elbow_flex', None)
            self.assertEqual(provisional, {})
            self.assertTrue((Path(directory) / 'invalid_joint.json').exists())
            self.assertFalse((Path(directory) / 'provisional.json').exists())

    def test_invalid_complete_calibration_never_written(self):
        calibration = {name: target.auto.MotorCalibration(id=id_, drive_mode=0,
            homing_offset=0, range_min=500, range_max=3500) for name, id_ in target.EXPECTED.items()}
        calibration['elbow_flex'].range_max = 500
        with self.assertRaises(target.MotionFault):
            self.bus.write_calibration(calibration)
        self.assertEqual(self.bus.calibration_writes, [])

    def test_incomplete_calibration_rejected(self):
        with self.assertRaises(target.MotionFault):
            self.bus.write_calibration({})
        self.assertEqual(self.bus.calibration_writes, [])

    def test_valid_complete_calibration_requires_torque_off(self):
        calibration = {name: target.auto.MotorCalibration(id=id_, drive_mode=0,
            homing_offset=0, range_min=500, range_max=3500) for name, id_ in target.EXPECTED.items()}
        self.bus.values['elbow_flex']['Torque_Enable'] = 1
        with self.assertRaises(target.MotionFault):
            self.bus.write_calibration(calibration)
        self.assertEqual(self.bus.calibration_writes, [])

    def test_ignored_torque_off_rejected_and_no_mode_switch(self):
        bus = FakeBus(self.before)
        bus.values['elbow_flex']['Torque_Enable'] = 1
        bus.ignore_write = ('Torque_Enable', 'elbow_flex')
        errors = target.safe_stop(bus, time.monotonic() + 3)
        self.assertTrue(any('readback mismatch' in error for error in errors))
        self.assertNotIn(('Operating_Mode', 'elbow_flex', 0), bus.writes)

    def test_shutdown_rejects_ignored_torque_off(self):
        self.bus.values['elbow_flex']['Torque_Enable'] = 1
        self.bus.ignore_write = ('Torque_Enable', 'elbow_flex')
        with tempfile.TemporaryDirectory() as directory, patch.object(target, 'ARTIFACTS', Path(directory)):
            errors = target.shutdown(self.bus, self.before)
            self.assertTrue(errors)
            samples = json.loads((Path(directory) / 'stop_samples.json').read_text())
            self.assertEqual(len(samples), 2)
            self.assertTrue(all(s['elbow_flex']['Torque_Enable'] == 1 for s in samples))

    def test_shutdown_rejects_remaining_motion(self):
        self.bus.values['wrist_flex']['Present_Velocity'] = -50
        with tempfile.TemporaryDirectory() as directory, patch.object(target, 'ARTIFACTS', Path(directory)):
            errors = target.shutdown(self.bus, self.before)
            self.assertTrue(any('Present_Velocity=-50' in error for error in errors))

    def test_shutdown_rejects_fault_status(self):
        self.bus.values['gripper']['Status'] = 32
        with tempfile.TemporaryDirectory() as directory, patch.object(target, 'ARTIFACTS', Path(directory)):
            errors = target.shutdown(self.bus, self.before)
            self.assertTrue(any('final status' in error for error in errors))

    def test_hardware_execution_entrypoints_locked(self):
        for option in ['--execute', '--stop-only']:
            with patch('sys.argv', ['calibrate_slow.py', option]), patch.object(target, 'SO101Follower') as device:
                with self.assertRaises(SystemExit) as error:
                    target.main()
                self.assertEqual(error.exception.code, 2)
                device.assert_not_called()

    def test_default_entrypoint_is_no_hardware(self):
        with patch('sys.argv', ['calibrate_slow.py']), patch.object(target, 'SO101Follower') as device:
            target.main()
            device.assert_not_called()


if __name__ == '__main__':
    unittest.main(verbosity=2)