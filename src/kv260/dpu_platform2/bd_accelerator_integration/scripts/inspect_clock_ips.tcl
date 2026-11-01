set root [file normalize [file join [file dirname [info script]] ..]]
open_project /home/amd/Workspace/dpu_platform2/kv260_vitis_platform2/dpu_trd_system_hw_link/Hardware/dpu.build/link/vivado/vpl/prj/prj.xpr
puts "REPOSITORIES: [get_property ip_repo_paths [current_project]]"
open_bd_design [get_files */kv260_hardware_platform.bd]
report_ip_status -file [file join $root reports clock100 locked_ip_status.rpt]
foreach core {image_preprocess yolo_postprocess} {
    foreach ip [get_ips *${core}*] { report_property $ip }
    foreach def [get_ipdefs -all local:vision:${core}:1.0] { report_property $def }
}
close_project
exit