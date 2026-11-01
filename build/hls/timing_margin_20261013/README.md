# 200 MHz timing-margin optimization (started 2026-10-13)

## Actual baseline

The user platform has completed implementation, not just synthesis.
Source report:
`/home/amd/Workspace/dpu_platform2/kv260_hardware_platform/kv260_hardware_platform/kv260_hardware_platform.runs/impl_1/kv260_hardware_platform_wrapper_timing_summary_postroute_physopted.rpt`.

Baseline global setup WNS = +0.076 ns, hold WHS = +0.010 ns; setup/hold
violations = 0. The 200 MHz clock period is 5.000 ns. This meets the current
constraints, but leaves little margin for later placement/routing changes.
Small positive hold slack is not an Fmax measurement.

`baseline_routed/` contains kernel-specific reports extracted from the actual
post-route-phys-opt DCP. Both integrated top-level RTL files match the previous
HLS exports. No original project runs have been reset.

| Kernel | Routed setup WNS | Root cause |
| --- | ---: | --- |
| image_preprocess | +0.076 ns | preview_stride AXI-Lite register through startup validation to datapath register CE; 13 levels, 4.885 ns data path (2.409 logic + 2.476 route) |
| yolo_postprocess | +0.106 ns | NMS 32x32 fabric area multiplier; 11 levels, 4.688 ns data path (2.084 logic + 2.604 route) |

## Source changes

- `/home/amd/Workspace/HLS_IP/image_preprocess/src/image_preprocess.cpp`: move
  guards into a non-inlined, II=1 validation function; give both capacity
  multipliers explicit two-cycle fabric bindings. Error priority, invalid-call
  no-memory-access behavior and all interface arguments remain unchanged.
  HLS reports a three-cycle validation latency. Existing color/resize processing
  loops retain their reported latencies.
- `/home/amd/Workspace/HLS_IP/yolo_postprocess/src/yolo_postprocess.cpp`: replace
  each 32x32 area multiply by four 16x16 partial products plus explicitly
  registered add stages. Preserve all 64 product bits and the strict 82-bit
  IoU comparison. Area II remains 1; latency increases 2 to 5 cycles.
  `suppress` worst-case latency increases 23 to 25 cycles. No DSPs added here.
- No clock reduction, multicycle/false-path exception, reduced coordinate
  precision, candidate truncation or approximate NMS.

## Independent mapped synthesis (not routed timing closure)

Same part xck26-sfvc784-2LV-c, 5 ns; HLS uncertainty 0.625 ns. OOC synthesis
uses estimated routing and unconstrained external AXI paths. Do not compare
these WNS numbers directly with the integrated routed baseline.

| Measurement | Image before | Image candidate | YOLO before | YOLO candidate |
| --- | ---: | ---: | ---: | ---: |
| OOC setup WNS, ns | 0.231 | 0.927 | 1.535 | 1.736 |
| LUT | 13,318 | 13,758 | 7,834 | 8,180 |
| FF | 13,002 | 14,334 | 6,436 | 7,147 |
| DSP | 49 | 55 | 8 | 8 |
| BRAM tiles | 11.5 | 11.5 | 12 | 12 |

This is a margin-for-resources tradeoff, not a claim of universal area or
throughput improvement. Image extraction changes HLS range propagation:
the coordinate generator becomes wider, contributing to the extra DSP usage.
The integrated routed result remains the acceptance measurement.

## Validation

Completed checks as of this intermediate note:

- Image full C simulation: 24 image cases plus invalid guards, zero failures.
- Image exact LUT arithmetic and new validation regression: boundary cases,
  30,000 random requests, error priority, null-pointer rejection and output ABI.
- YOLO full C simulation: eight cases, overflow/invalid guards, floating reference.
- YOLO exact arithmetic: 50,081 full-width area products plus 20,000 NMS pairs
  and exact threshold/no-overlap boundaries.
- OpenCV comparison: max INT8 error 1, 519,168 bytes; original numeric bound met.
- Python host/link tests: 7 passed; YOLO application/adapter tests: 4 passed.
- Candidate generated fixtures are byte-identical to previous fixtures.

The YOLO reference uses host long-double `exp` to avoid the slow HLS
bit-accurate double-exp model observed with a child debugger. This is testbench
only; the actual kernel has no floating-point exponential. Python LUT byte
equality and previous fixture equality both pass.

RTL co-simulation and the cloned integrated run may still be running. Consult
`candidate/{image_preprocess,yolo_postprocess}/status.json`, `platform_status.json`,
and actual PASS reports; do not infer completion from a launched command.
Image RTL smoke includes five image transactions and seven invalid requests.
YOLO RTL smoke includes five frame transactions.

## Artifact locations and safety

All paths below are relative to `/home/amd/Workspace/HLS_IP/timing_margin_20261013/`.

- `baseline/`: preserved sources, scripts, testbenches and mapped/HLS reports.
- `candidate/<kernel>/solution_200mhz/`: isolated candidate HLS project solution.
- `candidate/<kernel>/mapped/`: candidate Vivado OOC reports and checkpoint.
- `comparison.json`: measured OOC results, source hashes and fixture checks.
- `*.patch`: baseline-to-candidate source/test diffs.
- `platform_candidate/kv260_hardware_platform.xpr`: isolated copy of the actual
  project, preserving its Performance_ExplorePostRoutePhysOpt strategy.
- `candidate_routed/`: integrated comparison reports when completed.

`evaluate.py` runs direct tests, C simulation, HLS synthesis, OOC synthesis,
RTL co-simulation and export for one kernel. `evaluate_platform.py` waits for
both kernels to pass before replacing IPs only in the cloned platform and
launching its implementation. The live project, original IP snapshot, existing
bitstream and XSA are deliberately not overwritten during evaluation.