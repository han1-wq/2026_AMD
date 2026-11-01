"""Fail-closed keyboard/navigation switching; no ROS imports on the host."""
import argparse
from dataclasses import dataclass
from pathlib import Path
import shlex
import re
import subprocess
import time

from launcher_core import BASE, read_env

ROS_SETUP = 'source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; '
NODE_NAMES = {
    'keyboard': {'/yahboom_keyboard', '/keyboard_ctrl'},
    'slam': {'/slam_gmapping'},
    'navigation': {'/amcl', '/move_base', '/move_base_node', '/navigation_guard'},
}
LAUNCHES = {
    'keyboard': ('yahboomcar_ctrl', 'yahboom_keyboard.launch'),
    'slam': ('yahboomcar_nav', 'yahboomcar_map.launch'),
    'navigation': ('yahboomcar_nav', 'yahboomcar_navigation.launch'),
}


@dataclass
class ModeState:
    pids: set
    launches: set
    nodes: set

    def active(self):
        return bool(self.pids or self.nodes)


def process_mode(args):
    """Match executable/launch tokens, never a shell's embedded command text."""
    # ps does not quote argv; inspect only the executable and interpreter's
    # script position. Never search arbitrary arguments (grep/bash/echo).
    tokens = args.split()
    if not tokens:
        return None, False
    index = 0
    if re.fullmatch(r'python(?:[23](?:\.\d+)?)?', Path(tokens[0]).name):
        index = 1
        while index < len(tokens) and tokens[index] in ('-u', '-B', '-E', '-s', '-S'):
            index += 1
        if index >= len(tokens):
            return None, False
    name = Path(tokens[index]).name
    if name == 'roslaunch':
        for mode, launch in LAUNCHES.items():
            if tuple(tokens[index + 1:index + 3]) == launch:
                return mode, True
    if name == 'yahboom_keyboard.py':
        return 'keyboard', False
    if name == 'slam_gmapping':
        return 'slam', False
    if name in ('move_base', 'map_server', 'amcl', 'navigation_guard.py'):
        return 'navigation', False
    return None, False


class ModeGuard:
    def __init__(self, env):
        self.env = env
        self.name = env.get('ROBOT_NAME', 'x3plus-robot')

    def command(self, args, timeout=6):
        result = subprocess.run(args, capture_output=True, text=True,
                                timeout=timeout, env=self.env)
        if result.returncode:
            raise RuntimeError('Cannot confirm robot mode: ' +
                               (result.stderr or result.stdout or str(args))[-1000:].strip())
        return result.stdout

    def docker(self, *args):
        return self.command(['docker', 'exec', self.name, *args])

    def ros(self, command):
        return self.docker('bash', '-c', ROS_SETUP + command)

    def snapshot(self):
        states = {mode: ModeState(set(), set(), set()) for mode in LAUNCHES}
        for line in self.docker('ps', '-eo', 'pid=,args=').splitlines():
            pid, args = line.strip().split(None, 1)
            if not pid.isdigit() or int(pid) <= 0:
                raise RuntimeError('Invalid process snapshot')
            mode, launch = process_mode(args)
            if mode:
                states[mode].pids.add(int(pid))
                if launch:
                    states[mode].launches.add(int(pid))
        for node in self.ros('rosnode list').splitlines():
            node = node.strip()
            if not node.startswith('/'):
                raise RuntimeError('Invalid ROS node snapshot')
            for mode, names in NODE_NAMES.items():
                if node in names or (mode == 'navigation' and
                                     (node == '/map_server' or node.startswith('/map_server_'))):
                    states[mode].nodes.add(node)
        return states

    def signal(self, pids, signal):
        for pid in sorted(pids):
            try:
                self.docker('kill', '-' + signal, str(pid))
            except RuntimeError:
                # A process may exit between snapshot and signal. Never infer
                # success here; subsequent snapshots must prove it has gone.
                pass

    def wait_keyboard(self, seconds):
        deadline = time.monotonic() + seconds
        while True:
            state = self.snapshot()['keyboard']
            if not state.active() or time.monotonic() >= deadline:
                return state
            time.sleep(.5)

    def stop_keyboard(self):
        state = self.snapshot()['keyboard']
        if not state.active():
            print('Keyboard control is already stopped.')
            return
        print('Stopping keyboard control before changing control ownership...', flush=True)
        # SIGINT lets roslaunch restore the terminal and stop its children.
        self.signal(state.launches, 'INT')
        if state.nodes:
            try:
                self.ros('rosnode kill ' + ' '.join(shlex.quote(n) for n in sorted(state.nodes)))
            except RuntimeError:
                pass
        state = self.wait_keyboard(5)
        for signal, seconds in [('TERM', 5), ('KILL', 3)]:
            if not state.active():
                break
            self.signal(state.pids, signal)
            state = self.wait_keyboard(seconds)
        if state.active():
            raise RuntimeError('Keyboard processes/nodes remain; navigation was not started.')
        # Send zero only after the keyboard publisher has exited. A failed
        # command is not proof of braking, so do not proceed to navigation.
        self.ros('rostopic pub -1 /cmd_vel geometry_msgs/Twist '
                 '"{linear: {x: 0.0, y: 0.0, z: 0.0}, angular: {x: 0.0, y: 0.0, z: 0.0}}"')
        print('Keyboard control stopped; zero-velocity command sent (not a physical stop confirmation).')

    def prepare_navigation(self):
        self.stop_keyboard()
        if self.snapshot()['slam'].active():
            print('Stopping SLAM before navigation...', flush=True)
            subprocess.run(['bash', str(BASE / 'stop-slam.sh')], env=self.env,
                           check=True, timeout=60)
        states = self.snapshot()
        if states['keyboard'].active() or states['slam'].active():
            raise RuntimeError('Keyboard/SLAM still active; navigation was not started.')
        print('Navigation mode guard passed: keyboard and SLAM are absent.')

    def check_keyboard(self):
        states = self.snapshot()
        if states['navigation'].active():
            raise RuntimeError('Navigation is active. Stop navigation before starting keyboard control.')
        if states['keyboard'].active():
            raise RuntimeError('Keyboard control already exists; refusing a duplicate.')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('action', choices=['stop-keyboard', 'prepare-navigation', 'check-keyboard'])
    args = parser.parse_args()
    guard = ModeGuard(read_env())
    try:
        getattr(guard, args.action.replace('-', '_'))()
    except (RuntimeError, ValueError, OSError, subprocess.SubprocessError) as exc:
        parser.exit(1, 'Mode switch refused: %s\n' % exc)


if __name__ == '__main__':
    main()