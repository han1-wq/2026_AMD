"""Tk controls for metadata/log loopback, never a robot command channel."""
import json
import queue
import time
import tkinter as tk
from tkinter import ttk, messagebox, filedialog

from launcher_ofdm import MAX_BYTES, LogCursor, encode_message, make_worker
from launcher_tasks import state_dir


class OFDMPanel:
    def __init__(self, app, page):
        self.app, self.root = app, app.root
        self.worker = None
        self.active = False
        self.was_ready = False
        self.auto = tk.BooleanVar(value=False)
        self.cursor = LogCursor()
        self.states = {}
        self.next_sync = 0
        self.status = tk.StringVar(value='未连接')
        self.result = tk.StringVar(value='尚无回环校验结果')
        self.progress = tk.DoubleVar(value=0)
        self.targets = {'自动识别 FT2232 / 接口 1': {}}
        bar = ttk.Frame(page)
        bar.pack(fill='x')
        self.ports = ttk.Combobox(bar, state='readonly', width=54,
                                values=list(self.targets))
        self.ports.current(0)
        self.ports.pack(side='left', fill='x', expand=True)
        self.refresh_button = ttk.Button(bar, text='刷新设备', command=self.refresh)
        self.refresh_button.pack(side='left', padx=8)
        self.connect_button = ttk.Button(bar, text='连接', command=self.connect)
        self.connect_button.pack(side='left')
        ttk.Label(page, textvariable=self.status, wraplength=850).pack(anchor='w', pady=8)
        actions = ttk.Frame(page)
        actions.pack(fill='x')
        self.send_buttons = []
        for label, command in [('发送任务摘要', self.send_task), ('发送所选任务日志', self.send_log)]:
            button = ttk.Button(actions, text=label, command=command, state='disabled')
            button.pack(side='left', padx=(0, 8))
            self.send_buttons.append(button)
        ttk.Checkbutton(page, text='自动同步任务状态 / 所选任务新增日志',
                        variable=self.auto, command=self.reset_sync).pack(anchor='w', pady=8)
        self.text = tk.Text(page, height=3, wrap='word', font=('Sans', 10))
        self.text.pack(fill='x')
        row = ttk.Frame(page)
        row.pack(fill='x', pady=6)
        button = ttk.Button(row, text='发送文本', command=self.send_text, state='disabled')
        button.pack(side='left')
        self.send_buttons.append(button)
        ttk.Button(row, text='导出校验记录…', command=self.export).pack(side='right')
        ttk.Progressbar(page, variable=self.progress, maximum=100).pack(fill='x', pady=6)
        ttk.Label(page, textvariable=self.result, wraplength=850).pack(anchor='w', pady=6)
        frame = ttk.Frame(page)
        frame.pack(fill='both', expand=True)
        self.record = tk.Text(frame, height=8, state='disabled', wrap='word', font=('Monospace', 10))
        scroll = ttk.Scrollbar(frame, command=self.record.yview)
        self.record.configure(yscrollcommand=scroll.set)
        scroll.pack(side='right', fill='y')
        self.record.pack(fill='both', expand=True)
        try:
            self.worker = make_worker()
            self.worker.start()
            self.refresh()
        except (ImportError, OSError) as exc:
            self.status.set('OFDM 不可用：' + str(exc))
            self.connect_button.configure(state='disabled')
        self.timer = self.root.after(100, self.poll)

    def refresh(self):
        if self.active or self.worker is None:
            return
        from serial_devices import discover
        try:
            self.targets = {'自动识别 FT2232 / 接口 1': {}}
            for device in discover():
                if device.is_target:
                    self.targets[device.label] = {'serial_number': device.serial_number or None,
                                                   'location': device.location or None}
            self.ports.configure(values=list(self.targets))
            self.ports.current(0)
        except (OSError, ValueError) as exc:
            self.status.set(str(exc))

    def connect(self):
        if self.worker is None:
            return
        try:
            self.worker.control('disconnect' if self.active else 'connect',
                                self.targets[self.ports.get()])
            self.active = not self.active
            self.connect_button.configure(text='断开 / 停止重连' if self.active else '连接')
            self.status.set('连接中…' if self.active else '正在断开…')
            self.reset_sync()
        except (queue.Full, KeyError) as exc:
            messagebox.showerror('OFDM', str(exc), parent=self.root)

    def append(self, text):
        self.record.configure(state='normal')
        self.record.insert('end', time.strftime('%H:%M:%S ') + text + '\n')
        if int(self.record.count('1.0', 'end-1c', 'chars')[0] or 0) > 100000:
            self.record.delete('1.0', 'end-100000c')
        self.record.see('end')
        self.record.configure(state='disabled')

    def send(self, kind, content, action=None, automatic=False):
        action = action or self.app.selected
        try:
            data = encode_message(kind, action, content)
            if len(data) > MAX_BYTES:
                raise ValueError('消息含元数据后超过 24 KB；请缩短文本或日志')
            ident = self.worker.submit(data, kind)
            self.append('已排队 id=%08x kind=%s bytes=%d' % (ident, kind, len(data)))
            return True
        except (ValueError, queue.Full, AttributeError) as exc:
            error = '发送拒绝：队列已满' if isinstance(exc, queue.Full) else '发送拒绝：' + str(exc)
            self.append(error)
            if not automatic:
                messagebox.showerror('OFDM', error, parent=self.root)
            return False

    def task_state(self, action):
        try:
            return json.loads((state_dir() / (action + '.json')).read_text())
        except (OSError, ValueError):
            return {'message': '暂无任务记录'}

    def send_task(self):
        self.send('task', self.task_state(self.app.selected))

    def send_log(self):
        # Bound before JSON escaping, not just by displayed character count.
        try:
            with (state_dir() / (self.app.selected + '.log')).open('rb') as stream:
                stream.seek(0, 2)
                total = stream.tell()
                stream.seek(max(0, total - 3000))
                text = stream.read(3000).decode('utf-8', errors='replace')
            self.send('log', {'text': text, 'tail_only': True, 'file_bytes': total})
        except OSError as exc:
            messagebox.showerror('OFDM', str(exc), parent=self.root)

    def send_text(self):
        text = self.text.get('1.0', 'end-1c')
        if text.strip():
            self.send('text', text)

    def reset_sync(self):
        self.states.clear()
        self.cursor = LogCursor()
        self.cursor.read(state_dir() / (self.app.selected + '.log'), baseline=True)
        self.next_sync = time.monotonic() + 2

    def sync(self):
        action = self.app.selected
        state = self.task_state(action)
        if self.states.get(action) != state:
            if self.send('task', state, action, automatic=True):
                self.states[action] = state
        text = self.cursor.read_text(state_dir() / (action + '.log'))
        if text:
            self.send('log', {'text': text, 'incremental': True,
                             'skipped_bytes': self.cursor.skipped,
                             'offset': self.cursor.offset}, action, automatic=True)

    def poll(self):
        if self.app.closing:
            return
        if self.worker:
            for _ in range(100):
                try:
                    kind, value = self.worker.events.get_nowait()
                except queue.Empty:
                    break
                if kind == 'status':
                    self.status.set(value)
                elif kind == 'progress':
                    self.progress.set(100 * value['verified'] / value['total'])
                    self.result.set('id=%08x 分片 %d/%d · 已验证 %d · seq=%s · result=%s · flags=0x%02x · %s ms' %
                                    (value['id'], value['fragment'], value['total'], value['verified'],
                                     value['seq'], value['result'], value['flags'], value['latency_ms']))
                    self.append(json.dumps(value, ensure_ascii=False))
                elif kind == 'message':
                    self.progress.set(100 * value['verified'] / value['total'])
                    label = '回环校验通过' if value['passed'] else '回环校验未通过'
                    self.result.set('id=%08x %s · %d/%d 分片 · %s' %
                                    (value['id'], label, value['verified'], value['total'], value.get('error', '')))
                    self.append(label + ' ' + json.dumps(value, ensure_ascii=False))
                elif kind == 'log':
                    self.append(value.strip()[:2000])
            ready = self.worker.ready.is_set() and not self.worker.cancel.is_set()
            if ready != self.was_ready:
                self.reset_sync()
                self.was_ready = ready
            for button in self.send_buttons:
                button.configure(state='normal' if ready else 'disabled')
            self.ports.configure(state='disabled' if self.active else 'readonly')
            self.refresh_button.configure(state='disabled' if self.active else 'normal')
            if self.auto.get() and ready and time.monotonic() >= self.next_sync:
                self.next_sync = time.monotonic() + 2
                self.sync()
        self.timer = self.root.after(100, self.poll)

    def export(self):
        name = filedialog.asksaveasfilename(parent=self.root, defaultextension='.txt',
                                          initialfile='ofdm-validation.txt')
        if name:
            try:
                from pathlib import Path
                Path(name).write_text(self.record.get('1.0', 'end-1c'), encoding='utf-8')
            except OSError as exc:
                messagebox.showerror('OFDM', str(exc), parent=self.root)

    def close(self):
        self.root.after_cancel(self.timer)
        if self.worker:
            self.worker.cancel.set()
            self.worker.stop.set()
            self.worker.join(timeout=3)