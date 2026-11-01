`timescale 1ns / 1ps

module tx_gen_sig (
    output  wire                            fft_config_valid                                ,
    output  wire                            fft_input_valid                                 ,
    output  wire                            fft_input_last                                  ,
    output  wire    [63:0]                  fft_input_data                                  ,
    input   wire    [79:0]                  fft_output_data                                 ,
    input   wire    [7:0]                   fft_output_index                                ,
    input   wire                            fft_output_valid                                ,
    input   wire                            clk_Modulation                                  ,
    input   wire                            reset                                           ,
    input   wire    [5:0]                   tx_Rate                                         ,  // Rate
    input   wire    [1:0]                   tx_ConvCodeRate                                 ,  // ConvCodeRate
    input   wire    [1:0]                   tx_Modulation                                   ,  // 调制模式
    input   wire                            preamble_ready                                  ,
    input   wire    [15:0]                  packetlength                                    ,
    output  wire                            tx_gen_pkt_sig_valid                            ,
    output  wire                            tx_gen_pkt_sig_out                              ,
    output  wire                            tx_gen_pkt_sig_conv_valid                       ,
    output  wire    [1:0]                   tx_gen_pkt_sig_conv_bit                         ,
    output  wire                            tx_gen_sig_interleaver_valid                    ,
    output  wire                            tx_gen_sig_interleaver_bit                      ,
    output  wire                            tx_gen_sig_add_cyclic_prefix_valid              ,
    output  wire    [15:0]                  tx_gen_sig_add_cyclic_prefix_re                 ,
    output  wire    [15:0]                  tx_gen_sig_add_cyclic_prefix_im
);

    wire                                        w_tx_conv_cnt_valid;
    wire                [15:0]                  w_tx_conv_cnt;
    wire                                        w_tx_gen_sig_modulate_valid;
    wire                [31:0]                  w_tx_gen_sig_modulate_re;
    wire                [31:0]                  w_tx_gen_sig_modulate_im;

    //tx_gen_pkt_sig
    tx_gen_pkt_sig u_tx_gen_pkt_sig
    (
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .tx_Rate                                      (tx_Rate),
        .preamble_ready                               (preamble_ready),
        .packetlength                                 (packetlength),
        .tx_gen_pkt_sig_valid                         (tx_gen_pkt_sig_valid),
        .tx_gen_pkt_sig_out                           (tx_gen_pkt_sig_out)
    );

    //tx_conv_encoder_gen_pkt_sig
    tx_conv_encoder u_tx_conv_encoder_gen_pkt_sig (
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .tx_conv_encoder_valid                        (tx_gen_pkt_sig_valid),
        .tx_conv_encoder_bit                          (tx_gen_pkt_sig_out),
        .tx_conv_valid                                (tx_gen_pkt_sig_conv_valid),
        .tx_conv_bit                                  (tx_gen_pkt_sig_conv_bit)
    );

    //tx_gen_sig_interleaver
    tx_gen_sig_interleaver u_tx_gen_sig_interleaver (
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .tx_gen_sig_interleaver_in_valid              (tx_gen_pkt_sig_conv_valid),
        .tx_gen_sig_interleaver_in_bit                (tx_gen_pkt_sig_conv_bit),
        .tx_gen_sig_interleaver_valid                 (tx_gen_sig_interleaver_valid),
        .tx_gen_sig_interleaver_bit                   (tx_gen_sig_interleaver_bit)
    );

    //tx_gen_sig_modulate
    tx_gen_sig_modulate u_tx_gen_sig_modulate (
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .tx_gen_sig_modulate_in_valid                 (tx_gen_sig_interleaver_valid),
        .tx_gen_sig_modulate_in_bit                   (tx_gen_sig_interleaver_bit),
        .tx_gen_sig_modulate_valid                    (w_tx_gen_sig_modulate_valid),
        .tx_gen_sig_modulate_re                       (w_tx_gen_sig_modulate_re),
        .tx_gen_sig_modulate_im                       (w_tx_gen_sig_modulate_im)
    );

    //tx_freqd_to_timed
    tx_gen_sig_freqd_to_timed u_tx_gen_sig_freqd_to_timed (
        .fft_config_valid                             (fft_config_valid),
        .fft_input_valid                              (fft_input_valid),
        .fft_input_last                               (fft_input_last),
        .fft_input_data                               (fft_input_data),
        .fft_output_data                              (fft_output_data),
        .fft_output_index                             (fft_output_index),
        .fft_output_valid                             (fft_output_valid),
        .clk_Modulation                               (clk_Modulation),
        .reset                                        (reset),
        .tx_freqd_to_timed_valid                      (w_tx_gen_sig_modulate_valid),
        .tx_freqd_to_timed_re                         (w_tx_gen_sig_modulate_re),
        .tx_freqd_to_timed_im                         (w_tx_gen_sig_modulate_im),
        .tx_add_cyclic_prefix_valid                   (tx_gen_sig_add_cyclic_prefix_valid),
        .tx_add_cyclic_prefix_re                      (tx_gen_sig_add_cyclic_prefix_re),
        .tx_add_cyclic_prefix_im                      (tx_gen_sig_add_cyclic_prefix_im)
    );

endmodule
