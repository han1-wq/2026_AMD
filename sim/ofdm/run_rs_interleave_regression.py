#!/usr/bin/env python3
"""Independent balanced RS reference, exhaustive mapping and RTL/FCS/DMA tests."""
import argparse
from collections import Counter
import concurrent.futures
import hashlib
import json
from pathlib import Path
import random
import re
import subprocess
import time
import zlib

from run_rs_regression import encode

ROOT = Path(__file__).resolve().parents[1]
FILES = ["rtl/ofdm/tx/newdesign/rs_gf.v",
         "rtl/ofdm/tx/newdesign/rs_block_layout.v",
         "rtl/ofdm/tx/newdesign/rs_packet_encoder.v",
         "rtl/ofdm/rx/newdesign/rs_packet_decoder.v",
         "rtl/ofdm/rx/newdesign/fcs_for_data_field.v",
         "rtl/board/ofdm_dma_rx.v", "sim/tb_rs_packets.sv", "sim/tb_rs_control.sv"]


def layout(data_length):
    depth = (data_length + 238) // 239
    short, extra = divmod(data_length, depth)
    return [short + (i < extra) for i in range(depth)]


def encoded_packet(data):
    sizes = layout(len(data))
    rows, start = [], 0
    for size in sizes:
        rows.append(encode(data[start:start+size]))
        start += size
    # Deliberately independent of RTL scatter address arithmetic.
    positions = [(lane, column) for column in range(max(map(len, rows)))
                 for lane, row in enumerate(rows) if column < len(row)]
    return [rows[lane][column] for lane, column in positions], positions


def verify_mapping():
    windows = 0
    for payload in range(1, 1025):
        sizes = layout(payload+4)
        depth = len(sizes)
        lengths = [size+16 for size in sizes]
        order = [(lane, col) for col in range(max(lengths))
                 for lane in range(depth) if col < lengths[lane]]
        assert sum(sizes) == payload+4 and max(sizes) <= 239
        assert max(sizes)-min(sizes) <= 1
        assert len(order) == payload+4+16*depth
        assert len(set(order)) == len(order)
        assert [lane for lane, _ in order] == [i % depth for i in range(len(order))]
        # Every start, every payload: all shorter bursts are subsets of these.
        counts = Counter(lane for lane, _ in order[:8*depth])
        for start in range(len(order)-8*depth+1):
            assert max(counts.values()) == 8
            windows += 1
            if start+8*depth < len(order):
                counts[order[start][0]] -= 1
                counts[order[start+8*depth][0]] += 1
        # 8D+1 errors necessarily exceed one lane's guaranteed capacity.
        assert max(Counter(lane for lane, _ in order[:8*depth+1]).values()) == 9
    return windows


def cases(smoke=False):
    rng = random.Random(0x850255)
    lengths = [1, 235, 236, 474, 475, 713, 714, 952, 953, 1024] if smoke else range(1, 1025)
    for length in lengths:
        payload = bytes(rng.randrange(256) for _ in range(length))
        data = payload + zlib.crc32(payload).to_bytes(4, 'little')
        code, positions = encoded_packet(data)
        depth = len(layout(len(data)))
        yield 'clean', length, 0, True, data, code, code
        # Every codeword at the exact 8-byte correction limit, arbitrary positions/magnitudes.
        damaged = code.copy()
        for lane in range(depth):
            for index in rng.sample([i for i, p in enumerate(positions) if p[0] == lane], 8):
                damaged[index] ^= rng.randrange(1, 256)
        yield 'random_limit', length, 8*depth, True, data, code, damaged
        # Beginning, middle, parity region, final ragged column, all lane phases.
        starts = {0, len(code)//2, len(code)-8*depth}
        starts.update(range(min(depth, len(code)-8*depth+1)))
        if not smoke and length in (1, 236, 475, 714, 953, 1024):
            starts = range(len(code)-8*depth+1)
        elif not smoke and length not in (235, 474, 713, 952):
            starts = [len(code)-8*depth]  # Include tail on every legal payload length.
        for start in sorted(starts):
            damaged = code.copy()
            for index in range(start, start+8*depth):
                damaged[index] ^= rng.randrange(1, 256)
            yield 'burst_limit', length, 8*depth, True, data, code, damaged
        if length in (1, 235, 236, 474, 475, 713, 714, 952, 953, 1024):
            damaged = code.copy()
            for index in range(8*depth+1):
                damaged[index] ^= 0xa7
            yield 'burst_over_limit', length, 8*depth+1, False, data, code, damaged
            # Dispersed 9 errors in ONE lane, even if total errors is below 8D.
            damaged = code.copy()
            for index in [i for i, p in enumerate(positions) if p[0] == 0][:9]:
                damaged[index] ^= 0xa7
            yield 'one_lane_over_limit', length, 9, False, data, code, damaged


def execute(command, log, timeout):
    with log.open('w') as stream:
        subprocess.run(command, stdout=stream, stderr=subprocess.STDOUT,
                       check=True, timeout=timeout)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--smoke', action='store_true')
    parser.add_argument('--workers', type=int, default=4)
    parser.add_argument('--output-dir', type=Path, default=ROOT/'sim/build_rs_interleave')
    args = parser.parse_args()
    if not 1 <= args.workers <= 4:
        parser.error('--workers must be 1..4')
    out = args.output_dir.resolve()
    out.mkdir(parents=True, exist_ok=True)
    result_path = out/'results.json'
    if result_path.exists():
        result_path.unlink()
    started = time.monotonic()
    windows = verify_mapping()
    counts = Counter()
    vectors = list(cases(args.smoke))
    hashes = {str(ROOT/p):hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
              for p in FILES+[str(Path(__file__).relative_to(ROOT)), 'sim/run_rs_regression.py']}
    chunks = [vectors[i::args.workers] for i in range(args.workers)]
    for worker, chunk in enumerate(chunks):
        with (out/f'vectors{worker}.txt').open('w') as stream:
            stream.write(f'{len(chunk)}\n')
            for kind, length, errors, ok, data, code, damaged in chunk:
                counts[kind] += 1
                stream.write(f'{length} {len(code)} {errors} {int(ok)}\n')
                for values in (data, code, damaged):
                    stream.write(' '.join(f'{v:02x}' for v in values)+'\n')
    print(f'MAPPING_PASS windows={windows}; RTL cases={len(vectors)}', flush=True)
    execute(['iverilog', '-g2012', '-Wall', '-s', 'tb_rs_packets',
             '-Ptb_rs_packets.INTERLEAVE=1', '-o', str(out/'test.vvp'),
             *[str(ROOT/p) for p in FILES[:-1]]], out/'compile.log', 60)
    def run_worker(worker):
        log = out/f'run{worker}.log'
        execute(['vvp', str(out/'test.vvp'), f'+VECTORS={out / ("vectors%d.txt" % worker)}'], log, 7200)
        text = log.read_text()
        assert f'RS_REGRESSION_PASS cases={len(chunks[worker])} ' in text
        return text
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:
        text = '\n'.join(pool.map(run_worker, range(args.workers)))
    (out/'run.log').write_text(text)
    for mode in (0, 1):
        execute(['iverilog', '-g2012', '-s', 'tb_rs_control',
                 f'-Ptb_rs_control.INTERLEAVE={mode}', '-o', str(out/f'control{mode}.vvp'),
                 *[str(ROOT/p) for p in FILES[:4]], str(ROOT/FILES[-1])],
                out/f'control{mode}_compile.log', 60)
        execute(['vvp', str(out/f'control{mode}.vvp')], out/f'control{mode}.log', 60)
        assert 'RS_CONTROL_PASS' in (out/f'control{mode}.log').read_text()
    assert all(hashlib.sha256(Path(p).read_bytes()).hexdigest()==h for p,h in hashes.items()), 'Sources changed during regression'
    result = dict(passed=True, smoke=args.smoke, cases=len(vectors), categories=dict(counts),
                  mapping_payload_lengths=1024, burst_windows_checked=windows,
                  max_decode_cycles=max(map(int, re.findall(r'max_decode_cycles=(\d+)', text))),
                  elapsed_s=time.monotonic()-started,
                  scope='balanced RS interleave/deinterleave + FCS + DMA/backpressure; not raw RF BER',
                  source_sha256=hashes)
    result_path.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()