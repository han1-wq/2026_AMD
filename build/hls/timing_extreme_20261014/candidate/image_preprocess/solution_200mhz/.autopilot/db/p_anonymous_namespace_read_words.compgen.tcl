# This script segment is generated automatically by AutoPilot

set id 42
set name image_preprocess_mul_mul_9ns_11ns_20_4_1
set corename simcore_mul
set op mul
set stage_num 4
set clk_width 1
set clk_signed 0
set reset_width 1
set reset_signed 0
set in0_width 9
set in0_signed 0
set in1_width 11
set in1_signed 0
set ce_width 1
set ce_signed 0
set out_width 20
set arg_lists {i0 {9 0 +} i1 {11 0 +} p {20 1 +} acc {0} }
set TrueReset 0
if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $name BINDTYPE {op} TYPE {all} IMPL {dsp48} LATENCY 3 ALLOW_PRAGMA 1
}


set op mul
set corename DSP48
if {${::AESL::PGuard_autocg_gen} && ${::AESL::PGuard_autocg_ipmgen}} {
if {[info proc ::AESL_LIB_VIRTEX::xil_gen_dsp48] == "::AESL_LIB_VIRTEX::xil_gen_dsp48"} {
eval "::AESL_LIB_VIRTEX::xil_gen_dsp48 { \
    id ${id} \
    name ${name} \
    corename ${corename} \
    op ${op} \
    reset_level 1 \
    sync_rst true \
    true_reset ${TrueReset} \
    stage_num ${stage_num} \
    clk_width ${clk_width} \
    clk_signed ${clk_signed} \
    reset_width ${reset_width} \
    reset_signed ${reset_signed} \
    in0_width ${in0_width} \
    in0_signed ${in0_signed} \
    in1_width ${in1_width} \
    in1_signed ${in1_signed} \
    ce_width ${ce_width} \
    ce_signed ${ce_signed} \
    out_width ${out_width} \
    arg_lists {${arg_lists}} \
}"
} else {
puts "@W \[IMPL-101\] Cannot find ::AESL_LIB_VIRTEX::xil_gen_dsp48, check your platform lib"
}
}


# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 44 \
    name gmem_in \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_gmem_in \
    op interface \
    ports { m_axi_gmem_in_AWVALID { O 1 bit } m_axi_gmem_in_AWREADY { I 1 bit } m_axi_gmem_in_AWADDR { O 64 vector } m_axi_gmem_in_AWID { O 1 vector } m_axi_gmem_in_AWLEN { O 32 vector } m_axi_gmem_in_AWSIZE { O 3 vector } m_axi_gmem_in_AWBURST { O 2 vector } m_axi_gmem_in_AWLOCK { O 2 vector } m_axi_gmem_in_AWCACHE { O 4 vector } m_axi_gmem_in_AWPROT { O 3 vector } m_axi_gmem_in_AWQOS { O 4 vector } m_axi_gmem_in_AWREGION { O 4 vector } m_axi_gmem_in_AWUSER { O 1 vector } m_axi_gmem_in_WVALID { O 1 bit } m_axi_gmem_in_WREADY { I 1 bit } m_axi_gmem_in_WDATA { O 128 vector } m_axi_gmem_in_WSTRB { O 16 vector } m_axi_gmem_in_WLAST { O 1 bit } m_axi_gmem_in_WID { O 1 vector } m_axi_gmem_in_WUSER { O 1 vector } m_axi_gmem_in_ARVALID { O 1 bit } m_axi_gmem_in_ARREADY { I 1 bit } m_axi_gmem_in_ARADDR { O 64 vector } m_axi_gmem_in_ARID { O 1 vector } m_axi_gmem_in_ARLEN { O 32 vector } m_axi_gmem_in_ARSIZE { O 3 vector } m_axi_gmem_in_ARBURST { O 2 vector } m_axi_gmem_in_ARLOCK { O 2 vector } m_axi_gmem_in_ARCACHE { O 4 vector } m_axi_gmem_in_ARPROT { O 3 vector } m_axi_gmem_in_ARQOS { O 4 vector } m_axi_gmem_in_ARREGION { O 4 vector } m_axi_gmem_in_ARUSER { O 1 vector } m_axi_gmem_in_RVALID { I 1 bit } m_axi_gmem_in_RREADY { O 1 bit } m_axi_gmem_in_RDATA { I 128 vector } m_axi_gmem_in_RLAST { I 1 bit } m_axi_gmem_in_RID { I 1 vector } m_axi_gmem_in_RFIFONUM { I 7 vector } m_axi_gmem_in_RUSER { I 1 vector } m_axi_gmem_in_RRESP { I 2 vector } m_axi_gmem_in_BVALID { I 1 bit } m_axi_gmem_in_BREADY { O 1 bit } m_axi_gmem_in_BRESP { I 2 vector } m_axi_gmem_in_BID { I 1 vector } m_axi_gmem_in_BUSER { I 1 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 45 \
    name src \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_src \
    op interface \
    ports { src { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 46 \
    name words1 \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_words1 \
    op interface \
    ports { words1_din { O 128 vector } words1_num_data_valid { I 7 vector } words1_fifo_cap { I 7 vector } words1_full_n { I 1 bit } words1_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 47 \
    name width \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_width \
    op interface \
    ports { width { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 48 \
    name height \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_height \
    op interface \
    ports { height { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 49 \
    name stride \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_stride \
    op interface \
    ports { stride { I 13 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 50 \
    name width_c \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_width_c \
    op interface \
    ports { width_c_din { O 32 vector } width_c_num_data_valid { I 2 vector } width_c_fifo_cap { I 2 vector } width_c_full_n { I 1 bit } width_c_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 51 \
    name height_c \
    type fifo \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_height_c \
    op interface \
    ports { height_c_din { O 32 vector } height_c_num_data_valid { I 2 vector } height_c_fifo_cap { I 2 vector } height_c_full_n { I 1 bit } height_c_write { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id -1 \
    name ap_ctrl \
    type ap_ctrl \
    reset_level 1 \
    sync_rst true \
    corename ap_ctrl \
    op interface \
    ports { ap_start { I 1 bit } ap_ready { O 1 bit } ap_done { O 1 bit } ap_idle { O 1 bit } ap_continue { I 1 bit } } \
} "
}


# Adapter definition:
set PortName ap_clk
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_clock] == "cg_default_interface_gen_clock"} {
eval "cg_default_interface_gen_clock { \
    id -2 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_clk \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-113\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}


# Adapter definition:
set PortName ap_rst
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_reset] == "cg_default_interface_gen_reset"} {
eval "cg_default_interface_gen_reset { \
    id -3 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_rst \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-114\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}



# merge
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_end
    cg_default_interface_gen_bundle_end
    AESL_LIB_XILADAPTER::native_axis_end
}


