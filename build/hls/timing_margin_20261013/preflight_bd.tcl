open_project {/home/amd/Workspace/HLS_IP/timing_margin_20261013/platform_candidate/kv260_hardware_platform.xpr}
open_bd_design [get_files */kv260_hardware_platform.bd]
puts "UPGRADE_COMMANDS=[info commands *upgrade*]"
help upgrade_bd_cells
help upgrade_bd_cell
help upgrade_ip
puts "IP_USER_FILES=[get_property IP_USER_FILES_DIR [current_project]]"
foreach f [get_files -all] {if {[string first "/home/amd/Workspace/dpu_platform2" $f] >= 0} {puts "EXTERNAL_FILE=$f"}}
foreach ip [get_ips] {puts "IP=$ip FILE=[get_property IP_FILE $ip]"}
close_project
exit
