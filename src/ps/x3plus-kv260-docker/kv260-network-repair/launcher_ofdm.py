"""Bounded message transport over the existing OFDM loopback protocol."""
import codecs
import json
import os
from pathlib import Path
import queue
import secrets
import struct
import sys
import threading
import time

HOST = Path(os.environ.get('OFDM_HOST_DIR', str(Path.home() / 'ofdm-host')))
HEADER = struct.Struct('<2sBBIHHH')
CHUNK = 64 - HEADER.size
MAX_BYTES = 24000
KINDS = {'task': 1, 'log': 2, 'text': 3}


def fragments(data, message_id, kind):
    if not isinstance(data, bytes) or not 0 < len(data) <= MAX_BYTES:
        raise ValueError('Message must contain 1..24000 UTF-8 bytes')
    count = (len(data) + CHUNK - 1) // CHUNK
    for index in range(count):
        part = data[index * CHUNK:(index + 1) * CHUNK]
        yield HEADER.pack(b'KV', 1, KINDS[kind], message_id, index, count,
                          len(part)) + part.ljust(CHUNK, b'\0')


def encode_message(kind, action, content):
    return json.dumps({'version': 1, 'kind': kind, 'action': action,
                       'timestamp': time.time(), 'content': content},
                      ensure_ascii=False, separators=(',', ':')).encode('utf-8')


class LogCursor:
    """Tail only new bytes; reset on rotation and never accumulate a backlog."""
    def __init__(self):
        self.identity = None
        self.offset = 0
        self.decoder = codecs.getincrementaldecoder('utf-8')(errors='replace')
        self.skipped = 0

    def read(self, path, baseline=False):
        try:
            with path.open('rb') as stream:
                stat = os.fstat(stream.fileno())
                identity = (str(path), stat.st_dev, stat.st_ino)
                if identity != self.identity or stat.st_size < self.offset:
                    self.identity, self.offset = identity, 0
                    baseline = True
                if baseline:
                    self.offset = stat.st_size
                    self.decoder.reset()
                    return b''
                start = max(self.offset, stat.st_size - 2048)
                self.skipped = start - self.offset
                if self.skipped:
                    self.decoder.reset()
                stream.seek(start)
                data = stream.read(2048)
                self.offset = stream.tell()
                return data
        except OSError:
            return b''

    def read_text(self, path):
        data = self.read(path)
        if self.skipped:
            # A sampled tail can start in the middle of a UTF-8 code point.
            data = data.lstrip(bytes(range(128, 192)))
        return self.decoder.decode(data, final=False)


def make_worker():
    # Dependencies are optional for the robot dashboard; no import opens UART.
    sys.path.insert(0, str(HOST))
    import serial
    from serial_connection import SerialConnection
    import serial_packet
    from serial_worker import SerialWorker

    class MessageWorker(SerialWorker):
        def __init__(self):
            super().__init__(queue.Queue(maxsize=8), queue.Queue(maxsize=256))
            self.controls = queue.Queue(maxsize=4)
            self.cancel = threading.Event()
            self.ready = threading.Event()
            self.dropped_events = 0

        def emit(self, kind, value):
            if kind == 'connected':
                self.ready.set() if value else self.ready.clear()
            try:
                self.events.put_nowait((kind, value))
            except queue.Full:
                try:
                    self.events.get_nowait()
                    self.dropped_events += 1
                except queue.Empty:
                    pass
                self.events.put_nowait((kind, value))

        def submit(self, data, kind):
            if not self.ready.is_set() or self.cancel.is_set():
                raise ValueError('OFDM is not ready')
            ident = secrets.randbits(32)
            message = (ident, kind, tuple(fragments(data, ident, kind)))
            self.commands.put_nowait(message)
            return message[0]

        def control(self, command, options=None):
            self.controls.put_nowait((command, options))
            self.cancel.set()
            self.ready.clear()

        def transaction(self, payload):
            if self.connection is None or self.connection.port is None or not self.announced_ready:
                raise ValueError('Serial port is not ready')
            self.connection.validate()
            port = self.connection.port
            seq = self.seq
            self.seq = (seq + 1) & 255
            request = serial_packet.frame(payload, seq)
            port.reset_input_buffer()
            start = time.monotonic()
            if port.write(request) != len(request):
                raise OSError('Incomplete request write')
            status, flags, length, returned = serial_packet.receive(port, seq, timeout=2, stop=self.cancel)
            detail = dict(seq=seq, result=status, flags=flags, length=length,
                          latency_ms=round((time.monotonic() - start) * 1000, 1))
            passed = status == 0 and flags == 3 and length == 64 and returned == payload
            if not passed:
                detail['error'] = 'result/flags/length/content validation failed'
            return passed, detail

        def send_message(self, message):
            ident, kind, packets = message
            verified = 0
            start = time.monotonic()
            detail = {}
            try:
                for index, payload in enumerate(packets):
                    if self.cancel.is_set() or self.stop.is_set():
                        raise InterruptedError('Message cancelled')
                    passed, detail = self.transaction(payload)
                    verified += int(passed)
                    self.emit('progress', dict(id=ident, kind=kind, fragment=index + 1,
                              total=len(packets), verified=verified, **detail))
                    if not passed:
                        break
                    if index + 1 < len(packets) and self.cancel.wait(.05):
                        raise InterruptedError('Message cancelled')
            except (ValueError, OSError, serial.SerialException) as exc:
                detail = {'error': str(exc)}
                if isinstance(exc, (OSError, serial.SerialException)) and not isinstance(exc, TimeoutError) and not self.cancel.is_set():
                    self.lost(exc)
            self.emit('message', dict(id=ident, kind=kind, total=len(packets), verified=verified,
                      passed=verified == len(packets), elapsed_ms=round((time.monotonic()-start)*1000, 1),
                      **detail))

        def discard(self):
            while True:
                try:
                    ident, kind, packets = self.commands.get_nowait()
                    self.emit('message', dict(id=ident, kind=kind, total=len(packets), verified=0,
                              passed=False, error='Cancelled before transmission'))
                except queue.Empty:
                    return

        def run(self):
            try:
                while not self.stop.is_set():
                    try:
                        command, options = self.controls.get_nowait()
                    except queue.Empty:
                        command = None
                    if command:
                        self.discard()
                        self.disconnect()
                        self.cancel.clear()
                        if command == 'connect':
                            self.connection = SerialConnection(target='auto', **(options or {}))
                            self.next_scan = 0
                            self.announced_ready = False
                            self.emit('active', True)
                    self.maintain()
                    if self.ready.is_set() and not self.cancel.is_set():
                        try:
                            self.send_message(self.commands.get_nowait())
                        except queue.Empty:
                            pass
                    else:
                        self.discard()
                    self.stop.wait(.05)
            finally:
                self.discard()
                self.disconnect()

    return MessageWorker()