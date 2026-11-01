# NMS arithmetic optimization — 2026-10-13

The integrated failing path crossed the 65-by-17 fabric multiplier for
`union_area * threshold_q16`. Increasing function latency alone did not break
that combinational multiplier. The implementation now computes the same
82-bit product using 17 sequential shift/add steps. The full coordinate/area
widths and the strict `(intersection << 16) > scaled_union` rule are retained.
The area multipliers also have explicit two-cycle fabric bindings and a
pipelined interface, separating area multiplication from union arithmetic.

These changes trade NMS comparison cycles for less combinational area and
shorter register-to-register paths. No clipping, top-K approximation, class
behavior, detection ABI or timing exceptions are introduced.

## Synthesis comparison

Target: Vitis HLS/Vivado 2022.1, xck26-sfvc784-2LV-c, 5 ns clock; HLS uncertainty
0.625 ns. OOC synthesis uses estimated routing and unconstrained external AXI
delays; it is not integrated placement/routing closure.

| Measurement | Before | After |
| --- | ---: | ---: |
| HLS `suppress` estimated delay | 4.301 ns | 4.301 ns |
| HLS `suppress` LUT | 8,318 | 4,177 |
| HLS `suppress` FF | 842 | 692 |
| HLS `suppress` DSP | 0 | 0 |
| HLS `suppress` maximum latency | 3 cycles | 23 cycles |
| Vivado whole-IP LUT | 9,260 | 7,834 |
| Vivado whole-IP FF | 6,068 | 6,436 |
| Vivado whole-IP DSP | 8 | 8 |
| Vivado whole-IP BRAM tiles | 12 | 12 |
| Vivado whole-IP OOC setup WNS | +0.798 ns | +1.535 ns |
| Vivado worst OOC data path | 4.199 ns | 3.462 ns |

HLS estimates do not reflect the Vivado mapped improvement. The new worst OOC
path is an area multiplier between its input and output registers. LUT savings
are 1,426 (15.4%); FF increases by 368 because of the register boundaries.
NMS throughput must be measured on hardware, especially for dense overlapping
candidate lists. The candidate cap remains 256 with whole-frame overflow fallback.

## Verification and artifacts

Full HLS C simulation passed eight cases with an independent floating reference,
overflow/invalid guards and NMS overlap. The direct arithmetic regression uses
20,000 randomized box pairs and an independent unsigned __int128 reference,
plus no-overlap, identical-box, threshold 0/65536 and exact-IoU boundary cases.
The Python application comparison passed all four tests. The final Verilog
C/RTL co-simulation passed all five smoke transactions after adding the
multiplier register boundaries. Vivado OOC synthesis and IP export both
completed successfully. Logs and artifact hashes are recorded in
`build/critical_path_optimization/`.

Reproduce the direct arithmetic check with:

```sh
bash /home/amd/Workspace/HLS_IP/yolo_postprocess/scripts/check_nms_arithmetic.sh
```

Mapped reports/checkpoint are in `build/rtl_synthesis/`; previous mapped reports
are preserved in `build/critical_path_baseline/`. The final export is
`build/yolo_postprocess/solution_200mhz/impl/export.zip` and its adjacent `impl/ip`
directory. Source/artifact hashes and validation logs are stored under
`build/critical_path_optimization/`.

The existing integrated BD and artifact manifest still refer to the earlier
integration. Update cached IP products and rerun the full integrated design to
measure both setup and hold before bitstream generation. These results do not
establish closure for the DPU 300/600 MHz clock domains.