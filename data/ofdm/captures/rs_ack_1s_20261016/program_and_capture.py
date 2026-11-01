"""Program the ACK-1s firmware with the unchanged RS bitstream and capture boot."""
import hashlib
import json
from pathlib import Path
import subprocess
import time

import serial

out = Path(__file__).resolve().parent
root = out.parents[2]
artifacts = [root / 'build_rs_board/ofdm_ad9361.runs/impl_1/TOP.bit',
             root / 'build_sw_rs_ack1s/ofdm_dma/Debug/ofdm_dma.elf',
             root / 'build_sw_rs_ack1s/dma_platform/hw/ps7_init.tcl',
             root / 'build_rs_board/TOP.xsa']
(out / 'artifacts.json').write_text(json.dumps({str(p): hashlib.sha256(p.read_bytes()).hexdigest()
                                             for p in artifacts}, indent=2) + '\n')
with serial.Serial('/dev/ttyUSB1', 115200, timeout=0.1, exclusive=True) as port:
    port.reset_input_buffer()
    with (out / 'program.log').open('w') as log, (out / 'boot.log').open('wb') as boot:
        process = subprocess.Popen(['/tools/Xilinx/Vitis/2022.1/bin/xsct',
                                    str(root / 'firmware/program_dma.tcl'),
                                    *map(str, artifacts[:3])], stdout=log, stderr=subprocess.STDOUT)
        captured = bytearray()
        deadline = time.monotonic() + 90
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