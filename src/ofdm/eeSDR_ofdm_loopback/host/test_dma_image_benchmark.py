import socket
import struct
import threading
import unittest
import zlib

from dma_image import read_record, send_record
from dma_image_benchmark import distribution, summarize, transfer


class BenchmarkTests(unittest.TestCase):
    def test_persistent_full_duplex(self):
        host, board = socket.socketpair()
        errors = []
        data = bytes(range(256)) * 900

        def peer():
            try:
                with board:
                    for message in (1, 2):
                        meta = read_record(board)
                        send_record(board, meta)
                        for _ in range((len(data) + 999) // 1000):
                            send_record(board, read_record(board))
                        for code, detail in ((1, zlib.crc32(data)), (6, len(data))):
                            send_record(board, struct.pack('<2sBBIII', b'OS', 1, code, 42, message, detail))
            except Exception as exc:
                errors.append(exc)

        thread = threading.Thread(target=peer)
        thread.start()
        try:
            with host:
                host.settimeout(3)
                for message in (1, 2):
                    row, returned = transfer(host, data, 42, message, 3)
                    self.assertTrue(row['success'], row)
                    self.assertEqual(returned, data)
                    self.assertEqual(row['compared_bits'], len(data) * 8)
                    self.assertEqual(row['differing_bits'], 0)
                    self.assertEqual(row['missing_fragments'], [])
                    self.assertLessEqual(row['image_s'], row['elapsed_s'])
        finally:
            thread.join(5)
        self.assertFalse(thread.is_alive())
        self.assertFalse(errors, errors)

    def test_corruption_is_counted(self):
        host, board = socket.socketpair()

        def peer():
            with board:
                send_record(board, read_record(board))
                record = read_record(board)
                send_record(board, record[:-1] + bytes([record[-1] ^ 1]))

        thread = threading.Thread(target=peer)
        thread.start()
        with host:
            row, _ = transfer(host, b'abc', 42, 1, 2)
        thread.join(3)
        self.assertFalse(row['success'])
        self.assertIn('CRC', row['error'])
        self.assertEqual(row['differing_bits'], 1)
        self.assertEqual(row['compared_bits'], 24)

    def test_deadline_interrupts_blocked_receive(self):
        host, board = socket.socketpair()
        with host, board:
            row, _ = transfer(host, b'abc', 42, 1, .05)
        self.assertFalse(row['success'])
        self.assertIn('deadline', row['error'])
        self.assertLess(row['elapsed_s'], 1)
        self.assertEqual(row['missing_fragments'], [0])

    def test_failure_retains_matching_diagnostics(self):
        host, board = socket.socketpair()
        def peer():
            with board:
                read_record(board)
                read_record(board)
                for code, session, value in ((19, 99, 99), (19, 42, 3), (25, 42, 1), (5, 42, 3)):
                    send_record(board, struct.pack('<2sBBIII', b'OS', 1, code, session, 1, value))
        thread = threading.Thread(target=peer)
        thread.start()
        with host:
            row, _ = transfer(host, b'abc', 42, 1, 2)
        thread.join(3)
        self.assertFalse(thread.is_alive())
        self.assertFalse(row['success'])
        self.assertIn('status=5', row['error'])
        self.assertEqual(row['counters'], dict(tx_failed=3, link_failures=1))
        self.assertEqual(row['stale_records'], 1)

    def test_summary_distinguishes_failure_from_ber(self):
        rows = [dict(success=True, elapsed_s=1, image_s=.5, compared_bits=24, differing_bits=0),
                dict(success=False, elapsed_s=5, compared_bits=8, differing_bits=0)]
        result = summarize(rows, 3, 6)
        self.assertEqual(result['failure_rate'], .5)
        self.assertEqual(result['delivered_bit_difference_rate'], 0)
        self.assertIsNone(result['raw_rf_ber'])
        self.assertEqual(result['post_image_wait']['mean'], .5)
        self.assertEqual(distribution([1, 2, 3])['median'], 2)


if __name__ == '__main__':
    unittest.main()