"""Run the real board startup script with isolated Docker/X11 fixtures."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


BASE = Path(__file__).resolve().parent


class BoardViewerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.state = self.root / 'state.json'
        self.trace = self.root / 'trace.jsonl'
        self.config = self.root / 'remote-rviz'
        self.config.mkdir()
        for name in ('slam-view.launch', 'slam.rviz', 'navigation-view.launch', 'navigation.rviz'):
            shutil.copy2(BASE / name, self.config / name)
        (self.root / 'launcher-env.sh').write_text('')
        (self.root / 'X0').touch()
        (self.root / 'auth').touch()
        script = (BASE.parent / 'start-rviz.sh').read_text()
        # Substitute only the X socket path, leaving startup logic intact.
        (self.root / 'start-rviz.sh').write_text(script.replace('/tmp/.X11-unix/X0', str(self.root / 'X0')))
        docker = self.root / 'docker'
        docker.write_text('''#!/usr/bin/env python3
import json, os, sys
from pathlib import Path
args = sys.argv[1:]
root = Path(os.environ['FIXTURE_ROOT'])
state = root / 'state.json'
with (root / 'trace.jsonl').open('a') as stream:
    stream.write(json.dumps(args) + '\\n')
if args[:2] == ['image', 'inspect']:
    sys.exit(int(os.environ.get('IMAGE_FAIL', '0')))
if args[0] == 'inspect':
    if not state.exists(): sys.exit(1)
    data = json.loads(state.read_text())
    if '--format' in args:
        fmt = args[args.index('--format') + 1]
        values = {'{{.State.Status}}': data.get('status', 'running'),
                  '{{.State.Running}}': 'false' if os.environ.get('EXIT_EARLY') else 'true',
                  '{{.Config.Image}}': data.get('image', 'x3plus:melodic-arm64'),
                  '{{range .Config.Env}}{{println .}}{{end}}': '\\n'.join(data.get('env', []))}
        for key in ('mode', 'signature'):
            values['{{index .Config.Labels "x3plus.viewer.' + key + '"}}'] = data.get(key, '')
        print(values[fmt])
elif args[0] in ('stop', 'rm'):
    if args[0] == 'stop' and os.environ.get('STOP_FAIL'): sys.exit(1)
    if args[0] == 'stop' and os.environ.get('PERSISTENT'):
        data = json.loads(state.read_text()); data['status'] = 'exited'
        state.write_text(json.dumps(data))
    else:
        state.unlink(missing_ok=True)
elif args[0] == 'run':
    labels = dict(args[i+1].split('=', 1) for i, a in enumerate(args) if a == '--label')
    env = [args[i+1] for i, a in enumerate(args) if a == '--env']
    state.write_text(json.dumps({'mode': labels['x3plus.viewer.mode'],
                                'signature': labels['x3plus.viewer.signature'], 'env': env}))
    print('fixture-container')
''')
        docker.chmod(0o755)
        sleep = self.root / 'sleep'
        sleep.write_text('#!/bin/sh\nexit 0\n')
        sleep.chmod(0o755)
        self.env = dict(os.environ, PATH=str(self.root) + ':' + os.environ['PATH'],
                        FIXTURE_ROOT=str(self.root), XAUTHORITY=str(self.root / 'auth'),
                        XDG_RUNTIME_DIR=str(self.root), DISPLAY=':0',
                        ROS_MASTER_URI='http://192.168.43.182:11311',
                        ROS_HOSTNAME='192.168.43.182')

    def invoke(self, mode='map', **env):
        return subprocess.run(['bash', str(self.root / 'start-rviz.sh'), mode],
                              env=dict(self.env, **env), capture_output=True, text=True, timeout=10)

    def commands(self):
        return [json.loads(line) for line in self.trace.read_text().splitlines()]

    def successful(self, mode='map', **env):
        result = self.invoke(mode, **env)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def test_new_viewer_detaches_and_uses_shared_slam_config(self):
        self.successful()
        run = next(c for c in self.commands() if c[0] == 'run')
        self.assertIn('-d', run)
        self.assertIn('x3plus.viewer.mode=slam', run)
        self.assertIn('roslaunch /pc-rviz/slam-view.launch viewer_name:=kv260_slam_rviz', run[-1])

    def test_unchanged_viewer_is_reused(self):
        self.successful('navigate')
        self.trace.write_text('')
        self.assertIn('复用', self.successful('navigate').stdout)
        self.assertFalse(any(c[0] in ('stop', 'rm', 'run') for c in self.commands()))

    def test_modes_switch_both_directions(self):
        self.successful()
        for mode, expected in (('navigate', 'navigation'), ('map', 'slam')):
            self.trace.write_text('')
            self.successful(mode)
            commands = self.commands()
            self.assertLess(next(i for i, c in enumerate(commands) if c[0] == 'stop'),
                            next(i for i, c in enumerate(commands) if c[0] == 'run'))
            self.assertEqual(json.loads(self.state.read_text())['mode'], expected)

    def test_network_change_rebuilds_viewer(self):
        self.successful()
        self.trace.write_text('')
        self.successful(ROS_MASTER_URI='http://192.168.50.2:11311', ROS_HOSTNAME='192.168.50.2')
        self.assertTrue(any(c[0] == 'stop' for c in self.commands()))

    def test_configuration_change_rebuilds_viewer(self):
        self.successful()
        self.trace.write_text('')
        with (self.config / 'slam.rviz').open('a') as stream:
            stream.write('\n# Updated fixture\n')
        self.successful()
        self.assertTrue(any(c[0] == 'stop' for c in self.commands()))

    def test_legacy_unlabelled_container_is_replaced(self):
        self.state.write_text('{}')
        self.successful('navigate', PERSISTENT='1')
        operations = [c[0] for c in self.commands()]
        self.assertLess(operations.index('stop'), operations.index('rm'))
        self.assertLess(operations.index('rm'), operations.index('run'))

    def test_stopped_container_is_removed_before_start(self):
        self.state.write_text(json.dumps({'status': 'exited'}))
        self.successful()
        operations = [c[0] for c in self.commands()]
        self.assertNotIn('stop', operations)
        self.assertLess(operations.index('rm'), operations.index('run'))

    def test_missing_image_does_not_stop_existing_viewer(self):
        self.successful()
        self.trace.write_text('')
        self.assertNotEqual(self.invoke('navigate', IMAGE_FAIL='1').returncode, 0)
        self.assertFalse(any(c[0] in ('stop', 'rm', 'run') for c in self.commands()))

    def test_stop_failure_does_not_launch_duplicate(self):
        self.successful()
        self.trace.write_text('')
        self.assertNotEqual(self.invoke('navigate', STOP_FAIL='1').returncode, 0)
        self.assertFalse(any(c[0] in ('rm', 'run') for c in self.commands()))

    def test_viewer_early_exit_is_failure(self):
        result = self.invoke(EXIT_EARLY='1')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('RViz 未能保持运行', result.stderr)

    def test_invalid_mode_never_contacts_docker(self):
        self.assertEqual(self.invoke('invalid').returncode, 2)
        self.assertFalse(self.trace.exists())


if __name__ == '__main__':
    unittest.main()