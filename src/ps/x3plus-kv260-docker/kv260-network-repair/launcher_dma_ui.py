"""Embedded SG-DMA console with fresh B3136 AI vision frame capture."""
import hashlib
import json
import os
from pathlib import Path
import queue
import sys
import time
import tkinter as tk
from tkinter import ttk, messagebox

from launcher_tasks import state_dir, is_active
from launcher_dma_payload import task_and_log, usb_and_runtime

HOST = Path(os.environ.get('OFDM_HOST_DIR', str(Path(__file__).parent / 'ofdm_host')))
sys.path.insert(0, str(HOST))
from dma_gui import Console


class OFDMPanel(Console):
    def __init__(self, app, page):
        self.app = app
        self.send_after_capture = False
        super().__init__(app.root, parent=page)
        self.board.set(app.env.get('OFDM_BOARD_IP', '192.168.137.10'))
        self.directory = HOST
        self.captures = state_dir() / 'ofdm-images'
        self.captures.mkdir(parents=True, exist_ok=True)
        quick = ttk.Frame(self.uart_page)
        quick.pack(fill='x', before=self.uart_page.winfo_children()[0], pady=(0, 8))
        self.task_button = ttk.Button(quick, text='发送当前任务与日志', command=self.send_task_log)
        self.task_button.pack(side='left')
        self.runtime_button = ttk.Button(quick, text='发送 USB 与运行状态', command=self.send_runtime)
        self.runtime_button.pack(side='left', padx=8)
        bar = ttk.Frame(self.image_page)
        bar.pack(fill='x', before=self.image_page.winfo_children()[0], pady=(0, 8))
        self.capture_button = ttk.Button(bar, text='采集 AI 视觉当前帧', command=self.capture)
        self.capture_button.pack(side='left')
        self.capture_send_button = ttk.Button(bar, text='拍照发送并显示回传', command=lambda: self.capture(True))
        self.capture_send_button.pack(side='left', padx=8)
        ttk.Button(bar, text='停止采集', command=lambda: self.cancel('capture')).pack(side='left')
        self.topic = tk.StringVar(value=app.env.get('OFDM_YOLO_TOPIC', ''))
        source_row = ttk.Frame(self.image_page)
        source_row.pack(fill='x', after=bar, pady=(0, 8))
        ttk.Label(source_row, text='默认采集 AI 视觉显示画面（含检测框/增强）；先启动 AI 视觉。兼容 ROS 图片主题：').pack(side='left')
        ttk.Entry(source_row, textvariable=self.topic, width=20).pack(side='left')
        ttk.Label(source_row, text='留空使用新视觉').pack(side='left', padx=8)
        self.benchmark_status = tk.StringVar(value='空闲')
        bench = ttk.Frame(self.tabs, padding=12)
        self.tabs.add(bench, text='图片基准测试')
        self.count = tk.IntVar(value=200)
        row = ttk.Frame(bench)
        row.pack(fill='x')
        ttk.Label(row, text='次数').pack(side='left')
        ttk.Spinbox(row, from_=1, to=10000, textvariable=self.count, width=8).pack(side='left', padx=8)
        self.benchmark_button = ttk.Button(row, text='开始测试', command=self.benchmark)
        self.benchmark_button.pack(side='left')
        ttk.Button(row, text='停止', command=lambda: self.cancel('benchmark')).pack(side='left', padx=8)
        ttk.Label(bench, text='使用图片回环页当前选中的图片；每次验证完整回传、CRC 和 ACK。').pack(anchor='w', pady=12)
        ttk.Label(bench, textvariable=self.benchmark_status, wraplength=820).pack(anchor='w', pady=12)
        self.controls()

    def send_task_log(self):
        if 'uart' in self.jobs:
            return
        self.app.tabs.select(self.app.ofdm_tab)
        self.tabs.select(self.uart_page)
        action = self.app.selected
        try:
            record_path = state_dir() / (action + '.json')
            try:
                record = json.loads(record_path.read_text(encoding='utf-8'))
            except FileNotFoundError:
                record = {}
            log_path = state_dir() / (action + '.log')
            try:
                with log_path.open('rb') as stream:
                    stream.seek(0, 2)
                    size = stream.tell()
                    stream.seek(max(0, size - 700))
                    tail = stream.read(700)
            except FileNotFoundError:
                size, tail = 0, b''
            payload = task_and_log(action, record, is_active(action), tail, size)
            self.send_uart_payload(payload)
        except (OSError, ValueError, TypeError, KeyError) as exc:
            messagebox.showerror('发送当前任务与日志', str(exc), parent=self.root)

    def send_runtime(self):
        if 'uart' in self.jobs:
            return
        self.app.tabs.select(self.app.ofdm_tab)
        self.tabs.select(self.uart_page)
        try:
            self.send_uart_payload(usb_and_runtime(self.app.snapshot))
        except (ValueError, TypeError, KeyError) as exc:
            messagebox.showerror('发送 USB 与运行状态', str(exc), parent=self.root)

    def capture(self, send=False):
        if any(k in self.jobs for k in ('capture', 'image', 'benchmark')):
            return
        self.app.tabs.select(self.app.ofdm_tab)
        self.tabs.select(self.image_page)
        path = self.captures / ('ai-vision-' + str(time.time_ns()) + '.png')
        script = Path(__file__).parent / 'launcher_yolo_capture.py'
        topic = self.topic.get().strip()
        args = [str(script), str(path), '--timeout', '15']
        if topic:
            args += ['--topic', topic]
            command = ['/bin/bash', '-c', 'source /opt/ros/humble/setup.bash && exec /usr/bin/python3 -u "$@"',
                       'ofdm-capture', *args]
        else:
            command = ['/usr/bin/python3', '-u', *args]
        self.send_after_capture = send
        self.photos.pop('received', None)
        self.preview_labels['received'].configure(image='', text='等待本次采集与回传…')
        self.image_status.set('正在等待点击后的新图像；请先启动 AI 视觉。停止采集只取消截图。')
        self.launch('capture', [], path, command=command)

    def send_image(self):
        if 'capture' in self.jobs or 'benchmark' in self.jobs:
            return
        super().send_image()

    def benchmark(self):
        if any(k in self.jobs for k in ('capture', 'image', 'benchmark')):
            return
        try:
            count = self.count.get()
            source = Path(self.source.get())
            if not 1 <= count <= 10000 or not source.is_file():
                raise ValueError('请选择图片并设置 1～10000 次测试')
        except (ValueError, tk.TclError) as exc:
            messagebox.showerror('基准测试', str(exc), parent=self.root)
            return
        output = self.captures / ('benchmark-' + str(time.time_ns()))
        self.benchmark_status.set('测试进行中：' + str(output))
        self.launch('benchmark', ['dma_image_benchmark.py', self.board.get().strip(),
                                  str(source), str(output), '--count', str(count), '--timeout', '30'], output)

    def controls(self):
        super().controls()
        if not hasattr(self, 'task_button'):
            return
        for button in (self.task_button, self.runtime_button):
            button.configure(state='disabled' if 'uart' in self.jobs else 'normal')
        if not hasattr(self, 'benchmark_button'):
            return
        busy = any(k in self.jobs for k in ('capture', 'image', 'benchmark'))
        for button in (self.capture_button, self.capture_send_button, self.image_button, self.benchmark_button):
            button.configure(state='disabled' if busy else 'normal')

    def poll(self):
        try:
            for _ in range(200):
                kind, value = self.events.get_nowait()
                if kind == 'log':
                    self.append(value)
                    continue
                if kind != 'done':
                    continue
                task, success, output, cancelled = value
                self.jobs.pop(task, None)
                status = '已停止' if cancelled else ('回环 PASS：实际 RX 与发送数据一致' if success else '失败，请查看日志')
                if task == 'capture':
                    if success:
                        self.source.set(str(output))
                        self.destination.set(str(output.with_name(output.stem + '-returned.png')))
                        self.preview('source', output)
                        self.photos.pop('received', None)
                        self.preview_labels['received'].configure(image='', text='尚未回传')
                        self.image_status.set('已采集 AI 视觉图像：' + str(output))
                        if self.send_after_capture and not self.closing:
                            self.send_image()
                    else:
                        self.image_status.set('AI 视觉采集' + status)
                    self.send_after_capture = False
                elif task == 'image':
                    self.progress.stop()
                    if success:
                        self.preview('received', output)
                        try:
                            status += '\nSHA256: ' + hashlib.sha256(output.read_bytes()).hexdigest()
                        except OSError as exc:
                            status += '\n' + str(exc)
                    self.image_status.set(status)
                elif task == 'benchmark':
                    status = '已停止' if cancelled else '测试异常'
                    try:
                        summary = json.loads((output / 'summary.json').read_text())
                        passed = (success and not cancelled and summary['attempts'] > 0
                                  and summary['successes'] == summary['attempts']
                                  and summary['failures'] == 0 and summary['differing_bits'] == 0)
                        if not cancelled:
                            status = '测试 PASS' if passed else '测试 FAIL'
                        status += ('：成功 {successes}/{attempts}，失败 {failures}，'
                                   '差异 {differing_bits} bits').format(**summary)
                    except (OSError, ValueError, KeyError, TypeError, AttributeError):
                        status += '，无有效汇总；请查看日志'
                    self.benchmark_status.set(status + '；结果目录：' + str(output))
                else:
                    self.uart_status.set(status)
                self.controls()
        except queue.Empty:
            pass
        if not self.closing:
            self.timer = self.root.after(100, self.poll)

    def close(self):
        self.closing = True
        self.root.after_cancel(self.timer)
        for stop in self.jobs.values():
            stop.set()