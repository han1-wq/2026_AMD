"""Exercise the reconnect state machine and a real OS pseudo-terminal."""

import os
import queue
import select
import threading
import time
import unittest
from unittest.mock import patch

from serial_connection import SerialConnection
from serial_devices import DeviceNotFound
from serial_packet import crc16, frame, receive
from serial_worker import SerialWorker
from test_serial_devices import device


class WorkerTests(unittest.TestCase):
    @unittest.skipUnless(os.name == 'posix', 'requires POSIX pseudo-terminal')
    def test_running_worker_recovers_on_new_port_without_replaying(self):
        first_master, first_slave = os.openpty()
        next_master, next_slave = os.openpty()
        current = [device(os.ttyname(first_slave))]

        def resolve(*args):
            if not current:
                raise DeviceNotFound('removed')
            return current[0]

        commands, events = queue.Queue(), queue.Queue()
        worker = SerialWorker(commands, events)

        def wait_connected(value):
            deadline = time.monotonic() + 5
            while time.monotonic() < deadline:
                try:
                    kind, result = events.get(timeout=0.1)
                except queue.Empty:
                    continue
                if kind == 'connected' and result == value:
                    return
            self.fail('Worker did not reach connected={}'.format(value))

        try:
            with patch('serial_connection.resolve_device', side_effect=resolve):
                worker.start()
                commands.put(('connect', {'target': 'auto'}))
                wait_connected(True)
                current.clear()
                wait_connected(False)
                current.append(device(os.ttyname(next_slave), serial='UPDATED'))
                wait_connected(True)
                self.assertEqual(worker.connection.port.port, os.ttyname(next_slave))
                self.assertEqual(select.select([first_master, next_master], [], [], 0)[0], [])
                commands.put(('disconnect', None))
                wait_connected(False)
                worker.stop.set()
                worker.join(timeout=3)
                self.assertFalse(worker.is_alive())
        finally:
            worker.stop.set()
            if worker.ident is not None:
                worker.join(timeout=3)
            for fd in (first_master, first_slave, next_master, next_slave):
                os.close(fd)

    def test_missing_device_recovers_and_manual_stop_cancels(self):
        worker = SerialWorker(queue.Queue(), queue.Queue())
        with patch('serial_worker.SerialConnection') as factory:
            conn = factory.return_value
            worker.connection = conn
            conn.port = None
            conn.open.side_effect = DeviceNotFound('unplugged')
            worker.maintain()
            self.assertIs(worker.connection, conn)
            self.assertFalse(worker.announced_ready)
            conn.open.side_effect = None
            conn.open.return_value = '/dev/ttyUSB9'
            worker.next_scan = 0
            worker.maintain()
            self.assertEqual(conn.open.call_count, 2)
            worker.disconnect()
            worker.maintain()
            self.assertIsNone(worker.connection)
            self.assertEqual(conn.open.call_count, 2)

    def test_disconnect_during_validation_prevents_transmission(self):
        worker = SerialWorker(queue.Queue(), queue.Queue())
        with patch('serial_worker.SerialConnection') as factory:
            worker.connection = factory.return_value
            worker.connection.validate.side_effect = DeviceNotFound('removed')
            worker.announced_ready = True
            with self.assertRaisesRegex(ValueError, 'not sent'):
                worker.send(bytes(64))
            factory.return_value.port.write.assert_not_called()

    @unittest.skipUnless(os.name == 'posix', 'requires POSIX pseudo-terminal')
    def test_real_serial_transport_with_fragmented_response(self):
        master, slave = os.openpty()
        conn = SerialConnection(os.ttyname(slave))
        errors = []
        payload = bytes(range(64))

        def board():
            try:
                request = bytearray()
                deadline = time.monotonic() + 3
                while len(request) < 69 and time.monotonic() < deadline:
                    if select.select([master], [], [], 0.1)[0]:
                        request.extend(os.read(master, 69 - len(request)))
                self.assertEqual(bytes(request), frame(payload, 42))
                body = b'\x5a\xa5' + bytes([42, 0, 3, 64, 0]) + payload
                response = body + crc16(body).to_bytes(2, 'little')
                os.write(master, b'boot log\r\n' + response[:15])
                time.sleep(0.01)
                os.write(master, response[15:])
            except Exception as exc:
                errors.append(exc)

        thread = threading.Thread(target=board)
        try:
            conn.open(settle=0)
            thread.start()
            self.assertEqual(conn.port.write(frame(payload, 42)), 69)
            self.assertEqual(receive(conn.port, 42), (0, 3, 64, payload))
        finally:
            if thread.ident is not None:
                thread.join(timeout=4)
            conn.close()
            os.close(master)
            os.close(slave)
        self.assertFalse(thread.is_alive())
        if errors:
            raise errors[0]


if __name__ == '__main__':
    unittest.main()