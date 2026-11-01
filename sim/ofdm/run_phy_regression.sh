#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
rtl=../rtl/board/ad936x_phy_tx.v
models=tb_phy_tx.v
iverilog -g2012 -s tb_phy_tx -o "$tmp/phy_1t1r" "$rtl" "$models"
vvp "$tmp/phy_1t1r"
iverilog -g2012 -s tb_phy_tx_phase -o "$tmp/phy_phase" "$rtl" "$models" tb_phy_tx_phase.v
for phase in 0 1; do
    vvp "$tmp/phy_phase" +PHASE="$phase"
done
iverilog -g2012 -s tb_phy_tx_2t2r -o "$tmp/phy_2t2r" "$rtl" tb_phy_tx_2t2r.v
vvp "$tmp/phy_2t2r"
iverilog -g2012 -s tb_phy_tx_idle -o "$tmp/phy_idle" "$rtl" "$models" \
    ../rtl/board/ofdm_iq_scale.v tb_phy_tx_idle.v
for phase in 0 1; do
    vvp "$tmp/phy_idle" +PHASE="$phase"
done