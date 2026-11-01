//`define  TEST_MODE 1
module rx802p11_top #(
    parameter                                       IDEAL_LOOPBACK = 1'b0,
    parameter                                       DEBUG_ILA = 1'b0,
    parameter                                       CHANNEL_SMOOTH = 1'b1,
    parameter                                       RS_ENABLE = 1'b1,
    parameter                                       RS_INTERLEAVE = 1'b1
) (
//threshold for short preamble detect
    input   wire                                        sclk                                        ,
    input   wire                                        reset                                       ,
    input   wire                                        enable                                      ,
    input   wire            [15:0]                      sample_in_i                                 ,
    input   wire            [15:0]                      sample_in_q                                 ,
    input   wire                                        sample_in_valid                             ,
    output  wire                                        short_preamble_detected                     ,
    input   wire            [31:0]                      threshold_neg_pos_value                     ,
    input   wire            [15:0]                      peak_threshold                              ,
    output  wire                                        fcs_data_out_valid                          ,
    output  wire            [7:0]                       fcs_data_out                                ,
    output  wire                                        fcs_ok_strobe                               ,
    output  wire                                        fcs_ok                                      ,
    output  wire            [15:0]                      pkt_length                                  ,
    output  wire                                        packet_start                                ,
    output  wire            [15:0]                      data_csi_i                                  ,
    output  wire            [15:0]                      data_csi_q                                  ,
    output  wire                                        data_csi_valid                              ,
    output  wire            [31:0]                      data_chnl_out_i                             ,
    output  wire            [31:0]                      data_chnl_out_q                             ,
    output  wire                                        data_chnl_out_valid
);

    // Keep the legacy monitor ports at their original fixed-point scale.
    wire [24:0] w_data_csi_i, w_data_csi_q;
    wire [50:0] w_data_chnl_i, w_data_chnl_q;
    assign data_csi_i = $signed(w_data_csi_i) >>> 8;
    assign data_csi_q = $signed(w_data_csi_q) >>> 8;
    assign data_chnl_out_i = $signed(w_data_chnl_i) >>> 16;
    assign data_chnl_out_q = $signed(w_data_chnl_q) >>> 16;

    parameter                                       IDLE = 7'b000_0001;
    parameter                                       DETECT_SHORT = 7'b000_0010;
    parameter                                       DETECT_LONG = 7'b000_0100;
    parameter                                       WAIT_END = 7'b000_1000;

    reg                 [6:0]                       r_state;
    reg                 [4:0]                       r_idle_cnt;

    wire                [31:0]                      w_accu_avg_out_i;
    wire                [31:0]                      w_accu_avg_out_q;
    wire                                            w_accu_avg_out_valid;
    wire                [15:0]                      w_correct_coarse_i;
    wire                [15:0]                      w_correct_coarse_q;
    wire                                            w_correct_coarse_valid;
    wire                [15:0]                      w_correct_coarse_i_unused;
    wire                [15:0]                      w_correct_coarse_q_unused;
    wire                                            w_correct_coarse_valid_unused;

    wire                [15:0]                      w_align_lt1_file_i;
    wire                [15:0]                      w_align_lt1_file_q;
    wire                                            w_align_lt1_valid;
    wire                                            w_detect_long_status;
    wire                                            w_detect_long_status_valid;

    wire                                            w_short_detect_enable;
    wire                                            w_long_detect_enable;
    wire                                            w_first_peak_delay_8s;

    wire                [15:0]                      w_fine_cfo_out_i;
    wire                [15:0]                      w_fine_cfo_out_q;
    wire                                            w_fine_cfo_out_valid;
    wire                [15:0]                      w_fine_cfo_out_i_unused;
    wire                [15:0]                      w_fine_cfo_out_q_unused;
    wire                                            w_fine_cfo_out_valid_unused;

    wire                [22:0]                      w_fft_out_i;
    wire                [22:0]                      w_fft_out_q;
    wire                                            w_fft_out_valid;
    wire                [31:0]                      w_pilot_neg_21;
    wire                [31:0]                      w_pilot_neg_7;
    wire                [31:0]                      w_pilot_pos_7;
    wire                [31:0]                      w_pilot_pos_21;
    wire                                            w_pilot_valid;

    wire                [24:0]                      w_h_csi_out_i;
    wire                [24:0]                      w_h_csi_out_q;
    wire                                            w_h_csi_out_valid;
    wire                [50:0]                      w_channel_data_i;
    wire                [50:0]                      w_channel_data_q;
    wire                                            w_channel_data_valid;

    wire                [24:0]                      w_signal_csi_i;
    wire                [24:0]                      w_signal_csi_q;
    wire                                            w_signal_csi_valid;
    wire                [50:0]                      w_signal_chnl_out_i;
    wire                [50:0]                      w_signal_chnl_out_q;
    wire                                            w_signal_chnl_out_valid;
    // wire [15:0]      data_csi_i;
    // wire [15:0]      data_csi_q;
    // wire             data_csi_valid;
    // wire [31:0]      data_chnl_out_i;
    // wire [31:0]      data_chnl_out_q;
    // wire             data_chnl_out_valid;

    `ifdef TEST_MODE
    wire                [31:0]                      w_test_channel_data_i;
    wire                [31:0]                      w_test_channel_data_q;
    wire                                            w_test_channel_data_valid;
    `endif

    wire                [2:0]                       w_demod_out;
    wire                                            w_demod_out_valid;
    wire                [2:0]                       w_bpsk_deinterleaver_data_out_chnl0;
    wire                [2:0]                       w_bpsk_deinterleaver_data_out_chnl1;
    wire                                            w_bpsk_deinterleaver_data_out_valid;

    // The SIGNAL and 6 Mbps DATA fields are both BPSK, but they are separate
    // OFDM streams.  Keep a second BPSK demod/deinterleaver for DATA so the
    // SIGNAL parser cannot consume the payload symbols.
    wire                [2:0]                       w_bpsk_data_demod_out;
    wire                                            w_bpsk_data_demod_out_valid;
    wire                [2:0]                       w_bpsk_data_deinterleaver_data_out_chnl0;
    wire                [2:0]                       w_bpsk_data_deinterleaver_data_out_chnl1;
    wire                                            w_bpsk_data_deinterleaver_data_out_valid;

    wire                                            w_bpsk_decoder_data_out_valid;
    wire                                            w_bpsk_decoder_data_out;
    wire                                            w_bpsk_data_decoder_data_out_valid;
    wire                                            w_bpsk_data_decoder_data_out;

    wire                                            w_data_field_param_gain_stb;
    wire                                            w_data_field_param_gain_ok;
    assign packet_start = w_data_field_param_gain_stb && w_data_field_param_gain_ok;
    wire                [11:0]                      w_data_field_ofdm_nums;
    wire                [5:0]                       w_data_field_rate;
    wire                [11:0]                      w_data_field_psdu_byte_length;
    wire                [1:0]                       w_data_field_modulation;
    wire                [1:0]                       w_data_field_conv_code_rate;

    wire                                            w_qam64_demod_out_valid;
    wire                [2:0]                       w_qam64_demod_out;

    wire                                            w_qam64_deinterleaver_data_out_valid;
    wire                [2:0]                       w_qam64_deinterleaver_data_out_chnl0;
    wire                [2:0]                       w_qam64_deinterleaver_data_out_chnl1;

    wire                                            w_qam64_depuncture_dout_valid;
    wire                [2:0]                       w_qam64_depuncture_dout_conv_0;
    wire                [2:0]                       w_qam64_depuncture_dout_conv_1;

    wire                                            w_qam64_decoder_data_out_valid;
    wire                                            w_qam64_decoder_data_out;

    wire                                            w_qam64_descramble_dout_valid;
    wire                [7:0]                       w_qam64_descramble_dout;

    // wire             fcs_data_out_valid;
    // wire     [7:0]   fcs_data_out;
    // wire             fcs_ok_strobe;
    // wire             fcs_ok;

    wire                                            w_reset_for_recv_data_finished;

    wire                                            w_qam64_descramble_data_valid;
    wire                                            w_qam64_descramble_data;
    reg                                             r_signal_params_done;

    wire                                            w_bpsk_data_decoder_valid = w_bpsk_data_decoder_data_out_valid && r_signal_params_done;

    assign w_short_detect_enable = (r_state == DETECT_SHORT);
    // Keep the long-training/sample-alignment path alive after a successful
    // long-preamble decision.  The fine-CFO and timed-to-frequency stages consume
    // align_lt1_valid from this block for the remainder of the received frame;
    // disabling it immediately on entry to WAIT_END truncates that stream.
    assign w_long_detect_enable = (r_state == DETECT_LONG) || (r_state == WAIT_END);

    sync_short_packet_detect u_sync_short_packet_detect
    (
        .sclk                                         (sclk),
        .reset                                        (reset | w_reset_for_recv_data_finished),
        .enable                                       (enable & w_short_detect_enable),
        .sample_in_i                                  (sample_in_i),
        .sample_in_q                                  (sample_in_q),
        .sample_in_valid                              (sample_in_valid),
        .short_preamble_detected                      (short_preamble_detected),
        .threshold_neg_pos_value                      (threshold_neg_pos_value),
    //CFO
        .accu_avg_out_i                               (w_accu_avg_out_i),
        .accu_avg_out_q                               (w_accu_avg_out_q),
        .accu_avg_out_valid                           (w_accu_avg_out_valid)
    );
    rx_coarse_cfo_use_st u_rx_coarse_cfo_use_st
    (
        .sclk                                         (sclk),
        .reset                                        (reset | w_reset_for_recv_data_finished),
        .enable                                       (enable),
        .sample_in_i                                  (sample_in_i),
        .sample_in_q                                  (sample_in_q),
        .sample_in_valid                              (sample_in_valid),
        .accu_avg_in_i                                (w_accu_avg_out_i),
        .accu_avg_in_q                                (w_accu_avg_out_q),
        .accu_avg_valid                               (w_accu_avg_out_valid),
        .correct_coarse_i                             (w_correct_coarse_i_unused),
        .correct_coarse_q                             (w_correct_coarse_q_unused),
        .correct_coarse_valid                         (w_correct_coarse_valid_unused)
    );

    // Keep the normal sample-alignment pipeline in the loopback as well.  The
    // coarse-CFO block contains the 256-sample delay used by the downstream long
    // training/SIGNAL timing.  Bypassing it makes rx_timed_to_freqd start its
    // 128-sample counter at the short preamble instead of at the aligned long
    // training stream, so the first FFT is not the SIGNAL symbol.
    assign w_correct_coarse_i = w_correct_coarse_i_unused;
    assign w_correct_coarse_q = w_correct_coarse_q_unused;
    assign w_correct_coarse_valid = w_correct_coarse_valid_unused;
    rx_sync_long_packet_detect u_rx_sync_long_packet_detect
    (
        .sclk                                         (sclk),
        .reset                                        (reset | w_reset_for_recv_data_finished),
        .enable                                       (enable & w_long_detect_enable),
        .peak_threshold                               (peak_threshold),
        .sample_in_i                                  (w_correct_coarse_i),
        .sample_in_q                                  (w_correct_coarse_q),
        .sample_in_valid                              (w_correct_coarse_valid),
        .align_lt1_file_i                             (w_align_lt1_file_i),
        .align_lt1_file_q                             (w_align_lt1_file_q),
        .align_lt1_valid                              (w_align_lt1_valid),
        .detect_long_status                           (w_detect_long_status),
        .detect_long_status_valid                     (w_detect_long_status_valid),
        .second_peak_delay_8s                         (second_peak_delay_8s)
    );

    rx_fine_cfo_correct_use_lt #(
        .IDEAL_LOOPBACK                               (IDEAL_LOOPBACK)
    ) u_rx_fine_cfo_correct_use_lt (
        .sclk                                         (sclk),
        .reset                                        (reset | w_reset_for_recv_data_finished),
        .enable                                       (enable),
        .sample_in_i                                  (w_correct_coarse_i),
        .sample_in_q                                  (w_correct_coarse_q),
        .sample_in_valid                              (w_correct_coarse_valid),
        .second_peak_delay_8s                         (second_peak_delay_8s),
        .align_lt1_in_i                               (w_align_lt1_file_i),
        .align_lt1_in_q                               (w_align_lt1_file_q),
        .align_lt1_valid                              (w_align_lt1_valid),
        .fine_cfo_out_i                               (w_fine_cfo_out_i_unused),
        .fine_cfo_out_q                               (w_fine_cfo_out_q_unused),
        .fine_cfo_out_valid                           (w_fine_cfo_out_valid_unused)
    );

    assign w_fine_cfo_out_i = w_fine_cfo_out_i_unused;
    assign w_fine_cfo_out_q = w_fine_cfo_out_q_unused;
    assign w_fine_cfo_out_valid = w_fine_cfo_out_valid_unused;

    rx_timed_to_freqd u_rx_timed_to_freqd
    (
        .sclk                                         (sclk),
        .reset                                        (reset | w_reset_for_recv_data_finished),
        .enable                                       (enable),
        .sample_in_i                                  (w_fine_cfo_out_i),
        .sample_in_q                                  (w_fine_cfo_out_q),
        .sample_in_valid                              (w_fine_cfo_out_valid),
        .fft_out_i                                    (w_fft_out_i),
        .fft_out_q                                    (w_fft_out_q),
        .fft_out_valid                                (w_fft_out_valid),
        .pilot_neg_21                                 (w_pilot_neg_21),
        .pilot_neg_7                                  (w_pilot_neg_7),
        .pilot_pos_7                                  (w_pilot_pos_7),
        .pilot_pos_21                                 (w_pilot_pos_21),
        .pilot_valid                                  (w_pilot_valid)
    );

    rx_estimate_channel_info #(.CHANNEL_SMOOTH(CHANNEL_SMOOTH)) u_rx_estimate_channel_info (
        .sclk                                         (sclk),
        .reset                                        (reset | w_reset_for_recv_data_finished),
        .enable                                       (enable),
        .sample_in_i                                  (w_fft_out_i),
        .sample_in_q                                  (w_fft_out_q),
        .sample_in_valid                              (w_fft_out_valid),
        .h_csi_out_i                                  (w_h_csi_out_i),
        .h_csi_out_q                                  (w_h_csi_out_q),
        .h_csi_out_valid                              (w_h_csi_out_valid),
        .channel_data_i                               (w_channel_data_i),
        .channel_data_q                               (w_channel_data_q),
        .channel_data_valid                           (w_channel_data_valid)
    );
    `ifdef TEST_MODE
    add_freq_offset_sample_offset u_add_freq_offset_sample_offset
    (
        .sclk                                         (sclk),
        .enable                                       (enable),
        .reset                                        (reset | w_reset_for_recv_data_finished),
        .channel_data_i                               (w_channel_data_i),
        .channel_data_q                               (w_channel_data_q),
        .channel_data_valid                           (w_channel_data_valid),
        .data_chnl_out_i                              (w_test_channel_data_i),
        .data_chnl_out_q                              (w_test_channel_data_q),
        .data_chnl_out_valid                          (w_test_channel_data_valid)
    );

    `endif

    rx_phase_tracker_correct_use_pilot #(.CSI_WIDTH(25), .DATA_WIDTH(51)) u_rx_phase_tracker_correct_use_pilot (
        .sclk                                         (sclk),
        .enable                                       (enable),
        .reset                                        (reset | w_reset_for_recv_data_finished),
        .h_csi_i                                      (w_h_csi_out_i),
        .h_csi_q                                      (w_h_csi_out_q),
        .h_csi_valid                                  (w_h_csi_out_valid),
        `ifdef TEST_MODE
        .channel_data_i                               (w_test_channel_data_i),
        .channel_data_q                               (w_test_channel_data_q),
        .channel_data_valid                           (w_test_channel_data_valid),
        `else
        .channel_data_i                               (w_channel_data_i),
        .channel_data_q                               (w_channel_data_q),
        .channel_data_valid                           (w_channel_data_valid),
        `endif
        .signal_csi_i                                 (w_signal_csi_i),
        .signal_csi_q                                 (w_signal_csi_q),
        .signal_csi_valid                             (w_signal_csi_valid),
        .signal_chnl_out_i                            (w_signal_chnl_out_i),
        .signal_chnl_out_q                            (w_signal_chnl_out_q),
        .signal_chnl_out_valid                        (w_signal_chnl_out_valid),
        .data_csi_i                                   (w_data_csi_i),
        .data_csi_q                                   (w_data_csi_q),
        .data_csi_valid                               (data_csi_valid),
        .data_chnl_out_i                              (w_data_chnl_i),
        .data_chnl_out_q                              (w_data_chnl_q),
        .data_chnl_out_valid                          (data_chnl_out_valid)
    );

    bpsk_demodulation #(.CSI_WIDTH(25), .DATA_WIDTH(51)) u_bpsk_demodulation
    (
        .clk                                          (sclk),
        .rst                                          (reset | short_preamble_detected),
        .csi_i                                        (w_signal_csi_i),
        .csi_q                                        (w_signal_csi_q),
        .csi_valid                                    (w_signal_csi_valid),
        .chnl_data_i                                  (w_signal_chnl_out_i),
        .chnl_data_q                                  (w_signal_chnl_out_q),
        .chnl_data_valid                              (w_signal_chnl_out_valid),
        .demod_out                                    (w_demod_out),
        .demod_out_valid                              (w_demod_out_valid)
    );

    bpsk_deinterleaver u_bpsk_deinterleaver
    (
        .clk                                          (sclk),
        .rst                                          (reset | short_preamble_detected),
        .bpsk_deinterleaver_data_in_valid             (w_demod_out_valid),
        .bpsk_deinterleaver_data_in                   (w_demod_out),
        .bpsk_deinterleaver_data_out_valid            (w_bpsk_deinterleaver_data_out_valid),
        .bpsk_deinterleaver_data_out_chnl0            (w_bpsk_deinterleaver_data_out_chnl0),
        .bpsk_deinterleaver_data_out_chnl1            (w_bpsk_deinterleaver_data_out_chnl1)
    );

    // DATA parameters come from the decoded SIGNAL, not testbench settings.
    wire                [1:0]                       w_data_erasures;
    wire                                            w_data_decoder_ready;
    ofdm_data_frontend #(.CSI_WIDTH(25), .DATA_WIDTH(51)) u_data_frontend (
        .clk                                          (sclk),
        .rst                                          (reset | short_preamble_detected),
        .params_valid                                 (w_data_field_param_gain_stb),
        .params_ok                                    (w_data_field_param_gain_ok),
        .rate                                         (w_data_field_rate),
        .modulation                                   (w_data_field_modulation),
        .code_rate                                    (w_data_field_conv_code_rate),
        .n_symbols                                    (w_data_field_ofdm_nums),
        .csi_i                                        (w_data_csi_i),
        .csi_q                                        (w_data_csi_q),
        .data_i                                       (w_data_chnl_i),
        .data_q                                       (w_data_chnl_q),
        .data_valid                                   (data_chnl_out_valid),
        .demod_bit                                    (w_bpsk_data_demod_out),
        .demod_valid                                  (w_bpsk_data_demod_out_valid),
        .decoded_a                                    (w_bpsk_data_deinterleaver_data_out_chnl0),
        .decoded_b                                    (w_bpsk_data_deinterleaver_data_out_chnl1),
        .erased                                       (w_data_erasures),
        .decoded_valid                                (w_bpsk_data_deinterleaver_data_out_valid),
        .decoded_ready                                (w_data_decoder_ready)
    );

    viterbi_decoders u_viterbi_decoders
    (
        .clk                                          (sclk),
        .rst                                          (reset | short_preamble_detected),
        .bpsk_decoder_data_in_valid                   (w_bpsk_deinterleaver_data_out_valid),
        .bpsk_decoder_data_in_chnl_0                  (w_bpsk_deinterleaver_data_out_chnl0),
        .bpsk_decoder_data_in_chnl_1                  (w_bpsk_deinterleaver_data_out_chnl1),
        .qam64_decoder_data_in_valid                  (1'b0),
        .qam64_decoder_data_in_chnl_0                 (w_qam64_depuncture_dout_conv_0),
        .qam64_decoder_data_in_chnl_1                 (w_qam64_depuncture_dout_conv_1),
        .bpsk_decoder_data_out_valid                  (w_bpsk_decoder_data_out_valid),
        .bpsk_decoder_data_out                        (w_bpsk_decoder_data_out),
        .qam64_decoder_data_out_valid                 (w_qam64_decoder_data_out_valid),
        .qam64_decoder_data_out                       (w_qam64_decoder_data_out),
        .data_field_param_gain_stb                    (w_data_field_param_gain_stb),
        .data_field_param_gain_ok                     (w_data_field_param_gain_ok),
        .data_field_ofdm_nums                         (w_data_field_ofdm_nums),
        .data_field_rate                              (w_data_field_rate),
        .data_field_modulation                        (w_data_field_modulation),
        .data_field_conv_code_rate                    (w_data_field_conv_code_rate),
        .data_erasures                                (2'b00),
        .data_ready                                   ()
    );

    viterbi_decoders #(
        .DATA_STREAM                                  (1)) u_bpsk_data_viterbi_decoders
    (
        .clk                                          (sclk),
        .rst                                          (reset | short_preamble_detected),
        .bpsk_decoder_data_in_valid                   (w_bpsk_data_deinterleaver_data_out_valid),
        .bpsk_decoder_data_in_chnl_0                  (w_bpsk_data_deinterleaver_data_out_chnl0),
        .bpsk_decoder_data_in_chnl_1                  (w_bpsk_data_deinterleaver_data_out_chnl1),
        .qam64_decoder_data_in_valid                  (1'b0),
        .qam64_decoder_data_in_chnl_0                 (w_qam64_depuncture_dout_conv_0),
        .qam64_decoder_data_in_chnl_1                 (w_qam64_depuncture_dout_conv_1),
        .bpsk_decoder_data_out_valid                  (w_bpsk_data_decoder_data_out_valid),
        .bpsk_decoder_data_out                        (w_bpsk_data_decoder_data_out),
        .qam64_decoder_data_out_valid                 (),
        .qam64_decoder_data_out                       (),
        .data_field_param_gain_stb                    (w_data_field_param_gain_stb),
        .data_field_param_gain_ok                     (w_data_field_param_gain_ok),
        .data_field_ofdm_nums                         (w_data_field_ofdm_nums),
        .data_field_rate                              (w_data_field_rate),
        .data_field_modulation                        (w_data_field_modulation),
        .data_field_conv_code_rate                    (w_data_field_conv_code_rate),
        .data_erasures                                (w_data_erasures),
        .data_ready                                   (w_data_decoder_ready)
    );

    bpsk_param_gain #(
        .DEBUG_ILA                                    (DEBUG_ILA)) u_bpsk_param_gain
    (
        .clk                                          (sclk),
        .rst                                          (reset | short_preamble_detected),
        .bpsk_decoded_data_in_valid                   (w_bpsk_decoder_data_out_valid),
        .bpsk_decoded_data_in                         (w_bpsk_decoder_data_out),
        .data_field_param_gain_stb                    (w_data_field_param_gain_stb),
        .data_field_param_gain_ok                     (w_data_field_param_gain_ok),
        .data_field_ofdm_nums                         (w_data_field_ofdm_nums),
        .data_field_rate                              (w_data_field_rate),
        .data_field_psdu_byte_length                  (w_data_field_psdu_byte_length),
        .data_field_modulation                        (w_data_field_modulation),
        .data_field_conv_code_rate                    (w_data_field_conv_code_rate)
    );

    // DATA is a single continuous codeword.  No per-symbol byte rounding.
    assign w_qam64_descramble_data_valid = w_bpsk_data_decoder_data_out_valid && r_signal_params_done;
    assign w_qam64_descramble_data = w_bpsk_data_decoder_data_out;

    always @(posedge sclk) begin
        if (reset == 1'b1 || short_preamble_detected == 1'b1) begin
            r_signal_params_done <= 1'b0;
        end
        else if (w_data_field_param_gain_stb == 1'b1 && w_data_field_param_gain_ok == 1'b1) begin
            r_signal_params_done <= 1'b1;
        end
    end

    qam64_descramble #(
        .DATA_BYTES_PER_OFDM                          (3)
    ) u_qam64_descramble
    (
        .clk                                          (sclk),
        .rst                                          (reset | short_preamble_detected),
        .data_field_param_gain_stb                    (w_data_field_param_gain_stb),
        .data_field_param_gain_ok                     (w_data_field_param_gain_ok),
        .data_field_ofdm_nums                         (w_data_field_ofdm_nums),
        .data_field_psdu_byte_length                  (w_data_field_psdu_byte_length),
        .qam64_descramble_din_valid                   (w_qam64_descramble_data_valid),
        .qam64_descramble_din                         (w_qam64_descramble_data),
        .qam64_descramble_dout_valid                  (w_qam64_descramble_dout_valid),
        .qam64_descramble_dout                        (w_qam64_descramble_dout)
    );

    wire w_fcs_input_valid, w_fcs_start, w_rs_failed, w_fcs_ok;
    wire [7:0] w_fcs_input;
    wire [11:0] w_fcs_length;
    wire [7:0] w_rs_corrected;
    assign fcs_ok = w_fcs_ok && !w_rs_failed;
    generate if (RS_ENABLE) begin: g_rs
        rs_packet_decoder #(.INTERLEAVE(RS_INTERLEAVE)) u_rs (
            .clk(sclk), .reset(reset | short_preamble_detected),
            .s_start(w_data_field_param_gain_stb && w_data_field_param_gain_ok),
            .s_length(w_data_field_psdu_byte_length),
            .s_valid(w_qam64_descramble_dout_valid), .s_data(w_qam64_descramble_dout),
            .m_start(w_fcs_start), .m_valid(w_fcs_input_valid), .m_data(w_fcs_input),
            .m_length(w_fcs_length), .failed(w_rs_failed), .corrected(w_rs_corrected)
        );
    end else begin: g_no_rs
        assign w_fcs_input_valid=w_qam64_descramble_dout_valid;
        assign w_fcs_input=w_qam64_descramble_dout;
        assign w_fcs_start=w_data_field_param_gain_stb && w_data_field_param_gain_ok;
        assign w_fcs_length=w_data_field_psdu_byte_length;
        assign w_rs_failed=0;
        assign w_rs_corrected=0;
    end endgenerate

    fcs_for_data_field u_fcs_for_data_field
    (
        .clk                                          (sclk),
        .rst                                          (reset | short_preamble_detected),
        .fcs_data_in_valid                            (w_fcs_input_valid),
        .fcs_data_in                                  (w_fcs_input),
        .fcs_data_out_valid                           (fcs_data_out_valid),
        .fcs_data_out                                 (fcs_data_out),
        .fcs_ok_strobe                                (fcs_ok_strobe),
        .fcs_ok                                       (w_fcs_ok),
        .data_field_param_gain_stb                    (w_fcs_start),
        .data_field_param_gain_ok                     (1'b1),
        .data_field_psdu_byte_length                  (w_fcs_length),
        .pkt_length                                   (pkt_length)
    );

    recv_data_finished_control u_recv_data_finished_control
    (
        .clk                                          (sclk),
        .rst                                          (reset | short_preamble_detected),
        .data_field_param_gain_stb                    (w_data_field_param_gain_stb),
        .data_field_param_gain_ok                     (w_data_field_param_gain_ok),
        .data_field_ofdm_nums                         (w_data_field_ofdm_nums),
        .data_chnl_out_valid                          (data_chnl_out_valid),
        .detect_long_status                           (w_detect_long_status),
        .reset_for_recv_data_finished                 (w_reset_for_recv_data_finished)
    );

    always @(posedge sclk) begin
        if (reset == 1'b1 || w_reset_for_recv_data_finished == 1'b1) begin
            r_idle_cnt <= 'd0;
        end
        else if (enable == 1'b1 && r_state == IDLE) begin
            r_idle_cnt <= r_idle_cnt + 1'b1;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1 || w_reset_for_recv_data_finished == 1'b1) begin
            r_state <= IDLE;
        end
        else if (enable == 1'b1) begin
            case (r_state)
                IDLE: begin
                    if (r_idle_cnt == 'd16) begin
                        r_state <= DETECT_SHORT;
                    end
                end
                DETECT_SHORT: begin
                    if (w_accu_avg_out_valid == 1'b1) begin
                        r_state <= DETECT_LONG;
                    end
                end
                DETECT_LONG: begin
                    if (w_detect_long_status == 1'b1 && w_detect_long_status_valid == 1'b1) begin
                        r_state <= IDLE;
                    end
                    else if (w_detect_long_status == 1'b0 && w_detect_long_status_valid == 1'b1) begin
                        r_state <= WAIT_END;
                    end
                end
                WAIT_END: begin
                    r_state <= WAIT_END;
                end
                default: r_state <= IDLE;
            endcase
        end
    end

endmodule
