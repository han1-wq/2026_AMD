set_param general.maxThreads 2
open_checkpoint {/home/amd/Workspace/dpu_platform2/kv260_hardware_platform/kv260_hardware_platform/kv260_hardware_platform.runs/impl_1/kv260_hardware_platform_wrapper_postroute_physopt.dcp}
set out {/home/amd/Workspace/HLS_IP/timing_margin_20261013/baseline_routed}
file mkdir $out
foreach kernel {image_preprocess yolo_postprocess} {
 set cells [get_cells -hier -filter "NAME =~ */${kernel}_1/*"]
 if {[llength $cells] == 0} {error "Missing $kernel hierarchy"}
 foreach type {max min} {
 report_timing -from $cells -to $cells -delay_type $type -max_paths 20 -nworst 1 -path_type full_clock_expanded -input_pins -file $out/${kernel}_${type}.rpt
 }
 report_utilization -cells [get_cells -hier -filter "NAME =~ */${kernel}_1"] -file $out/${kernel}_utilization.rpt
}
puts VISION_ROUTED_ANALYSIS_PASS
exit
