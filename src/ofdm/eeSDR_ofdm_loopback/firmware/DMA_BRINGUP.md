# Workspace cleanup note

Historical `build_*` paths in this bring-up record are no longer present.
Current build commands are documented in
`/home/amd/ofdm/eeSDR_ofdm_loopback/README.md`; the maintained hardware and
software package is `/home/amd/ofdm/eeSDR_ofdm_loopback/release_qspi_20261009`.

# DMA board bring-up and reproducible fixes

The board is configured as `192.168.137.10/24`, TCP port `5001`. The host
observed during bring-up was `192.168.137.83`; the Windows gateway was
`192.168.137.1`. Do not assign the board the gateway's address.

Two independent configuration errors were found on the physical board:

* The PHY reports ID `001c:c916`. The lwip211 v1.7 Realtek branch tests
  register 17 bit `0x0400` after negotiation. That register reads zero on
  this PHY even when BMSR reports link and negotiation complete. The
  application-owned `board_phy.c` wrapper selects this exact ID, advertises
  full duplex, resolves speed from the standard Clause 22 registers, and
  configures GEM0's generated SLCR divisors. Other PHYs use the BSP code.
  No vendor RGMII-delay register guesses are applied. The wrapper is linked
  by `build_dma_sw.tcl`, so BSP regeneration preserves the adaptation.
* AXI DMA's `c_sg_include_stscntrl_strm` defaulted to 1, although the OFDM
  design has no external status/control stream. S2MM wrote a correct
  received packet into DDR but did not mark the RX descriptor complete.
  The observed counters were TX complete=50, RX accepted=49, overflow=0;
  the first RX buffer contained the transmitted `01 02 03 04` payload and
  its matching protocol header, while the descriptor status remained zero.
  `connect_dma_bd.tcl` now explicitly disables that optional stream.

`firmware/check_dma_xsa.py` checks the actual exported hardware parameters
before a software workspace is created. It rejects the original XSA with
`C_SG_INCLUDE_STSCNTRL_STRM=1`. Rebuilding only the ELF cannot repair this
second error: the bitstream and matching XSA must also be rebuilt.

Build into unused directories, with Vivado/Vitis 2022.1:

```sh
/tools/Xilinx/Vivado/2022.1/bin/vivado -mode batch \
  -source /home/amd/ofdm/eeSDR_ofdm_loopback/build_dma.tcl \
  -tclargs /absolute/new/hardware bitstream
/tools/Xilinx/Vitis/2022.1/bin/xsct \
  /home/amd/ofdm/eeSDR_ofdm_loopback/firmware/build_dma_sw.tcl \
  /absolute/new/hardware/TOP.xsa /absolute/new/software 10 137
/tools/Xilinx/Vitis/2022.1/bin/xsct \
  /home/amd/ofdm/eeSDR_ofdm_loopback/firmware/program_dma.tcl \
  /absolute/new/hardware/ofdm_ad9361.runs/impl_1/TOP.bit \
  /absolute/new/software/ofdm_dma/Debug/ofdm_dma.elf \
  /absolute/new/software/dma_platform/hw/ps7_init.tcl
```

The hardware build checks routed internal setup, hold, pulse-width timing,
and unconstrained internal endpoints before exporting the XSA. Board-level
external I/O delays remain subject to the existing timing report limitations.

Run regressions with
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/run_dma_regression.sh`.
The PHY test exercises speed selection, latched link status, timeouts,
MDIO failures, clock programming and fallback to other PHY drivers.

For live diagnosis, pass the matching XSA to
`/home/amd/ofdm/eeSDR_ofdm_loopback/firmware/diagnose_dma.tcl`.
It loads the PL memory map, reads packet counters and DMA registers, and
resumes CPU0 even when the diagnostic body fails. Run it between transfers:
pausing the CPU can disrupt TCP timers and ARQ deadlines.

Acceptance requires actual returned bytes: UART enqueue acceptance alone is
insufficient, and a TCP connection alone does not prove RF image transfer.
`host/dma_uart.py` matches message IDs and payloads; `host/dma_image.py loopback`
requires the returned image, board CRC status, and drained ACK window before
atomically saving the result. `host/dma_gui.py` previews that saved RX file.

## TCP return-path validation, 2026-10-09

The reproducible firmware configuration in
`/home/amd/ofdm/eeSDR_ofdm_loopback/firmware/build_dma_sw.tcl` now sets
`TCP_MSS=1440` and `TCP_WND=32768`. Generated BSP headers confirm that the
MSS-only experiment used `1440/2048`, and the final build used `1440/32768`.
Both retain `TCP_SND_BUF=8192`, `MEM_SIZE=131072`, and 256 TCP segments/pool
pbufs.

The generated lwip211 v1.7 `xemacpsif_dma.c` caps each TX descriptor's pbuf
length at `XEMACPS_MAX_FRAME_SIZE - 18`, or 1500 bytes. A contiguous pbuf
with a 1460-byte TCP payload plus Ethernet/IPv4/TCP headers needs 1514
bytes; a 1440-byte payload needs 1494 bytes with the configured basic
headers. This supports the truncation explanation for the return stalls;
it is not a wire-capture confirmation. MSS 1440 is a workaround for this
driver/configuration, not a general Ethernet MTU requirement.

The 2048-byte receive window is small relative to 1026-byte application
records. Raising it to 32768 permits multiple full records/segments while
remaining below the services input ring's 64 KiB capacity. The separate
MSS-only and window experiments distinguish reliability from latency:

| Configuration | Host TCP mode | Successes | First data median / p95 (ms) | Transfer median / p95 (ms) | Run wall time (s) |
| --- | --- | ---: | ---: | ---: | ---: |
| MSS 1440, window 2048 | NODELAY | 20/20 | 213.574 / 241.105 | 426.309 / 477.364 | 7.605 |
| MSS 1440, window 2048 | Nagle | 20/20 | 211.408 / 232.471 | 434.123 / 466.698 | 8.530 |
| MSS 1440, window 32768 | NODELAY | 20/20 | 2.163 / 3.802 | 156.987 / 216.995 | 3.500 |
| MSS 1440, window 32768 | Nagle | 20/20 | 2.122 / 3.205 | 155.969 / 160.600 | 3.191 |
| MSS 1440, window 32768 | NODELAY | 200/200 | 2.166 / 3.773 | 156.300 / 215.684 | 32.163 |

All five runs report zero differing bits and zero failed transfers. Each
transfer returns the 73,944-byte demo image in 74 fragments, checks board
CRC status, and waits for the upload ACK window to drain. Times are measured
from transfer start, with upload and receive proceeding concurrently. Each
run uses a persistent TCP connection, no scheduled inter-transfer sleep,
and a 30-second whole-transfer deadline. NODELAY/Nagle refers to the host
socket option. The final three runs execute sequentially without JTAG stall
probes in the benchmark runner.

The 200-transfer run compared 118,310,400 delivered bits, achieved
459,800.8 application bytes/s, and had maximum first-data/transfer times
of 10.951/229.953 ms. Thus the earlier approximately 210 ms first-data
delay is absent in this sample; occasional full-transfer latency outliers
remain. This is a 32-second endurance sample, not a long-duration soak.

Evidence is retained under
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/progress_fix_validation/`:
`mss1440_{nodelay,nagle}_20/` and `final_{nodelay_20,nagle_20,nodelay_200}/`
contain configuration, per-transfer records, summaries, and the last saved
RX image. `build_tcp_fix.log`, `program_tcp_fix.log`, and
`regression_final.log` end with software-build, boot, and regression pass
markers. The regression covers DMA packet/control RTL, C link/services/PHY
tests, and 23 host Python tests.

Socket diagnostics are not clean: the last sampled socket in
`final_nodelay_200.ss.log` reports `bytes_sent:25154032`,
`bytes_retrans:9974432`, and `retrans:0/7293`. In that field, zero means
no retransmissions currently outstanding; 7293 is cumulative. These are
host TCP send statistics, not RF error counters. Successful application
delivery does not explain the retransmissions, reordering, or latency
outliers. Packet capture remains unavailable without interface privileges;
raw RF BER/loss and the precise TCP failure mechanism remain unmeasured.

The deployed hardware is in
`/home/amd/ofdm/eeSDR_ofdm_loopback/build_dma_progress_fix/`, with firmware
in `/home/amd/ofdm/eeSDR_ofdm_loopback/build_dma_sw_tcp_fix/`. The hardware
XSA and the firmware platform's copied XSA have identical SHA-256 hashes.
`/home/amd/ofdm/eeSDR_ofdm_loopback/build_dma_progress_fix/routed_timing.rpt`
reports 80 MHz OFDM clocks, WNS +0.602 ns, WHS +0.035 ns, WPWS +3.250 ns,
and zero failing setup/hold/pulse-width endpoints. The external I/O timing
limitations described above still apply.

| Final artifact | SHA-256 |
| --- | --- |
| Hardware `TOP.xsa` and firmware platform `TOP.xsa` | `72683c6833e3903ee8272189730790fedad737def9289daf40d0048582c2ab43` |
| Hardware `ofdm_ad9361.runs/impl_1/TOP.bit` | `e1b50d9cac44bb95bf184419071a8448bc40dff254f7f1ed2e3856c01209f9b6` |
| Firmware `ofdm_dma/Debug/ofdm_dma.elf` | `8f92f5f5d4f8cbfa2eff2a622634afb9fecc4962b62c3525fce044c58b1b4666` |
| Firmware `dma_platform/hw/ps7_init.tcl` | `650afea958fe29f09eb5f8930a440aab4069b0456601bb8c6dfd1e69437cb105` |
| Exported BSP `lwipopts.h` | `7242adedcde5b03ed3004fb6c2e22313ac5379e076b6bcce58705d7c23890fd9` |

The machine-readable manifest is
`/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/progress_fix_validation/artifacts.json`.
Use its `build_dma_sw_tcp_fix` entry for the final firmware and hardware;
the `new` entry describes the earlier progress-fix experiment.