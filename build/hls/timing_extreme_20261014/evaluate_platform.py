"""Wait for verified HLS exports, then measure the isolated platform clone."""
import json
import hashlib
from pathlib import Path
import shutil
import subprocess
import sys
import time

WORK = Path(__file__).resolve().parent
if sys.argv[1:] not in ([], ["--installed"]):
    raise SystemExit("usage: evaluate_platform.py [--installed]")
installed = sys.argv[1:] == ["--installed"]
KERNELS = ("image_preprocess", "yolo_postprocess")
STATUS = WORK / "platform_status.json"

def status(stage, **kwargs):
    STATUS.write_text(json.dumps(dict(stage=stage, updated=time.strftime("%Y-%m-%d %H:%M:%S"), **kwargs), indent=2))

status("waiting_for_verified_exports")
deadline = time.monotonic() + 3600
while True:
    states = [json.loads((WORK / "candidate" / k / "status.json").read_text()) for k in KERNELS]
    if any(s["status"] not in ("running", "passed") for s in states):
        status("blocked_by_kernel_failure", kernels=states)
        raise SystemExit(1)
    if all(s["status"] == "passed" for s in states):
        break
    if time.monotonic() > deadline:
        status("timeout_waiting_for_exports")
        raise SystemExit(124)
    time.sleep(15)

clone = WORK / "platform_candidate"
with (WORK / "export_abi.log").open("w") as log:
    check = subprocess.run([sys.executable, str(WORK / "check_exports.py")],
        cwd=WORK, stdout=log, stderr=subprocess.STDOUT)
if check.returncode:
    status("export_abi_mismatch", returncode=check.returncode)
    raise SystemExit(check.returncode)
for kernel in KERNELS:
    src = WORK / "candidate" / kernel / "solution_200mhz/impl/ip"
    dst = clone / "ip_repo/vision" / kernel
    if not (src / "component.xml").is_file():
        status("missing_export", kernel=kernel)
        raise SystemExit(1)
    old = dst.with_name(kernel + "_baseline")
    if installed:
        def hashes(root):
            return {str(p.relative_to(root)): hashlib.sha256(p.read_bytes()).hexdigest()
                    for p in root.rglob("*") if p.is_file()}
        if hashes(src) != hashes(dst):
            status("installed_export_mismatch", kernel=kernel)
            raise SystemExit(1)
        continue
    if old.exists():
        raise SystemExit("Refusing to overwrite clone baseline")
    dst.rename(old)
    shutil.copytree(src, dst)
status("running_integrated_implementation")
with (WORK / "platform_build.console.log").open("w") as log:
    proc = subprocess.run(["/tools/Xilinx/Vivado/2022.1/bin/vivado", "-mode", "batch",
        "-notrace", "-source", str(WORK / "build_platform.tcl")],
        cwd=clone, stdout=log, stderr=subprocess.STDOUT)
status("passed" if proc.returncode == 0 else "failed", returncode=proc.returncode)
raise SystemExit(proc.returncode)