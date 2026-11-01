"""Shared serial opening and identity checks for the GUI and CLI."""

import os
import time

import serial

from serial_devices import AUTO_PORT, resolve_device


class SerialConnection:
    def __init__(self, target=AUTO_PORT, serial_number=None, location=None):
        self.target = target
        self.serial_number = serial_number
        self.location = location
        self.port = None
        self.device = None
        self.ready_at = 0.0

    def resolve(self):
        return resolve_device(self.serial_number, self.location)

    def open(self, settle=1.0):
        self.close()
        device = self.resolve() if self.target == AUTO_PORT else None
        path = device.device if device else self.target
        port = serial.Serial(
            port=None, baudrate=115200, bytesize=8, parity="N", stopbits=1,
            timeout=0.05, write_timeout=1, xonxoff=False, rtscts=False,
            dsrdtr=False, exclusive=True if os.name == "posix" else None)
        # Set these before open to avoid deliberately asserting board reset lines.
        port.dtr = False
        port.rts = False
        port.port = path
        try:
            port.open()
            if device is not None and self.resolve() != device:
                raise serial.SerialException("USB device changed while opening; retrying discovery")
        except Exception:
            port.close()
            raise
        self.port = port
        self.device = device
        self.ready_at = time.monotonic() + settle
        return device.label if device else path

    def validate(self):
        if self.port is None:
            raise serial.SerialException("Serial port is not connected")
        if self.device is not None and self.resolve() != self.device:
            raise serial.SerialException("FT2232 identity/path changed; reconnecting")

    def close(self):
        port, self.port = self.port, None
        self.device = None
        if port is not None:
            try:
                port.close()
            except (serial.SerialException, OSError):
                pass