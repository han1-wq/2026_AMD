# Source in the linked DPU BD, or an isolated copy of that BD.
# Standalone AXI-Lite IPs: polling is supported; these are not XRT kernels.
set integration_root [file normalize [file join [file dirname [info script]] ..]]
foreach cell {zynq_ultra_ps_e_0 clk_wiz_1 proc_sys_reset_0 ps8_0_axi_periph} {
    if {[llength [get_bd_cells -quiet $cell]] != 1} { error "Missing platform cell $cell" }
}
foreach cell {image_preprocess_1 yolo_postprocess_1 vision_read_sc vision_write_sc} {
    if {[llength [get_bd_cells -quiet $cell]]} { error "Already integrated: $cell" }
}
foreach port {S_AXI_HP2_FPD S_AXI_HP3_FPD} {
    set pin [get_bd_intf_pins -quiet zynq_ultra_ps_e_0/$port]
    if {[llength $pin] && [llength [get_bd_intf_nets -quiet -of_objects $pin]]} {
        error "PS port $port is already occupied"
    }
}
if {[get_property CONFIG.CLKOUT1_REQUESTED_OUT_FREQ [get_bd_cells clk_wiz_1]] != 100} {
    error "Expected clk_wiz_1/clk_out1 at 100 MHz"
}
set control [get_bd_cells ps8_0_axi_periph]
set original_mi [get_property CONFIG.NUM_MI $control]
if {$original_mi != 3} { error "Expected three existing control outputs, got $original_mi" }
set repos [get_property ip_repo_paths [current_project]]
set pinned_repos {}
foreach core {image_preprocess yolo_postprocess} {
    set repo [file join $integration_root ip_repo $core]
    if {![file exists [file join $repo component.xml]]} { error "Missing exported IP: $repo" }
    lappend pinned_repos $repo
}
foreach repo $repos {
    if {[file normalize $repo] eq "/home/amd/Workspace/HLS_IP"} { continue }
    if {[lsearch -exact $pinned_repos $repo] < 0} { lappend pinned_repos $repo }
}
set_property ip_repo_paths $pinned_repos [current_project]
update_ip_catalog
set_property -dict [list CONFIG.PSU__USE__S_AXI_GP4 1 CONFIG.PSU__USE__S_AXI_GP5 1 \
    CONFIG.PSU__SAXIGP4__DATA_WIDTH 128 CONFIG.PSU__SAXIGP5__DATA_WIDTH 128] \
    [get_bd_cells zynq_ultra_ps_e_0]
create_bd_cell -type ip -vlnv local:vision:image_preprocess:1.0 image_preprocess_1
create_bd_cell -type ip -vlnv local:vision:yolo_postprocess:1.0 yolo_postprocess_1
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 vision_read_sc
set_property -dict [list CONFIG.NUM_SI 2 CONFIG.NUM_MI 1 CONFIG.NUM_CLKS 1] [get_bd_cells vision_read_sc]
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 vision_write_sc
set_property -dict [list CONFIG.NUM_SI 3 CONFIG.NUM_MI 1 CONFIG.NUM_CLKS 1] [get_bd_cells vision_write_sc]
foreach {master slave} {
    image_preprocess_1/m_axi_gmem_in vision_read_sc/S00_AXI
    yolo_postprocess_1/m_axi_gmem_in vision_read_sc/S01_AXI
    vision_read_sc/M00_AXI zynq_ultra_ps_e_0/S_AXI_HP2_FPD
    image_preprocess_1/m_axi_gmem_out vision_write_sc/S00_AXI
    image_preprocess_1/m_axi_gmem_preview vision_write_sc/S01_AXI
    yolo_postprocess_1/m_axi_gmem_out vision_write_sc/S02_AXI
    vision_write_sc/M00_AXI zynq_ultra_ps_e_0/S_AXI_HP3_FPD
} {
    connect_bd_intf_net [get_bd_intf_pins $master] [get_bd_intf_pins $slave]
}
set_property CONFIG.NUM_MI 5 $control
connect_bd_intf_net [get_bd_intf_pins ps8_0_axi_periph/M03_AXI] [get_bd_intf_pins image_preprocess_1/s_axi_control]
connect_bd_intf_net [get_bd_intf_pins ps8_0_axi_periph/M04_AXI] [get_bd_intf_pins yolo_postprocess_1/s_axi_control]
source [file join $integration_root scripts connect_vision_100mhz.tcl]
# Keep existing IRQ0 (softmax) and IRQ1 (DPU) unchanged. New software may poll.
foreach {core index} {image_preprocess_1 2 yolo_postprocess_1 3} {
    set pin [get_bd_pins axi_intc_0_intr_1_interrupt_concat/In$index]
    set net [get_bd_nets -quiet -of_objects $pin]
    if {[llength $net] != 1 || [lsearch -exact [get_bd_pins -of_objects $net] /irq_const_tieoff/dout] < 0} {
        error "Interrupt input $index is not tied low as expected"
    }
    disconnect_bd_net $net $pin
    connect_bd_net [get_bd_pins $core/interrupt] $pin
}
# Explicit nonoverlapping control windows; do not relocate existing peripherals.
# M_AXI_HPM0_LPD exposes only 0x80000000..0x9fffffff in this platform.
assign_bd_address -offset 0x86000000 -range 64K -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs image_preprocess_1/s_axi_control/Reg]
assign_bd_address -offset 0x86010000 -range 64K -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs yolo_postprocess_1/s_axi_control/Reg]
# Only expose DDR to new memory masters, not OCM/QSPI or other PS peripherals.
foreach {core interface psport} {
    image_preprocess_1 m_axi_gmem_in SAXIGP4
    yolo_postprocess_1 m_axi_gmem_in SAXIGP4
    image_preprocess_1 m_axi_gmem_out SAXIGP5
    image_preprocess_1 m_axi_gmem_preview SAXIGP5
    yolo_postprocess_1 m_axi_gmem_out SAXIGP5
} {
    set space [get_bd_addr_spaces -quiet $core/Data_$interface]
    if {[llength $space] != 1} { error "Cannot identify master address space $core/$interface" }
    foreach region {DDR_LOW DDR_HIGH} {
        set segs [get_bd_addr_segs -quiet zynq_ultra_ps_e_0/$psport/*$region]
        if {[llength $segs] != 1} { error "Cannot identify DDR region $psport/$region" }
        assign_bd_address -target_address_space $space $segs
    }
}
validate_bd_design
regenerate_bd_layout
save_bd_design
puts "ACCELERATOR_INTEGRATION_PASS"