set root /home/amd/ofdm/eeSDR_ofdm_loopback
set out [file join $root build_hw]
open_project [file join $out ofdm_ad9361.xpr]
source [file join $root check_mailbox_bd.tcl]
set bd [get_files ZYNQ_bd.bd]
open_bd_design $bd
check_mailbox_bd $bd rst_mailbox rst_mailbox_peripheral_aresetn 3
set_param general.maxThreads 4
launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {
    error "Synthesis failed: [get_property STATUS [get_runs synth_1]]"
}
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
if {[get_property STATUS [get_runs impl_1]] ne {write_bitstream Complete!}} {
    error "Implementation failed: [get_property STATUS [get_runs impl_1]]"
}
open_run impl_1
source [file join $root check_routed_timing.tcl]
check_routed_timing $out
report_utilization -file [file join $out routed_utilization.rpt]
report_drc -file [file join $out routed_drc.rpt]
set bit [file join [get_property DIRECTORY [get_runs impl_1]] TOP.bit]
if {![file exists $bit]} {error "Missing bitstream: $bit"}
file copy -force $bit [file join $out TOP.bit]
write_hw_platform -fixed -include_bit -force -file [file join $out TOP.xsa]
close_project
puts "ACTIVE_BITSTREAM_COMPLETE $out"