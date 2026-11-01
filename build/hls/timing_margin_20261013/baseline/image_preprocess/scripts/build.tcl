# Usage: HLS_STAGE=csim|synth|cosim|export|all vitis_hls -f scripts/build.tcl
set root [file normalize [file join [file dirname [info script]] ..]]
set stage csim
if {[info exists ::env(HLS_STAGE)]} { set stage $::env(HLS_STAGE) }
if {$stage ni {csim synth cosim export all}} { error "Invalid HLS_STAGE: $stage" }
file mkdir [file join $root build]
cd [file join $root build]
open_project image_preprocess
set_top image_preprocess
add_files [file join $root src image_preprocess.cpp] -cflags "-std=c++14 -I[file join $root src]"
add_files -tb [file join $root tb test_image_preprocess.cpp] -cflags "-std=c++14 -I[file join $root src]"
open_solution solution_200mhz -flow_target vivado
set_part {xck26-sfvc784-2LV-c}
create_clock -period 5 -name default
set_clock_uncertainty 0.625
config_interface -m_axi_addr64
if {$stage in {csim all}} { csim_design -clean }
if {$stage in {synth all}} { csynth_design }
if {$stage in {cosim all}} {
    cosim_design -rtl verilog -tool xsim -argv {--smoke} -trace_level none
}
if {$stage in {export all}} {
    export_design -format ip_catalog -rtl verilog -vendor local -library vision -version 1.0 -display_name {KV260 Image Preprocess}
}
exit