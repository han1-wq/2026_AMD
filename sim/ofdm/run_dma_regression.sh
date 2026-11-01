#!/bin/bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
out="$root/sim/build/dma"
mkdir -p "$out"
iverilog -g2012 -Wall -s tb_dma_packets -o "$out/packets.vvp" \
    "$root/rtl/board/ofdm_dma_tx.v" "$root/rtl/board/ofdm_dma_rx.v" \
    "$root/sim/tb_dma_packets.v"
vvp "$out/packets.vvp" | tee "$out/packets.log"
grep -q DMA_PACKETS_PASS "$out/packets.log"
iverilog -g2012 -Wall -s tb_dma_control -o "$out/control.vvp" \
    "$root/rtl/board/ofdm_dma_control.v" "$root/sim/tb_dma_control.v"
vvp "$out/control.vvp" | tee "$out/control.log"
grep -q DMA_CONTROL_PASS "$out/control.log"
cc -std=c11 -Wall -Wextra -Werror -I"$root/firmware/dma_app" \
    "$root/firmware/dma_app/link.c" "$root/sim/test_dma_link.c" -o "$out/link_test"
"$out/link_test" | tee "$out/link.log"
cc -std=c11 -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
    -I"$root/firmware/dma_app" -I"$root/sim" \
    "$root/firmware/dma_app/link.c" "$root/sim/test_dma_services.c" \
    -Wl,--gc-sections -o "$out/services_test"
"$out/services_test" | tee "$out/services.log"
cc -std=c11 -Wall -Wextra -Werror -DOFDM_PHY_TEST -I"$root/sim" \
    "$root/firmware/dma_app/board_phy.c" "$root/sim/test_board_phy.c" -o "$out/phy_test"
"$out/phy_test" | tee "$out/phy.log"
python3 -B -m unittest discover -s "$root/host" -p 'test_dma_*.py' -v
echo DMA_REGRESSION_PASS
