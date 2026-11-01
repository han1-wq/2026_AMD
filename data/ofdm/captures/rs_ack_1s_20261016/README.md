# ACK timeout 1-second hardware experiment, 2026-10-16

The user requested a larger interval and firmware programming. This experiment
changes the firmware ACK retry deadline from 100 ms to 1000 ms, measured from
successful DMA submission. It does not add an inter-image sleep or change the
409.6-us RS transmit guard. The unchanged retry limit is 50 attempts; absent
ACKs can now take approximately 50 seconds to exhaust that limit, while host
image clients still impose their own deadlines. The independent 2000-ms
submission-stall watchdog remains enabled.

Maintained source: `/home/amd/ofdm/eeSDR_ofdm_loopback/firmware/dma_app/link.c`.
New GUI-openable Vitis 2022.1 workspace:
`/home/amd/ofdm/eeSDR_ofdm_loopback/build_sw_rs_ack1s`.
The original `/home/amd/ofdm/eeSDR_ofdm_loopback/build_sw_rs` remains the 100-ms
control. Comparing their copied C/H sources found only `link.c` different.
The same RS bitstream and XSA were used throughout. Artifact SHA-256 hashes,
programming logs and UART boot evidence are retained for every programming.
This is a volatile JTAG download; QSPI was not modified.

Host: 192.168.137.117/24. Board: 192.168.137.10:5001. UART: /dev/ttyUSB1,
115200 baud. Each boot confirmed AD9361 initialization, 433 MHz, 40 MSPS,
12-dB RX gain and 1000-Mbps full-duplex Ethernet. The physical RF path was
not independently inspected. Only one image client ran at a time.

All runs used the same 73,944-byte source image and the maintained benchmark,
one persistent TCP connection per run, no scheduled inter-image sleeps,
TCP_NODELAY and a 30-second whole-image deadline. Each transfer required
returned bytes, CRC verification and completed link acknowledgements.

| Run order / firmware | Images passed | RX drops | Link retries | Mean image time | Goodput |
| --- | ---: | ---: | ---: | ---: | ---: |
| Initial 1000 ms | 50/50 | 0 | 0 | 124.99 ms | 590,320 B/s |
| Control 100 ms | 50/50 | 0 | 0 | 125.52 ms | 587,813 B/s |
| Restored 1000 ms | 200/200 | 0 | 0 | 125.12 ms | 589,816 B/s |

All runs had zero differing bits, TX rejected/failed, RX overflow/timeout and
link failures. Final run: 118,310,400 compared bits, 25.074 seconds wall time,
126.96-ms P95, 135.42-ms maximum; TX submitted/completed and RX accepted each
30,000. `comparison.json` retains the side-by-side summary, while each benchmark
directory retains all result rows, configuration, summary and last RX image.
An initial standalone image also passed in 0.127 seconds.

The current control did not reproduce the earlier 3,549 retries / 3,529 RX drops.
Both deadlines work without retries in the current conditions; this experiment
does not establish that the 100-ms deadline caused the historical problem or
that increasing it cured that problem. Neither run exercised actual retries
on hardware. No RF BER or controlled interference measurement was performed.

Local C regressions passed for the maintained link and services code. Link tests
cover no retry at 100/999 ms, retry at 1000 ms, a delayed ACK at 500 ms, timer
wraparound, retry exhaustion, ACK backpressure, and independent stall recovery.
Services tests retain failure/cancellation coverage with longer simulated time.
Build command and output are in `build_command.txt` and `build.log`.

Final board state is the 1000-ms ELF, programmed using
`final_1s/program_and_capture.py`. The final 200-image evidence is in
`final_1s/benchmark_200/`. GUI evidence is recorded separately in
`gui_result.json`, `gui_transfer.log` and `gui_received.png`.