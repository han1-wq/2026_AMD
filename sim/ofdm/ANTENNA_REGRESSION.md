# Antenna frequency-response characterization

The RF-chain testbench applies a simulation-only FIR before CFO, overall gain,
and ADC quantization. Its response represents the combined transmit and receive
antenna response about the tuned carrier, with maximum gain at the carrier and
progressively lower gain away from it. It does not simulate radiation patterns,
impedance matching, polarization, or an electromagnetic antenna geometry.

`GAIN` is the total **amplitude** gain at the carrier. `ANTENNA_EDGE_DB` is the
positive attenuation relative to that center at the outermost occupied OFDM
carriers, +/-8.125 MHz (26 * 20 MHz / 64). This is total link attenuation:
for example, 3 dB rolloff in each antenna corresponds to 6 dB combined rolloff.
No automatic power normalization or AGC is applied. A 6 dB rolloff therefore
reduces edge amplitude to approximately half its flat-channel value.

The model uses eight cascaded three-tap sections `[a, 1-2a, a]` at 40 MS/s:

```
a = (1 - 10^(-ANTENNA_EDGE_DB/160)) / (4*sin(pi*8.125/40)^2)
H(f) = exp(-j*8*w) * (1 - 4*a*sin(w/2)^2)^8, w = 2*pi*f/40 MHz
```

The supported range is 0..30 dB. In this range `a` is between zero and 1/4,
so the magnitude is nonnegative and monotonic from center to Nyquist. The
17-tap FIR has 200 ns group delay and 400 ns impulse-response span, shorter
than the 800 ns OFDM cyclic prefix. Zero dB selects an exact zero-delay bypass.
I and Q use the same coefficients. Filter state advances only on converter
samples and continues through the frame tail and interpacket zeros. Only reset
clears it. An optional echo is applied before this filter.

## Run

Use the same Vivado 2022.1 and Icarus environment and generated IP libraries
as the existing amplitude regression. Do not run multiple compilation scripts
concurrently: they share the simulation library in
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build`.

```sh
python3 /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_antenna_regression.py
```

Defaults: `GAINS='1 0.02'`, `EDGES='0 3 6 12 24'`, `PACKETS=1`, `TAG=antenna`.
Both channel-smoothing settings are always tested. The runner prepares the
project, verifies the FIR with Icarus, and builds each smoothing configuration
through the amplitude regression, including the real-IP Viterbi unit and flat
gain-1 baseline. It then reuses the snapshots for the sweep. Runs use 12-bit
saturating, truncating ADC conversion (`ADC_MODE=0`, `ADC_WRAP=0`), `RX_SHIFT=4`,
zero CFO/interference/echo, and the existing 54 Mb/s, 64-byte packet source.
The sweep uses a simulation timeout of 250 microseconds per requested packet;
the general RF testbench retains its default 3 ms timeout.

The CSV is written incrementally to
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build/antenna_results.csv`, with one row
per combination and a link to each raw log. `PASS` requires exact payload,
length, sample-count and FCS checks. Expected decode failures are recorded as
`FAIL` and the sweep continues. Exit zero / `ANTENNA_CHARACTERIZATION_DONE`
means the sweep completed; **it does not mean every case decoded**. The separate
wall-clock guard `WALL_TIMEOUT_S` defaults to 120 seconds per swept case. A
stalled simulator is killed with its launcher process group and recorded as
`ERROR`, not a failed decode. Other simulator errors are also recorded as
`ERROR`. Remaining cases still run, but any `ERROR` makes the final exit status
nonzero. Increase the wall limit on slower hosts or for longer packet runs.
Build/baseline errors stop immediately; they have a separate 900-second limit.

For a single case that must pass (nonzero exit on decode failure):

```sh
python3 /home/amd/ofdm/eeSDR_ofdm_loopback/sim/prepare_xsim.py
TAG=antenna_single GAINS=1 ANTENNA_EDGE_DB=6 CHANNEL_SMOOTH=1 PACKETS=3 \
  bash /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_amplitude_regression.sh
```

For a custom sweep:

```sh
TAG=antenna_custom GAINS='0.02 0.05 1' EDGES='0 3 6 9 12' PACKETS=3 \
  python3 /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_antenna_regression.py
```

These deterministic tests characterize this response family and this payload;
they are not BER measurements, an AWGN sweep, or validation of all PHY rates.
Channel equalization can compensate gain/phase variation, but cannot restore
information lost to ADC quantization or overcome arbitrary edge attenuation.
There is no claim that an arbitrary real antenna has this linear-phase response.

## Observed results (2026-10-06)

Default 20-case sweep, **one packet per case**, under the conditions above:

| Center amplitude gain | Channel smoothing | 0 dB | 3 dB | 6 dB | 12 dB | 24 dB |
|---|---|---|---|---|---|---|
| 1 | Off | PASS | PASS | PASS | FAIL | ERROR |
| 1 | On | PASS | PASS | PASS | FAIL | ERROR |
| 0.02 | Off | FAIL | FAIL | FAIL | ERROR | ERROR |
| 0.02 | On | PASS | FAIL | ERROR | ERROR | ERROR |

Columns are combined antenna attenuation at +/-8.125 MHz relative to center.
All six `FAIL` cases reported `PAYLOAD_MISMATCH`, with no ADC overflow.
All seven `ERROR` cases reached the 120-second **wall-clock** limit without a
completed decode verdict; these are inconclusive, not demonstrated RF failures
or confirmed testbench simulation-time timeouts. Their cause has not been
isolated. The driver attempted all 20 cases and exited **1**, reporting seven
incomplete/error cases. No `ANTENNA_CHARACTERIZATION_DONE` marker was emitted.
The final driver log is `/tmp/antenna_driver.log`; case details and raw log paths
are in `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build/antenna_results.csv`.

At gain 1, both smoothing configurations decoded the 3 dB and 6 dB responses,
but neither decoded the tested 12 dB response. This establishes working points,
not a precise attenuation threshold or a guarantee for arbitrary antennas.
At gain 0.02, smoothing is needed even for the flat baseline, and the tested
3 dB response failed with smoothing enabled. In that comparison the maximum
ADC component code dropped from 11 to 8. Quantization is a plausible limitation,
but these tests alone do not isolate it from synchronization, channel estimation,
or other receiver effects. No claim of a diagnosed failure mechanism is made.

Validation also passed the antenna model's 135 single-tone checks, impulse/DC
gain, tail, reset and bypass checks, plus both builds' existing smoothing,
soft-metric, pilot-rotation, real-IP Viterbi-prefix and CFO-scale unit tests.
This antenna sweep did not establish multi-packet or all-rate coverage.
