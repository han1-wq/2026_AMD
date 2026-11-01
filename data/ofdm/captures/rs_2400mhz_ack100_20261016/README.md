# RS / 2400 MHz / 100 ms — 400-image board test

## Configuration

- Date: 2026-10-16; single-board RF loopback, not a second-board reception test.
- TX/RX LO changed from 850 MHz to 2400 MHz. Both read back as
  `2400.00 MHz` in the captured boot log.
- ACK retry timeout remains 100 ms; existing RS-enabled bitstream reused.
- Sampling rate 40 MSPS, RF bandwidth 40 MHz, manual RX gain 12 dB,
  configured TX attenuation 10 dB unchanged.
- Same 73,944-byte image, META plus 74 DATA fragments, persistent TCP,
  30 s whole-transfer deadline, 400 consecutive transfers.
- Image SHA256: `67baf57173fcc1a933e11441bed11528fb98cdf33ac62937fede91ed2609f4b6`.
- Workspace: `/home/amd/ofdm/eeSDR_ofdm_loopback/build_sw_rs_2400mhz_ack100`.
- Previous builds preserved. JTAG download only; QSPI untouched. Power
  cycling may restore the previous QSPI image.

## Results

All columns use RS and 100 ms ACK timeout; 433/850 MHz columns are prior runs.

| Metric | 433 MHz | 850 MHz | 2400 MHz |
|---|---:|---:|---:|
| Successful images | 400/400 | 400/400 | 400/400 |
| Wall time | 75.009 s | 52.356 s | 100.768 s |
| Mean completion time | 187.27 ms | 130.62 ms | 251.67 ms |
| Median completion time | 190.44 ms | 124.89 ms | 229.74 ms |
| P95 completion time | 274.31 ms | 176.13 ms | 380.28 ms |
| P99 completion time | 318.02 ms | 219.01 ms | 431.26 ms |
| Link retries | 1,021 | 152 | 4,577 |
| RX drops | 975 | 120 | 2,267 |
| RX timeout | 0 | 0 | 4 |
| Returned differing bits | 0 | 0 | 0 |

All 400 rows were independently checked for success, 74 returned DATA
fragments, zero differing bits and consistent counter totals. All transfers
reported counters. Total compared bits: 236,620,800. The final saved image
matches the source byte-for-byte. Maximum completion time: 605.14 ms.
Application goodput: 293,520.59 bytes/s (about 2.35 Mbit/s).
TX rejections, TX failures, RX overflow and final link failures were zero.

2400 MHz took about 1.93 times the mean completion time of the preceding
850 MHz run, with about 30.1 times the retries and 18.9 times the RX drops.
All images still completed correctly, but delivery required substantially
more retransmission. The 4 RX timeouts are receiver events, not image-level
30-second deadline failures.

These are sequential measurements, not repeated/interleaved controlled
frequency trials. They do not prove a universal frequency ranking or identify
the cause of degradation. Interference, antenna matching and RF propagation
can all vary with frequency and time; no spectral measurements were made.
Retries may follow DATA or ACK loss; RX drops combine multiple rejection
causes. Neither metric measures raw BER, nor does this test establish reliable
passive reception by a second board.

## Evidence and validation

Evidence directory:
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_2400mhz_ack100_20261016`.

- `build.log`: successful Vitis build, `BUILD_EXIT=0`.
- `regression.log`: DMA RTL, link, services, PHY and 23 host tests passed.
- `artifacts.json`: downloaded artifact hashes, independently rechecked.
- `program.log`, `program_capture.log`, `boot.log`: JTAG success and LO readback.
- `command.json`, `benchmark.log`, `benchmark_400/`: command, per-image records,
  summary and last received image.
- `result.json`, `runner.log`: aggregate results and `TEST_COMPLETE`.
- `verification.log`: independent row and artifact validation passed.
- `post_test_tcp.log`: TCP connection to `192.168.137.10:5001` passed after testing.
- `run_test.py`, `program_and_capture.py`: executed test scripts.

Built radio source differs from the 850 MHz build only in the two LO values;
built link source is identical. Current board was left running 2400 MHz/100 ms.

Prior evidence:

- `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_ack100_20261016/result.json`
- `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_ack_compare400_20261016/comparison.json`