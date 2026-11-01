# Vivado 2022.1: apply once, or verify the saved hardware platform.
set root [file normalize [file dirname [info script]]]
set project_dir [file dirname $root]
set mode [lindex $argv 0]
if {$mode ni {apply verify}} { error "Usage: integrate.tcl -tclargs apply|verify" }
file mkdir $root/reports/$mode
open_project $project_dir/kv260_hardware_platform.xpr
set bd [get_files */kv260_hardware_platform.bd]
if {[llength $bd] != 1} { error "Expected exactly one platform BD" }
if {$mode eq "apply"} {
    set_property ip_repo_paths [list $project_dir/ip_repo/vision/image_preprocess $project_dir/ip_repo/vision/yolo_postprocess] [current_project]
    update_ip_catalog -rebuild
}
open_bd_design $bd

proc same_net {a b} {
    set na [get_bd_nets -quiet -of_objects [get_bd_pins $a]]
    set nb [get_bd_nets -quiet -of_objects [get_bd_pins $b]]
    if {[llength $na] != 1 || $na ne $nb} { error "Net mismatch: $a / $b" }
}
proc same_interface {a b} {
    set na [get_bd_intf_nets -quiet -of_objects [get_bd_intf_pins $a]]
    set nb [get_bd_intf_nets -quiet -of_objects [get_bd_intf_pins $b]]
    if {[llength $na] != 1 || $na ne $nb} { error "Interface mismatch: $a / $b" }
}
set clock_pins {
    image_preprocess_1/ap_clk yolo_postprocess_1/ap_clk
    vision_read_sc/aclk vision_write_sc/aclk
    zynq_ultra_ps_e_0/saxihp2_fpd_aclk zynq_ultra_ps_e_0/saxihp3_fpd_aclk
    ps8_0_axi_periph/M01_ACLK ps8_0_axi_periph/M02_ACLK
}
set peripheral_reset_pins {image_preprocess_1/ap_rst_n yolo_postprocess_1/ap_rst_n}
set interconnect_reset_pins {
    vision_read_sc/aresetn vision_write_sc/aresetn
    ps8_0_axi_periph/M01_ARESETN ps8_0_axi_periph/M02_ARESETN
}
set interfaces {
    image_preprocess_1/m_axi_gmem_in vision_read_sc/S00_AXI
    yolo_postprocess_1/m_axi_gmem_in vision_read_sc/S01_AXI
    vision_read_sc/M00_AXI zynq_ultra_ps_e_0/S_AXI_HP2_FPD
    image_preprocess_1/m_axi_gmem_out vision_write_sc/S00_AXI
    image_preprocess_1/m_axi_gmem_preview vision_write_sc/S01_AXI
    yolo_postprocess_1/m_axi_gmem_out vision_write_sc/S02_AXI
    vision_write_sc/M00_AXI zynq_ultra_ps_e_0/S_AXI_HP3_FPD
    ps8_0_axi_periph/M01_AXI image_preprocess_1/s_axi_control
    ps8_0_axi_periph/M02_AXI yolo_postprocess_1/s_axi_control
}
set masters {
    image_preprocess_1 m_axi_gmem_in SAXIGP4
    yolo_postprocess_1 m_axi_gmem_in SAXIGP4
    image_preprocess_1 m_axi_gmem_out SAXIGP5
    image_preprocess_1 m_axi_gmem_preview SAXIGP5
    yolo_postprocess_1 m_axi_gmem_out SAXIGP5
}
if {[get_property CONFIG.CLKOUT3_REQUESTED_OUT_FREQ [get_bd_cells clk_wiz_1]] != 200} {
    error "Expected platform clk_wiz_1/clk_out3 at nominal 200 MHz"
}
same_net clk_wiz_1/clk_out3 proc_sys_reset_2/slowest_sync_clk

if {$mode eq "apply"} {
    foreach cell {image_preprocess_1 yolo_postprocess_1 vision_read_sc vision_write_sc vision_irq_concat vision_irq_zero} {
        if {[llength [get_bd_cells -quiet $cell]]} { error "Already integrated: use verify" }
    }
    if {[get_property CONFIG.NUM_MI [get_bd_cells ps8_0_axi_periph]] != 1} {
        error "Expected the original base platform control interconnect"
    }
    foreach pin {S_AXI_HP2_FPD S_AXI_HP3_FPD} {
        set p [get_bd_intf_pins -quiet zynq_ultra_ps_e_0/$pin]
        if {[llength $p] && [llength [get_bd_intf_nets -quiet -of_objects $p]]} { error "$pin occupied" }
    }
    set p [get_bd_pins -quiet zynq_ultra_ps_e_0/pl_ps_irq1]
    if {[llength $p] && [llength [get_bd_nets -quiet -of_objects $p]]} { error "PS IRQ1 occupied" }
    set_property -dict [list CONFIG.PSU__USE__S_AXI_GP4 1 CONFIG.PSU__USE__S_AXI_GP5 1 \
        CONFIG.PSU__SAXIGP4__DATA_WIDTH 128 CONFIG.PSU__SAXIGP5__DATA_WIDTH 128 \
        CONFIG.PSU__USE__IRQ1 1] [get_bd_cells zynq_ultra_ps_e_0]
    foreach core {image_preprocess yolo_postprocess} {
        create_bd_cell -type ip -vlnv local:vision:${core}:1.0 ${core}_1
    }
    foreach {cell count} {vision_read_sc 2 vision_write_sc 3} {
        create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 $cell
        set_property -dict [list CONFIG.NUM_SI $count CONFIG.NUM_MI 1 CONFIG.NUM_CLKS 1] [get_bd_cells $cell]
    }
    set_property CONFIG.NUM_MI 3 [get_bd_cells ps8_0_axi_periph]
    foreach {master slave} $interfaces {
        connect_bd_intf_net [get_bd_intf_pins $master] [get_bd_intf_pins $slave]
    }
    foreach pin $clock_pins { connect_bd_net [get_bd_pins clk_wiz_1/clk_out3] [get_bd_pins $pin] }
    foreach pin $peripheral_reset_pins { connect_bd_net [get_bd_pins proc_sys_reset_2/peripheral_aresetn] [get_bd_pins $pin] }
    foreach pin $interconnect_reset_pins { connect_bd_net [get_bd_pins proc_sys_reset_2/interconnect_aresetn] [get_bd_pins $pin] }

    # Static interrupts use PS IRQ1[1:0]. Keep AXI INTC's 32 platform IRQs
    # available to the Vitis linker (DPU/softmax) on the existing PS IRQ0.
    create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 vision_irq_concat
    set_property -dict [list CONFIG.NUM_PORTS 3 CONFIG.IN2_WIDTH 6] [get_bd_cells vision_irq_concat]
    create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vision_irq_zero
    set_property -dict [list CONFIG.CONST_WIDTH 6 CONFIG.CONST_VAL 0] [get_bd_cells vision_irq_zero]
    connect_bd_net [get_bd_pins image_preprocess_1/interrupt] [get_bd_pins vision_irq_concat/In0]
    connect_bd_net [get_bd_pins yolo_postprocess_1/interrupt] [get_bd_pins vision_irq_concat/In1]
    connect_bd_net [get_bd_pins vision_irq_zero/dout] [get_bd_pins vision_irq_concat/In2]
    connect_bd_net [get_bd_pins vision_irq_concat/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq1]

    foreach {core offset} {image_preprocess_1 0x86000000 yolo_postprocess_1 0x86010000} {
        assign_bd_address -offset $offset -range 64K -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs $core/s_axi_control/Reg]
    }
    foreach {core interface psport} $masters {
        foreach region {DDR_LOW DDR_HIGH} {
            assign_bd_address -target_address_space [get_bd_addr_spaces $core/Data_$interface] [get_bd_addr_segs zynq_ultra_ps_e_0/$psport/*$region]
        }
    }
    # Do not advertise occupied ports as free Vitis platform resources.
    foreach {cell used} {
        zynq_ultra_ps_e_0 {S_AXI_HP2_FPD S_AXI_HP3_FPD}
        ps8_0_axi_periph {M01_AXI M02_AXI}
    } {
        set attrs [get_property PFM.AXI_PORT [get_bd_cells $cell]]
        foreach port $used { dict unset attrs $port }
        set_property PFM.AXI_PORT $attrs [get_bd_cells $cell]
    }
}

validate_bd_design -force
foreach pin $clock_pins { same_net clk_wiz_1/clk_out3 $pin }
foreach pin $peripheral_reset_pins { same_net proc_sys_reset_2/peripheral_aresetn $pin }
foreach pin $interconnect_reset_pins { same_net proc_sys_reset_2/interconnect_aresetn $pin }
foreach {master slave} $interfaces { same_interface $master $slave }
same_net image_preprocess_1/interrupt vision_irq_concat/In0
same_net yolo_postprocess_1/interrupt vision_irq_concat/In1
same_net vision_irq_concat/dout zynq_ultra_ps_e_0/pl_ps_irq1
same_net axi_intc_0/irq zynq_ultra_ps_e_0/pl_ps_irq0
foreach {cell used} {
    zynq_ultra_ps_e_0 {S_AXI_HP2_FPD S_AXI_HP3_FPD}
    ps8_0_axi_periph {M01_AXI M02_AXI}
} {
    foreach port $used {
        if {[dict exists [get_property PFM.AXI_PORT [get_bd_cells $cell]] $port]} { error "Occupied port still advertised: $cell/$port" }
    }
}
foreach {core offset} {image_preprocess_1 0x86000000 yolo_postprocess_1 0x86010000} {
    set seg [get_bd_addr_segs -of_objects [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] -filter "NAME =~ *${core}*"]
    if {[llength $seg] != 1 || [get_property OFFSET $seg] != $offset || [get_property RANGE $seg] != 65536} {
        error "Unexpected control address for $core"
    }
    set hz [get_property CONFIG.FREQ_HZ [get_bd_pins $core/ap_clk]]
    if {$hz < 199900000 || $hz > 200100000} { error "Unexpected clock for $core: $hz" }
    puts "VISION_CLOCK $core $hz Hz (nominal 200 MHz)"
}
foreach {core interface psport} $masters {
    set segs [get_bd_addr_segs -of_objects [get_bd_addr_spaces $core/Data_$interface]]
    if {[llength $segs] != 2} { error "Expected DDR_LOW and DDR_HIGH for $core/$interface" }
    foreach seg $segs {
        if {![string match *DDR_LOW $seg] && ![string match *DDR_HIGH $seg]} { error "Unexpected memory segment $seg" }
    }
}
set dir $root/reports/$mode
report_ip_status -file $dir/ip_status.rpt
write_bd_tcl -force $dir/integrated_bd.tcl
set fp [open $dir/connections.txt w]
foreach pin $clock_pins {
    puts $fp "$pin NET=[get_bd_nets -of_objects [get_bd_pins $pin]] FREQ_HZ=[get_property CONFIG.FREQ_HZ [get_bd_pins $pin]]"
}
foreach seg [get_bd_addr_segs -hier] {
    puts $fp "$seg OFFSET=[get_property OFFSET $seg] RANGE=[get_property RANGE $seg]"
}
close $fp
if {$mode eq "apply"} {
    regenerate_bd_layout
    save_bd_design
    generate_target all $bd
    make_wrapper -files $bd -top
    update_compile_order -fileset sources_1
    save_bd_design
}
set fp [open $dir/run_status.txt w]
foreach run [get_runs] { puts $fp "$run STATUS=[get_property STATUS $run] NEEDS_REFRESH=[get_property NEEDS_REFRESH $run]" }
close $fp
close_project
puts "VISION_200MHZ_${mode}_PASS"
exit