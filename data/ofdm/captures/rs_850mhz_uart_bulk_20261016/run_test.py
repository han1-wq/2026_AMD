"""Restore verified 850 MHz firmware, probe lengths, then test 2 MB over UART."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time

out = Path(__file__).resolve().parent
root = out.parents[2]
sys.path.insert(0, str(root / 'host'))
from dma_uart import loopback
from dma_uart_benchmark import payload_for
from serial_connection import SerialConnection


def main():
    previous = json.loads((root / 'sim/captures/rs_850mhz_ack100_20261016/artifacts.json').read_text())
    for name, digest in previous.items():
        assert hashlib.sha256(Path(name).read_bytes()).hexdigest() == digest
    src = root / 'build_sw_rs_850mhz_ack100/ofdm_dma/src'
    assert (src / 'main.c').read_bytes() == (root / 'firmware/radio/main.c').read_bytes()
    assert (src / 'link.c').read_bytes() == (root / 'firmware/dma_app/link.c').read_bytes()
    with (out / 'program_capture.log').open('w') as log:
        subprocess.run([sys.executable, '-u', str(out / 'program_and_capture.py')],
                       stdout=log, stderr=subprocess.STDOUT, check=True, timeout=110)
    boot = (out / 'boot.log').read_text(errors='replace')
    for direction in ('TX', 'RX'):
        assert f'Get {direction}_LO_Freq       :850.00 MHz' in boot
    print('PROGRAM_AND_850MHZ_READBACK_PASS', flush=True)
    connection = SerialConnection('/dev/ttyUSB1')
    try:
        connection.open()
        time.sleep(max(0, connection.ready_at - time.monotonic()))
        connection.validate()
        connection.port.reset_input_buffer()
        with (out / 'length_checks.jsonl').open('w', buffering=1) as log:
            for size in (1, 4, 25, 64, 239, 255, 512, 999, 1000):
                for repetition in range(3):
                    data = payload_for(repetition, size, 850)
                    start = time.monotonic()
                    received = loopback(connection.port, data, 10)
                    assert received == data
                    log.write(json.dumps(dict(size=size, repetition=repetition,
                                              success=True, elapsed_s=time.monotonic()-start,
                                              sha256=hashlib.sha256(received).hexdigest()))+'\n')
        print('LENGTH_CHECKS_PASS: 27 packets', flush=True)
    finally:
        connection.close()
    cmd = [sys.executable, '-u', str(root / 'host/dma_uart_benchmark.py'),
           '/dev/ttyUSB1', str(out / 'bulk_2000'), '--count', '2000',
           '--size', '1000', '--timeout', '10', '--seed', '850']
    (out / 'command.json').write_text(json.dumps(cmd, indent=2)+'\n')
    with (out / 'benchmark.log').open('w') as log:
        subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT, check=True)
    print('UART_BULK_TEST_COMPLETE', flush=True)


if __name__ == '__main__':
    main()