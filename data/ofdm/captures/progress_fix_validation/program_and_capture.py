"""Program the verified progress-fix pair and retain its serial boot log."""
import subprocess
import sys
import time
from pathlib import Path

import serial

out = Path(__file__).resolve().parent
root = out.parents[2]
sw = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else root / 'build_dma_sw_progress_matched'
if len(sys.argv) > 2:
    out = Path(sys.argv[2]).resolve()
    out.mkdir(exist_ok=False)
with serial.Serial('/dev/ttyUSB1', 115200, timeout=0.1, exclusive=True) as port:
    port.reset_input_buffer()
    with (out / 'program.log').open('w') as log:
        process = subprocess.Popen([
            '/tools/Xilinx/Vitis/2022.1/bin/xsct',
            str(root / 'firmware/program_dma.tcl'),
            str(root / 'build_dma_progress_fix/ofdm_ad9361.runs/impl_1/TOP.bit'),
            str(sw / 'ofdm_dma/Debug/ofdm_dma.elf'),
            str(sw / 'dma_platform/hw/ps7_init.tcl'),
        ], stdout=log, stderr=subprocess.STDOUT)
        captured = bytearray()
        deadline = time.monotonic() + 90
        with (out / 'boot.log').open('wb') as boot:
            while time.monotonic() < deadline:
                data = port.read(4096)
                if data:
                    captured.extend(data)
                    boot.write(data)
                    boot.flush()
                if process.poll() is not None:
                    if process.returncode:
                        raise RuntimeError(f'Programming failed: {process.returncode}')
                    if b'DMA ready:' in captured:
                        break
            else:
                process.terminate()
                raise TimeoutError('No DMA ready boot message within 90 seconds')
        print(captured.decode('utf-8', errors='replace'))
        print('PROGRAM_AND_BOOT_PASS', flush=True)