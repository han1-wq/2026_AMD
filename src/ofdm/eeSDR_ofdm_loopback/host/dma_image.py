#!/usr/bin/env python3
"""TCP image client for the SG-DMA firmware (standard library only)."""
import argparse
import hashlib
import math
import os
from pathlib import Path
import secrets
import socket
import struct
import threading
import time
import zlib

HEADER = struct.Struct('<2sBBBBIIHHHI')
MAX_IMAGE = 16 * 1024 * 1024
META, DATA = 2, 3
COUNTER_NAMES = ('tx_submitted', 'tx_completed', 'tx_rejected', 'tx_failed',
                 'rx_accepted', 'rx_dropped', 'rx_overflow', 'rx_timeout',
                 'link_retries', 'link_failures')


def connect_board(address, timeout, *, nodelay=True):
    sock = socket.create_connection(address, timeout=timeout)
    try:
        sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, int(nodelay))
    except OSError:
        sock.close()
        raise
    return sock


def packet(kind, session, message, index, count, total, payload, channel=0):
    return HEADER.pack(b'OF', 1, kind, 0, channel, session, message,
                       index, count, len(payload), total) + payload


def decode(data):
    if len(data) < HEADER.size:
        raise ValueError('short wireless packet')
    magic, version, kind, flags, channel, session, message, index, count, size, total = HEADER.unpack_from(data)
    if (magic != b'OF' or version != 1 or flags or kind not in (1, 2, 3, 4)
            or len(data) != 24 + size or size > 1000 or not count or index >= count
            or total > MAX_IMAGE):
        raise ValueError('invalid wireless packet')
    return kind, channel, session, message, index, count, total, data[24:]


def send_record(sock, data):
    sock.sendall(struct.pack('<H', len(data)) + data)


def read_exact(sock, length):
    chunks = bytearray()
    while len(chunks) < length:
        block = sock.recv(length - len(chunks))
        if not block:
            raise ConnectionError('board closed connection')
        chunks.extend(block)
    return bytes(chunks)


def read_record(sock):
    length, = struct.unpack('<H', read_exact(sock, 2))
    if not 1 <= length <= 1024:
        raise ValueError(f'invalid TCP record length: {length}')
    return read_exact(sock, length)


class ImageReceiver:
    def __init__(self):
        self.key = None
        self.data = None
        self.seen = set()
        self.crc = None
        self.count = 0

    def accept(self, record):
        kind, channel, session, message, index, count, total, payload = decode(record)
        key = channel, session, message
        if kind == META:
            if len(payload) != 4 or not total or count != (total + 999) // 1000 or index:
                raise ValueError('invalid image metadata')
            crc, = struct.unpack('<I', payload)
            if self.key == key:
                if self.crc != crc or len(self.data) != total or self.count != count:
                    raise ValueError('conflicting metadata')
                return None
            self.key, self.crc, self.count = key, crc, count
            self.data = bytearray(total)
            self.seen.clear()
        elif kind == DATA:
            if key != self.key:
                raise ValueError('image data arrived without metadata')
            expected = min(1000, total - index * 1000)
            if total != len(self.data) or count != self.count or len(payload) != expected:
                raise ValueError('invalid image fragment')
            offset = index * 1000
            if index in self.seen and self.data[offset:offset + len(payload)] != payload:
                raise ValueError('conflicting duplicate fragment')
            self.data[offset:offset + len(payload)] = payload
            self.seen.add(index)
            if len(self.seen) == count:
                if zlib.crc32(self.data) != self.crc:
                    raise ValueError('whole-image CRC mismatch')
                return bytes(self.data)
        return None


def upload(sock, path):
    data = path.read_bytes()
    if not 1 <= len(data) <= MAX_IMAGE:
        raise ValueError('image size must be 1 byte through 16 MiB')
    session, message = secrets.randbits(32), secrets.randbits(32)
    count = (len(data) + 999) // 1000
    send_record(sock, packet(META, session, message, 0, count, len(data),
                             struct.pack('<I', zlib.crc32(data))))
    for index in range(count):
        send_record(sock, packet(DATA, session, message, index, count, len(data),
                                 data[index * 1000:(index + 1) * 1000]))
    # End-to-end completion is reported by the receiving host, not sendall().
    print(f'Uploaded {len(data)} bytes to TCP; session={session:08x} image={message:08x}', flush=True)
    print('Waiting for remote acceptance; keep the receiver connected.', flush=True)
    while True:
        record = read_record(sock)
        if record[:2] == b'OS':
            if len(record) != 16 or record[2] != 1:
                raise ValueError('invalid board status')
            code = record[3]
            status_session, status_message, detail = struct.unpack_from('<III', record, 4)
            matches = (status_session, status_message) == (session, message)
            if code == 4 or (code == 3 and (status_session, status_message) == (0, 0)) or (code in (3, 5) and matches):
                raise RuntimeError(f'board transfer failure: status={code}')
            if code == 6 and matches and detail == len(data):
                print('Wireless send window drained (each fragment acknowledged).')
                return


def download(sock, path):
    receiver = ImageReceiver()
    start = time.monotonic()
    while True:
        record = read_record(sock)
        if record[:2] == b'OS':
            if len(record) != 16 or record[2] != 1:
                raise ValueError('invalid board status')
            session, message, _ = struct.unpack_from('<III', record, 4)
            if record[3] == 4 or (record[3] == 2 and receiver.key is not None and receiver.key[1:] == (session, message)):
                raise RuntimeError(f'board transfer failure: status={record[3]}')
            continue
        result = receiver.accept(record)
        if result is not None:
            temporary = path.with_name(path.name + '.part')
            temporary.write_bytes(result)
            os.replace(temporary, path)
            elapsed = time.monotonic() - start
            print(f'Saved {len(result)} bytes, CRC32={zlib.crc32(result):08x}, {elapsed:.3f}s')
            # Give TCP time to ACK the final output before closing the socket.
            return


def loopback(sock, source, destination):
    """Send and receive on the board's single TCP connection concurrently."""
    if source.resolve() == destination.resolve():
        raise ValueError('input and output paths must differ')
    data = source.read_bytes()
    if not 1 <= len(data) <= MAX_IMAGE:
        raise ValueError('image size must be 1 byte through 16 MiB')
    session, message = secrets.randbits(32), secrets.randbits(32)
    count = (len(data) + 999) // 1000
    crc = zlib.crc32(data)
    errors = []

    def send():
        try:
            send_record(sock, packet(META, session, message, 0, count, len(data),
                                     struct.pack('<I', crc)))
            for index in range(count):
                send_record(sock, packet(DATA, session, message, index, count, len(data),
                                         data[index * 1000:(index + 1) * 1000]))
        except Exception as exc:
            errors.append(exc)
            try:
                sock.shutdown(socket.SHUT_RDWR)
            except OSError:
                pass

    receiver = ImageReceiver()
    result = None
    verified = acknowledged = False
    start = time.monotonic()
    sender = threading.Thread(target=send, name='image-upload')
    sender.start()
    try:
        while result is None or not verified or not acknowledged:
            record = read_record(sock)
            if record[:2] == b'OS':
                if len(record) != 16 or record[2] != 1:
                    raise ValueError('invalid board status')
                code = record[3]
                sid, mid, detail = struct.unpack_from('<III', record, 4)
                matches = (sid, mid) == (session, message)
                if code == 4 or (code == 3 and (sid, mid) == (0, 0)) or (matches and code in (2, 3, 5)):
                    raise RuntimeError(f'board transfer failure: status={code}')
                if matches and code == 1:
                    if detail != crc:
                        raise ValueError('board CRC mismatch')
                    verified = True
                if matches and code == 6:
                    if detail != len(data):
                        raise ValueError('board upload length mismatch')
                    acknowledged = True
                continue
            kind, channel, sid, mid, *_ = decode(record)
            if (channel, sid, mid) != (0, session, message):
                continue
            if kind not in (META, DATA):
                raise ValueError('unexpected loopback packet type')
            received = receiver.accept(record)
            if received is not None:
                if received != data:
                    raise ValueError('loopback data differs from input')
                result = received
    except BaseException:
        try:
            sock.shutdown(socket.SHUT_RDWR)
        except OSError:
            pass
        raise
    finally:
        sender.join()
    if errors:
        raise errors[0]
    temporary = destination.with_name(destination.name + '.part')
    temporary.write_bytes(result)
    os.replace(temporary, destination)
    elapsed = time.monotonic() - start
    print(f'LOOPBACK PASS: {len(result)} bytes, CRC32={crc:08x}, {elapsed:.3f}s')
    print(f'SHA256={hashlib.sha256(result).hexdigest()}\nSaved {destination}')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=('loopback', 'send', 'receive'))
    parser.add_argument('board')
    parser.add_argument('file', type=Path)
    parser.add_argument('--output', type=Path, help='received file for single-board loopback')
    parser.add_argument('--port', type=int, default=5001)
    parser.add_argument('--timeout', type=float, default=120)
    args = parser.parse_args()
    if not math.isfinite(args.timeout) or args.timeout <= 0:
        parser.error('--timeout must be finite and positive')
    if (args.action == 'loopback') != (args.output is not None):
        parser.error('--output is required only for loopback')
    try:
        with connect_board((args.board, args.port), args.timeout) as sock:
            if args.action == 'loopback':
                loopback(sock, args.file, args.output)
            else:
                (upload if args.action == 'send' else download)(sock, args.file)
    except (OSError, ValueError, RuntimeError) as exc:
        parser.exit(1, f'{exc}\n')


if __name__ == '__main__':
    main()
