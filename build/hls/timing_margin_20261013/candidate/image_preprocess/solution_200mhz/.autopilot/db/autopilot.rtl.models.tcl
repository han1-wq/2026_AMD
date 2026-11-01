set SynModuleInfo {
  {SRCNAME {(anonymous namespace)validate_settings} MODELNAME p_anonymous_namespace_validate_settings RTLNAME image_preprocess_p_anonymous_namespace_validate_settings
    SUBMODULES {
      {MODELNAME image_preprocess_mul_13ns_11ns_24_3_1 RTLNAME image_preprocess_mul_13ns_11ns_24_3_1 BINDTYPE op TYPE mul IMPL fabric LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME image_preprocess_Pipeline_VITIS_LOOP_530_2 MODELNAME image_preprocess_Pipeline_VITIS_LOOP_530_2 RTLNAME image_preprocess_image_preprocess_Pipeline_VITIS_LOOP_530_2
    SUBMODULES {
      {MODELNAME image_preprocess_flow_control_loop_pipe_sequential_init RTLNAME image_preprocess_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME image_preprocess_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME image_preprocess_Pipeline_VITIS_LOOP_540_4 MODELNAME image_preprocess_Pipeline_VITIS_LOOP_540_4 RTLNAME image_preprocess_image_preprocess_Pipeline_VITIS_LOOP_540_4}
  {SRCNAME {(anonymous namespace)make_coordinates} MODELNAME p_anonymous_namespace_make_coordinates RTLNAME image_preprocess_p_anonymous_namespace_make_coordinates
    SUBMODULES {
      {MODELNAME image_preprocess_mul_32s_32s_32_1_1 RTLNAME image_preprocess_mul_32s_32s_32_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_udiv_32ns_32ns_32_36_seq_1 RTLNAME image_preprocess_udiv_32ns_32ns_32_36_seq_1 BINDTYPE op TYPE udiv IMPL auto_seq LATENCY 35 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_urem_32ns_32ns_32_36_seq_1 RTLNAME image_preprocess_urem_32ns_32ns_32_36_seq_1 BINDTYPE op TYPE urem IMPL auto_seq LATENCY 35 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME {(anonymous namespace)read_words_Pipeline_VITIS_LOOP_145_2} MODELNAME p_anonymous_namespace_read_words_Pipeline_VITIS_LOOP_145_2 RTLNAME image_preprocess_p_anonymous_namespace_read_words_Pipeline_VITIS_LOOP_145_2}
  {SRCNAME {(anonymous namespace)read_words} MODELNAME p_anonymous_namespace_read_words RTLNAME image_preprocess_p_anonymous_namespace_read_words
    SUBMODULES {
      {MODELNAME image_preprocess_mul_mul_9ns_11ns_20_4_1 RTLNAME image_preprocess_mul_mul_9ns_11ns_20_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME {(anonymous namespace)unpack_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2} MODELNAME p_anonymous_namespace_unpack_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2 RTLNAME image_preprocess_p_anonymous_namespace_unpack_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2}
  {SRCNAME {(anonymous namespace)unpack} MODELNAME p_anonymous_namespace_unpack RTLNAME image_preprocess_p_anonymous_namespace_unpack
    SUBMODULES {
      {MODELNAME image_preprocess_mul_32ns_32ns_64_1_1 RTLNAME image_preprocess_mul_32ns_32ns_64_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME {(anonymous namespace)statistics_pass_Block_entry36_proc} MODELNAME p_anonymous_namespace_statistics_pass_Block_entry36_proc RTLNAME image_preprocess_p_anonymous_namespace_statistics_pass_Block_entry36_proc
    SUBMODULES {
      {MODELNAME image_preprocess_mul_11ns_11ns_22_1_1 RTLNAME image_preprocess_mul_11ns_11ns_22_1_1 BINDTYPE op TYPE mul IMPL fabric LATENCY 0 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME {(anonymous namespace)histogram_pixels} MODELNAME p_anonymous_namespace_histogram_pixels RTLNAME image_preprocess_p_anonymous_namespace_histogram_pixels
    SUBMODULES {
      {MODELNAME image_preprocess_mac_muladd_8ns_8ns_15s_17_4_1 RTLNAME image_preprocess_mac_muladd_8ns_8ns_15s_17_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_mac_muladd_8ns_7ns_17s_18_4_1 RTLNAME image_preprocess_mac_muladd_8ns_7ns_17s_18_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_mac_muladd_14ns_10s_22s_25_4_1 RTLNAME image_preprocess_mac_muladd_14ns_10s_22s_25_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_mac_muladd_8ns_8ns_15s_16_4_1 RTLNAME image_preprocess_mac_muladd_8ns_8ns_15s_16_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_mac_muladd_8ns_7ns_16s_16_4_1 RTLNAME image_preprocess_mac_muladd_8ns_7ns_16s_16_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_flow_control_loop_delay_pipe RTLNAME image_preprocess_flow_control_loop_delay_pipe BINDTYPE interface TYPE internal_upc_flow_control INSTNAME image_preprocess_flow_control_loop_delay_pipe_U}
    }
  }
  {SRCNAME {(anonymous namespace)statistics_pass} MODELNAME p_anonymous_namespace_statistics_pass RTLNAME image_preprocess_p_anonymous_namespace_statistics_pass
    SUBMODULES {
      {MODELNAME image_preprocess_fifo_w128_d64_A RTLNAME image_preprocess_fifo_w128_d64_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w32_d2_S RTLNAME image_preprocess_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w24_d64_A RTLNAME image_preprocess_fifo_w24_d64_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w22_d3_S RTLNAME image_preprocess_fifo_w22_d3_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_start_for_p_anonymous_namespace_unpack_U0 RTLNAME image_preprocess_start_for_p_anonymous_namespace_unpack_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
    }
  }
  {SRCNAME {(anonymous namespace)build_lut_Pipeline_VITIS_LOOP_206_1} MODELNAME p_anonymous_namespace_build_lut_Pipeline_VITIS_LOOP_206_1 RTLNAME image_preprocess_p_anonymous_namespace_build_lut_Pipeline_VITIS_LOOP_206_1}
  {SRCNAME {(anonymous namespace)build_lut} MODELNAME p_anonymous_namespace_build_lut RTLNAME image_preprocess_p_anonymous_namespace_build_lut}
  {SRCNAME entry_proc MODELNAME entry_proc RTLNAME image_preprocess_entry_proc}
  {SRCNAME {(anonymous namespace)read_words.1_Pipeline_VITIS_LOOP_145_2} MODELNAME p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2 RTLNAME image_preprocess_p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2}
  {SRCNAME {(anonymous namespace)read_words.1} MODELNAME p_anonymous_namespace_read_words_1 RTLNAME image_preprocess_p_anonymous_namespace_read_words_1}
  {SRCNAME {(anonymous namespace)unpack.2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2} MODELNAME p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2 RTLNAME image_preprocess_p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2}
  {SRCNAME {(anonymous namespace)unpack.2} MODELNAME p_anonymous_namespace_unpack_2 RTLNAME image_preprocess_p_anonymous_namespace_unpack_2}
  {SRCNAME {(anonymous namespace)output_pass_Block_entry47_proc} MODELNAME p_anonymous_namespace_output_pass_Block_entry47_proc RTLNAME image_preprocess_p_anonymous_namespace_output_pass_Block_entry47_proc}
  {SRCNAME {(anonymous namespace)color_stage_Pipeline_VITIS_LOOP_267_1} MODELNAME p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1 RTLNAME image_preprocess_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1
    SUBMODULES {
      {MODELNAME image_preprocess_mac_muladd_9s_9ns_14s_17_4_1 RTLNAME image_preprocess_mac_muladd_9s_9ns_14s_17_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_mac_muladd_9s_8ns_14s_16_4_1 RTLNAME image_preprocess_mac_muladd_9s_8ns_14s_16_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_mac_muladd_9s_9ns_15s_17_4_1 RTLNAME image_preprocess_mac_muladd_9s_9ns_15s_17_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME {(anonymous namespace)color_stage} MODELNAME p_anonymous_namespace_color_stage RTLNAME image_preprocess_p_anonymous_namespace_color_stage}
  {SRCNAME {(anonymous namespace)collect_or_drain_Pipeline_VITIS_LOOP_290_2} MODELNAME p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_290_2 RTLNAME image_preprocess_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_290_2}
  {SRCNAME {(anonymous namespace)collect_or_drain_Pipeline_VITIS_LOOP_283_1} MODELNAME p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_283_1 RTLNAME image_preprocess_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_283_1}
  {SRCNAME {(anonymous namespace)collect_or_drain} MODELNAME p_anonymous_namespace_collect_or_drain RTLNAME image_preprocess_p_anonymous_namespace_collect_or_drain}
  {SRCNAME {(anonymous namespace)resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3} MODELNAME p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3 RTLNAME image_preprocess_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3}
  {SRCNAME {(anonymous namespace)resize_and_split_Pipeline_VITIS_LOOP_354_4} MODELNAME p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4 RTLNAME image_preprocess_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4
    SUBMODULES {
      {MODELNAME image_preprocess_mux_21_24_1_1 RTLNAME image_preprocess_mux_21_24_1_1 BINDTYPE op TYPE mux IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_mac_muladd_12ns_9s_19ns_20_4_1 RTLNAME image_preprocess_mac_muladd_12ns_9s_19ns_20_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_mac_muladd_12ns_9s_20ns_20_4_1 RTLNAME image_preprocess_mac_muladd_12ns_9s_20ns_20_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1 RTLNAME image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME {(anonymous namespace)resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7} MODELNAME p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7 RTLNAME image_preprocess_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7}
  {SRCNAME {(anonymous namespace)resize_and_split} MODELNAME p_anonymous_namespace_resize_and_split RTLNAME image_preprocess_p_anonymous_namespace_resize_and_split
    SUBMODULES {
      {MODELNAME image_preprocess_p_anonymous_namespace_resize_and_split_rows_V_RAM_2P_BRAM_1R1W RTLNAME image_preprocess_p_anonymous_namespace_resize_and_split_rows_V_RAM_2P_BRAM_1R1W BINDTYPE storage TYPE ram_2p IMPL bram LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME {(anonymous namespace)output_pass_Block_entry412_proc} MODELNAME p_anonymous_namespace_output_pass_Block_entry412_proc RTLNAME image_preprocess_p_anonymous_namespace_output_pass_Block_entry412_proc}
  {SRCNAME {(anonymous namespace)pack_Pipeline_VITIS_LOOP_396_2} MODELNAME p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_396_2 RTLNAME image_preprocess_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_396_2}
  {SRCNAME {(anonymous namespace)pack} MODELNAME p_anonymous_namespace_pack RTLNAME image_preprocess_p_anonymous_namespace_pack}
  {SRCNAME {(anonymous namespace)output_pass_Block_entry414_proc} MODELNAME p_anonymous_namespace_output_pass_Block_entry414_proc RTLNAME image_preprocess_p_anonymous_namespace_output_pass_Block_entry414_proc}
  {SRCNAME {(anonymous namespace)pack.3_Pipeline_VITIS_LOOP_396_2} MODELNAME p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_396_2 RTLNAME image_preprocess_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_396_2}
  {SRCNAME {(anonymous namespace)pack.3} MODELNAME p_anonymous_namespace_pack_3 RTLNAME image_preprocess_p_anonymous_namespace_pack_3}
  {SRCNAME {(anonymous namespace)write_words_Pipeline_VITIS_LOOP_417_1_VITIS_LOOP_419_2} MODELNAME p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_417_1_VITIS_LOOP_419_2 RTLNAME image_preprocess_p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_417_1_VITIS_LOOP_419_2}
  {SRCNAME {(anonymous namespace)write_words} MODELNAME p_anonymous_namespace_write_words RTLNAME image_preprocess_p_anonymous_namespace_write_words}
  {SRCNAME {(anonymous namespace)write_words.4_Pipeline_VITIS_LOOP_419_2} MODELNAME p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_419_2 RTLNAME image_preprocess_p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_419_2}
  {SRCNAME {(anonymous namespace)write_words.4} MODELNAME p_anonymous_namespace_write_words_4 RTLNAME image_preprocess_p_anonymous_namespace_write_words_4}
  {SRCNAME {(anonymous namespace)output_pass} MODELNAME p_anonymous_namespace_output_pass RTLNAME image_preprocess_p_anonymous_namespace_output_pass
    SUBMODULES {
      {MODELNAME image_preprocess_fifo_w64_d7_S RTLNAME image_preprocess_fifo_w64_d7_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w13_d7_S RTLNAME image_preprocess_fifo_w13_d7_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w1_d5_S RTLNAME image_preprocess_fifo_w1_d5_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w128_d64_A_x RTLNAME image_preprocess_fifo_w128_d64_A_x BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w32_d2_S_x RTLNAME image_preprocess_fifo_w32_d2_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w24_d64_A_x RTLNAME image_preprocess_fifo_w24_d64_A_x BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w2_d3_S RTLNAME image_preprocess_fifo_w2_d3_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w22_d3_S_x RTLNAME image_preprocess_fifo_w22_d3_S_x BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w48_d64_A RTLNAME image_preprocess_fifo_w48_d64_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w8_d64_S RTLNAME image_preprocess_fifo_w8_d64_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w22_d2_S RTLNAME image_preprocess_fifo_w22_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_fifo_w1_d2_S RTLNAME image_preprocess_fifo_w1_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_start_for_p_anonymous_namespace_write_words_U0 RTLNAME image_preprocess_start_for_p_anonymous_namespace_write_words_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_start_for_p_anonymous_namespace_write_words_4_U0 RTLNAME image_preprocess_start_for_p_anonymous_namespace_write_words_4_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
      {MODELNAME image_preprocess_start_for_p_anonymous_namespace_unpack_2_U0 RTLNAME image_preprocess_start_for_p_anonymous_namespace_unpack_2_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME {$InstName}}
    }
  }
  {SRCNAME image_preprocess MODELNAME image_preprocess RTLNAME image_preprocess IS_TOP 1
    SUBMODULES {
      {MODELNAME image_preprocess_previous_V_RAM_2P_LUTRAM_1R1W RTLNAME image_preprocess_previous_V_RAM_2P_LUTRAM_1R1W BINDTYPE storage TYPE ram_2p IMPL lutram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_color_V_RAM_2P_LUTRAM_1R1W RTLNAME image_preprocess_color_V_RAM_2P_LUTRAM_1R1W BINDTYPE storage TYPE ram_2p IMPL lutram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_hist_V_RAM_2P_BRAM_1R1W RTLNAME image_preprocess_hist_V_RAM_2P_BRAM_1R1W BINDTYPE storage TYPE ram_2p IMPL bram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_xc_index_V_RAM_1P_BRAM_1R1W RTLNAME image_preprocess_xc_index_V_RAM_1P_BRAM_1R1W BINDTYPE storage TYPE ram_1p IMPL bram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_xc_weight_V_RAM_1P_BRAM_1R1W RTLNAME image_preprocess_xc_weight_V_RAM_1P_BRAM_1R1W BINDTYPE storage TYPE ram_1p IMPL bram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME image_preprocess_gmem_in_m_axi RTLNAME image_preprocess_gmem_in_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME image_preprocess_gmem_out_m_axi RTLNAME image_preprocess_gmem_out_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME image_preprocess_gmem_preview_m_axi RTLNAME image_preprocess_gmem_preview_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME image_preprocess_control_s_axi RTLNAME image_preprocess_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}
