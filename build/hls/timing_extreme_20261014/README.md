# Timing-first exact arithmetic candidate

Target: xck26-sfvc784-2LV-c, Vivado/Vitis HLS 2022.1, 5 ns clock and
0.625 ns HLS uncertainty. Extra processing cycles are permitted. No timing
exceptions, interface changes or approximate arithmetic are introduced.

This directory contains an isolated source variant in `sources/`, HLS outputs
in `candidate/`, and a disposable integrated project in `platform_candidate/`.
The installed IP and live platform have not been replaced by this candidate.

## Verified integrated result (2026-10-14)

The isolated platform completed post-route physical optimization at 00:43:15.
`comparison.json` reports `acceptance_passed: true` under the existing platform
constraints. The selected candidate is the completed project at
`/home/amd/Workspace/HLS_IP/timing_extreme_20261014/platform_candidate/kv260_hardware_platform.xpr`.
Its exported IP snapshots match all 294 candidate export files by SHA-256.
Use this candidate for the next platform revision; the live project, bitstream
and XSA remain the previous version. No new bitstream, XSA or board test is
claimed by this evaluation.

| Routed measurement | Previous candidate (20261013) | This candidate |
| --- | ---: | ---: |
| Global setup WNS, ns | 0.038 | 0.157 |
| Image setup WNS, ns | 0.221 | 0.403 |
| YOLO setup WNS, ns | 0.038 | 0.157 |
| Global hold WHS, ns | 0.009 | 0.010 |
| Platform LUT | 27,306 | 23,104 |
| Platform FF | 32,488 | 31,106 |
| Platform DSP | 63 | 61 |
| Platform BRAM tiles | 23.5 | 23.5 |

The original live-platform baseline was global WNS 0.076 ns, image 0.076 ns,
and YOLO 0.106 ns. This candidate improves those measurements too. Results
are for the integrated base platform, without a subsequent DPU link, and do
not establish an absolute optimum or guaranteed margin across placements.

| Kernel routed resources | LUT | FF | DSP | BRAM tiles |
| --- | ---: | ---: | ---: | ---: |
| image_preprocess | 12,511 | 12,892 | 37 | 11.5 |
| yolo_postprocess | 4,468 | 7,205 | 24 | 12 |

All 47,501 routable nets are fully routed, with zero routing errors. Setup,
hold and pulse-width failing endpoints are zero, and there are no unconstrained
internal endpoints. The image/YOLO clock is 5.000 ns (200 MHz). No placer
congestion windows above level 5 were reported. All seven bus-skew checks pass;
minimum slack is 13.658 ns. These measurements are in `candidate_routed/`.

DRC has 29 ordinary warnings (6 DPIP-2, 7 DPOP-3, 15 DPOP-4 and one RTSTAT-10),
with no errors or critical warnings. The separate methodology check has two
critical warnings, TIMING-4 and TIMING-27, for an internal primary-clock
redefinition at clk_wiz_1/inst/clk_in1, plus two clock advisories. The same two
critical warnings are present in both the old candidate and live platform
methodology reports. Timing acceptance uses the existing constraints; it does
not certify that the platform clock methodology is clean.

The worst image path is width-dependent startup arithmetic into a FIFO,
4.454 ns data delay (3.196 ns route). The worst YOLO path is intersection
comparison into a subtraction register enable, 4.429 ns (3.283 ns route).
These are the next measured targets if further optimization is pursued.

## Verified functional and schedule evidence

- Both kernels: arithmetic tests, full C simulation, HLS/mapped synthesis,
  Verilog RTL smoke co-simulation and IP export passed. Register maps, bus
  interfaces, ports and model parameter signatures match the original exports.
- Image C simulation: 24 cases plus guards, zero failures. Exact coordinate
  division, Q11 ties, LUT arithmetic and validation checks pass.
- YOLO C simulation: eight cases plus guards and independent floating reference;
  exact full-width area/NMS/threshold arithmetic tests pass.
- All five expected fixtures are nonempty and byte-identical to the previous
  candidate. The summary recomputes their hashes, so an empty fixture manifest
  cannot count as a passing check.
- OpenCV 5.0.0 / NumPy 2.2.6: 519,168 INT8 bytes checked, maximum error 1 LSB,
  padding correct, quantization LUTs match at nine fix-point settings. Rechecked
  using `/home/amd/cocotb-demo-venv/bin/python` and the image `check_opencv.py`.
- Image color and interpolation loops retain II=1, with pipeline depths 18
  and 12 respectively. Coordinate division takes 23 cycles and uses zero DSP;
  coordinate generation also uses zero DSP. Extra setup latency is intentional.
- YOLO area and threshold products each take 6 cycles with II=1; suppress takes
  18 cycles with II=1. These function intervals are not whole-frame throughput.
- RTL smoke latency ranges: image 260..1,126,267 cycles; YOLO
  1,390,494..1,397,142 cycles. The ranges include different transactions and are
  not worst-case latency guarantees for all valid inputs.

The completed HLS runs predate the build-time source hash recording change.
Their status files therefore do not contain a before/after source hash manifest.
`source_snapshot_audit.json` explicitly records that limitation and verifies the
current C++ source, HLS pragmas and local header against the HLS preprocessed
snapshot. Future `evaluate.py` runs compare complete source-file dictionaries
before and after the build, detecting additions, deletions and modifications.

Recreate the measured summary with
`python3 /home/amd/Workspace/HLS_IP/timing_extreme_20261014/summarize.py`.
`inspect_routed.tcl` reopens the completed DCP for bus-skew and methodology
reports without rerunning implementation. Missing new checks on the older
candidate are not evidence that its routing or DRC failed.

## Arithmetic changes

- Image coordinates: replace generic division/modulo and quotient multiplication
  with exact 21-bit restoring division using an 11-bit trial remainder and a
  12-bit subtract/borrow. Increment the half-pixel numerator by `2*src` between
  coordinates. Preserve Q11 nearest-even rounding. The narrowed values are used
  only after the original full-width validation accepts the request.
- Image resize: use bounded 11-bit row counters/dimensions and 9-bit destination
  dimensions, reducing the synthesized row-control arithmetic. Pixel-loop II
  remains a required measurement, not an assumption.
- YOLO area: four 16x16 DSP products with three-cycle multiplier bindings and
  explicit carry stages retain all 64 bits.
- YOLO threshold: four 16x17 DSP products plus the 65th input bit replace the
  serial 82-bit shift/add accumulator. Registered carry stages assemble all
  82 result bits; suppression still uses strict `intersection<<16 > product`.
- Coordinate differences use unsigned subtraction to support valid ordered
  signed endpoints whose distance exceeds INT32_MAX without signed C++ overflow.

## Tests and acceptance

`python3 evaluate.py image_preprocess` and `python3 evaluate.py yolo_postprocess`
run arithmetic tests, full C simulation, HLS synthesis, mapped Vivado synthesis,
RTL smoke co-simulation and IP export. The image coordinate test compares every
destination size 1..416 for six source dimensions, 1000 random geometries, and
divider boundaries against independent integer division. YOLO adds 50,000
65x17 product checks against unsigned __int128 and extreme signed endpoints.

`python3 evaluate_platform.py` checks exported register maps/interfaces against
the original exports, installs into the disposable clone, validates its BD,
and runs the original Performance_ExplorePostRoutePhysOpt strategy. The
Vivado 2022.1 post-route step is `phys_opt_design (Post-Route)`.

Consult actual status files and reports. A launched run, HLS estimated Fmax,
or mapped OOC slack is not proof of integrated timing closure. Co-simulation
is smoke coverage, not exhaustive RTL testing. Baseline measurements are under
`/home/amd/Workspace/HLS_IP/timing_margin_20261013/`.

## Vitis Libraries decision

The local Vitis-AI 2.5 tree contains Vision headers and an NMS example under
`/home/amd/Vitis-AI/Vitis-AI-2.5/examples/Whole-App-Acceleration/plugins/`.
The NMS example truncates area products and uses a different threshold boundary;
Vision resize uses xf::cv::Mat and requires a separate coordinate/rounding and
stream-interface equivalence study. Neither is included in this exact-ABI
candidate. No unmeasured library performance gain is claimed.

## Tool compatibility

Vitis HLS 2022.1 crashed in LowerDirectiveScope on bound products declared in
a shared C++ declaration. Declaring each bound product separately resolved the
crash. The diagnostic is retained in `clang_diagnostic.log`.