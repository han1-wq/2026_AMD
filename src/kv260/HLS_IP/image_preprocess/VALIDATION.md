# Validation record — 2026-10-13

Toolchain: Vitis HLS and Vivado 2022.1, Linux x86_64.
Part: `xck26-sfvc784-2LV-c`. Clock: 5 ns / 200 MHz.
All files and logs below are relative to
`/home/amd/Workspace/HLS_IP/image_preprocess`.

## Functional evidence

* Final C simulation: PASS, 24 valid frame scenarios and 7 invalid requests.
  `build/final_all.log` contains the full C simulation record.
* Final Verilog C/RTL co-simulation: PASS for all five consecutive transactions,
  with zero post-check failures and no DATAFLOW deadlock detected. Covers
  640×480 current-frame equalization with both outputs, previous-frame startup,
  repeated-bin previous-frame update/application, configuration reset with
  preview-only output and enhancement bypass with tensor-only output.
* Independent golden model uses double arithmetic for color, saturation,
  chroma and CDF rounding, and independently computes rational half-pixel
  coordinates with the declared Q11 coefficient convention. It does not
  invoke accelerator helper functions. Tensor and preview bytes, metadata,
  capacity guards, row tails and disabled outputs are checked.
* Frame coverage includes seeded random data, constants, repeated histogram
  bins, two-bin distributions, black/white, checkerboard, BGR color bars,
  gradients, 640×480, 641×479, 1280×720, 1920×1080, 416×416, 1920×416 and
  416×1080. Enhancement coverage includes identity, clipping, alpha 0/1/1.5/4,
  beta limits, saturation 0/1/1.5/2, original tensor with enhanced preview,
  current-frame equalization, previous-frame startup/config/mode changes.
* Invalid requests cover dimensions, stride, source capacity, output mode,
  geometry, saturation and unknown flags. These use null memory pointers to
  verify rejection occurs before memory access in C simulation.
* Host validation: 4 Python unittest cases pass; alignment, capacity and
  physical range overlap are checked here. Alignment, overlap and LUT capacity
  are preconditions of the hardware ABI, not checks implemented in RTL.
* Link configuration merge: 3 Python unittest cases pass. An additional check
  against the actual DPU link file confirms preservation of every original
  nonblank line, duplicate `nk`/`id` entries, unique sections and PS HP1 mapping.
* Quantization table: all 256 entries match NumPy for fix points
  -16, -1, 0, 4, 6, 7, 8, 12 and 16. Example ties 2→0, 6→2, 10→2 at fix=6.

## OpenCV compatibility

OpenCV 4.10.0, NumPy 1.24.4, one seeded random 640×480 frame, enhancement off,
416×312 bilinear resize, 52-row padding, RGB and fix=6 quantization:

| Measurement | Result |
|---|---:|
| Compared INT8 bytes | 519,168 |
| Differing bytes | 12,285 (2.3663%) |
| Maximum absolute INT8 difference | 1 |
| Mean absolute INT8 difference | 0.0236628606 |
| Padding value/order | Exact |

The accelerator uses one final half-up rounding of the Q22 bilinear sum.
OpenCV can round intermediate stages differently. This check establishes
the observed quantized bound on this test frame, not a universal error bound
and not detection accuracy. Board OpenCV golden frames, a dataset precision
regression and threshold-sensitive YOLO samples remain required before
accepting this interpolation difference for deployment.

## Synthesis and resources

HLS pipeline schedules: read/unpack/color/resize/pack/write loops II=1;
histogram update loops II=2, with the true RAM dependency preserved.
Input and output AXI bursts were inferred. Runtime AXI settings use 128-bit
words, max 32-beat bursts and two outstanding requests. FIFOs use depth 64;
two 1920-pixel BGR row banks provide resize storage without a frame buffer.

| Resource | HLS estimate | Vivado mapped OOC synthesis | Design target |
|---|---:|---:|---:|
| LUT | 28,989 | 13,543 | ≤15,000 |
| FF | 18,781 | 13,299 | ≤20,000 |
| BRAM | 54 BRAM18K | 11.5 BRAM Tiles | ≤20 Tiles |
| DSP | 46 | 52 | ≤48 |
| URAM | 0 | 0 | 0 |

HLS estimates and mapped counts are different measurements; the HLS BRAM
estimate is not a measured 27-tile physical allocation. The mapped DSP count
exceeds the target by 4. Earlier mapped synthesis used 93 DSP; integer address
widths, fabric bindings, constant shift/add arithmetic and equivalent
difference-form bilinear interpolation reduced that count to 52.

HLS estimated period: 4.659 ns (about 214.65 MHz). HLS warns that this exceeds
the effective 4.375 ns budget after the configured 0.625 ns uncertainty.
Vivado OOC synthesis at 5 ns reports WNS +0.452 ns, WHS +0.084 ns and no
internal unconstrained endpoints, with external AXI inputs/outputs lacking
I/O delay constraints. It also warns that `HD.CLK_SRC` is unset in OOC mode.
No routed design exists for this IP with the DPU. These measurements must not
be presented as timing closure of the complete system.

Evidence: `build/image_preprocess/solution_200mhz/syn/report`,
`build/rtl_synthesis_final.log`, `build/rtl_synthesis/utilization.rpt`,
`build/rtl_synthesis/timing.rpt`, `build/rtl_synthesis/image_preprocess.dcp`.
The initial mapped reports are retained under `build/initial_resource_reports`.

## Integration verification

`scripts/validate_integration.tcl` reconstructed the original source BD in an
isolated project, inserted the exported IP with `scripts/integrate_bd.tcl`,
enabled HP2/HP3 and passed `validate_bd_design`. The original platform, DPU
settings, link config and application were not modified.

The validated copy connects input to HP2, tensor/preview through a two-input
SmartConnect to HP3, and AXI-Lite through a new control interconnect slot.
Clock/reset use `clk_wiz_1/clk_out3` / `proc_sys_reset_2/peripheral_aresetn`.
Vivado allocated 0x80000000 for the IP's 64 KiB control segment in this isolated
copy; this is an observation, not a fixed deployment address. DDR low/high
segments are mapped. Addresses are in `build/integration_check/addresses.txt`.

Remaining BD messages include PS/interconnect AXI USER width adaptation,
the 199.998 MHz platform clock versus the IP's 200 MHz metadata, intentionally
excluded OCM address segments, and the source platform's unconnected
`axi_intc_0/intr` (a critical warning because Vitis normally supplies kernel
interrupt wiring). The IP integration uses polling. Missing source XCI files
in the isolated copy were reconstructed from installed IP definitions.
Resolve or explicitly review these messages in the full platform build;
BD validation alone does not establish DRC/CDC/timing or interrupt correctness.

## Limits before deployment

No camera, PYNQ, ROS2 or VART board execution has occurred. There is no tested
zero-copy integration, frame-ownership recovery after timeout, dataset accuracy
result, random AXI stall stress test, or combined DPU implementation.
The API provides IDs, status and valid byte counts but no hardware cycle counter.
The exported artifact is Vivado IP; the generated candidate Vitis link file
requires a separately exported `.xo` and kernel metadata verification.

Next acceptance steps are board golden frames, dataset accuracy, review of
the 4-DSP budget excess, full DPU placement/routing and timing/CDC/DRC, then
cache/ownership integration and 640×480@30 measurements under DPU concurrency.

## Final RTL latency and exported artifact

Measured in XSIM using the AXI memory model, at 5 ns per cycle:

| RTL transaction | Cycles | Simulated latency |
|---|---:|---:|
| 640×480, current equalization, tensor + preview | 1,142,239 | 5.711195 ms |
| 416×416, previous equalization first frame | 462,791 | 2.313955 ms |
| 416×416, apply previous LUT and collect repeated bin | 451,238 | 2.256190 ms |
| 416×416, configuration reset, preview only | 374,682 | 1.873410 ms |
| 416×416, enhancement bypass, tensor only | 381,616 | 1.908080 ms |

These are simulated kernel task latencies. They exclude CPU staging/sync,
real DDR contention, DPU, capture/decode and host launch overhead; they do not
establish board FPS. The report is
`build/image_preprocess/solution_200mhz/sim/report/image_preprocess_cosim.rpt`.
FIFO depth 64 completed these scenarios without deadlock; no quantitative
occupancy profile or randomized backpressure stress result is claimed.

Final Vivado IP export: `build/image_preprocess/solution_200mhz/impl/export.zip`.
ZIP integrity, `component.xml`, three memory interfaces and AXI-Lite control,
and the generated register header were checked. SHA256:
`a4e9e6be65d62bdcabd1aef067d88f92a868308078b7dde9a92917dcaa11d1e0`.
Source/document/artifact hashes are recorded in `build/artifact_sha256.json`.