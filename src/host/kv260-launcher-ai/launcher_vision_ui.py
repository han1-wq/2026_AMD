"""Unprivileged standalone Tk interface for the B3136/HLS pipeline."""
import argparse
import fcntl
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time
import tkinter as tk
from tkinter import ttk, messagebox

BASE = Path(__file__).resolve().parent
RUNTIME = Path('/home/ubuntu/kv260_B3136')
sys.path.insert(0, str(RUNTIME))
from runtime.controls import Controls, write_json

DIRECTORY = Path('/run/user/1000/kv260-b3136-ui')
EQ_LABELS = ('关闭', '当前帧（精确均衡）', '上一帧（低开销均衡）')


class VisionWindow:
    def __init__(self, root):
        self.root = root
        root.title('KV260 AI 视觉 · B3136 + HLS RGB-D')
        root.geometry('1080x760+80+80')
        root.minsize(1020, 720)
        style = ttk.Style(root)
        style.theme_use('clam')
        style.configure('.', font=('Sans', 10))
        for name in ('TFrame', 'TLabel', 'TLabelframe', 'TLabelframe.Label'):
            style.configure(name, background='#eef2f7')
        style.configure('TLabel', foreground='#24334b')
        style.configure('TButton', padding=(10, 5), background='#ffffff', foreground='#24334b')
        style.map('TButton', background=[('active', '#dceafb')])
        root.protocol('WM_DELETE_WINDOW', self.close)
        DIRECTORY.mkdir(parents=True, exist_ok=True)
        self.values = {}
        self.photo = None
        self.frame_version = None
        self.pending = None
        self.processes = []
        self.closed = False
        try:
            initial = Controls.parse(json.loads((DIRECTORY/'controls.json').read_text()))
        except (OSError, ValueError, TypeError):
            initial = Controls()
        header = tk.Frame(root, bg='#17243b', padx=20, pady=14)
        header.pack(fill='x')
        tk.Label(header, text='AI 视觉 / RGB-D', font=('Sans', 21, 'bold'), bg='#17243b', fg='white').pack(side='left')
        tk.Label(header, text='HLS 前处理 → DPU B3136 → HLS 后处理\nROS2 Humble · Astra Pro', bg='#17243b', fg='#b8c9e3', justify='right').pack(side='right')
        toolbar = ttk.Frame(root, padding=12)
        toolbar.pack(fill='x')
        self.start_button = ttk.Button(toolbar, text='启动视觉', command=lambda:self.submit('vision'))
        self.start_button.pack(side='left')
        self.stop_button = ttk.Button(toolbar, text='安全停止', command=lambda:self.submit('stop-vision'))
        self.stop_button.pack(side='left', padx=8)
        ttk.Button(toolbar, text='保存当前画面', command=self.save_frame).pack(side='left')
        ttk.Button(toolbar, text='恢复默认', command=self.reset).pack(side='left', padx=8)
        ttk.Button(toolbar, text='查看日志', command=self.logs).pack(side='right')
        body = ttk.Frame(root, padding=(12, 0))
        body.pack(fill='both', expand=True)
        left = ttk.Frame(body)
        left.pack(side='left', fill='both', expand=True)
        image_area = tk.Frame(left, width=640, height=480, bg='#111c2e')
        image_area.pack()
        image_area.pack_propagate(False)
        self.image = tk.Label(image_area, text='点击“启动视觉”获取实时画面', bg='#111c2e', fg='white')
        self.image.pack(fill='both', expand=True)
        self.stats = tk.StringVar(value='等待推理状态…')
        ttk.Label(left, textvariable=self.stats, justify='left', wraplength=640).pack(fill='x', pady=10)
        right = ttk.LabelFrame(body, text='HLS 图像调节', padding=14)
        right.pack(side='right', fill='y', padx=(14, 0))
        for key, label, low, high, resolution in (
            ('brightness', '亮度  /  −255 ～ +255', -255, 255, 1),
            ('contrast', '对比度  /  0 ～ 4×', 0, 4, .05),
            ('saturation', '饱和度  /  0 ～ 2×', 0, 2, .05)):
            ttk.Label(right, text=label).pack(anchor='w', pady=(8, 0))
            var = tk.DoubleVar(value=getattr(initial, key))
            self.values[key] = var
            tk.Scale(right, variable=var, from_=low, to=high, resolution=resolution,
                     orient='horizontal', length=280, command=lambda _value:self.schedule()).pack(fill='x')
        ttk.Label(right, text='亮度直方图均衡').pack(anchor='w', pady=(14, 5))
        self.eq = ttk.Combobox(right, values=EQ_LABELS, state='readonly', width=28)
        self.eq.current(initial.eq_mode)
        self.eq.pack(fill='x')
        self.eq.bind('<<ComboboxSelected>>', lambda _event:self.schedule())
        self.enhance = tk.BooleanVar(value=initial.enhance_tensor)
        ttk.Checkbutton(right, text='增强同时用于 DPU 推理', variable=self.enhance, command=self.schedule).pack(anchor='w', pady=14)
        ttk.Label(right, text='关闭时：预览增强，模型仍读取原图。\n开启后：增强图像参与检测。', wraplength=280).pack(anchor='w')
        ttk.Label(right, text='显示画面').pack(anchor='w', pady=(14, 4))
        self.display = tk.StringVar(value=initial.display_mode)
        for label, value in (('HLS 增强图', 'enhanced'), ('原始图', 'original')):
            ttk.Radiobutton(right, text=label, value=value, variable=self.display, command=self.schedule).pack(anchor='w')
        ttk.Label(right, text='上一帧模式首帧/参数变化后重建历史。\n深度为近似值，尚未标定配准。', wraplength=280, foreground='#805b20').pack(anchor='w', pady=16)
        self.status = tk.StringVar(value='就绪')
        ttk.Label(root, textvariable=self.status, padding=12, wraplength=1030).pack(fill='x')
        self.apply()
        root.bind('<Escape>', lambda _event:self.close())
        self.tick()

    def schedule(self):
        if self.pending:
            self.root.after_cancel(self.pending)
        self.pending = self.root.after(180, self.apply)

    def apply(self):
        self.pending = None
        try:
            settings = Controls.parse(dict(brightness=round(self.values['brightness'].get()),
                contrast=self.values['contrast'].get(), saturation=self.values['saturation'].get(),
                eq_mode=self.eq.current(), enhance_tensor=self.enhance.get(), display_mode=self.display.get()))
            from dataclasses import asdict
            write_json(DIRECTORY/'controls.json', asdict(settings))
            self.status.set('参数已提交；在下一帧 HLS 任务边界生效。')
        except (OSError, ValueError, tk.TclError) as exc:
            self.status.set('参数提交失败：' + str(exc))

    def reset(self):
        for key, value in (('brightness', 0), ('contrast', 1), ('saturation', 1)):
            self.values[key].set(value)
        self.eq.current(0)
        self.enhance.set(False)
        self.display.set('enhanced')
        self.schedule()

    def submit(self, action):
        from launcher_tasks import state_dir
        if action == 'vision':
            self.apply()
        env = dict(os.environ)
        env.setdefault('DISPLAY', ':0')
        env.setdefault('XAUTHORITY', '/run/user/1000/gdm/Xauthority')
        try:
            with (state_dir()/(action+'.submit.log')).open('wb') as errors:
                process = subprocess.Popen([sys.executable, str(BASE/'launcher_tasks.py'), action],
                    env=env, cwd=BASE, stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                    stderr=errors, start_new_session=True)
            self.processes.append((process, action))
            self.status.set('已提交：' + ('启动视觉' if action == 'vision' else '安全停止；等待硬件排空'))
        except OSError as exc:
            self.status.set(str(exc))

    def tick(self):
        if self.closed:
            return
        try:
            data = json.loads((DIRECTORY/'status.json').read_text())
            state = data['state']
            fresh = time.time()-data['updated'] < 3
            from launcher_tasks import is_active
            active = is_active('vision')
            self.start_button.configure(state='disabled' if active or (fresh and state in ('running', 'starting', 'draining')) else 'normal')
            self.stop_button.configure(state='normal' if active or state in ('running', 'starting', 'draining') else 'disabled')
            if state == 'running':
                msg = data['message']
                timing = msg['timings']
                settings = msg['preprocessing']
                self.stats.set('%s  ·  %.2f FPS  ·  %d 帧  ·  RGB-D 配对 %d\n前处理 %.2f ms  /  DPU %.2f ms  /  后处理 %.2f ms  /  延迟 %.0f ms\n检测 %d 个  ·  配置 #%d  ·  亮度 %d / 对比度 %.2f / 饱和度 %.2f\n均衡：%s  ·  推理输入：%s  ·  ROS2：/yolov4_b3136/detections' % (
                    '运行中' if fresh else '状态更新中断，请查看日志', data['fps'], data['processed'], data['depth_pairs'],
                    timing['pre_ms'], timing['dpu_ms'], timing['post_ms'], msg['latency_ms'],
                    len(msg['detections']), settings['config_id'], settings['brightness'], settings['contrast'], settings['saturation'],
                    EQ_LABELS[settings['eq_mode']], '增强图' if settings['enhance_tensor'] else '原图'))
                path = DIRECTORY/'frame.ppm'
                stat = path.stat()
                version = (stat.st_mtime_ns, stat.st_ino)
                if version != self.frame_version:
                    self.photo = tk.PhotoImage(file=str(path))
                    self.image.configure(image=self.photo, text='')
                    self.frame_version = version
            else:
                self.stats.set({'starting':'正在加载模型与相机…', 'draining':'正在排空加速器并释放相机…',
                                'stopped':'已停止 · 资源释放完成', 'error':'推理退出，请查看日志'}.get(state, state))
        except (OSError, ValueError, KeyError, tk.TclError):
            pass
        for process, action in self.processes[:]:
            code = process.poll()
            if code is not None:
                self.processes.remove((process, action))
                if code:
                    self.status.set('任务失败，返回码 %d；请查看日志。' % code)
                    self.logs()
        self.root.after(120, self.tick)

    def save_frame(self):
        try:
            destination = Path.home()/'Pictures'/'KV260-AI'
            destination.mkdir(parents=True, exist_ok=True)
            path = destination/(time.strftime('%Y%m%d-%H%M%S')+'.ppm')
            shutil.copyfile(DIRECTORY/'frame.ppm', path)
            self.status.set('画面已保存：' + str(path))
        except OSError as exc:
            self.status.set('保存失败：' + str(exc))

    def logs(self):
        from launcher_tasks import state_dir
        window = tk.Toplevel(self.root)
        window.title('AI 视觉日志')
        window.geometry('900x600')
        text = tk.Text(window, wrap='word')
        text.pack(fill='both', expand=True)
        def refresh():
            parts = []
            for name in ('vision', 'stop-vision'):
                for suffix in ('.log', '.submit.log'):
                    path = state_dir()/(name+suffix)
                    try:
                        with path.open('rb') as stream:
                            stream.seek(0, 2)
                            stream.seek(max(0, stream.tell()-20000))
                            parts.append(path.name+'\n'+stream.read().decode(errors='replace'))
                    except OSError:
                        pass
            text.delete('1.0', 'end')
            text.insert('end', '\n'.join(parts))
            text.see('end')
        ttk.Button(window, text='刷新', command=refresh).pack()
        refresh()

    def close(self):
        self.closed = True
        if self.pending:
            self.root.after_cancel(self.pending)
        self.root.destroy()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--smoke-seconds', type=int, default=0)
    args = parser.parse_args()
    DIRECTORY.mkdir(parents=True, exist_ok=True)
    with (DIRECTORY/'gui.lock').open('a') as lock:
        root = tk.Tk()
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            root.withdraw()
            messagebox.showinfo('AI 视觉', '视觉界面已打开，请切换到已有窗口。', parent=root)
            root.destroy()
            return
        app = VisionWindow(root)
        if args.smoke_seconds:
            root.after(args.smoke_seconds*1000, app.close)
        root.mainloop()


if __name__ == '__main__':
    main()