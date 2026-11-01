import os
from pathlib import Path
import tempfile
import time
import tkinter as tk
import unittest
from unittest.mock import patch

from dma_gui import Console


@unittest.skipUnless(os.environ.get('DISPLAY') or os.name == 'nt', 'desktop display required')
class GuiTests(unittest.TestCase):
    def setUp(self):
        self.root = tk.Tk()
        self.root.withdraw()
        self.console = Console(self.root)
        self.directory = tempfile.TemporaryDirectory()

    def tearDown(self):
        self.console.close()
        end = time.monotonic() + 4
        while self.console.jobs and time.monotonic() < end:
            self.root.update()
            time.sleep(0.02)
        try:
            self.root.after_cancel(self.console.timer)
            self.root.destroy()
        except tk.TclError:
            pass
        self.directory.cleanup()

    def pump(self):
        end = time.monotonic() + 5
        while self.console.jobs and time.monotonic() < end:
            self.root.update()
            time.sleep(0.02)
        self.assertFalse(self.console.jobs)

    def test_preview_uses_saved_received_file(self):
        path = Path(self.directory.name) / 'returned.png'
        image = tk.PhotoImage(width=8, height=8)
        image.put('red', to=(0, 0, 8, 8))
        image.write(str(path), format='png')
        self.console.jobs['image'] = __import__('threading').Event()
        self.console.events.put(('done', ('image', True, path, False)))
        self.pump()
        self.assertEqual(self.console.photos['received'].get(0, 0), (255, 0, 0))
        self.assertIn('SHA256:', self.console.image_status.get())

    def test_failed_transfer_does_not_display_source_as_return(self):
        self.console.jobs['image'] = __import__('threading').Event()
        self.console.events.put(('done', ('image', False, None, False)))
        self.pump()
        self.assertNotIn('received', self.console.photos)
        self.assertIn('失败', self.console.image_status.get())

    def test_cancel_child_process(self):
        script = Path(self.directory.name) / 'block.py'
        script.write_text('import time\nprint("started", flush=True)\ntime.sleep(60)\n')
        self.console.launch('uart', [str(script)])
        self.console.cancel('uart')
        self.pump()
        self.assertEqual(self.console.uart_status.get(), '已停止')

    def test_text_payload_is_encoded_for_dma_client(self):
        self.console.mode.set('text')
        self.console.payload.delete('1.0', 'end')
        self.console.payload.insert('1.0', '你好 OFDM')
        with patch.object(self.console, 'launch') as launch:
            self.console.send_uart()
        args = launch.call_args[0][1]
        self.assertEqual(bytes.fromhex(args[args.index('--hex') + 1]).decode(), '你好 OFDM')


if __name__ == '__main__':
    unittest.main()