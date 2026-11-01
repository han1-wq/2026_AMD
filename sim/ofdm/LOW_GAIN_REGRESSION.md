# Low-gain receiver regression

The DATA decoder prepends 84 unpunctured, high-confidence zero bits to establish
the convolutional encoder's known zero history, then discards exactly 84 decoder
outputs. This matches the generated Viterbi IP's traceback length. Prefix pairs
use the same elastic AXIS stage as DATA; they do not count against the frame
length. A packet reset restarts both prefix counters.

The receiver also preserves FFT/equalizer/pilot-rotation precision and 64-QAM
soft confidence through deinterleaving. Channel smoothing uses five binomial
weights `[1,4,6,4,1]/16`, replicating band edges and never crossing DC.

## Reproduction

Use Vivado 2022.1 and Icarus Verilog in the shell environment. The existing
simulation project and generated IP libraries must be prepared first:

```sh
python3 /home/amd/ofdm/eeSDR_ofdm_loopback/sim/prepare_xsim.py
TAG=low_gain PACKETS=3 CHANNEL_SMOOTH=1 \
  bash /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_amplitude_regression.sh
```

The default gain list is `0.02 0.03 0.05 0.075 0.1 0.25 0.3 0.4 0.5 0.75
1.0 1.25 1.5 2.0 3.0 3.5`. Each packet uses 54 Mb/s (64-QAM, rate 3/4),
64 payload bytes, and `RX_SHIFT=4`. The test checks every payload byte, FCS,
packet length, sample cadence, and transmitted sample count.

The script additionally runs:

- Channel estimation/equalization: smoothing off/on, 208 carriers per setting.
- Soft metrics/deinterleaving: CSI/DATA widths 16/32 and 25/51, all eight rates,
  1656 pairs per width, including frontend backpressure.
- Pilot rotation: 4050 comparisons.
- Coarse/fine CFO scaling: 65536 samples and five boundary checks each.
- Actual Viterbi IP: 16 frames / 4968 bits across all eight rates, puncturing,
  input gaps, repeated resets, and ambiguous first-bit observations.

## Channel and converter controls

`CHANNEL_SMOOTH=0` bypasses frequency smoothing. In the deterministic flat
channel with truncation (`ADC_MODE=0`), gain 0.02 fails without smoothing
(payload byte 5), while gain 0.03 passes. With rounded quantization
(`ADC_MODE=1`), gain 0.02 passes with either smoothing setting.

`ECHO_GAIN` adds a real-valued delayed copy of the transmitted I/Q samples.
`ECHO_DELAY` is 1..32 converter samples at 40 MS/s, including the echo tail
after transmission. At gain 1 and echo gain 0.25:

| Echo delay | Smoothing off | Smoothing on |
| --- | --- | --- |
| 4 samples (100 ns) | PASS | PASS |
| 16 samples (400 ns) | PASS | FAIL at payload byte 50 |

Use smoothing bypass for sharply frequency-selective channels. These cases
demonstrate a tradeoff; they do not establish a general multipath performance
bound. Example:

```sh
TAG=echo_bypass GAINS=1 CHANNEL_SMOOTH=0 ECHO_GAIN=0.25 ECHO_DELAY=16 \
  bash /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_amplitude_regression.sh
```

Gain 1 with CFO 300 Hz and deterministic alternating interference of 2 ADC
codes passes with both smoothing settings.

The converter now saturates at -2048/2047 by default. `ADC_WRAP=1` reproduces
the former overflow-wrap diagnostic. Gain 3.5 has no overflow in the flat
channel; gain 3.6 reaches 2084 and the wrap model fails with either smoothing
setting. `ADC_MODE=2` preserves fractional converter codes for isolation only;
it is not a realizable 12-bit ADC and is not used to qualify low-gain reception.

These are deterministic RTL simulations with generated IP models, not BER
measurements or hardware validation. Timing, resource usage, and a new board
release still require the flow in
[BUILD_RELEASE.md](/home/amd/ofdm/eeSDR_ofdm_loopback/BUILD_RELEASE.md).