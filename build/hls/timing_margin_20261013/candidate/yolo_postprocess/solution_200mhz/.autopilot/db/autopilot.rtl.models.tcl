set SynModuleInfo {
  {SRCNAME yolo_postprocess_Pipeline_VITIS_LOOP_107_2_VITIS_LOOP_108_3 MODELNAME yolo_postprocess_Pipeline_VITIS_LOOP_107_2_VITIS_LOOP_108_3 RTLNAME yolo_postprocess_yolo_postprocess_Pipeline_VITIS_LOOP_107_2_VITIS_LOOP_108_3
    SUBMODULES {
      {MODELNAME yolo_postprocess_flow_control_loop_pipe_sequential_init RTLNAME yolo_postprocess_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME yolo_postprocess_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME yolo_postprocess_Pipeline_VITIS_LOOP_121_7 MODELNAME yolo_postprocess_Pipeline_VITIS_LOOP_121_7 RTLNAME yolo_postprocess_yolo_postprocess_Pipeline_VITIS_LOOP_121_7}
  {SRCNAME yolo_postprocess_Pipeline_VITIS_LOOP_151_10 MODELNAME yolo_postprocess_Pipeline_VITIS_LOOP_151_10 RTLNAME yolo_postprocess_yolo_postprocess_Pipeline_VITIS_LOOP_151_10}
  {SRCNAME {(anonymous namespace)area} MODELNAME p_anonymous_namespace_area RTLNAME yolo_postprocess_p_anonymous_namespace_area
    SUBMODULES {
      {MODELNAME yolo_postprocess_mul_16ns_16ns_32_3_1 RTLNAME yolo_postprocess_mul_16ns_16ns_32_3_1 BINDTYPE op TYPE mul IMPL fabric LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yolo_postprocess_add_33ns_33ns_33_2_1 RTLNAME yolo_postprocess_add_33ns_33ns_33_2_1 BINDTYPE op TYPE add IMPL fabric LATENCY 1 ALLOW_PRAGMA 1}
      {MODELNAME yolo_postprocess_add_32ns_32ns_32_2_1 RTLNAME yolo_postprocess_add_32ns_32ns_32_2_1 BINDTYPE op TYPE add IMPL fabric LATENCY 1 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME {(anonymous namespace)suppress} MODELNAME p_anonymous_namespace_suppress RTLNAME yolo_postprocess_p_anonymous_namespace_suppress}
  {SRCNAME yolo_postprocess_Pipeline_VITIS_LOOP_147_8 MODELNAME yolo_postprocess_Pipeline_VITIS_LOOP_147_8 RTLNAME yolo_postprocess_yolo_postprocess_Pipeline_VITIS_LOOP_147_8}
  {SRCNAME yolo_postprocess MODELNAME yolo_postprocess RTLNAME yolo_postprocess IS_TOP 1
    SUBMODULES {
      {MODELNAME yolo_postprocess_mul_8ns_6ns_14_1_1 RTLNAME yolo_postprocess_mul_8ns_6ns_14_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME yolo_postprocess_mul_6ns_6ns_11_1_1 RTLNAME yolo_postprocess_mul_6ns_6ns_11_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME yolo_postprocess_mul_32s_32s_32_1_1 RTLNAME yolo_postprocess_mul_32s_32s_32_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME yolo_postprocess_mul_32s_6ns_32_1_1 RTLNAME yolo_postprocess_mul_32s_6ns_32_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME yolo_postprocess_mac_muladd_14ns_6ns_21ns_21_4_1 RTLNAME yolo_postprocess_mac_muladd_14ns_6ns_21ns_21_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME yolo_postprocess_boxes_x1_RAM_2P_BRAM_1R1W RTLNAME yolo_postprocess_boxes_x1_RAM_2P_BRAM_1R1W BINDTYPE storage TYPE ram_2p IMPL bram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yolo_postprocess_boxes_score_RAM_2P_BRAM_1R1W RTLNAME yolo_postprocess_boxes_score_RAM_2P_BRAM_1R1W BINDTYPE storage TYPE ram_2p IMPL bram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yolo_postprocess_boxes_id_RAM_2P_BRAM_1R1W RTLNAME yolo_postprocess_boxes_id_RAM_2P_BRAM_1R1W BINDTYPE storage TYPE ram_2p IMPL bram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yolo_postprocess_lut_RAM_2P_BRAM_1R1W RTLNAME yolo_postprocess_lut_RAM_2P_BRAM_1R1W BINDTYPE storage TYPE ram_2p IMPL bram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yolo_postprocess_gmem_in_m_axi RTLNAME yolo_postprocess_gmem_in_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME yolo_postprocess_gmem_out_m_axi RTLNAME yolo_postprocess_gmem_out_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME yolo_postprocess_control_s_axi RTLNAME yolo_postprocess_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}
