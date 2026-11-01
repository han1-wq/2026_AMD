# Source after creating the vision cores, or to migrate their existing wiring.
# Reuse the platform's 100 MHz clock and its synchronous reset controller.
if {[get_property CONFIG.CLKOUT1_REQUESTED_OUT_FREQ [get_bd_cells clk_wiz_1]] != 100} {
    error "Expected clk_wiz_1/clk_out1 at 100 MHz"
}
set vision_clock [get_bd_pins clk_wiz_1/clk_out1]
set vision_clock_net [get_bd_nets -of_objects $vision_clock]
if {[get_bd_nets -of_objects [get_bd_pins proc_sys_reset_0/slowest_sync_clk]] ne $vision_clock_net} {
    error "proc_sys_reset_0 must be synchronized to clk_wiz_1/clk_out1"
}
set vision_connections {}
foreach pin {
    image_preprocess_1/ap_clk yolo_postprocess_1/ap_clk
    vision_read_sc/aclk vision_write_sc/aclk
    zynq_ultra_ps_e_0/saxihp2_fpd_aclk zynq_ultra_ps_e_0/saxihp3_fpd_aclk
    ps8_0_axi_periph/M03_ACLK ps8_0_axi_periph/M04_ACLK
} {
    lappend vision_connections [list $pin clk_wiz_1/clk_out1 clk_wiz_1/clk_out3]
}
foreach pin {image_preprocess_1/ap_rst_n yolo_postprocess_1/ap_rst_n} {
    lappend vision_connections [list $pin proc_sys_reset_0/peripheral_aresetn proc_sys_reset_2/peripheral_aresetn]
}
foreach pin {vision_read_sc/aresetn vision_write_sc/aresetn ps8_0_axi_periph/M03_ARESETN ps8_0_axi_periph/M04_ARESETN} {
    lappend vision_connections [list $pin proc_sys_reset_0/interconnect_aresetn proc_sys_reset_2/interconnect_aresetn]
}
# Check every endpoint before changing any connections.
foreach connection $vision_connections {
    lassign $connection endpoint target previous
    set pin [get_bd_pins $endpoint]
    if {[llength $pin] != 1} { error "Missing endpoint $endpoint" }
    set net [get_bd_nets -quiet -of_objects $pin]
    if {[llength $net]} {
        set pins [get_bd_pins -of_objects $net]
        if {[lsearch -exact $pins /$target] < 0 && [lsearch -exact $pins /$previous] < 0} {
            error "Unexpected existing clock/reset driver for $endpoint"
        }
    }
}
foreach connection $vision_connections {
    lassign $connection endpoint target previous
    set pin [get_bd_pins $endpoint]
    set net [get_bd_nets -quiet -of_objects $pin]
    set target_net [get_bd_nets -of_objects [get_bd_pins $target]]
    if {$net eq $target_net} { continue }
    if {[llength $net]} { disconnect_bd_net $net $pin }
    connect_bd_net [get_bd_pins $target] $pin
    puts "VISION_100MHZ: $endpoint <- $target"
}