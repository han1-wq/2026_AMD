#!/usr/bin/env python3
"""Independent polynomial-division reference versus RTL encoder/decoder/FCS/DMA."""
import json
from pathlib import Path
import random
import subprocess
import zlib

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "sim/build_rs"


def tables():
    exp = []
    x = 1
    for _ in range(255):
        exp.append(x)
        x <<= 1
        if x & 256:
            x ^= 0x11D
    log = {v: i for i, v in enumerate(exp)}
    return exp, log


EXP, LOG = tables()


def mul(a, b):
    return EXP[(LOG[a] + LOG[b]) % 255] if a and b else 0


def generator():
    g = [1]
    for root in EXP[:16]:
        new = [0] * (len(g) + 1)
        for i, v in enumerate(g):
            new[i] ^= v
            new[i + 1] ^= mul(v, root)
        g = new
    return g


G = generator()


def encode(data):
    result = []
    for offset in range(0, len(data), 239):
        block = list(data[offset:offset + 239])
        work = block + [0] * 16
        for i in range(len(block)):
            coefficient = work[i]
            for j, g in enumerate(G):
                work[i + j] ^= mul(coefficient, g)
        code = block + work[-16:]
        for root in EXP[:16]:
            value = 0
            for byte in code:
                value = mul(value, root) ^ byte
            assert value == 0
        result.extend(code)
    return result


def make_cases():
    rng = random.Random(0x255239)
    cases = []
    lengths = [1, 2, 16, 64, 234, 235, 236, 238, 239, 240,
               474, 475, 476, 713, 714, 952, 953, 1024]
    for length in lengths:
        for errors in [0, 1, 2, 4, 8, 9]:
            payload = bytes(rng.randrange(256) for _ in range(length))
            data = payload + zlib.crc32(payload).to_bytes(4, "little")
            code = encode(data)
            damaged = code.copy()
            total = 0
            for offset in range(0, len(code), 255):
                size = min(255, len(code) - offset)
                positions = rng.sample(range(size), errors)
                for pos in positions:
                    damaged[offset + pos] ^= rng.randrange(1, 256)
                total += errors
            cases.append((length, total, errors <= 8, data, code, damaged))
    # Explicit leading/trailing/parity-only and contiguous burst patterns.
    for length in [1, 235, 236, 1024]:
        for pattern in ["first", "last", "parity", "burst"]:
            payload = bytes((i * 37 + 91) & 255 for i in range(length))
            data = payload + zlib.crc32(payload).to_bytes(4, "little")
            code = encode(data)
            damaged = code.copy()
            total = 0
            for offset in range(0, len(code), 255):
                size = min(255, len(code) - offset)
                positions = {"first": [0], "last": [size-1],
                             "parity": list(range(size-8, size)),
                             "burst": list(range(8))}[pattern]
                for pos in positions:
                    damaged[offset+pos] ^= 0xA7
                    total += 1
            cases.append((length, total, True, data, code, damaged))
    # Additional seeded random packet sizes and 0..8 errors per codeword.
    for _ in range(80):
        length = rng.randrange(1, 1025)
        payload = bytes(rng.randrange(256) for _ in range(length))
        data = payload + zlib.crc32(payload).to_bytes(4, "little")
        code = encode(data)
        damaged = code.copy()
        total = 0
        for offset in range(0, len(code), 255):
            size = min(255, len(code)-offset)
            errors = rng.randrange(9)
            for pos in rng.sample(range(size), errors):
                damaged[offset+pos] ^= rng.randrange(1, 256)
            total += errors
        cases.append((length, total, True, data, code, damaged))
    return cases


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    if (OUT / "results.json").exists():
        (OUT / "results.json").unlink()
    cases = make_cases()
    with (OUT / "vectors.txt").open("w") as f:
        f.write(f"{len(cases)}\n")
        for length, errors, ok, data, code, damaged in cases:
            f.write(f"{length} {len(code)} {errors} {int(ok)}\n")
            for stream in [data, code, damaged]:
                f.write(" ".join(f"{x:02x}" for x in stream) + "\n")
    files = ["rtl/ofdm/tx/newdesign/rs_gf.v",
             "rtl/ofdm/tx/newdesign/rs_packet_encoder.v",
             "rtl/ofdm/rx/newdesign/rs_packet_decoder.v",
             "rtl/ofdm/tx/newdesign/rs_block_layout.v",
             "rtl/ofdm/rx/newdesign/fcs_for_data_field.v",
             "rtl/board/ofdm_dma_rx.v", "sim/tb_rs_packets.sv"]
    with (OUT / "compile.log").open("w") as log:
        subprocess.run(["iverilog", "-g2012", "-Wall", "-s", "tb_rs_packets",
                        "-o", str(OUT / "test.vvp"),
                        *[str(ROOT / p) for p in files]],
                       stdout=log, stderr=subprocess.STDOUT, check=True)
    with (OUT / "run.log").open("w") as log:
        subprocess.run(["vvp", str(OUT / "test.vvp"),
                        f"+VECTORS={OUT / 'vectors.txt'}"],
                       stdout=log, stderr=subprocess.STDOUT, check=True, timeout=180)
    text = (OUT / "run.log").read_text()
    assert "RS_REGRESSION_PASS" in text, text[-2000:]
    subprocess.run(["iverilog", "-g2012", "-s", "tb_rs_control", "-o",
                    str(OUT / "control.vvp"), str(ROOT / files[0]),
                    str(ROOT / files[3]),
                    str(ROOT / files[1]), str(ROOT / files[2]),
                    str(ROOT / "sim/tb_rs_control.sv")], check=True)
    with (OUT / "control.log").open("w") as log:
        subprocess.run(["vvp", str(OUT / "control.vvp")], stdout=log,
                       stderr=subprocess.STDOUT, check=True, timeout=30)
    assert "RS_CONTROL_PASS" in (OUT / "control.log").read_text()
    result = {"cases": len(cases), "pass": True, "seed": "0x255239",
              "correctable_cases": sum(c[2] for c in cases),
              "over_limit_cases": sum(not c[2] for c in cases),
              "generator": bytes(G).hex(),
              "scope": "RTL RS TX/RX + CRC32 + DMA commit/backpressure"}
    (OUT / "results.json").write_text(json.dumps(result, indent=2) + "\n")
    print(text[-1500:])
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()