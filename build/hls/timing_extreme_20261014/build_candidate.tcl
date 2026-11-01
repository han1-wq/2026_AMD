set work [file normalize [file dirname [info script]]]
set kernel $::env(VISION_KERNEL)
if {$kernel ni {image_preprocess yolo_postprocess}} {error "Invalid VISION_KERNEL"}
set stage $::env(HLS_STAGE)
if {$stage ni {csim synth cosim export}} {error "Invalid HLS_STAGE"}
set root [file join $work sources $kernel]
file mkdir [file join $work candidate]
cd [file join $work candidate]
open_project $kernel
set_top $kernel
add_files [file join $root src ${kernel}.cpp] -cflags "-std=c++14 -O2 -I[file join $root src]"
add_files -tb [file join $root tb test_${kernel}.cpp] -cflags "-std=c++14 -O2 -I[file join $root src]"
open_solution solution_200mhz -flow_target vivado
set_part {xck26-sfvc784-2LV-c}
create_clock -period 5 -name default
set_clock_uncertainty 0.625
config_interface -m_axi_addr64
if {$stage eq "csim"} {csim_design -clean -O}
if {$stage eq "synth"} {csynth_design}
if {$stage eq "cosim"} {cosim_design -rtl verilog -tool xsim -argv {--smoke} -trace_level none}
if {$stage eq "export"} {export_design -format ip_catalog -rtl verilog -vendor local -library vision -version 1.0}
exit