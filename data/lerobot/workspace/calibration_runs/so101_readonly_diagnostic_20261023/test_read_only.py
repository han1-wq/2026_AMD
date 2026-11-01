import unittest
from unittest.mock import Mock, patch
import read_only_diagnostic as target


def packet(motor_id=1, instruction=2, address=40, count=1):
    data = [255, 255, motor_id, 4, instruction, address, count, 0]
    data[-1] = ~sum(data[2:-1]) & 255
    return data


class ReadOnlyTests(unittest.TestCase):
    def test_every_allowed_read_passes(self):
        for motor_id in range(1, 7):
            for address, length in target.ALLOWED_READS:
                data = packet(motor_id=motor_id, address=address, count=length)
                self.assertEqual(target.validate_read_packet(data), data)

    def test_every_other_instruction_blocked(self):
        for instruction in range(256):
            if instruction != 2:
                with self.assertRaises(PermissionError):
                    target.validate_read_packet(packet(instruction=instruction))

    def test_broadcast_bad_ids_checksum_and_length_blocked(self):
        for data in [packet(motor_id=254), packet(motor_id=0), packet(motor_id=7),
                     packet(address=42), packet(count=4), packet()[:-1],
                     packet() + [0], [0] * 8]:
            with self.assertRaises(PermissionError):
                target.validate_read_packet(data)
        data = packet(); data[-1] ^= 1
        with self.assertRaises(PermissionError):
            target.validate_read_packet(data)

    def test_blocked_write_never_reaches_serial(self):
        port = target.ReadOnlyPort('/not-opened')
        port.ser = Mock()
        with self.assertRaises(PermissionError):
            port.writePort(packet(instruction=3))
        port.ser.write.assert_not_called()
        self.assertEqual(port.tx_packets, [])

    def test_sdk_generates_only_allowed_read_packet(self):
        port = target.ReadOnlyPort('/not-opened')
        port.ser = Mock()
        port.ser.write.return_value = 8
        handler = target.sdk.PacketHandler(0)
        with patch.object(handler, 'rxPacket', return_value=([255,255,1,3,0,0,251],0)):
            self.assertEqual(target.read_value(handler, port, 1, 'Torque_Enable'), 0)
        self.assertEqual(port.tx_packets, [packet()])
        port.ser.write.assert_called_once_with(packet())

    def test_fault_or_missing_data_rejected(self):
        for response in [([0],0,32), ([],0,0), ([0],-1,0)]:
            handler = Mock(); handler.readTxRx.return_value = response
            with self.assertRaises(RuntimeError):
                target.read_value(handler, Mock(), 1, 'Torque_Enable')

    def test_signed_velocity(self):
        self.assertEqual(target.signed_magnitude(32768 + 50, 15), -50)
        self.assertEqual(target.signed_magnitude(400, 15), 400)


if __name__ == '__main__':
    unittest.main(verbosity=2)