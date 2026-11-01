#
# this file was created by a computer. trust it.
#

# compiler tools
XILINX_VITIS ?= /tools/Xilinx/Vitis/2022.1
XILINX_VIVADO ?= /tools/Xilinx/Vivado/2022.1
XILINX_HLS ?= $(XILINX_VITIS)/Vivado_HLS

VPP ?= ${XILINX_VITIS}/bin/v++
RM = rm -f
RMDIR = rm -rf

VITIS_PLATFORM = dpu_base
VITIS_PLATFORM_DIR = /home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_base/export/dpu_base
VITIS_PLATFORM_PATH = $(VITIS_PLATFORM_DIR)/dpu_base.xpfm

TARGET = hw
VPP_OPTS = --target $(TARGET)

#
# Hw kernel files
#


HW_KERNEL_OBJS += DPUCZDX8G.xo
HW_KERNEL_OBJS += sfm_xrt_top.xo

ALL_MESSAGE_FILES = $(subst .xo,.o,.mdb,$(SRC_KERNEL_OBJS))

#
# primary build targets
#

.PHONY: all clean
all: $(HW_KERNEL_OBJS)


clean:
	-$(RM) $(SRC_KERNEL_OBJS) $(ALL_MESSAGE_FILES) 
	-$(RMDIR) $(BUILD_SUBDIRS)
	-$(RMDIR) .Xil
	-rm -rf *.log *.jou *.xo packaged_* tmp_kernel_*

.PHONY: incremental
incremental: all


nothing:

#
# Hw Kernels compile;
#

DPUCZDX8G.xo: ../src/prj/Vitis/kernel_xml/dpu/kernel.xml ../src/prj/Vitis/scripts_gui/package_dpu_kernel.tcl ../src/prj/Vitis/scripts_gui/gen_dpu_xo.tcl ../src/prj/Vitis/dpu_conf.vh ../src/dpu_ip/Vitis/dpu/hdl/DPUCZDX8G.v ../src/dpu_ip/Vitis/dpu/inc/arch_def.vh ../src/dpu_ip/Vitis/dpu/xdc/timing_clocks.xdc ../src/dpu_ip/DPUCZDX8G_v4_0_0/ttcl/fingerprint_json.ttcl ../src/dpu_ip/DPUCZDX8G_v4_0_0/hdl/DPUCZDX8G_v4_0_0_vl_dpu.sv ../src/dpu_ip/DPUCZDX8G_v4_0_0/inc/function.vh ../src/dpu_ip/DPUCZDX8G_v4_0_0/inc/arch_para.vh
	$(XILINX_VIVADO)/bin/vivado -mode batch -source ../src/prj/Vitis/scripts_gui/gen_dpu_xo.tcl -tclargs .. $@ $(@F:.xo=) $(TARGET) $(VITIS_PLATFORM) $(VITIS_PLATFORM_PATH)

sfm_xrt_top.xo: ../src/prj/Vitis/kernel_xml/sfm/kernel.xml ../src/prj/Vitis/scripts_gui/package_sfm_kernel.tcl ../src/prj/Vitis/scripts_gui/gen_sfm_xo.tcl ../src/dpu_ip/Vitis/sfm/hdl/sfm_xrt_top.v ../src/dpu_ip/DPUCZDX8G_v4_0_0/hdl/DPUCZDX8G_v4_0_0_vl_sfm.sv ../src/dpu_ip/DPUCZDX8G_v4_0_0/xci/sfm/fp_acc/fp_acc.xci ../src/dpu_ip/DPUCZDX8G_v4_0_0/xci/sfm/fp_add/fp_add.xci ../src/dpu_ip/DPUCZDX8G_v4_0_0/xci/sfm/fp_convert/fp_convert.xci ../src/dpu_ip/DPUCZDX8G_v4_0_0/xci/sfm/fp_div/fp_div.xci ../src/dpu_ip/DPUCZDX8G_v4_0_0/xci/sfm/fp_exp/fp_exp.xci
	$(XILINX_VIVADO)/bin/vivado -mode batch -source ../src/prj/Vitis/scripts_gui/gen_sfm_xo.tcl -tclargs .. $@ $(@F:.xo=) $(TARGET) $(VITIS_PLATFORM) $(VITIS_PLATFORM_PATH)

