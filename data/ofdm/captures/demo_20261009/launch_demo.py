"""Run the existing desktop console and save evidence of this live demo."""
import hashlib
import json
from pathlib import Path
import shutil
import sys
import time
import tkinter as tk
from tkinter import ttk

out = Path(__file__).resolve().parent
project = out.parents[2]
sys.path.insert(0, str(project / 'host'))
from dma_gui import Console

image_input = Path(sys.argv[1]) if len(sys.argv) > 1 else project / 'release_dma/live/test_image.png'
if len(sys.argv) > 2:
    out = Path(sys.argv[2]).resolve()
    out.mkdir(parents=True, exist_ok=True)
source = out / 'demo_source.png'
destination = out / 'demo_received.png'
if destination.exists():
    raise RuntimeError('Demo output already exists; choose a new capture directory')
shutil.copyfile(image_input, source)
root = tk.Tk()
console = Console(root)
console.board.set('192.168.137.10')
console.port.set('/dev/ttyUSB1')
console.source.set(str(source))
console.destination.set(str(destination))
console.preview('source', source)
console.mode.set('text')
console.payload.delete('1.0', 'end')
console.payload.insert('1.0', 'OFDM live demo 2026-10-09: UART and image RF loopback')
for widget in root.winfo_children()[0].winfo_children():
    if isinstance(widget, ttk.Notebook):
        widget.select(1)
root.lift()
started = time.monotonic()

def check():
    text = console.log.get('1.0', 'end-1c')
    (out / 'gui_live.log').write_text(text, encoding='utf-8')
    if not console.jobs:
        equal = destination.exists() and source.read_bytes() == destination.read_bytes()
        result = {
            'board': console.board.get(), 'source': str(source),
            'received': str(destination), 'bytes': source.stat().st_size,
            'byte_equal': equal,
            'sha256': hashlib.sha256(destination.read_bytes()).hexdigest() if destination.exists() else None,
            'uart_pass': 'UART LOOPBACK PASS:' in text,
            'image_pass': '[image] LOOPBACK PASS:' in text,
            'returned_preview_loaded': 'received' in console.photos,
            'uart_status': console.uart_status.get(), 'image_status': console.image_status.get(),
        }
        (out / 'demo_result.json').write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
        print(json.dumps(result, ensure_ascii=False), flush=True)
        return
    if time.monotonic() - started > 120:
        console.cancel('uart')
        console.cancel('image')
    root.after(500, check)

def start():
    console.send_uart()
    console.send_image()
    root.after(500, check)

root.after(1000, start)
root.mainloop()