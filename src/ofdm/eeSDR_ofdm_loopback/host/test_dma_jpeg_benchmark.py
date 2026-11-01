from io import BytesIO
import json
from pathlib import Path
import socket
import struct
import tempfile
import threading
import unittest
import zlib

from PIL import Image

from dma_image import decode, read_record, send_record
from dma_jpeg_benchmark import due_frame, run


class VideoScheduleTests(unittest.TestCase):
    def test_overload_drops_stale_frames(self):
        self.assertEqual(due_frame(0.65, 10, 1, 100), 6)

    def test_early_wakeup_does_not_repeat_frame(self):
        self.assertEqual(due_frame(0.099, 10, 1, 100), 1)

    def test_end_of_stream_does_not_send_out_of_range(self):
        self.assertEqual(due_frame(12, 10, 80, 100), 100)

    def test_paced_jpeg_decode_and_saved_evidence(self):
        errors = []
        with tempfile.TemporaryDirectory() as directory, socket.socket() as server:
            root = Path(directory)
            frames = root / 'frames'
            frames.mkdir()
            buffer = BytesIO()
            Image.new('RGB', (32, 24), 'blue').save(buffer, format='JPEG')
            data = buffer.getvalue()
            (frames / 'frame.jpg').write_bytes(data)
            server.bind(('127.0.0.1', 0))
            server.listen(1)
            server.settimeout(3)

            def peer():
                try:
                    connection, _ = server.accept()
                    with connection:
                        connection.settimeout(3)
                        for _ in range(2):
                            meta = read_record(connection)
                            _, _, sid, mid, _, count, _, _ = decode(meta)
                            send_record(connection, meta)
                            for _ in range(count):
                                send_record(connection, read_record(connection))
                            for code, detail in ((1, zlib.crc32(data)), (6, len(data))):
                                send_record(connection, struct.pack('<2sBBIII', b'OS', 1,
                                                                   code, sid, mid, detail))
                except Exception as exc:
                    errors.append(exc)

            thread = threading.Thread(target=peer)
            thread.start()
            try:
                output = root / 'result'
                summary = run('127.0.0.1', frames, output, 5, .4,
                              port=server.getsockname()[1], save_frames=True)
            finally:
                thread.join(4)
            self.assertFalse(thread.is_alive())
            self.assertFalse(errors, errors)
            self.assertEqual(summary['successes'], 2)
            self.assertEqual(summary['dropped_source_frames'], 0)
            self.assertEqual(summary['unattempted_frames'], 0)
            self.assertEqual(summary['differing_bits'], 0)
            self.assertEqual(summary['compared_bits'], len(data) * 16)
            self.assertGreaterEqual(summary['wall_s'], .4)
            self.assertEqual((output / 'last_received.jpg').read_bytes(), data)
            self.assertEqual(len(list((output / 'received').glob('*.jpg'))), 2)
            self.assertTrue(all(p.read_bytes() == data for p in (output / 'received').glob('*.jpg')))
            self.assertEqual(json.loads((output / 'summary.json').read_text()), summary)


if __name__ == '__main__':
    unittest.main()