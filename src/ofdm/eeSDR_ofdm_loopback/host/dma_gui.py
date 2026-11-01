#!/usr/bin/env python3
"""Desktop serial and image console for single-board SG-DMA RF loopback."""
import hashlib
import os
from pathlib import Path
import queue
import subprocess
import sys
import threading
import time
import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext, ttk

from serial_connection import SerialConnection
from serial_devices import discover


class Console:
    def __init__(self, root):
        self.root = root
        self.events = queue.Queue()
        self.jobs = {}
        self.photos = {}
        self.closing = False
        self.directory = Path(__file__).resolve().parent
        root.title('OFDM 单板自发自收 · UART / 图片')
        root.geometry('1180x860')
        root.minsize(900, 700)
        self.port = tk.StringVar(value='auto')
        self.board = tk.StringVar(value='192.168.137.10')
        self.source = tk.StringVar()
        self.destination = tk.StringVar()
        self.mode = tk.StringVar(value='hex')
        self.uart_status = tk.StringVar(value='串口空闲 · 115200 8N1')
        self.image_status = tk.StringVar(value='请选择图片；返回文件通过校验后显示在右侧')
        page = ttk.Frame(root, padding=12)
        page.pack(fill='both', expand=True)
        ttk.Label(page, text='OFDM 单板天线回环', font=('TkDefaultFont', 18, 'bold')).pack(anchor='w')
        ttk.Label(page, text='上位机 → 本板 TX → 天线 → 本板 RX → 上位机；成功以实际返回数据校验为准').pack(anchor='w', pady=(4, 12))
        tabs = ttk.Notebook(page)
        tabs.pack(fill='both', expand=True)
        uart = ttk.Frame(tabs, padding=12)
        image = ttk.Frame(tabs, padding=12)
        tabs.add(uart, text='串口调试')
        tabs.add(image, text='图片回环')
        row = ttk.Frame(uart)
        row.pack(fill='x')
        ttk.Label(row, text='串口').pack(side='left')
        self.ports = ttk.Combobox(row, textvariable=self.port, width=38)
        self.ports.pack(side='left', padx=8)
        ttk.Button(row, text='刷新', command=self.refresh).pack(side='left')
        self.monitor_button = ttk.Button(row, text='查看启动日志', command=self.monitor)
        self.monitor_button.pack(side='left', padx=8)
        ttk.Button(row, text='停止串口任务', command=lambda: self.cancel('uart')).pack(side='right')
        row = ttk.Frame(uart)
        row.pack(fill='x', pady=12)
        for label, mode in [('十六进制', 'hex'), ('UTF-8 文本', 'text'), ('随机 64 字节', 'random')]:
            ttk.Radiobutton(row, text=label, variable=self.mode, value=mode).pack(side='left', padx=(0, 12))
        self.uart_button = ttk.Button(row, text='发送并校验回环', command=self.send_uart)
        self.uart_button.pack(side='right')
        self.payload = scrolledtext.ScrolledText(uart, height=5, wrap='char')
        self.payload.pack(fill='x')
        self.payload.insert('1.0', bytes(range(64)).hex())
        ttk.Label(uart, text='支持 1～1000 字节。查看启动日志时请先停止监听，再发送业务数据。').pack(anchor='w', pady=8)
        ttk.Label(uart, textvariable=self.uart_status, wraplength=1000).pack(anchor='w')

        row = ttk.Frame(image)
        row.pack(fill='x')
        ttk.Label(row, text='板卡 IP').pack(side='left')
        ttk.Entry(row, textvariable=self.board, width=20).pack(side='left', padx=8)
        ttk.Label(row, text='TCP 5001 · 同一连接并发收发').pack(side='left')
        self.image_button = ttk.Button(row, text='发送图片并接收回环', command=self.send_image)
        self.image_button.pack(side='right')
        ttk.Button(row, text='停止', command=lambda: self.cancel('image')).pack(side='right', padx=8)
        for label, variable, callback in [('原始图片', self.source, self.choose_source),
                                          ('回传保存', self.destination, self.choose_destination)]:
            row = ttk.Frame(image)
            row.pack(fill='x', pady=(10, 0))
            ttk.Label(row, text=label, width=9).pack(side='left')
            ttk.Entry(row, textvariable=variable).pack(side='left', fill='x', expand=True, padx=8)
            ttk.Button(row, text='浏览…', command=callback).pack(side='right')
        ttk.Label(image, text='预览支持 PNG / GIF / PPM。其它文件仍可传输和校验，但不提供图像预览。').pack(anchor='w', pady=8)
        previews = ttk.Frame(image)
        previews.pack(fill='both', expand=True)
        previews.columnconfigure(0, weight=1, uniform='preview')
        previews.columnconfigure(1, weight=1, uniform='preview')
        previews.rowconfigure(0, weight=1)
        self.preview_labels = {}
        for col, key, title in [(0, 'source', '发送原图'), (1, 'received', '实际回传图片')]:
            box = ttk.LabelFrame(previews, text=title, padding=8)
            box.grid(row=0, column=col, sticky='nsew', padx=4)
            label = ttk.Label(box, text='尚无图片', anchor='center')
            label.pack(fill='both', expand=True)
            self.preview_labels[key] = label
        self.progress = ttk.Progressbar(image, mode='indeterminate')
        self.progress.pack(fill='x', pady=8)
        ttk.Label(image, textvariable=self.image_status, wraplength=1050).pack(anchor='w')
        row = ttk.Frame(page)
        row.pack(fill='x', pady=(10, 4))
        ttk.Label(row, text='调试日志').pack(side='left')
        ttk.Button(row, text='保存日志', command=self.save_log).pack(side='right')
        self.log = scrolledtext.ScrolledText(page, height=12, state='disabled', wrap='char')
        self.log.pack(fill='x')
        self.refresh()
        root.protocol('WM_DELETE_WINDOW', self.close)
        self.timer = root.after(100, self.poll)

    def refresh(self):
        self.ports['values'] = ['auto'] + [d.device for d in discover() if d.is_target]

    def append(self, text):
        self.log.configure(state='normal')
        self.log.insert('end', text)
        if int(self.log.index('end-1c').split('.')[0]) > 4000:
            self.log.delete('1.0', '1000.0')
        self.log.see('end')
        self.log.configure(state='disabled')

    def preview(self, key, path):
        label = self.preview_labels[key]
        self.photos.pop(key, None)
        label.configure(image='', text='无可显示图片')
        try:
            photo = tk.PhotoImage(file=str(path))
            factor = max(1, (photo.width() + 479) // 480, (photo.height() + 319) // 320)
            if factor > 1:
                photo = photo.subsample(factor)
            self.photos[key] = photo
            label.configure(image=photo, text='')
        except (tk.TclError, OSError) as exc:
            label.configure(text='文件已选择/保存，但无法预览\n请使用 PNG / GIF / PPM')
            self.append(f'预览: {exc}\n')

    def choose_source(self):
        name = filedialog.askopenfilename(parent=self.root, filetypes=[('可预览图片', '*.png *.gif *.ppm'), ('所有文件', '*')])
        if name:
            path = Path(name)
            self.source.set(name)
            self.destination.set(str(path.with_name(path.stem + '_returned' + path.suffix)))
            self.preview('source', path)

    def choose_destination(self):
        name = filedialog.asksaveasfilename(parent=self.root, initialfile=Path(self.destination.get()).name)
        if name:
            self.destination.set(name)

    def launch(self, kind, args, output=None):
        if kind in self.jobs:
            return
        stop = threading.Event()
        self.jobs[kind] = stop

        def worker():
            try:
                with subprocess.Popen([sys.executable, '-u', str(self.directory / args[0]), *args[1:]],
                                      stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                      text=True, encoding='utf-8', errors='replace') as process:
                    def cancel_process():
                        while process.poll() is None:
                            if stop.wait(0.1):
                                if process.poll() is None:
                                    try:
                                        process.terminate()
                                        process.wait(timeout=2)
                                    except subprocess.TimeoutExpired:
                                        process.kill()
                                    except OSError:
                                        pass
                                return
                    watcher = threading.Thread(target=cancel_process, daemon=True)
                    watcher.start()
                    for line in process.stdout:
                        self.events.put(('log', f'[{kind}] {line}'))
                    code = process.wait()
                    watcher.join()
                self.events.put(('done', (kind, code == 0 and not stop.is_set(), output, stop.is_set())))
            except Exception as exc:
                self.events.put(('log', f'[{kind}] ERROR: {exc}\n'))
                self.events.put(('done', (kind, False, None, stop.is_set())))
        threading.Thread(target=worker, daemon=True).start()
        self.controls()

    def send_uart(self):
        if 'uart' in self.jobs:
            return
        try:
            text = self.payload.get('1.0', 'end-1c')
            payload = os.urandom(64) if self.mode.get() == 'random' else (
                text.encode('utf-8') if self.mode.get() == 'text' else bytes.fromhex(text))
            if not 1 <= len(payload) <= 1000:
                raise ValueError('数据长度须为 1～1000 字节')
        except ValueError as exc:
            messagebox.showerror('串口数据', str(exc), parent=self.root)
            return
        self.uart_status.set(f'正在发送 {len(payload)} 字节，等待真实 RX 返回…')
        self.launch('uart', ['dma_uart.py', self.port.get().strip(), '--hex', payload.hex(), '--timeout', '10'])

    def send_image(self):
        if 'image' in self.jobs:
            return
        source, output = Path(self.source.get()), Path(self.destination.get())
        try:
            if not source.is_file() or not 1 <= source.stat().st_size <= 16 * 1024 * 1024:
                raise ValueError('请选择 1 字节～16 MiB 的文件')
            if not self.destination.get() or source.resolve() == output.resolve() or not output.parent.is_dir():
                raise ValueError('请指定不同于原图的有效输出文件路径')
            if output.exists() and not messagebox.askyesno('覆盖回传文件', f'成功校验后覆盖 {output}？', parent=self.root):
                return
        except (ValueError, OSError) as exc:
            messagebox.showerror('图片', str(exc), parent=self.root)
            return
        self.preview('source', source)
        self.photos.pop('received', None)
        self.preview_labels['received'].configure(image='', text='等待本次回传图片…')
        self.image_status.set('收发进行中；等待完整 RX 图片、CRC 校验及 ACK 完成…')
        self.progress.start(15)
        self.launch('image', ['dma_image.py', 'loopback', self.board.get().strip(), str(source),
                              '--output', str(output), '--timeout', '30'], output)

    def monitor(self):
        if 'uart' in self.jobs:
            return
        stop = threading.Event()
        self.jobs['uart'] = stop
        port = self.port.get().strip()
        self.uart_status.set('正在监听启动日志；停止监听后才能发送')

        def worker():
            connection = SerialConnection(port)
            try:
                self.events.put(('log', '串口监听: ' + connection.open(0) + '\n'))
                while not stop.is_set():
                    data = connection.port.read(1024)
                    if data:
                        self.events.put(('log', data.decode('utf-8', errors='replace')))
            except Exception as exc:
                self.events.put(('log', f'串口监听失败: {exc}\n'))
            finally:
                connection.close()
                self.events.put(('done', ('uart', False, None, True)))
        threading.Thread(target=worker, daemon=True).start()
        self.controls()

    def cancel(self, kind):
        if kind in self.jobs:
            self.jobs[kind].set()

    def controls(self):
        self.uart_button.configure(state='disabled' if 'uart' in self.jobs else 'normal')
        self.monitor_button.configure(state='disabled' if 'uart' in self.jobs else 'normal')
        self.image_button.configure(state='disabled' if 'image' in self.jobs else 'normal')

    def poll(self):
        try:
            for _ in range(200):
                kind, value = self.events.get_nowait()
                if kind == 'log':
                    self.append(value)
                elif kind == 'done':
                    task, success, output, cancelled = value
                    self.jobs.pop(task, None)
                    status = '已停止' if cancelled else ('回环 PASS：实际 RX 数据与发送数据一致' if success else '回环失败，请查看日志')
                    if task == 'image':
                        self.progress.stop()
                        if success:
                            self.preview('received', output)
                            try:
                                status += '\nSHA256: ' + hashlib.sha256(output.read_bytes()).hexdigest()
                            except OSError as exc:
                                status += '\n无法读取保存文件: ' + str(exc)
                        self.image_status.set(status)
                    else:
                        self.uart_status.set(status)
                    self.controls()
        except queue.Empty:
            pass
        if self.closing and not self.jobs:
            self.root.destroy()
            return
        self.timer = self.root.after(100, self.poll)

    def save_log(self):
        name = filedialog.asksaveasfilename(parent=self.root, defaultextension='.txt')
        if name:
            try:
                Path(name).write_text(self.log.get('1.0', 'end-1c'), encoding='utf-8')
            except OSError as exc:
                messagebox.showerror('保存日志', str(exc), parent=self.root)

    def close(self):
        self.closing = True
        for stop in self.jobs.values():
            stop.set()


def main():
    root = tk.Tk()
    Console(root)
    root.mainloop()


if __name__ == '__main__':
    main()