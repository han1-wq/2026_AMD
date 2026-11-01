`timescale 1ns / 1ps

module ofdm_packet_source #(
    parameter integer P_LENGTH = 64,
    parameter integer P_IDLE_CLOCKS = 8192,
    parameter integer P_REPEAT = 1
) (
    input   wire            iw_clk,
    input   wire            iw_rst,
    input   wire            iw_cmd_ready,
    input   wire            iw_data_ready,
    input   wire            iw_done,
    output  reg             ow_cmd_valid,
    output  wire [10:0]     ow_cmd_length,
    output  wire [5:0]      ow_cmd_rate,
    output  wire [1:0]      ow_cmd_upsample,
    output  reg             ow_data_valid,
    output  wire            ow_data_last,
    output  wire [7:0]      ow_data
);
    localparam [1:0] LP_WAIT = 0, LP_CMD = 1, LP_DATA = 2, LP_DONE = 3;
    reg [1:0] r_state;
    reg [15:0] r_idle_count;
    reg [10:0] r_byte_index;

    assign ow_cmd_length = P_LENGTH;
    assign ow_cmd_rate = 6'd54; // 64-QAM, rate 3/4
    assign ow_cmd_upsample = 2'd0;
    assign ow_data_last = r_byte_index == P_LENGTH - 1;
    assign ow_data = (r_byte_index[7:0] ^ 8'h5a) + 8'h13;

    always @(*) begin
        ow_cmd_valid = r_state == LP_CMD;
        ow_data_valid = r_state == LP_DATA;
    end

    always @(posedge iw_clk) begin
        if (iw_rst) begin
            r_state <= LP_WAIT;
            r_idle_count <= 0;
            r_byte_index <= 0;
        end else begin
            case (r_state)
                LP_WAIT: if (r_idle_count == P_IDLE_CLOCKS - 1) begin
                    r_idle_count <= 0;
                    r_state <= LP_CMD;
                end else r_idle_count <= r_idle_count + 1'b1;
                LP_CMD: if (iw_cmd_ready) begin
                    r_byte_index <= 0;
                    r_state <= LP_DATA;
                end
                LP_DATA: if (iw_data_ready) begin
                    if (ow_data_last) r_state <= LP_DONE;
                    else r_byte_index <= r_byte_index + 1'b1;
                end
                LP_DONE: if (iw_done && P_REPEAT != 0) r_state <= LP_WAIT;
                default: r_state <= LP_WAIT;
            endcase
        end
    end
endmodule