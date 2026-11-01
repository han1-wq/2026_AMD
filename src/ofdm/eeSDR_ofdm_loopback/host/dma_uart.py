#!/usr/bin/env python3
"""Verify single-board TX/RX loopback through the DMA UART protocol."""
import argparse
import os
import secrets
import struct
import time

from dma_image import decode, packet
from serial_packet import nonnegative_seconds, positive_seconds


def loopback(port, payload, timeout=5.0):
    if not 1 <= len(payload) <= 1000:
        raise ValueError('UART payload must be 1 through 1000 bytes')
    session, message = secrets.randbits(32), secrets.randbits(32)
    body = packet(1, session, message, 0, 1, len(payload), payload)
    request = b'\xa5\x5a' + struct.pack('<H', len(body)) + body
    start = time.monotonic()
    if port.write(request) != len(request):
        raise OSError('incomplete UART request write')
    buffer = bytearray()
    accepted = False
    returned = None
    while time.monotonic() - start < timeout:
        buffer.extend(port.read(1028))
        while buffer:
            pos = buffer.find(b'\x5a\xa5')
            if pos < 0:
                buffer[:] = b'\x5a' if buffer[-1] == 0x5a else b''
                break
            del buffer[:pos]
            if len(buffer) < 4:
                break
            length, = struct.unpack_from('<H', buffer, 2)
            if length != 1 and not 25 <= length <= 1024:
                del buffer[0]
                continue
            if len(buffer) < length + 4:
                break
            record = bytes(buffer[4:4 + length])
            del buffer[:4 + length]
            if length == 1:
                if record[0] != 0:
                    raise RuntimeError(f'UART enqueue failed: status={record[0]} (1 busy, 2 invalid)')
                accepted = True
            else:
                kind, channel, sid, mid, index, count, total, received = decode(record)
                if (kind, channel, sid, mid) != (1, 0, session, message):
                    continue
                if index or count != 1 or total != len(payload) or received != payload:
                    raise ValueError('UART loopback data differs from input')
                returned = received
            if accepted and returned is not None:
                return returned
    raise TimeoutError('UART loopback timeout: matching RX data and enqueue acceptance required')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('port', nargs='?', default='auto')
    parser.add_argument('--hex', help='1..1000 payload bytes in hexadecimal; default random 64 bytes')
    parser.add_argument('--timeout', type=positive_seconds, default=5.0)
    parser.add_argument('--settle', type=nonnegative_seconds, default=1.0)
    args = parser.parse_args()
    try:
        payload = bytes.fromhex(args.hex) if args.hex is not None else os.urandom(64)
        if not 1 <= len(payload) <= 1000:
            raise ValueError('UART payload must be 1 through 1000 bytes')
    except ValueError as exc:
        parser.error(str(exc))
    from serial_connection import SerialConnection
    connection = SerialConnection(args.port)
    try:
        print('Connected: ' + connection.open(args.settle))
        time.sleep(max(0, connection.ready_at - time.monotonic()))
        connection.validate()
        connection.port.reset_input_buffer()
        start = time.monotonic()
        received = loopback(connection.port, payload, args.timeout)
        print(f'UART LOOPBACK PASS: {len(received)} bytes, {time.monotonic() - start:.3f}s')
        print(f'tx={payload.hex()}\nrx={received.hex()}')
    except (OSError, ValueError, RuntimeError) as exc:
        parser.exit(1, f'{exc}\n')
    finally:
        connection.close()


if __name__ == '__main__':
    main()
