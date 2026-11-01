"""Download the matching active RS-interleaved build over JTAG and capture boot."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time
import zipfile

out = Path(__file__).resolve().parent
root = out.parents[2]
sys.path.insert(0, str(root / 'host'))
from serial_connection import SerialConnection


def main():
    verified = json.loads((root / 'build_hw/interleave_build_verified.json').read_text())
    for name, digest in verified['sha256'].items():
        assert hashlib.sha256(Path(name).read_bytes()).hexdigest() == digest, name
    artifacts = [root / 'build_hw/TOP.bit',
                 root / 'build_sw/ofdm_dma/Debug/ofdm_dma.elf',
                 root / 'build_sw/dma_platform/hw/ps7_init.tcl',
                 root / 'build_hw/TOP.xsa']
    with zipfile.ZipFile(artifacts[3]) as archive:
        assert archive.read('ps7_init.tcl') == artifacts[2].read_bytes()
    (out / 'artifacts.json').write_text(json.dumps(
        {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in artifacts}, indent=2) + '\n')
    connection = SerialConnection('/dev/serial/by-id/usb-Xilinx_my_product_desc_0ABC01-if01-port0')
    process = None
    try:
        connection.open()
        connection.port.reset_input_buffer()
        with (out / 'program.log').open('w') as log, (out / 'boot.log').open('wb') as boot:
            command = ['/tools/Xilinx/Vitis/2022.1/bin/xsct',
                       str(root / 'firmware/program_dma.tcl'), *map(str, artifacts[:3])]
            (out / 'program_command.json').write_text(json.dumps(command, indent=2) + '\n')
            process = subprocess.Popen(command, stdout=log, stderr=subprocess.STDOUT)
            captured = bytearray()
            deadline = time.monotonic() + 90
            while time.monotonic() < deadline:
                data = connection.port.read(4096)
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
                raise TimeoutError('No DMA ready boot message within 90 seconds')
        text = captured.decode('utf-8', errors='replace')
        print(text, flush=True)
        for direction in ('TX', 'RX'):
            assert f'Get {direction}_LO_Freq       :850.00 MHz' in text
        assert 'DMA_PROGRAMMED_AND_RUNNING' in (out / 'program.log').read_text()
        print('PROGRAM_AND_850MHZ_BOOT_PASS', flush=True)
    finally:
        connection.close()
        if process is not None and process.poll() is None:
            process.terminate()
            process.wait(timeout=10)


if __name__ == '__main__':
    main()