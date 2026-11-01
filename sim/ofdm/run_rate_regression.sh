#!/bin/bash
# Use a separately prepared BUILD_DIR for concurrent simulation regressions.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "${BUILD_DIR:-$root/sim/build}"
tag=${TAG:-rates}
[[ $tag =~ ^[a-zA-Z0-9_]+$ ]] || { echo 'Invalid TAG'; exit 1; }
xvlog --relax -prj vlog.prj > "${tag}_compile.log" 2>&1
xvhdl --relax -prj vhdl.prj >> "${tag}_compile.log" 2>&1
libs=(fifo_generator_v13_2_7 blk_mem_gen_v8_4_5 xbip_utils_v3_0_10
      xbip_pipe_v3_0_6 xbip_bram18k_v3_0_6 mult_gen_v12_0_18
      axi_utils_v2_0_6 xbip_dsp48_wrapper_v3_0_4 xbip_dsp48_addsub_v3_0_6
      floating_point_v7_0_20 xbip_dsp48_mult_v3_0_6 xbip_dsp48_multadd_v3_0_6
      div_gen_v5_1_19 c_reg_fd_v12_0_6 xbip_addsub_v3_0_6
      c_addsub_v12_0_14 c_gate_bit_v12_0_6 c_compare_v12_0_6
      xbip_counter_v3_0_6 c_counter_binary_v12_0_15 c_mux_bit_v12_0_6
      c_mux_bus_v12_0_6 c_shift_ram_v12_0_14 viterbi_v9_1_13
      cmpy_v6_0_21 dds_compiler_v6_0_22 cordic_v6_0_18 xfft_v9_1_8
      unisims_ver unimacro_ver secureip xpm)
args=()
for lib in "${libs[@]}"; do args+=(-L "$lib"); done
cases=0
for rate in ${RATES:-6 9 12 18 24 36 48 54}; do
    snapshot="${tag}_r${rate}"
    xelab --relax --mt 2 "${args[@]}" --snapshot "$snapshot" \
        -generic_top "RATE_MBPS=$rate" -generic_top "PACKETS=${PACKETS:-2}" \
        -generic_top "CHANNEL_SMOOTH=${CHANNEL_SMOOTH:-1}" \
        -generic_top "RS_ENABLE=${RS_ENABLE:-1}" \
        -generic_top "RS_INTERLEAVE=${RS_INTERLEAVE:-1}" \
        -generic_top "PAYLOAD_LENGTH=${PAYLOAD_LENGTH:-64}" \
        -generic_top "RS_INJECT_ERRORS=${RS_INJECT_ERRORS:-0}" \
        -generic_top "RS_BURST_LENGTH=${RS_BURST_LENGTH:-0}" \
        -generic_top "RS_BURST_START=${RS_BURST_START:-0}" \
        xil_defaultlib.tb_ofdm_rf_chain xil_defaultlib.glbl > "${snapshot}_elab.log" 2>&1
    for gain in ${GAINS:-1 0.02}; do
        log="${snapshot}_gain_${gain}.log"
        timeout "${WALL_TIMEOUT_S:-600}" xsim "$snapshot" -runall \
            -testplusarg "GAIN=$gain" -testplusarg "CFO_HZ=${CFO_HZ:-0}" \
            -testplusarg "INTERFERENCE=${INTERFERENCE:-0}" \
            -testplusarg "RF_BURST_START=${RF_BURST_START:-0}" \
            -testplusarg "RF_BURST_SAMPLES=${RF_BURST_SAMPLES:-0}" \
            -testplusarg "TIMEOUT_NS=${TIMEOUT_NS:-10000000}" \
            -testplusarg "ECHO_GAIN=${ECHO_GAIN:-0}" \
            -testplusarg "ECHO_DELAY=${ECHO_DELAY:-1}" \
            -testplusarg "ADC_MODE=${ADC_MODE:-0}" > "$log" 2>&1
        if grep -Eq 'Fatal:|Error:' "$log" || ! grep 'RF_CHAIN_PASS packets=' "$log"; then
            echo "RATE_REGRESSION_FAIL rate=$rate gain=$gain log=$PWD/$log"
            exit 1
        fi
        cases=$((cases+1))
    done
done
echo "RATE_REGRESSION_PASS cases=$cases"