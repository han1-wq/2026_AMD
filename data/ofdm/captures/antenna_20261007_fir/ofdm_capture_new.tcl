open_hw_manager
connect_hw_server -url localhost:3121
open_hw_target
set dev [get_hw_devices xc7z020_1]
set_property PROBES.FILE /home/amd/ofdm/eeSDR_ofdm_loopback/build_80m_neighbor_v6/ofdm_ad9361.runs/impl_1/TOP.ltx $dev
current_hw_device $dev
refresh_hw_device $dev
set ila [lindex [get_hw_ilas] 0]
set_property CONTROL.TRIGGER_POSITION 64 $ila
set_property CONTROL.DATA_DEPTH 4096 $ila
foreach probe [get_hw_probes -of_objects $ila] {
    set width [get_property WIDTH $probe]
    set_property TRIGGER_COMPARE_VALUE "eq${width}'b[string repeat X $width]" $probe
}
set tx_sample_valid [get_hw_probes *w_tx_sample_valid -of_objects $ila]
set_property TRIGGER_COMPARE_VALUE eq1'b1 $tx_sample_valid
run_hw_ila $ila
puts [exec python3 /tmp/ofdm_send_fixed.py 221]
wait_on_hw_ila -timeout 5 $ila
set data [upload_hw_ila_data $ila]
write_hw_ila_data -csv_file /tmp/ofdm_new_capture_221.csv $data
close_hw_manager