set root [file normalize [file join [file dirname [info script]] ..]]
set project /home/amd/Workspace/dpu_platform2/kv260_vitis_platform2/dpu_trd_system_hw_link/Hardware/dpu.build/link/vivado/vpl/prj/prj.xpr
set mode [lindex $argv 0]
if {$mode ni {check apply prepare verify clock100}} { error "Use check, apply, prepare, verify, or clock100" }
file mkdir [file join $root reports $mode]
open_project $project
# Resolve HLS VLNVs only against the preserved integration snapshots.
# Live HLS exports can change revision without changing the VLNV.
set repos [get_property ip_repo_paths [current_project]]
set pinned_repos {}
foreach core {image_preprocess yolo_postprocess} {
    set repo [file join $root ip_repo $core]
    if {![file exists [file join $repo component.xml]]} { error "Missing IP snapshot $repo" }
    lappend pinned_repos $repo
}
foreach repo $repos {
    if {[file normalize $repo] eq "/home/amd/Workspace/HLS_IP"} { continue }
    if {[lsearch -exact $pinned_repos $repo] < 0} { lappend pinned_repos $repo }
}
set_property ip_repo_paths $pinned_repos [current_project]
update_ip_catalog -rebuild
# Reload IP instances after repairing a catalog that may have locked them.
if {$repos ne $pinned_repos} {
    close_project
    open_project $project
}
set bd [get_files */kv260_hardware_platform.bd]
if {[llength $bd] != 1} { error "Expected one platform BD" }
if {$mode eq "check"} {
    set repos [get_property ip_repo_paths [current_project]]
    set part [get_property PART [current_project]]
    set copy [file join $root check_source kv260_hardware_platform.bd]
    file mkdir [file dirname $copy]
    set backup_file [file join $root backup_path.txt]
    if {[file exists $backup_file]} {
        set fp [open $backup_file r]
        set original [file join [string trim [read $fp]] original_bd.json]
        close $fp
        file copy -force $original $copy
    } else {
        file copy -force $bd $copy
    }
    close_project
    create_project -force accelerator_bd_check [file join $root check_project] -part $part
    set_property ip_repo_paths $repos [current_project]
    update_ip_catalog
    import_files $copy
    set bd [get_files */kv260_hardware_platform.bd]
}
open_bd_design $bd
if {$mode in {check apply}} { source [file join $root scripts integrate_accelerators.tcl] }
if {$mode eq "clock100"} { source [file join $root scripts connect_vision_100mhz.tcl] }
validate_bd_design
if {$mode eq "clock100"} { save_bd_design }
set dir [file join $root reports $mode]
report_ip_status -file [file join $dir ip_status.rpt]
write_bd_tcl -force [file join $dir integrated_bd.tcl]
set fp [open [file join $dir addresses.txt] w]
foreach seg [get_bd_addr_segs -hier] {
    puts $fp "$seg OFFSET=[get_property OFFSET $seg] RANGE=[get_property RANGE $seg]"
}
close $fp
set fp [open [file join $dir run_status.txt] w]
foreach run [get_runs] {
    puts $fp "$run STATUS=[get_property STATUS $run] NEEDS_REFRESH=[get_property NEEDS_REFRESH $run]"
}
close $fp
if {$mode in {apply prepare clock100}} {
    generate_target all $bd
    # A clock-only migration preserves the project's existing synthesis mode.
    # This linked project can use global BD synthesis without separate IP runs.
    if {$mode ne "clock100"} { create_ip_run $bd }
    update_compile_order -fileset sources_1
    save_bd_design
    puts "ACCELERATOR_OUTPUT_PRODUCTS_PASS"
}
close_project
puts "ACCELERATOR_${mode}_PASS"
exit