# Reconstruct the source BD in an isolated project, then validate IP insertion.
set root [file normalize [file join [file dirname [info script]] ..]]
set source_bd /home/amd/Workspace/dpu_platform2/kv260_hardware_platform/kv260_hardware_platform/kv260_hardware_platform.srcs/sources_1/bd/kv260_hardware_platform/kv260_hardware_platform.bd
set check_dir [file join $root build integration_check]
set copy_dir [file join $check_dir source_bd]
file mkdir $copy_dir
set copy_bd [file join $copy_dir kv260_hardware_platform.bd]
file copy -force $source_bd $copy_bd
create_project -force image_integration_check [file join $check_dir project] -part xck26-sfvc784-2LV-c
import_files $copy_bd
open_bd_design [get_files */kv260_hardware_platform.bd]
source [file join $root scripts integrate_bd.tcl]
write_bd_tcl -force [file join $check_dir integrated_bd.tcl]
set address_file [open [file join $check_dir addresses.txt] w]
foreach segment [get_bd_addr_segs -hier] {
    puts $address_file "$segment OFFSET=[get_property OFFSET $segment] RANGE=[get_property RANGE $segment]"
}
close $address_file
close_project
exit