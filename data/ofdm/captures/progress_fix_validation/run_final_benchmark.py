"""Capture TCP socket diagnostics alongside the final, unpaused benchmarks."""
import json
from pathlib import Path
import subprocess
import time

out = Path(__file__).resolve().parent
root = out.parents[2]
deadline = time.monotonic() + 100
while 'PROGRAM_AND_BOOT_PASS' not in (out / 'program_tcp_fix.log').read_text():
    if time.monotonic() > deadline:
        raise TimeoutError('Final firmware did not boot')
    time.sleep(0.5)
for mode, count in [('nodelay', 20), ('nagle', 20), ('nodelay', 200)]:
    destination = out / f'final_{mode}_{count}'
    command = ['python3', '-B', str(root / 'host/dma_image_benchmark.py'),
               '192.168.137.10', str(root / 'sim/captures/demo_20261009/demo_source.png'),
               str(destination), '--count', str(count)]
    if mode == 'nagle':
        command.append('--nagle')
    with destination.with_suffix('.log').open('w') as log, \
            destination.with_suffix('.ss.log').open('w') as sockets:
        process = subprocess.Popen(command, stdout=log, stderr=subprocess.STDOUT)
        while process.poll() is None:
            sockets.write(f'{time.monotonic():.6f}\n')
            subprocess.run(['ss', '-tin', 'dst', '192.168.137.10'],
                           stdout=sockets, stderr=subprocess.STDOUT, check=True)
            sockets.flush()
            time.sleep(0.2)
        if process.returncode:
            raise RuntimeError(f'Benchmark exited {process.returncode}')
    summary = json.loads((destination / 'summary.json').read_text())
    print(destination.name, summary['successes'], summary['failures'], flush=True)