# Source inside an opened COPY of the platform project/BD, before implementation.
# export_design must have completed. Polling control is used; interrupt is unused.
set image_root [file normalize [file join [file dirname [info script]] ..]]
set image_repo [file join $image_root build image_preprocess solution_200mhz impl ip]
if {![file exists [file join $image_repo component.xml]]} {
    error "Export HLS IP first: HLS_STAGE=export vitis_hls -f scripts/build.tcl"
}
foreach image_cell {zynq_ultra_ps_e_0 clk_wiz_1 proc_sys_reset_2 ps8_0_axi_periph} {
    if {[llength [get_bd_cells -quiet $image_cell]] != 1} {
        error "Expected platform cell $image_cell; open the source platform BD"
    }
}
foreach image_port {S_AXI_HP2_FPD S_AXI_HP3_FPD} {
    set image_pin [get_bd_intf_pins -quiet zynq_ultra_ps_e_0/$image_port]
    if {[llength $image_pin] && [llength [get_bd_intf_nets -quiet -of_objects $image_pin]]} {
        error "$image_port already connected; resolve port allocation before insertion"
    }
}
if {[llength [get_bd_cells -quiet image_preprocess_1]]} { error "IP already inserted" }
set_property ip_repo_paths [concat [get_property ip_repo_paths [current_project]] [list $image_repo]] [current_project]
update_ip_catalog
set_property -dict [list CONFIG.PSU__USE__S_AXI_GP4 1 CONFIG.PSU__USE__S_AXI_GP5 1 \
    CONFIG.PSU__SAXIGP4__DATA_WIDTH 128 CONFIG.PSU__SAXIGP5__DATA_WIDTH 128] \
    [get_bd_cells zynq_ultra_ps_e_0]
create_bd_cell -type ip -vlnv local:vision:image_preprocess:1.0 image_preprocess_1
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 image_input_sc
set_property -dict [list CONFIG.NUM_SI 1 CONFIG.NUM_MI 1] [get_bd_cells image_input_sc]
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 image_output_sc
set_property -dict [list CONFIG.NUM_SI 2 CONFIG.NUM_MI 1] [get_bd_cells image_output_sc]
connect_bd_intf_net [get_bd_intf_pins image_preprocess_1/m_axi_gmem_in] [get_bd_intf_pins image_input_sc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins image_input_sc/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP2_FPD]
connect_bd_intf_net [get_bd_intf_pins image_preprocess_1/m_axi_gmem_out] [get_bd_intf_pins image_output_sc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins image_preprocess_1/m_axi_gmem_preview] [get_bd_intf_pins image_output_sc/S01_AXI]
connect_bd_intf_net [get_bd_intf_pins image_output_sc/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP3_FPD]
set image_control [get_bd_cells ps8_0_axi_periph]
set image_mi [get_property CONFIG.NUM_MI $image_control]
if {$image_mi >= 16} { error "No free control interconnect master slot" }
set_property CONFIG.NUM_MI [expr {$image_mi + 1}] $image_control
set image_slot [format M%02d $image_mi]
connect_bd_intf_net [get_bd_intf_pins ps8_0_axi_periph/${image_slot}_AXI] [get_bd_intf_pins image_preprocess_1/s_axi_control]
foreach image_pin [list image_preprocess_1/ap_clk image_input_sc/aclk image_output_sc/aclk \
    zynq_ultra_ps_e_0/saxihp2_fpd_aclk zynq_ultra_ps_e_0/saxihp3_fpd_aclk \
    ps8_0_axi_periph/${image_slot}_ACLK] {
    connect_bd_net [get_bd_pins clk_wiz_1/clk_out3] [get_bd_pins $image_pin]
}
foreach image_pin [list image_preprocess_1/ap_rst_n image_input_sc/aresetn image_output_sc/aresetn \
    ps8_0_axi_periph/${image_slot}_ARESETN] {
    connect_bd_net [get_bd_pins proc_sys_reset_2/peripheral_aresetn] [get_bd_pins $image_pin]
}
# Let Vivado allocate a nonoverlapping control address and DDR address segments.
# The generated HWH and driver headers define the actual register/address map.
assign_bd_address
validate_bd_design
save_bd_design
puts "Inserted image_preprocess_1. Export the updated platform/HWH and rerun full implementation."