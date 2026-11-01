"""Independently audit the completed capture without transmitting RF data."""
import hashlib
import json
import math
from pathlib import Path
import socket
import statistics
import time


def main():
    out = Path(__file__).resolve().parent
    root = out.parents[2]
    bulk = out / 'bulk_2000'
    summary = json.loads((bulk / 'summary.json').read_text())
    config = json.loads((bulk / 'config.json').read_text())
    rows = [json.loads(line) for line in (bulk / 'results.jsonl').read_text().splitlines()]
    sent = (bulk / 'sent.bin').read_bytes()
    received = (bulk / 'received.bin').read_bytes()
    assert config['count'] == 2000 and config['payload_bytes'] == 1000
    assert config['seed'] == 850 and config['timeout_s'] == 10
    assert config['baudrate'] == 115200 and config['framing'] == '8N1'
    assert len(rows) == summary['attempts'] == summary['successes'] == 2000
    assert summary['requested'] == 2000 and summary['passed'] and summary['completed']
    assert summary['failures'] == summary['not_attempted'] == 0
    assert len(sent) == len(received) == summary['successful_bytes'] == 2000000
    assert sent == received
    for i, row in enumerate(rows):
        expected = hashlib.shake_256(f'850:{i}'.encode('ascii')).digest(1000)
        assert sent[i * 1000:(i + 1) * 1000] == expected
        assert row['attempt'] == i + 1 and row['success']
        assert not row['error'] and not row['error_type']
        assert row['payload_bytes'] == 1000 and row['compared_bits'] == 8000
        assert row['tx_sha256'] == row['rx_sha256'] == hashlib.sha256(expected).hexdigest()
        assert 0 < row['elapsed_s'] < config['timeout_s']
    differences = sum(bin(a ^ b).count('1') for a, b in zip(sent, received))
    digest = hashlib.sha256(sent).hexdigest()
    assert digest == summary['sent_sha256'] == summary['received_sha256']
    assert differences == summary['verified_payload_differing_bits'] == 0
    assert sum(row['compared_bits'] for row in rows) == summary['compared_bits'] == 16000000
    assert math.isclose(statistics.mean(row['elapsed_s'] for row in rows),
                        summary['success_elapsed_s']['mean'])
    assert math.isclose(2000000 / summary['wall_s'], summary['application_goodput_Bps'])
    lengths = [json.loads(line) for line in (out / 'length_checks.jsonl').read_text().splitlines()]
    sizes = (1, 4, 25, 64, 239, 255, 512, 999, 1000)
    assert len(lengths) == 27
    assert [(r['size'], r['repetition']) for r in lengths] == [(s, r) for s in sizes for r in range(3)]
    for row in lengths:
        expected = hashlib.shake_256(f"850:{row['repetition']}".encode('ascii')).digest(row['size'])
        assert row['success'] and row['sha256'] == hashlib.sha256(expected).hexdigest()
    artifacts = json.loads((out / 'artifacts.json').read_text())
    previous = json.loads((root / 'sim/captures/rs_850mhz_ack100_20261016/artifacts.json').read_text())
    assert artifacts == previous
    for name, expected in artifacts.items():
        assert hashlib.sha256(Path(name).read_bytes()).hexdigest() == expected
    src = root / 'build_sw_rs_850mhz_ack100/ofdm_dma/src'
    for name, maintained in (('main.c', 'firmware/radio/main.c'), ('link.c', 'firmware/dma_app/link.c')):
        assert (src / name).read_bytes() == (root / maintained).read_bytes()
    assert '#define RETRY_MS 100\n' in (src / 'link.c').read_text()
    boot = (out / 'boot.log').read_text()
    for direction in ('TX', 'RX'):
        assert f'Get {direction}_LO_Freq       :850.00 MHz' in boot
    assert 'UART_BULK_TEST_COMPLETE' in (out / 'runner.log').read_text()
    regression = (out / 'regression.log').read_text()
    assert 'DMA_REGRESSION_PASS' in regression and 'Ran 27 tests' in regression
    result = dict(verified_local=time.strftime('%Y-%m-%dT%H:%M:%S%z'),
                  capture_verified=True, artifact_hashes_verified=True,
                  source_matches_850mhz_workspace=True, bulk_packets=2000,
                  length_check_packets=27, length_check_bytes=sum(r['size'] for r in lengths),
                  bulk_bytes=len(sent), compared_bits=len(sent) * 8, differing_bits=differences,
                  sha256=digest, tcp_target='192.168.137.10:5001')
    try:
        start = time.monotonic()
        with socket.create_connection(('192.168.137.10', 5001), timeout=5):
            result.update(post_test_tcp_connected=True, tcp_connect_s=time.monotonic() - start)
    except OSError as exc:
        result.update(post_test_tcp_connected=False, tcp_error=str(exc))
    (out / 'verification.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))
    return 0 if result['post_test_tcp_connected'] else 1


if __name__ == '__main__':
    raise SystemExit(main())