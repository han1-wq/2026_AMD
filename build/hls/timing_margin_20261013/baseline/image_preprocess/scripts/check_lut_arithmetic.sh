#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
hls_include=${XILINX_HLS:-/tools/Xilinx/Vitis_HLS/2022.1}/include
binary=$(mktemp /tmp/image_lut_arithmetic.XXXXXX)
trap 'rm -f "$binary"' EXIT
g++ -std=c++14 -O2 -Wno-unknown-pragmas -I"$hls_include" \
    "$root/tb/test_lut_arithmetic.cpp" -o "$binary"
"$binary"