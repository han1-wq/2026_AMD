#!/usr/bin/env python3
"""Lightweight dashboard. Opening this window never starts robot hardware."""
import argparse
import fcntl
import json
import os
from pathlib import Path
import queue
import subprocess
import sys
import threading
import time
import tkinter as tk
from tkinter import ttk, messagebox, simpledialog, filedialog
from launcher_core import BASE, MAP_PATTERN, Monitor, read_env
from launcher_tasks import ACTIONS, LONG_ACTIONS, is_active, state_dir
from launcher_dma_ui import OFDMPanel
from launcher_roarm_ui import RoArmPanel
from launcher_roarm import snapshot as arm_snapshot


def tail_log(path, limit=24000):
    try:
        with path.open('rb') as stream:
            stream.seek(0, 2)
            stream.seek(max(0, stream.tell() - limit))
            return stream.read(limit).decode('utf-8', errors='replace')
    except OSError:
        return '暂无日志。运行任务后在此显示输出。'


class Dashboard:
    def __init__(self, root, env):
        self.root, self.env = root, env
        self.monitor = Monitor(env)
        self.results = queue.Queue(maxsize=1)
        self.stop = threading.Event()
        self.refresh = threading.Event()
        self.snapshot, self.processes, self.buttons = {}, [], {}
        self.selected, self.last_log, self.closing = 'base', None, False
        root.title('KV260 X3plus · 机器人控制台')
        root.geometry('1100x800')
        root.minsize(930, 720)
        root.configure(bg='#eef2f7')
        root.protocol('WM_DELETE_WINDOW', self.close)
        self.build()
        threading.Thread(target=self.monitor_loop, daemon=True).start()
        self.tick()

    def build(self):
        style = ttk.Style(self.root)
        style.theme_use('clam')
        style.configure('.', font=('Sans', 10))
        for cls in ('TFrame', 'TLabel', 'TLabelframe', 'TLabelframe.Label'):
            style.configure(cls, background='#eef2f7')
        style.configure('TLabel', foreground='#24334b')
        style.configure('TButton', padding=(12, 4), background='#ffffff',
                        foreground='#24334b', bordercolor='#c7d3e2', relief='flat')
        style.map('TButton', background=[('active', '#dceafb'), ('disabled', '#e5eaf0')],
                  foreground=[('disabled', '#8896a8')])
        style.configure('Danger.TButton', foreground='#a32130', background='#fff1f2')
        style.configure('TLabelframe', bordercolor='#c7d3e2')
        style.configure('TLabelframe.Label', font=('Sans', 11, 'bold'))
        style.map('TNotebook.Tab', background=[('selected', '#ffffff'), ('!selected', '#dce4ef')],
                  foreground=[('selected', '#174c86')])
        style.configure('Treeview', rowheight=28)
        style.configure('TNotebook.Tab', padding=(22, 9))
        header = tk.Frame(self.root, bg='#17243b', padx=24, pady=16)
        header.pack(fill='x')
        tk.Label(header, text='KV260  /  X3plus', font=('Sans', 22, 'bold'), bg='#17243b', fg='white').pack(side='left')
        tk.Label(header, text='机器人控制台\nROS1 · RGB-D / DPU · USB 身份校验', bg='#17243b', fg='#b8c9e3', justify='right').pack(side='right')
        bar = ttk.Frame(self.root, padding=(20, 12))
        bar.pack(fill='x')
        self.resource = tk.StringVar(value='正在进行只读检查…')
        ttk.Label(bar, textvariable=self.resource, font=('Sans', 11, 'bold')).pack(side='left')
        ttk.Button(bar, text='刷新状态', command=self.refresh.set).pack(side='right')
        self.tabs = ttk.Notebook(self.root)
        self.tabs.pack(fill='both', expand=True, padx=18)
        control, vision, devices, logs, ofdm, arm, help_page = [ttk.Frame(self.tabs, padding=16) for _ in range(7)]
        for frame, title in zip((control, vision, devices, logs, ofdm, arm, help_page), ('总览与控制', 'AI 视觉', 'USB 与运行状态', '任务与日志', 'OFDM 通信', '机械臂', '使用说明')):
            self.tabs.add(frame, text=title)
        self.vision_tab = vision
        ttk.Label(vision, text='独立 AI 视觉 · Astra RGB-D / B3136 / HLS 前后处理', font=('Sans', 16, 'bold')).pack(anchor='w', pady=12)
        ttk.Label(vision, text='在独立窗口查看实时检测、RGB-D 配对与各阶段耗时。\n支持硬件亮度、对比度、饱和度、当前帧/上一帧直方图均衡。\n增强预览与推理输入可以独立选择；参数在帧边界生效。', justify='left').pack(anchor='w', pady=12)
        ttk.Button(vision, text='打开 AI 视觉界面', command=self.open_vision).pack(anchor='w', pady=12)
        self.button(vision, 'vision', '启动 B3136 + HLS 视觉流水线')
        self.button(vision, 'stop-vision', '安全停止 AI 视觉')
        ttk.Label(vision, text='关闭视觉界面保留推理；停止请使用“安全停止”。\n结果主题：/yolov4_b3136/detections；深度为未标定近似值。').pack(anchor='w', pady=12)
        self.logs_tab = logs
        self.ofdm_tab = ofdm
        self.ofdm = OFDMPanel(self, ofdm)
        self.arm = RoArmPanel(self, arm)
        control.columnconfigure(0, weight=1, uniform='panels')
        control.columnconfigure(1, weight=1, uniform='panels')
        self.summary = tk.StringVar(value='检查容器、USB 与 ROS 注册状态…')
        ttk.Label(control, textvariable=self.summary, justify='left', wraplength=960).grid(row=0, column=0, columnspan=2, sticky='ew', pady=(0, 10))
        panels = []
        for i, title in enumerate(('01  基础与建图', '02  地图与导航', '03  AI 视觉入口', '04  释放资源')):
            panel = ttk.LabelFrame(control, text=title, padding=10)
            panel.grid(row=1 + i // 2, column=i % 2, sticky='nsew', padx=(0, 8) if i % 2 == 0 else (8, 0), pady=(0, 10))
            panels.append(panel)
        for action, label in [('base','启动基础环境'), ('hardware','启动底盘与雷达'), ('slam','启动 SLAM 建图'), ('keyboard','键盘控制（独立终端）'), ('stop-keyboard','停止键盘控制'), ('rviz-map','打开建图 RViz'), ('stop-slam','停止 SLAM')]:
            self.button(panels[0], action, label)
        self.map_name = tk.StringVar()
        self.maps = ttk.Combobox(panels[1], state='readonly', textvariable=self.map_name)
        self.maps.pack(fill='x', pady=(2, 6))
        self.refresh_maps()
        for action, label in [('navigation','使用所选地图启动导航'), ('rviz-nav','打开导航 RViz'), ('save','保存当前地图…'), ('stop-navigation','停止导航')]:
            self.button(panels[1], action, label)
        ttk.Button(panels[1], text='刷新地图列表', command=self.refresh_maps).pack(fill='x', pady=3)
        ttk.Button(panels[2], text='进入独立 AI 视觉页面', command=lambda:self.tabs.select(self.vision_tab)).pack(fill='x', pady=3)
        self.camera_text = tk.StringVar(value='相机状态检查中')
        ttk.Label(panels[2], textvariable=self.camera_text, wraplength=420).pack(anchor='w', pady=5)
        self.button(panels[3], 'stop-rviz', '关闭 RViz（保留机器人运行）')
        self.button(panels[3], 'stop-all', '停止全部服务（保留容器与地图）')
        ttk.Label(panels[3], text='软件停止不是急停；危险时请使用物理急停。', foreground='#a32130', wraplength=420).pack(anchor='w', pady=5)
        ttk.Label(devices, text='VID/PID + USB 接口校验；有歧义时拒绝猜测。不打开串口。').pack(anchor='w')
        columns = ('path','id','serial','interface','location')
        self.device_table = ttk.Treeview(devices, columns=columns, show='headings', height=5)
        for key, title, width in zip(columns, ('设备','VID : PID','序列号','USB 接口','USB 位置'), (180,140,170,100,160)):
            self.device_table.heading(key, text=title)
            self.device_table.column(key, width=width)
        self.device_table.pack(fill='x', pady=10)
        self.details = tk.Text(devices, height=12, wrap='word', relief='flat', padx=12, pady=10, font=('Monospace', 10))
        self.details.pack(fill='both', expand=True)
        ttk.Button(devices, text='导出只读诊断 JSON…', command=self.export).pack(anchor='e', pady=8)
        logbar = ttk.Frame(logs)
        logbar.pack(fill='x')
        self.log_choice = ttk.Combobox(logbar, state='readonly', values=[v[0] for v in ACTIONS.values()], width=28)
        self.log_choice.current(0)
        self.log_choice.pack(side='left')
        self.log_choice.bind('<<ComboboxSelected>>', self.select_log)
        self.task_info = tk.StringVar(value='未运行')
        ttk.Label(logbar, textvariable=self.task_info).pack(side='left', padx=15)
        sendbar = ttk.Frame(logs)
        sendbar.pack(fill='x', pady=(8, 0))
        ttk.Button(sendbar, text='发送当前任务与日志', command=self.ofdm.send_task_log).pack(side='left')
        ttk.Button(sendbar, text='发送 USB 与运行状态', command=self.ofdm.send_runtime).pack(side='left', padx=8)
        ttk.Button(sendbar, text='拍照发送并显示回传', command=lambda: self.ofdm.capture(True)).pack(side='left')
        ttk.Button(sendbar, text='查看通信结果', command=lambda: self.tabs.select(self.ofdm_tab)).pack(side='right')
        self.log_text = tk.Text(logs, wrap='word', bg='#111c2e', fg='#d8e4f5', relief='flat', padx=14, pady=12, font=('Monospace', 10))
        scroll = ttk.Scrollbar(logs, command=self.log_text.yview)
        self.log_text.configure(yscrollcommand=scroll.set)
        scroll.pack(side='right', fill='y', pady=12)
        self.log_text.pack(fill='both', expand=True, pady=12)
        ttk.Label(logs, text='界面仅显示最近 24 KB；每任务轮转日志约 512 KB。退出码不等于硬件健康。').pack(anchor='w')
        help_text = (
            '操作流程\n\n'
            '基础环境 → 底盘与雷达 → SLAM → 建图 RViz → 保存地图。\n'
            '导航选择已有地图；在导航 RViz 先设初始位姿，再下发目标。\n'
            '导航启动前停止键盘与 SLAM；无法确认退出则拒绝导航。\n'
            '导航运行时拒绝启动键盘；先停止导航再切换。键盘需保持终端焦点。\n\n'
            '设备安全\n\n'
            'VID/PID 标识型号，不是唯一编号。同型号多设备时需配置序列号或 USB 位置。\n'
            '无序列号设备无法仅靠软件辨认物理个体；换 USB 口可能改变位置。\n'
            '容器设备号过期时先确保安全停止，再停止/重启容器；不会自动恢复运动。\n\n'
            '资源与状态\n\n'
            '8 秒后台只读采样；不导入 ROS / OpenCV / DPU，不订阅图像。\n'
            'ROS 状态仅为 master 注册信息，不代表实时数据、TF 或硬件端到端健康。\n'
            'RViz 软件渲染占用 CPU；不需要时关闭，或在另一台电脑显示。\n'
            '相机未接入时禁用视觉启动；本界面不加载 DPU。视觉仍是独立 ROS2 功能。\n\n'
            '退出与停止\n\n'
            '关闭窗口只退出界面，后台任务继续运行；需要停止请先点停止按钮。\n'
            '普通控制操作串行执行，启动中可能暂时不能停止；软件控制不是物理急停。\n'
            '停止全部包括机械臂、视觉、RViz、Robot 和 Master，保留容器数据及地图。\n\n'
            '配置：' + str(BASE / 'KV260.env') + '\n日志：' + str(state_dir()))
        help_widget = tk.Text(help_page, wrap='word', relief='flat', bg='#eef2f7', font=('Sans', 11), padx=8, pady=8)
        help_widget.pack(fill='both', expand=True)
        self.set_text(help_widget, help_text)
        self.footer = tk.StringVar(value='只读监控 · 不自动启动硬件')
        ttk.Label(self.root, textvariable=self.footer, padding=(20,10)).pack(fill='x')

    def button(self, parent, action, label):
        button = ttk.Button(parent, text=label, command=lambda: self.launch(action), style='Danger.TButton' if action == 'stop-all' else 'TButton')
        button.pack(fill='x', pady=3)
        self.buttons[action] = button

    def refresh_maps(self):
        folder = Path(self.env.get('MAP_DIR', '/home/ubuntu/x3plus-maps'))
        names = sorted(p.stem for p in folder.glob('*.yaml') if MAP_PATTERN.fullmatch(p.stem))
        self.maps['values'] = names
        if self.map_name.get() not in names:
            self.map_name.set(names[0] if names else '')

    def monitor_loop(self):
        while not self.stop.is_set():
            self.refresh.clear()
            try:
                data = self.monitor.snapshot()
            except Exception as exc:
                data = {'error': str(exc)}
            try:
                data['arm'] = arm_snapshot()
            except Exception as exc:
                data['arm'] = {'error': str(exc)}
            data['sampled_at'] = time.strftime('%H:%M:%S')
            try:
                self.results.put_nowait(data)
            except queue.Full:
                pass
            self.refresh.wait(8)

    @staticmethod
    def set_text(widget, content):
        widget.configure(state='normal')
        widget.delete('1.0','end')
        widget.insert('1.0', content)
        widget.configure(state='disabled')

    def show_snapshot(self, data):
        self.snapshot = data
        self.arm.update(data.get('arm', {'error': '尚未采样'}))
        if 'error' in data:
            self.summary.set('状态读取失败：' + data['error'])
            return
        mem = data['memory']
        cpu = '采样中' if data['cpu'] is None else '%.0f%%' % data['cpu']
        self.resource.set('CPU %s · 内存已用 %.0f / %.0f MiB · 可用 %.0f MiB' % (cpu, mem['total']-mem['available'], mem['total'], mem['available']))
        lines = ['%s：%s' % (label, data['serial'][role]['message']) for role,label in [('ROBOT','底盘'),('LIDAR','雷达')]]
        containers = data.get('containers', {})
        lines.append('容器：' + ' | '.join('%s %s' % (label, containers.get(self.env.get(key, name),'未创建')) for label,key,name in [('Master','MASTER_NAME','x3plus-master'),('Robot','ROBOT_NAME','x3plus-robot'),('RViz','RVIZ_CONTAINER_NAME','x3plus-rviz')]))
        nodes = data.get('nodes', [])
        lines.append('ROS：' + ('不可达' if 'ros_error' in data else '%d 个注册节点（非健康检查）' % len(nodes)))
        lines.append('当前网络：' + data.get('network', '未确定') + '；换网后请重新启动基础环境')
        if data.get('mapping_error'):
            lines.append('警告：' + data['mapping_error'])
        self.summary.set('\n'.join(lines))
        self.camera_text.set('相机已枚举（未验证图像/深度）' if data['camera'] else '相机未连接 · 禁用视觉启动，不加载 DPU')
        children = self.device_table.get_children()
        if children:
            self.device_table.delete(*children)
        for d in data['devices']:
            self.device_table.insert('', 'end', values=(d['path'],d['vid']+':'+d['pid'],d['serial'] or '无',d['interface'] or '未知',d['location']))
        detail = '\n'.join(lines) + '\n\n注册节点：\n' + ('\n'.join(nodes) or '无 / 无法获取')
        detail += '\n\n容器映射：' + data.get('mapping_error', data.get('mapping','未检查'))
        detail += '\nDocker 错误：' + data.get('docker_error','无')
        detail += '\nROS 错误：' + data.get('ros_error','无')
        detail += '\n内存 PSI：' + ' '.join(data.get('pressure',[]))
        detail += '\n相机路径：' + data['camera_path']
        self.set_text(self.details, detail)
        self.footer.set('只读监控 · 最近采样 ' + data['sampled_at'] + ' · 周期 8 秒 · 关闭窗口不停止服务')

    def select_log(self, _event=None):
        self.selected = list(ACTIONS)[self.log_choice.current()]
        self.last_log = None

    def tick(self):
        if self.closing:
            return
        try:
            self.show_snapshot(self.results.get_nowait())
        except queue.Empty:
            pass
        pending = []
        for proc, submitted in self.processes:
            code = proc.poll()
            if code is None:
                pending.append((proc, submitted))
            elif code:
                error = tail_log(state_dir() / (submitted + '.submit.log'), 4000)
                messagebox.showerror('任务未成功完成', '%s · 返回码 %s\n%s\n请查看任务日志及实际服务状态。' %
                                     (ACTIONS[submitted][0], code, error), parent=self.root)
        self.processes = pending
        busy = is_active('control')
        arm_busy = is_active('arm-control')
        for action, button in self.buttons.items():
            stop_action = action.startswith(('stop-', 'arm-stop'))
            gate_busy = arm_busy if action.startswith('arm-') else busy
            disabled = is_active(action) or (not stop_action and gate_busy)
            if action == 'vision' and not self.snapshot.get('camera'):
                disabled = True
            button.configure(state='disabled' if disabled else 'normal')
        action = self.selected
        if self.tabs.select() == str(self.logs_tab):
            value = tail_log(state_dir() / (action + '.log'))
            if value != self.last_log:
                bottom = self.log_text.yview()[1] >= .98
                self.set_text(self.log_text, value)
                if bottom:
                    self.log_text.see('end')
                self.last_log = value
        try:
            state = json.loads((state_dir() / (action + '.json')).read_text())
            self.task_info.set('任务运行中' if is_active(action) else (state.get('message') or ('已结束 · 返回码 %s' % state['returncode'] if 'returncode' in state else '任务中断 / 旧记录；请查看服务状态')))
        except (OSError, ValueError):
            self.task_info.set('未运行 / 等待任务记录')
        self.root.after(1000, self.tick)

    def open_vision(self):
        env = dict(self.env)
        env.setdefault('DISPLAY', ':0')
        env.setdefault('XAUTHORITY', '/run/user/1000/gdm/Xauthority')
        subprocess.Popen([sys.executable, str(BASE/'launcher_vision_ui.py')],
                         cwd=BASE, env=env, start_new_session=True)

    def launch(self, action):
        argument = ''
        if action.startswith('arm-'):
            try:
                argument = self.arm.argument(action)
            except ValueError as exc:
                messagebox.showerror('机械臂参数无效', str(exc), parent=self.root)
                return
            if action not in ('arm-pose', 'arm-stop', 'arm-stop-mode'):
                if not messagebox.askyesno(ACTIONS[action][0],
                        '此操作可能改变机械臂姿态，且会停止其他机械臂模式。\n'
                        '请确保工作空间无人、无障碍，并能随时断电。\n参数：' + (argument or '官方默认配置'), parent=self.root):
                    return
        if action == 'save':
            argument = simpledialog.askstring('保存地图','新地图名称（英文、数字、_、-；不会覆盖）：',parent=self.root)
            if argument is None:
                return
        elif action == 'navigation':
            argument = self.map_name.get()
        if action in ('save','navigation') and not MAP_PATTERN.fullmatch(argument):
            messagebox.showerror('地图名称无效','请选择或输入合法地图名称。',parent=self.root)
            return
        if action in ('hardware','slam','navigation','keyboard','vision','stop-all'):
            warning = '将停止机械臂、视觉、RViz、Robot 和 Master，保留地图和容器。\n这不是物理急停。' if action == 'stop-all' else '此操作可能启动硬件、切换模式或加载 DPU。\n请确认环境安全；软件控制不能替代物理急停。'
            if action == 'navigation':
                warning = '将停止键盘控制和 SLAM，再启动或复用所选地图的导航。\n无法确认退出时拒绝导航；底盘与雷达保留运行。\n请确认环境安全；软件控制不能替代物理急停。'
            if not messagebox.askyesno(ACTIONS[action][0],warning,parent=self.root):
                return
        args = [sys.executable,str(BASE/'launcher_tasks.py'),action] + ([argument] if argument else [])
        env = dict(self.env)
        env.setdefault('DISPLAY',':0')
        env.setdefault('XAUTHORITY','/run/user/%d/gdm/Xauthority' % os.getuid())
        env.setdefault('DBUS_SESSION_BUS_ADDRESS','unix:path=/run/user/%d/bus' % os.getuid())
        try:
            if action == 'keyboard':
                args = ['gnome-terminal','--wait','--title','KV260 键盘控制 · 空格/k 停止','--',*args]
            elif action == 'arm-keyboard':
                args = ['gnome-terminal','--wait','--title','RoArm-M3 官方键盘 · Q 退出','--',*args]
            if len(self.processes) >= 20:
                raise OSError('待处理任务过多，请等待已有任务完成。')
            # Only supervisor/bootstrap stderr goes here; task output uses the
            # rotating logger. Truncate this small file on each submission.
            with (state_dir() / (action + '.submit.log')).open('wb') as errors:
                proc = subprocess.Popen(args,cwd=BASE,env=env,start_new_session=True,
                    stdin=subprocess.DEVNULL,stdout=subprocess.DEVNULL,stderr=errors)
            self.processes.append((proc, action))
            self.selected = action
            self.log_choice.current(list(ACTIONS).index(action))
            self.tabs.select(self.logs_tab)
            self.last_log = None
            self.footer.set('已提交：' + ACTIONS[action][0] + '；等待任务状态。')
        except OSError as exc:
            messagebox.showerror('启动失败',str(exc),parent=self.root)

    def export(self):
        path = filedialog.asksaveasfilename(parent=self.root,defaultextension='.json',initialfile='kv260-diagnostics.json')
        if path:
            try:
                Path(path).write_text(json.dumps(self.snapshot,ensure_ascii=False,indent=2))
            except OSError as exc:
                messagebox.showerror('导出失败',str(exc),parent=self.root)

    def close(self, force=False):
        if not force and not messagebox.askyesno('关闭控制台','仅关闭界面，任务和服务继续运行。\n如需停止，请先使用停止按钮。继续关闭？',parent=self.root):
            return
        self.closing = True
        self.stop.set()
        self.refresh.set()
        self.ofdm.close()
        self.root.destroy()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--diagnose',action='store_true',help='只读诊断，不显示界面')
    parser.add_argument('--smoke-seconds',type=int,default=0,help='只读 GUI 测试，指定秒数后退出')
    args = parser.parse_args()
    env = read_env()
    if args.diagnose:
        print(json.dumps(Monitor(env).snapshot(),ensure_ascii=False,indent=2))
        return 0
    with (state_dir()/'gui.lock').open('a') as lock:
        root = tk.Tk()
        try:
            fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        except BlockingIOError:
            root.withdraw()
            messagebox.showinfo('KV260 控制台','控制台已打开，请切换到已有窗口。',parent=root)
            root.destroy()
            return 0
        app = Dashboard(root,env)
        if args.smoke_seconds:
            root.after(args.smoke_seconds*1000,lambda:app.close(force=True))
        root.mainloop()
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
