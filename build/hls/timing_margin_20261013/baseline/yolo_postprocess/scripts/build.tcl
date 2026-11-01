set root [file normalize [file join [file dirname [info script]] ..]]
set stage csim
if {[info exists ::env(HLS_STAGE)]} { set stage $::env(HLS_STAGE) }
if {$stage ni {csim synth cosim export all}} { error "Invalid HLS_STAGE" }
file mkdir [file join $root build]
cd [file join $root build]
open_project yolo_postprocess
set_top yolo_postprocess
add_files [file join $root src yolo_postprocess.cpp] -cflags "-std=c++14 -O2"
add_files -tb [file join $root tb test_yolo_postprocess.cpp] -cflags "-std=c++14 -O2 -I[file join $root src]"
open_solution solution_200mhz -flow_target vivado
set_part {xck26-sfvc784-2LV-c}
create_clock -period 5 -name default
set_clock_uncertainty 0.625
config_interface -m_axi_addr64
if {$stage in {csim all}} { csim_design -clean -O }
if {$stage in {synth all}} { csynth_design }
if {$stage in {cosim all}} { cosim_design -rtl verilog -tool xsim -argv {--smoke} -trace_level none }
if {$stage in {export all}} { export_design -format ip_catalog -rtl verilog -vendor local -library vision -version 1.0 }
exit