"""Program the 850 MHz/100 ms RS build, check LO readback, test 400 images."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

out = Path(__file__).resolve().parent
root = out.parents[2]
source = root / 'sim/captures/demo_20261009/demo_source.png'
workspace = root / 'build_sw_rs_850mhz_ack100'


def main():
    assert '#define RETRY_MS 100\n' in (workspace / 'ofdm_dma/src/link.c').read_text()
    template = (root / 'sim/captures/rs_ack_1s_20261016/program_and_capture.py').read_text()
    helper = template.replace('build_sw_rs_ack1s/', 'build_sw_rs_850mhz_ack100/')
    helper = helper.replace('Program the ACK-1s firmware', 'Program the 850 MHz/100 ms firmware')
    (out / 'program_and_capture.py').write_text(helper)
    with (out / 'program_capture.log').open('w') as log:
        subprocess.run([sys.executable, '-u', str(out / 'program_and_capture.py')],
                       stdout=log, stderr=subprocess.STDOUT, check=True, timeout=110)
    boot = (out / 'boot.log').read_text(errors='replace')
    for direction in ('TX', 'RX'):
        assert f'Get {direction}_LO_Freq       :850.00 MHz' in boot, boot
    print('PROGRAM_AND_850MHZ_READBACK_PASS', flush=True)
    cmd = [sys.executable, '-u', str(root / 'host/dma_image_benchmark.py'),
           '192.168.137.10', str(source), str(out / 'benchmark_400'),
           '--count', '400', '--timeout', '30']
    (out / 'command.json').write_text(json.dumps(cmd, indent=2) + '\n')
    with (out / 'benchmark.log').open('w') as log:
        subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT, check=True)
    directory = out / 'benchmark_400'
    rows = [json.loads(line) for line in (directory / 'results.jsonl').read_text().splitlines()]
    summary = json.loads((directory / 'summary.json').read_text())
    assert summary['attempts'] == 400
    totals = {}
    for row in rows:
        for key, value in row.get('counters', {}).items():
            totals[key] = totals.get(key, 0) + value
    summary.update(counter_totals=totals,
                   rows_with_counters=sum(bool(row.get('counters')) for row in rows),
                   error_messages=[row.get('error') for row in rows if not row['success']],
                   source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
                   tx_lo_hz=850000000, rx_lo_hz=850000000, ack_timeout_ms=100)
    last = directory / 'last_received.png'
    summary['last_image_matches'] = last.exists() and last.read_bytes() == source.read_bytes()
    (out / 'result.json').write_text(json.dumps(summary, indent=2) + '\n')
    print(json.dumps(summary, indent=2), flush=True)
    print('TEST_COMPLETE', flush=True)


if __name__ == '__main__':
    main()