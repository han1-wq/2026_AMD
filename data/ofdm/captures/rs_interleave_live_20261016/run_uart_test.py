"""Exercise RS block boundaries and 500 random 1000-byte UART/RF returns."""
import hashlib
import json
from pathlib import Path
import sys
import time

out = Path(__file__).resolve().parent
root = out.parents[2]
sys.path.insert(0, str(root / 'host'))
from dma_uart import loopback
from dma_uart_benchmark import benchmark, payload_for
from serial_connection import SerialConnection


def main():
    assert 'PROGRAM_AND_850MHZ_BOOT_PASS' in (out / 'program_capture.log').read_text()
    connection = SerialConnection('/dev/serial/by-id/usb-Xilinx_my_product_desc_0ABC01-if01-port0')
    try:
        print('Connected: ' + connection.open(), flush=True)
        time.sleep(max(0, connection.ready_at - time.monotonic()))
        connection.validate()
        connection.port.reset_input_buffer()
        with (out / 'length_checks.jsonl').open('x', buffering=1) as log:
            for size in (1, 4, 25, 64, 238, 239, 240, 254, 255, 256,
                         477, 478, 479, 512, 716, 717, 718, 955, 956, 957, 999, 1000):
                for repetition in range(3):
                    data = payload_for(repetition, size, 20261016)
                    start = time.monotonic()
                    returned = loopback(connection.port, data, 10)
                    passed = returned == data
                    log.write(json.dumps(dict(size=size, repetition=repetition, success=passed,
                                              elapsed_s=time.monotonic() - start,
                                              tx_sha256=hashlib.sha256(data).hexdigest(),
                                              rx_sha256=hashlib.sha256(returned).hexdigest())) + '\n')
                    assert passed, (size, repetition)
        print('LENGTH_CHECKS_PASS: 66 packets', flush=True)
        result = benchmark(connection.port, out / 'uart_500', count=500, size=1000,
                           timeout=10, seed=20261016)
        print(json.dumps(result, indent=2), flush=True)
        assert result['passed'], result
        print('UART_TEST_PASS', flush=True)
    finally:
        connection.close()


if __name__ == '__main__':
    main()