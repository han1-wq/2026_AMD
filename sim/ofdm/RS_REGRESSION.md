# RS(255,239) outer FEC

> Update: maintained RTL now defaults to balanced packet-local byte interleaving.
> See `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/RS_INTERLEAVE.md` for the new format,
> compatibility switch, proof and regression evidence. The D=1 format and measured
> board/PHY results below describe the **earlier noninterleaved revision**.
> `RS_INTERLEAVE=0` selects that old format; historical board captures do not
> certify the new interleaved revision.

## Format and integration

- TX: payload → CRC32 → shortened RS → existing scrambling/convolutional PHY.
- RX: existing Viterbi/descrambler → RS correction → CRC32 → DMA commit.
- GF(256), primitive polynomial `0x11d`, alpha=2, roots alpha^0 through alpha^15.
- Systematic code, highest-degree symbol first. Descending generator coefficients:
  `01 3b 0d 68 bd 44 d1 1e 08 a3 41 29 e5 62 32 24 3b`.
- Split payload+CRC into at most 239-byte blocks, append 16 parity bytes each.
  The final short block is equivalent to zero-prefix shortening. No additional
  byte interleaver (D=1). CRC bytes may straddle a block boundary.
- User lengths remain 1..1024 bytes. Encoded SIGNAL length is
  `payload+4+16*ceil((payload+4)/239)`, maximum 1108. RX removes parity and CRC
  before DMA; software packet format is unchanged.
- Legacy PHY helpers add four to their length argument: TX supplies encoded
  length minus four, not the original user length.
- Mother-code store expanded to 9072 pairs; maximum 6 Mbps frame is 371 DATA
  symbols. RX carrier store and TX constellation store expanded to 17808;
  TX sample-count bound updated.
- Compile-time `RS_ENABLE` defaults to 1 on board, TX wrapper/core and RX.
  `OFDM_RS_ENABLE=0` in the project-build environment selects bypass. Both peers
  must agree; there is no in-band mode negotiation. RS mode is a custom PSDU
  format, not interoperable with an ordinary 802.11 CRC-only peer.

## Contracts and limitations

- Single packet buffers, synchronous single-clock operation, no overlap queue.
  TX wrapper accepts arbitrary ingress gaps then replays contiguously to CRC.
  Encoder `s_start` precedes valid input; start while busy is unsupported/ignored.
  Encoder accepts 5..1028 bytes. Reset aborts a packet.
- Decoder `s_start` precedes bytes and replaces an unfinished packet; new detected
  preamble resets decoder and FCS. Invalid lengths are rejected with `failed`, no
  corrected output; downstream DMA discards on replacement or its timeout.
- Decoder uses Berlekamp–Massey, Chien search, Forney and syndrome recheck.
  `failed` is sticky until reset/new packet. `corrected` counts attempted nonzero
  symbol corrections, meaningful as successful corrections only for accepted
  packets. RX gates CRC success with `!failed`; bytes before FCS are speculative.
- At most eight erroneous bytes **per codeword** are guaranteed correctable.
  More errors can miscorrect to another valid codeword. CRC32 provides the final
  check, not an absolute mathematical guarantee against all undetected errors.
- Test-observed maximum decoder time from last input byte through FCS is 12668
  clocks (158.35 us at 80 MHz); this excludes upstream PHY/Viterbi latency.
- TX enforces a 32768-clock guard after RF completion (409.6 us at 80 MHz).
  `done` still indicates RF completion, but `busy` remains asserted and
  `cmd_ready` remains low during the guard. It trades throughput for serial RX
  processing margin. External transmitters must also respect receiver latency.
- No claim of BER/SNR gain follows from post-Viterbi byte injection alone.
  Full-board resource/timing closure and over-the-air tests remain required.

## Reproduce

```sh
python3 /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_rs_regression.py
export PATH=/tools/Xilinx/Vivado/2022.1/bin:$PATH
python3 /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_rs_phy_matrix.py
vivado -mode batch -source /home/amd/ofdm/eeSDR_ofdm_loopback/sim/synth_rs.tcl
bash /home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_dma_regression.sh
```

The PHY matrix needs generated IP under
`/home/amd/ofdm/eeSDR_ofdm_loopback/build_hw/ip`. It runs at most two isolated
XSim jobs; selected case names can be passed as arguments. Do not run concurrent
instances on the same case directory. Test logs and machine-readable summaries:

- `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs/results.json`
- `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs/control.log`
- `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs/phy_results.json`
- `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs_phy_<case>/driver.log`
- `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs_synth/`

## Verified standalone results, 2026-10-16

Independent Python log/antilog multiplication and polynomial-division encoding
verify RTL parity (not merely encoder-to-decoder agreement). 204 packet cases:
186 accepted/corrected byte-for-byte, 18 seeded nine-errors-per-codeword cases
rejected by RS/FCS and not committed to DMA. Includes 239-byte boundaries,
1..1024-byte payloads, first/last/parity errors, eight-byte bursts, random
positions/magnitudes, valid gaps, consecutive packets and DMA backpressure.
Additional control bench checks malformed 12-bit lengths, reset during capture,
syndrome/BM/Chien/output and replacement of an incomplete packet, plus encoder
reset during capture/parity/replay and subsequent recovery. Existing DMA and
AD936x PHY interface regressions also pass.

Vivado 2022.1, xc7z020clg400-2, out-of-context place-and-route at 12.5 ns:

| Module | LUT | FF | Slice | RAMB18 | internal WNS | internal WHS |
|---|---:|---:|---:|---:|---:|---:|
| Encoder | 305 | 218 | 100 | 2 | +6.400 ns | +0.134 ns |
| Decoder | 1110 | 925 | 413 | 1 | +4.219 ns | +0.120 ns |

These are standalone results, not an additive whole-design utilization estimate.
They exclude integration/guard and enlarged existing PHY buffers. OOC I/O paths
are not constrained and clock-location warnings apply. DRC reports only the
expected missing-PS7 warning for standalone modules. Historical build artifacts
under the active `build_hw` directory predate RS.

## Full-board implementation, 2026-10-16

The isolated DMA-enabled RS board build completed synthesis, implementation,
bitstream generation and the repository's routed internal timing check:

- Project: `/home/amd/ofdm/eeSDR_ofdm_loopback/build_rs_board/ofdm_ad9361.xpr`
- Bitstream: `/home/amd/ofdm/eeSDR_ofdm_loopback/build_rs_board/ofdm_ad9361.runs/impl_1/TOP.bit`
- Hardware export: `/home/amd/ofdm/eeSDR_ofdm_loopback/build_rs_board/TOP.xsa`
- Timing: `/home/amd/ofdm/eeSDR_ofdm_loopback/build_rs_board/routed_timing.rpt`
- WNS +0.400297 ns, WHS +0.006583 ns, TNS=THS=0; hold margin is small.
- Placed utilization: 37401 LUT (70.30%), 51096 FF (48.02%), 12682 slices
  (95.35%), 92 BRAM tiles (65.71%), 89 DSP (40.45%). These are whole-board values.
- Routed DRC has warnings/advisories (DSP pipelining, RAM controls and others),
  no error-level violations. Two implementation critical warnings refer to
  unused `ila_for_bpsk_param_gain` constraint files. CDC and external I/O timing
  still require board-level review; internal timing success does not certify them.
- The build did not replace the active project or release images, and has not
  been programmed to hardware. Firmware was not rebuilt against this new XSA.

## PHY verification scope

Real generated FFT/Viterbi IP is used, not behavioral codec replacements. The
matrix covers clean 6/54 Mbps, legacy bypass, 1-byte and 1024-byte packets with
eight errors per codeword, 300 Hz CFO plus interference=2, and nine-error rejection.
Residual-byte injection is **after** real descrambling and before RS; it is not
an RF burst-noise model. The testbench verifies corrected-byte counts and payload,
and drains actual DMA output with backpressure before declaring success.
Consult the per-case JSON/logs for the actual pass/fail results; a launched job
or an earlier pre-DMA test is not evidence of a completed current matrix.

The final eight-case PHY + DMA matrix passed on 2026-10-16. The rebuilt 6 Mbps
maximum-payload case used a verified 10 ms timeout and completed two 1024-byte
packets with eight injected errors per codeword: `dma_accepted=2`,
`dma_dropped=0`. The second packet passed FCS at approximately 3.431 ms and
the complete bench finished at approximately 3.463 ms, beyond the old 3 ms
timeout. Evidence is in
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/build_rs_phy_max6/max6_r6_gain_0.75.log`;
both the per-case result and aggregate `phy_results.json` record success.