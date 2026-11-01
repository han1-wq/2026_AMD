# RS-interleaved board acceptance, 2026-10-16

The active Vivado/Vitis 2022.1 build was downloaded over JTAG using the maintained
`firmware/program_dma.tcl`. QSPI was not modified. CPU0 was confirmed Running
after all tests; a power cycle may restore the previous boot image.

Matching artifacts (absolute paths and SHA-256 in `artifacts.json`):

- `/home/amd/ofdm/eeSDR_ofdm_loopback/build_hw/TOP.bit`
- `/home/amd/ofdm/eeSDR_ofdm_loopback/build_hw/TOP.xsa`
- `/home/amd/ofdm/eeSDR_ofdm_loopback/build_sw/ofdm_dma/Debug/ofdm_dma.elf`
- `/home/amd/ofdm/eeSDR_ofdm_loopback/build_sw/dma_platform/hw/ps7_init.tcl`

The programming helper checked the build manifest and confirmed that PS init
matches the XSA. Hardware uses DMA_ENABLE=1, RS_ENABLE=1, RS_INTERLEAVE=1.
`boot.log` confirms AD9361 initialization, TX1/RX1, TX/RX LO 850 MHz, 40 MSPS,
40 MHz bandwidth, RX gain 12 dB, and 1000 Mbps full-duplex Ethernet.
Firmware uses a 100 ms ACK timeout. Host ens33 was 192.168.137.212/24;
board service was 192.168.137.10:5001. UART was FT2232 serial 0ABC01 interface 1,
115200 8N1. The physical antenna/cable arrangement was not independently inspected.

## Results

| Check | Result |
| --- | --- |
| UART lengths 1..1000, including RS block boundaries | 66/66 passed |
| UART bulk: 500 packets, 1000 bytes each | 500/500 passed |
| UART returned data | 500,000 bytes / 4,000,000 bits, zero differences |
| UART bulk wall time | 101.748 s |
| Ethernet image round trips, 73,944 bytes each | 200/200 passed |
| Image returned data | 14,788,800 bytes / 118,310,400 bits, zero differences |
| Image run wall time | 25.080 s |
| Image application goodput | 589,655.67 bytes/s (4.717 Mbit/s) |
| Complete-image latency median / P95 / maximum | 124.898 / 126.072 / 136.955 ms |
| Image counter totals: TX submitted/completed, RX accepted | 30,000 / 30,000 / 30,000 |
| Image counter totals: link retries/failures, RX drops/overflow/timeout | all zero |
| Image counter totals: TX rejected/failed | both zero |

`run_uart_test.py` used the maintained serial framing/loopback and benchmark
helpers, with no host retry and a 10 s request deadline. All 22 lengths were
tested three times. The bulk run saved sent and received bytes; these were
independently compared after the run and have identical SHA-256 hashes.

The maintained `host/dma_image_benchmark.py` ran 200 sequential transfers over
one TCP connection, TCP_NODELAY enabled, with no scheduled sleeps and a 30 s
whole-transfer deadline. Every transfer passed byte comparison, CRC verification,
board CRC status and completed upload ACK checks. All 200 rows contained counters;
these are sums of per-transfer snapshots, not an atomic full-run measurement.
The last received PNG was independently compared with the source file.

Results are application data after FCS/ARQ. They do not measure raw RF BER,
RS correction counts, burst-error correction capability, or long-duration stability.
No interleave-disabled control was run under the same physical conditions.
UART does not expose retry/drop counters. Existing implementation CDC and external
I/O timing limitations are not resolved by these functional tests.

## Evidence

- `program_and_capture.py`, `program_command.json`, `program.log`, `boot.log`
- `run_uart_test.py`, `length_checks.jsonl`, `uart_test.log`, `uart_500/`
- `image_command.json`, `image_test.log`, `images_200/`
- `verified_result.json`: independently checked aggregate results and limitations

These scripts target this captured build and USB identity. Re-running the tests
requires a new output directory because existing benchmark evidence is protected
against accidental overwrite.