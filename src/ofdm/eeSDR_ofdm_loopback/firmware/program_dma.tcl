# xsct /absolute/path/program_dma.tcl bitstream elf matching_ps7_init.tcl
if {[llength $argv] != 3} {error {Expected bitstream, ELF and matching ps7_init.tcl}}
foreach path $argv {if {![file isfile $path]} {error "Missing file: $path"}}
connect -url tcp:127.0.0.1:3121
targets -set -filter {name =~ "ARM Cortex-A9 MPCore #0"}
# program_flash can leave the CPU halted. Do not reject that valid state.
if {[catch {stop} stop_error] && $stop_error ne "Already stopped"} {
    error $stop_error
}
rst -system
after 1000
targets -set -filter {name =~ "xc7z020"}
fpga -file [lindex $argv 0]
targets -set -filter {name =~ "ARM Cortex-A9 MPCore #0"}
source [lindex $argv 2]
ps7_init
ps7_post_config
dow [lindex $argv 1]
con
puts {DMA_PROGRAMMED_AND_RUNNING}
disconnect
exit