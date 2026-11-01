connect -url tcp:127.0.0.1:3121
targets -set -filter {name =~ "ARM Cortex-A9 MPCore #0"}
stop
set result [catch {
loadhw -hw /home/amd/ofdm/eeSDR_ofdm_loopback/build_dma_progress_fix/TOP.xsa -mem-ranges [list {0x40000000 0x4fffffff}]
puts "PC [rrd pc]"
puts "outstanding [mrd 0x002847c8 1]"
puts "fault [mrd 0x002847d0 1]"
for {set i 0} {$i < 32} {incr i} {puts "window$i [mrd [expr {0x002847d4+1048*$i+1024}] 6]"}
puts "ack_wr [mrd 0x0028e8d4 1]"
puts "ack_rd [mrd 0x0028e8d8 1]"
puts "cursor [mrd 0x0028e8e4 1]"
puts "link_retries [mrd 0x0028e8f8 1]"
puts "link_failures [mrd 0x0028e8fc 1]"
puts "client [mrd 0x0028ea20 1]"
puts "in_wr [mrd 0x002aea24 1]"
puts "in_rd [mrd 0x002aea28 1]"
puts "out_wr [mrd 0x002aea2c 1]"
puts "out_rd [mrd 0x002aea30 1]"
puts "upload_active [mrd 0x012b36a0 1]"
puts "upload_failed [mrd 0x012b36b4 1]"
puts "upload_count [mrd 0x012b36b8 1]"
puts "upload_next [mrd 0x012b36bc 1]"
puts "now_ms [mrd 0x012b36e8 1]"
puts "next_tcp_timer [mrd 0x012b36ec 1]"
set pcb [mrd -value 0x0028ea20]
if {$pcb != 0} {puts "PCB [mrd $pcb 40]"; set seg [mrd -value [expr {$pcb+112}]]; if {$seg != 0} {puts "UNACKED [mrd $seg 4]"; set buf [mrd -value [expr {$seg+4}]]; puts "PBUF [mrd $buf 4]"; set hdr [mrd -value [expr {$seg+12}]]; puts "TCP_HEADER [mrd $hdr 5]"}}
puts "PACKET [mrd 0x43c10000 13]"
puts "DMA [mrd 0x40400000 24]"
} problem]
con
disconnect
if {$result} {error $problem}
exit
