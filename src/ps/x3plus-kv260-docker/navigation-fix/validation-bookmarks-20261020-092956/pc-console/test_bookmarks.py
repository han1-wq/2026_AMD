"""Start-pose persistence and GUI safeguards; no live Docker/ROS calls."""
import json
import math
import os
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import console_backend as backend
import test_console


class BookmarkTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        setting = patch.object(backend, 'CONFIG', Path(self.temp.name)/'config.json')
        setting.start()
        self.addCleanup(setting.stop)
        self.snapshot = {'ready': True, 'stationary': True, 'pose': [2., 1., .6],
                         'map': {'sha256': 'a'*64, 'resolution': .05, 'width': 240, 'height': 200,
                                 'origin': [-4., -4., 0.], 'frame': 'map'}}
        self.data = {'pc_ip': '192.168.1.2', 'kv260_ip': '192.168.1.3', 'port': '11311'}

    def save(self):
        with patch.object(backend, 'bookmark_ros', return_value=self.snapshot):
            return backend.save_bookmark('起点 A', self.data, True)

    def test_roundtrip_atomic_and_explicit_overwrite(self):
        entry = self.save()
        self.assertEqual(backend.bookmarks(), {'起点 A': entry})
        self.assertEqual(list(Path(self.temp.name).iterdir()), [backend.CONFIG.with_name('start-poses.json')])
        with patch.object(backend, 'bookmark_ros') as remote:
            with self.assertRaises(ValueError):
                backend.save_bookmark('起点 A', self.data, True)
            remote.assert_not_called()

    def test_no_save_without_verification_readiness_or_stationary(self):
        with patch.object(backend, 'bookmark_ros') as remote:
            with self.assertRaises(ValueError):
                backend.save_bookmark('A', self.data)
            remote.assert_not_called()
        for key in ('ready', 'stationary'):
            with self.subTest(key=key), patch.object(backend, 'bookmark_ros', return_value=dict(self.snapshot, **{key: False})):
                with self.assertRaises(ValueError):
                    backend.save_bookmark('A', self.data, True)
        self.assertEqual(backend.bookmarks(), {})

    def test_restore_requires_placement_preview_does_not(self):
        self.save()
        with patch.object(backend, 'bookmark_ros', return_value={'ok': True}) as remote:
            with self.assertRaises(ValueError):
                backend.use_bookmark('起点 A', self.data, True)
            remote.assert_not_called()
            backend.use_bookmark('起点 A', self.data)
            self.assertEqual(remote.call_args.args[1]['action'], 'preview')
            backend.use_bookmark('起点 A', self.data, True, True)
            self.assertEqual(remote.call_args.args[1]['action'], 'restore')
            self.assertTrue(remote.call_args.args[1]['physical_placement_confirmed'])

    def test_corrupt_bookmarks_not_overwritten(self):
        path = backend.CONFIG.with_name('start-poses.json')
        path.write_text('[]')
        with self.assertRaises(ValueError):
            self.save()
        self.assertEqual(path.read_text(), '[]')

    def test_reject_nonfinite_and_invalid_heading(self):
        entry = self.save()
        for value in (math.nan, math.inf, True, '0', 4.):
            with self.subTest(value=value), self.assertRaises(ValueError):
                backend.validate_bookmark(dict(entry, pose=[2., 1., value]))

    def test_slam_or_wrong_network_never_executes(self):
        for viewer in ({'running': False}, {'running': True, 'mode': 'slam'},
                       {'running': True, 'mode': 'navigation', 'master': 'wrong'}):
            with patch.object(backend, 'viewer_state', return_value=viewer), patch.object(backend, 'run') as command:
                with self.assertRaises(ValueError):
                    backend.bookmark_ros(self.data, {'action': 'snapshot'})
                command.assert_not_called()

    def test_request_data_is_stdin_not_shell_source(self):
        viewer = {'running': True, 'mode': 'navigation', 'master': backend.master_url(self.data),
                  'pc_ip': self.data['pc_ip']}
        req = {'action': 'preview', 'name': '"; touch /tmp/not-executed; #'}
        with patch.object(backend, 'viewer_state', return_value=viewer), patch.object(backend, 'run', return_value='{"ok":true,"result":{}}') as command:
            backend.bookmark_ros(self.data, req)
            self.assertEqual(json.loads(command.call_args.kwargs['input']), req)
            self.assertNotIn(req['name'], ' '.join(command.call_args.args[0]))


@unittest.skipUnless(os.environ.get('DISPLAY'), 'requires a graphical desktop')
class BookmarkGuiTests(unittest.TestCase):
    make_app = test_console.GuiTests.make_app
    def test_restore_cancel_does_not_send_request(self):
        app = self.make_app()
        app.bookmark_box.set('A')
        with patch.object(backend, 'bookmarks', return_value={'A': {'pose': [2., 1., .6]}}), patch('tkinter.messagebox.askyesno', return_value=False), patch.object(app, 'operation') as operation:
            app.restore_start_pose()
            operation.assert_not_called()

    def test_restore_confirmation_invalidates_previous_probe(self):
        app = self.make_app()
        app.bookmark_box.set('A')
        app.last_probe = (0, app.data())
        with patch.object(backend, 'bookmarks', return_value={'A': {'pose': [2., 1., .6]}}), patch('tkinter.messagebox.askyesno', return_value=True), patch.object(app, 'operation') as operation:
            app.restore_start_pose()
            operation.assert_called_once()
            self.assertIsNone(app.last_probe)


if __name__ == '__main__':
    unittest.main()