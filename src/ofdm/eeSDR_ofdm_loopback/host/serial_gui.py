#!/usr/bin/env python3
"""Desktop UART packet console for the OFDM loopback firmware."""

import os
import queue
import tkinter as tk
from datetime import datetime
from tkinter import filedialog, messagebox, scrolledtext, ttk

from serial_devices import AUTO_PORT, discover
from serial_worker import SerialWorker


class SerialConsole:
    def __init__(self, root):
        self.root = root
        root.title("OFDM UART Console")
        root.geometry("960x680")
        root.minsize(720, 540)
        self.connected = False
        self.active = False
        self.busy = False
        self.commands = queue.Queue()
        self.events = queue.Queue()
        self.port_name = tk.StringVar(value=AUTO_PORT)
        self.targets = {AUTO_PORT: {"target": AUTO_PORT}}
        self.mode = tk.StringVar(value="random")
        self.status = tk.StringVar(value="Disconnected")
        self.result = tk.StringVar(value="No transaction")

        page = ttk.Frame(root, padding=12)
        page.pack(fill="both", expand=True)
        page.columnconfigure(0, weight=1)
        page.rowconfigure(5, weight=1)
        ttk.Label(page, text="OFDM UART Console", font=("TkDefaultFont", 16, "bold")).grid(
            row=0, column=0, sticky="w", pady=(0, 12))
        toolbar = ttk.Frame(page)
        toolbar.grid(row=1, column=0, sticky="ew")
        ttk.Label(toolbar, text="Port").pack(side="left")
        self.ports = ttk.Combobox(toolbar, textvariable=self.port_name, width=58)
        self.ports.pack(side="left", padx=8)
        self.refresh_button = ttk.Button(toolbar, text="Refresh", command=self.refresh)
        self.refresh_button.pack(side="left")
        self.connect_button = ttk.Button(toolbar, text="Connect", command=self.connect)
        self.connect_button.pack(side="left", padx=8)
        ttk.Label(toolbar, text="115200 / 8N1").pack(side="right")

        settings = ttk.Frame(page)
        settings.grid(row=2, column=0, sticky="ew", pady=(14, 6))
        ttk.Label(settings, text="64-byte payload").pack(side="left", padx=(0, 12))
        ttk.Radiobutton(settings, text="Random", variable=self.mode, value="random").pack(side="left")
        ttk.Radiobutton(settings, text="Hex", variable=self.mode, value="hex").pack(side="left", padx=10)
        self.send_button = ttk.Button(settings, text="Send Packet", command=self.send, state="disabled")
        self.send_button.pack(side="right")
        self.payload = tk.Text(page, height=3, wrap="char", font=("TkFixedFont", 10))
        self.payload.grid(row=3, column=0, sticky="ew")
        self.payload.insert("1.0", bytes(range(64)).hex())

        log_toolbar = ttk.Frame(page)
        log_toolbar.grid(row=4, column=0, sticky="ew", pady=(12, 6))
        ttk.Label(log_toolbar, text="Serial Log").pack(side="left")
        ttk.Button(log_toolbar, text="Save Log", command=self.save_log).pack(side="right")
        ttk.Button(log_toolbar, text="Clear", command=self.clear_log).pack(side="right", padx=8)
        self.log = scrolledtext.ScrolledText(
            page, wrap="char", state="disabled", font=("TkFixedFont", 10))
        self.log.grid(row=5, column=0, sticky="nsew")
        footer = ttk.Frame(page)
        footer.grid(row=6, column=0, sticky="ew", pady=(10, 0))
        ttk.Label(footer, textvariable=self.status).pack(side="left")
        ttk.Label(footer, textvariable=self.result).pack(side="right")
        self.refresh()
        self.worker = SerialWorker(self.commands, self.events)
        self.worker.start()
        root.protocol("WM_DELETE_WINDOW", self.close)
        self.timer = root.after(100, self.poll)

    def refresh(self):
        try:
            devices = discover()
        except OSError as exc:
            self.append_log("Device scan failed: {}\n".format(exc))
            return
        self.targets = {AUTO_PORT: {"target": AUTO_PORT}}
        for device in devices:
            if device.is_target:
                same_serial = [item for item in devices if item.is_target
                               and item.serial_number == device.serial_number]
                options = {"target": AUTO_PORT, "serial_number": device.serial_number or None}
                if not device.serial_number or len(same_serial) > 1:
                    options["location"] = device.location or None
                self.targets[device.label] = options
            else:
                self.targets[device.label] = {"target": device.device}
        self.ports["values"] = list(self.targets)

    def update_controls(self):
        self.connect_button.configure(
            text="Disconnect / Stop" if self.active else "Connect",
            state="disabled" if self.busy else "normal")
        self.send_button.configure(state="normal" if self.connected and not self.busy else "disabled")
        self.ports.configure(state="disabled" if self.active or self.busy else "normal")
        self.refresh_button.configure(state="disabled" if self.active or self.busy else "normal")

    def connect(self):
        if self.busy:
            return
        if not self.active and not self.port_name.get().strip():
            messagebox.showerror("Serial port", "Select a serial port", parent=self.root)
            return
        self.busy = True
        self.status.set("Disconnecting..." if self.active else "Connecting...")
        target = self.port_name.get().strip()
        options = self.targets.get(target, {"target": target})
        self.commands.put(("disconnect" if self.active else "connect", options))
        self.update_controls()

    def send(self):
        if not self.connected or self.busy:
            return
        try:
            payload = os.urandom(64) if self.mode.get() == "random" else bytes.fromhex(
                self.payload.get("1.0", "end").strip())
            if len(payload) != 64:
                raise ValueError("Payload must contain exactly 64 bytes (128 hexadecimal digits)")
        except ValueError as exc:
            messagebox.showerror("Payload", str(exc), parent=self.root)
            return
        self.busy = True
        self.result.set("Waiting for response...")
        self.commands.put(("send", payload))
        self.update_controls()

    def append_log(self, text):
        self.log.configure(state="normal")
        self.log.insert("end", text)
        # Keep long sessions bounded while retaining the most recent output.
        lines = int(self.log.index("end-1c").split(".")[0])
        if lines > 10000:
            self.log.delete("1.0", "{}.0".format(lines - 10000))
        if int(self.log.count("1.0", "end-1c", "chars")[0]) > 1000000:
            self.log.delete("1.0", "end-1000000c")
        self.log.see("end")
        self.log.configure(state="disabled")

    def clear_log(self):
        self.log.configure(state="normal")
        self.log.delete("1.0", "end")
        self.log.configure(state="disabled")

    def save_log(self):
        filename = filedialog.asksaveasfilename(parent=self.root, defaultextension=".txt")
        if filename:
            try:
                with open(filename, "w", encoding="utf-8") as stream:
                    stream.write(self.log.get("1.0", "end-1c"))
            except OSError as exc:
                messagebox.showerror("Save log", str(exc), parent=self.root)

    def poll(self):
        try:
            for _ in range(200):
                kind, value = self.events.get_nowait()
                if kind == "connected":
                    self.connected = value
                elif kind == "active":
                    self.active = value
                elif kind == "status":
                    self.status.set(value)
                elif kind == "idle":
                    self.busy = False
                elif kind == "result":
                    self.result.set(value)
                elif kind == "error":
                    self.result.set("Error")
                    self.append_log("[{}] ERROR: {}\n".format(datetime.now().strftime("%H:%M:%S"), value))
                elif kind == "log":
                    self.append_log(value)
        except queue.Empty:
            pass
        self.update_controls()
        self.timer = self.root.after(100, self.poll)

    def close(self):
        self.root.after_cancel(self.timer)
        self.worker.stop.set()
        self.worker.join(timeout=3)
        self.root.destroy()


def main():
    try:
        root = tk.Tk()
    except tk.TclError as exc:
        raise SystemExit("Cannot open desktop display: {}. Run in a desktop terminal or use serial_packet.py over SSH.".format(exc))
    SerialConsole(root)
    root.mainloop()


if __name__ == "__main__":
    main()