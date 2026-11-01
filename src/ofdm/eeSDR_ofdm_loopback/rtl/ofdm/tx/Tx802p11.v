`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name: Tx802p11
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//                        Rate             -> 6
//                                         -> 9
//                                         -> 12
//                                         -> 18
//                                         -> 24
//                                         -> 36
//                                         -> 48
//                                         -> 54
//                    ConvCodeRate = 0 -> R1/2
//                                     = 1 -> R2/3
//                                     = 2 -> R3/4
//                    Modulation   = 0 -> BPSK
//                                     = 1 -> QPSK
//                                     = 2 -> 16QAM
//                                     = 3 -> 64QAM
//
//////////////////////////////////////////////////////////////////////////////////

module Tx802p11 #(
    parameter RS_ENABLE = 1'b1,
    parameter RS_INTERLEAVE = 1'b1
) (
    input   wire                            clk_User                                        ,  // 用户数据时钟
    input   wire                            clk_Modulation                                  ,  // TX端调制时钟
    input   wire                            reset                                           ,  // 复位
    input   wire    [1:0]                   tx_Upsample                                     ,  // 上采样率
    input   wire    [5:0]                   tx_Rate                                         ,  // Rate
    input   wire    [1:0]                   tx_ConvCodeRate                                 ,  // ConvCodeRate
    input   wire    [1:0]                   tx_Modulation                                   ,  // 调制模式
    input   wire                            user_tx_data_start                              ,  // 用户数据启动标志
    input   wire                            user_tx_data_end                                ,  // 用户数据结束标志
    input   wire    [15:0]                  packetlength                                    ,  // 用户数据长度（存在上限）
    input   wire                            user_tx_data_valid                              ,  // 用户数据有效
    input   wire    [7:0]                   user_tx_data                                    ,  // 用户数据
    output  wire                            tx_802p11_out_valid                             ,  // 802p11调制数据有效
    output  wire    [15:0]                  tx_802p11_re_out                                ,  // 802p11 re调制数据
    output  wire    [15:0]                  tx_802p11_im_out                                ,  // 802p11 im调制数据
    output  wire                            tx_generate_data_valid                          ,
    output  wire                            tx_generate_data_bit                            ,
    output  wire                            scramble_lc_bit_valid                           ,
    output  wire                            scramble_lc_bit                                 ,
    output  wire                            tx_conv_encoder_valid                           ,
    output  wire    [1:0]                   tx_conv_encoder_bit                             ,
    output  wire                            tx_puncture_valid                               ,
    output  wire                            tx_puncture_bit                                 ,
    output  wire                            tx_interleaver_intlvr_patt_valid                ,
    output  wire    [15:0]                  tx_interleaver_intlvr_patt                      ,
    output  wire                            tx_interleaver_bit_valid                        ,
    output  wire                            tx_interleaver_bit                              ,
    output  wire                            tx_add_cyclic_prefix_valid                      ,
    output  wire    [15:0]                  tx_add_cyclic_prefix_re                         ,
    output  wire    [15:0]                  tx_add_cyclic_prefix_im                         ,
    output  wire                            tx_gen_pkt_sig_valid                            ,
    output  wire                            tx_gen_pkt_sig_out                              ,
    output  wire                            tx_gen_pkt_sig_conv_valid                       ,
    output  wire    [1:0]                   tx_gen_pkt_sig_conv_bit                         ,
    output  wire                            tx_gen_sig_interleaver_valid                    ,
    output  wire                            tx_gen_sig_interleaver_bit                      ,
    output  wire                            tx_gen_sig_add_cyclic_prefix_valid              ,
    output  wire    [15:0]                  tx_gen_sig_add_cyclic_prefix_re                 ,
    output  wire    [15:0]                  tx_gen_sig_add_cyclic_prefix_im                 ,
    output  wire                            tx_done
);

    wire                                        w_crc_data_valid;
    wire                [7:0]                   w_crc_data;
    wire w_phy_data_valid, w_phy_start;
    wire [7:0] w_phy_data;
    wire [15:0] w_phy_length;
    generate if (RS_ENABLE) begin: g_rs
        wire [11:0] encoded_length;
        rs_packet_encoder #(.INTERLEAVE(RS_INTERLEAVE)) u_rs (
            .clk(clk_Modulation), .reset(reset), .s_start(user_tx_data_start),
            .s_length(packetlength[10:0]+11'd4),
            .s_valid(w_crc_data_valid), .s_data(w_crc_data),
            .m_valid(w_phy_data_valid), .m_start(w_phy_start),
            .m_data(w_phy_data), .m_length(encoded_length)
        );
        // Legacy PHY helpers add four to their length argument. The CRC is
        // already inside the RS codewords; pass encoded PSDU length minus four.
        assign w_phy_length = {4'd0,encoded_length}-16'd4;
    end else begin: g_no_rs
        assign w_phy_data_valid=w_crc_data_valid;
        assign w_phy_data=w_crc_data;
        assign w_phy_start=user_tx_data_start;
        assign w_phy_length=packetlength;
    end endgenerate
    wire                                        w_tx_puncture_bit_cnt_valid;
    wire                [15:0]                  w_tx_puncture_bit_cnt;
    wire                                        w_tx_puncture_last;
    wire                                        w_tx_interleaver_last;
    wire                                        w_data_start_allowed;
    wire                                        w_punc_valid_stream;
    wire                                        w_intl_valid_stream;
    wire                                        w_punc_ready;
    wire                                        w_intl_ready;
    wire                [15:0]                  w_frame_symbols;
    wire                                        w_sig_fft_config;
    wire                                        w_sig_fft_valid;
    wire                                        w_sig_fft_last;
    wire                                        w_data_fft_config;
    wire                                        w_data_fft_valid;
    wire                                        w_data_fft_last;
    wire                [63:0]                  w_sig_fft_data;
    wire                [63:0]                  w_data_fft_data;
    wire                [79:0]                  w_fft_result;
    wire                [7:0]                   w_fft_index;
    wire                                        w_fft_valid;
    wire                                        w_fft_last;
    wire                                        w_fft_input_ready;
    wire                                        w_fft_config_ready;
    wire                [64:0]                  w_fft_queued;
    wire                                        w_fft_queued_valid;
    reg                                         r_fft_configured;
    always @(posedge clk_Modulation) begin
        if (reset) r_fft_configured <= 0;
        else if (w_fft_config_ready) r_fft_configured <= 1;
    end
    // All transforms use the same inverse/unscaled configuration. Keep CONFIG
    // valid until accepted; data tokens remain stable across IFFT backpressure.
    tx_fft_input_queue u_fft_input_queue (
        .clk                                          (clk_Modulation),
        .reset                                        (reset),
        .push                                         (w_sig_fft_valid || w_data_fft_valid),
        .din                                          (w_data_fft_valid ? {w_data_fft_last, w_data_fft_data} : {w_sig_fft_last, w_sig_fft_data}),
        .ready                                        (w_fft_input_ready && r_fft_configured),
        .valid                                        (w_fft_queued_valid),
        .dout                                         (w_fft_queued)
    );
    reg                                         r_fft_owner_data;
    reg                                         r_fft_busy;
    // SIGNAL capture completes before the DATA mapper is granted access. Keep
    // ownership through the entire transform, including gaps in output valid.
    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_fft_owner_data <= 0;
            r_fft_busy <= 0;
        end
        else begin
            if (w_fft_valid && w_fft_last) r_fft_busy <= 0;
            if (w_sig_fft_config || w_data_fft_config) begin
                r_fft_owner_data <= w_data_fft_config;
                r_fft_busy <= 1;
            end
        end
    end
    xfft_tx_freqd_to_timed u_shared_ifft (
        .aclk                                         (clk_Modulation),
        .aresetn                                      (!reset),
        .s_axis_config_tdata                          (8'd0),
        .s_axis_config_tvalid                         (!reset && !r_fft_configured),
        .s_axis_config_tready                         (w_fft_config_ready),
        .s_axis_data_tdata                            (w_fft_queued[63:0]),
        .s_axis_data_tvalid                           (w_fft_queued_valid && r_fft_configured),
        .s_axis_data_tready                           (w_fft_input_ready),
        .s_axis_data_tlast                            (w_fft_queued[64]),
        .m_axis_data_tdata                            (w_fft_result),
        .m_axis_data_tuser                            (w_fft_index),
        .m_axis_data_tvalid                           (w_fft_valid),
        .m_axis_data_tready                           (1'b1),
        .m_axis_data_tlast                            (w_fft_last),
        .event_frame_started                          (),
        .event_tlast_unexpected                       (),
        .event_tlast_missing                          (),
        .event_status_channel_halt                    (),
        .event_data_in_channel_halt                   (),
        .event_data_out_channel_halt                  ()
    );
    // synthesis translate_off
    always @(posedge clk_Modulation) if (!reset) begin
        if ((w_sig_fft_config && w_data_fft_config) || (w_sig_fft_valid && w_data_fft_valid))
            $fatal(1, "Shared IFFT input collision");
    end
    // synthesis translate_on
    reg                                         r_conv_valid_d;
    always @(posedge clk_Modulation) begin
        if (reset) r_conv_valid_d <= 0;
        else r_conv_valid_d <= tx_conv_encoder_valid;
    end
    // Boundary adapter: upstream remains a contiguous, unstallable frame.
    wire                                        w_conv_end = r_conv_valid_d && !tx_conv_encoder_valid;
    // Public debug valid means ACCEPTED transfer, not a held stream beat.
    assign tx_puncture_valid = w_punc_valid_stream && w_punc_ready;
    assign tx_interleaver_bit_valid = w_intl_valid_stream && w_intl_ready;
    wire                [15:0]                  w_n_ofdm_syms;
    wire                                        w_tx_freq_to_timed_cycle_flag;
    wire                                        w_tx_modulate_out_valid;
    wire                [31:0]                  w_tx_modulate_re_out;
    wire                [31:0]                  w_tx_modulate_im_out;
    wire                                        w_preamble_ready;
    wire                                        w_tx_add_cyclic_prefix_end;
    //统计
    reg                 [15:0]                  r_tx_sof_cnt;
    reg                 [15:0]                  r_tx_eof_cnt;
    //调制模式锁存
    reg                 [5:0]                   r_tx_rate_reg;
    reg                 [1:0]                   r_tx_conv_code_rate_reg;
    reg                 [1:0]                   r_tx_modulation_reg;

    //调制模式锁存
    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_tx_rate_reg <= 6'd6;
            r_tx_conv_code_rate_reg <= 2'd0;
            r_tx_modulation_reg <= 2'd0;
        end
        else if (user_tx_data_start) begin
            r_tx_rate_reg <= tx_Rate;
            r_tx_conv_code_rate_reg <= tx_ConvCodeRate;
            r_tx_modulation_reg <= tx_Modulation;
        end
        else begin
            r_tx_rate_reg <= r_tx_rate_reg;
            r_tx_conv_code_rate_reg <= r_tx_conv_code_rate_reg;
            r_tx_modulation_reg <= r_tx_modulation_reg;
        end
    end

    //统计SOF
    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_tx_sof_cnt <= 0;
        end
        else if (user_tx_data_end) begin
            r_tx_sof_cnt <= r_tx_sof_cnt + 1;
        end
        else begin
            r_tx_sof_cnt <= r_tx_sof_cnt;
        end
    end

    //统计EOF
    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_tx_eof_cnt <= 0;
        end
        else if (w_tx_add_cyclic_prefix_end) begin
            r_tx_eof_cnt <= r_tx_eof_cnt + 1;
        end
        else begin
            r_tx_eof_cnt <= r_tx_eof_cnt;
        end
    end

    //crc32
    crc32 u_crc32 (
        .clk_User                                     (clk_Modulation),
        .reset                                        (reset),
        .crc_en                                       (user_tx_data_valid),
        .data_in                                      (user_tx_data),
        .crc_data_valid                               (w_crc_data_valid),
        .crc_data                                     (w_crc_data)
    );

    //tx_generate_data
    tx_generate_data u_tx_generate_data (
        .frame_symbols                                (w_frame_symbols),
        .clk_User                                     (clk_Modulation),
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .tx_Rate                                      (r_tx_rate_reg),
        .send_data_valid                              (w_phy_data_valid),
        .send_data                                    (w_phy_data),
        .packetlength                                 (w_phy_length),
        .data_bit_valid                               (tx_generate_data_valid),
        .data_bit                                     (tx_generate_data_bit)
    );

    //scramble_lc
    scramble_lc u_scramble_lc (
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .packetlength                                 (w_phy_length),
        .data_bit_valid                               (tx_generate_data_valid),
        .data_bit                                     (tx_generate_data_bit),
        .scramble_bit_valid                           (scramble_lc_bit_valid),
        .scramble_bit                                 (scramble_lc_bit)
    );

    //tx_conv_encoder
    tx_conv_encoder u_tx_conv_encoder (
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .tx_conv_encoder_valid                        (scramble_lc_bit_valid),
        .tx_conv_encoder_bit                          (scramble_lc_bit),
        .tx_conv_valid                                (tx_conv_encoder_valid),
        .tx_conv_bit                                  (tx_conv_encoder_bit)
    );

    //tx_puncture
    tx_puncture u_tx_puncture (
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .tx_ConvCodeRate                              (r_tx_conv_code_rate_reg),
        .tx_conv_valid                                (tx_conv_encoder_valid),
        .tx_conv_bit                                  (tx_conv_encoder_bit),
        .tx_puncture_valid                            (w_punc_valid_stream),
        .tx_puncture_bit                              (tx_puncture_bit),
        .tx_puncture_bit_cnt_valid                    (w_tx_puncture_bit_cnt_valid),
        .tx_puncture_bit_cnt                          (w_tx_puncture_bit_cnt),
        .out_ready                                    (w_punc_ready),
        .in_end                                       (w_conv_end),
        .out_last                                     (w_tx_puncture_last)
    );

    //tx_interleaver
    tx_interleaver u_tx_interleaver (
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .tx_Modulation                                (r_tx_modulation_reg),
        .tx_interleaver_in_valid                      (w_punc_valid_stream),
        .tx_interleaver_in_bit                        (tx_puncture_bit),
        .in_last                                      (w_tx_puncture_last),
        .in_ready                                     (w_punc_ready),
        .out_ready                                    (w_intl_ready),
        .out_last                                     (w_tx_interleaver_last),
        .tx_puncture_bit_cnt_valid                    (w_tx_puncture_bit_cnt_valid),
        .tx_puncture_bit_cnt                          (w_tx_puncture_bit_cnt),
        .intlvr_patt_valid                            (tx_interleaver_intlvr_patt_valid),
        .intlvr_patt                                  (tx_interleaver_intlvr_patt),
        .interleaved_bit_valid                        (w_intl_valid_stream),
        .interleaved_bit                              (tx_interleaver_bit)
    );

    //tx_modulate
    tx_modulate u_tx_modulate0 (
        .tx_Upsample                                  (tx_Upsample),
        .data_start_allowed                           (w_data_start_allowed),
        .in_ready                                     (w_intl_ready),
        .frame_symbols                                (w_frame_symbols),
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .tx_Rate                                      (r_tx_rate_reg),
        .tx_Modulation                                (r_tx_modulation_reg),
        .tx_modulate_in_valid                         (w_intl_valid_stream),
        .tx_modulate_in_bit                           (tx_interleaver_bit),
        .tx_modulate_in_last                          (w_tx_interleaver_last),
        .tx_freq_to_timed_cycle_flag                  (w_tx_add_cyclic_prefix_end),
        .n_ofdm_syms                                  (w_n_ofdm_syms),
        .tx_modulate_out_valid                        (w_tx_modulate_out_valid),
        .tx_modulate_re_out                           (w_tx_modulate_re_out),
        .tx_modulate_im_out                           (w_tx_modulate_im_out)
    );

    //tx_freqd_to_timed
    tx_freqd_to_timed u_tx_freqd_to_timed0 (
        .fft_config_valid                             (w_data_fft_config),
        .fft_input_valid                              (w_data_fft_valid),
        .fft_input_last                               (w_data_fft_last),
        .fft_input_data                               (w_data_fft_data),
        .fft_output_data                              (w_fft_result),
        .fft_output_index                             (w_fft_index),
        .fft_output_valid                             (w_fft_valid && r_fft_owner_data),
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .n_ofdm_syms                                  (w_n_ofdm_syms),
        .tx_freqd_to_timed_valid                      (w_tx_modulate_out_valid),
        .tx_freqd_to_timed_re                         (w_tx_modulate_re_out),
        .tx_freqd_to_timed_im                         (w_tx_modulate_im_out),
        .tx_freq_to_timed_cycle_flag                  (w_tx_freq_to_timed_cycle_flag),
        .tx_add_cyclic_prefix_valid                   (tx_add_cyclic_prefix_valid),
        .tx_add_cyclic_prefix_end                     (w_tx_add_cyclic_prefix_end),
        .tx_add_cyclic_prefix_re                      (tx_add_cyclic_prefix_re),
        .tx_add_cyclic_prefix_im                      (tx_add_cyclic_prefix_im)
    );

    //tx_gen_sig
    tx_gen_sig u_tx_gen_sig (
        .fft_config_valid                             (w_sig_fft_config),
        .fft_input_valid                              (w_sig_fft_valid),
        .fft_input_last                               (w_sig_fft_last),
        .fft_input_data                               (w_sig_fft_data),
        .fft_output_data                              (w_fft_result),
        .fft_output_index                             (w_fft_index),
        .fft_output_valid                             (w_fft_valid && !r_fft_owner_data),
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .tx_Rate                                      (r_tx_rate_reg),
        .tx_ConvCodeRate                              (r_tx_conv_code_rate_reg),
        .tx_Modulation                                (r_tx_modulation_reg),
        .preamble_ready                               (w_preamble_ready),
        .packetlength                                 (w_phy_length),
        .tx_gen_pkt_sig_valid                         (tx_gen_pkt_sig_valid),
        .tx_gen_pkt_sig_out                           (tx_gen_pkt_sig_out),
        .tx_gen_pkt_sig_conv_valid                    (tx_gen_pkt_sig_conv_valid),
        .tx_gen_pkt_sig_conv_bit                      (tx_gen_pkt_sig_conv_bit),
        .tx_gen_sig_interleaver_valid                 (tx_gen_sig_interleaver_valid),
        .tx_gen_sig_interleaver_bit                   (tx_gen_sig_interleaver_bit),
        .tx_gen_sig_add_cyclic_prefix_valid           (tx_gen_sig_add_cyclic_prefix_valid),
        .tx_gen_sig_add_cyclic_prefix_re              (tx_gen_sig_add_cyclic_prefix_re),
        .tx_gen_sig_add_cyclic_prefix_im              (tx_gen_sig_add_cyclic_prefix_im)
    );

    // Register SIGNAL data and valid together before the capture mux. This
    // separates the CP FIFO's BRAM read/mux from the sample queue's write path.
    // DATA admission still waits for SIGNAL capture, now one clock later.
    reg                 [15:0]                  r_signal_capture_re;
    reg                 [15:0]                  r_signal_capture_im;
    reg                                         r_signal_capture_valid;
    always @(posedge clk_Modulation) begin
        r_signal_capture_re <= tx_gen_sig_add_cyclic_prefix_re;
        r_signal_capture_im <= tx_gen_sig_add_cyclic_prefix_im;
        if (reset || w_phy_start) r_signal_capture_valid <= 1'b0;
        else r_signal_capture_valid <= tx_gen_sig_add_cyclic_prefix_valid;
    end

    //tx_out_arrange
    tx_out_arrange u_tx_out_arrange (
        .frame_done                                   (tx_done),
        .data_start_allowed                           (w_data_start_allowed),
        .clk_Modulation                               (clk_Modulation),  //TX端调制时钟
        .reset                                        (reset),  //复位
        .tx_Upsample                                  (tx_Upsample),
        .user_tx_data_start                           (w_phy_start),
        .tx_add_cyclic_prefix_valid                   (tx_add_cyclic_prefix_valid),
        .tx_add_cyclic_prefix_end                     (w_tx_add_cyclic_prefix_end),
        .tx_add_cyclic_prefix_re                      (tx_add_cyclic_prefix_re),
        .tx_add_cyclic_prefix_im                      (tx_add_cyclic_prefix_im),
        .tx_gen_sig_add_cyclic_prefix_valid           (r_signal_capture_valid),
        .tx_gen_sig_add_cyclic_prefix_re              (r_signal_capture_re),
        .tx_gen_sig_add_cyclic_prefix_im              (r_signal_capture_im),
        .preamble_ready                               (w_preamble_ready),
        .tx_802p11_out_valid                          (tx_802p11_out_valid),
        .tx_802p11_re_out                             (tx_802p11_re_out),
        .tx_802p11_im_out                             (tx_802p11_im_out)
    );

endmodule

// Registered synchronous-RAM queue. One output skid register allows a new
// BRAM read on every accepted beat, with no combinational RAM data path.
module tx_fft_input_queue (
    input   wire                            clk                                             ,
    input   wire                            reset                                           ,  // 复位
    input   wire                            push                                            ,
    input   wire                            ready                                           ,
    input   wire    [64:0]                  din                                             ,
    output  reg                             valid                                           ,
    output  reg     [64:0]                  dout
);
    (* ram_style = "block" *) reg [64:0] r_mem[0:255];
    reg                 [8:0]                   r_wr_ptr;
    reg                 [8:0]                   r_rd_ptr;
    wire                                        w_empty = r_wr_ptr == r_rd_ptr;
    wire                                        w_fetch = (!valid || ready) && !w_empty;
    always @(posedge clk) begin
        if (!reset && push) r_mem[r_wr_ptr[7:0]] <= din;
        if (w_fetch) dout <= r_mem[r_rd_ptr[7:0]];
        if (reset) begin
            r_wr_ptr <= 0;
            r_rd_ptr <= 0;
            valid <= 0;
        end
        else begin
            if (push) r_wr_ptr <= r_wr_ptr + 1'b1;
            if (w_fetch) begin
                r_rd_ptr <= r_rd_ptr + 1'b1;
                valid <= 1;
            end
            else if (ready) valid <= 0;
        end
    end
    // synthesis translate_off
    always @(posedge clk) if (!reset && push &&
            r_wr_ptr[8] != r_rd_ptr[8] && r_wr_ptr[7:0] == r_rd_ptr[7:0])
    $fatal(1, "TX IFFT ingress overflow");
// synthesis translate_on
endmodule
