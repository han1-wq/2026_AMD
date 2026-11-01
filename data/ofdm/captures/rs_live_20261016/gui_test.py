"""Exercise the maintained GUI's image action and leave its result visible."""
import hashlib
import json
from pathlib import Path
import sys
import time
import tkinter as tk
from tkinter import ttk

out = Path(__file__).resolve().parent
root_path = out.parents[2]
sys.path.insert(0, str(root_path / 'host'))
from dma_gui import Console

source = root_path / 'sim/captures/demo_20261009/demo_source.png'
destination = out / 'gui_received.png'
root = tk.Tk()
app = Console(root)
app.source.set(str(source))
app.destination.set(str(destination))
app.board.set('192.168.137.10')
for frame in root.winfo_children():
    for widget in frame.winfo_children():
        if isinstance(widget, ttk.Notebook):
            widget.select(1)
start = time.monotonic()


def collect():
    if 'image' in app.jobs:
        root.after(200, collect)
        return
    status = app.image_status.get()
    result = dict(status=status, elapsed_s=time.monotonic() - start,
                  source=str(source), received=str(destination),
                  success='PASS' in status and destination.exists()
                  and destination.read_bytes() == source.read_bytes())
    if destination.exists():
        result['sha256'] = hashlib.sha256(destination.read_bytes()).hexdigest()
    (out / 'gui_result.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    (out / 'gui_transfer.log').write_text(app.log.get('1.0', 'end-1c'))
    print(json.dumps(result, ensure_ascii=False), flush=True)


def run():
    app.send_image()
    root.after(300, collect)


root.after(500, run)
root.mainloop()