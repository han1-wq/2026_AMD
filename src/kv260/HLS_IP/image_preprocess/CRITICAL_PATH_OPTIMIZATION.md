# CDF LUT arithmetic optimization — 2026-10-13

`build_lut` previously used a 40/32-bit divider and multiplied the quotient by
the denominator to recover its remainder. Validated input dimensions limit the
frame count to 2,073,600. The normalized CDF is at most the denominator, so its
scaled quotient is always between 0 and 255.

The new implementation uses a 22-bit CDF/count and a 30-bit remainder. Eight
sequential compare/subtract iterations obtain the quotient. The retained
remainder drives the same nearest-even rounding rule. Constant histograms still
generate the identity LUT. No interface, status, clock or equalization behavior
changes are intended.

## Synthesis comparison

Target: Vitis HLS/Vivado 2022.1, xck26-sfvc784-2LV-c, 5 ns clock; HLS uncertainty
0.625 ns. OOC synthesis has estimated routing and unconstrained external AXI
delays. Its WNS is not integrated placement/routing closure.

| Measurement | Before | After |
| --- | ---: | ---: |
| HLS `build_lut` estimated delay | 4.002 ns | 3.484 ns |
| HLS `build_lut` LUT | 1,110 | 708 |
| HLS `build_lut` FF | 889 | 261 |
| HLS `build_lut` DSP | 3 | 0 |
| HLS `build_lut` maximum latency | 12,549 cycles | 3,333 cycles |
| Vivado whole-IP LUT | 13,543 | 13,318 |
| Vivado whole-IP FF | 13,299 | 13,002 |
| Vivado whole-IP DSP | 52 | 49 |
| Vivado whole-IP BRAM tiles | 11.5 | 11.5 |
| Vivado whole-IP OOC setup WNS | +0.452 ns | +0.231 ns |

The local LUT path and resource use improve, but whole-IP WNS decreases. The
new worst OOC path is input-height validation to the return-status register,
outside `build_lut`. Do not interpret the local optimization as whole-IP timing
closure or resolution of the DPU 300/600 MHz hold failures.

## Verification and artifacts

- Full HLS C simulation: 24 cases, PASS, zero failures.
- Direct LUT arithmetic: 2,000 random/sparse histograms plus maximum constant
  histogram and nearest-even ties, exact agreement with independent uint64
  division/remainder reference.
- Verilog C/RTL co-simulation: five smoke transactions, PASS, including current
  equalization, previous-frame history and configuration reset.
- OpenCV/NumPy comparison: PASS existing numeric bound; maximum INT8 error 1.
- Vivado OOC synthesis completed successfully.

Reproduce the direct check with:

```sh
bash /home/amd/Workspace/HLS_IP/image_preprocess/scripts/check_lut_arithmetic.sh
```

Reports/checkpoint: `build/rtl_synthesis/`. The previous mapped reports were
preserved in `build/critical_path_baseline/`. The refreshed Vivado IP is
`build/image_preprocess/solution_200mhz/impl/export.zip` and the adjacent
`impl/ip` directory. Source/artifact hashes and validation logs are recorded
under `build/critical_path_optimization/` after final verification.

The existing integrated BD and its artifact manifest still describe the old
IP integration. Refreshing this export alone does not update cached BD IP
products, the platform XSA, a bitstream or an XCLBIN.