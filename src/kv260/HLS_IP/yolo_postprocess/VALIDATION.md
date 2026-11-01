# Postprocessing validation — 2026-10-13

This is a standalone candidate IP, not an integrated/board-qualified accelerator.
All paths in the table below are relative to
`/home/amd/Workspace/HLS_IP/yolo_postprocess`.

## Verified functional results

* Native C++ simulation against independent floating decode/NMS: eight valid
  scenarios and six invalid configurations pass. Coverage includes empty,
  three-scale populated frames, candidate count 256, overflow at 257, NMS
  overlap suppression, decode-only bypass and output sentinels.
* Final Vitis HLS C simulation: PASS, zero errors (`build/csim_final.log`), with system libm preloaded.
  The test bench undefines NDEBUG so assertions remain active in release mode.
* Verilog C/RTL co-simulation: PASS for five consecutive transactions, including
  zero detections, 50 detections, overflow, 256 decode-only candidates and an
  overlapping same-class pair suppressed to one detection. Post-check assertions
  pass. Log: `build/cosim_native.log`; report:
  `build/yolo_postprocess/solution_200mhz/sim/report/yolo_postprocess_cosim.rpt`.
* Four Python tests pass: actual application's decode/NMS comparison, all-INT8
  LUT checks, physical buffer ABI validation, and adapter/fallback behavior.
* Fixture versus actual `infer_yolov4.py` functions: 50 matching detections,
  maximum coordinate error 0.00379944 letterbox pixels, maximum score error
  0.000024713576. This is a synthetic fixture, not camera/mAP evidence.
* At fix_points -16,-1,0,4,6,8,16, all 65,536 objectness/class INT8 pairs per
  fix_point have the same decision at confidence 0.30 as a float64 sigmoid
  reference. This does not cover arbitrary thresholds or class/NMS ties.

Python fixture checks can use either native `build` or HLS
`build/yolo_postprocess/solution_200mhz/csim/build` as their command argument.
The application functions are loaded by AST extraction, avoiding imports of
PYNQ/VART or creation of board resources.

## Resource and timing evidence

Vitis HLS 2022.1, 5 ns target and 0.625 ns uncertainty: synthesis passes;
all loop constraints satisfied; estimated period 4.375 ns (228.57 MHz).
Top-level HLS latency is variable/unknown; do not infer frame latency from the
inner-loop II or the HLS clock estimate. Conditional input reads prevent a single
whole-frame AXI burst; kernel timing must include actual AXI transactions.

Vivado 2022.1 out-of-context RTL synthesis:

| Resource | Preprocess baseline | Added postprocess | Arithmetic sum | Original subsystem target |
|---|---:|---:|---:|---:|
| LUT | 13,543 | 9,260 | 22,803 | ≤15,000 |
| FF | 13,299 | 6,068 | 19,367 | ≤20,000 |
| BRAM tiles | 11.5 | 12 | 23.5 | ≤20 |
| DSP | 52 | 8 | 60 | ≤48 |
| URAM | 0 | 0 | 0 | 0 |

These sums exclude added platform interconnect and are not an integrated result.
LUT/BRAM/DSP targets are NOT met. The preprocessor's existing 4-DSP overage has
not been resolved by this work. Further area optimization or a changed budget is
required before platform acceptance. No implicit acceptance of an overage occurs.

OOC WNS +0.798 ns, TNS 0; WHS +0.084 ns. External AXI delays are unconstrained,
clock skew/routing is estimated, and no full DPU place/route has occurred.
Reports: `build/rtl_synthesis/utilization.rpt`, `build/rtl_synthesis/timing.rpt`.
Checkpoint: `build/rtl_synthesis/yolo_postprocess.dcp`.

## Numeric and integration limits

RTL AXI-model timing at 5 ns per cycle:

| Transaction | Cycles | Simulated latency |
|---|---:|---:|
| Empty detections | 1,390,494 | 6.952470 ms |
| 50 candidates with NMS | 1,396,386 | 6.981930 ms |
| 257 candidates, overflow return | 1,390,986 | 6.954930 ms |
| 256 candidates, NMS disabled | 1,391,350 | 6.956750 ms |
| Two overlapping candidates, one kept | 1,390,522 | 6.952610 ms |

These are kernel-only simulations, not ARM speedups or board throughput. Dense
256-candidate hardware-NMS worst-case timing, randomized AXI stalls and concurrent
DPU DDR contention have not been measured. Preprocessor current-frame equalization
plus postprocess representative simulated latencies add to approximately 12.69 ms;
this excludes DPU, staging, cache sync, capture, depth, rendering and scheduling.

Q15 sigmoid, Q30 score, Q8 coordinates and Q16 NMS threshold can alter boundary
decisions. Global greedy order across classes is equivalent for untied scores,
but tie handling differs from NumPy argsort. Logit argmax is monotonic in exact
arithmetic; Python float32 sigmoid saturation can create additional ties.
Python adds 1e-9 to union area; hardware omits it. Do not claim bit-exact behavior.

256 candidates bounds BRAM/NMS work. Overflow returns status=2 with no detections;
the provided adapter falls back on the entire original output tensors. It copies
905 KB of DPU results into one staging allocation and uses an injected device
executor; there is no tested MMIO/XRT board driver or zero-copy path yet.

No change was made to the existing preprocessor, DPU platform or remote camera
application. Before enabling hardware, complete platform memory/control wiring,
clock/reset/CDC, full routing, buffer ownership/cache/timeout recovery, real-frame
accuracy regression and ARM latency/FPS measurement under concurrent DPU traffic.

## Exported artifact

Vivado IP export completed and ZIP integrity, component XML, two AXI masters,
AXI-Lite and generated register header verified. Artifact:
`build/yolo_postprocess/solution_200mhz/impl/export.zip` (206,926 bytes).
SHA256: `14c247034fc1a358d6f3e5f5f048fb4037abaab1887a6ae79b70827ccca2e5ac`.
IP repository: `build/yolo_postprocess/solution_200mhz/impl/ip`.
Generated register header:
`build/yolo_postprocess/solution_200mhz/impl/ip/drivers/yolo_postprocess_v1_0/src/xyolo_postprocess_hw.h`.
Source/report/artifact hashes are recorded in `build/artifact_sha256.json`.