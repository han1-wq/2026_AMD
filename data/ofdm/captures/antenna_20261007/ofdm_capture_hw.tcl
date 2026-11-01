open_hw_manager
connect_hw_server -url localhost:3121
open_hw_target
set dev [get_hw_devices xc7z020_1]
set_property PROBES.FILE /home/amd/ofdm/eeSDR_ofdm_loopback/build_80m_neighbor_v6/ofdm_ad9361.runs/impl_1/TOP.ltx $dev
current_hw_device $dev
refresh_hw_device $dev
set ila [lindex [get_hw_ilas] 0]
help wait_on_hw_ila
help write_hw_ila_data
set_property CONTROL.TRIGGER_POSITION 64 $ila
set_property CONTROL.DATA_DEPTH 4096 $ila
set txp [get_hw_probes *w_tx_sample_valid -of_objects $ila]
set_property TRIGGER_COMPARE_VALUE eq1'bX $txp
set_property TRIGGER_COMPARE_VALUE eq1'b1 [get_hw_probes *w_payload_valid -of_objects $ila]
for {set seq 140} {$seq < 150} {incr seq} {
    run_hw_ila $ila
    puts [exec python3 /tmp/ofdm_send_capture.py $seq]
    if {[catch {wait_on_hw_ila -timeout 2 $ila} msg]} {
        puts "NO_PAYLOAD $seq $msg"
        stop_hw_ila $ila
        continue
    }
    set data [upload_hw_ila_data $ila]
    write_hw_ila_data -csv_file /tmp/ofdm_capture_${seq}.csv $data
}
close_hw_manager