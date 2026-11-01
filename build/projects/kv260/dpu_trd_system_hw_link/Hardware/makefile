#
# this file was created by a computer. trust it.
#

# compiler tools
XILINX_VITIS ?= /tools/Xilinx/Vitis/2022.1
XILINX_VIVADO ?= /tools/Xilinx/Vivado/2022.1
XILINX_HLS ?= $(XILINX_VITIS)/Vivado_HLS

VPP_LINKER ?= ${XILINX_VITIS}/bin/v++
RM = rm -f
RMDIR = rm -rf

VITIS_PLATFORM = dpu_base
VITIS_PLATFORM_DIR = /home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_base/export/dpu_base
VITIS_PLATFORM_PATH = $(VITIS_PLATFORM_DIR)/dpu_base.xpfm

VPP_OPTS = --target hw

#
# Hw kernel files
#

BINARY_CONTAINERS += dpu.xclbin

BUILD_SUBDIRS += dpu.build
DPU_OBJS += ../../dpu_trd_kernels/Hardware/DPUCZDX8G.xo
DPU_OBJS += ../../dpu_trd_kernels/Hardware/sfm_xrt_top.xo

ALL_MESSAGE_FILES = $(subst .xclbin,.mdb,$(BINARY_CONTAINERS))

#
# primary build targets
#

.PHONY: all clean
all: $(BINARY_CONTAINERS)


clean:
	-$(RM) $(BINARY_CONTAINERS) $(ALL_MESSAGE_FILES) 
	-$(RM) *.xclbin.sh *.xclbin.info *.xclbin.link_summary*
	-$(RMDIR) $(BUILD_SUBDIRS)
	-$(RMDIR) .Xil

.PHONY: incremental
incremental: all


nothing:

#
# binary container: dpu.xclbin
#

dpu.xclbin: $(DPU_OBJS) dpu-link.cfg
	-@echo $(VPP_LINKER) $(VPP_OPTS) --link --config dpu-link.cfg -o"$@" $(DPU_OBJS) > dpu.xclbin.sh
	$(VPP_LINKER) $(VPP_OPTS) --link --config dpu-link.cfg -o"$@" $(DPU_OBJS)

