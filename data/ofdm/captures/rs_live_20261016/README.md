# RS board and Ethernet acceptance, 2026-10-16

The matching RS bitstream, ELF and PS initialization script were downloaded
using Vitis 2022.1 XSCT and `firmware/program_dma.tcl`. Absolute artifact paths
and SHA-256 hashes are in `artifacts.json`. This was a volatile JTAG download;
QSPI was not modified.

Host: 192.168.137.64/24, interface ens33. Board: 192.168.137.10:5001.
UART boot confirms AD9361 initialization, TX1/RX1, TX/RX LO 433 MHz, 40 MSPS,
40 MHz bandwidth, RX gain 12 dB, and 1000 Mbps full-duplex Ethernet.
The maintained firmware leaves AD9361 internal loopback disabled. The actual
external antenna/cable arrangement was not independently inspected.

The maintained `host/dma_gui.py` Console was exercised by `gui_test.py`, using
its normal `send_image()` action. A 73,944-byte PNG returned in 0.469 seconds,
with CRC32 2ca783f9 and matching SHA-256
67baf57173fcc1a933e11441bed11528fb98cdf33ac62937fede91ed2609f4b6.
The GUI remains available with source and received previews and its PASS result.
`gui_result.json`, `gui_transfer.log`, `gui_received.png` and `gui_pass.xwd`
retain the result and window capture.

The existing `host/dma_image_benchmark.py` then performed 200 sequential
transfers over one TCP connection with TCP_NODELAY, no scheduled sleeps and
a 30-second whole-transfer deadline. Every transfer checked actual returned
bytes, image CRC, board CRC status and completed upload ACKs.

| Metric | Result |
| --- | ---: |
| Successful transfers | 200 / 200 |
| Bytes per transfer / fragments | 73,944 / 74 |
| Compared bits / differing bits | 118,310,400 / 0 |
| Total successful bytes | 14,788,800 |
| Wall time | 65.347 s |
| Application goodput | 226,311.78 bytes/s |
| Complete-transfer median / P95 / maximum | 308.18 / 491.29 / 659.36 ms |
| First-data median / P95 | 3.01 / 6.32 ms |

`benchmark_200/` contains configuration, all 200 result rows, the summary and
the last returned image. `counter_totals.json` sums each transfer's reported
counter deltas: TX submitted/completed 33,677; RX accepted 30,148; RX dropped
3,529; link retries 3,549. TX rejected/failed, RX overflow/timeout, and link
failures were all zero. These snapshots cover transfer intervals, not an
atomic full-run hardware counter measurement.

The returned data passed after FCS/ARQ. This is not a raw RF BER measurement,
an RS correction-count measurement, or a long-duration soak test. TCP socket
samples also show retransmissions (`tcp_during_benchmark.log`); successful
delivery does not explain those retransmissions or establish their cause.
No pre-RS comparison was run under the same physical conditions.

`diagnose.log` was collected after the benchmark, avoiding CPU pauses during
the throughput measurement. The diagnostic script resumes CPU0 before exit.
`program_and_capture.py` and `program_capture.log` retain programming/boot
reproduction and evidence; `program.log` confirms DMA_PROGRAMMED_AND_RUNNING.