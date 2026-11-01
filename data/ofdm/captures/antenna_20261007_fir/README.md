# FIR bandwidth diagnosis and hardware validation — 2026-10-07

The patched PL still failed antenna packets because the enabled AD9361 TX/RX
FIR coefficient pair suppressed occupied OFDM edge carriers. At 40 MS/s and
NFFT=64, bins ±25 and ±26 are at ±15.625 and ±16.25 MHz. Evaluating the actual
64-tap coefficients gives combined attenuation relative to DC of 19.29 dB and
80.62 dB respectively. Setting the analog RF bandwidth to 40 MHz does not
redesign these FIRs. Run `fir_response.py` in this directory to reproduce.

## Evidence

- Capture 221: original FIR configuration, patched PL. 640 TX samples plus a
  valid zero at cycle 1345, after TX done at 1344. RX cadence is two clocks.
  Post-packet RX RMS is about 13 ADC codes and mean -0.145+j1.511 codes.
  The previous TX idle defect is therefore fixed in the running PL.
- Capture 220: payload-triggered window has all 64 decoded bytes and failed FCS.
- Capture 221: complete TX/RX window. Edge channel magnitudes at +25/+26 are
  0.111/0.053; at -25/-26 approximately 0.098/0.055. Other bins are mostly
  0.7–1.2. Very small theoretical FIR output is masked by measured noise and
  other impairments; the measured floor is not an 80 dB attenuation measurement.
- `ofdm_rx_replay.v` feeds every captured RX cycle (including valid gaps) to
  the real RX RTL and v6 Xilinx IP models. Capture 221 reproduces **all 64
  hardware error bytes exactly**, with FCS failure. Capture 222 reproduces
  00..3f with successful FCS. See `ofdm_replay221.log`/`ofdm_replay222.log`.
- Capture 222: FIR bypass; edge channel amplitudes recover to +25/+26
  0.663/0.591 and -25/-26 0.500/0.425. Offline data-symbol EVM estimates
  are 8.34%, 6.76%, 8.28%, versus 89.88%, 27.35%, 38.54% in capture 221.
  These are diagnostic estimates using TX IQ, LTS-based equalization and
  pilot common-phase correction, not a standards-compliance measurement.

## Controlled hardware comparison

Only PS firmware was downloaded during this diagnosis; PL was not rebuilt or
downloaded. The independent bypass experiment replaced FIR load/enable with
`ad9361_set_trx_fir_en_dis(ad9361_phy, 0)` and preserved other initialization.

| Configuration | Test | Result |
|---|---|---|
| Original FIR | 10 repeated 00..3f packets, initial test | 0/10 passed |
| FIR bypass, isolated ELF | 10 fixed + 30 seeded random packets | 40/40 passed |
| Restore original ELF | 10 repeated 00..3f packets | 0/10 passed |
| Final rebuilt ELF, FIR bypass | 20 fixed + 180 seeded random packets | 198/200 passed |
| Repeat the two residual-failure payloads | 20 repeats of each | 40/40 passed |

The final 200-packet test had two FCS failures, indices 77 and 108, with 261
and 26 payload bit errors respectively, and no timeout. Do not claim zero BER
or a fully resolved receiver. Residual errors were not repeatable by payload;
their cause remains unlocated. Capture 223 retransmits index 77 successfully.

The bypass initialization UART readback reports 800 MHz TX/RX LO, 40 MS/s,
40 MHz RF bandwidth, RX CH1 gain 12 dB and MGC mode 0. TX attenuation remains
10 dB in the firmware configuration. The unrelated `ps/main.c` example has
different LO/gain values and is not the source used by this Vitis application.

## Persistent changes and current board state

Both the active Vitis application source
`/home/amd/ofdm/eeSDR_ofdm_loopback/build_80m_neighbor_v6/Vitis/AD936x_PS/src/main.c`
and the source template
`/home/amd/ofdm/eeSDR_ofdm_loopback/ps/AD936X_PS/src/main.c`
now use the driver FIR bypass API and print an explicit bypass message.
The template's unrelated parameters were preserved. The active ELF was built
with its existing makefile and downloaded through XSCT processor restart.
The board is left running this final ELF, using the user's patched PL.
No flash/BOOT.BIN update was made; power cycling may restore an older image.

- Final ELF SHA256: `413c501f8683ba84b6a7316b958cc303e96f60d81609c09f2296475d3ca6d527`
- Original ELF SHA256: `19fa9a396b2599fdcb46b0fd6c7b29c4beb695c3ce570a659b14f49fa0c1dbe2`
- PL bit SHA256: `e02e58856b7c2d98978efee74b47c8c0a1457f14fdbc9d93ffb99bc51dd65c89`

`original_fir.elf` and `final_fir_bypass.elf` preserve both firmware variants.
Bypass is validated for the current link; a production FIR design should pass
all occupied carriers and be checked for ripple, EVM and spectral performance.
Digital TX-to-RX interface loopback does not exercise the normal RF/filter
path, so its success does not validate the original FIR configuration.

## Reproduction and limitations

`check_packets.py` is the repeatable UART test. For example:

```sh
python3 /home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/antenna_20261007_fir/check_packets.py --count 200 --output /tmp/ofdm_packets_repeat.json
```

The archived capture/replay scripts are session records with `/tmp` paths.
`ofdm_analyze_new.py /absolute/path/capture.csv` writes the cycle-level replay
input next to the CSV. The testbench takes `+INPUT=/absolute/path/capture.csv.txt`.
The compiled snapshot `antenna_replay` remains in `/tmp/ofdm_idle_sim`, compiled
against the existing v6 IP project and the libraries listed by the repository's
`sim/run_xsim.sh`. Example (Xilinx tools on PATH):

```sh
cd /tmp/ofdm_idle_sim
xsim antenna_replay -runall -testplusarg INPUT=/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/antenna_20261007_fir/ofdm_new_capture_221.csv.txt
```

UART is released and the last ILA acquisition completed. Targeted whitespace
checks pass for the edited firmware; the global worktree check reports existing
Eclipse `.metadata` whitespace changes, which were not modified here.