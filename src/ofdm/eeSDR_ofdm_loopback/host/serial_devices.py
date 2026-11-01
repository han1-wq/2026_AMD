"""Discover FT2232 interface 1 without relying on tty numbering (Linux)."""

import re
from dataclasses import dataclass
from pathlib import Path

from serial.tools import list_ports


AUTO_PORT = "auto"
FT2232_ID = (0x0403, 0x6010)


class DeviceNotFound(ValueError):
    pass


class AmbiguousDevice(ValueError):
    pass


@dataclass(frozen=True)
class SerialDevice:
    device: str
    vid: object
    pid: object
    serial_number: str
    location: str
    interface_number: object
    description: str

    @property
    def is_target(self):
        return (self.vid, self.pid) == FT2232_ID and self.interface_number == 1

    @property
    def label(self):
        usb_id = "{:04x}:{:04x}".format(self.vid, self.pid) if self.vid is not None and self.pid is not None else "unknown"
        return "{} | {} interface={} serial={} location={} | {}".format(
            self.device, usb_id, self.interface_number,
            self.serial_number or "-", self.location or "-", self.description)


def interface_number(port):
    # USB interface strings are manufacturer-defined and often identical on
    # both FT2232 channels. Read the actual USB descriptor instead.
    interface_path = getattr(port, "usb_interface_path", None)
    paths = [Path(interface_path)] if interface_path else []
    device_path = Path("/sys/class/tty") / Path(port.device).name / "device"
    resolved = device_path.resolve()
    paths.extend([resolved] + list(resolved.parents))
    for path in paths:
        try:
            return int((path / "bInterfaceNumber").read_text().strip(), 16)
        except (OSError, ValueError):
            continue
    # pyserial on Linux encodes bus-port:configuration.interface here.
    match = re.search(r":\d+\.(\d+)$", getattr(port, "location", "") or "")
    return int(match.group(1)) if match else None


def discover():
    devices = []
    for port in list_ports.comports():
        devices.append(SerialDevice(
            port.device, port.vid, port.pid, port.serial_number or "",
            port.location or "", interface_number(port), port.description or ""))
    return sorted(devices, key=lambda item: item.device)


def select_device(devices, serial_number=None, location=None):
    candidates = [item for item in devices if item.is_target
                  and (not serial_number or item.serial_number == serial_number)
                  and (not location or item.location == location)]
    if not candidates:
        raise DeviceNotFound("Waiting for FT2232 0403:6010 interface 1"
                             + (" serial=" + serial_number if serial_number else "")
                             + (" location=" + location if location else ""))
    if len(candidates) != 1:
        raise AmbiguousDevice("Multiple FT2232 interface 1 devices; select a serial number/USB location: "
                              + "; ".join(item.label for item in candidates))
    return candidates[0]


def resolve_device(serial_number=None, location=None):
    return select_device(discover(), serial_number, location)