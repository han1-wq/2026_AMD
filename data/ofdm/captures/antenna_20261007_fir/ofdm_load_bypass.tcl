connect -url tcp:127.0.0.1:3121
targets -set -filter {name =~ "ARM*#0"}
stop
rst -processor
dow /tmp/ofdm_fir_bypass/Debug/AD936x_PS.elf
con
disconnect
exit