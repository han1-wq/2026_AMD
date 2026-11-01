#!/bin/bash
set -euo pipefail
cd /home/amd/ofdm/eeSDR_ofdm_loopback/sim/build
tag=${TAG:-amplitude}
shift_bits=${RX_SHIFT:-4}
packets=${PACKETS:-1}
for smooth in 0 1; do
    unit="${tag}_channel_${smooth}"
    iverilog -g2012 -s tb_channel_smoothing -Ptb_channel_smoothing.SMOOTH="$smooth" \
        -o "${unit}.vvp" \
        /home/amd/ofdm/eeSDR_ofdm_loopback/rtl/ofdm/rx/newdesign/rx_estimate_channel_info.v \
        /home/amd/ofdm/eeSDR_ofdm_loopback/sim/tb_channel_smoothing.v
    vvp "${unit}.vvp" > "${unit}.log" 2>&1
    grep 'CHANNEL_SMOOTHING_PASS' "${unit}.log"
done
for widths in '16 32' '25 51'; do
    read -r csi_width data_width <<< "$widths"
    unit="${tag}_soft_${csi_width}"
    iverilog -g2012 -s tb_data_soft_metrics \
        -Ptb_data_soft_metrics.CW="$csi_width" -Ptb_data_soft_metrics.DW="$data_width" \
        -o "${unit}.vvp" \
        /home/amd/ofdm/eeSDR_ofdm_loopback/rtl/ofdm/rx/newdesign/qam64_demodulation.v \
        /home/amd/ofdm/eeSDR_ofdm_loopback/sim/tb_data_soft_metrics.v
    vvp "${unit}.vvp" > "${unit}.log" 2>&1
    grep 'DATA_SOFT_METRICS_PASS' "${unit}.log"
done
iverilog -g2012 -s tb_pilot_rotate_precision -o "${tag}_pilot_unit.vvp" \
    /home/amd/ofdm/eeSDR_ofdm_loopback/rtl/ofdm/rx/newdesign/rx_phase_tracker_correct_use_pilot.v \
    /home/amd/ofdm/eeSDR_ofdm_loopback/sim/tb_pilot_rotate_precision.v
vvp "${tag}_pilot_unit.vvp" > "${tag}_pilot_unit.log" 2>&1
grep 'PILOT_ROTATE_PRECISION_PASS' "${tag}_pilot_unit.log"
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
xvlog --relax --work xil_defaultlib /home/amd/ofdm/eeSDR_ofdm_loopback/sim/tb_viterbi_prefix.v \
      >> "${tag}_compile.log" 2>&1
xelab --relax --mt 2 "${args[@]}" --snapshot "${tag}_viterbi_unit" \
      xil_defaultlib.tb_viterbi_prefix > "${tag}_viterbi_elab.log" 2>&1
xsim "${tag}_viterbi_unit" -runall > "${tag}_viterbi.log" 2>&1
grep 'VITERBI_PREFIX_PASS' "${tag}_viterbi.log"
xvlog --relax --work xil_defaultlib /home/amd/ofdm/eeSDR_ofdm_loopback/sim/tb_fine_cfo_scale.v \
      >> "${tag}_compile.log" 2>&1
xelab --relax --mt 2 "${args[@]}" --snapshot "${tag}_scale_unit" \
      xil_defaultlib.tb_fine_cfo_scale > "${tag}_unit_elab.log" 2>&1
xsim "${tag}_scale_unit" -runall > "${tag}_unit.log" 2>&1
grep 'FINE_CFO_SCALE_PASS' "${tag}_unit.log"
grep 'COARSE_CFO_SCALE_PASS' "${tag}_unit.log"
xelab --relax --mt 2 "${args[@]}" --snapshot "$tag" \
      -generic_top "RX_SHIFT=$shift_bits" -generic_top "PACKETS=$packets" \
      -generic_top "CHANNEL_SMOOTH=${CHANNEL_SMOOTH:-1}" \
      xil_defaultlib.tb_ofdm_rf_chain xil_defaultlib.glbl > "${tag}_elab.log" 2>&1
for gain in ${GAINS:-0.02 0.03 0.05 0.075 0.1 0.25 0.3 0.4 0.5 0.75 1.0 1.25 1.5 2.0 3.0 3.5}; do
    log="${tag}_gain_${gain}.log"
    trace=()
    if [[ ${TRACE:-0} == 1 ]]; then trace=(-testplusarg TRACE); fi
    xsim "$tag" -runall -testplusarg "GAIN=$gain" \
         -testplusarg "ANTENNA_EDGE_DB=${ANTENNA_EDGE_DB:-0}" \
         -testplusarg "ADC_MODE=${ADC_MODE:-0}" \
         -testplusarg "ADC_WRAP=${ADC_WRAP:-0}" \
         -testplusarg "ECHO_GAIN=${ECHO_GAIN:-0}" -testplusarg "ECHO_DELAY=${ECHO_DELAY:-1}" \
         -testplusarg "CFO_HZ=${CFO_HZ:-0}" \
         -testplusarg "INTERFERENCE=${INTERFERENCE:-0}" "${trace[@]}" > "$log" 2>&1
    if ! grep 'RF_CHAIN_PASS packets=' "$log"; then
        grep -E 'Fatal:|Error:|RF_CHAIN_' "$log" || true
        exit 1
    fi
done