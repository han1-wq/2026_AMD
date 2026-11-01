"""Protocol checks without hardware."""

import unittest

from serial_packet import crc16, frame, receive


class FakePort:
    def __init__(self, data=b""):
        self.data = data

    def read(self, size):
        result, self.data = self.data[:size], self.data[size:]
        return result


class PacketTests(unittest.TestCase):
    def response(self, seq=7):
        body = b"\x5a\xa5" + bytes([seq, 0, 3, 64, 0]) + bytes(range(64))
        return body + crc16(body).to_bytes(2, "little")

    def test_crc_vector(self):
        self.assertEqual(crc16(b"123456789"), 0x29b1)

    def test_request(self):
        data = frame(bytes(range(64)), 7)
        self.assertEqual(len(data), 69)
        self.assertEqual(data[:3], b"\xa5\x5a\x07")
        self.assertEqual(int.from_bytes(data[-2:], "little"), crc16(data[:-2]))
        with self.assertRaises(ValueError):
            frame(b"short", 7)

    def test_response_and_sync(self):
        data = b"startup log\r\n\x5a" + self.response()
        self.assertEqual(receive(FakePort(data), 7), (0, 3, 64, bytes(range(64))))

    def test_no_response_timeout(self):
        with self.assertRaisesRegex(TimeoutError, "response timeout"):
            receive(FakePort(), 7, timeout=0.01)

    def test_partial_timeout(self):
        with self.assertRaisesRegex(TimeoutError, "incomplete response"):
            receive(FakePort(self.response()[:12]), 7, timeout=0.01)

    def test_crc_error(self):
        data = bytearray(self.response())
        data[10] ^= 1
        with self.assertRaisesRegex(ValueError, "CRC"):
            receive(FakePort(data), 7, timeout=0.01)

    def test_sequence_error(self):
        with self.assertRaisesRegex(ValueError, "sequence"):
            receive(FakePort(self.response(8)), 7, timeout=0.01)

    def test_stale_response_then_current(self):
        data = self.response(8) + self.response(7)
        self.assertEqual(receive(FakePort(data), 7)[3], bytes(range(64)))

    def test_corrupted_response_then_current(self):
        corrupt = bytearray(self.response())
        corrupt[10] ^= 1
        self.assertEqual(receive(FakePort(corrupt + self.response()), 7)[0], 0)

    def test_false_header_before_valid_response(self):
        data = b'\x5a\xa5noise' + self.response()
        self.assertEqual(receive(FakePort(data), 7)[3], bytes(range(64)))

    def test_invalid_sequence_and_timeout(self):
        for seq in (-1, 256):
            with self.assertRaises(ValueError):
                frame(bytes(64), seq)
        for timeout in (0, -1, float('inf'), float('nan')):
            with self.assertRaises(ValueError):
                receive(FakePort(), 0, timeout=timeout)


if __name__ == "__main__":
    unittest.main()