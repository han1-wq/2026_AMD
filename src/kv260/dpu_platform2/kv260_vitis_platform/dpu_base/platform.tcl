# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_base/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_base/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {dpu_base}\
-hw {/home/amd/Workspace/dpu_platform2/kv260_hardware_platform/kv260_hardware_platform/kv260_hardware_platform.xsa}\
-proc {psu_cortexa53} -os {linux} -arch {64-bit} -no-boot-bsp -fsbl-target {psu_cortexa53_0} -out {/home/amd/Workspace/dpu_platform2/kv260_vitis_platform}

platform write
platform active {dpu_base}
platform generate
