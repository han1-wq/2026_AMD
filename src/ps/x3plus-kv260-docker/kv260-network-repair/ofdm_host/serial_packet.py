#!/usr/bin/env python3
"""Send a 64-byte OFDM packet over the UART1 binary protocol."""

import argparse
import math
import os
import sys
import time


DEFAULT_PORT = "auto"


def crc16(data):
    crc = 0xffff
    for byte in data:
        crc ^= byte << 8
        for _ in range(8):
            crc = ((crc << 1) ^ (0x1021 if crc & 0x8000 else 0)) & 0xffff
    return crc


def frame(payload, seq):
    if len(payload) != 64:
        raise ValueError("payload must be exactly 64 bytes")
    if not 0 <= seq <= 255:
        raise ValueError("seq must be 0..255")
    body = b"\xa5\x5a" + bytes([seq]) + payload
    return body + crc16(body).to_bytes(2, "little")


def receive(port, seq, timeout=2.0, stop=None):
    if not math.isfinite(timeout) or timeout <= 0:
        raise ValueError("timeout must be finite and positive")
    deadline = time.monotonic() + timeout
    data = bytearray()
    last_error = None
    while time.monotonic() < deadline:
        if stop is not None and stop.is_set():
            raise InterruptedError("Receive cancelled")
        chunk = port.read(1)
        if not chunk:
            time.sleep(0.001)
            continue
        data.extend(chunk)
        if len(data) == 1 and data[0] != 0x5a:
            data.clear()
        elif len(data) == 2 and data[1] != 0xa5:
            data[:] = b"\x5a" if data[1] == 0x5a else b""
        if len(data) < 73:
            continue
        if crc16(data[:-2]) != int.from_bytes(data[-2:], "little"):
            last_error = "response CRC error"
            # Slide to the next possible header, including one inside a corrupt
            # candidate; a false header must not consume a valid response.
            index = data.find(b"\x5a\xa5", 1)
            data[:] = data[index:] if index >= 0 else (b"\x5a" if data[-1] == 0x5a else b"")
            continue
        rest = data[2:]
        if rest[0] != seq:
            last_error = "response sequence mismatch"
            data.clear()
            continue
        return rest[1], rest[2], int.from_bytes(rest[3:5], "little"), bytes(rest[5:69])
    if last_error:
        raise ValueError(last_error)
    raise TimeoutError("response timeout" if len(data) < 2 else "incomplete response")


def positive_seconds(value):
    value = float(value)
    if not math.isfinite(value) or value <= 0:
        raise argparse.ArgumentTypeError("must be finite and positive")
    return value


def nonnegative_seconds(value):
    value = float(value)
    if not math.isfinite(value) or value < 0:
        raise argparse.ArgumentTypeError("must be finite and nonnegative")
    return value


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("port", nargs="?", default=DEFAULT_PORT,
                        help="UART1 serial port (115200 8N1; default: %(default)s)")
    parser.add_argument("--hex", help="128 hexadecimal characters; default random packet")
    parser.add_argument("--seq", type=int, default=0)
    parser.add_argument("--list", action="store_true", help="list serial devices without opening them")
    parser.add_argument("--detect", action="store_true", help="resolve the target without opening or transmitting")
    parser.add_argument("--serial-number", help="select an FT2232 by USB serial number")
    parser.add_argument("--location", help="select an FT2232 by USB location shown by --list")
    parser.add_argument("--wait", type=nonnegative_seconds, default=0, help="seconds to wait for device/open, default 0")
    parser.add_argument("--settle", type=nonnegative_seconds, default=1, help="delay after opening before sending, default 1 second")
    parser.add_argument("--timeout", type=positive_seconds, default=2, help="response deadline in seconds")
    args = parser.parse_args()
    if not 0 <= args.seq <= 255:
        parser.error("seq must be 0..255")
    if args.port != DEFAULT_PORT and (args.serial_number or args.location):
        parser.error("--serial-number/--location require automatic port selection")
    try:
        payload = bytes.fromhex(args.hex) if args.hex is not None else os.urandom(64)
    except ValueError:
        parser.error("--hex must contain valid hexadecimal bytes")
    if len(payload) != 64:
        parser.error("payload must be 64 bytes")
    try:
        import serial
        from serial_connection import SerialConnection
        from serial_devices import AmbiguousDevice, DeviceNotFound, discover
    except ImportError:
        parser.error("install pyserial: python3 -m pip install pyserial")
    connection = SerialConnection(args.port, args.serial_number, args.location)
    try:
        if args.list:
            for device in discover():
                print(("[FT2232 UART] " if device.is_target else "[other] ") + device.label)
            return
        deadline = time.monotonic() + args.wait
        while True:
            try:
                if args.detect:
                    print(connection.resolve().label if args.port == DEFAULT_PORT else args.port)
                    return
                print("Connected: " + connection.open(args.settle))
                break
            except AmbiguousDevice:
                raise
            except (DeviceNotFound, serial.SerialException, OSError):
                remaining = deadline - time.monotonic()
                if remaining <= 0:
                    raise
                time.sleep(min(0.5, remaining))
        time.sleep(max(0, connection.ready_at - time.monotonic()))
        connection.validate()
        port = connection.port
        port.reset_input_buffer()
        request = frame(payload, args.seq)
        if port.write(request) != len(request):
            raise IOError("Incomplete request write; request was not retried")
        status, flags, length, received = receive(port, args.seq, timeout=args.timeout)
    except (ValueError, OSError, serial.SerialException) as exc:
        print("ERROR: {} (no automatic packet retry)".format(exc), file=sys.stderr)
        sys.exit(2)
    except KeyboardInterrupt:
        sys.exit(130)
    finally:
        connection.close()
    print(f"status={status} flags=0x{flags:02x} rx_length={length}")
    print(f"tx={payload.hex()}\nrx={received.hex()}")
    if status or length != 64 or received != payload:
        sys.exit(1)


if __name__ == "__main__":
    main()