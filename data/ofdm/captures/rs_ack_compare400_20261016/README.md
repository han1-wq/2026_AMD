# 400-image comparison of 100-ms and 1000-ms ACK retry deadlines

Date: 2026-10-16. Each trial attempted 400 transfers of the same 73,944-byte
image, with a persistent TCP connection, TCP_NODELAY, no inter-image sleep,
and the same 30-second whole-image host deadline. The control ran first.
Host: 192.168.137.117; board: 192.168.137.10:5001.

| Metric | 100 ms | 1000 ms |
| --- | ---: | ---: |
| Attempts | 400 | 400 |
| Successful complete images | 400 | 399 |
| Host deadline failures | 0 | 1 |
| Wall time | 75.009 s | 505.319 s |
| Mean successful image time | 187.27 ms | 1191.02 ms |
| P95 successful image time | 274.31 ms | 2080.33 ms |
| Maximum successful image time | 369.72 ms | 4009.26 ms |
| Application goodput | 394,320 B/s | 58,386 B/s |
| Reported link retries | 1,021 | 1,398* |
| Reported RX drops | 975 | 1,376* |
| RX accepted | 60,268 | 60,171* |
| TX submitted/completed | 61,243 | 61,547* |
| RX overflow / RX timeout | 0 / 0 | 0 / 0* |
| TX rejected / TX failed / link failures | 0 / 0 / 0 | 0 / 0 / 0* |
| Differing bits among received unique fragments | 0 | 0 |

*Counters are summed per-image deltas, reported at successful completion.
The 100-ms trial contains 400 counter reports; the 1000-ms trial contains only
399. Its failed final image did not report counters, so those totals omit its
activity and must not be presented as complete totals for all 400 attempts.
Image 400 hit the 30-second host deadline with 72/74 fragments received,
missing indices 33 and 64. A zero link-failure total does not exclude a host
deadline failure. The firmware's retry limit and host deadline are independent.

The returned fragments were compared against the source. The 100-ms run
compared 236,620,800 bits; the 1000-ms run compared 236,604,800 bits, including
the partial final image. Both last successful returned files match the source
SHA-256 `67baf57173fcc1a933e11441bed11528fb98cdf33ac62937fede91ed2609f4b6`.
Missing fragments are not counted as matching bits or as measured bit errors.

The same bitstream, XSA and PS initialization contents were used for both
trials; artifact hashes and programming/boot logs are in each trial directory.
`source_diff.json` verifies that the copied application C/H files differ only
in the ACK deadline and its comment. `comparison.json` preserves summaries,
counter coverage and errors. Per-attempt JSONL/CSV and the last successful
returned image are under each `benchmark_400` directory.

## What the counters mean

`firmware/dma_app/link.c` increments `link_retries` when a packet already sent
is successfully submitted again after waiting for its matching ACK. It does
not count bad bits, and loss of either data or ACK can cause it.

`rtl/board/ofdm_dma_rx.v` increments `dropped` for an active packet interrupted
by another packet start, a failed receive commit, or a receive timeout. Commit
requires no discard flag, valid FCS, 1..1024 bytes and matching received length.
Discard can result from full packet storage or excessive length. In the RS
receive path, FCS acceptance additionally requires that RS has not failed
(`rtl/ofdm/rx/newdesign/rx802p11_top.v`, `fcs_ok = w_fcs_ok && !w_rs_failed`).
Ordinary firmware duplicate suppression does not increment this hardware
counter. Zero RX overflow and timeout reports do not distinguish CRC/RS
failure from length errors or packet interruption.

The observed drop fraction among accepted-plus-dropped events is about 1.59%
for 100 ms and 2.24% for 1000 ms (the latter covers only reported intervals).
This includes short ACKs and data packets and is not raw BER or a complete RF
packet-error measurement: packets missed before SIGNAL decoding may not enter
the receive gate, and different discard reasons share one counter. Successful
payload comparison occurs after FEC, CRC rejection and ARQ and does not measure
pre-correction BER. No failed-packet bit comparison or RF SNR/EVM was captured.

Both trials show receive failures and retries. A 1000-ms deadline did not
eliminate them and imposed substantially longer recovery waits in this run.
Sequential trials and changing RF/runtime conditions prevent assigning the
difference in drop counts solely to the timeout. The actual receive-failure
cause remains unlocalized. Distinguishing it requires separate CRC/RS,
length and interruption counters or an ILA capture, followed by controlled
measurements of received signal quality and known transmitted data.

After the failed last image, an attempt to program the 1000-ms firmware again
using `restore_1000ms/program_and_capture.py` failed before programming because
`/dev/ttyUSB1` no longer existed. No USB serial devices were visible, and board
ping and TCP connection checks also failed. The last successful download was
the 1000-ms trial firmware; its present running state cannot be confirmed.
Only volatile JTAG programming was used; QSPI was not written.

## Historical pre-RS evidence

The pre-RS 2026-10-09 release acceptance run in
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/qspi_restored_20261009_tcp200/`
passed 200/200 images with zero delivered bit differences, but summing its
200 counter reports gives 3,042 link retries and 3,042 RX drops, with zero
RX overflow, RX timeout and link failures. Its mean image time was 158.44 ms.
The release README identifies this as the acceptance run after the user
restored antenna positions; it is not a controlled RF comparison with RS.
Earlier `qspi_final_20261009_tcp20` passed 20/20 with 2,035 retries and 2,035
drops, and `qspi_final_20261009_tcp_solo20` passed 20/20 with 2,158 retries and
2,146 drops. Thus packet discards and ARQ retries demonstrably predate RS;
these historical runs alone do not establish RS's effect on their rate.