#!/bin/bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
out="$root/sim/build/mailbox"
mkdir -p "$out"
rtl="$root/rtl/board/ofdm_packet_mailbox.v"
tb="$root/sim/tb_packet_mailbox_edges.v"
check_log() {
    local log=$1 marker=$2
    if grep -Eiq 'FATAL|ERROR:|Error:' "$log" || ! grep -q "$marker" "$log"; then
        cat "$log"
        return 1
    fi
    grep "$marker" "$log"
}
iverilog -g2012 -Wall -s tb_packet_mailbox -o "$out/legacy.vvp" \
    "$rtl" "$root/sim/tb_packet_mailbox.v" > "$out/legacy_compile.log" 2>&1
vvp "$out/legacy.vvp" > "$out/legacy.log" 2>&1
check_log "$out/legacy.log" MAILBOX_PASS
runs=0
for config in same async_normal axi_fast data_fast; do
    case "$config" in
        same) params=(-Ptb_packet_mailbox_edges.SAME_CLOCK=1 -Ptb_packet_mailbox_edges.AXI_HALF_NS=6.25);;
        async_normal) params=();;
        axi_fast) params=(-Ptb_packet_mailbox_edges.AXI_HALF_NS=2.5 -Ptb_packet_mailbox_edges.DATA_HALF_NS=11.3 -Ptb_packet_mailbox_edges.DATA_PHASE_NS=0.4);;
        data_fast) params=(-Ptb_packet_mailbox_edges.AXI_HALF_NS=11.0 -Ptb_packet_mailbox_edges.DATA_HALF_NS=3.1 -Ptb_packet_mailbox_edges.DATA_PHASE_NS=2.3);;
    esac
    iverilog -g2012 -Wall -DMAILBOX_CONFIGURABLE_TIMEOUT -s tb_packet_mailbox_edges \
        "${params[@]}" -o "$out/$config.vvp" "$rtl" "$tb" > "$out/${config}_compile.log" 2>&1
    for seed in ${SEEDS:-1 17 2026 314159}; do
        log="$out/${config}_${seed}.log"
        vvp "$out/$config.vvp" "+SEED=$seed" "+RANDOM_PACKETS=${RANDOM_PACKETS:-40}" > "$log" 2>&1
        printf '%s seed=%s ' "$config" "$seed"
        check_log "$log" MAILBOX_EDGES_PASS
        runs=$((runs+1))
    done
done
# Exercise the unchanged hardware default; not merely a shortened/forced timer.
if [[ ${FULL_TIMEOUT:-1} == 1 ]]; then
    iverilog -g2012 -Wall -s tb_packet_mailbox_edges \
        -Ptb_packet_mailbox_edges.TIMEOUT_CYCLES=8000000 \
        -Ptb_packet_mailbox_edges.SAME_CLOCK=1 -Ptb_packet_mailbox_edges.AXI_HALF_NS=6.25 \
        -o "$out/default_timeout.vvp" "$rtl" "$tb" > "$out/default_timeout_compile.log" 2>&1
    vvp "$out/default_timeout.vvp" +CASE=timeout > "$out/default_timeout.log" 2>&1
    check_log "$out/default_timeout.log" MAILBOX_EDGES_PASS
fi
printf 'MAILBOX_REGRESSION_PASS matrix_runs=%s full_timeout=%s\n' "$runs" "${FULL_TIMEOUT:-1}"