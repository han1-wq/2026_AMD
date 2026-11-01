import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from dma_uart_benchmark import benchmark, payload_for


class UartBenchmarkTests(unittest.TestCase):
    def test_success_records_bytes_and_hashes(self):
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp) / 'test'
            with patch('dma_uart_benchmark.loopback', side_effect=lambda port, data, timeout: data):
                summary = benchmark(None, out, count=3, size=1000)
            expected = b''.join(payload_for(i, 1000, 850) for i in range(3))
            self.assertTrue(summary['passed'])
            self.assertEqual(summary['compared_bits'], 24000)
            self.assertEqual(summary['sent_sha256'], hashlib.sha256(expected).hexdigest())
            self.assertEqual(summary['sent_sha256'], summary['received_sha256'])
            self.assertEqual((out / 'received.bin').read_bytes(), expected)
            self.assertEqual((out / 'sent.bin').read_bytes(), expected)
            self.assertEqual(len((out / 'results.jsonl').read_text().splitlines()), 3)
            self.assertIsNone(summary['link_retries'])

    def test_failure_stops_without_retry_and_preserves_evidence(self):
        for error in (TimeoutError('timeout'), RuntimeError('enqueue busy'), ValueError('mismatch')):
            with self.subTest(error=error), tempfile.TemporaryDirectory() as tmp:
                out = Path(tmp) / 'test'
                with patch('dma_uart_benchmark.loopback', side_effect=[payload_for(0, 64, 850), error]) as call:
                    summary = benchmark(None, out, count=5, size=64)
                self.assertEqual(call.call_count, 2)
                self.assertFalse(summary['passed'])
                self.assertFalse(summary['completed'])
                self.assertEqual(summary['successes'], 1)
                self.assertEqual(summary['failures'], 1)
                self.assertEqual(summary['not_attempted'], 3)
                self.assertEqual((out / 'sent.bin').stat().st_size, 128)
                self.assertEqual((out / 'received.bin').stat().st_size, 64)
                rows = [json.loads(line) for line in (out / 'results.jsonl').read_text().splitlines()]
                self.assertEqual(rows[1]['error_type'], type(error).__name__)
                self.assertIsNone(summary['failed_payload_differing_bits'])

    def test_incorrect_return_is_failure(self):
        with tempfile.TemporaryDirectory() as tmp, patch('dma_uart_benchmark.loopback', return_value=b'bad'):
            summary = benchmark(None, Path(tmp) / 'test', count=1, size=3)
            self.assertFalse(summary['passed'])
            self.assertEqual(summary['compared_bits'], 0)

    def test_invalid_size_or_count(self):
        for count, size in ((0, 1000), (1, 0), (1, 1001)):
            with self.subTest(count=count, size=size), tempfile.TemporaryDirectory() as tmp:
                with self.assertRaises(ValueError):
                    benchmark(None, Path(tmp) / 'test', count=count, size=size)


if __name__ == '__main__':
    unittest.main()