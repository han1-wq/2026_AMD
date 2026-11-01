#!/usr/bin/env python3
"""Sequential UART -> RF -> UART validation, stopping at the first failure."""
import argparse
import hashlib
import json
from pathlib import Path
import time

from dma_image_benchmark import distribution
from dma_uart import loopback
from serial_packet import positive_seconds


def payload_for(index, size, seed):
    return hashlib.shake_256(f'{seed}:{index}'.encode('ascii')).digest(size)


def benchmark(port, output, count=2000, size=1000, timeout=10.0, seed=850):
    if count < 1 or not 1 <= size <= 1000:
        raise ValueError('count must be positive; payload size must be 1..1000')
    positive_seconds(timeout)
    output = Path(output)
    output.mkdir(parents=True, exist_ok=False)
    config = dict(count=count, payload_bytes=size, seed=seed, timeout_s=timeout,
                  baudrate=115200, framing='8N1', scheduled_sleep_s=0,
                  mode='sequential, one outstanding request, no host retry, fail-fast',
                  payload_generator='SHAKE256 ASCII seed:index; zero-based index',
                  success_requires='local enqueue acceptance AND matching RF RX payload',
                  start_local=time.strftime('%Y-%m-%dT%H:%M:%S%z'))
    (output / 'config.json').write_text(json.dumps(config, indent=2) + '\n')
    rows = []
    tx_hash, rx_hash = hashlib.sha256(), hashlib.sha256()
    start = time.monotonic()
    try:
        with (output / 'results.jsonl').open('w', buffering=1) as log, \
                (output / 'sent.bin').open('wb') as tx, \
                (output / 'received.bin').open('wb') as rx:
            for index in range(count):
                payload = payload_for(index, size, seed)
                tx.write(payload)
                tx_hash.update(payload)
                row = dict(attempt=index + 1, success=False, error='', error_type='',
                           payload_bytes=size, compared_bits=0,
                           tx_sha256=hashlib.sha256(payload).hexdigest())
                before = time.monotonic()
                try:
                    returned = loopback(port, payload, timeout)
                    if returned != payload:
                        raise ValueError('UART loopback data differs from input')
                    rx.write(returned)
                    rx_hash.update(returned)
                    row.update(success=True, compared_bits=size * 8,
                               rx_sha256=hashlib.sha256(returned).hexdigest())
                except (OSError, ValueError, RuntimeError) as exc:
                    row.update(error=str(exc), error_type=type(exc).__name__)
                row['elapsed_s'] = time.monotonic() - before
                rows.append(row)
                log.write(json.dumps(row) + '\n')
                if (index + 1) % 100 == 0 or not row['success'] or index + 1 == count:
                    print(f"{index + 1}/{count} {'PASS' if row['success'] else 'FAIL'} "
                          f"{row['elapsed_s']:.3f}s {row['error']}", flush=True)
                if not row['success']:
                    break
    finally:
        wall = time.monotonic() - start
        good = [row for row in rows if row['success']]
        summary = dict(requested=count, attempts=len(rows), successes=len(good),
                       failures=len(rows) - len(good), not_attempted=count - len(rows),
                       completed=len(rows) == count,
                       passed=len(good) == count, wall_s=wall,
                       successful_bytes=len(good) * size,
                       compared_bits=len(good) * size * 8,
                       verified_payload_differing_bits=0,
                       failed_payload_differing_bits=None,
                       raw_rf_ber=None, link_retries=None, rx_dropped=None,
                       measurement='Only fully verified returns are saved; failed/partial data is not bit-counted',
                       application_goodput_Bps=len(good) * size / wall if wall else 0,
                       success_elapsed_s=distribution(row['elapsed_s'] for row in good),
                       sent_sha256=tx_hash.hexdigest(), received_sha256=rx_hash.hexdigest())
        (output / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
    return summary


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('port')
    parser.add_argument('output', type=Path)
    parser.add_argument('--count', type=int, default=2000)
    parser.add_argument('--size', type=int, default=1000)
    parser.add_argument('--timeout', type=positive_seconds, default=10.0)
    parser.add_argument('--seed', type=int, default=850)
    args = parser.parse_args()
    if args.count < 1 or not 1 <= args.size <= 1000:
        parser.error('count must be positive; payload size must be 1..1000')
    from serial_connection import SerialConnection
    connection = SerialConnection(args.port)
    try:
        print('Connected: ' + connection.open())
        time.sleep(max(0, connection.ready_at - time.monotonic()))
        connection.validate()
        connection.port.reset_input_buffer()
        summary = benchmark(connection.port, args.output, args.count, args.size,
                            args.timeout, args.seed)
        print(json.dumps(summary, indent=2), flush=True)
    finally:
        connection.close()
    return 0 if summary['passed'] else 1


if __name__ == '__main__':
    raise SystemExit(main())