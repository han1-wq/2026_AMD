#!/usr/bin/env python3
"""Paced JPEG frame loopback with bounded latency and explicit source-frame drops.

Input is a directory of JPEG frames, replayed cyclically. Frames are pre-encoded;
camera capture and encoding are excluded, while receive/decode time is included.
"""
import argparse
from io import BytesIO
import json
import math
from pathlib import Path
import secrets
import time

from PIL import Image

from dma_image import MAX_IMAGE, connect_board
from dma_image_benchmark import distribution, transfer


def due_frame(elapsed, fps, next_index, count):
    """Skip expired source frames instead of building an unbounded video queue."""
    return min(count, max(next_index, int(elapsed * fps)))


def run(board, frames, output, fps, seconds, timeout=10, port=5001, save_frames=False):
    if not all(math.isfinite(x) and x > 0 for x in (fps, seconds, timeout)):
        raise ValueError('fps, seconds and timeout must be positive finite numbers')
    paths = sorted(Path(frames).glob('*.jpg'))
    if not paths:
        raise ValueError('No JPEG frames found')
    payloads = [p.read_bytes() for p in paths]
    if any(not 1 <= len(data) <= MAX_IMAGE for data in payloads):
        raise ValueError('Invalid frame size')
    dimensions = set()
    for data in payloads:
        with Image.open(BytesIO(data)) as image:
            if image.format != 'JPEG':
                raise ValueError('Expected JPEG')
            dimensions.add(image.size)
            image.load()
    if len(dimensions) != 1:
        raise ValueError('Frame dimensions must match')
    output = Path(output)
    output.mkdir(parents=True, exist_ok=False)
    count = math.ceil(seconds * fps)
    config = dict(board=board, port=port, source=str(Path(frames).resolve()),
                  fps=fps, seconds=seconds, scheduled_frames=count,
                  dimensions=list(dimensions.pop()), source_frames=len(paths),
                  frame_bytes=distribution(map(len, payloads)), timeout_s=timeout,
                  save_received_frames=save_frames,
                  policy='one outstanding frame; skip stale source frames; no host retry',
                  measurement='preencoded JPEG loopback; decode included; capture/encode excluded')
    (output / 'config.json').write_text(json.dumps(config, indent=2) + '\n')
    if save_frames:
        (output / 'received').mkdir()
    rows = []
    index = dropped = 0
    last = None
    session = secrets.randbits(32)
    sock = connect_board((board, port), timeout)
    start = time.monotonic()
    try:
        with (output / 'results.jsonl').open('w', buffering=1) as log:
            while index < count:
                wait = start + index / fps - time.monotonic()
                if wait > 0:
                    time.sleep(wait)
                current = due_frame(time.monotonic() - start, fps, index, count)
                dropped += current - index
                index = current
                if index >= count:
                    break
                data = payloads[index % len(payloads)]
                row, returned = transfer(sock, data, session, index + 1, timeout)
                decode_start = time.monotonic()
                if row['success']:
                    try:
                        with Image.open(BytesIO(returned)) as image:
                            image.load()
                        last = returned
                        if save_frames:
                            filename = f'frame_{index:06d}.jpg'
                            (output / 'received' / filename).write_bytes(returned)
                            latest = output / 'received' / 'latest.tmp'
                            latest.write_text(json.dumps(dict(frame=filename, index=index,
                                                              fps=fps, bytes=len(returned))))
                            latest.replace(output / 'received' / 'latest.json')
                    except (OSError, ValueError) as exc:
                        row.update(success=False, error=f'JPEG decode: {exc}')
                finished = time.monotonic() - start
                row.update(source_index=index, bytes=len(data), finish_s=finished,
                           decode_s=time.monotonic() - decode_start,
                           capture_to_decode_s=finished - index / fps,
                           on_time=bool(row['success'] and finished <= (index + 1) / fps))
                rows.append(row)
                log.write(json.dumps(row) + '\n')
                index += 1
                if not row['success']:
                    break
            # Include the final presentation interval in goodput/FPS, not only busy time.
            if index >= count:
                time.sleep(max(0, start + seconds - time.monotonic()))
    finally:
        sock.close()
        wall = time.monotonic() - start
        good = [r for r in rows if r['success']]
        counters = {}
        for row in rows:
            for key, value in row['counters'].items():
                counters[key] = counters.get(key, 0) + value
        summary = dict(requested_fps=fps, scheduled_frames=count, attempted=len(rows),
                       successes=len(good), failures=len(rows) - len(good),
                       dropped_source_frames=dropped, unattempted_frames=count-len(rows)-dropped,
                       late_frames=sum(not r['on_time'] for r in good),
                       on_time_frames=sum(r['on_time'] for r in good),
                       wall_s=wall, delivered_fps=len(good)/wall,
                       successful_bytes=sum(r['bytes'] for r in good),
                       application_goodput_Bps=sum(r['bytes'] for r in good)/wall,
                       compared_bits=sum(r['compared_bits'] for r in rows),
                       differing_bits=sum(r['differing_bits'] for r in rows),
                       transfer_s=distribution(r['elapsed_s'] for r in good),
                       capture_to_decode_s=distribution(r['capture_to_decode_s'] for r in good),
                       decode_s=distribution(r['decode_s'] for r in good),
                       counter_totals=counters,
                       rows_with_counters=sum(bool(r['counters']) for r in rows),
                       strict_realtime_pass=len(good)==count and all(r['on_time'] for r in rows),
                       raw_rf_ber=None)
        (output / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
        if last is not None:
            (output / 'last_received.jpg').write_bytes(last)
    return summary


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('board')
    parser.add_argument('frames', type=Path)
    parser.add_argument('output', type=Path)
    parser.add_argument('--fps', type=float, default=5)
    parser.add_argument('--seconds', type=float, default=30)
    parser.add_argument('--timeout', type=float, default=10)
    parser.add_argument('--port', type=int, default=5001)
    parser.add_argument('--save-frames', action='store_true',
                        help='Save every verified returned JPEG; disk time is included in latency')
    args = parser.parse_args()
    print(json.dumps(run(args.board, args.frames, args.output, args.fps,
                         args.seconds, args.timeout, args.port, args.save_frames), indent=2))


if __name__ == '__main__':
    main()