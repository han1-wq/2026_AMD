#!/usr/bin/env python3
"""Legacy noninterleaved RS/real-PHY regressions; isolated XSim, two jobs."""
import concurrent.futures
import json
import os
import shutil
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
CASES = [
    ("clean54", 54, 64, 1, 0, 2, 0, 0),
    ("clean6", 6, 64, 1, 0, 1, 0, 0),
    ("bypass54", 54, 64, 0, 0, 1, 0, 0),
    ("short8", 54, 1, 1, 8, 1, 0, 0),
    ("max8", 54, 1024, 1, 8, 2, 0, 0),
    ("impaired", 54, 64, 1, 0, 1, 300, 2),
    ("max6", 6, 1024, 1, 8, 2, 0, 0),
    ("reject9", 54, 64, 1, 9, 1, 0, 0),
]


def run(case):
    name, rate, length, enabled, errors, packets, cfo, noise = case
    out = ROOT / "sim" / ("build_rs_phy_" + name)
    if (out / "result.json").exists():
        (out / "result.json").unlink()
    subprocess.run(["python3", str(ROOT / "sim/prepare_xsim.py"), "--ip-dir",
                    str(ROOT / "build_hw/ip"), "--output-dir", str(out)], check=True)
    env = dict(os.environ, PATH="/tools/Xilinx/Vivado/2022.1/bin:"+os.environ["PATH"],
               BUILD_DIR=str(out), TAG=name, RATES=str(rate), GAINS="0.75",
               PACKETS=str(packets), PAYLOAD_LENGTH=str(length), RS_ENABLE=str(enabled),
                RS_INTERLEAVE="0", RS_BURST_LENGTH="0", RS_BURST_START="0",
                RF_BURST_START="0", RF_BURST_SAMPLES="0",
               RS_INJECT_ERRORS=str(errors), CFO_HZ=str(cfo), INTERFERENCE=str(noise),
               WALL_TIMEOUT_S="3600", TIMEOUT_NS="10000000")
    runner = out / "run_rate_snapshot.sh"
    shutil.copy2(ROOT / "sim/run_rate_regression.sh", runner)
    with (out / "driver.log").open("w") as log:
        status = subprocess.run(["bash", str(runner)],
                                env=env, stdout=log, stderr=subprocess.STDOUT).returncode
    result = dict(name=name, rate=rate, payload=length, rs=enabled, errors=errors,
                  packets=packets, cfo=cfo, interference=noise, passed=status==0,
                  scope="real PHY + RS + FCS + DMA with backpressure",
                  log=str(out / "driver.log"))
    (out / "result.json").write_text(json.dumps(result, indent=2)+"\n")
    print(json.dumps(result), flush=True)
    return result


if __name__ == "__main__":
    (ROOT / "sim/build_rs").mkdir(parents=True, exist_ok=True)
    selected = [case for case in CASES if not sys.argv[1:] or case[0] in sys.argv[1:]]
    if not selected:
        raise SystemExit("Unknown case name")
    with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
        results = list(pool.map(run, selected))
    results = [json.loads((ROOT / "sim" / ("build_rs_phy_"+case[0]) / "result.json").read_text())
               for case in CASES
               if (ROOT / "sim" / ("build_rs_phy_"+case[0]) / "result.json").exists()]
    (ROOT / "sim/build_rs/phy_results.json").write_text(json.dumps(results, indent=2)+"\n")
    raise SystemExit(0 if all(r["passed"] for r in results) else 1)