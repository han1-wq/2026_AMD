`timescale 1ns / 1ps

module ofdm_iq_scale #(
    parameter integer P_TX_SHIFT = 4,
    parameter integer P_RX_SHIFT = 4
) (
    input   wire                    iw_clk,
    input   wire                    iw_rst,
    input   wire                    iw_tx_valid,
    input   wire                    iw_tx_clear,
    input   wire signed [15:0]      iw_tx_i,
    input   wire signed [15:0]      iw_tx_q,
    output  reg                     ow_tx_valid,
    output  reg signed [11:0]       ow_tx_i,
    output  reg signed [11:0]       ow_tx_q,
    input   wire                    iw_rx_valid,
    input   wire signed [11:0]      iw_rx_i,
    input   wire signed [11:0]      iw_rx_q,
    output  reg                     ow_rx_valid,
    output  reg signed [15:0]       ow_rx_i,
    output  reg signed [15:0]       ow_rx_q
);
    function [11:0] f_clip12;
        input signed [15:0] value;
        reg signed [15:0] shifted;
        begin
            shifted = value >>> P_TX_SHIFT;
            if (shifted > 16'sd2047)       f_clip12 = 12'h7ff;
            else if (shifted < -16'sd2048) f_clip12 = 12'h800;
            else                            f_clip12 = shifted[11:0];
        end
    endfunction

    always @(posedge iw_clk) begin
        if (iw_rst) begin
            ow_tx_valid <= 1'b0;
            ow_tx_i <= 12'd0;
            ow_tx_q <= 12'd0;
            ow_rx_valid <= 1'b0;
            ow_rx_i <= 16'd0;
            ow_rx_q <= 16'd0;
        end else begin
            // The LVDS serializer holds the last accepted IQ word during gaps.
            // Clear must therefore be a valid zero word, not only a change on
            // the data bus, or the last packet sample is transmitted forever.
            ow_tx_valid <= iw_tx_valid || iw_tx_clear;
            ow_rx_valid <= iw_rx_valid;
            if (iw_tx_valid) begin
                ow_tx_i <= f_clip12(iw_tx_i);
                ow_tx_q <= f_clip12(iw_tx_q);
            end else if (iw_tx_clear) begin
                ow_tx_i <= 12'd0;
                ow_tx_q <= 12'd0;
            end
            if (iw_rx_valid) begin
                ow_rx_i <= $signed(iw_rx_i) <<< P_RX_SHIFT;
                ow_rx_q <= $signed(iw_rx_q) <<< P_RX_SHIFT;
            end
        end
    end
endmodule