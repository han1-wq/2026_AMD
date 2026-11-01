# xsct firmware/build_dma_sw.tcl /absolute/TOP.xsa /unused/workspace [board_id] [subnet]
if {[llength $argv] < 2 || [llength $argv] > 4} {error {Expected XSA, workspace, optional board ID and subnet}}
set fwroot [file dirname [file normalize [info script]]]
set hw [file normalize [lindex $argv 0]]
set ws [file normalize [lindex $argv 1]]
set id [expr {[llength $argv] >= 3 ? [lindex $argv 2] : 10}]
set subnet [expr {[llength $argv] == 4 ? [lindex $argv 3] : 1}]
if {$id < 2 || $id > 254} {error {Board ID must be 2..254}}
if {![string is integer -strict $subnet] || $subnet < 0 || $subnet > 255} {error {Subnet must be 0..255}}
if {[file exists $ws]} {error {Workspace must not exist}}
puts [exec python3 [file join $fwroot check_dma_xsa.py] $hw]
setws $ws
platform create -name dma_platform -hw $hw -proc ps7_cortexa9_0 -os standalone
platform active dma_platform
domain active standalone_domain
bsp setlib -name lwip211 -ver 1.7
bsp config lwip_dhcp false
bsp config ipv6_enable false
# lwip211 v1.7's Zynq GEM driver caps each TX pbuf at 1500 bytes,
# including Ethernet/IP/TCP headers. Keep full segments below that cap
# (1440 + 14 + 20 + 20 = 1494) to avoid unrecoverable truncated retransmits.
bsp config tcp_mss 1440
# A 2048-byte window repeatedly closes partway through 1026-byte records.
# Fit multiple full segments while staying within services.c's 64 KiB ring.
bsp config tcp_wnd 32768
platform generate
app create -name ofdm_dma -platform dma_platform -domain standalone_domain -template {Empty Application(C)}
set src [file join $ws ofdm_dma src]
foreach f [glob $fwroot/radio/*] {file copy -force $f $src}
foreach f [glob $fwroot/dma_app/*] {file copy -force $f $src}
app config -name ofdm_dma define-compiler-symbols BOARD_ID=$id
app config -name ofdm_dma define-compiler-symbols BOARD_SUBNET=$subnet
if {[info exists ::env(OFDM_NET_TRACE)] && $::env(OFDM_NET_TRACE) eq "1"} {
    app config -name ofdm_dma define-compiler-symbols OFDM_NET_TRACE
}
app config -name ofdm_dma linker-misc {-Wl,--wrap=phy_setup_emacps}
app build -name ofdm_dma
puts "DMA_SOFTWARE_COMPLETE $ws/ofdm_dma/Debug/ofdm_dma.elf BOARD_ID=$id BOARD_SUBNET=$subnet"