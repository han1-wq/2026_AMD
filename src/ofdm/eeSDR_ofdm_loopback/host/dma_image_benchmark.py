#!/usr/bin/env python3
"""Sequential hardware image loopback benchmark; raw RF BER is not observable."""
import argparse
import csv
import hashlib
import json
import math
from pathlib import Path
import secrets
import socket
import statistics
import struct
import threading
import time
import zlib

from dma_image import (DATA, META, MAX_IMAGE, COUNTER_NAMES, ImageReceiver,
                       connect_board, decode, packet, read_record, send_record)


def transfer(sock, data, session, message, timeout):
    """Return metrics and validated image (or partial received bytes on failure)."""
    count = (len(data) + 999) // 1000
    crc = zlib.crc32(data)
    row = dict(session=session, message=message, success=False, error='',
               upload_s=None, metadata_s=None, first_data_s=None,
               image_s=None, crc_s=None, ack_s=None, elapsed_s=None,
               fragments=0, compared_bits=0, differing_bits=0, stale_records=0,
               counters={})
    receiver = ImageReceiver()
    seen = set()
    errors = []
    start = time.monotonic()
    expired = threading.Event()

    def shutdown():
        try:
            sock.shutdown(socket.SHUT_RDWR)
        except OSError:
            pass

    def expire():
        expired.set()
        shutdown()

    def send():
        try:
            send_record(sock, packet(META, session, message, 0, count, len(data), struct.pack('<I', crc)))
            for index in range(count):
                send_record(sock, packet(DATA, session, message, index, count, len(data),
                                         data[index * 1000:(index + 1) * 1000]))
            row['upload_s'] = time.monotonic() - start
        except Exception as exc:
            errors.append(str(exc))
            shutdown()

    timer = threading.Timer(timeout, expire)
    sender = threading.Thread(target=send, name='benchmark-upload')
    timer.start()
    sender.start()
    result = None
    try:
        while result is None or row['crc_s'] is None or row['ack_s'] is None:
            record = read_record(sock)
            elapsed = time.monotonic() - start
            if record[:2] == b'OS':
                if len(record) != 16 or record[2] != 1:
                    raise ValueError('invalid board status')
                code = record[3]
                sid, mid, detail = struct.unpack_from('<III', record, 4)
                matches = (sid, mid) == (session, message)
                if matches and 16 <= code < 16 + len(COUNTER_NAMES):
                    row['counters'][COUNTER_NAMES[code - 16]] = detail
                if code == 4 or (code == 3 and (sid, mid) == (0, 0)) or (matches and code in (2, 3, 5)):
                    raise RuntimeError(f'board transfer failure: status={code}, detail={detail}')
                if matches and code == 1:
                    if detail != crc:
                        raise ValueError('board CRC mismatch')
                    row['crc_s'] = elapsed
                if matches and code == 6:
                    if detail != len(data):
                        raise ValueError('board upload length mismatch')
                    row['ack_s'] = elapsed
                if not matches:
                    row['stale_records'] += 1
                continue
            kind, channel, sid, mid, index, fragments, total, payload = decode(record)
            if (channel, sid, mid) != (0, session, message):
                row['stale_records'] += 1
                continue
            if kind not in (META, DATA) or fragments != count or total != len(data):
                raise ValueError('unexpected loopback packet')
            if kind == META and row['metadata_s'] is None:
                row['metadata_s'] = elapsed
            if kind == DATA:
                if row['first_data_s'] is None:
                    row['first_data_s'] = elapsed
                expected = data[index * 1000:(index + 1) * 1000]
                if len(payload) != len(expected):
                    raise ValueError('fragment length mismatch')
                if index not in seen:
                    seen.add(index)
                    row['compared_bits'] += len(payload) * 8
                    row['differing_bits'] += sum(bin(a ^ b).count('1') for a, b in zip(payload, expected))
            received = receiver.accept(record)
            if received is not None:
                if received != data:
                    raise ValueError('loopback bytes differ from source')
                if result is None:
                    row['image_s'] = time.monotonic() - start
                result = received
        sender.join()
        if errors:
            raise RuntimeError(errors[0])
        if expired.is_set():
            raise TimeoutError('transfer deadline exceeded')
        row['success'] = True
    except Exception as exc:
        row['error'] = 'transfer deadline exceeded' if expired.is_set() else str(exc)
        shutdown()
    finally:
        timer.cancel()
        sender.join()
        timer.join()
        row['elapsed_s'] = time.monotonic() - start
        row['fragments'] = len(seen)
        row['missing_fragments'] = sorted(set(range(count)) - seen)
    return row, result if result is not None else receiver.data


def distribution(values):
    values = sorted(v for v in values if v is not None)
    if not values:
        return None
    def percentile(p):
        x = (len(values) - 1) * p
        lo, hi = math.floor(x), math.ceil(x)
        return values[lo] + (values[hi] - values[lo]) * (x - lo)
    return dict(n=len(values), min=min(values), mean=statistics.mean(values),
                median=statistics.median(values), p90=percentile(.9), p95=percentile(.95),
                p99=percentile(.99), max=max(values), stdev=statistics.pstdev(values))


def summarize(rows, size, wall):
    good = [r for r in rows if r['success']]
    compared = sum(r['compared_bits'] for r in rows)
    differences = sum(r['differing_bits'] for r in rows)
    return dict(attempts=len(rows), successes=len(good), failures=len(rows) - len(good),
                failure_rate=(len(rows) - len(good)) / len(rows),
                compared_bits=compared, differing_bits=differences,
                delivered_bit_difference_rate=differences / compared if compared else None,
                raw_rf_ber=None, raw_rf_packet_loss_rate=None,
                wall_s=wall, successful_bytes=len(good) * size,
                application_goodput_Bps=len(good) * size / wall,
                success_timings={key: distribution(r.get(key) for r in good) for key in
                                 ('elapsed_s', 'upload_s', 'metadata_s', 'first_data_s', 'image_s', 'crc_s', 'ack_s', 'gap_s')},
                failure_elapsed=distribution(r['elapsed_s'] for r in rows if not r['success']),
                post_image_wait=distribution(r['elapsed_s'] - r['image_s'] for r in good))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('board')
    parser.add_argument('source', type=Path)
    parser.add_argument('output', type=Path)
    parser.add_argument('--count', type=int, default=200)
    parser.add_argument('--port', type=int, default=5001)
    parser.add_argument('--timeout', type=float, default=30)
    parser.add_argument('--nagle', action='store_true', help='enable Nagle for latency A/B measurement')
    args = parser.parse_args()
    data = args.source.read_bytes()
    if not 1 <= len(data) <= MAX_IMAGE or args.count < 1 or not math.isfinite(args.timeout) or args.timeout <= 0:
        parser.error('invalid size, count or timeout')
    args.output.mkdir(parents=True, exist_ok=False)
    config = dict(board=args.board, port=args.port, source=str(args.source.resolve()),
                  source_bytes=len(data), source_sha256=hashlib.sha256(data).hexdigest(),
                  count=args.count, timeout_s=args.timeout, persistent_connection=True,
                  tcp_nodelay=not args.nagle,
                  scheduled_sleep_s=0, start_local=time.strftime('%Y-%m-%dT%H:%M:%S%z'),
                  timeout_policy='30s default whole-transfer deadline, not only socket idle timeout',
                  measurement='application records after RF FCS/ARQ; raw BER unavailable; counter deltas when supported')
    (args.output / 'config.json').write_text(json.dumps(config, indent=2) + '\n')
    rows, sock, last_good = [], None, None
    start = previous_end = time.monotonic()
    try:
        with (args.output / 'results.jsonl').open('w', buffering=1) as log:
            for index in range(1, args.count + 1):
                attempt_start = time.monotonic()
                connect_s = 0.0
                if sock is None:
                    try:
                        sock = connect_board((args.board, args.port), args.timeout, nodelay=not args.nagle)
                        connect_s = time.monotonic() - attempt_start
                    except OSError as exc:
                        row = dict(success=False, error=f'connect: {exc}', elapsed_s=time.monotonic() - attempt_start,
                                   compared_bits=0, differing_bits=0, fragments=0)
                        returned = None
                if sock is not None:
                    row, returned = transfer(sock, data, secrets.randbits(32), index, args.timeout)
                row.update(attempt=index, connect_s=connect_s, gap_s=attempt_start - previous_end,
                           offset_s=attempt_start - start)
                previous_end = time.monotonic()
                if row['success']:
                    last_good = returned
                else:
                    if sock is not None:
                        sock.close()
                        sock = None
                    if returned is not None:
                        (args.output / f'failed_{index:03d}_partial.bin').write_bytes(returned)
                rows.append(row)
                log.write(json.dumps(row) + '\n')
                print(f"{index:03d}/{args.count} {'PASS' if row['success'] else 'FAIL'} "
                      f"{row['elapsed_s']:.3f}s fragments={row['fragments']} "
                      f"bit_differences={row['differing_bits']} {row['error']}", flush=True)
    finally:
        if sock is not None:
            sock.close()
        wall = time.monotonic() - start
        if rows:
            summary = summarize(rows, len(data), wall)
            (args.output / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
            fields = sorted(set().union(*(r.keys() for r in rows)))
            with (args.output / 'results.csv').open('w', newline='') as file:
                writer = csv.DictWriter(file, fieldnames=fields)
                writer.writeheader()
                writer.writerows(rows)
            if last_good is not None:
                (args.output / 'last_received.png').write_bytes(last_good)
            print(json.dumps(summary, indent=2), flush=True)


if __name__ == '__main__':
    main()