#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ "${1:-}" == --help ]]; then
  printf 'Usage: bash build_ofdm_firmware.sh NEW_ABSOLUTE_WORKSPACE [board_id=10] [subnet=1]\nNo hardware programming is performed.\n'
  exit 0
fi
workspace="${1:?Specify a new absolute build workspace}"
[[ "$workspace" == /* && ! -e "$workspace" ]] || { echo 'Workspace must be absolute and not exist' >&2; exit 2; }
XSCT="${XSCT:-/tools/Xilinx/Vitis/2022.1/bin/xsct}"
[[ -x "$XSCT" ]] || { echo "Missing tool: $XSCT" >&2; exit 2; }
SOURCE="$ROOT/src/ofdm/eeSDR_ofdm_loopback"
"$XSCT" "$SOURCE/firmware/build_dma_sw.tcl" "$SOURCE/build_hw/TOP.xsa" "$workspace" "${2:-10}" "${3:-1}"