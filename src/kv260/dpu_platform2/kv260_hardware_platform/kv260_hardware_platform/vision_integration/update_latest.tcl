# Refresh the already integrated vision kernels from the local IP snapshots.
set root [file normalize [file dirname [info script]]]
set project_dir [file dirname $root]
set reports [file join $root reports latest_20261014]
file mkdir $reports
set_param general.maxThreads 2
open_project [file join $project_dir kv260_hardware_platform.xpr]
set_property ip_repo_paths [list [file join $project_dir ip_repo vision image_preprocess] \
    [file join $project_dir ip_repo vision yolo_postprocess]] [current_project]
update_ip_catalog -rebuild
set bd [get_files */kv260_hardware_platform.bd]
if {[llength $bd] != 1} {error "Expected exactly one platform BD"}
open_bd_design $bd
upgrade_bd_cells [get_bd_cells {image_preprocess_1 yolo_postprocess_1}]
validate_bd_design -force
save_bd_design
report_ip_status -file [file join $reports ip_status.rpt]
reset_target all $bd
generate_target all $bd
set wrappers [make_wrapper -files $bd -top]
add_files -norecurse $wrappers
set_property top kv260_hardware_platform_wrapper [get_filesets sources_1]
update_compile_order -fileset sources_1
save_bd_design
# Preserve existing run products while recording that they are stale.
foreach name {synth_1 impl_1} {
    set_property NEEDS_REFRESH true [get_runs $name]
}
set fp [open [file join $reports run_status.txt] w]
foreach run [get_runs] {
    puts $fp "$run STATUS=[get_property STATUS $run] NEEDS_REFRESH=[get_property NEEDS_REFRESH $run]"
}
close $fp
close_project
puts VISION_LATEST_UPDATE_PASS
exit