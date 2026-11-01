# KV260 image preprocessing HLS IP

Persistent source: `/home/amd/Workspace/HLS_IP/image_preprocess`.
Design specification: `/home/amd/Workspace/dpu_platform2/IMAGE_PREPROCESS_HLS_DESIGN.md`.
Target: Vitis HLS/Vivado 2022.1, `xck26-sfvc784-2LV-c`, 200 MHz.

The frame task reads aligned BGR888 from DDR, applies optional color LUT,
saturation and luminance equalization, and produces a 416×416 RGB NHWC INT8
tensor, an original-size enhanced BGR preview, or both. The inference branch
can select the original image independently of the enhanced preview.

## Build and verify

From an environment containing `vitis_hls` and `vivado`:

```sh
cd /home/amd/Workspace/HLS_IP/image_preprocess
bash /home/amd/Workspace/HLS_IP/image_preprocess/scripts/check_lut_arithmetic.sh
HLS_STAGE=csim vitis_hls -f /home/amd/Workspace/HLS_IP/image_preprocess/scripts/build.tcl
HLS_STAGE=synth vitis_hls -f /home/amd/Workspace/HLS_IP/image_preprocess/scripts/build.tcl
HLS_STAGE=cosim vitis_hls -f /home/amd/Workspace/HLS_IP/image_preprocess/scripts/build.tcl
HLS_STAGE=export vitis_hls -f /home/amd/Workspace/HLS_IP/image_preprocess/scripts/build.tcl
python3 /home/amd/Workspace/HLS_IP/image_preprocess/tb/test_host_config.py
python3 /home/amd/Workspace/HLS_IP/image_preprocess/tb/test_link_config.py
```

`HLS_STAGE=all` runs these HLS steps sequentially. `cosim` requires a preceding
successful synthesis of the current source. The C test runs the full matrix;
RTL uses `--smoke` for several representative transactions including histogram
state changes and both output modes. All generated artifacts live under
`/home/amd/Workspace/HLS_IP/image_preprocess/build`.

OpenCV comparison (requires NumPy and OpenCV; used only in verification):

```sh
PYTHONPATH=/home/amd/Workspace/HLS_IP/image_preprocess/build/python_deps \
python3 /home/amd/Workspace/HLS_IP/image_preprocess/scripts/check_opencv.py \
  /home/amd/Workspace/HLS_IP/image_preprocess/build/image_preprocess/solution_200mhz/csim/build
```

The development machine's isolated `build/python_deps` contains NumPy 1.24.4
and opencv-python-headless 4.10.0.84. The tensor dump comes from the default
640×480 random-frame test. See `VALIDATION.md` for measured results and limits.

## ABI and memory ownership

The C declaration and status values are in `src/image_preprocess.h`.
AXI-Lite register offsets are generated in:

`/home/amd/Workspace/HLS_IP/image_preprocess/build/image_preprocess/solution_200mhz/impl/ip/drivers/image_preprocess_v1_0/src/ximage_preprocess_hw.h`

Use that header or the matching HWH register map. The ABI version is `0x00010000`.
The unsigned function return is the status register. Completion metadata
contains the submitted frame/config IDs; `tensor_bytes`/`preview_bytes` are
zero on failure. These IDs identify the attempted request even on error;
only status `OK` certifies valid output. No hardware cycle counter is provided
in this ABI; measure launch-to-completion time on the host.

* Input dimensions: width 416–1920, height 416–1080. Smaller inputs fall back
  to software. The format is fixed BGR888; shape is fixed `[1,416,416,3]`.
* All four device allocations must have 64-byte-aligned starts and must not
  overlap. C/RTL interfaces do not prove physical allocation, alignment,
  nonoverlap or LUT allocation size; the host must validate these properties.
  Never pass a Python/NumPy virtual pointer as a device address.
* Strides are in bytes, divisible by 16, at least `3*width`, and at most 5760.
  Input/preview capacities must cover `stride*height`; tensor capacity must
  be at least 519168 bytes. The geometry, enabled capacities, mode and
  saturation are checked before any AXI memory access.
* LUT buffer: 512 bytes (32 128-bit words), color map at bytes 0–255 and signed
  INT8 quantization bit patterns at bytes 256–511. The caller creates the
  quantization table from the model's actual `fix_point`.
* Preview writes `ceil(3*width/16)` words per row. Unused bytes of the last
  written word are zero; any additional stride words remain untouched.
  `preview_bytes` reports valid pixels (`3*width*height`), excluding stride.
* `output_mode`: 0 tensor, 1 preview, 2 both. Disabled outputs receive no
  writes; retain valid distinct allocations for the interface and host helper.
* `flags`: bit 0 color LUT, bit 1 saturation, bit 2 use enhancement for tensor,
  bit 3 reset previous-frame histogram history. Enhancement is disabled by
  default. `saturation_q12` is 0–8192, with 4096 representing 1.0.
* `eq_mode`: 0 off, 1 current frame (two DDR reads), 2 previous frame (one read).
  Previous mode first/reset frames bypass equalization entirely. History resets
  on dimensions, config ID, relevant flags, saturation or mode changes.
  Increment config ID whenever color LUT contents change, and assert reset
  after camera/accelerator restart. History registers are initialized by the
  bitstream; explicit `RESET_HISTORY` is required after a soft restart.
* Host writes and flushes/syncs source and LUT memory before launch. Disable
  auto-restart; keep registers, LUTs and source unchanged until `ap_done`.
  Wait with timeout, check status and IDs, then invalidate/sync outputs.
  Retain tensor ownership until the DPU runner completes. A successful HLS
  run does not establish VART zero-copy or cache coherency.

`host/config.py` supplies dependency-free LUT generation and request validation.
It also rejects overlaps, bad addresses and invalid capacities. It deliberately
does not import PYNQ or write unverified board registers. Tensor/runner shape,
dtype and `fix_point` must be checked by the application before using it.

## Numeric behavior

Color LUT, signed saturation, chroma conversion/reconstruction and CDF LUT use
nearest-even rounding and unsigned 8-bit clipping according to the design.
Constant-image histograms generate an identity LUT; current equalization still
performs the specified chroma round trip. First-frame previous equalization
bypasses that round trip. Histogram dependencies are retained (statistics II=2).

CDF normalization uses a 22-bit frame count, a 30-bit scaled numerator and
eight sequential quotient-bit comparisons. It retains the remainder for exact
nearest-even rounding, eliminating the general divider and quotient-times-count
DSP multiplication. The direct arithmetic regression covers sparse/random
histograms, the maximum frame count, constant frames and both tie directions.
Measured synthesis results are in `CRITICAL_PATH_OPTIMIZATION.md`.

Resize uses exact rational half-pixel coordinates, nearest-even Q11 fractional
weights, two BGR row banks and one final half-up rounding after the Q22 bilinear
sum. This convention is tested against its independent golden model. OpenCV
`INTER_LINEAR` can differ in intermediate rounding; do not call the accelerator
bit-exact with OpenCV. Default geometry is 640×480 → 416×312 with 52 gray rows
above/below. Padding is 128 before quantization, RGB channel order is explicit,
and quantization uses the host LUT (`round_even(pixel*2^(fix_point-8))`).

## Integration

The delivered artifact is Vivado IP rather than an `.xo`:

`/home/amd/Workspace/HLS_IP/image_preprocess/build/image_preprocess/solution_200mhz/impl/export.zip`

The IP repository is the adjacent `impl/ip` directory. To insert into an opened
copy of the source platform BD:

```tcl
source /home/amd/Workspace/HLS_IP/image_preprocess/scripts/integrate_bd.tcl
```

The script enables PS HP2/HP3 at 128 bits, connects `gmem_in` to HP2 and both
output masters through SmartConnect to HP3, attaches AXI-Lite to a new control
interconnect slot, and uses `clk_wiz_1/clk_out3` with `proc_sys_reset_2`.
The current driver polls completion; interrupt is left unused. Addresses are
allocated by Vivado. The script fails when required cells are absent or the
memory ports are already occupied. It is not idempotent after insertion.

An isolated insertion/BD-validation check can be reproduced with:

```sh
vivado -mode batch -source /home/amd/Workspace/HLS_IP/image_preprocess/scripts/validate_integration.tcl
```

This does not run complete DPU place/route or deploy hardware. The input source
BD has platform tags for HP2/HP3, but its generated PS metadata marks these
interfaces disabled. Re-export the modified platform, regenerate HWH/xclbin
as required and rerun DRC/CDC/timing and full implementation.

`scripts/make_link_config.py` creates a candidate Vitis configuration by merging
new clock/connectivity entries into the existing file and preserving DPU/sfm:

```sh
python3 /home/amd/Workspace/HLS_IP/image_preprocess/scripts/make_link_config.py \
  /home/amd/Workspace/dpu_platform2/kv260_vitis_platform2/dpu_trd_system_hw_link/Hardware/dpu-link.cfg \
  /home/amd/Workspace/HLS_IP/image_preprocess/build/dpu-link-with-image.cfg
```

It refuses to overwrite the source or an existing output. This candidate
requires a separate valid `.xo` export, actual `kernel.xml` name verification
and the updated platform; the Vivado IP ZIP cannot be supplied directly to
`v++ --link`. Choose one owner (MMIO or XRT) for accelerator scheduling.

Mapped resource counts can be reproduced after HLS synthesis:

```sh
vivado -mode batch -source /home/amd/Workspace/HLS_IP/image_preprocess/scripts/synth_ip.tcl
python3 /home/amd/Workspace/HLS_IP/image_preprocess/scripts/report_hls.py
```

This synthesizes the current HLS-generated RTL out of context. Timing has
unconstrained external AXI delays and estimated routing; a positive slack
here does not establish timing closure in the complete DPU design.