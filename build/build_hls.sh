#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ "${1:-}" == --help ]]; then
  printf 'Usage: bash build_hls.sh {image_preprocess|yolo_postprocess} {csim|synth|cosim|export|all}\nSet VITIS_HLS to the 2022.1 executable if installed elsewhere.\n'
  exit 0
fi
kernel="${1:?Specify image_preprocess or yolo_postprocess}"
stage="${2:-csim}"
case "$kernel" in image_preprocess|yolo_postprocess) ;; *) echo 'Invalid kernel' >&2; exit 2;; esac
case "$stage" in csim|synth|cosim|export|all) ;; *) echo 'Invalid HLS stage' >&2; exit 2;; esac
HLS="${VITIS_HLS:-/tools/Xilinx/Vitis_HLS/2022.1/bin/vitis_hls}"
[[ -x "$HLS" ]] || { echo "Missing tool: $HLS" >&2; exit 2; }
cd "$ROOT/src/kv260/HLS_IP/$kernel"
HLS_STAGE="$stage" "$HLS" -f "$PWD/scripts/build.tcl"