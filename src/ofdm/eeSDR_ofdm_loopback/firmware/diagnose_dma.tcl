# Pause CPU0 briefly to read GEM MDIO and packet adapter counters, then resume.
# xsct /absolute/diagnose_dma.tcl [matching_TOP.xsa]
if {[llength $argv] > 1} {error {Expected optional matching XSA}}
set root [file dirname [file dirname [file normalize [info script]]]]
set hw [expr {[llength $argv] ? [lindex $argv 0] : [file join $root release_dma TOP.xsa]}]
connect -url tcp:127.0.0.1:3121
targets -set -filter {name =~ "ARM Cortex-A9 MPCore #0"}
catch {stop}
proc phy_read {address reg} {
    mwr 0xe000b034 [expr {0x60020000 | ($address << 23) | ($reg << 18)}]
    after 2
    return [expr {[mrd -value 0xe000b034] & 0xffff}]
}
set result [catch {
    loadhw -hw $hw -mem-ranges [list {0x40000000 0x4fffffff}]
    if {[catch {mrd 0x43c10000 13} packet_registers]} {
        puts "PACKET_REGISTERS unavailable: $packet_registers"
    } else {
        puts "PACKET_REGISTERS: $packet_registers"
    }
    puts "DMA_REGISTERS: [mrd 0x40400000 24]"
    foreach offset {0x00 0x04 0x08 0x14 0x34} {
        puts "GEM_REGISTER: [mrd [expr {0xe000b000 + $offset}]]"
    }
    for {set address 0} {$address < 32} {incr address} {
        set id1 [phy_read $address 2]
        set id2 [phy_read $address 3]
        if {$id1 != 0xffff && $id1 != 0} {
            puts [format "PHY address=%d ID=%04x:%04x" $address $id1 $id2]
            foreach reg {0 1 4 5 9 10 17 18 19 26 31} {
                puts [format "  reg %d = %04x" $reg [phy_read $address $reg]]
            }
        }
    }
} problem]
con
disconnect
if {$result} {error $problem}
exit