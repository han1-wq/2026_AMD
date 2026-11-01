connect -url tcp:127.0.0.1:3121
targets -set -filter {name =~ "ARM Cortex-A9 MPCore #0"}
stop
mrd -bin -file {/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/lwip_audit/baseline_trace/ofdm_net_trace_count.bin} 0x2de994 1
mrd -bin -file {/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/lwip_audit/baseline_trace/ofdm_net_trace_overflow.bin} 0x2de998 1
mrd -bin -file {/home/amd/ofdm/eeSDR_ofdm_loopback/sim/captures/lwip_audit/baseline_trace/ofdm_net_trace.bin} 0x28e994 81920
con
disconnect
exit
