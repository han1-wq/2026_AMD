"""Repeatable UART antenna test; stores every TX/RX and separates timeouts."""
import argparse
import json
from pathlib import Path
import random
import sys
import time

import serial

sys.path.insert(0, str(Path(__file__).resolve().parents[3] / 'host'))
import serial_packet as sp

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--port', default=sp.DEFAULT_PORT)
parser.add_argument('--count', type=int, default=200)
parser.add_argument('--output', required=True)
args = parser.parse_args()
results = []
with serial.Serial(args.port, 115200, timeout=.1, write_timeout=1, exclusive=True) as port:
    for index in range(args.count):
        rng = random.Random(index)
        tx = bytes(range(64)) if index < 20 else bytes(rng.getrandbits(8) for _ in range(64))
        seq = index % 256
        result = dict(index=index, seq=seq, tx=tx.hex())
        try:
            port.reset_input_buffer()
            port.write(sp.frame(tx, seq))
            status, flags, length, rx = sp.receive(port, seq)
            result.update(status=status, flags=flags, length=length, rx=rx.hex(),
                          passed=status == 0 and flags == 3 and length == 64 and rx == tx)
            if length == 64 and not (flags & 0x10):
                result['bit_errors'] = sum(bin(a ^ b).count('1') for a, b in zip(tx, rx))
        except (TimeoutError, ValueError, serial.SerialException) as exc:
            result.update(passed=False, error=str(exc))
        results.append(result)
        with open(args.output, 'w') as out:
            json.dump(results, out, indent=2)
        if not result['passed'] or (index + 1) % 20 == 0:
            print('completed={} passed={}'.format(index + 1, sum(r['passed'] for r in results)), flush=True)
        time.sleep(.05)
print('PACKET_RESULT total={} passed={} bit_errors={}'.format(
    len(results), sum(r['passed'] for r in results), sum(r.get('bit_errors', 0) for r in results)))
sys.exit(0 if all(r['passed'] for r in results) else 1)