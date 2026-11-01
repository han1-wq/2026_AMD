#!/usr/bin/env python3
"""Exercise the real embedded capture/send/returned-preview path on the board."""
import hashlib
import json
from pathlib import Path
import time
import tkinter as tk
from types import SimpleNamespace
from tkinter import ttk

from launcher_dma_ui import OFDMPanel


def main():
    root = tk.Tk()
    root.title('OFDM AI 视觉真实回环验证')
    root.geometry('1180x860+20+20')
    tabs = ttk.Notebook(root)
    tabs.pack(fill='both', expand=True)
    page = ttk.Frame(tabs)
    tabs.add(page, text='OFDM 通信')
    app = SimpleNamespace(root=root, env={}, tabs=tabs, ofdm_tab=page)
    panel = OFDMPanel(app, page)
    panel.tabs.select(panel.image_page)
    started = time.monotonic()
    report = {}
    directory = Path('/home/ubuntu/kv260_B3136/logs')

    def check():
        if not panel.jobs and report.get('invoked'):
            source, returned = Path(panel.source.get()), Path(panel.destination.get())
            passed = ('PASS' in panel.image_status.get() and returned.is_file()
                      and source.read_bytes() == returned.read_bytes()
                      and 'received' in panel.photos)
            report.update(passed=passed, source=str(source), returned=str(returned),
                          elapsed_s=time.monotonic() - started,
                          status=panel.image_status.get(),
                          log=panel.log.get('1.0', 'end-1c'))
            if source.is_file():
                report.update(bytes=source.stat().st_size,
                              sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
                              capture=json.loads(source.with_suffix('.json').read_text()))
            (directory / 'ofdm-ai-live-validation.json').write_text(
                json.dumps(report, ensure_ascii=False, indent=2) + '\n')
            root.update_idletasks()
            from capture_desktop import capture
            capture(str(directory / 'ofdm-ai-live-desktop.png'))
            root.after(1500, finish)
            return
        if time.monotonic() - started > 75:
            report.update(passed=False, error='GUI validation timed out')
            (directory / 'ofdm-ai-live-validation.json').write_text(json.dumps(report))
            finish()
            return
        root.after(100, check)

    def finish():
        panel.close()
        root.destroy()

    def invoke():
        report['invoked'] = True
        panel.capture_send_button.invoke()
        root.after(100, check)

    root.after(800, invoke)
    root.mainloop()
    if not report.get('passed'):
        raise SystemExit(1)
    print('OFDM_AI_GUI_LOOPBACK_PASS', flush=True)


if __name__ == '__main__':
    main()