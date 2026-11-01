"""OFDM adapter regression tests without robot or physical UART access."""
import json
import os
from pathlib import Path
import queue
import tempfile
import select
import threading
import time
import unittest
from unittest.mock import Mock, patch

import launcher_ofdm as ofdm


class FragmentTests(unittest.TestCase):
    def test_utf8_reassembly(self):
        data = ('任务日志 abc\n' * 400).encode('utf-8')
        packets = list(ofdm.fragments(data, 123, 'log'))
        restored = bytearray()
        for index, packet in enumerate(packets):
            self.assertEqual(len(packet), 64)
            magic, version, kind, ident, pos, count, length = ofdm.HEADER.unpack_from(packet)
            self.assertEqual((magic, version, kind, ident, pos, count),
                             (b'KV', 1, 2, 123, index, len(packets)))
            restored.extend(packet[ofdm.HEADER.size:ofdm.HEADER.size + length])
            self.assertEqual(packet[ofdm.HEADER.size + length:], bytes(ofdm.CHUNK-length))
        self.assertEqual(bytes(restored), data)
        self.assertEqual(restored.decode('utf-8'), data.decode('utf-8'))

    def test_boundary_lengths(self):
        for length in (1, ofdm.CHUNK-1, ofdm.CHUNK, ofdm.CHUNK+1, ofdm.MAX_BYTES):
            with self.subTest(length=length):
                packets = list(ofdm.fragments(b'x' * length, 1, 'text'))
                self.assertEqual(len(packets), (length + ofdm.CHUNK-1)//ofdm.CHUNK)
                self.assertEqual(sum(ofdm.HEADER.unpack_from(p)[-1] for p in packets), length)

    def test_invalid_size(self):
        for data in (b'', b'x' * (ofdm.MAX_BYTES+1), 'not bytes'):
            with self.assertRaises(ValueError):
                list(ofdm.fragments(data, 1, 'text'))

    def test_json_metadata(self):
        data = ofdm.encode_message('task', 'save', {'message': '完成'})
        parsed = json.loads(data)
        self.assertEqual(parsed['kind'], 'task')
        self.assertEqual(parsed['action'], 'save')
        self.assertEqual(parsed['content'], {'message': '完成'})


class CursorTests(unittest.TestCase):
    def test_utf8_split_across_log_reads(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder)/'task.log'
            path.write_bytes(b'')
            cursor = ofdm.LogCursor()
            cursor.read(path)
            data = '任务'.encode('utf-8')
            path.write_bytes(data[:2])
            self.assertEqual(cursor.read_text(path), '')
            with path.open('ab') as stream:
                stream.write(data[2:])
            self.assertEqual(cursor.read_text(path), '任务')

    def test_baseline_increment_and_rotation(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder)/'task.log'
            path.write_bytes(b'old')
            cursor = ofdm.LogCursor()
            self.assertEqual(cursor.read(path), b'')
            with path.open('ab') as stream:
                stream.write(b'new')
            self.assertEqual(cursor.read(path), b'new')
            self.assertEqual(cursor.read(path), b'')
            path.rename(path.with_suffix('.log.1'))
            path.write_bytes(b'rotated')
            self.assertEqual(cursor.read(path), b'')
            path.write_bytes(b'rotated-more')
            self.assertEqual(cursor.read(path), b'-more')
            path.write_bytes(b'x')
            self.assertEqual(cursor.read(path), b'')

    def test_tail_bounded_and_missing(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder)/'task.log'
            cursor = ofdm.LogCursor()
            self.assertEqual(cursor.read(path), b'')
            path.write_bytes(b'')
            cursor.read(path)
            path.write_bytes(b'x'*10000)
            self.assertEqual(len(cursor.read(path)), 2048)
            self.assertEqual(cursor.offset, 10000)


class WorkerTests(unittest.TestCase):
    def setUp(self):
        self.worker = ofdm.make_worker()
        self.conn = Mock()
        self.worker.connection = self.conn
        self.worker.announced_ready = True
        self.worker.ready.set()
        self.conn.port.write.side_effect = lambda request: len(request)

    def events(self, kind):
        result = []
        while not self.worker.events.empty():
            event, value = self.worker.events.get_nowait()
            if event == kind:
                result.append(value)
        return result

    def test_submit_ids_match_all_fragments(self):
        ident = self.worker.submit(b'x'*101, 'log')
        message = self.worker.commands.get_nowait()
        self.assertEqual(ident, message[0])
        self.assertEqual(len(message[2]), 3)
        self.assertTrue(all(ofdm.HEADER.unpack_from(p)[3] == ident for p in message[2]))

    def test_submission_rejects_not_connected(self):
        self.worker.ready.clear()
        with self.assertRaises(ValueError):
            self.worker.submit(b'x', 'text')

    def test_queue_overflow_is_nonblocking(self):
        for _ in range(8):
            self.worker.submit(b'x', 'text')
        with self.assertRaises(queue.Full):
            self.worker.submit(b'x', 'text')

    def test_event_overflow_is_bounded(self):
        for i in range(1000):
            self.worker.emit('log', i)
        self.assertEqual(self.worker.events.qsize(), 256)
        self.assertEqual(self.worker.dropped_events, 744)
        self.worker.emit('message', {'passed': False})
        self.assertEqual(self.events('message'), [{'passed': False}])

    def test_control_cancels_and_discards(self):
        self.worker.submit(b'hello', 'text')
        self.worker.control('disconnect')
        self.assertTrue(self.worker.cancel.is_set())
        self.assertFalse(self.worker.ready.is_set())
        self.worker.discard()
        self.assertEqual(self.events('message')[0]['verified'], 0)
        self.conn.port.write.assert_not_called()

    def test_transaction_pass_and_sequence_wrap(self):
        payload = bytes(range(64))
        self.worker.seq = 255
        with patch('serial_packet.receive', return_value=(0, 3, 64, payload)) as receive:
            passed, detail = self.worker.transaction(payload)
        self.assertTrue(passed)
        self.assertEqual(detail['seq'], 255)
        self.assertEqual(self.worker.seq, 0)
        self.assertEqual(receive.call_args.args[1], 255)

    def test_negative_response_is_never_pass(self):
        payload = bytes(64)
        for response in ((1, 3, 64, payload), (2, 3, 64, payload),
                         (3, 3, 64, payload), (4, 3, 64, payload),
                         (0, 1, 64, payload), (0, 7, 64, payload),
                         (0, 3, 63, payload), (0, 3, 64, bytes([1])*64)):
            with self.subTest(response=response[:3]):
                with patch('serial_packet.receive', return_value=response):
                    passed, detail = self.worker.transaction(payload)
                self.assertFalse(passed)
                self.assertIn('validation', detail['error'])

    def test_identity_changed_prevents_write(self):
        self.conn.validate.side_effect = ValueError('identity changed')
        with self.assertRaises(ValueError):
            self.worker.transaction(bytes(64))
        self.conn.port.write.assert_not_called()

    def test_short_write(self):
        self.conn.port.write.side_effect = lambda request: 1
        with self.assertRaisesRegex(OSError, 'Incomplete'):
            self.worker.transaction(bytes(64))

    def test_complete_message(self):
        self.worker.submit(b'x'*123, 'log')
        message = self.worker.commands.get_nowait()
        with patch.object(self.worker, 'transaction', return_value=(True, {'seq': 1})):
            self.worker.send_message(message)
        result = self.events('message')[0]
        self.assertTrue(result['passed'])
        self.assertEqual(result['verified'], 3)

    def test_failure_stops_at_first_bad_fragment(self):
        self.worker.submit(b'x'*150, 'text')
        message = self.worker.commands.get_nowait()
        with patch.object(self.worker, 'transaction', side_effect=[(True, {}),
                         (False, {'error': 'mismatch'})]) as send:
            self.worker.send_message(message)
        result = self.events('message')[0]
        self.assertFalse(result['passed'])
        self.assertEqual(result['verified'], 1)
        self.assertEqual(send.call_count, 2)

    def test_protocol_errors_are_aggregate_failures(self):
        for error in (TimeoutError('timeout'), ValueError('response CRC error'),
                      ValueError('response sequence mismatch'), OSError('disconnect')):
            with self.subTest(error=error):
                message = (1, 'text', tuple(ofdm.fragments(b'abc', 1, 'text')))
                with patch.object(self.worker, 'transaction', side_effect=error) as send:
                    self.worker.send_message(message)
                result = self.events('message')[0]
                self.assertFalse(result['passed'])
                self.assertEqual(result['verified'], 0)
                self.assertIn(str(error), result['error'])
                self.assertEqual(send.call_count, 1)

    def test_cancel_mid_message(self):
        message = (1, 'text', tuple(ofdm.fragments(b'x'*150, 1, 'text')))
        def transaction(payload):
            self.worker.cancel.set()
            return True, {}
        with patch.object(self.worker, 'transaction', side_effect=transaction) as send:
            self.worker.send_message(message)
        result = self.events('message')[0]
        self.assertFalse(result['passed'])
        self.assertEqual(result['verified'], 1)
        self.assertEqual(send.call_count, 1)

    def test_stopping_worker_closes_connection(self):
        self.worker.stop.set()
        self.worker.start()
        self.worker.join(timeout=2)
        self.assertFalse(self.worker.is_alive())
        self.conn.close.assert_called_once()

    @unittest.skipUnless(os.name == 'posix', 'requires pseudo-terminal')
    def test_adapter_multi_fragment_over_real_os_uart(self):
        from serial_connection import SerialConnection
        from serial_packet import crc16
        master, slave = os.openpty()
        connection = SerialConnection(os.ttyname(slave))
        errors = []
        data = ('中文任务\n' * 20).encode('utf-8')
        self.worker.submit(data, 'log')
        message = self.worker.commands.get_nowait()
        returned = []

        def board():
            try:
                for packet in message[2]:
                    request = bytearray()
                    deadline = time.monotonic() + 3
                    while len(request) < 69 and time.monotonic() < deadline:
                        if select.select([master], [], [], .1)[0]:
                            request.extend(os.read(master, 69-len(request)))
                    self.assertEqual(bytes(request[3:67]), packet)
                    self.assertEqual(crc16(request[:-2]), int.from_bytes(request[-2:], 'little'))
                    returned.append(packet[ofdm.HEADER.size:ofdm.HEADER.size+ofdm.HEADER.unpack_from(packet)[-1]])
                    body = b'\x5a\xa5' + bytes([request[2], 0, 3, 64, 0]) + packet
                    response = body + crc16(body).to_bytes(2, 'little')
                    os.write(master, response[:12])
                    time.sleep(.005)
                    os.write(master, response[12:])
            except Exception as exc:
                errors.append(exc)

        thread = threading.Thread(target=board, daemon=True)
        try:
            connection.open(settle=0)
            self.worker.connection = connection
            thread.start()
            self.worker.send_message(message)
            thread.join(timeout=4)
            self.assertFalse(thread.is_alive())
            self.assertEqual(errors, [])
            self.assertTrue(self.events('message')[0]['passed'])
            self.assertEqual(b''.join(returned), data)
        finally:
            connection.close()
            os.close(master)
            os.close(slave)


if __name__ == '__main__':
    unittest.main()