#!/usr/bin/env python3
"""Chinese Tk console; all Docker/ROS operations run outside the UI thread."""
import json
import queue
import threading
import time
import tkinter as tk
from tkinter import messagebox, ttk

import console_backend as backend


class Console(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("X3plus KV260 上位机")
        self.geometry("1000x%d" % min(940, self.winfo_screenheight() - 70))
        self.minsize(900, 700)
        self.events = queue.Queue()
        self.busy = False
        self.refresh_in_progress = False
        self.last_probe = None
        self.next_probe = 0
        self.network_fingerprint = None
        self.last_viewer = {}
        self.config_data, warning = backend.load_config()
        self.build_ui()
        self.write_log(warning or "请确认 KV260 已启动硬件和 SLAM 或导航服务。")
        self.write_log("关闭上位机窗口会保留 RViz；停止 RViz 不会停止板上导航。")
        self.after(100, self.consume_events)
        self.after(200, self.auto_refresh)

    def build_ui(self):
        ttk.Style(self).configure("Title.TLabel", font=("Sans", 18, "bold"))
        outer = ttk.Frame(self, padding=16)
        outer.pack(fill="both", expand=True)
        ttk.Label(outer, text="X3plus KV260 上位机", style="Title.TLabel").pack(anchor="w")
        ttk.Label(outer, text="网络配置 · 地图与导航查看 · ROS 连接检查").pack(anchor="w", pady=(4, 12))
        network = ttk.LabelFrame(outer, text="网络配置", padding=10)
        network.pack(fill="x")
        self.variables = {key: tk.StringVar(value=value) for key, value in self.config_data.items()}
        self.controls = []
        for row, (key, label) in enumerate((("pc_ip", "主机 IP"), ("kv260_ip", "KV260 IP"), ("port", "ROS Master 端口"))):
            ttk.Label(network, text=label, width=19).grid(row=row, column=0, sticky="w", pady=3)
            if key == "pc_ip":
                entry = ttk.Combobox(network, textvariable=self.variables[key])
                self.address_box = entry
            else:
                entry = ttk.Entry(network, textvariable=self.variables[key])
            entry.grid(row=row, column=1, sticky="ew", padx=8)
            self.controls.append(entry)
        network.columnconfigure(1, weight=1)
        for row, (label, callback) in enumerate((("自动检测网卡", self.auto_ip), ("保存配置", self.save_config), ("恢复默认值", self.reset_defaults))):
            button = ttk.Button(network, text=label, command=callback)
            button.grid(row=row, column=2, padx=8, sticky="ew")
            self.controls.append(button)
        self.interface_info = ttk.Label(network, text="可手动输入或自动检测后从下拉框选择网卡地址。")
        self.interface_info.grid(row=3, column=0, columnspan=3, sticky="w", pady=(6, 0))
        ttk.Label(network, text="网络方案名称").grid(row=4, column=0, sticky="w")
        self.profile_box = ttk.Combobox(network)
        self.profile_box.grid(row=4, column=1, sticky="ew", padx=8, pady=5)
        self.controls.append(self.profile_box)
        profile_actions = ttk.Frame(network)
        profile_actions.grid(row=4, column=2)
        for label, callback in (("保存方案", self.save_profile), ("载入方案", self.load_profile)):
            button = ttk.Button(profile_actions, text=label, command=callback)
            button.pack(side="left")
            self.controls.append(button)
        try:
            self.profile_box.configure(values=sorted(backend.profiles()))
        except (OSError, ValueError) as exc:
            self.profile_box.set("方案读取失败")
            self.after(0, lambda error=str(exc): self.write_log(error))

        actions = ttk.LabelFrame(outer, text="RViz 操作", padding=10)
        actions.pack(fill="x", pady=10)
        buttons = (("启动 SLAM 地图 RViz", lambda: self.launch("slam")),
                   ("启动导航 RViz", lambda: self.launch("navigation")),
                   ("停止 RViz", self.stop_viewer), ("查看 RViz 日志", self.viewer_logs))
        for column, (label, callback) in enumerate(buttons):
            button = ttk.Button(actions, text=label, command=callback)
            button.grid(row=0, column=column, sticky="ew", padx=3)
            self.controls.append(button)
            actions.columnconfigure(column, weight=1)
        ttk.Label(actions, text="切换模式或网络配置会重建当前查看器。导航按钮仅打开 RViz，板上服务需另行启动。",
                  wraplength=750).grid(row=1, column=0, columnspan=4, sticky="w", pady=(8, 0))

        frame = ttk.LabelFrame(outer, text="连接状态（每 5 秒刷新注册信息）", padding=10)
        frame.pack(fill="x")
        self.status_labels = {}
        labels = (("network", "网络配置一致性"), ("master", "ROS Master"), ("map", "/map 地图"), ("scan", "/scan 雷达"),
                  ("tf", "TF 发布者"), ("localization", "AMCL 定位"), ("nav", "move_base"),
                  ("cmd_vel", "/cmd_vel 发布者"), ("viewer", "电脑 RViz"), ("probe", "数据 / TF 实测"))
        for row, (key, label) in enumerate(labels):
            ttk.Label(frame, text=label, width=19).grid(row=row, column=0, sticky="nw", pady=2)
            value = ttk.Label(frame, text="尚未检查", wraplength=590)
            value.grid(row=row, column=1, sticky="w", pady=2)
            self.status_labels[key] = value
        frame.columnconfigure(1, weight=1)
        refresh = ttk.Frame(frame)
        refresh.grid(row=len(labels), column=0, columnspan=2, sticky="w", pady=(8, 0))
        ttk.Button(refresh, text="刷新注册状态", command=self.refresh_status).pack(side="left")
        button = ttk.Button(refresh, text="检查实际数据与 TF", command=self.probe)
        button.pack(side="left", padx=8)
        self.controls.append(button)
        network_button = ttk.Button(refresh, text="完整网络诊断", command=self.check_network)
        network_button.pack(side="left", padx=4)
        self.controls.append(network_button)
        button = ttk.Button(refresh, text="重新连接当前 RViz", command=self.reconnect)
        button.pack(side="left", padx=4)
        self.controls.append(button)
        self.continuous_probe = tk.BooleanVar(value=True)
        ttk.Checkbutton(frame, text="每 20 秒实测数据与 TF（结果 35 秒后失效；不重启板端服务）",
                        variable=self.continuous_probe).grid(row=len(labels)+1, column=0, columnspan=2, sticky="w")
        bookmarks = ttk.LabelFrame(outer, text="地图绑定起点（仅 AMCL 导航；不会自动开车）", padding=6)
        # Keep pose actions visible when status messages wrap in a short window.
        bookmarks.pack(fill='x', pady=5, before=frame)
        self.bookmark_box = ttk.Combobox(bookmarks, width=20)
        self.bookmark_box.pack(side='left', padx=3)
        self.controls.append(self.bookmark_box)
        for text, callback in (('保存当前位置', self.save_start_pose), ('显示起点', self.preview_start_pose),
                               ('恢复起点定位', self.restore_start_pose)):
            button = ttk.Button(bookmarks, text=text, command=callback)
            button.pack(side='left', padx=3)
            self.controls.append(button)
        self.reload_bookmarks()
        self.activity = tk.StringVar(value="就绪")
        ttk.Label(outer, textvariable=self.activity).pack(anchor="w", pady=(8, 3))
        log_frame = ttk.Frame(outer)
        log_frame.pack(fill="both", expand=True)
        self.log = tk.Text(log_frame, height=7, state="disabled", wrap="word")
        scrollbar = ttk.Scrollbar(log_frame, command=self.log.yview)
        self.log.configure(yscrollcommand=scrollbar.set)
        scrollbar.pack(side="right", fill="y")
        self.log.pack(fill="both", expand=True)
        for variable in self.variables.values():
            variable.trace_add('write', self.configuration_changed)

    def invalidate_probe(self, reason):
        self.last_probe = None
        self.set_status('probe', reason, False)

    def reload_bookmarks(self):
        try:
            self.bookmark_box.configure(values=sorted(backend.bookmarks()))
        except (OSError, ValueError) as exc:
            self.after(0, lambda error=str(exc): self.write_log('起点书签读取失败：' + error))

    def save_start_pose(self):
        if self.busy:
            return
        try:
            name = backend.profile_name(self.bookmark_box.get())
            exists = name in backend.bookmarks()
        except (OSError, ValueError) as exc:
            messagebox.showerror('起点保存失败', str(exc), parent=self)
            return
        prompt = ('覆盖已有起点“%s”。\n' % name if exists else '')
        prompt += ('请确认：这是已保存地图的 AMCL 导航模式；小车已静止，'
                   '实车位置和车头方向与 RViz 一致，激光与地图重合。\n'
                   '仅 ready 不能排除对称地图的错误定位。确认保存当前位置？')
        if not messagebox.askyesno('核实实车定位后保存', prompt, parent=self):
            return
        data = self.data()
        self.operation('保存起点', lambda: backend.save_bookmark(name, data, True, exists), 'bookmark_saved')

    def preview_start_pose(self):
        if self.busy:
            return
        name, data = self.bookmark_box.get(), self.data()
        self.operation('显示起点', lambda: backend.use_bookmark(name, data))

    def restore_start_pose(self):
        if self.busy:
            return
        name, data = self.bookmark_box.get(), self.data()
        try:
            entry = backend.bookmarks()[name]
        except (OSError, ValueError, KeyError) as exc:
            messagebox.showerror('请选择已保存起点', str(exc), parent=self)
            return
        x, y, angle = entry['pose']
        prompt = ('起点：%s\nx=%.3f m，y=%.3f m，朝向=%.1f°\n\n'
                  '必须先把实车放回该位置，车头朝向也完全一致，并保持静止。\n'
                  '将撤销旧目标并重设 AMCL；不会自动行驶，必须等待重新定位检查。\n'
                  '确认已完成实物摆放？') % (name, x, y, angle*180/3.141592653589793)
        if not messagebox.askyesno('确认实物摆放及朝向', prompt, parent=self):
            return
        self.invalidate_probe('正在恢复起点，必须重新检查定位')
        self.operation('恢复起点定位', lambda: backend.use_bookmark(name, data, True, True))

    def configuration_changed(self, *_):
        self.invalidate_probe('配置已变化，请诊断或重新连接')
        self.set_status('network', '输入已变化，等待检查', None)
        self.next_probe = time.monotonic() + 2

    def save_profile(self):
        try:
            name = backend.profile_name(self.profile_box.get())
            if name in backend.profiles() and not messagebox.askyesno('覆盖网络方案', '覆盖方案“%s”？' % name, parent=self):
                return
            backend.save_profile(name, self.data())
            self.profile_box.configure(values=sorted(backend.profiles()))
            self.write_log('已保存网络方案：' + name)
        except (OSError, ValueError) as exc:
            messagebox.showerror('方案保存失败', str(exc), parent=self)

    def load_profile(self):
        try:
            data = backend.profiles()[self.profile_box.get().strip()]
            for key, value in data.items():
                self.variables[key].set(value)
            self.write_log('已载入方案，保留已保存的网卡选择；请诊断或重新连接。')
            self.refresh_status()
        except (OSError, ValueError, KeyError) as exc:
            messagebox.showerror('方案载入失败', str(exc), parent=self)

    def reconnect(self):
        data = self.data()
        self.invalidate_probe('正在重新连接，等待实测')
        self.operation('重新连接当前 RViz', lambda: backend.reconnect(data), 'diagnosis')

    def data(self):
        return {key: variable.get().strip() for key, variable in self.variables.items()}

    def save_config(self, quiet=False):
        try:
            backend.save_config(self.data())
        except (OSError, ValueError) as exc:
            messagebox.showerror("配置错误", str(exc), parent=self)
            return False
        if not quiet:
            self.write_log("配置已保存：" + str(backend.CONFIG))
        return True

    def reset_defaults(self):
        for key, value in backend.DEFAULTS.items():
            self.variables[key].set(value)
        self.write_log("已恢复默认输入；自动检测完成后点击保存配置生效。")
        self.auto_ip()

    def auto_ip(self):
        target = self.variables["kv260_ip"].get().strip()
        self.operation("检测网卡", lambda: (backend.local_addresses(), backend.detect_pc_ip(target)), "addresses")

    def launch(self, mode):
        if self.busy or not self.save_config(quiet=True):
            return
        data = self.data()
        self.invalidate_probe("网络或模式变更后需重新实测")
        self.operation("启动 " + ("SLAM" if mode == "slam" else "导航") + " RViz", lambda: backend.launch(mode, data))

    def stop_viewer(self):
        self.invalidate_probe('正在停止 RViz')
        self.operation("停止 RViz", backend.stop)

    def viewer_logs(self):
        self.operation("读取 RViz 日志", backend.viewer_logs)

    def probe(self):
        data = self.data()
        self.operation("检查实际数据与 TF（约 6 秒）", lambda: backend.probe(data), "probe")

    def check_network(self):
        data = self.data()
        self.invalidate_probe('正在完整诊断')
        self.operation("完整网络诊断", lambda: backend.diagnose(data), 'diagnosis')

    def operation(self, title, function, kind="operation"):
        if self.busy:
            return
        self.busy = True
        self.operation_config = self.data()
        self.activity.set(title + "…")
        for control in self.controls:
            control.state(["disabled"])

        def worker():
            try:
                self.events.put((kind, title, function(), None))
            except Exception as exc:
                self.events.put((kind, title, None, str(exc)))
        threading.Thread(target=worker, daemon=True).start()

    def refresh_status(self):
        if self.refresh_in_progress or self.busy:
            return
        self.refresh_in_progress = True
        data = self.data()

        def worker():
            try:
                backend.validate(data)
                self.events.put(("status", data, backend.status(data), None))
            except Exception as exc:
                self.events.put(("status", data, ({"ok": False, "error": str(exc)}, {"error": "检查未完成"},
                                                {'ok': False, 'issues': [str(exc)], 'addresses': [], 'route': ''}), None))
        threading.Thread(target=worker, daemon=True).start()

    def auto_refresh(self):
        now = time.monotonic()
        if self.last_probe and now - self.last_probe[0] > 35:
            self.invalidate_probe('实测结果已过期，等待重新检查')
        if (self.continuous_probe.get() and not self.busy and not self.refresh_in_progress
                and self.last_viewer.get('running') and now >= self.next_probe):
            self.next_probe = now + 20
            self.probe()
        self.refresh_status()
        self.after(5000, self.auto_refresh)

    def consume_events(self):
        try:
            while True:
                kind, context, result, error = self.events.get_nowait()
                if kind == "status":
                    self.refresh_in_progress = False
                    if context == self.data() and not self.busy:
                        self.show_status(*result)
                    continue
                self.busy = False
                for control in self.controls:
                    control.state(["!disabled"])
                self.activity.set("操作失败" if error else "就绪")
                if kind in ('probe', 'diagnosis') and self.operation_config != self.data():
                    self.invalidate_probe('检查期间配置已变化，请重新检查')
                    self.refresh_status()
                    continue
                if error:
                    self.write_log(context + "失败：" + error)
                    if kind in ("probe", "diagnosis"):
                        self.invalidate_probe("检查失败，详见日志")
                elif kind == "addresses":
                    addresses, route = result
                    self.address_box.configure(values=[address for _, address in addresses])
                    self.interface_info.configure(text="；".join("%s: %s" % item for item in addresses) or "没有启用的 IPv4 网卡")
                    if route:
                        self.variables["pc_ip"].set(route)
                    self.write_log("检测到主机地址：" + (route or "无到 KV260 的路由，请手动选择"))
                elif kind == "probe":
                    self.show_probe(result)
                elif kind == 'bookmark_saved':
                    self.reload_bookmarks()
                    self.write_log('起点已保存（地图指纹绑定）：\n' + json.dumps(result, ensure_ascii=False))
                elif kind == 'diagnosis':
                    self.write_log('诊断结果：\n' + json.dumps(result, ensure_ascii=False, indent=2))
                    self.set_status('network', '完整诊断通过' if result['ok'] else '诊断未全部通过，详见日志', result['ok'])
                    if result.get('probe') and result['ok']:
                        self.show_probe(result['probe'])
                    else:
                        self.invalidate_probe('诊断未全部通过，详见日志')
                    if not result['ok']:
                        self.activity.set('诊断未全部通过')
                else:
                    self.write_log(context + "完成：\n" + (result or "无输出"))
                self.refresh_status()
        except queue.Empty:
            pass
        finally:
            self.after(100, self.consume_events)

    def set_status(self, key, text, good):
        color = "#19733b" if good else "#a05a00" if good is False else "#56616f"
        self.status_labels[key].configure(text=text, foreground=color)

    def show_probe(self, result):
        good = backend.probe_ok(result)
        self.last_probe = (time.monotonic(), self.data())
        self.next_probe = time.monotonic() + 20
        nav_good = backend.navigation_ok(result)
        description = ' 数据连通；定位已确认' if nav_good else (' 数据连通；定位未确认，导航未放行' if good else ' 数据缺失或过期，详见日志')
        self.set_status('probe', time.strftime('%H:%M:%S') + description, good)
        self.write_log('实测结果（定位确认状态来自板端门控）：\n' + json.dumps(result, ensure_ascii=False))

    def show_status(self, ros, viewer, network=None):
        self.last_viewer = viewer
        if network is not None:
            fingerprint = (tuple(sorted(tuple(item) for item in network['addresses'])), network['route'],
                           tuple(sorted(network.get('routing', {}).items())))
            if self.network_fingerprint is not None and fingerprint != self.network_fingerprint:
                self.invalidate_probe('网卡或路由发生变化，请重新连接')
                self.write_log('检测到网络变化；请确认 KV260 IP，自动检测主机地址，再重新连接。')
            self.network_fingerprint = fingerprint
            self.set_status('network', ('本机与运行配置一致；路由源地址 ' + network['route']) if network['ok']
                            else '；'.join(network['issues']), network['ok'])
            if not network['ok']:
                self.invalidate_probe('网络配置不一致或不可用，请查看诊断')
        if not ros.get('ok') or not viewer.get('running'):
            self.invalidate_probe('Master 不可达或 RViz 未运行')
        self.set_status("master", "已连接 " + backend.master_url(self.data()) if ros.get("ok") else "未连接：" + ros.get("error", "连接失败")[:90], bool(ros.get("ok")))
        fields = (("map", "map_publishers"), ("scan", "scan_publishers"), ("tf", "tf_publishers"),
                  ("localization", "amcl_publishers", "amcl_nodes"),
                  ("nav", "move_base_publishers", "move_base_nodes"), ("cmd_vel", "cmd_vel_publishers"))
        for field in fields:
            key, source = field[0], field[1]
            nodes = list(ros.get(source, []))
            for extra_source in field[2:]:
                nodes += ros.get(extra_source, [])
            nodes = sorted(set(nodes))
            if key == "tf":
                nodes = sorted(set(nodes + ros.get("tf_static_publishers", [])))
            text = "已注册：" + ", ".join(nodes) if nodes else "无发布者"
            if key == "tf" and nodes:
                text = "已注册 %d 个节点；链路有效性请点击实测" % len(nodes)
            self.set_status(key, text if ros.get("ok") else "等待 ROS Master", None if key == "cmd_vel" else bool(nodes))
        if viewer.get("error"):
            self.set_status("viewer", "Docker 检查失败：" + viewer["error"][:90], False)
        elif viewer.get("running"):
            mode = "SLAM" if viewer["mode"] == "slam" else "导航"
            matches = viewer["master"] == backend.master_url(self.data()) and viewer["pc_ip"] == self.data()["pc_ip"]
            text = "运行中（%s），%s → %s" % (mode, viewer["pc_ip"], viewer["master"])
            self.set_status("viewer", text + ("" if matches else "；与输入配置不同"), matches)
        else:
            self.set_status("viewer", "未运行", None)

    def write_log(self, text):
        self.log.configure(state="normal")
        self.log.insert("end", "[%s] %s\n" % (time.strftime("%H:%M:%S"), text))
        if int(self.log.index("end-1c").split(".")[0]) > 1500:
            self.log.delete("1.0", "501.0")
        self.log.see("end")
        self.log.configure(state="disabled")


if __name__ == "__main__":
    Console().mainloop()