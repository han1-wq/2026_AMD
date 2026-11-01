#!/usr/bin/env python3
"""Offline-prepared speed-400 wrapper; motion blocked pending shutdown diagnosis."""
import argparse
import functools
import json
import logging
import signal
import time
from dataclasses import asdict
from pathlib import Path

from lerobot.motors import auto_calibrate as auto
from lerobot.robots.so101_follower import SO101Follower, SO101FollowerConfig

ARTIFACTS = Path('/run_artifacts')
OUTPUT = Path('/workspace/calibration/robots/so101_follower')
DEVICE_ID = 'follower_so101'
EXPECTED = {'shoulder_pan': 1, 'shoulder_lift': 2, 'elbow_flex': 3,
            'wrist_flex': 4, 'wrist_roll': 5, 'gripper': 6}
SPEED_LIMIT = 400
# Conservative plausibility floor, not a manufacturer range specification.
MIN_RANGE = 200
HARDWARE_EXECUTION_BLOCKED = True


def validate_joint(name, value):
    if name not in EXPECTED or value['id'] != EXPECTED[name]:
        raise MotionFault(f'Unexpected motor identity: {name}: {value}')
    if not (0 <= value['range_min'] < value['range_max'] <= 4095
            and value['range_max'] - value['range_min'] >= MIN_RANGE):
        raise MotionFault(f'{name}: zero, too-small, or invalid range: {value}')
    if not -2047 <= value['homing_offset'] <= 2047 or value['drive_mode'] != 0:
        raise MotionFault(f'{name}: invalid homing offset or drive mode: {value}')


def validate_all(calibration):
    if set(calibration) != set(EXPECTED):
        raise MotionFault('Incomplete or unexpected motor calibration set')
    for name, value in calibration.items():
        validate_joint(name, asdict(value))


def validated_limits(function):
    @functools.wraps(function)
    def wrapped(bus, name, config, behavior):
        result = function(bus, name, config, behavior)
        lower, upper = auto.unwrap_physical_limit_range(
            result.first_limit, result.second_limit, behavior.second_direction, auto.SERVO_RESOLUTION)
        if upper - lower < MIN_RANGE:
            bus.motion_fault = f'{name}: invalid measured span {upper - lower}; stopping before midpoint'
            raise MotionFault(bus.motion_fault)
        return result
    return wrapped


def validated_joint(function, provisional):
    @functools.wraps(function)
    def wrapped(bus, name, config):
        result = function(bus, name, config)
        if bus.motion_fault:
            raise MotionFault(bus.motion_fault)
        data = asdict(result)
        try:
            validate_joint(name, data)
        except MotionFault as error:
            bus.motion_fault = str(error)
            (ARTIFACTS / 'invalid_joint.json').write_text(json.dumps(
                {'name': name, 'rejected_result': data, 'reason': str(error)}, indent=2) + chr(10))
            raise
        provisional[name] = data
        (ARTIFACTS / 'provisional.json').write_text(json.dumps(provisional, indent=2) + chr(10))
        return result
    return wrapped


class MotionFault(Exception):
    """Abort instead of allowing upstream overload recovery to continue motion."""


class WatchdogAbort(BaseException):
    """Cannot be swallowed by upstream best-effort Exception handlers."""


def verify_health(bus, before):
    for name in EXPECTED:
        registers = before[name]['registers']
        for register in ['Torque_Enable', 'Goal_Velocity', 'Present_Velocity', 'Status']:
            value = bus.read(register, name, normalize=False)
            if value != 0:
                raise MotionFault(f'{name}: pre-motion {register}={value}')
        temperature = bus.read('Present_Temperature', name, normalize=False)
        voltage = bus.read('Present_Voltage', name, normalize=False)
        if temperature >= min(50, registers['Max_Temperature_Limit'] - 10):
            raise MotionFault(f'{name}: temperature too high: {temperature}')
        if not registers['Min_Voltage_Limit'] < voltage < registers['Max_Voltage_Limit']:
            raise MotionFault(f'{name}: voltage outside configured limits: {voltage}')


def install_guards(bus, before):
    bus.unguarded_read = bus.read
    bus.unguarded_write = bus.write
    bus.unguarded_write_calibration = bus.write_calibration
    bus.motion_fault = None
    last_health = [0.0]

    def fail(message):
        bus.motion_fault = message
        raise MotionFault(message)

    def read(register, name, *args, **kwargs):
        if bus.motion_fault:
            raise MotionFault(bus.motion_fault)
        try:
            value = bus.unguarded_read(register, name, *args, **kwargs)
            if register == 'Status' and value:
                raise MotionFault(f'{name}: status fault {value:#x}')
            if time.monotonic() - last_health[0] >= 0.5:
                last_health[0] = time.monotonic()
                for motor in EXPECTED:
                    original = before[motor]['registers']
                    status = bus.unguarded_read('Status', motor, normalize=False)
                    temperature = bus.unguarded_read('Present_Temperature', motor, normalize=False)
                    voltage = bus.unguarded_read('Present_Voltage', motor, normalize=False)
                    if status:
                        raise MotionFault(f'{motor}: status fault {status:#x}')
                    if temperature >= min(50, original['Max_Temperature_Limit'] - 10):
                        raise MotionFault(f'{motor}: temperature {temperature}')
                    if not original['Min_Voltage_Limit'] < voltage < original['Max_Voltage_Limit']:
                        raise MotionFault(f'{motor}: voltage {voltage}')
            return value
        except Exception as error:
            fail(f'Read failed; stopping without recovery: {error}')

    def write(register, name, value, *args, **kwargs):
        if bus.motion_fault:
            raise MotionFault(bus.motion_fault)
        original = before[name]['registers']
        if register in ['Goal_Position', 'Goal_Time']:
            fail(f'Unexpected position-control command: {register}')
        if register in ['Acceleration', 'Maximum_Acceleration'] and value != original[register]:
            fail(f'Refusing undocumented acceleration change: {register}={value}')
        if register == 'Operating_Mode':
            if value not in [0, 1]:
                fail(f'Unexpected operating mode: {value}')
            if value == 0 and read('Torque_Enable', name, normalize=False) != 0:
                fail(f'Refusing position mode while torque is enabled: {name}')
        if register == 'Torque_Enable' and value != 0:
            if value != 1 or read('Operating_Mode', name, normalize=False) != 1:
                fail(f'Refusing torque enable outside guarded velocity mode: {name}')
            if read('Goal_Velocity', name, normalize=False) != 0:
                fail(f'Refusing torque enable with stale velocity: {name}')
        if register == 'Goal_Velocity' and abs(value) > SPEED_LIMIT:
            fail(f'Refusing excessive speed {name}: {value}')
        if register in ['Torque_Limit', 'Max_Torque_Limit']:
            cap = 300 if name in ['wrist_roll', 'gripper'] else 600
            value = min(value, cap, original['Max_Torque_Limit'])
        if register in ['Overload_Torque', 'Protective_Torque', 'Protection_Time', 'Protection_Current',
                        'Over_Current_Protection_Time', 'Unloading_Condition', 'LED_Alarm_Condition',
                        'Max_Temperature_Limit', 'Min_Voltage_Limit', 'Max_Voltage_Limit']:
            # Keep the currently configured hardware protection unchanged.
            value = original[register]
        try:
            result = bus.unguarded_write(register, name, value, *args, **kwargs)
            actual = bus.unguarded_read(register, name, normalize=False)
            if actual != value:
                fail(f'Write readback mismatch {name}/{register}: requested={value}, actual={actual}')
            return result
        except Exception as error:
            fail(f'Write failed; stopping without recovery: {error}')

    def write_calibration(calibration, *args, **kwargs):
        if bus.motion_fault:
            raise MotionFault(bus.motion_fault)
        try:
            validate_all(calibration)
            for name in EXPECTED:
                for register in ['Torque_Enable', 'Goal_Velocity']:
                    if read(register, name, normalize=False) != 0:
                        fail(f'Refusing calibration write before verified stop: {name}/{register}')
            return bus.unguarded_write_calibration(calibration, *args, **kwargs)
        except Exception as error:
            fail(f'Calibration write rejected: {error}')

    bus.read = read
    bus.write = write
    bus.write_calibration = write_calibration


def abort(signum, frame):
    raise WatchdogAbort('Motion watchdog expired' if signum == signal.SIGALRM
                       else 'Calibration interrupted by termination signal')


def bounded(function, seconds, deadline):
    @functools.wraps(function)
    def wrapped(*args, **kwargs):
        remaining = min(seconds, deadline - time.monotonic())
        if remaining <= 0:
            raise WatchdogAbort('Total calibration time limit exceeded')
        signal.setitimer(signal.ITIMER_REAL, remaining)
        try:
            return function(*args, **kwargs)
        finally:
            signal.setitimer(signal.ITIMER_REAL, max(0.001, deadline - time.monotonic()))
    return wrapped


def cleanup_call(function, deadline, *args, **kwargs):
    remaining = deadline - time.monotonic()
    if remaining <= 0:
        raise TimeoutError('Cleanup budget exhausted; physical power-off required')
    def cleanup_timeout(signum, frame):
        raise TimeoutError('Cleanup operation timed out')
    previous_handler = signal.signal(signal.SIGALRM, cleanup_timeout)
    signal.setitimer(signal.ITIMER_REAL, min(1.0, remaining))
    try:
        return function(*args, **kwargs)
    finally:
        signal.setitimer(signal.ITIMER_REAL, 0)
        signal.signal(signal.SIGALRM, previous_handler)


def safe_stop(bus, deadline):
    errors = []
    # Torque-off goes to every motor first; never send position targets.
    for register in ['Torque_Enable', 'Goal_Velocity', 'Operating_Mode']:
        for name in EXPECTED:
            try:
                if register == 'Operating_Mode':
                    torque = cleanup_call(bus.read, deadline, 'Torque_Enable', name, normalize=False)
                    if torque != 0:
                        raise MotionFault(f'Refusing position-mode switch while torque remains {torque}')
                cleanup_call(bus.write, deadline, register, name, 0, normalize=False, num_retry=0)
                actual = cleanup_call(bus.read, deadline, register, name, normalize=False)
                if actual != 0:
                    raise MotionFault(f'Stop write readback mismatch: requested=0, actual={actual}')
            except Exception as error:
                errors.append(f'{name}/{register}: {error}')
    return errors


def shutdown(bus, before):
    deadline = time.monotonic() + 60
    errors = []
    state, after = {}, {}
    if hasattr(bus, 'unguarded_read'):
        bus.read, bus.write = bus.unguarded_read, bus.unguarded_write
        bus.write_calibration = bus.unguarded_write_calibration
    if bus.is_connected:
        errors.extend(safe_stop(bus, deadline))
        samples = []
        for sample_number in range(2):
            if sample_number:
                time.sleep(0.2)
            state = {}
            for name in EXPECTED:
                state[name] = {}
                for register in ['Torque_Enable', 'Goal_Velocity', 'Operating_Mode', 'Present_Velocity']:
                    try:
                        value = cleanup_call(bus.read, deadline, register, name, normalize=False)
                        state[name][register] = value
                        if value != 0:
                            errors.append(f'Stop sample {sample_number} {name}/{register}={value}')
                    except Exception as error:
                        state[name][register] = {'error': str(error)}
                        errors.append(f'Stop sample {sample_number} {name}/{register}: {error}')
            samples.append(state)
        (ARTIFACTS / 'stop_samples.json').write_text(json.dumps(samples, indent=2) + chr(10))
        (ARTIFACTS / 'stopped.json').write_text(json.dumps(state, indent=2) + chr(10))
        for name in EXPECTED:
            registers = {}
            after[name] = {'id': EXPECTED[name], 'registers': registers}
            for register in before[name]['registers']:
                try:
                    registers[register] = cleanup_call(bus.read, deadline, register, name, normalize=False)
                except Exception as error:
                    registers[register] = {'error': str(error)}
                    errors.append(f'Final snapshot {name}/{register}: {error}')
        (ARTIFACTS / 'after.json').write_text(json.dumps(after, indent=2) + chr(10))
        for name in EXPECTED:
            if after[name]['registers'].get('Status') != 0:
                errors.append(f'{name}: final status is not verified fault-free')
        try:
            cleanup_call(bus.disconnect, deadline, disable_torque=False)
        except Exception as error:
            errors.append(f'Disconnect: {error}')
    else:
        errors.append('Bus unavailable; shutdown was not verified')
    (ARTIFACTS / 'cleanup.json').write_text(json.dumps(errors, indent=2) + chr(10))
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--execute', action='store_true', help='Permit physical joint motion')
    parser.add_argument('--stop-only', action='store_true', help='Only disable torque, clear velocity, and verify')
    args = parser.parse_args()
    if HARDWARE_EXECUTION_BLOCKED and (args.execute or args.stop_only):
        parser.error('OFFLINE_ONLY: prior shutdown failed; no device may be opened until separately reviewed')
    if args.stop_only:
        if args.execute:
            parser.error('--execute and --stop-only are mutually exclusive')
        before = json.loads((ARTIFACTS / 'before.json').read_text())
        config = SO101FollowerConfig(port='/dev/follower', id=DEVICE_ID, calibration_dir=OUTPUT)
        bus = SO101Follower(config).bus
        signal.signal(signal.SIGALRM, abort)
        signal.setitimer(signal.ITIMER_REAL, 10)
        try:
            bus.connect(handshake=False)
        finally:
            signal.setitimer(signal.ITIMER_REAL, 0)
        errors = shutdown(bus, before)
        if errors:
            raise RuntimeError(f'STOP_ONLY_UNVERIFIED: {errors}; physically disconnect power')
        print('STOP_ONLY_VERIFIED', flush=True)
        return
    if not args.execute:
        print('Validation only: imports succeeded; no device constructed or connected.')
        return
    logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')
    destination = OUTPUT / f'{DEVICE_ID}.json'
    if destination.exists():
        raise FileExistsError(f'Refusing to overwrite calibration: {destination}')
    before = json.loads((ARTIFACTS / 'before.json').read_text())
    if {name: data['id'] for name, data in before.items()} != EXPECTED:
        raise ValueError('Expected six-motor preflight backup is missing or mismatched')
    config = SO101FollowerConfig(port='/dev/follower', id=DEVICE_ID, calibration_dir=OUTPUT)
    device = SO101Follower(config)
    settings = auto.AutoCalibrateConfig(robot=config, try_torque=400, max_torque=600,
        torque_step=50, explore_velocity=SPEED_LIMIT, wait_time_s=0.3,
        velocity_threshold=4, position_tolerance=4000)
    signal.signal(signal.SIGALRM, abort)
    signal.signal(signal.SIGTERM, abort)
    signal.signal(signal.SIGINT, abort)
    deadline = time.monotonic() + 900
    auto.explore_literal_limit = bounded(auto.explore_literal_limit, 60, deadline)
    auto.move_motor_to_midpoint = bounded(auto.move_motor_to_midpoint, 60, deadline)
    auto.run_limit_exploration_sequence = validated_limits(auto.run_limit_exploration_sequence)
    provisional = {}
    auto.auto_calibrate_single_joint = validated_joint(auto.auto_calibrate_single_joint, provisional)
    data = None
    cleanup_errors = []
    try:
        signal.setitimer(signal.ITIMER_REAL, 20)
        device.bus.connect()
        verify_health(device.bus, before)
        install_guards(device.bus, before)
        for name in EXPECTED:
            device.bus.write('Goal_Velocity', name, 0, normalize=False)
            device.bus.write('Operating_Mode', name, 0, normalize=False)
        signal.setitimer(signal.ITIMER_REAL, max(0.001, deadline - time.monotonic()))
        print(f'MOTION_START: speed={SPEED_LIMIT}; torque=400/cap600 (wrist/gripper300); phase=60s; total=900s', flush=True)
        result = auto.auto_calibrate_connected_device(device, settings, save=False)
        if device.bus.motion_fault:
            raise MotionFault(device.bus.motion_fault)
        data = {name: asdict(value) for name, value in result.calibration_dict.items()}
        (ARTIFACTS / 'candidate.json').write_text(json.dumps(data, indent=2) + chr(10))
        validate_all(result.calibration_dict)
        signal.setitimer(signal.ITIMER_REAL, min(20, max(0.001, deadline - time.monotonic())))
        actual = {name: asdict(value) for name, value in device.bus.read_calibration().items()}
        if actual != data:
            raise ValueError('Hardware calibration readback differs from calculated result')
        print('CALIBRATION_READBACK_MATCH', flush=True)
    except BaseException as error:
        (ARTIFACTS / 'failure.json').write_text(json.dumps({
            'type': type(error).__name__, 'message': str(error),
            'motion_fault': getattr(device.bus, 'motion_fault', None)}, indent=2) + chr(10))
        raise
    finally:
        signal.setitimer(signal.ITIMER_REAL, 0)
        cleanup_errors = shutdown(device.bus, before)
        print('CLEANUP_ERRORS', json.dumps(cleanup_errors), flush=True)
    if cleanup_errors:
        raise RuntimeError('Stop verification failed; physically disconnect motor power')
    auto.save_calibration_to_file(result.calibration_dict, destination)
    if json.loads(destination.read_text()) != data:
        raise ValueError('Saved JSON differs from verified hardware calibration')
    (ARTIFACTS / 'success.json').write_text(json.dumps({
        'calibration_file': str(destination), 'motors': data, 'torque_disabled': True,
        'register_readback_matches': True}, indent=2) + chr(10))
    print('CALIBRATION_SUCCESS', destination, flush=True)


if __name__ == '__main__':
    main()