import struct
import unittest
from unittest.mock import patch

from dma_image import packet
from dma_uart import loopback


def frame(body):
    return b'\x5a\xa5' + struct.pack('<H', len(body)) + body


class Port:
    def __init__(self, records):
        self.input = bytearray(b'boot diagnostics\r\n' + b''.join(frame(r) for r in records))
        self.sent = None

    def write(self, data):
        self.sent = data
        return len(data)

    def read(self, size):
        # Split all headers and payloads to exercise stream reassembly.
        result = bytes(self.input[:1])
        del self.input[:1]
        return result


class UartTests(unittest.TestCase):
    def test_matching_radio_return_and_local_acceptance(self):
        for size in (1, 64, 1000):
            with self.subTest(size=size):
                data = bytes(i % 251 for i in range(size))
                stale = packet(1, 9, 20, 0, 1, size, data)
                returned = packet(1, 10, 20, 0, 1, size, data)
                port = Port([b'\0', stale, returned])
                with patch('dma_uart.secrets.randbits', side_effect=[10, 20]):
                    self.assertEqual(loopback(port, data), data)
                self.assertEqual(port.sent, b'\xa5\x5a' + struct.pack('<H', len(returned)) + returned)

    def test_enqueue_success_alone_is_not_loopback(self):
        with patch('dma_uart.secrets.randbits', side_effect=[10, 20]):
            with self.assertRaises(TimeoutError):
                loopback(Port([b'\0']), b'abc', timeout=0.01)

    def test_mismatch_and_rejected_input(self):
        for records, error in (([b'\1'], RuntimeError), ([b'\2'], RuntimeError),
                               ([b'\0', packet(1, 10, 20, 0, 1, 3, b'bad')], ValueError)):
            with self.subTest(records=records), patch('dma_uart.secrets.randbits', side_effect=[10, 20]):
                with self.assertRaises(error):
                    loopback(Port(records), b'abc')


if __name__ == '__main__':
    unittest.main()
