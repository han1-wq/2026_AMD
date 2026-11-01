import subprocess
import time
from pathlib import Path
import serial

out = Path(__file__).resolve().parent
release = out.parents[2] / 'release_dma'
with serial.Serial('/dev/ttyUSB1', 115200, timeout=0.1, exclusive=True) as port:
    port.reset_input_buffer()
    with (out / 'program.log').open('w') as log:
        process = subprocess.Popen([
            '/tools/Xilinx/Vitis/2022.1/bin/xsct',
            str(release / 'program_dma.tcl'), str(release / 'TOP.bit'),
            str(release / 'ofdm_dma_board10.elf'), str(release / 'ps7_init.tcl'),
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
                    print(data.decode('utf-8', errors='replace'), end='', flush=True)
                if process.poll() is not None:
                    if process.returncode:
                        raise RuntimeError(f'Programming failed: {process.returncode}')
                    if b'DMA ready:' in captured:
                        break
            else:
                process.terminate()
                raise TimeoutError('No DMA ready boot message within 90 seconds')
        print('\nPROGRAM_AND_BOOT_PASS', flush=True)