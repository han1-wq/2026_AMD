# Source IP configurations

These 27 XCI configurations and their adjacent initialization files were
preserved byte-for-byte from the former `build_80m_neighbor_v6/ip` directory.
They are build inputs, not disposable generated products.

`/home/amd/ofdm/eeSDR_ofdm_loopback/build_project.tcl` imports these files into
the requested output directory and regenerates the IP products with Vivado
2022.1. It resolves ROM coefficient paths against the maintained RTL tree.
The custom AXI control IP remains under
`/home/amd/ofdm/eeSDR_ofdm_loopback/ip_repo/axi_ad936x_ctrl`.