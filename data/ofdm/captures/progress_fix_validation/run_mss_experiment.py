"""Run the MSS-only experiment after its captured boot completes."""
import subprocess
import time
from pathlib import Path

out = Path(__file__).resolve().parent
root = out.parents[2]
deadline = time.monotonic() + 100
while 'PROGRAM_AND_BOOT_PASS' not in (out / 'program_mss1440.log').read_text():
    if time.monotonic() > deadline:
        raise TimeoutError('MSS firmware did not boot')
    time.sleep(0.5)
for mode in ('nodelay', 'nagle'):
    destination = out / f'mss1440_{mode}_20'
    command = ['python3', '-B', str(root / 'host/dma_image_benchmark.py'),
               '192.168.137.10', str(root / 'sim/captures/demo_20261009/demo_source.png'),
               str(destination), '--count', '20']
    if mode == 'nagle':
        command.append('--nagle')
    with destination.with_suffix('.log').open('w') as log:
        subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, check=True)