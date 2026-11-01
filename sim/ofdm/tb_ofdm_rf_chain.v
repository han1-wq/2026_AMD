`timescale 1ns / 1ps
module tb_ofdm_rf_chain #(
    parameter integer RX_SHIFT = 4,
    parameter integer PACKETS = 1,
    parameter integer CHANNEL_SMOOTH = 1,
    parameter integer RATE_MBPS = 54,
    parameter integer RS_ENABLE = 1,
    parameter integer RS_INTERLEAVE = 1,
    parameter integer PAYLOAD_LENGTH = 64,
    parameter integer RS_INJECT_ERRORS = 0,
    parameter integer RS_BURST_LENGTH = 0,
    parameter integer RS_BURST_START = 0
);
    // SERVICE + encoded PSDU + tail, rounded to whole symbols.
    localparam integer PSDU_LENGTH = PAYLOAD_LENGTH+4+
        (RS_ENABLE ? 16*((PAYLOAD_LENGTH+4+238)/239) : 0);
    localparam integer DATA_SYMBOLS = (16 + 8*PSDU_LENGTH + 6 + 4*RATE_MBPS-1)/(4*RATE_MBPS);
    localparam integer PACKET_SAMPLES = 320 + 80*(1+DATA_SYMBOLS);
    reg clk = 0;
    reg rst = 1;
    always #6.25 clk = ~clk; // AD9361 1T1R: data_clk 80 MHz, IQ 40 MS/s
    wire cmd_valid, cmd_ready, s_valid, s_last, s_ready, tx_valid, done;
    wire [10:0] length;
    wire [5:0] rate;
    wire [1:0] upsample;
    wire [7:0] s_data;
    wire [15:0] tx_i, tx_q;
    wire [1:0] error;
    wire scaled_valid, rx_valid;
    wire signed [11:0] scaled_i, scaled_q;
    wire signed [15:0] rx_i, rx_q;
    wire fcs_valid, fcs_ok, fcs_ok_strobe;
    wire [7:0] payload;
    wire [15:0] pkt_length;
    integer output_count = 0, byte_count = 0, fcs_count = 0;
    localparam integer RS_DEPTH = (PAYLOAD_LENGTH+4+238)/239;
    localparam EXPECT_OK = RS_BURST_LENGTH>0 ?
        RS_BURST_LENGTH <= 8*(RS_INTERLEAVE ? RS_DEPTH : 1) : RS_INJECT_ERRORS<=8;
    wire dma_valid, dma_last;
    wire [7:0] dma_data;
    wire [31:0] dma_accepted, dma_dropped, dma_overflow, dma_timeout;
    wire dma_ready = cycle_count%5!=0;
    integer dma_bytes=0, dma_packets=0;
    ofdm_dma_rx dma (
        .clk(clk), .reset(rst), .packet_start(rx.packet_start),
        .rx_valid(fcs_valid), .rx_byte(payload), .fcs_strobe(fcs_ok_strobe),
        .fcs_ok(fcs_ok), .rx_length(pkt_length),
        .m_data(dma_data), .m_valid(dma_valid), .m_last(dma_last), .m_ready(dma_ready),
        .accepted(dma_accepted), .dropped(dma_dropped),
        .overflow(dma_overflow), .timed_out(dma_timeout));
    always @(posedge clk) if(!rst) begin
        if(dma_valid && dma_ready) begin
            if(!EXPECT_OK || dma_data!==((dma_bytes[7:0]^8'h5a)+8'h13) ||
               dma_last!=(dma_bytes==PAYLOAD_LENGTH-1))
                $fatal(1,"PHY_DMA mismatch index=%0d",dma_bytes);
            if(dma_last) begin dma_packets=dma_packets+1; dma_bytes=0; end
            else dma_bytes=dma_bytes+1;
        end
        if(fcs_count==PACKETS &&
           (EXPECT_OK ? dma_packets==PACKETS : dma_dropped==PACKETS)) begin
            if(dma_overflow || dma_timeout ||
               dma_accepted!=(EXPECT_OK ? PACKETS : 0) ||
               dma_dropped!=(EXPECT_OK ? 0 : PACKETS)) $fatal(1,"PHY_DMA counters");
            if(rf_burst_applied!=rf_burst_samples*PACKETS) $fatal(1,"RF dropout not applied");
            $display("RF_DROPOUT samples=%0d start=%0d applied=%0d",rf_burst_samples,rf_burst_start,rf_burst_applied);
            $display("RF_CHAIN_PASS packets=%0d gain=%f rx_shift=%0d rate=%0d rs=%0d errors=%0d interleave=%0d burst=%0d start=%0d dma_accepted=%0d dma_dropped=%0d",
                     PACKETS,gain,RX_SHIFT,RATE_MBPS,RS_ENABLE,RS_INJECT_ERRORS,RS_INTERLEAVE,
                     RS_BURST_LENGTH,RS_BURST_START,dma_accepted,dma_dropped);
            $finish;
        end
    end
    integer cycle_count = 0, last_sample_cycle = -1;
    integer cfo_hz = 0, interference = 0;
    // Time-domain DATA-field dropout, in 40-MS/s converter samples.
    // Separate from residual-byte injection: no assumed byte-error budget.
    integer rf_burst_start=0, rf_burst_samples=0, rf_burst_applied=0;
    integer timeout_ns = 10000000;
    real gain = 0.75;
    real phase = 0.0, angle;
    real ch_i, ch_q;
    real echo_gain = 0.0;
    integer echo_delay = 1, echo_index;
    reg signed [11:0] echo_i [0:31], echo_q [0:31];
    real channel_i, channel_q;
    real antenna_edge_db = 0.0;
    real antenna_i, antenna_q;
    antenna_channel antenna();
    reg signed [11:0] impaired_i = 0, impaired_q = 0;
    reg impaired_valid = 0;
    reg drain_phase = 0;
    integer trace_fd = 0;
    integer adc_overflow_count = 0;
    integer adc_max_abs = 0;
    integer adc_mode = 0; // 0: truncate (legacy), 1: round, 2: fractional diagnostic
    integer adc_wrap = 0; // Explicit diagnostic for the former 12-bit wrap model.
    reg signed [15:0] diagnostic_i = 0, diagnostic_q = 0;
    reg signed [15:0] diagnostic_i_dly = 0, diagnostic_q_dly = 0;
    reg [1023:0] trace_path;

    function signed [11:0] adc_quantize;
        input real sample;
        integer code;
        begin
            code = adc_mode == 1 ? $rtoi(sample + (sample < 0 ? -0.5 : 0.5)) : $rtoi(sample);
            if (!adc_wrap && code > 2047) code = 2047;
            if (!adc_wrap && code < -2048) code = -2048;
            adc_quantize = code;
        end
    endfunction

    ofdm_packet_source #(.P_LENGTH(PAYLOAD_LENGTH), .P_IDLE_CLOCKS(128),
                         .P_REPEAT(PACKETS > 1)) source (
        .iw_clk(clk), .iw_rst(rst), .iw_cmd_ready(cmd_ready),
        .iw_data_ready(s_ready), .iw_done(done),
        .ow_cmd_valid(cmd_valid), .ow_cmd_length(length),
        .ow_cmd_rate(), .ow_cmd_upsample(upsample),
        .ow_data_valid(s_valid), .ow_data_last(s_last), .ow_data(s_data)
    );
    assign rate = RATE_MBPS;
    initial begin
        case (RATE_MBPS)
            6, 9, 12, 18, 24, 36, 48, 54: begin end
            default: $fatal(1, "Unsupported RATE_MBPS=%0d", RATE_MBPS);
        endcase
    end
    tx802p11_ip #(.RS_ENABLE(RS_ENABLE), .RS_INTERLEAVE(RS_INTERLEAVE)) tx (
        .clk(clk), .reset(rst), .cmd_valid(cmd_valid), .cmd_ready(cmd_ready),
        .cmd_length(length), .cmd_rate(rate), .cmd_upsample(upsample),
        .s_valid(s_valid), .s_last(s_last), .s_data(s_data), .s_ready(s_ready),
        .m_valid(tx_valid), .m_re(tx_i), .m_im(tx_q),
        .busy(), .done(done), .error(error)
    );
    ofdm_iq_scale #(.P_RX_SHIFT(RX_SHIFT)) scale (
        .iw_clk(clk), .iw_rst(rst), .iw_tx_valid(tx_valid), .iw_tx_clear(done),
        .iw_tx_i(tx_i), .iw_tx_q(tx_q), .ow_tx_valid(scaled_valid),
        .ow_tx_i(scaled_i), .ow_tx_q(scaled_q),
        .iw_rx_valid(impaired_valid), .iw_rx_i(impaired_i),
        .iw_rx_q(impaired_q), .ow_rx_valid(rx_valid),
        .ow_rx_i(rx_i), .ow_rx_q(rx_q)
    );
    rx802p11_top #(.IDEAL_LOOPBACK(1'b0), .CHANNEL_SMOOTH(CHANNEL_SMOOTH),
                  .RS_ENABLE(RS_ENABLE), .RS_INTERLEAVE(RS_INTERLEAVE)) rx (
        .sclk(clk), .reset(rst), .enable(1'b1),
        .sample_in_i(adc_mode == 2 ? diagnostic_i_dly : rx_i),
        .sample_in_q(adc_mode == 2 ? diagnostic_q_dly : rx_q), .sample_in_valid(rx_valid),
        .short_preamble_detected(),
        .threshold_neg_pos_value(32'd100), .peak_threshold(16'd10000),
        .fcs_data_out_valid(fcs_valid), .fcs_data_out(payload),
        .fcs_ok_strobe(fcs_ok_strobe), .fcs_ok(fcs_ok), .pkt_length(pkt_length),
        .data_csi_i(), .data_csi_q(), .data_csi_valid(),
        .data_chnl_out_i(), .data_chnl_out_q(), .data_chnl_out_valid()
    );

    // Residual-byte fault injection after real Viterbi/descrambler processing.
    // Corrupt first N symbols/lane OR a contiguous wire-order byte burst.
    // Injection is before byte deinterleaving, never bypassing real PHY IP.
    integer rs_byte_index=0;
    reg [7:0] rs_injected_byte;
    generate if(RS_INJECT_ERRORS>0 || RS_BURST_LENGTH>0) begin: g_inject
        initial begin
            if(!RS_ENABLE || (RS_INJECT_ERRORS>0 && RS_BURST_LENGTH>0) ||
               RS_BURST_START<0 || RS_BURST_START+RS_BURST_LENGTH>PSDU_LENGTH)
                $fatal(1,"Invalid RS fault injection configuration");
        end
        always @(posedge clk) if(fcs_ok_strobe && EXPECT_OK) begin
            if(rx.w_rs_corrected != (RS_BURST_LENGTH>0 ? RS_BURST_LENGTH : RS_INJECT_ERRORS*RS_DEPTH))
                $fatal(1,"RS correction count got=%0d",rx.w_rs_corrected);
        end
        always @(negedge clk) begin
            release rx.w_qam64_descramble_dout;
            if(rst || rx.packet_start) rs_byte_index=0;
            else if(rx.w_qam64_descramble_dout_valid) begin
                rs_injected_byte=rx.u_qam64_descramble.qam64_descramble_dout;
                if(RS_BURST_LENGTH>0 ?
                   (rs_byte_index>=RS_BURST_START && rs_byte_index<RS_BURST_START+RS_BURST_LENGTH) :
                   (RS_INTERLEAVE ? rs_byte_index<RS_INJECT_ERRORS*RS_DEPTH : rs_byte_index%255<RS_INJECT_ERRORS))
                    rs_injected_byte=rs_injected_byte^8'ha7;
                force rx.w_qam64_descramble_dout=rs_injected_byte;
                rs_byte_index=rs_byte_index+1;
            end
        end
    end endgenerate

    // Deterministic channel model at 12-bit converter boundary, not RTL.
    // Mode 2 is an isolation experiment, not a realizable 12-bit ADC: retain
    // fractional ADC codes in the four low RX bits, with the same input timing.
    always @(posedge clk) begin
        diagnostic_i_dly <= diagnostic_i;
        diagnostic_q_dly <= diagnostic_q;
    end
    always @(posedge clk) begin
        if (rst) begin
            phase = 0.0;
            antenna.clear;
            impaired_valid <= 0;
            drain_phase <= 0;
            impaired_i <= 0;
            impaired_q <= 0;
            for (echo_index=0; echo_index<32; echo_index=echo_index+1) begin
                echo_i[echo_index] <= 0;
                echo_q[echo_index] <= 0;
            end
        end else begin
            cycle_count <= cycle_count + 1;
            // A valid zero follows done, so also start a new cadence epoch
            // at the next command rather than checking across the idle gap.
            if (done || (cmd_valid && cmd_ready)) last_sample_cycle <= -1;
            if (scaled_valid) drain_phase <= 0;
            else drain_phase <= ~drain_phase;
            // AD9361 RX runs continuously, including before/after the TX frame.
            impaired_valid <= scaled_valid || drain_phase;
            // Delay is in 40-MS/s converter samples (two samples per FFT
            // sample). Include the post-frame echo in the continuous stream.
            if (scaled_valid || drain_phase) begin
                channel_i = (scaled_valid ? $itor(scaled_i) : 0.0) + echo_gain * $itor(echo_i[echo_delay-1]);
                channel_q = (scaled_valid ? $itor(scaled_q) : 0.0) + echo_gain * $itor(echo_q[echo_delay-1]);
                antenna.step(channel_i, channel_q, antenna_i, antenna_q);
                for (echo_index=31; echo_index>0; echo_index=echo_index-1) begin
                    echo_i[echo_index] <= echo_i[echo_index-1];
                    echo_q[echo_index] <= echo_q[echo_index-1];
                end
                echo_i[0] <= scaled_valid ? scaled_i : 12'sd0;
                echo_q[0] <= scaled_valid ? scaled_q : 12'sd0;
            end
            if (scaled_valid) begin
                if (last_sample_cycle >= 0 && cycle_count - last_sample_cycle != 2)
                    $fatal(1, "SAMPLE_CADENCE_FAIL cycle=%0d previous=%0d",
                           cycle_count, last_sample_cycle);
                last_sample_cycle <= cycle_count;
                angle = 6.283185307179586 * cfo_hz / 40000000.0;
                phase = phase + angle;
                if (output_count == 0)
                    $display("RF_CHAIN_GAIN gain=%f first_tx_i=%0d first_tx_q=%0d", gain, scaled_i, scaled_q);
                ch_i = gain * (antenna_i * $cos(phase) - antenna_q * $sin(phase));
                ch_q = gain * (antenna_i * $sin(phase) + antenna_q * $cos(phase));
                diagnostic_i <= $rtoi((ch_i + ((output_count & 1) ? interference : -interference)) * (1 << RX_SHIFT));
                diagnostic_q <= $rtoi((ch_q - ((output_count & 1) ? interference : -interference)) * (1 << RX_SHIFT));
                // Apply the integer interference after quantization to preserve
                // the existing in-range regression stimulus exactly.
                ch_i = (adc_mode == 1 ? $rtoi(ch_i + (ch_i < 0 ? -0.5 : 0.5)) : $rtoi(ch_i)) + ((output_count & 1) ? interference : -interference);
                ch_q = (adc_mode == 1 ? $rtoi(ch_q + (ch_q < 0 ? -0.5 : 0.5)) : $rtoi(ch_q)) - ((output_count & 1) ? interference : -interference);
                if(output_count%(PACKET_SAMPLES+1)>=rf_burst_start &&
                   output_count%(PACKET_SAMPLES+1)<rf_burst_start+rf_burst_samples) begin
                    ch_i=0.0; ch_q=0.0; diagnostic_i<=0; diagnostic_q<=0;
                    rf_burst_applied=rf_burst_applied+1;
                end
                output_count <= output_count + 1;
            end else begin
                if (drain_phase) phase = phase + 6.283185307179586 * cfo_hz / 40000000.0;
                ch_i = gain * (antenna_i * $cos(phase) - antenna_q * $sin(phase));
                ch_q = gain * (antenna_i * $sin(phase) + antenna_q * $cos(phase));
                diagnostic_i <= $rtoi(ch_i * (1 << RX_SHIFT));
                diagnostic_q <= $rtoi(ch_q * (1 << RX_SHIFT));
            end
            impaired_i <= adc_quantize(ch_i);
            impaired_q <= adc_quantize(ch_q);
            if (scaled_valid || drain_phase) begin
                if (ch_i > 2047.0 || ch_i < -2048.0 || ch_q > 2047.0 || ch_q < -2048.0)
                    adc_overflow_count = adc_overflow_count + 1;
                if (ch_i > adc_max_abs) adc_max_abs = $rtoi(ch_i);
                if (-ch_i > adc_max_abs) adc_max_abs = $rtoi(-ch_i);
                if (ch_q > adc_max_abs) adc_max_abs = $rtoi(ch_q);
                if (-ch_q > adc_max_abs) adc_max_abs = $rtoi(-ch_q);
            end
            if (fcs_valid) begin
                if (EXPECT_OK && payload !== ((byte_count[7:0] ^ 8'h5a) + 8'h13))
                    $fatal(1, "PAYLOAD_MISMATCH index=%0d got=%02h adc_overflow=%0d adc_max_abs=%0d",
                           byte_count, payload, adc_overflow_count, adc_max_abs);
                byte_count <= byte_count + 1;
            end
            if (fcs_ok_strobe) begin
                if (fcs_ok !== EXPECT_OK || pkt_length != PAYLOAD_LENGTH || byte_count != PAYLOAD_LENGTH ||
                    // Each frame also sends one valid zero to flush the LVDS
                    // serializer's held sample at TX done.
                    output_count != (PACKET_SAMPLES + 1) * (fcs_count + 1))
                    $fatal(1, "FCS_FAIL ok=%b length=%0d bytes=%0d samples=%0d",
                           fcs_ok, pkt_length, byte_count, output_count);
                fcs_count <= fcs_count + 1;
                byte_count <= 0;
                $display("RF_CHAIN_PACKET_PASS gain=%f rx_shift=%0d packet=%0d cfo=%0d interference=%0d samples=%0d bytes=%0d adc_overflow=%0d adc_max_abs=%0d",
                         gain, RX_SHIFT, fcs_count + 1, cfo_hz, interference, output_count, byte_count,
                         adc_overflow_count, adc_max_abs);
            end
        end
    end
    always @(posedge clk) begin
        if (trace_fd != 0) begin
            if (rx_valid)
                $fdisplay(trace_fd, "rx,%0t,%0d,%0d", $time, $signed(rx_i), $signed(rx_q));
            if (rx.w_correct_coarse_valid)
                $fdisplay(trace_fd, "coarse,%0t,%0d,%0d", $time,
                          $signed(rx.w_correct_coarse_i), $signed(rx.w_correct_coarse_q));
            if (rx.w_fine_cfo_out_valid)
                $fdisplay(trace_fd, "fine,%0t,%0d,%0d", $time,
                          $signed(rx.w_fine_cfo_out_i), $signed(rx.w_fine_cfo_out_q));
            if (rx.u_rx_fine_cfo_correct_use_lt.w_cor_mult_out_valid)
                $fdisplay(trace_fd, "fine_product,%0t,%0d,%0d", $time,
                          $signed(rx.u_rx_fine_cfo_correct_use_lt.w_cor_mult_out[31:0]) >>> 13,
                          $signed(rx.u_rx_fine_cfo_correct_use_lt.w_cor_mult_out[63:32]) >>> 13);
            if (rx.u_rx_timed_to_freqd.w_fft_out_v)
                $fdisplay(trace_fd, "fft_raw,%0t,%0d,%0d,%0d", $time,
                          rx.u_rx_timed_to_freqd.w_xk_index[5:0],
                          $signed(rx.u_rx_timed_to_freqd.w_fft_out[23:0]),
                          $signed(rx.u_rx_timed_to_freqd.w_fft_out[47:24]));
            if (rx.w_fft_out_valid)
                $fdisplay(trace_fd, "fft,%0t,%0d,%0d", $time,
                          $signed(rx.w_fft_out_i), $signed(rx.w_fft_out_q));
            if (rx.w_channel_data_valid)
                $fdisplay(trace_fd, "channel,%0t,%0d,%0d", $time,
                          $signed(rx.w_channel_data_i), $signed(rx.w_channel_data_q));
            if (rx.data_chnl_out_valid)
                $fdisplay(trace_fd, "data,%0t,%0d,%0d,%0d,%0d", $time,
                          $signed(rx.w_data_chnl_i), $signed(rx.w_data_chnl_q),
                          $signed(rx.w_data_csi_i), $signed(rx.w_data_csi_q));
            if (rx.w_bpsk_data_demod_out_valid) begin
                $fdisplay(trace_fd, "bit,%0t,%0d", $time, rx.w_bpsk_data_demod_out[2]);
                $fdisplay(trace_fd, "soft,%0t,%0d", $time, rx.w_bpsk_data_demod_out);
            end
            if (rx.u_bpsk_demodulation.r_csi_valid_dly5)
                $fdisplay(trace_fd, "bpsk_cmp,%0t,%0d,%0d,%0d,%0d,%0d,%0d,%0d",
                          $time,
                          rx.u_bpsk_demodulation.r_channel_sign_dly5,
                          rx.u_bpsk_demodulation.r_channel_abs_dly5,
                          rx.u_bpsk_demodulation.r_one_quarter_amp,
                          rx.u_bpsk_demodulation.r_two_quarters_amp,
                          rx.u_bpsk_demodulation.r_three_quarters_amp,
                          rx.u_bpsk_demodulation.demod_out,
                          rx.u_bpsk_demodulation.r_csi_amp);
            if (rx.u_rx_phase_tracker_correct_use_pilot.w_phase_valid)
                $fdisplay(trace_fd, "phase,%0t,%0d,%0d,%0d,%0d,%0d,%0d",
                          $time,
                          $signed(rx.u_rx_phase_tracker_correct_use_pilot.r_pilot1234[50:0]),
                          $signed(rx.u_rx_phase_tracker_correct_use_pilot.r_pilot1234[101:51]),
                          $signed(rx.u_rx_phase_tracker_correct_use_pilot.w_phase),
                          $signed(rx.u_rx_phase_tracker_correct_use_pilot.r_avg_phase_beta),
                          $signed(rx.u_rx_phase_tracker_correct_use_pilot.r_dds_phase),
                          $signed(rx.u_rx_phase_tracker_correct_use_pilot.r_symbol_slope));
        end
    end
    initial begin
        if ($value$plusargs("GAIN=%f", gain)) begin end
        if ($value$plusargs("TIMEOUT_NS=%d", timeout_ns)) begin end
        if (timeout_ns <= 0) $fatal(1, "TIMEOUT_NS must be positive");
        $display("RF_CHAIN_TIMEOUT_SETTING ns=%0d",timeout_ns);
        if ($value$plusargs("ANTENNA_EDGE_DB=%f", antenna_edge_db)) begin end
        antenna.configure(antenna_edge_db);
        $display("RF_CHAIN_ANTENNA edge_db=%f edge_mhz=8.125 center_gain=%f", antenna_edge_db, gain);
        if ($value$plusargs("ADC_MODE=%d", adc_mode)) begin end
        if ($value$plusargs("ADC_WRAP=%d", adc_wrap)) begin end
        if ($value$plusargs("ECHO_GAIN=%f", echo_gain)) begin end
        if ($value$plusargs("ECHO_DELAY=%d", echo_delay)) begin end
        if (echo_delay<1 || echo_delay>32) $fatal(1, "ECHO_DELAY must be 1..32 converter samples");
        $display("RF_CHAIN_CHANNEL smooth=%0d echo_gain=%f echo_delay=%0d", CHANNEL_SMOOTH, echo_gain, echo_delay);
        $display("RF_CHAIN_ADC_MODE mode=%0d wrap=%0d", adc_mode, adc_wrap);
        if ($test$plusargs("TRACE")) begin
            if ($value$plusargs("TRACE_PATH=%s", trace_path)) trace_fd = $fopen(trace_path, "w");
            else if (gain == 0.75) trace_fd = $fopen("/tmp/rf_gain_075.csv", "w");
            else trace_fd = $fopen("/tmp/rf_gain_100.csv", "w");
        end
        if ($value$plusargs("CFO_HZ=%d", cfo_hz)) begin end
        if ($value$plusargs("INTERFERENCE=%d", interference)) begin end
        if ($value$plusargs("RF_BURST_START=%d", rf_burst_start)) begin end
        if ($value$plusargs("RF_BURST_SAMPLES=%d", rf_burst_samples)) begin end
        if(rf_burst_samples<0 || rf_burst_start<0 || rf_burst_start+rf_burst_samples>PACKET_SAMPLES)
            $fatal(1,"Invalid RF dropout interval");
        repeat (20) @(negedge clk);
        rst = 0;
        #(timeout_ns);
        $fatal(1, "RF_CHAIN_TIMEOUT samples=%0d bytes=%0d FCS=%0d error=%0d",
               output_count, byte_count, fcs_count, error);
    end
    always @(posedge clk) if(!rst && PAYLOAD_LENGTH==1024) begin
        if(done) $display("RF_DIAG_TX_DONE time=%0t",$time);
        if(rx.packet_start) $display("RF_DIAG_SIGNAL time=%0t length=%0d",$time,rx.w_data_field_psdu_byte_length);
        if(fcs_ok_strobe) $display("RF_DIAG_FCS time=%0t ok=%0d",$time,fcs_ok);
    end
endmodule