# Independent OOC RTL synthesis for mapped resource counts, not routed timing.
set root [file normalize [file join [file dirname [info script]] ..]]
set rtl_dir [file join $root build image_preprocess solution_200mhz syn verilog]
cd $rtl_dir
set output_dir [file join $root build rtl_synthesis]
file mkdir $output_dir
create_project -in_memory -part xck26-sfvc784-2LV-c
read_verilog [glob [file join $rtl_dir *.v]]
set constraints [open [file join $output_dir clock.xdc] w]
puts $constraints {create_clock -name ap_clk -period 5.000 [get_ports ap_clk]}
close $constraints
read_xdc [file join $output_dir clock.xdc]
synth_design -top image_preprocess -part xck26-sfvc784-2LV-c -mode out_of_context
report_utilization -file [file join $output_dir utilization.rpt]
report_timing_summary -file [file join $output_dir timing.rpt]
write_checkpoint -force [file join $output_dir image_preprocess.dcp]
exit