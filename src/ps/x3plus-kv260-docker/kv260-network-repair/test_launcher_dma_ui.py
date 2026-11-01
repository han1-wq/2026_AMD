import json
import os
from pathlib import Path
import tempfile
import threading
import tkinter as tk
import unittest
from unittest.mock import Mock, patch

from launcher_dma_ui import OFDMPanel


@unittest.skipUnless(os.environ.get('DISPLAY'), 'desktop display required')
class ShortcutTests(unittest.TestCase):
    def setUp(self):
        self.root = tk.Tk()
        self.root.withdraw()
        self.page = tk.Frame(self.root)
        self.app = Mock(root=self.root, env={}, selected='vision', snapshot={
            'serial': {'ROBOT': {'ok': True, 'message': 'OK'}}, 'devices': [],
            'camera': True})
        self.app.tabs = Mock()
        self.app.ofdm_tab = 'ofdm'
        self.panel = OFDMPanel(self.app, self.page)
        self.folder = tempfile.TemporaryDirectory()

    def tearDown(self):
        self.panel.close()
        self.root.destroy()
        self.folder.cleanup()

    def test_task_button_sends_selected_state_and_log(self):
        folder = Path(self.folder.name)
        (folder / 'vision.json').write_text('{"status":"running","pid":42}')
        (folder / 'vision.log').write_text('新视觉日志')
        with patch('launcher_dma_ui.state_dir', return_value=folder), \
                patch('launcher_dma_ui.is_active', return_value=True), \
                patch.object(self.panel, 'launch') as launch:
            self.panel.task_button.invoke()
        args = launch.call_args[0][1]
        data = json.loads(bytes.fromhex(args[args.index('--hex') + 1]))
        self.assertEqual(data['state']['pid'], 42)
        self.assertEqual(data['log'], '新视觉日志')
        self.assertTrue(data['active'])

    def test_runtime_button_and_capture_button(self):
        with patch.object(self.panel, 'launch') as launch:
            self.panel.runtime_button.invoke()
        args = launch.call_args[0][1]
        self.assertEqual(json.loads(bytes.fromhex(args[args.index('--hex') + 1]))['type'],
                         'usb_runtime')
        with patch.object(self.panel, 'capture') as capture:
            self.panel.capture_send_button.invoke()
        capture.assert_called_once_with(True)

    def drain_events(self):
        self.root.after_cancel(self.panel.timer)
        self.panel.poll()

    def test_default_capture_uses_ipc_and_legacy_topic_is_explicit(self):
        with patch.object(self.panel, 'launch') as launch:
            self.panel.capture()
        command = launch.call_args.kwargs['command']
        self.assertEqual(command[0], '/usr/bin/python3')
        self.assertNotIn('--topic', command)
        self.panel.topic.set('/yolov4/image')
        with patch.object(self.panel, 'launch') as launch:
            self.panel.capture()
        command = launch.call_args.kwargs['command']
        self.assertEqual(command[0], '/bin/bash')
        self.assertEqual(command[command.index('--topic') + 1], '/yolov4/image')

    def test_cancel_capture_only_cancels_snapshot_job(self):
        event = threading.Event()
        self.panel.jobs['capture'] = event
        self.panel.cancel('capture')
        self.assertTrue(event.is_set())
        self.app.submit.assert_not_called()

    def test_failed_capture_clears_previous_return_and_never_sends(self):
        self.panel.photos['received'] = tk.PhotoImage(width=1, height=1)
        with patch.object(self.panel, 'launch'):
            self.panel.capture(True)
        self.assertNotIn('received', self.panel.photos)
        self.panel.events.put(('done', ('capture', False, None, False)))
        with patch.object(self.panel, 'send_image') as send:
            self.drain_events()
        send.assert_not_called()
        self.assertIn('失败', self.panel.image_status.get())

    def test_capture_automatically_sends_and_previews_actual_return(self):
        source = Path(self.folder.name) / 'frame.png'
        returned = source.with_name('frame-returned.png')
        for path, color in ((source, 'red'),):
            photo = tk.PhotoImage(width=1, height=1)
            photo.put(color, to=(0, 0, 1, 1))
            photo.write(str(path), format='png')
        with patch.object(self.panel, 'launch'):
            self.panel.capture(True)
        self.panel.jobs['capture'] = threading.Event()
        self.panel.events.put(('done', ('capture', True, source, False)))
        with patch.object(self.panel, 'launch') as launch:
            self.drain_events()
        self.assertEqual(launch.call_args[0][0], 'image')
        self.assertEqual(launch.call_args[0][2], returned)
        self.assertNotIn('received', self.panel.photos)
        photo.put('blue', to=(0, 0, 1, 1))
        photo.write(str(returned), format='png')
        self.panel.events.put(('done', ('image', True, returned, False)))
        self.drain_events()
        self.assertEqual(self.panel.photos['received'].get(0, 0), (0, 0, 255))
        self.assertIn('PASS', self.panel.image_status.get())


if __name__ == '__main__':
    unittest.main()