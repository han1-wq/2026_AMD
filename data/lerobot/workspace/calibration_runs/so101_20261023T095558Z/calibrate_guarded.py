#!/usr/bin/env python3
"""One supervised SO101 calibration; preserves installed calibration logic."""
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


def abort(signum, frame):
    raise TimeoutError('Motion watchdog expired' if signum == signal.SIGALRM
                       else 'Calibration interrupted by termination signal')


def bounded(function, seconds, deadline):
    @functools.wraps(function)
    def wrapped(*args, **kwargs):
        remaining = min(seconds, deadline - time.monotonic())
        if remaining <= 0:
            raise TimeoutError('Total calibration time limit exceeded')
        signal.setitimer(signal.ITIMER_REAL, remaining)
        try:
            return function(*args, **kwargs)
        finally:
            signal.setitimer(signal.ITIMER_REAL, 0)
    return wrapped


def safe_stop(bus):
    errors = []
    # Attempt every motor independently even if another motor fails.
    for name in EXPECTED:
        for register, value in [('Goal_Velocity', 0), ('Torque_Enable', 0)]:
            try:
                bus.write(register, name, value, normalize=False, num_retry=2)
            except Exception as error:
                errors.append(f'{name}/{register}: {error}')
    for name in EXPECTED:
        try:
            bus.write('Operating_Mode', name, 0, normalize=False, num_retry=2)
        except Exception as error:
            errors.append(f'{name}/Operating_Mode: {error}')
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--execute', action='store_true', help='Permit physical joint motion')
    args = parser.parse_args()
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
    settings = auto.AutoCalibrateConfig(robot=config, try_torque=600, max_torque=1000,
        torque_step=50, explore_velocity=600, wait_time_s=0.5,
        velocity_threshold=4, position_tolerance=4000)
    signal.signal(signal.SIGALRM, abort)
    signal.signal(signal.SIGTERM, abort)
    signal.signal(signal.SIGINT, abort)
    deadline = time.monotonic() + 300
    auto.explore_literal_limit = bounded(auto.explore_literal_limit, 20, deadline)
    auto.move_motor_to_midpoint = bounded(auto.move_motor_to_midpoint, 20, deadline)
    data = None
    cleanup_errors = []
    try:
        signal.setitimer(signal.ITIMER_REAL, 20)
        device.connect(calibrate=False)
        signal.setitimer(signal.ITIMER_REAL, 0)
        print('MOTION_START: speed=600; sweep/midpoint deadline=20s; total=300s', flush=True)
        result = auto.auto_calibrate_connected_device(device, settings, save=False)
        data = {name: asdict(value) for name, value in result.calibration_dict.items()}
        (ARTIFACTS / 'candidate.json').write_text(json.dumps(data, indent=2) + chr(10))
        if {name: value['id'] for name, value in data.items()} != EXPECTED:
            raise ValueError('Calibration has incorrect motor names or IDs')
        for name, value in data.items():
            if not 0 <= value['range_min'] < value['range_max'] <= 4095:
                raise ValueError(f'{name}: invalid or zero-width calibrated range: {value}')
            if not -2047 <= value['homing_offset'] <= 2047:
                raise ValueError(f'{name}: homing offset outside signed register range')
        signal.setitimer(signal.ITIMER_REAL, 20)
        actual = {name: asdict(value) for name, value in device.bus.read_calibration().items()}
        if actual != data:
            raise ValueError('Hardware calibration readback differs from calculated result')
        print('CALIBRATION_READBACK_MATCH', flush=True)
    finally:
        signal.setitimer(signal.ITIMER_REAL, 0)
        if device.bus.is_connected:
            cleanup_errors = safe_stop(device.bus)
            try:
                state = {name: {register: device.bus.read(register, name, normalize=False)
                    for register in ['Torque_Enable', 'Goal_Velocity', 'Operating_Mode']}
                    for name in EXPECTED}
                (ARTIFACTS / 'stopped.json').write_text(json.dumps(state, indent=2) + chr(10))
                if any(value != 0 for registers in state.values() for value in registers.values()):
                    cleanup_errors.append('Post-stop register check failed')
            except Exception as error:
                cleanup_errors.append(f'Stop readback: {error}')
            try:
                device.bus.disconnect(disable_torque=False)
            except Exception as error:
                cleanup_errors.append(f'Disconnect: {error}')
        (ARTIFACTS / 'cleanup.json').write_text(json.dumps(cleanup_errors, indent=2) + chr(10))
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