#!/usr/bin/env python3
"""Check unchanged single-lane format and CRC/DMA rejection of mixed peer modes."""
import hashlib
import json
from pathlib import Path
import random
import zlib

from run_rs_regression import encode
from run_rs_interleave_regression import encoded_packet, execute, FILES, ROOT


def main():
    out = ROOT/'sim/build_rs_interleave_compat'
    out.mkdir(parents=True, exist_ok=True)
    result_path = out/'results.json'
    if result_path.exists():
        result_path.unlink()
    sources = [ROOT/p for p in FILES] + [Path(__file__), ROOT/'sim/run_rs_interleave_regression.py',
                                       ROOT/'sim/run_rs_regression.py']
    hashes = {str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in sources}
    rng = random.Random(0x850)
    cases = []
    for length in (1, 64, 235, 236, 474, 475, 713, 714, 952, 953, 1024):
        payload = bytes(rng.randrange(256) for _ in range(length))
        data = payload + zlib.crc32(payload).to_bytes(4, 'little')
        legacy = encode(data)
        interleaved, _ = encoded_packet(data)
        assert (legacy==interleaved) == (length<=235)
        cases.append((length, data, legacy, interleaved))
    for mode in (0, 1):
        vectors = out/f'vectors{mode}.txt'
        with vectors.open('w') as stream:
            stream.write(f'{len(cases)}\n')
            for length, data, legacy, interleaved in cases:
                code, received = (interleaved, legacy) if mode else (legacy, interleaved)
                stream.write(f'{length} {len(code)} 0 {int(length<=235)}\n')
                for values in (data, code, received):
                    stream.write(' '.join(f'{v:02x}' for v in values)+'\n')
        execute(['iverilog', '-g2012', '-s', 'tb_rs_packets',
                 f'-Ptb_rs_packets.INTERLEAVE={mode}', '-o', str(out/f'test{mode}.vvp'),
                 *[str(ROOT/p) for p in FILES[:-1]]], out/f'compile{mode}.log', 60)
        execute(['vvp', str(out/f'test{mode}.vvp'), f'+VECTORS={vectors}'], out/f'run{mode}.log', 60)
        assert 'RS_REGRESSION_PASS cases=11 accepted=3 rejected=8' in (out/f'run{mode}.log').read_text()
    assert all(hashlib.sha256(Path(p).read_bytes()).hexdigest()==h for p,h in hashes.items())
    result = dict(passed=True, cases=22, single_lane_compatible=6, mixed_mode_rejected=16,
                  source_sha256=hashes)
    result_path.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()