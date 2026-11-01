"""Evaluate the stored FIR coefficient pair at the 40 MS/s OFDM bins."""
import cmath
import math
from pathlib import Path
import re

root = Path(__file__).resolve().parents[3]
source = root / 'build_80m_neighbor_v6/Vitis/AD936x_PS/src/main.c'
text = source.read_text()
responses = []
for name in ('rx_fir_config', 'tx_fir_config'):
    block = text.split(name + ' = {', 1)[1]
    coefficient_text = block.split('{', 1)[1].split('}', 1)[0]
    coefficients = [int(x) for x in re.findall(r'-?\d+', coefficient_text)]
    # The configured 64 taps include trailing zeros; the remaining 64 are zero too.
    assert len(coefficients) == 128 and not any(coefficients[64:])
    responses.append([
        abs(sum(c * cmath.exp(-2j * math.pi * k * n / 64)
                for n, c in enumerate(coefficients[:64]))) / abs(sum(coefficients[:64]))
        for k in range(27)
    ])
print('bin,frequency_MHz,RX_dB,TX_dB,combined_dB (relative to DC)')
for k in range(20, 27):
    rx = 20 * math.log10(responses[0][k])
    tx = 20 * math.log10(responses[1][k])
    print('{},{:.3f},{:.2f},{:.2f},{:.2f}'.format(k, k * 40 / 64, rx, tx, rx + tx))