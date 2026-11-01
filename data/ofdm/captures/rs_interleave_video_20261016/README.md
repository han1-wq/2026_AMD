# RS-interleaved OFDM: 400 images and paced JPEG video

Current-board Ethernet -> OFDM RF loopback -> Ethernet tests; 850 MHz,
40 MSPS, RS and packet-local interleaving enabled. No firmware/bitstream
change or QSPI programming was performed during these tests.

## 400 consecutive original PNG transfers

400/400 passed; 29,577,600 bytes / 236,620,800 bits compared, zero differences.
Wall time 50.412 s, application goodput 586.7 kB/s (4.694 Mbit/s).
Median / P95 / maximum full-frame time: 124.79 / 126.61 / 208.37 ms.
Reported per-transfer counter totals: `{"tx_submitted": 60006, "tx_completed": 60006, "tx_rejected": 0, "tx_failed": 0, "rx_accepted": 60001, "rx_dropped": 5, "rx_overflow": 0, "rx_timeout": 0, "link_retries": 5, "link_failures": 0}`.

## Moving JPEG sweep

The source is synthetic motion with seeded texture over an upscaled
192x128 test pattern, not a natural camera recording. Each profile contains
32 JPEG frames replayed cyclically (4:2:0; Pillow quality as listed).
Resolution identifies transmitted JPEG dimensions, not source camera detail.
Each configuration ran for 12 seconds. No host retry; one outstanding frame.
Source frames that expire while the link is busy are skipped, bounding latency.
Each returned frame is byte/CRC checked and JPEG-decoded.

| Dimensions / quality | Mean kB/frame | Target fps | Delivered fps | Successful / scheduled | Source frames skipped | Late frames | P95 source-to-decode ms | Retries |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 320x180_q70 | 16.4 | 12.5 | 12.47 | 150/150 | 0 | 3 | 36.7 | 3 |
| 320x180_q70 | 16.4 | 22 | 21.67 | 260/264 | 4 | 7 | 31.9 | 10 |
| 320x180_q70 | 16.4 | 30 | 29.17 | 350/360 | 10 | 16 | 31.0 | 5 |
| 640x360_q50 | 32.4 | 8 | 8.00 | 96/96 | 0 | 3 | 97.2 | 8 |
| 640x360_q50 | 32.4 | 14.5 | 14.50 | 174/174 | 0 | 11 | 73.2 | 2 |
| 640x360_q50 | 32.4 | 22.5 | 16.70 | 201/270 | 69 | 201 | 101.2 | 10 |
| 640x360_q70 | 44.7 | 4.5 | 4.50 | 54/54 | 0 | 0 | 98.4 | 27 |
| 640x360_q70 | 44.7 | 8 | 8.00 | 96/96 | 0 | 1 | 84.1 | 1 |
| 640x360_q70 | 44.7 | 12.5 | 12.42 | 149/150 | 1 | 30 | 97.4 | 2 |
| 640x360_q85 | 67.4 | 4 | 4.00 | 48/48 | 0 | 0 | 124.8 | 1 |
| 640x360_q85 | 67.4 | 7 | 7.00 | 84/84 | 0 | 10 | 191.4 | 4 |
| 640x360_q85 | 67.4 | 11 | 8.48 | 102/132 | 30 | 102 | 203.0 | 2 |
| 960x540_q70 | 93.4 | 3 | 3.00 | 36/36 | 0 | 0 | 164.0 | 0 |
| 960x540_q70 | 93.4 | 5 | 5.00 | 60/60 | 0 | 2 | 184.2 | 7 |
| 960x540_q70 | 93.4 | 8 | 6.17 | 75/96 | 21 | 75 | 280.5 | 5 |
| 1280x720_q50 | 120.6 | 2 | 2.00 | 24/24 | 0 | 0 | 209.3 | 0 |
| 1280x720_q50 | 120.6 | 4 | 4.00 | 48/48 | 0 | 3 | 246.6 | 26 |
| 1280x720_q50 | 120.6 | 6 | 4.87 | 59/72 | 13 | 59 | 362.1 | 0 |
| 1280x720_q70 | 180.7 | 1.5 | 1.50 | 18/18 | 0 | 0 | 308.7 | 0 |
| 1280x720_q70 | 180.7 | 2.5 | 2.50 | 30/30 | 0 | 0 | 308.6 | 0 |
| 1280x720_q70 | 180.7 | 4 | 3.26 | 40/48 | 8 | 40 | 530.0 | 0 |

Late frames are successfully recovered frames that miss the next source-frame
deadline; they are counted separately from skipped source frames and failures.
Source-to-decode latency includes scheduling delay and the full transfer/ACK
completion plus JPEG decode. A small playback buffer could absorb some late
frames, but buffered playback was not tested.

## Sustained runs

- `endurance_360p`: target 8 fps, 120.00 s; 960/960 complete, 0 source skips, 6 late; delivered 8.000 fps; P95 80.1 ms, 11 link retries.
- `confirm_640x360_q70_5fps`: target 5 fps, 120.00 s; 600/600 complete, 0 source skips, 0 late; delivered 5.000 fps; P95 78.9 ms, 4 link retries.

## Interpretation and reproduction

Goodput counts successful JPEG payload bytes once per complete RF loopback.
It is not PHY bitrate or an independently measured peer-to-peer video capacity.
Packets include FCS/ARQ; zero delivered differences do not establish raw BER.
Saturation FPS depends on JPEG size, protocol overhead, RF retries, and host jitter.
A practical configuration needs headroom below saturation and a frame budget
that tolerates the configured 100 ms link retry timeout.

Capture, resize, JPEG encode and GUI display are excluded from paced runs.
`encoding_timings.json` separately measures host JPEG encoding only.
`synthetic_360p_preview.gif` previews the source, not a recording of a receiver.
The last actual verified received JPEG is retained in each run directory.
No natural video source/camera was available; conclusions apply to these loads.

Run a JPEG directory through the maintained tool (choose a new output directory):

```sh
python3 /home/amd/ofdm/eeSDR_ofdm_loopback/host/dma_jpeg_benchmark.py 192.168.137.10 /home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/rs_interleave_video_20261016/sources/640x360_q70 /tmp/ofdm_video_new --fps 5 --seconds 120
```

Evidence: `images_400/`, `source_manifest.json`, `calibration_*.json`,
`sweep_summary.json`, per-run `results.jsonl`/`summary.json`,
`video_suite.log`, `endurance_360p/`, `verified_result.json`.
Run `verify_and_report.py` after the suite to independently recheck these results.

## Requested 640x480 / 7 fps configuration

JPEG Q50, 120 seconds: 840/840 successful; 0 source skips; 2 late frames; 0 bit differences.
All returned JPEGs and independent per-file hashes are retained in `vga7/`.
`vga7/received_player.html` plays the first 49 actually returned JPEGs
offline at 7 fps. `vga7/received_640x480_7fps.gif` is a color-quantized preview.
The entire 120-second received sequence is in `vga7/received_run/received/`.
Earlier optional follow-ups were stopped when the user narrowed the target;
partial logs are retained but excluded from complete-run validation.
