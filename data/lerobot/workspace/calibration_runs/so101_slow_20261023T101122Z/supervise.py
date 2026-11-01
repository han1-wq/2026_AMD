#!/usr/bin/env python3
"""Single authorized run; external watchdog is not a hardware emergency stop."""
import datetime
import hashlib
import json
import os
import subprocess
from pathlib import Path

RUN = Path('/home/amd/lerobot-deploy/workspace/calibration_runs/so101_slow_20261023T101122Z')
CALIBRATION = Path('/home/amd/lerobot-deploy/workspace/calibration')
PORT = Path('/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B91028053-if00')
NAME = 'so101-autocal-slow-20261023t101122'
IMAGE = 'lerobot-cpu:joyandai-0.4.3'


def command(args, timeout=10):
    return subprocess.run(args, capture_output=True, text=True, timeout=timeout)


def inspect():
    result = command(['docker', 'inspect', NAME])
    result.check_returncode()
    return json.loads(result.stdout)[0]


def stopped_verified():
    try:
        state = json.loads((RUN / 'stopped.json').read_text())
        expected = set(json.loads((RUN / 'before.json').read_text()))
        return set(state) == expected and all(
            set(values) == {'Torque_Enable', 'Goal_Velocity', 'Operating_Mode', 'Present_Velocity'}
            and all(value == 0 for value in values.values()) for values in state.values())
    except (OSError, ValueError, TypeError):
        return False


def main():
    if (RUN / 'offline_tests.exit').read_text().strip() != '0':
        raise RuntimeError('Offline tests did not pass')
    if (CALIBRATION / 'robots/so101_follower/follower_so101.json').exists():
        raise RuntimeError('Refusing to overwrite a calibration')
    occupied = command(['fuser', str(PORT.resolve())])
    if occupied.returncode != 1:
        raise RuntimeError(f'Serial port occupied or cannot be checked: {occupied.stdout} {occupied.stderr}')
    if command(['docker', 'inspect', NAME]).returncode == 0:
        raise RuntimeError('Run container already exists; no automatic repeat permitted')
    manifest = {
        'utc_start': datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'container': NAME, 'image': IMAGE, 'serial': str(PORT),
        'user_confirmed': 'Power-cycled, shoulder checked, safely supported, motion area clear, supervisor ready to cut power.',
        'explore_velocity': 150, 'try_torque': 400, 'max_torque': 600,
        'wrist_roll_torque': 300, 'gripper_torque': 300,
        'motion_budget_s': 900, 'phase_budget_s': 60, 'cleanup_budget_s': 60,
        'external_process_budget_s': 975,
        'sha256': {p: hashlib.sha256((RUN / p).read_bytes()).hexdigest()
                   for p in ['calibrate_slow.py', 'before.json', 'original_before.json', 'test_slow.py']},
    }
    with (RUN / 'launch.json').open('x') as file:
        json.dump(manifest, file, indent=2)
    base = ['docker', 'run', '--network', 'none', '--cap-drop', 'ALL',
            '--security-opt', 'no-new-privileges', '--user', f'{os.getuid()}:{os.getgid()}',
            '--group-add', str(PORT.stat().st_gid), '--device', f'{PORT}:/dev/follower:rwm',
            '--env', 'PYTHONDONTWRITEBYTECODE=1',
            '--mount', f'type=bind,src={RUN},dst=/run_artifacts',
            '--mount', f'type=bind,src={CALIBRATION},dst=/workspace/calibration']
    timed_out = False
    print('STARTING_SINGLE_ATTEMPT', json.dumps(manifest), flush=True)
    with (RUN / 'calibration.log').open('x') as log:
        process = subprocess.Popen(base + ['--name', NAME, IMAGE, 'python', '-u',
                                           '/run_artifacts/calibrate_slow.py', '--execute'],
                                   stdout=log, stderr=subprocess.STDOUT)
        try:
            returncode = process.wait(timeout=975)
        except subprocess.TimeoutExpired:
            timed_out = True
            print('EXTERNAL_TIMEOUT: sending termination; physically cut power if motion persists', flush=True)
            stop = command(['docker', 'stop', '--time', '70', NAME], timeout=85)
            (RUN / 'external_stop.log').write_text(stop.stdout + stop.stderr)
            returncode = process.wait(timeout=10)
    info = inspect()
    (RUN / 'container_state.json').write_text(json.dumps(info['State'], indent=2))
    if info['State']['Running']:
        raise RuntimeError('Container still active; do not open another serial client; cut physical power')
    if not stopped_verified():
        print('SHUTDOWN_UNVERIFIED: stop-only fallback, no calibration retry', flush=True)
        for name in ['stopped.json', 'cleanup.json', 'after.json']:
            path = RUN / name
            if path.exists():
                path.rename(RUN / ('primary_' + name))
        fallback_name = NAME + '-stop-only'
        with (RUN / 'stop_only.log').open('x') as log:
            process = subprocess.Popen(base + ['--name', fallback_name, IMAGE, 'python', '-u',
                                               '/run_artifacts/calibrate_slow.py', '--stop-only'],
                                       stdout=log, stderr=subprocess.STDOUT)
            try:
                process.wait(timeout=80)
            except subprocess.TimeoutExpired:
                command(['docker', 'stop', '--time', '5', fallback_name], timeout=15)
                print('STOP_ONLY_TIMEOUT: physical power-off required', flush=True)
    outcome = {'returncode': returncode, 'external_timeout': timed_out,
               'shutdown_verified': stopped_verified(),
               'success_artifact': (RUN / 'success.json').exists(),
               'utc_finished': datetime.datetime.now(datetime.timezone.utc).isoformat()}
    (RUN / 'supervisor_result.json').write_text(json.dumps(outcome, indent=2))
    print('SUPERVISOR_RESULT', json.dumps(outcome), flush=True)
    if not outcome['shutdown_verified']:
        raise RuntimeError('PHYSICAL POWER-OFF REQUIRED: shutdown is not verified')


if __name__ == '__main__':
    main()