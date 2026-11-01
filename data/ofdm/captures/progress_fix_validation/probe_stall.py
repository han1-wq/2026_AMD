"""Diagnostic run; JTAG pauses invalidate benchmark timing for this run."""
import json
from pathlib import Path
import secrets
import subprocess
import sys
import threading

out = Path(__file__).resolve().parent
root = out.parents[2]
sys.path.insert(0, str(root / 'host'))
from dma_image import connect_board
from dma_image_benchmark import transfer

data = (root / 'sim/captures/demo_20261009/demo_source.png').read_bytes()
with connect_board(('192.168.137.10', 5001), 30) as sock:
    for index in range(1, 51):
        paused = threading.Event()

        def inspect():
            paused.set()
            with (out / 'active_stall.log').open('w') as log:
                subprocess.run(['/tools/Xilinx/Vitis/2022.1/bin/xsct',
                                str(out / 'inspect_stall.tcl')],
                               stdout=log, stderr=subprocess.STDOUT, timeout=60)

        timer = threading.Timer(2, inspect)
        timer.start()
        row, _ = transfer(sock, data, secrets.randbits(32), index, 30)
        timer.cancel()
        timer.join()
        print(json.dumps(row), flush=True)
        if paused.is_set() or not row['success']:
            break