# Read-only target identification and boot strap inspection.
connect -url tcp:127.0.0.1:3121
puts [targets]
puts [jtag targets]
targets -set -filter {name =~ "ARM Cortex-A9 MPCore #0"}
puts "BOOT_MODE_REGISTER [mrd 0xF800025C]"
disconnect
exit