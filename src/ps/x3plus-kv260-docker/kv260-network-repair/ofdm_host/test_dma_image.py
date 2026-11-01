import random
import socket
import struct
import threading
import tempfile
import unittest
import zlib
from pathlib import Path
from unittest.mock import patch

from dma_image import DATA, META, ImageReceiver, connect_board, download, loopback, packet, read_record, send_record, upload


class ImageTests(unittest.TestCase):
    def test_tcp_connection_nodelay_and_ab_override(self):
        with socket.socket() as listener:
            listener.bind(('127.0.0.1', 0))
            listener.listen()
            for nodelay in (True, False):
                with connect_board(listener.getsockname(), 2, nodelay=nodelay) as client:
                    peer, _ = listener.accept()
                    with peer:
                        self.assertEqual(client.getsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY), int(nodelay))
                        send_record(client, b'metadata')
                        self.assertEqual(read_record(peer), b'metadata')

    def test_out_of_order_duplicates_and_exact_length(self):
        for size in (1, 999, 1000, 1001, 64013):
            with self.subTest(size=size):
                rng = random.Random(size)
                data = bytes(rng.getrandbits(8) for _ in range(size))
                count = (size + 999) // 1000
                receiver = ImageReceiver()
                meta = packet(META, 10, 20, 0, count, size, struct.pack('<I', zlib.crc32(data)))
                receiver.accept(meta)
                order = list(range(count))
                random.Random(size).shuffle(order)
                result = None
                for i in order:
                    p = packet(DATA, 10, 20, i, count, size, data[i*1000:(i+1)*1000])
                    result = receiver.accept(p)
                    self.assertEqual(receiver.accept(p), result)
                self.assertEqual(result, data)

    def test_corruption_and_missing_metadata(self):
        p = packet(DATA, 1, 2, 0, 1, 3, b'bad')
        receiver = ImageReceiver()
        with self.assertRaises(ValueError):
            receiver.accept(p)
        receiver.accept(packet(META, 1, 2, 0, 1, 3, struct.pack('<I', zlib.crc32(b'yes'))))
        with self.assertRaisesRegex(ValueError, 'CRC'):
            receiver.accept(p)

    def test_fragmented_tcp_stream(self):
        a, b = socket.socketpair()
        body = packet(DATA, 1, 2, 0, 1, 3, b'abc')
        wire = struct.pack('<H', len(body)) + body
        def writer():
            with a:
                for byte in wire:
                    a.sendall(bytes([byte]))
        thread = threading.Thread(target=writer)
        thread.start()
        with b:
            self.assertEqual(read_record(b), body)
            with self.assertRaises(ConnectionError):
                read_record(b)
        thread.join()

    def test_upload_completion_and_failure(self):
        class StatusSocket:
            def __init__(self, records):
                self.received = bytearray(b''.join(struct.pack('<H', len(r)) + r for r in records))
                self.sent = bytearray()

            def sendall(self, data):
                self.sent.extend(data)

            def recv(self, size):
                data = bytes(self.received[:size])
                del self.received[:size]
                return data

        def status(code, session=10):
            return struct.pack('<2sBBIII', b'OS', 1, code, session, 20, 3)

        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'image.bin'
            path.write_bytes(b'abc')
            with patch('dma_image.secrets.randbits', side_effect=[10, 20]):
                sock = StatusSocket([status(5, 99), status(6, 99), status(6)])
                upload(sock, path)
                self.assertFalse(sock.received)
                self.assertTrue(sock.sent.endswith(b'abc'))
            with patch('dma_image.secrets.randbits', side_effect=[10, 20]):
                with self.assertRaisesRegex(RuntimeError, 'status=5'):
                    upload(StatusSocket([status(5)]), path)

    def test_invalid_and_conflicting_records(self):
        receiver = ImageReceiver()
        meta = packet(META, 1, 2, 0, 2, 1001, struct.pack('<I', 0))
        receiver.accept(meta)
        with self.assertRaisesRegex(ValueError, 'conflicting metadata'):
            receiver.accept(packet(META, 1, 2, 0, 2, 1001, struct.pack('<I', 1)))
        receiver.accept(packet(DATA, 1, 2, 0, 2, 1001, b'a' * 1000))
        with self.assertRaisesRegex(ValueError, 'conflicting duplicate'):
            receiver.accept(packet(DATA, 1, 2, 0, 2, 1001, b'b' * 1000))
        with self.assertRaises(ValueError):
            receiver.accept(packet(DATA, 1, 2, 1, 2, 1001, b'xx'))

    def test_download_ignores_unrelated_upload_failure(self):
        a, b = socket.socketpair()
        with tempfile.TemporaryDirectory() as directory, a, b:
            path = Path(directory) / 'received.bin'
            send_record(a, struct.pack('<2sBBIII', b'OS', 1, 5, 99, 20, 3))
            send_record(a, packet(META, 10, 20, 0, 1, 3, struct.pack('<I', zlib.crc32(b'abc'))))
            send_record(a, packet(DATA, 10, 20, 0, 1, 3, b'abc'))
            download(b, path)
            self.assertEqual(path.read_bytes(), b'abc')
            self.assertFalse(path.with_name(path.name + '.part').exists())

    def test_download_rejects_malformed_status_and_dma_fault(self):
        for record, exception in ((b'OS', ValueError),
                                  (struct.pack('<2sBBIII', b'OS', 2, 1, 0, 0, 0), ValueError),
                                  (struct.pack('<2sBBIII', b'OS', 1, 4, 0, 0, 0), RuntimeError)):
            with self.subTest(record=record):
                a, b = socket.socketpair()
                with a, b:
                    send_record(a, record)
                    with self.assertRaises(exception):
                        download(b, Path('/unused/received.bin'))

    def run_loopback(self, data, failure=None):
        # Tiny socket buffers force the host to read while uploading. A send-all,
        # then receive implementation deadlocks here for the large-image case.
        host, board = socket.socketpair()
        for sock in (host, board):
            sock.settimeout(3)
            sock.setsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF, 2048)
        errors = []

        def radio():
            try:
                with board:
                    meta = read_record(board)
                    if failure == 'disconnect':
                        return
                    if failure == 'status':
                        send_record(board, struct.pack('<2sBBIII', b'OS', 1, 5, 10, 20, 0))
                        return
                    # Ignore a stale transaction and accept status before data.
                    send_record(board, struct.pack('<2sBBIII', b'OS', 1, 5, 99, 20, 0))
                    send_record(board, meta)
                    for _ in range((len(data) + 999) // 1000):
                        record = read_record(board)
                        if failure == 'corrupt':
                            record = record[:-1] + bytes([record[-1] ^ 1])
                        send_record(board, record)
                    send_record(board, struct.pack('<2sBBIII', b'OS', 1, 6, 10, 20, len(data)))
                    send_record(board, struct.pack('<2sBBIII', b'OS', 1, 1, 10, 20, zlib.crc32(data)))
            except OSError as exc:
                if failure is None:
                    errors.append(exc)

        thread = threading.Thread(target=radio)
        thread.start()
        try:
            with tempfile.TemporaryDirectory() as directory, host:
                source = Path(directory) / 'source.bin'
                destination = Path(directory) / 'received.bin'
                source.write_bytes(data)
                destination.write_bytes(b'previous output')
                with patch('dma_image.secrets.randbits', side_effect=[10, 20]):
                    if failure:
                        with self.assertRaises((ValueError, RuntimeError, ConnectionError)):
                            loopback(host, source, destination)
                        self.assertEqual(destination.read_bytes(), b'previous output')
                    else:
                        loopback(host, source, destination)
                        self.assertEqual(destination.read_bytes(), data)
                self.assertFalse(destination.with_name(destination.name + '.part').exists())
        finally:
            thread.join(5)
        self.assertFalse(thread.is_alive())
        self.assertFalse(errors, errors)

    def test_single_board_full_duplex_loopback(self):
        for size in (1, 1000, 1001, 262013):
            with self.subTest(size=size):
                self.run_loopback(bytes(i % 251 for i in range(size)))

    def test_single_board_failure_preserves_output(self):
        for failure in ('disconnect', 'status', 'corrupt'):
            with self.subTest(failure=failure):
                self.run_loopback(b'abc', failure)

    def test_loopback_requires_returned_image(self):
        host, board = socket.socketpair()
        with tempfile.TemporaryDirectory() as directory, host, board:
            source = Path(directory) / 'source.bin'
            source.write_bytes(b'abc')
            for code, detail in ((6, 3), (1, zlib.crc32(b'abc'))):
                send_record(board, struct.pack('<2sBBIII', b'OS', 1, code, 10, 20, detail))
            board.shutdown(socket.SHUT_WR)
            with patch('dma_image.secrets.randbits', side_effect=[10, 20]):
                with self.assertRaises(ConnectionError):
                    loopback(host, source, Path(directory) / 'received.bin')


if __name__ == '__main__':
    unittest.main()
