"""Reconnectable serial worker, independent of the desktop UI."""

import queue
import threading
import time

import serial

from serial_connection import SerialConnection
from serial_packet import frame, receive


RESULTS = {
    0: "Verified pass", 1: "PL failure", 2: "UART CRC error",
    3: "Mailbox busy", 4: "PS wait timeout",
}
FLAGS = ("Verified pass", "FCS OK", "Data/length mismatch", "TX error", "PL timeout")


class SerialWorker(threading.Thread):
    def __init__(self, commands, events):
        super().__init__(daemon=True)
        self.commands = commands
        self.events = events
        self.stop = threading.Event()
        self.connection = None
        self.seq = 0
        self.next_scan = 0.0
        self.last_notice = None
        self.announced_ready = False

    def emit(self, kind, value):
        self.events.put((kind, value))

    def notice(self, text):
        self.emit("status", text)
        if text != self.last_notice:
            self.emit("log", text + "\n")
            self.last_notice = text

    def disconnect(self):
        if self.connection is not None:
            self.connection.close()
        self.connection = None
        self.emit("connected", False)
        self.emit("active", False)
        self.notice("Disconnected")

    def lost(self, exc):
        if self.connection is not None:
            self.connection.close()
        self.announced_ready = False
        self.emit("connected", False)
        self.notice("Waiting/reconnecting: {}".format(exc))
        self.next_scan = time.monotonic() + 1.0

    def maintain(self):
        if self.connection is None:
            return
        now = time.monotonic()
        if now >= self.next_scan:
            self.next_scan = now + 1.0
            try:
                if self.connection.port is None:
                    label = self.connection.open()
                    self.announced_ready = False
                    self.notice("Connected; settling for 1 s: " + label)
                else:
                    self.connection.validate()
            except (ValueError, serial.SerialException, OSError) as exc:
                self.lost(exc)
                return
        if self.connection.port is not None:
            try:
                port = self.connection.port
                data = port.read(min(port.in_waiting or 1, 4096))
                if data:
                    self.emit("log", data.decode("utf-8", errors="replace"))
                if not self.announced_ready and time.monotonic() >= self.connection.ready_at:
                    self.announced_ready = True
                    self.emit("connected", True)
                    self.notice("Connected: " + port.port)
            except (serial.SerialException, OSError) as exc:
                self.lost(exc)

    def send(self, payload):
        if self.connection is None or self.connection.port is None or not self.announced_ready:
            raise ValueError("Serial port is not ready")
        try:
            self.connection.validate()
        except (ValueError, serial.SerialException, OSError) as exc:
            self.lost(exc)
            raise ValueError("Device changed before transmission; packet was not sent") from exc
        port = self.connection.port
        seq = self.seq
        self.seq = (self.seq + 1) & 0xff
        request = frame(payload, seq)
        port.reset_input_buffer()
        self.emit("log", "TX seq={} payload={}\n".format(seq, payload.hex()))
        if port.write(request) != len(request):
            raise IOError("Incomplete request write")
        status, flags, length, received = receive(port, seq, timeout=2.0, stop=self.stop)
        passed = status == 0 and length == 64 and received == payload
        detail = ", ".join(name for bit, name in enumerate(FLAGS) if flags & (1 << bit))
        self.emit("result", "PASS" if passed else "FAIL")
        self.emit("log", "RX seq={} result={} ({}) flags=0x{:02x} [{}] length={}\n"
                  "RX payload={}\n".format(seq, status, RESULTS.get(status, "Unknown"),
                                            flags, detail, length, received.hex()))

    def run(self):
        try:
            while not self.stop.is_set():
                try:
                    command, value = self.commands.get(timeout=0.05)
                except queue.Empty:
                    self.maintain()
                    continue
                try:
                    if command == "connect":
                        self.disconnect()
                        self.connection = SerialConnection(**value)
                        self.next_scan = 0
                        self.announced_ready = False
                        self.emit("active", True)
                        self.maintain()
                    elif command == "disconnect":
                        self.disconnect()
                    elif command == "send":
                        self.send(value)
                except (TimeoutError, ValueError) as exc:
                    self.emit("error", "{}; packet was not automatically retried".format(exc))
                except (serial.SerialException, OSError) as exc:
                    self.emit("error", "{}; packet was not automatically retried".format(exc))
                    self.lost(exc)
                finally:
                    self.emit("idle", None)
        finally:
            self.disconnect()