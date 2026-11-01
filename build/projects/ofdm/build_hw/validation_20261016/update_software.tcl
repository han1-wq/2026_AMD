set root /home/amd/ofdm/eeSDR_ofdm_loopback
set ws [file join $root build_sw]
set hw [file join $root build_hw TOP.xsa]
puts [exec python3 [file join $root firmware check_dma_xsa.py] $hw]
setws $ws
platform active dma_platform
platform config -updatehw $hw
domain active standalone_domain
platform generate
app clean -name ofdm_dma
app build -name ofdm_dma
puts "BITSTREAM_SOFTWARE_COMPLETE $ws/ofdm_dma/Debug/ofdm_dma.elf"
exit