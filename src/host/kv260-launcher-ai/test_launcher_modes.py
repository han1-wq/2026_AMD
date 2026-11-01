"""Mode-switch regressions with mocked ROS/Docker; never access real hardware."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
from unittest.mock import Mock, patch

import launcher_modes as modes


def snapshot(keyboard=False, slam=False, navigation=False, nodes_only=False):
    states = {name: modes.ModeState(set(), set(), set()) for name in modes.LAUNCHES}
    for name, active in [('keyboard', keyboard), ('slam', slam), ('navigation', navigation)]:
        if active:
            states[name] = modes.ModeState(set() if nodes_only else {42},
                                          set() if nodes_only else {42},
                                          {sorted(modes.NODE_NAMES[name])[0]})
    return states


class ModeTests(unittest.TestCase):
    def setUp(self):
        self.guard = modes.ModeGuard(dict(os.environ))

    def test_process_matches_launch_and_orphan_script(self):
        for args in ['/usr/bin/python /opt/ros/melodic/bin/roslaunch yahboomcar_ctrl yahboom_keyboard.launch',
                     '/usr/bin/python /opt/x3plus_ws/src/yahboomcar_ctrl/scripts/yahboom_keyboard.py __name:=yahboom_keyboard']:
            self.assertEqual(modes.process_mode(args)[0], 'keyboard')

    def test_other_processes_are_not_keyboard(self):
        for args in ['bash -c "roslaunch yahboomcar_ctrl yahboom_keyboard.launch"',
                     'grep yahboom_keyboard.py',
                     '/usr/bin/python /tmp/not_yahboom_keyboard.py',
                     '/usr/bin/python /opt/ros/melodic/bin/roslaunch other yahboom_keyboard.launch']:
            self.assertIsNone(modes.process_mode(args)[0])

    def test_snapshot_detects_orphans_and_both_keyboard_node_names(self):
        with patch.object(self.guard, 'docker', return_value='42 python /opt/scripts/yahboom_keyboard.py\n'), \
             patch.object(self.guard, 'ros', return_value='/keyboard_ctrl\n/yahboom_keyboard\n/driver_node\n'):
            state = self.guard.snapshot()['keyboard']
        self.assertEqual(state.pids, {42})
        self.assertEqual(state.nodes, modes.NODE_NAMES['keyboard'])

    def test_absent_keyboard_does_not_publish_or_signal(self):
        with patch.object(self.guard, 'snapshot', return_value=snapshot()), \
             patch.object(self.guard, 'signal') as signal, patch.object(self.guard, 'ros') as ros:
            self.guard.stop_keyboard()
        signal.assert_not_called()
        ros.assert_not_called()

    def test_keyboard_clean_exit_then_zero(self):
        with patch.object(self.guard, 'snapshot', return_value=snapshot(keyboard=True)), \
             patch.object(self.guard, 'wait_keyboard', return_value=snapshot()['keyboard']), \
             patch.object(self.guard, 'signal') as signal, patch.object(self.guard, 'ros') as ros:
            self.guard.stop_keyboard()
        signal.assert_called_once_with({42}, 'INT')
        self.assertIn('rosnode kill', ros.call_args_list[0][0][0])
        self.assertIn('rostopic pub -1 /cmd_vel', ros.call_args_list[-1][0][0])

    def test_term_then_kill_fallback(self):
        active = snapshot(keyboard=True)['keyboard']
        absent = snapshot()['keyboard']
        with patch.object(self.guard, 'snapshot', return_value=snapshot(keyboard=True)), \
             patch.object(self.guard, 'wait_keyboard', side_effect=[active, active, absent]), \
             patch.object(self.guard, 'signal') as signal, patch.object(self.guard, 'ros'):
            self.guard.stop_keyboard()
        self.assertEqual([c[0][1] for c in signal.call_args_list], ['INT', 'TERM', 'KILL'])

    def test_residual_keyboard_refuses_without_zero(self):
        for nodes_only in (False, True):
            with self.subTest(nodes_only=nodes_only), \
                 patch.object(self.guard, 'snapshot', return_value=snapshot(keyboard=True, nodes_only=nodes_only)), \
                 patch.object(self.guard, 'wait_keyboard', return_value=snapshot(keyboard=True, nodes_only=nodes_only)['keyboard']), \
                 patch.object(self.guard, 'signal'), patch.object(self.guard, 'ros') as ros:
                with self.assertRaisesRegex(RuntimeError, 'remain'):
                    self.guard.stop_keyboard()
                self.assertFalse(any('rostopic pub' in c[0][0] for c in ros.call_args_list))

    def test_zero_publish_failure_refuses_navigation(self):
        def ros(command):
            if command.startswith('rostopic pub'):
                raise RuntimeError('zero failed')
        with patch.object(self.guard, 'snapshot', return_value=snapshot(keyboard=True)), \
             patch.object(self.guard, 'wait_keyboard', return_value=snapshot()['keyboard']), \
             patch.object(self.guard, 'signal'), patch.object(self.guard, 'ros', side_effect=ros), \
             patch.object(modes.subprocess, 'run') as run:
            with self.assertRaisesRegex(RuntimeError, 'zero failed'):
                self.guard.prepare_navigation()
        run.assert_not_called()

    def test_prepare_stops_keyboard_before_slam(self):
        order = []
        with patch.object(self.guard, 'stop_keyboard', side_effect=lambda: order.append('keyboard')), \
             patch.object(self.guard, 'snapshot', side_effect=[snapshot(slam=True), snapshot()]), \
             patch.object(modes.subprocess, 'run', side_effect=lambda *a, **kw: order.append('slam')) as run:
            self.guard.prepare_navigation()
        self.assertEqual(order, ['keyboard', 'slam'])
        self.assertTrue(run.call_args[1]['check'])

    def test_slam_stop_failure_and_residual_refuse(self):
        with patch.object(self.guard, 'stop_keyboard'), \
             patch.object(self.guard, 'snapshot', return_value=snapshot(slam=True)), \
             patch.object(modes.subprocess, 'run', side_effect=subprocess.CalledProcessError(1, 'stop-slam')):
            with self.assertRaises(subprocess.CalledProcessError):
                self.guard.prepare_navigation()
        for name in ('slam', 'keyboard'):
            with patch.object(self.guard, 'stop_keyboard'), \
                 patch.object(self.guard, 'snapshot', side_effect=[snapshot(), snapshot(**{name: True})]):
                with self.assertRaisesRegex(RuntimeError, 'still active'):
                    self.guard.prepare_navigation()

    def test_query_failures_are_not_treated_as_absence(self):
        for failure in (RuntimeError('docker failed'), subprocess.TimeoutExpired('docker', 6)):
            with patch.object(self.guard, 'docker', side_effect=failure):
                with self.assertRaises(type(failure)):
                    self.guard.prepare_navigation()
        with patch.object(self.guard, 'docker', return_value='1 tail -f /dev/null\n'), \
             patch.object(self.guard, 'ros', side_effect=RuntimeError('ROS unreachable')):
            with self.assertRaisesRegex(RuntimeError, 'ROS unreachable'):
                self.guard.prepare_navigation()

    def test_keyboard_rejects_navigation_process_or_node(self):
        for nodes_only in (False, True):
            with patch.object(self.guard, 'snapshot', return_value=snapshot(navigation=True, nodes_only=nodes_only)):
                with self.assertRaisesRegex(RuntimeError, 'Navigation is active'):
                    self.guard.check_keyboard()

    def test_keyboard_duplicate_rejected_and_idle_allowed(self):
        with patch.object(self.guard, 'snapshot', return_value=snapshot(keyboard=True)):
            with self.assertRaisesRegex(RuntimeError, 'already exists'):
                self.guard.check_keyboard()
        with patch.object(self.guard, 'snapshot', return_value=snapshot()):
            self.guard.check_keyboard()

    def test_signal_race_requires_recheck(self):
        with patch.object(self.guard, 'docker', side_effect=RuntimeError('already exited')):
            self.guard.signal({42}, 'INT')
        with patch.object(modes.subprocess, 'run', return_value=Mock(returncode=1, stderr='failed', stdout='')):
            with self.assertRaisesRegex(RuntimeError, 'Cannot confirm'):
                self.guard.command(['docker', 'ps'])


class ShellGuardTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.trace = self.root / 'trace'
        for name in ('start-navigation.sh', 'start-keyboard.sh'):
            shutil.copy2(modes.BASE / name, self.root / name)
        (self.root / 'launcher-env.sh').write_text('#!/bin/bash\n')
        (self.root / 'launcher_core.py').write_text('')
        (self.root / 'launcher_modes.py').write_text(
            'import os,sys\nfrom pathlib import Path\n'
            'with Path(os.environ["TRACE"]).open("a") as f: f.write("guard " + sys.argv[1] + "\\n")\n'
            'sys.exit(int(os.environ.get("GUARD_CODE", "0")))\n')
        (self.root / 'map.yaml').write_text('image: map.pgm\n')
        (self.root / 'map.pgm').write_text('fake image\n')
        docker = self.root / 'docker'
        docker.write_text('''#!/usr/bin/env python3
import os,sys
from pathlib import Path
with Path(os.environ['TRACE']).open('a') as f: f.write('docker ' + repr(sys.argv[1:]) + '\\n')
args = sys.argv[1:]
if args[0] == 'inspect':
    if '--format' in args:
        print(os.environ['MAP_DIR'] if '.Mounts' in args[-1] else 'true')
elif 'bash' in args:
    cmd = args[-1]
    if 'rosnode list' in cmd: print('/map_server\\n/amcl\\n/move_base')
    elif 'rostopic info' in cmd: print(' * /map_server')
    elif 'pgrep -af' in cmd: print('42 roslaunch map:=/maps/map')
''')
        docker.chmod(0o755)
        self.env = dict(os.environ, PATH=str(self.root) + ':' + os.environ['PATH'],
                        MAP_DIR=str(self.root), TRACE=str(self.trace))

    def run_script(self, name, code):
        return subprocess.run(['bash', str(self.root / name), 'map'],
                              env=dict(self.env, GUARD_CODE=str(code)),
                              capture_output=True, text=True, timeout=10)

    def test_guard_failure_blocks_navigation_launch_and_reuse(self):
        result = self.run_script('start-navigation.sh', 9)
        self.assertEqual(result.returncode, 9, result.stderr)
        trace = self.trace.read_text()
        self.assertIn('guard prepare-navigation', trace)
        self.assertNotIn('rosnode list', trace)
        self.assertNotIn("'exec', '-d'", trace)

    def test_guard_runs_before_healthy_navigation_reuse(self):
        result = self.run_script('start-navigation.sh', 0)
        self.assertEqual(result.returncode, 0, result.stderr)
        trace = self.trace.read_text()
        self.assertLess(trace.index('guard prepare-navigation'), trace.index('rosnode list'))
        self.assertNotIn("'exec', '-d'", trace)

    def test_keyboard_guard_failure_blocks_interactive_launch(self):
        result = self.run_script('start-keyboard.sh', 9)
        self.assertEqual(result.returncode, 9, result.stderr)
        self.assertIn('guard check-keyboard', self.trace.read_text())
        self.assertNotIn("'-it'", self.trace.read_text())

    def test_invalid_map_does_not_stop_keyboard(self):
        (self.root / 'map.yaml').unlink()
        result = self.run_script('start-navigation.sh', 0)
        self.assertEqual(result.returncode, 1)
        self.assertFalse(self.trace.exists())


if __name__ == '__main__':
    unittest.main()