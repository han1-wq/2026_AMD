# Only operate on the disposable comparison project, never the live platform.
set work [file normalize [file dirname [info script]]]
set clone [file join $work platform_candidate]
set project [file join $clone kv260_hardware_platform.xpr]
set reports [file join $work candidate_routed]
file mkdir $reports
set_param general.maxThreads 2
open_project $project
if {[file normalize [get_property DIRECTORY [current_project]]] ne $clone} {
    error "Refusing to modify a project outside platform_candidate"
}
set_property ip_output_repo [file join $clone kv260_hardware_platform.cache ip] [current_project]
foreach source [get_files -all] {
    if {[file exists $source] && [string first "${clone}/" [file normalize $source]] != 0} {
        error "Clone resolved an external source: $source"
    }
}
if {![info exists ::env(VISION_RESUME_IMPL)]} {
set_property ip_repo_paths [list [file join $clone ip_repo vision image_preprocess] \
    [file join $clone ip_repo vision yolo_postprocess]] [current_project]
update_ip_catalog -rebuild
set bd [get_files */kv260_hardware_platform.bd]
if {[llength $bd] != 1} {error "Expected exactly one platform BD"}
open_bd_design $bd
foreach file [get_files -all] {
    if {[string first "/home/amd/Workspace/dpu_platform2/" $file] >= 0} {
        error "Clone resolved a live-project source: $file"
    }
}
upgrade_bd_cells [get_bd_cells {image_preprocess_1 yolo_postprocess_1}]
validate_bd_design -force
save_bd_design
report_ip_status -file [file join $reports ip_status.rpt]
set_property synth_checkpoint_mode None $bd
reset_target all $bd
generate_target all $bd
set wrappers [make_wrapper -files $bd -top]
add_files -norecurse $wrappers
set_property top kv260_hardware_platform_wrapper [get_filesets sources_1]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs synth_1 -jobs 2
wait_on_run synth_1
if {![string match {*Complete*} [get_property STATUS [get_runs synth_1]]]} {
    error "Platform synthesis failed: [get_property STATUS [get_runs synth_1]]"
}
}
launch_runs impl_1 -to_step {phys_opt_design (Post-Route)} -jobs 2
wait_on_run impl_1
if {![string match {*Complete*} [get_property STATUS [get_runs impl_1]]]} {
    error "Platform implementation failed: [get_property STATUS [get_runs impl_1]]"
}
open_run impl_1
report_timing_summary -delay_type min_max -check_timing_verbose \
    -file [file join $reports timing_summary.rpt]
report_utilization -file [file join $reports utilization.rpt]
report_route_status -file [file join $reports route_status.rpt]
report_design_analysis -congestion -file [file join $reports congestion.rpt]
report_drc -file [file join $reports drc.rpt]
report_bus_skew -warn_on_violation -file [file join $reports bus_skew.rpt]
report_clocks -file [file join $reports clocks.rpt]
set status [open [file join $reports slack.tsv] w]
puts $status "scope\ttype\tslack_ns"
set passed 1
foreach type {max min} {
    set path [get_timing_paths -delay_type $type -max_paths 1]
    if {[llength $path] != 1} {error "Missing global $type timing path"}
    set slack [get_property SLACK $path]
    puts $status "global\t$type\t$slack"
    if {$slack < 0} {set passed 0}
}
foreach kernel {image_preprocess yolo_postprocess} {
    set cells [get_cells -hier -filter "NAME =~ */${kernel}_1/*"]
    if {[llength $cells] == 0} {error "Missing $kernel"}
    foreach type {max min} {
        report_timing -from $cells -to $cells -delay_type $type -max_paths 20 \
            -nworst 1 -path_type full_clock_expanded -input_pins \
            -file [file join $reports ${kernel}_${type}.rpt]
        set path [get_timing_paths -from $cells -to $cells -delay_type $type -max_paths 1]
        if {[llength $path] != 1} {error "Missing $kernel $type timing path"}
        puts $status "$kernel\t$type\t[get_property SLACK $path]"
    }
    report_utilization -cells [get_cells -hier -filter "NAME =~ */${kernel}_1"] \
        -file [file join $reports ${kernel}_utilization.rpt]
}
close $status
write_checkpoint -force [file join $reports platform_candidate.dcp]
if {!$passed} {error "Candidate platform does not meet setup/hold timing"}
puts VISION_CANDIDATE_ROUTED_PASS
close_project
exit