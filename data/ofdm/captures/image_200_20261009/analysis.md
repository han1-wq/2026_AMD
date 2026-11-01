# 200 Sequential Hardware Image Loopbacks

## Method and Verification

- Board: 192.168.137.10:5001. Source: 73,944 bytes, 74 data fragments.
- 200 attempts completed; JSONL and CSV agree on every field. Recomputed summary matches summary.json.
- Persistent TCP after success, reconnect after failure, no scheduled inter-image sleep.
- Success requires complete byte equality, board CRC confirmation and all-upload ACK status.
- Timeout is a 30-second whole-transfer deadline, not an inter-image delay.
- Source and last received image SHA256: 67baf57173fcc1a933e11441bed11528fb98cdf33ac62937fede91ed2609f4b6.
- Host image/benchmark tests: 14 passed.

## Reliability and Observable Differences

- Successes: 186/200 (93%). Failures: 14/200 (7%).
- All failures reached the deadline with incomplete reception: 9-46 of 74 fragments received, median 28.
- Failure attempts: 3, 12, 14, 15, 26, 28, 60, 113, 117, 139, 141, 158, 159, 185.
- Adjacent failures: 14-15 and 158-159. First 28 attempts contain 6 failures; the remaining 172 contain 8. This single run does not establish a trend or cause.
- Failures had TCP upload completion and returned metadata/data, but no complete image, final CRC or ACK-completion status. No explicit board failure status was recorded.
- Missing application fragment instances: 660/14,800 (4.46%). This is deadline coverage, not RF packet loss; unsent fragments and hidden retries cannot be distinguished.
- Compared bits: 113,036,672 total = 110,028,672 in successes + 3,008,000 in partial failures. Differing bits: 0.
- Bit comparisons count unique returned data fragments per attempt, not RF transmissions or retries.
- All 14 failure buffers are preallocated to 73,944 bytes. Their file size does not imply full reception; use missing_fragments in results.jsonl to distinguish zero-filled holes from received bytes.
- Raw RF BER, RF packet loss and retransmission counts are unavailable. FCS filtering and ARQ prevent interpreting zero delivered differences as zero raw BER.

## Timing and Goodput

| Successful transfer latency | Seconds |
| --- | ---: |
| Minimum | 0.1462 |
| Mean | 0.4225 |
| Median | 0.4415 |
| P90 | 0.4537 |
| P95 | 0.4579 |
| P99 | 0.4648 |
| Maximum (attempt 152) | 0.4672 |

- Wall time: 498.658 seconds (8 min 18.658 s).
- Successful transfer time: 78.591 seconds. Failed transfer time: 420.011 seconds, 84.23% of wall time.
- Overall successful-image goodput: 27.581 kB/s = 0.22065 Mbit/s, including failed attempts and their deadlines.
- Success-only image goodput: 175.001 kB/s = 1.40001 Mbit/s. Both count each successful image once, not both TCP directions or RF overhead, and neither is PHY bitrate.
- All-attempt inter-image bookkeeping gap: mean 0.144 ms, median 0.100 ms, max 2.372 ms, total 28.852 ms. Connection setup is separate: 15 connections, total 9.387 ms.
- Successful upload completion: median 5.861 ms, P95 231.647 ms; 102/186 below 50 ms. This measures TCP send completion, not wireless acceptance.
- Returned metadata: median 0.913 ms, maximum 11.134 ms (attempt 197).
- First returned data: 174 successes average 209.705 ms; 12 early successes average 3.309 ms. Their respective total transfer means are 436.296 ms and 222.988 ms.
- First data to complete image: median 233.256 ms, mean 225.956 ms, range approximately 143-256 ms.
- Complete image to full transfer completion: median 0.127 ms, P95 0.477 ms, max 2.499 ms. Final CRC/ACK waiting is not the dominant overhead.
- Stage timestamps overlap because upload and receive run concurrently; do not sum upload_s, first_data_s and image_s as separate durations.

## Conclusions and Next Measurements

There is no deliberate pause between images. Low aggregate goodput is dominated by incomplete attempts spending 30 seconds waiting. Shortening that deadline would change the benchmark policy and reported goodput, but would not fix the underlying failures or increase PHY throughput.

Successful attempts also show a substantial approximately 0.21-second first-data delay that is absent in 12 cases. Investigate this separately from image switching. The host uses default TCP Nagle behavior; board services already call tcp_nagle_disable(). A host TCP_NODELAY comparison plus packet capture can test TCP buffering/delayed-ACK hypotheses. Link retry configuration (100 ms interval) is another timing consideration, but retries are not measured here. No root cause is established by these timestamps alone.

Previously observed RX frontend drain/reset behavior is a plausible independent risk, not a proven explanation for this run. Instrument TCP send/ACK timing and board link/DMA counters before attributing missing fragments to RF corruption, retry exhaustion or reset timing.