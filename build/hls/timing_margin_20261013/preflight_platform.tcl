open_project {/home/amd/Workspace/HLS_IP/timing_margin_20261013/platform_candidate/kv260_hardware_platform.xpr}
puts "CLONE_DIRECTORY=[get_property DIRECTORY [current_project]]"
puts "UPGRADE_CMD=[info commands upgrade_bd_cells]"
help upgrade_bd_cells
puts "IMPL_STRATEGY=[get_property STRATEGY [get_runs impl_1]]"
puts "POSTROUTE_ENABLED=[get_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED [get_runs impl_1]]"
puts "BD=[get_files */kv260_hardware_platform.bd]"
close_project
exit
