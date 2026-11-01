"""Isolated candidate builds; never modify the integrated Vivado platform."""
import json
import os
from pathlib import Path
import subprocess
import sys
import time

WORK = Path(__file__).resolve().parent
KERNEL = sys.argv[1]
if KERNEL not in ("image_preprocess", "yolo_postprocess"):
    raise SystemExit("invalid kernel")
ROOT = WORK.parent / KERNEL
OUT = WORK / "candidate" / KERNEL
OUT.mkdir(parents=True, exist_ok=True)
ENV = dict(os.environ, VISION_KERNEL=KERNEL)
HLS = "/tools/Xilinx/Vitis_HLS/2022.1/bin/vitis_hls"
VIVADO = "/tools/Xilinx/Vivado/2022.1/bin/vivado"
INCLUDE = "/tools/Xilinx/Vitis_HLS/2022.1/include"
state = {"kernel": KERNEL, "completed": [], "status": "running"}

def save():
    state["updated"] = time.strftime("%Y-%m-%d %H:%M:%S")
    (OUT / "status.json").write_text(json.dumps(state, indent=2))

def run(label, command, env=ENV):
    state["stage"] = label
    save()
    with (OUT / (label + ".log")).open("w") as log:
        try:
            proc = subprocess.run(command, cwd=OUT, env=env, stdout=log,
                stderr=subprocess.STDOUT, timeout=3600 if label != "csim" else 120)
        except subprocess.TimeoutExpired:
            state["status"] = "timeout"
            save()
            raise SystemExit(124)
    if proc.returncode:
        state["status"] = "failed"
        state["returncode"] = proc.returncode
        save()
        raise SystemExit(proc.returncode)
    state["completed"].append(label)
    save()

checks = ["test_lut_arithmetic", "test_validation"] if KERNEL == "image_preprocess" else ["test_nms_arithmetic"]
for check in checks:
    binary = OUT / check
    run(check + "_compile", ["g++", "-std=c++14", "-O2", "-Wno-unknown-pragmas",
        "-I" + INCLUDE, str(ROOT / "tb" / (check + ".cpp")), "-o", str(binary)])
    run(check, [str(binary)])
for stage in ["csim", "synth"]:
    run(stage, [HLS, "-f", str(WORK / "build_candidate.tcl")], dict(ENV, HLS_STAGE=stage))
run("mapped", [VIVADO, "-mode", "batch", "-notrace", "-source", str(WORK / "synth_candidate.tcl")])
for stage in ["cosim", "export"]:
    run(stage, [HLS, "-f", str(WORK / "build_candidate.tcl")], dict(ENV, HLS_STAGE=stage))
state["status"] = "passed"
save()