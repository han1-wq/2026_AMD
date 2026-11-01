# Packet-local balanced RS byte block interleaving

## Format

Maintained RTL defaults to `RS_ENABLE=1, RS_INTERLEAVE=1`. Both endpoints must
use identical settings. There is no in-band negotiation or auto-detection.
`RS_INTERLEAVE=0` restores the previous RS full-block/short-tail wire format;
`RS_ENABLE=0` bypasses the entire outer code, regardless of `RS_INTERLEAVE`.
The new format is **not compatible** with the previously programmed RS image
for multi-codeword packets. Existing board images, firmware, QSPI and captured
850 MHz measurements have not been replaced by this source change.

For a user payload of P bytes, let M=P+4 (including CRC32), D=ceil(M/239),
q=floor(M/D), r=M mod D. Split the original M-byte stream into D consecutive
chunks: the first r chunks contain q+1 bytes, the rest q bytes. Encode each
chunk independently using the existing shortened RS(255,239), with 16 parity
bytes. The GF and polynomial conventions are unchanged.

Serialize column 0 from lanes 0..D-1, then column 1, and so on. Codeword lengths
differ by at most one; longer lanes are first. The last partial column contains
only lanes 0..r-1. Thus the lane sequence is exactly `wire_index mod D`, including
the packet tail. There are no dummy bytes or additional parity symbols.

For example, P=1024 gives M=1028, D=5, and data chunk lengths
`206,206,206,205,205`. Codeword lengths are `222,222,222,221,221`, replacing the
old `255,255,255,255,88`. The encoded length remains 1108 bytes. The original
user-byte and CRC ordering is restored before the existing FCS checker.

| User payload P | D | Guaranteed contiguous residual-byte burst |
|---|---:|---:|
| 1..235 | 1 | 8 |
| 236..474 | 2 | 16 |
| 475..713 | 3 | 24 |
| 714..952 | 4 | 32 |
| 953..1024 | 5 | 40 |

## Correction guarantee and its limits

Any interval of B serialized bytes places at most ceil(B/D) bytes in any lane.
Consequently every burst of at most 8D erroneous bytes is correctable, at every
start position, including the shortened tail, **provided there are no additional
errors in those codewords**. Sparse errors inside such an interval also satisfy
the bound. Each RS decoder still corrects at most eight erroneous bytes; this
does not increase the code's per-codeword distance or redundancy.

This attains the maximum *guaranteed contiguous arbitrary-error burst length*
for the existing D independent t=8 codewords, fixed parity overhead and
bounded-distance decoding: 8D+1 errors necessarily put at least nine in a lane.
It is not a claim of globally optimal FEC, maximum random-error performance,
or that every 8D-error pattern is correctable. Nine errors concentrated in a
single lane exceed the guarantee even when their total is below 8D. Bursts
beyond the bound can sometimes be decoded, but cannot be guaranteed; CRC32 is
still required and is not an absolute guarantee against all miscorrections.

The unit is a **byte after Viterbi decoding and descrambling**, not RF samples,
microseconds, OFDM symbols or RF outage duration. Time-domain interference may
also destroy synchronization/SIGNAL or create dispersed residual errors.

## Implementation and interfaces

- TX: CRC → balanced RS encoding → byte interleaving → existing scrambling,
  convolutional encoding and OFDM bit interleaving.
- RX: existing OFDM deinterleaving/Viterbi/descrambling → byte deinterleaving →
  RS correction → FCS → DMA commit.
- No separate stream stage: TX scatter-writes `column*D+lane` into the existing
  encoded packet RAM, then replays linearly. RX scatters the received columns
  into consecutive codeword rows in its existing packet RAM. Correction and
  corrected-payload replay then operate on those rows.
- `/home/amd/ofdm/eeSDR_ofdm_loopback/rtl/ofdm/tx/newdesign/rs_block_layout.v`
  computes balanced shortening with constant divisors only. TX/RX packet modules
  have `INTERLEAVE`; core, wrapper and board expose `RS_INTERLEAVE`.
- Existing no-backpressure contracts remain: start precedes data; TX busy-start
  is unsupported/ignored; RX start replaces an incomplete packet. Reset aborts.
  Valid gaps, length guards and metadata semantics are unchanged.
- No new packet buffer or replay pass. The original serial RX and TX guard
  remain; there is no new overlapping-packet support. SIGNAL length, PHY sample
  budget and host/software framing remain unchanged.
- Project generation accepts `OFDM_RS_INTERLEAVE=0|1` (default 1), independently
  of `OFDM_RS_ENABLE=0|1`. Rebuilding an older project requires updating the board
  module parameters too; changing maintained RTL does not program the board.

## Verification and reproduction

```sh
python3 -B /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_rs_interleave_regression.py
python3 -B /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_rs_regression.py
python3 -B /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_rs_interleave_compat.py
python3 -B /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_rs_interleave_phy.py
/tools/Xilinx/Vivado/2022.1/bin/vivado -mode batch -source /home/amd/ofdm/eeSDR_ofdm_loopback/sim/synth_rs.tcl
bash /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_dma_regression.sh
bash /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_phy_regression.sh
python3 -B -m unittest discover -s /home/amd/ofdm/eeSDR_ofdm_loopback/host -p 'test_*.py' -v
python3 -B /home/amd/ofdm/eeSDR_ofdm_loopback/sim/verify_rs_interleave_results.py
```

The real-IP runner requires generated IP in
`/home/amd/ofdm/eeSDR_ofdm_loopback/build_hw/ip` and Vivado 2022.1. It creates
isolated XSim libraries, limits concurrency to two, and never downloads hardware.
`--resume` reuses a case only when it passed with exactly matching source hashes.
Only the current invocation's selected cases enter the aggregate result.
The original runner deliberately exits nonzero when the old-format RF dropout
fails. Preserve that result; the independent verifier classifies the specific
observed reference failure separately instead of silently treating it as a
successful decode. A subset invocation is not a complete regression.

For the completed run, the slow clean-rate scan was finished with two isolated
per-rate workers using
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/finish_rs_interleave_phy.py --wait-rate6`.
This helper requires the sequential driver to be stopped first, validates the
baseline source hashes, waits for an already-running clean 6 Mbps snapshot,
then copies only completed per-rate logs into the aggregate. The provenance is
recorded in
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs_interleave/parallel_rates.json`.

The byte-level runner uses up to four independent Icarus processes (`--workers
1..4`). It compares TX output against independent Python polynomial division
and nested column/lane traversal, not a second copy of RTL address logic. RX is
fed independently generated damaged reference bytes, so a matching TX/RX bug
cannot make a round-trip silently pass. Actual FCS and DMA output are checked.

Coverage:

- All 1024 user lengths; mapping bijection, equalized shortening, parity budget,
  and all 551,888 possible 8D-byte burst windows checked in the reference model.
- 6,693 RTL packet cases: clean and eight random errors/lane at every length;
  tail bursts at every length; every 8D-byte burst start for payloads
  1,236,475,714,953,1024; additional transition-boundary cases; 8D+1-byte bursts
  and nine-errors-in-one-lane rejection examples. Nonzero error magnitudes are
  seeded and reproducible. Over-limit rejection is empirical for these vectors,
  not a proof that CRC catches every possible uncorrectable word.
- Control checks in both modes: every invalid 12-bit RX length and 11-bit TX
  length; RX reset during capture/syndrome/BM/Chien/replay; packet replacement
  across one- and five-lane frames; TX reset in capture/parity/replay for data
  lengths 5,240,1028; recovery and consecutive frames. Existing input-valid gaps
  and downstream DMA backpressure are exercised.
- A separate 22-case compatibility test checks unchanged single-codeword wire
  format in both directions and CRC/DMA rejection of selected mismatched-mode
  multi-codeword packets. Peers must still be configured identically; rejection
  of these examples is not an automatic format negotiation mechanism.
- Real FFT/Viterbi PHY: 1..5 lanes, 6/54 Mbps correction boundaries, consecutive
  max-size packets, 40-byte correction versus old-mode rejection, 41-byte
  rejection, legacy RS and full RS bypass, 300 Hz CFO/interference, and clean
  maximum-size packets at all eight PHY rates. Controlled byte faults enter
  before byte deinterleaving, after real Viterbi/descrambling.
- Separate time-domain trials zero 16 converter samples (0.4 us at 40 MS/s)
  starting at sample 1000 of a max-size 54 Mbps frame in each mode, without
  residual-byte injection. This fixed dropout is a limited channel regression,
  not a statistical BER/PER/SNR comparison or worst-case RF guarantee.
  The interleaved frame recovered correctly. The noninterleaved reference
  produced `PAYLOAD_MISMATCH index=113 got=e8` and stopped at the testbench's
  payload assertion, before FCS/DMA completion. Its raw result remains
  `passed:false`; do not interpret it as a completed DMA rejection test. The
  final verifier reports this separately as observed reference degradation,
  while requiring every other PHY case to pass.

Results, pass markers and source SHA-256 evidence are written under:

- `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs_interleave/results.json`
- `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs_interleave/phy_results.json`
- `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs_interleave_phy_*/`
- `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs_interleave_synth/`

The independent result verifier checks complete case/rate/packet counts, current
source hashes, pass markers, both control modes, compatibility results, and
routed setup/hold timing. It writes
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs_interleave/verified_summary.json`
only after every required check succeeds.

An earlier log, launched process or partial case list is not evidence of a
complete passing current regression. Check aggregate results and their hashes.

## Standalone implementation check

Vivado 2022.1, xc7z020clg400-2, 80 MHz, out-of-context routed results:

| Module | LUT | FF | Slice | RAMB18 | DSP | WNS | WHS |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Encoder + interleaver | 504 | 235 | 164 | 2 | 0 | +4.551 ns | +0.141 ns |
| Deinterleaver + decoder | 1294 | 969 | 472 | 1 | 0 | +3.515 ns | +0.147 ns |

BRAM counts match the previous noninterleaved implementation. These are
standalone internal timing results, not full-board resource/timing closure.
OOC I/O paths are unconstrained; standalone missing-PS7 advisories apply.
The old board timing and UART/RF captures do **not** validate this new format.

## Completed byte-level results

The full current RTL run passed 6,693/6,693 packet cases: 1,024 clean, 1,024
random eight-errors-per-lane, 4,625 at-limit contiguous bursts, and 20 selected
over-limit rejection cases. Both control modes passed. Maximum observed decode
time from last input byte to FCS was 12,702 clocks = 158.775 us at 80 MHz,
excluding upstream Viterbi/PHY delay. The existing 32768-clock TX guard was not
changed. This is a measured maximum over the suite, not a formal whole-chain
worst-case latency bound.

The 204-case old-format RS regression and 22 compatibility cases passed, as did
the DMA regression (including 27 DMA host tests), all 50 host tests, and six
AD936x interface scenarios. Full real-IP completion must additionally be
confirmed in the current PHY aggregate and independent verified summary.

## Completed real-IP verification and final acceptance

The independent verifier completed successfully with the current source hashes:

- 14 PHY scenarios, expanded to 21 rate/scenario combinations.
- 20 combinations reached the complete PHY/FCS/DMA pass marker, covering
  21 fully checked packets (one scenario contains two consecutive packets).
- All eight rates `6,9,12,18,24,36,48,54` Mbps recovered clean 1024-byte payloads.
- 1..5 lane burst limits, 40-byte correction at 6/54 Mbps, ragged packet-tail
  protection, 41-byte rejection, old-mode 40-byte rejection, old RS correction,
  full RS bypass, and 300 Hz CFO/interference plus a 40-byte burst completed.
- The interleaved time-domain dropout recovered. The one noninterleaved
  reference-degradation trial failed the payload assertion as described above.
  The raw aggregate therefore honestly records `passed:false`; the independent
  acceptance summary records `passed:true` **with** that explicit
  `reference_degradation` entry. It does not claim every raw scenario passed.

The final verified summary is
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs_interleave/verified_summary.json`.
The byte-level, real-IP, compatibility, supporting-regression and OOC artifacts
remain separate. All new Python scripts pass syntax checks; the modified shell
runner passes `bash -n`, and the tracked edited files pass `git diff --check`.

No full-board build, bitstream download, firmware update, QSPI write or radio
frequency change was performed. Board qualification and statistical RF BER/PER
comparisons remain future work; this result does not certify the previous
850 MHz board image as containing the new interleaver.