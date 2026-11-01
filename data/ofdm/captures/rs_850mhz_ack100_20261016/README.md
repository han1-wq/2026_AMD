# RS / 850 MHz / 100 ms ACK timeout — 400-image board test

## Configuration and verification

- Date: 2026-10-16; single-board RF loopback, not a second-board reception test.
- TX and RX LO changed from 433 MHz to 850 MHz; both read back as
  `850.00 MHz` in the captured boot log.
- ACK retry timeout: 100 ms, measured from successful submission.
- Existing RS-enabled FPGA bitstream reused without modification.
- Sampling rate 40 MSPS; RF bandwidth 40 MHz; RX gain 12 dB, manual mode.
- Same 73,944-byte source image as the preceding comparison, 74 DATA fragments
  plus META per transfer; persistent TCP connection, 30 s whole-transfer deadline.
- Source SHA256: `67baf57173fcc1a933e11441bed11528fb98cdf33ac62937fede91ed2609f4b6`.
- Independent software workspace:
  `/home/amd/ofdm/eeSDR_ofdm_loopback/build_sw_rs_850mhz_ack100`.
- Prior 433 MHz workspaces were preserved. Download was through JTAG;
  QSPI was not written. Power cycling may restore the previous QSPI image.

## Results

| Metric | Earlier 433 MHz / 100 ms | This 850 MHz / 100 ms |
|---|---:|---:|
| Successful images | 400/400 | 400/400 |
| Wall time | 75.009 s | 52.356 s |
| Mean image completion | 187.27 ms | 130.62 ms |
| Median image completion | 190.44 ms | 124.89 ms |
| P95 image completion | 274.31 ms | 176.13 ms |
| P99 image completion | 318.02 ms | 219.01 ms |
| Link retries | 1,021 | 152 |
| RX drops | 975 | 120 |
| Returned differing bits | 0 | 0 |

All 400 transfers returned counters. This run compared 236,620,800 bits;
the final saved image also matches the source byte-for-byte. TX failures,
TX rejections, RX overflow, RX timeout and link failures were all zero.
Application goodput was 564,936.83 bytes/s (about 4.52 Mbit/s).

Mean completion time fell by approximately 30.2%, retries by 85.1%, and
RX drops by 87.7% relative to the earlier 433 MHz / 100 ms run.
This is a historical comparison after reconnection, not an interleaved,
controlled frequency A/B experiment: environmental interference, antenna
matching and physical connection conditions can affect the result.
It does not establish that 850 MHz is universally more reliable.

Retries can follow DATA or ACK loss; RX drops combine several rejection
causes. Neither counter is raw RF BER. Packet loss still occurred and was
recovered by the current RS/ARQ system; 400/400 success does not guarantee
lossless passive reception by a second board.

## Evidence

All paths below are under
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_ack100_20261016`:

- `build.log`: Vitis build completed, `BUILD_EXIT=0`.
- `regression.log`: DMA RTL, link, services and PHY tests passed;
  23 host tests passed; `DMA_REGRESSION_PASS`.
- `artifacts.json`: SHA256 hashes of downloaded ELF, bitstream, PS init and XSA.
- `program.log`, `program_capture.log`, `boot.log`: successful JTAG download,
  LO readback and network service startup.
- `command.json`, `benchmark.log`, `benchmark_400/`: command, per-image
  results, timings, summaries and final received image.
- `result.json`, `runner.log`: aggregated results and `TEST_COMPLETE`.
- `run_test.py`, `program_and_capture.py`: scripts used for this run.

Earlier comparison:
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_ack_compare400_20261016/comparison.json`.

An ICMP ping after testing did not succeed and reported an ICMP redirect.
The separate TCP check succeeded against `192.168.137.10:5001`, confirming
the application port remained reachable; see `post_test_tcp.log`.