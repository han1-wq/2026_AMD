"""Check that ROS row padding and RGB ordering survive PNG capture."""
import tempfile
import contextlib
import hashlib
import io
import json
import os
import threading
import time
from pathlib import Path
from types import SimpleNamespace
import unittest

from launcher_yolo_capture import save_frame, capture_desktop


class CaptureTests(unittest.TestCase):
    def frame(self, encoding='rgb8'):
        return SimpleNamespace(width=1, height=2, step=4, encoding=encoding,
                               data=bytes([255, 0, 0, 99, 0, 255, 0, 99]),
                               header=SimpleNamespace(stamp=SimpleNamespace(sec=1, nanosec=2), frame_id='camera'))

    def test_padded_rgb_image(self):
        import cv2
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'image.png'
            result = save_frame(self.frame(), path)
            image = cv2.imread(str(path))
            self.assertEqual(image.tolist(), [[[0, 0, 255]], [[0, 255, 0]]])
            self.assertEqual(result['bytes'], path.stat().st_size)
            self.assertFalse(path.with_name('image.png.part').exists())

    def test_rejects_depth_buffer_and_bad_stride(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'image.png'
            for field, value in [('encoding', '16UC1'), ('step', 2), ('data', b'')]:
                message = self.frame()
                setattr(message, field, value)
                with self.assertRaises(ValueError):
                    save_frame(message, path)
                self.assertFalse(path.exists())


class DesktopCaptureTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.directory = Path(self.folder.name)
        self.output = self.directory / 'capture.png'

    def publish(self, state='running', old=False, gap=False):
        payload = b'P6\n640 480\n255\n' + bytes([255, 0, 0]) * (640 * 480)
        frame = self.directory / 'frame.ppm'
        temporary = self.directory / 'frame.tmp'
        temporary.write_bytes(payload)
        temporary.replace(frame)
        updated = time.time() - (10 if old or gap else 0)
        if old:
            os.utime(frame, (updated, updated))
        status = dict(state=state, updated=updated, display_mode='enhanced',
                      message={'sequence': 42, 'preprocessing': {'brightness': 12}})
        temporary.write_text(json.dumps(status))
        temporary.replace(self.directory / 'status.json')

    def test_waits_for_new_frame_and_preserves_pixels_and_configuration(self):
        import cv2
        self.publish(old=True)
        producer = threading.Timer(.08, self.publish)
        producer.start()
        try:
            with contextlib.redirect_stdout(io.StringIO()):
                metadata = capture_desktop(self.output, self.directory, timeout=1)
        finally:
            producer.join()
        self.assertEqual(cv2.imread(str(self.output))[0, 0].tolist(), [0, 0, 255])
        self.assertEqual(metadata['message']['preprocessing']['brightness'], 12)
        self.assertEqual(metadata['sha256'], hashlib.sha256(self.output.read_bytes()).hexdigest())
        self.assertEqual(json.loads(self.output.with_suffix('.json').read_text()), metadata)

    def test_stale_or_missing_frames_cannot_be_sent(self):
        for old in (False, True):
            if old:
                self.publish(old=True)
            with self.assertRaises(TimeoutError):
                capture_desktop(self.output, self.directory, timeout=.1)
            self.assertFalse(self.output.exists())

    def test_frame_status_write_gap_is_rejected(self):
        producer = threading.Timer(.03, lambda: self.publish(gap=True))
        producer.start()
        try:
            with self.assertRaises(TimeoutError):
                capture_desktop(self.output, self.directory, timeout=.15)
        finally:
            producer.join()
        self.assertFalse(self.output.exists())

    def test_stopped_runtime_fails_without_using_retained_image(self):
        self.publish(state='stopped')
        with self.assertRaisesRegex(RuntimeError, '已停止'):
            capture_desktop(self.output, self.directory, timeout=1)
        self.assertFalse(self.output.exists())


if __name__ == '__main__':
    unittest.main()