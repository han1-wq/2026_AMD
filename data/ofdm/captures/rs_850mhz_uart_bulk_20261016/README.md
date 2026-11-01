# 850 MHz RS UART bulk loopback — 2026-10-16

## Configuration

- TX/RX LO: **850 MHz**, verified independently from both boot readback lines.
- RS-enabled FPGA bitstream reused; link ACK retry timeout: **100 ms**.
- Sampling rate and bandwidth: 40 MHz; manual RX gain: 12 dB;
  configured TX attenuation: 10 dB.
- Host serial: `/dev/ttyUSB1`, 115200 baud, 8N1, no hardware/software flow control.
- Path: host UART -> board link/DMA -> single-board RF loopback -> host UART.
- One outstanding request, no scheduled inter-packet sleep, no host retry;
  each success requires local enqueue acceptance and a matching RF-returned
  payload, session, message and length. A failure stops the run.
- Host per-packet deadline: **10 s**, distinct from the link ACK timeout.
- Bulk payload: 1,000 bytes per packet (protocol maximum), 2,000 packets.
  Payload index `i` uses `SHAKE256(ASCII("850:" + str(i))).digest(1000)`;
  indices are zero-based. Each packet has distinct pseudorandom test content.
- Restored the existing verified software workspace
  `/home/amd/ofdm/eeSDR_ofdm_loopback/build_sw_rs_850mhz_ack100`.
  Maintained radio source now matches its 850 MHz settings; radio/link source
  bytes match that workspace, and all programming artifact hashes match the
  previous 850 MHz capture. No rebuild was needed.
- **JTAG only; QSPI untouched.** Power cycling may restore older QSPI firmware.
  Previous frequency-comparison workspaces and captures are preserved.

## Results

| Metric | Result |
| --- | ---: |
| Bulk packets passed | 2,000 / 2,000 |
| Failed / unattempted packets | 0 / 0 |
| Verified bulk payload | 2,000,000 bytes (2 MB decimal) |
| Compared bits | 16,000,000 |
| Differing bits | 0 |
| Bulk wall time | 407.758 s (6 min 47.758 s) |
| Mean packet time | 203.772 ms |
| Median / P95 / P99 packet time | 203.538 / 205.757 / 207.983 ms |
| Minimum / maximum packet time | 201.153 / 303.402 ms |
| Application goodput (payload counted once) | 4,904.868 B/s (4.905 kB/s) |
| Additional variable-length checks | 27 / 27 |
| Post-test TCP connect to 192.168.137.10:5001 | PASS |

The variable-length checks tested 1, 4, 25, 64, 239, 255, 512, 999 and 1,000
bytes, three times each: 9,297 additional bytes. Thus all 2,027 requests passed;
the timing/goodput figures above refer only to the 2,000-packet bulk phase.

Both complete 2,000,000-byte files have SHA256:

```text
df9c9ec93ee577e1c7c8b1598a173185e62c36b06a010973c6faee5623de60bc
```

Independent verification regenerated every payload, checked every per-packet
record/hash and aggregate count, compared the complete sent/received files,
recomputed bit differences, validated artifacts/source/boot settings, and
successfully opened TCP after the UART test. DMA packet/control, link, services
and board PHY regression passed. All 27 DMA host tests passed before the run
and again after it, including four new bulk-benchmark tests. The deliberate
`FAIL` messages in unit-test logs exercise error paths; the unit tests passed.

## Interpretation and limits

- This is reliable delivered-data evidence for this single-board loopback trial,
  not a two-board or passive-receiver acceptance test.
- No application timeout, enqueue rejection or returned-data mismatch occurred.
  No host retries were performed. UART does **not** expose RF retry/drop counters;
  firmware retransmissions may still occur. Those counts remain unknown, not zero.
- Zero delivered bit differences is **not** a raw RF BER measurement.
- Goodput includes serial framing, request/response serialization, host polling,
  firmware and RF processing. It is not peak UART or RF throughput, and is not
  directly comparable with the Ethernet image benchmark.
- The run did not stall: a progress query returned stale terminal text at 980
  packets; a direct file/process query then showed 1,982 successful packets,
  followed by normal completion at 2,000.

## Evidence and commands

Capture root:
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_uart_bulk_20261016`

- Summary:
  `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_uart_bulk_20261016/bulk_2000/summary.json`
- Per-packet results and full data:
  `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_uart_bulk_20261016/bulk_2000/results.jsonl`,
  `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_uart_bulk_20261016/bulk_2000/sent.bin`,
  `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_uart_bulk_20261016/bulk_2000/received.bin`.
- Independent audit and TCP result:
  `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_uart_bulk_20261016/verification.json`.
- Boot readback and programming artifact hashes:
  `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_uart_bulk_20261016/boot.log`,
  `/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_uart_bulk_20261016/artifacts.json`.

Repeat only the audit (also attempts a TCP connection; sends no RF payload):

```sh
python3 -B /home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_uart_bulk_20261016/verify_results.py
```

For a new hardware trial, first verify board configuration, then use a **new**
output directory. The benchmark refuses to overwrite an existing directory:

```sh
python3 -B /home/amd/ofdm/eeSDR_ofdm_loopback/host/dma_uart_benchmark.py /dev/ttyUSB1 /home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_uart_bulk_repeat --count 2000 --size 1000 --timeout 10 --seed 850
```

The original programming/length-check orchestration is preserved at
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_850mhz_uart_bulk_20261016/run_test.py`.
Do not rerun that capture-specific script in place: it rewrites some logs before
the benchmark rejects the existing output directory. Copy it and its companion
programming script to a fresh capture directory for a new programming trial.