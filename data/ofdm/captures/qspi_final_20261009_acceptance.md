# Latest firmware live acceptance before QSPI programming

Date: 2026-10-09. Decision: HOLD QSPI programming. Data correctness passed
in the latest maintained build, but transfer speed did not match the historical
baseline. No QSPI erase or programming command was issued in this session.
No QSPI boot image was generated or cold boot validated.

## Selected artifacts

All paths are relative to /home/amd/ofdm/eeSDR_ofdm_loopback/.

| Artifact | Path | SHA256 |
| --- | --- | --- |
| Application | build_dma_sw_maintained/ofdm_dma/Debug/ofdm_dma.elf | 7b0749b6a8a28a377e9ba5de34fec779cf3150177615381fa8a67b1f947b740d |
| Bitstream | build_dma_sw_maintained/dma_platform/hw/TOP.bit | e1b50d9cac44bb95bf184419071a8448bc40dff254f7f1ed2e3856c01209f9b6 |
| XSA | build_dma_sw_maintained/dma_platform/hw/TOP.xsa | 72683c6833e3903ee8272189730790fedad737def9289daf40d0048582c2ab43 |
| PS initialization | build_dma_sw_maintained/dma_platform/hw/ps7_init.tcl | 650afea958fe29f09eb5f8930a440aab4069b0456601bb8c6dfd1e69437cb105 |
| FSBL (not boot-tested) | build_dma_sw_maintained/dma_platform/zynq_fsbl/fsbl.elf | 94336f93d8801c0a8161ba13c35c77ca2caecb1f3c8ba07fd9acd692226e73eb |

The application source copies exactly matched firmware/dma_app/ and
firmware/radio/. BOARD_ID=10, BOARD_SUBNET=137, TCP_MSS=1440, TCP_WND=32768.
The FSBL ps7_init.c hash matched the TCP-fix hardware initialization source.
Exported hardware parameters specify single-chip x4 QSPI on MIO 1..6;
physical flash identity/capacity and board boot switches remain unverified.

## Live results

- Successful JTAG load: qspi_final_20261009_deploy_retry/program.log.
- Captured boot: qspi_final_20261009_deploy_retry/boot.log reports
  RTL8211F PHY 1: 1000 Mbps full duplex and DMA ready: 192.168.137.10:5001.
- UART /dev/ttyUSB1, 115200 8N1: 1, 4, 16, 64-byte CLI requests passed
  (qspi_final_20261009_uart/results.log). Three repetitions each of
  25, 64, 999, 1000 bytes also passed an in-process client test, observed
  in terminal output. Total: 16/16. Small requests took about 50 ms with
  the client's 50 ms read timeout; this is not pure RF latency. Large
  requests took 0.303..0.504 s.
- Image: demo_20261009/demo_source.png, 73944 bytes, 74 fragments.
- qspi_final_20261009_tcp20/: 20/20, CRC/ACK/byte comparison passed,
  0 differing bits; mean 0.807651 s, goodput 91504.3 B/s.
  UART CLI requests ran concurrently for part of this run.
- qspi_final_20261009_tcp_solo20/: 20/20 with no concurrent UART requests
  or JTAG diagnostic pauses; 0 differing bits; mean 0.884684 s,
  goodput 83543.1 B/s. First transfer: 255 TX submitted/completed,
  152 RX accepted, 103 RX dropped, 103 link retries; no TX errors,
  RX overflow, RX timeout, or link failures.
- Both saved RX images match the source SHA256:
  67baf57173fcc1a933e11441bed11528fb98cdf33ac62937fede91ed2609f4b6.
- Same maintained build historical baseline: lwip_audit/maintained_20/,
  20/20, mean 0.159240 s, goodput 463262.6 B/s. Current solo test is
  about 5.6 times slower in mean latency.

## Earlier comparison

The older build_dma_sw_tcp_fix application was loaded first, before checking
current source copies showed build_dma_sw_maintained was newer. Its hashes
matched progress_fix_validation/artifacts.json. Live results in
final_tcp_fix_live_20261009/image_benchmark/: 26/50 success, 24 status=5
failures, success mean 1.814826 s. Failure 1 had 1306 TX completed,
1183 RX dropped, 1167 link retries and 1 link failure, with no DMA errors
or RX overflow/timeouts. Five small UART requests passed.

## Next prerequisite

Investigate the increased pre-DMA RX discard count and radio retry behavior.
rtl/board/ofdm_dma_rx.v increments dropped for interrupted packets, invalid
FCS/length, discard conditions and timeout. These counters alone cannot
identify a physical antenna fault, interference, RF gain issue or timing fault,
and are not a raw RF loss/BER measurement.

Confirm the TX1/RX1 antenna or attenuated RF connection and whether it changed
since the fast baseline. Do not connect TX directly to RX without appropriate
attenuation. Repeat the same solo test under stable RF conditions before
declaring speed accepted. Keep QSPI unchanged until acceptance passes, then
identify the physical flash, generate/review the matching FSBL/bitstream/app
boot image, program with verification, and request a user-controlled power-off
and QSPI boot-mode change for an independent cold-boot test.