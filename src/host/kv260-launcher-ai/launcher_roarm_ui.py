"""RoArm controls use the dashboard's existing tasks, logs and confirmations."""
import json
import tkinter as tk
from tkinter import ttk
from launcher_roarm import validate_command


class RoArmPanel:
    def __init__(self, app, parent):
        self.app = app
        self.status = tk.StringVar(value='机械臂状态检查中…')
        ttk.Label(parent, textvariable=self.status, wraplength=980, justify='left').pack(fill='x', pady=(0, 8))
        row = ttk.Frame(parent)
        row.pack(fill='x')
        start = ttk.LabelFrame(row, text='官方教程 3–5 · 驱动与交互', padding=10)
        start.pack(side='left', fill='both', expand=True, padx=(0, 8))
        for action, label in [('arm-driver', '3 · 启动 / 复用官方驱动'),
                              ('arm-moveit', '4 · MoveIt2 拖拽控制（RViz）'),
                              ('arm-keyboard', '5 · 官方键盘控制（独立终端）'),
                              ('arm-stop-mode', '停止控制模式（保留驱动）'),
                              ('arm-stop', '停止机械臂服务（含驱动）')]:
            app.button(start, action, label)
        ttk.Label(start, text='模式自动互斥。拖拽后先 Plan，检查轨迹再 Execute。\n键盘启动后等 3 秒再按 j；确认切换成功后按 1–5。\nr 反向；g 夹爪；t → 方向键 / ; / .；Q 退出。',
                  wraplength=420, justify='left').pack(anchor='w', pady=4)
        mtc = ttk.LabelFrame(row, text='官方教程 7 · MoveIt Task Constructor', padding=10)
        mtc.pack(side='left', fill='both', expand=True)
        app.button(mtc, 'arm-mtc', '启动 MTC 模式（RViz）')
        self.demo = tk.StringVar(value='supervised_demo')
        ttk.Combobox(mtc, textvariable=self.demo, state='readonly',
                     values=('supervised_demo', 'cartesian', 'cartesian_modular', 'pick_place')).pack(fill='x', pady=4)
        app.button(mtc, 'arm-mtc-task', '规划所选 MTC 演示')
        ttk.Label(mtc, text='supervised_demo：底座左右约 26°、腕部约 20°，自动返回起点。\n在 RViz 中选择任务完整解，检查后点击 Exec。\n从 ready 姿态开始；执行期间请勿切换模式。',
                  wraplength=420, justify='left').pack(anchor='w', pady=4)
        app.button(mtc, 'arm-pose', '读取模型位姿（需先启动命令模式）')
        command = ttk.LabelFrame(parent, text='官方教程 6 · ROS2 命令控制（米 / 弧度）', padding=10)
        command.pack(fill='x', pady=10)
        app.button(command, 'arm-command', '启动命令控制模式')
        self.values = {}
        for keys, defaults in [(('x', 'y', 'z', 'roll', 'pitch', 'yaw'), ('0.3', '0', '0.1', '0.2', '0.2', '0')),
                               (('x0', 'y0', 'z0', 'x1', 'y1', 'z1'), ('0.2', '0.1', '0.2', '0.2', '0.2', '0.2'))]:
            inputs = ttk.Frame(command)
            inputs.pack(fill='x', pady=4)
            for key, default in zip(keys, defaults):
                ttk.Label(inputs, text=key).pack(side='left', padx=(4, 2))
                self.values[key] = tk.StringVar(value=default)
                ttk.Entry(inputs, textvariable=self.values[key], width=9).pack(side='left', padx=(0, 8))
        commands = ttk.Frame(command)
        commands.pack(fill='x', pady=4)
        for action, label in [('arm-joint', '目标位姿'), ('arm-line', '直线到 xyz'), ('arm-circle', '圆弧经过点 → 终点')]:
            app.button(commands, action, label)
            app.buttons[action].pack_configure(side='left', padx=4)
        self.values['data'] = tk.StringVar(value='0.5')
        ttk.Label(commands, text='夹爪 0–1.5').pack(side='left', padx=8)
        ttk.Entry(commands, textvariable=self.values['data'], width=7).pack(side='left')
        app.button(commands, 'arm-gripper', '发送夹爪')
        app.buttons['arm-gripper'].pack_configure(side='left', padx=8)
        ttk.Label(parent, text='启动模式可能使实机改变姿态。软件停止保留舵机力矩；危险时使用电源开关。\n官方驱动把模型 /joint_states 写给实机，位姿查询不是编码器反馈。命令执行以实际运动和日志为准。',
                  wraplength=960, foreground='#a32130', justify='left').pack(anchor='w')
        ttk.Button(parent, text='查看机械臂服务日志', command=self.open_logs).pack(anchor='e', pady=6)

    def argument(self, action):
        if action == 'arm-mtc-task':
            return self.demo.get()
        kind = action.removeprefix('arm-')
        from launcher_roarm import FIELDS
        if kind in FIELDS:
            payload = {key: float(self.values[key].get()) for key in FIELDS[kind]}
            return json.dumps(validate_command(kind, payload))
        return ''

    def update(self, data):
        if 'error' in data:
            self.status.set('机械臂检查失败：' + data['error'])
            return
        ps = data['processes']
        mode = ', '.join(data['modes']) or '无'
        self.status.set('RoArm-M3 · ROS2 Humble · 串口 %s → %s（%s）\n驱动 %s · 当前模式 %s · 键盘 %s · MTC 示例 %s\n工作区 %s（%s）' % (
            data['serial'], data['serial_target'], '可读写' if data['serial_ready'] else '不可用',
            ps['driver'] or '未运行', mode, ps['keyboard'] or '未运行', ps['mtc-task'] or '未运行',
            data['workspace'], '已安装' if data['installed'] else '未安装'))

    def open_logs(self):
        from launcher_roarm import directory
        window = tk.Toplevel(self.app.root)
        window.title('机械臂服务日志 · ' + str(directory()))
        window.geometry('900x600')
        choice = ttk.Combobox(window, state='readonly', values=(
            'driver', 'moveit', 'servo', 'command', 'mtc', 'mtc-task'))
        choice.current(0)
        choice.pack(fill='x')
        text = tk.Text(window, wrap='word')
        text.pack(fill='both', expand=True)
        def refresh():
            from kv260_launcher import tail_log
            self.app.set_text(text, tail_log(directory() / (choice.get() + '.log')))
            text.see('end')
        choice.bind('<<ComboboxSelected>>', lambda _event: refresh())
        ttk.Button(window, text='刷新（最近 24 KB）', command=refresh).pack()
        refresh()