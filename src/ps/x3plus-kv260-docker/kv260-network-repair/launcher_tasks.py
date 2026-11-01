"""Detached action supervisor: bounded logs, locks, no shell interpolation.

The GUI may exit without killing the supervisor or its ROS/vision command.
Only explicit user actions invoke this module's main entry point.
"""
import argparse
import codecs
import fcntl
import json
import logging
from logging.handlers import RotatingFileHandler
import os
from pathlib import Path
import subprocess
import selectors
import sys
import time

from launcher_core import BASE, MAP_PATTERN, read_env, require_serial, check_container_devices

STATE = Path.home() / '.local/state/kv260-launcher'
ACTIONS = {
    'base': ('基础环境', [['run-master.sh'], ['run-robot.sh']]),
    'hardware': ('底盘与雷达', [['start-hardware.sh']]),
    'slam': ('SLAM 建图', [['start-slam.sh']]),
    'navigation': ('地图导航', [['start-navigation.sh']]),
    'save': ('保存地图', [['save-map.sh']]),
    'stop-navigation': ('停止导航', [['stop-navigation.sh']]),
    'stop-slam': ('停止 SLAM', [['stop-slam.sh']]),
    'rviz-map': ('建图 RViz', [['start-rviz.sh', 'map']]),
    'rviz-nav': ('导航 RViz', [['start-rviz.sh', 'navigate']]),
    'vision': ('Astra RGB-D YOLOv4', [['start-astra-rgbd-yolov4.sh']]),
    'stop-vision': ('停止 AI 视觉', [['stop-astra-rgbd-yolov4.sh']]),
    'stop-rviz': ('停止 RViz', [['stop-rviz.sh']]),
    'stop-all': ('停止全部服务', [['stop-all.sh']]),
    'keyboard': ('键盘控制', [['start-keyboard.sh']]),
    'stop-keyboard': ('停止键盘控制', [['stop-keyboard.sh']]),
}
LONG_ACTIONS = {'rviz-map', 'rviz-nav', 'vision', 'keyboard'}
FINITE_TIMEOUTS = {'base': 420}


def finite_timeout(action):
    """Keep migration's 300-second snapshot inside the task supervisor."""
    return FINITE_TIMEOUTS.get(action, 180)


def service_started(action, env):
    """Release the startup gate only once the stoppable service is present."""
    if action in ('rviz-map', 'rviz-nav'):
        args = ['docker', 'inspect', '--format', '{{.State.Running}}',
                env.get('RVIZ_CONTAINER_NAME', 'x3plus-rviz')]
        expected = 'true'
    elif action == 'vision':
        args = ['pgrep', '-f', '/home/ubuntu/kv260_yolov4_deploy/[r]emote_camera_yolov4.py']
        expected = None
    else:
        args = ['docker', 'exec', env.get('ROBOT_NAME', 'x3plus-robot'),
                'pgrep', '-f', '[r]oslaunch yahboomcar_ctrl yahboom_keyboard.launch']
        expected = None
    try:
        result = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
                                text=True, timeout=2)
        return result.returncode == 0 and (expected is None or result.stdout.strip() == expected)
    except (OSError, subprocess.TimeoutExpired):
        return False


def supervise(args, action, env, logger, release_startup):
    """Stream bounded chunks; keyboard inherits its real terminal."""
    keyboard = action == 'keyboard'
    with subprocess.Popen(args, cwd=BASE, env=env,
            stdin=None if keyboard else subprocess.DEVNULL,
            stdout=None if keyboard else subprocess.PIPE,
            stderr=None if keyboard else subprocess.STDOUT) as proc:
        decoder = codecs.getincrementaldecoder('utf-8')(errors='replace')
        next_probe = 0
        released = False
        with selectors.DefaultSelector() as selector:
            if not keyboard:
                selector.register(proc.stdout, selectors.EVENT_READ)
            while proc.poll() is None or selector.get_map():
                if action in LONG_ACTIONS and not released and time.monotonic() >= next_probe:
                    if service_started(action, env):
                        release_startup()
                        released = True
                    next_probe = time.monotonic() + 2
                for key, _ in selector.select(timeout=.25):
                    chunk = os.read(key.fd, 4096)
                    if chunk:
                        logger.info('%s', decoder.decode(chunk).rstrip())
                    else:
                        tail = decoder.decode(b'', final=True)
                        if tail:
                            logger.info('%s', tail)
                        selector.unregister(key.fileobj)
        return proc.wait()


def state_dir():
    STATE.mkdir(parents=True, exist_ok=True, mode=0o700)
    return STATE


def lock_name(action):
    return 'rviz' if action in ('rviz-map', 'rviz-nav') else action


def is_active(action):
    with (state_dir() / (lock_name(action) + '.lock')).open('a') as stream:
        try:
            fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return True
    return False


def action_commands(action, argument=''):
    if action not in ACTIONS:
        raise ValueError('未知操作')
    if action in ('save', 'navigation') and not MAP_PATTERN.fullmatch(argument):
        raise ValueError('地图名称不合法')
    commands = [[str(BASE / args[0]), *args[1:]] for args in ACTIONS[action][1]]
    if action in ('save', 'navigation'):
        commands[0].append(argument)
    return commands


def write_state(action, **values):
    path = state_dir() / (action + '.json')
    temp = path.with_suffix('.tmp')
    temp.write_text(json.dumps(values, ensure_ascii=False))
    temp.replace(path)


def run(action, argument=''):
    locks = []
    try:
        for key in [lock_name(action), 'control']:
            stream = (state_dir() / (key + '.lock')).open('a')
            locks.append(stream)
            try:
                fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except BlockingIOError:
                message = '已有同类任务或启动/停止操作正在进行；本次操作未执行。等待当前操作结束后重试。'
                print(message, file=sys.stderr)
                # Do not overwrite an active same-action record.
                if key == 'control':
                    write_state(action, status='rejected', returncode=75, message=message)
                return 75
        logger = logging.getLogger(action)
        logger.setLevel(logging.INFO)
        handler = RotatingFileHandler(state_dir() / (action + '.log'),
                                      maxBytes=256 * 1024, backupCount=1, encoding='utf-8')
        handler.setFormatter(logging.Formatter('%(asctime)s %(message)s', '%H:%M:%S'))
        logger.addHandler(handler)
        start = time.time()
        write_state(action, status='running', pid=os.getpid(), started=start)
        logger.info('▶ %s %s', ACTIONS[action][0], argument)
        code = 1
        try:
            commands = action_commands(action, argument)
            env = read_env()
            if action in ('base', 'hardware', 'slam', 'navigation', 'keyboard'):
                require_serial(env)
            if action in ('slam', 'navigation', 'keyboard'):
                check_container_devices(env)
            if action == 'vision':
                camera = env.get('ASTRA_COLOR_DEVICE',
                    '/dev/v4l/by-id/usb-Astra_Pro_HD_Camera_Astra_Pro_HD_Camera-video-index0')
                if not Path(camera).exists():
                    raise ValueError('相机未连接；拒绝加载 DPU: ' + camera)
            for args in commands:
                if action not in LONG_ACTIONS:
                    limit = finite_timeout(action)
                    args = ['timeout', '--kill-after=5s', str(limit), *args]
                code = supervise(args, action, env, logger,
                                 lambda: fcntl.flock(locks[-1], fcntl.LOCK_UN))
                if code:
                    if code == 124:
                        logger.error('启动超过 %s 秒；这不是硬件错误码。检查 ROS 地址、Master 和本任务最后一条日志。后台服务可能仍在运行。', limit)
                    break
        except Exception:
            code = 1
            logger.exception('操作异常；请核对实际服务状态，不自动重试')
        finally:
            logger.info('■ 操作结束，返回码 %s；后台服务状态请查看总览。', code)
            write_state(action, status='finished', pid=os.getpid(), started=start,
                        finished=time.time(), returncode=code)
            handler.close()
            logger.removeHandler(handler)
        return code
    finally:
        for stream in locks:
            stream.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('action', choices=sorted(ACTIONS))
    parser.add_argument('argument', nargs='?', default='')
    args = parser.parse_args()
    raise SystemExit(run(args.action, args.argument))