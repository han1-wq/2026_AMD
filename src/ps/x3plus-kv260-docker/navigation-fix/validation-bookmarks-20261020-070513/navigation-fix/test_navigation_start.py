"""Exercise host startup/reuse with fake Docker; never contact a robot."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

BASE = Path(__file__).resolve().parents[1]


class NavigationStartTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.trace = self.root/'trace'
        shutil.copy2(BASE/'start-navigation.sh', self.root/'start-navigation.sh')
        (self.root/'launcher-env.sh').write_text('')
        (self.root/'launcher_core.py').write_text('')
        (self.root/'launcher_modes.py').write_text(
            'import os\nfrom pathlib import Path\n'
            'with Path(os.environ["TRACE"]).open("a") as f: f.write("prepare-navigation\\n")\n')
        (self.root/'navigation-fix').mkdir()
        (self.root/'navigation-fix/sync-runtime.py').write_text(
            'import os,sys\nfrom pathlib import Path\n'
            'with Path(os.environ["TRACE"]).open("a") as f: f.write("check-runtime\\n")\n'
            'sys.exit(int(os.environ.get("SYNC_CODE", "0")))\n')
        (self.root/'map.yaml').write_text('image: map.pgm\n')
        (self.root/'map.pgm').write_text('test')
        docker = self.root/'docker'
        docker.write_text('''#!/usr/bin/env python3
import os,sys
from pathlib import Path
args=sys.argv[1:]
with Path(os.environ['TRACE']).open('a') as f: f.write(repr(args)+'\\n')
if args[0]=='inspect':
    print(os.environ['MAP_DIR'] if '.Mounts' in args[-1] else 'true')
elif 'bash' in args:
    cmd=args[-1]
    if 'rosnode list' in cmd: print('/map_server\\n/amcl\\n/move_base\\n/navigation_guard')
    elif 'rostopic info' in cmd: print(' * /map_server')
    elif 'pgrep -af' in cmd: print('42 roslaunch map:=/maps/map')
    elif 'rosservice call /navigation_guard/reset' in cmd: print('success: True')
''')
        docker.chmod(0o755)
        self.env = dict(os.environ, PATH=str(self.root)+':'+os.environ['PATH'],
                        MAP_DIR=str(self.root), TRACE=str(self.trace))

    def invoke(self, **env):
        return subprocess.run(['bash', str(self.root/'start-navigation.sh'), 'map'],
                              capture_output=True, text=True, timeout=10, env=dict(self.env, **env))

    def test_same_map_reuse_resets_localization_without_relaunch(self):
        result = self.invoke()
        self.assertEqual(result.returncode, 0, result.stderr)
        trace = self.trace.read_text()
        self.assertLess(trace.index('check-runtime'), trace.index('prepare-navigation'))
        self.assertIn('rosservice call /navigation_guard/reset', trace)
        self.assertNotIn("'exec', '-d'", trace)
        self.assertIn('重新设置 2D Pose Estimate', result.stdout)

    def test_runtime_mismatch_blocks_mode_switch_and_navigation(self):
        result = self.invoke(SYNC_CODE='1')
        self.assertEqual(result.returncode, 1)
        self.assertNotIn('prepare-navigation', self.trace.read_text())
        self.assertNotIn("'exec', '-d'", self.trace.read_text())

    def test_missing_map_does_not_change_robot_mode(self):
        (self.root/'map.yaml').unlink()
        result = self.invoke()
        self.assertEqual(result.returncode, 1)
        self.assertFalse(self.trace.exists())


if __name__ == '__main__':
    unittest.main()