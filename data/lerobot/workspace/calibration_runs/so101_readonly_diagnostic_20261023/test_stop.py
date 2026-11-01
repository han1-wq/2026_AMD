import unittest
from unittest.mock import Mock
import verify_stop as target


def packet(address, values, motor_id=1, instruction=3):
    data = [255, 255, motor_id, len(values) + 3, instruction, address] + values
    return data + [~sum(data[2:]) & 255]


class StopTests(unittest.TestCase):
    def test_zero_writes_allowed(self):
        for motor_id in range(1, 7):
            for address, values in [(40, [0]), (46, [0, 0])]:
                data = packet(address, values, motor_id)
                self.assertEqual(target.validate_stop_packet(data), data)

    def test_nonzero_and_other_writes_blocked(self):
        for address in range(256):
            for values in [[0], [0, 0], [1], [1, 0], [0, 1], [255, 255]]:
                if (address, values) in [(40, [0]), (46, [0, 0])]:
                    continue
                with self.assertRaises(PermissionError):
                    target.validate_stop_packet(packet(address, values))

    def test_broadcast_and_other_instructions_blocked(self):
        for instruction in range(256):
            if instruction != 3:
                with self.assertRaises(PermissionError):
                    target.validate_stop_packet(packet(40, [0], instruction=instruction))
        with self.assertRaises(PermissionError):
            target.validate_stop_packet(packet(40, [0], motor_id=254))

    def test_enable_never_reaches_serial(self):
        port = target.StopOnlyPort('/not-opened')
        port.ser = Mock()
        with self.assertRaises(PermissionError):
            port.writePort(packet(40, [1]))
        port.ser.write.assert_not_called()


if __name__ == '__main__':
    unittest.main(verbosity=2)