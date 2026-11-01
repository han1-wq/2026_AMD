# Recovered AD936x control IP

The two HDL files are byte-for-byte copies of the surviving IP source under
`generated_07/ofdm_ad9361.srcs/sources_1/bd/board/ipshared/9eee/hdl`.
They retain the original four-register AXI-Lite implementation and TR_mode
assignment (register 0, bit 0); no datapath or register-map changes were made.

The original external IP repository is missing. `package_ctrl_ip.tcl` creates
fresh IP-XACT metadata and XGUI files in each new build directory, preserving
the VLNV `xilinx.com:user:axi_ad936x_ctrl:1.0`, interface `S00_AXI`, and address
block `S00_AXI_reg`. The build registers that output-local repository before
importing/upgrading the board BD. Generated wrappers are not used as sources.