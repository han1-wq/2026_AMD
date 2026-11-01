`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/01/27 20:15:23
// Design Name: 
// Module Name: ad936x_phy_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: ad936x_lvds_TOP
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ad936x_phy_TOP(
//system signal
    input                       rst_n,
    input                       TR_mode,
//rx input
    input    wire               data_clk_p,
    input    wire               data_clk_n,
    input    wire    [5:0]      rx_data_p,
    input    wire    [5:0]      rx_data_n,
    input    wire               rx_frame_p,
    input    wire               rx_frame_n,
//rx output
    output   wire               data_clk,
    output   wire               rx_frame,
    output   wire    [11:0]     rx_data_ch1_i,
    output   wire    [11:0]     rx_data_ch1_q,
    output   wire    [11:0]     rx_data_ch2_i,
    output   wire    [11:0]     rx_data_ch2_q,
    output   wire               rx_data_ch1_vaild,
    output   wire               rx_data_ch2_vaild,
//tx input
    input    wire    [11:0]     tx_data_ch1_i,
    input    wire    [11:0]     tx_data_ch1_q,
    input    wire    [11:0]     tx_data_ch2_i,
    input    wire    [11:0]     tx_data_ch2_q,
    input    wire               tx_data_vaild,
//tx output
    output   wire               fb_clk_p,
    output   wire               fb_clk_n,
    output   wire    [5:0]      tx_data_p,
    output   wire    [5:0]      tx_data_n,
    output   wire               tx_frame_p,
    output   wire               tx_frame_n
);


ad936x_phy_rx u_ad936x_phy_rx(
    .i_rst_n                    (rst_n),
    .i_TR_mode                  (TR_mode),
    .i_rx_clk_p                 (data_clk_p),
    .i_rx_clk_n                 (data_clk_n),
    .i_rx_data_p                (rx_data_p),
    .i_rx_data_n                (rx_data_n),
    .i_rx_frame_p               (rx_frame_p),
    .i_rx_frame_n               (rx_frame_n),
    .o_data_clk                 (data_clk),
    .o_rx_fream                 (rx_frame),
    .o_rx_data_ch1_i            (rx_data_ch1_i),
    .o_rx_data_ch1_q            (rx_data_ch1_q),
    .o_rx_data_ch2_i            (rx_data_ch2_i),
    .o_rx_data_ch2_q            (rx_data_ch2_q),
    .o_rx_data_ch1_vaild        (rx_data_ch1_vaild),
    .o_rx_data_ch2_vaild        (rx_data_ch2_vaild)
);

ad936x_phy_tx u_ad936x_phy_tx(
    .i_rst_n                    (rst_n),
    .i_TR_mode                  (TR_mode),
    .i_data_clk                 (data_clk),
    .i_tx_data_ch1_i            (tx_data_ch1_i),
    .i_tx_data_ch1_q            (tx_data_ch1_q),
    .i_tx_data_ch2_i            (tx_data_ch2_i),
    .i_tx_data_ch2_q            (tx_data_ch2_q),
    .i_tx_data_vaild            (tx_data_vaild),
    .o_tx_clk_p                 (fb_clk_p),
    .o_tx_clk_n                 (fb_clk_n),
    .o_tx_data_p                (tx_data_p),
    .o_tx_data_n                (tx_data_n),
    .o_tx_frame_p               (tx_frame_p),
    .o_tx_frame_n               (tx_frame_n)
);
endmodule