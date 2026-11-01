# KV260 YOLOv4 postprocessing IP

Source: `/home/amd/Workspace/HLS_IP/yolo_postprocess`.
Companion to `/home/amd/Workspace/HLS_IP/image_preprocess`; independent Vivado IP,
Vitis HLS/Vivado 2022.1, `xck26-sfvc784-2LV-c`, target 200 MHz with 0.625 ns uncertainty.

## Scope

Hardware covers three YOLOv4 output scales, INT8 dequantization via configurable
sigmoid/exp tables, best class, confidence filtering, anchor decode and optional
classwise greedy NMS. Software retains letterbox coordinate restoration/clipping,
depth ROI statistics, tracking, drawing, ROS2 and acquisition. Coordinate mapping
is cheap for the small final list; doing it after NMS preserves operation order.

The accelerator scans 10,647 anchors/904,995 INT8 bytes once. It selects the largest
signed class logit before looking up one class sigmoid (monotonic transformation),
avoiding 80 sigmoid lookups per anchor. It consumes all bytes sequentially, even
for rejected anchors. Width/height tables include anchors and half-size scaling;
there are no runtime floating-point exp, sigmoid or divisions in RTL. NMS reuses
arithmetic and BRAM instead of an all-pairs parallel network. This trades cycles
for bounded area. No top-K approximation is applied.

NMS area multipliers have explicit two-cycle fabric bindings and registered
interfaces. The Q16 threshold product uses 17 sequential shift/add steps,
preserving the full 82-bit result while removing the large 65-by-17 fabric
multiplier. Overlapping-box comparison latency is up to 23 cycles; the candidate
scan and the strict IoU comparison are unchanged. See
`CRITICAL_PATH_OPTIMIZATION.md` for the measured area/timing tradeoff.

## ABI

Authoritative declaration: `/home/amd/Workspace/HLS_IP/yolo_postprocess/src/yolo_postprocess.h`.
Generated AXI-Lite register header from the matching export is authoritative for
offsets. No hardcoded register offsets are supplied.

* Input: contiguous scales **52,26,13**, each NHWC `[1,H,H,255]`, anchor-major
  85-byte records (4 coordinates, objectness, 80 classes). No inter-scale padding;
  pad the final allocation to 905,008 bytes (56,563 128-bit words).
* Tables: 5,376 little-endian u32 words (21,504 bytes); per-scale 256-entry sigmoid
  Q15, followed by six half-width/height Q8 tables. Signed INT8 bit patterns index
  each table. Host must use validated `make_tables()` and actual per-output
  `fix_point`, sorted by grid. Standard COCO anchors only; fixed 416 input.
* Output: allocation of at least 8,192 bytes; up to 256 32-byte records, each
  `x1,y1,x2,y2` signed Q8, score unsigned Q30, class u32, global anchor ID u32,
  reserved zero u32. Coordinates are unclipped letterbox pixels.
* `confidence_q30`: (0,2^30]; `nms_q16`: [0,65536]; `enable_nms`: 0/1.
* Status 0: success; status 1: invalid request; status 2: candidate overflow.
  Invalid/overflow requests write no detections and return detection_count=0.
  On overflow candidate_count saturates at 256; it is not the total count.
  Host must run the ORIGINAL whole-frame software path on overflow, never accept
  truncated results. No stale output beyond detection_count is valid.
* All allocations must have aligned (64-byte) physical starts, disjoint ranges,
  and validated capacities. Only scalar capacities/config are checked by RTL;
  LUT contents, physical addresses and ownership are trusted host preconditions.
* Host must synchronize CPU writes before launch, wait for DPU completion before
  consuming DPU outputs, wait for postprocess completion and invalidate results.
  Retain all buffers until completion; on timeout drain/reset before reuse.

`/home/amd/Workspace/HLS_IP/yolo_postprocess/host/config.py` validates the memory ABI
and constructs tables; `/home/amd/Workspace/HLS_IP/yolo_postprocess/host/adapter.py`
provides tensor ordering, packing, output conversion and overflow fallback through
an injected device executor. It is not a board MMIO driver. It currently copies
the three tensors into a staging buffer; board timing must include this cost.
The existing remote camera application is not yet switched to this IP.

## Numeric compatibility

Scores use rounded Q15 sigmoid values and Q30 products; coordinates use Q8.
Exp inputs clip to [-10,10], sigmoid inputs to [-30,30], as in Python. Greedy NMS
uses cross multiplication, suppressing IoU strictly greater than the Q16 threshold;
it omits Python's tiny `1e-9` union epsilon. It does not clip boxes before NMS.
Ties choose the first class logit and first input anchor. Python float32 sigmoid
saturation can produce class-score ties for distinct logits, and NumPy argsort
can reorder tied scores. Neither tie behavior nor boundary decisions are claimed
bit-exact. Quantization can change near-threshold scores/IoUs, including at
non-default thresholds. Dataset regression is required before deployment.

## Build

```sh
bash /home/amd/Workspace/HLS_IP/yolo_postprocess/scripts/check_nms_arithmetic.sh
LD_PRELOAD=/lib/x86_64-linux-gnu/libm.so.6 HLS_STAGE=all vitis_hls -f /home/amd/Workspace/HLS_IP/yolo_postprocess/scripts/build.tcl
PYTHONPATH=/home/amd/Workspace/HLS_IP/image_preprocess/build/python_deps python3 /home/amd/Workspace/HLS_IP/yolo_postprocess/tb/check_python.py /home/amd/Workspace/HLS_IP/yolo_postprocess/build/yolo_postprocess/solution_200mhz/csim/build
vivado -mode batch -source /home/amd/Workspace/HLS_IP/yolo_postprocess/scripts/synth_ip.tcl
```

Stages: csim, synth, cosim, export, all. RTL smoke covers empty, populated,
overflow, full-capacity decode-only and overlapping-NMS frames. C tests additionally cover
invalid configurations, output guards and an independent floating reference.
Python tests execute the actual application's AST-extracted decode/NMS functions
without loading board hardware. Generated reports reside under
`/home/amd/Workspace/HLS_IP/yolo_postprocess/build`.

On this Linux x86_64 installation, preloading system libm avoids extremely slow
vendor exp evaluation in the floating reference test bench. The kernel contains
no floating-point math. Keep the tool's bundled GCC for co-simulation: overriding
AP_GCC_PATH with the system GCC caused a PIE link error in generated test code.
Assertions are explicitly enabled in the test bench even with release-mode csim.

## Deployment limits

Existing preprocessor alone uses 13,543 LUT, 13,299 FF, 11.5 BRAM tiles and 52 DSP.
The original entire-subsystem budget (15k LUT/20k FF/20 BRAM/48 DSP) is already
exceeded in DSP and cannot be assumed to accommodate this independent IP.
Historical platform placement occupies 97.9% of CLB sites with 0.011 ns WNS.
Actual mapped resource reports and integrated routing are acceptance gates;
200 MHz HLS scheduling and isolated synthesis are not integrated timing closure.
No platform memory ports may be assumed free after inserting the preprocessor;
integration must extend/share the existing interconnect with proper clock/reset.

Measure PS baseline versus accelerator launch+staging+sync+kernel+result time,
candidate counts/overflow frequency, and total FPS under concurrent DPU traffic.
Fallback may be frequent on crowded/low-threshold frames. Hardware NMS is optional
at runtime; disabling it does not remove its synthesized area. A smaller build
would require a separate synthesis configuration and validation.