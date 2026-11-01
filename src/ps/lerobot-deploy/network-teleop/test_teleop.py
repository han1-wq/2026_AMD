import argparse
import json
import socket
import threading
import time
import unittest
from unittest.mock import Mock

from teleop import Arm, JOINTS, Wire, limited, positions, serve_connection, validate_reply


class ProtocolTests(unittest.TestCase):
    def setUp(self):
        self.left, self.right = socket.socketpair()
        self.addCleanup(self.left.close)
        self.addCleanup(self.right.close)
        self.tx = Wire(self.left, b'x' * 32)
        self.rx = Wire(self.right, b'x' * 32)
        self.zero = dict.fromkeys(JOINTS, 0.0)

    def test_frames_and_fragmentation(self):
        capture = Mock()
        Wire(capture, b'x' * 32).send({'value': 1})
        packet = capture.sendall.call_args.args[0]
        self.left.sendall(packet[:5])
        self.left.sendall(packet[5:] + packet)
        self.assertEqual(self.rx.receive(time.monotonic() + 1), {'value': 1})
        self.assertEqual(self.rx.receive(time.monotonic() + 1), {'value': 1})

    def test_wrong_key(self):
        Wire(self.left, b'y' * 32).send({'value': 1})
        with self.assertRaisesRegex(ValueError, 'Authentication'):
            self.rx.receive(time.monotonic() + 1)

    def test_oversized(self):
        self.left.sendall(b'x' * 4097)
        with self.assertRaisesRegex(ValueError, 'large'):
            self.rx.receive(time.monotonic() + 1)

    def test_timeout_and_disconnect(self):
        with self.assertRaises(TimeoutError):
            self.rx.receive(time.monotonic() + 0.02)
        self.left.close()
        with self.assertRaises(EOFError):
            self.rx.receive(time.monotonic() + 1)

    def test_expired_buffer(self):
        self.tx.send({'value': 1})
        with self.assertRaises(TimeoutError):
            self.rx.receive(time.monotonic() - 1)

    def test_invalid_targets(self):
        for bad in (float('nan'), float('inf'), True, '0', 101, -101):
            with self.subTest(bad=bad), self.assertRaises(ValueError):
                positions(dict(self.zero, shoulder_pan=bad))
        with self.assertRaises(ValueError):
            positions(dict(self.zero, gripper=-1))
        with self.assertRaises(ValueError):
            positions({'gripper': 0})

    def test_replay(self):
        for seq, nonce in ((0, 'old'), (1, 'fresh'), (False, 'fresh')):
            with self.assertRaises(ValueError):
                validate_reply({'seq': seq, 'nonce': nonce, 'positions': self.zero}, 0, 'fresh')

    def test_local_relative_target_behavior(self):
        target = dict(self.zero, wrist_roll=80)
        self.assertEqual(limited(target, self.zero)['wrist_roll'], 5)
        self.assertEqual(limited(dict(self.zero, wrist_roll=-80), self.zero)['wrist_roll'], -5)
        self.assertEqual(limited(dict(self.zero, wrist_roll=2), self.zero)['wrist_roll'], 2)
        present = dict(self.zero, wrist_roll=72)
        self.assertEqual(limited(dict(self.zero, wrist_roll=54), present)['wrist_roll'], 67)

    def test_hold_acknowledged_and_preserves_torque(self):
        arm = Arm(argparse.Namespace())
        arm.bus = Mock(is_connected=True)
        arm.live = True
        arm.bus.sync_read.return_value = dict.fromkeys(JOINTS, 2048)
        arm.hold()
        self.assertEqual(arm.bus.write.call_count, 6)
        arm.bus.disable_torque.assert_not_called()
        arm.close()
        arm.bus.disconnect.assert_called_once_with(disable_torque=False)

    def test_initial_mismatch_activates_with_clamped_target(self):
        arm = Mock()
        arm.read.return_value = self.zero
        args = argparse.Namespace(duration=0.01, ttl=0.2, hardware=False, hz=20)
        errors = []

        def worker():
            try:
                serve_connection(self.right, args, b'x' * 32, arm)
            except Exception as exc:
                errors.append(exc)

        thread = threading.Thread(target=worker)
        thread.start()
        request = self.tx.receive(time.monotonic() + 1)
        self.tx.send({'seq': request['seq'], 'nonce': request['nonce'],
                      'positions': dict(self.zero, elbow_flex=50)})
        thread.join(1)
        self.assertFalse(thread.is_alive())
        self.assertEqual(errors, [])
        arm.activate.assert_called_once()
        arm.write.assert_called_once_with(dict(self.zero, elbow_flex=5.0))

    def test_server_rejects_faults_before_writing(self):
        for fault in ('expired', 'replayed', 'invalid', 'disconnect'):
            with self.subTest(fault=fault):
                left, right = socket.socketpair()
                self.addCleanup(left.close)
                self.addCleanup(right.close)
                arm = Mock()
                arm.read.return_value = self.zero
                args = argparse.Namespace(duration=0, ttl=0.05, hardware=False, hz=20, rate=10)
                errors = []

                def worker():
                    try:
                        serve_connection(right, args, b'x' * 32, arm)
                    except Exception as exc:
                        errors.append(exc)

                thread = threading.Thread(target=worker)
                thread.start()
                wire = Wire(left, b'x' * 32)
                request = wire.receive(time.monotonic() + 1)
                if fault == 'disconnect':
                    left.close()
                elif fault != 'expired':
                    wire.send({'seq': 99 if fault == 'replayed' else request['seq'],
                               'nonce': request['nonce'],
                               'positions': {} if fault == 'invalid' else self.zero})
                thread.join(1)
                self.assertFalse(thread.is_alive())
                self.assertEqual(len(errors), 1)
                arm.activate.assert_not_called()
                arm.write.assert_not_called()


if __name__ == '__main__':
    unittest.main()