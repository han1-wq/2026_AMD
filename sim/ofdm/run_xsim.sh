#!/bin/bash
set -euo pipefail
cd /home/amd/ofdm/eeSDR_ofdm_loopback/sim/build
xvlog --relax -prj vlog.prj > compile.log 2>&1
xvhdl --relax -prj vhdl.prj >> compile.log 2>&1
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
xelab --relax --mt 2 "${args[@]}" --snapshot rf_chain_behav \
      xil_defaultlib.tb_ofdm_rf_chain xil_defaultlib.glbl > elaborate.log 2>&1
for scenario in '300 2' '0 0'; do
    read -r cfo noise <<< "$scenario"
    xsim rf_chain_behav -runall -testplusarg "CFO_HZ=$cfo" \
         -testplusarg "INTERFERENCE=$noise" > "run_${cfo}_${noise}.log" 2>&1
    grep 'RF_CHAIN_PASS' "run_${cfo}_${noise}.log"
done