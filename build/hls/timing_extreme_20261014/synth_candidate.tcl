set work [file normalize [file dirname [info script]]]
set kernel $::env(VISION_KERNEL)
if {$kernel ni {image_preprocess yolo_postprocess}} {error "Invalid VISION_KERNEL"}
set rtl [file join $work candidate $kernel solution_200mhz syn verilog]
set out [file join $work candidate $kernel mapped]
file mkdir $out
cd $rtl
set_param general.maxThreads 2
create_project -in_memory -part xck26-sfvc784-2LV-c
read_verilog [glob [file join $rtl *.v]]
set fd [open [file join $out clock.xdc] w]
puts $fd {create_clock -name ap_clk -period 5.000 [get_ports ap_clk]}
close $fd
read_xdc [file join $out clock.xdc]
synth_design -top $kernel -part xck26-sfvc784-2LV-c -mode out_of_context
report_utilization -file [file join $out utilization.rpt]
report_timing_summary -file [file join $out timing.rpt]
report_timing -delay_type max -max_paths 10 -file [file join $out critical_paths.rpt]
write_checkpoint -force [file join $out ${kernel}.dcp]
puts VISION_CANDIDATE_SYNTH_PASS
exit