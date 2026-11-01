`timescale 1ns / 1ps

module ODDR #(
    parameter DDR_CLK_EDGE = "SAME_EDGE", INIT = 0, SRTYPE = "SYNC"
) (
    output reg Q, input C, CE, D1, D2, R, S
);
    reg d2_hold;
    always @(posedge C) if (CE) begin
        Q <= D1;
        d2_hold <= D2;
    end
    always @(negedge C) if (CE) Q <= d2_hold;
endmodule
module OBUFDS #(parameter IOSTANDARD = "DEFAULT", SLEW = "SLOW")
    (output O, OB, input I);
    assign O = I;
    assign OB = ~I;
endmodule

module tb_phy_tx;
    reg clk = 0, rst_n = 0, valid = 0;
    reg [11:0] tx_i = 0, tx_q = 0;
    wire [5:0] data_p, data_n;
    wire frame_p, frame_n, clk_p, clk_n;
    integer cycle = 0;
    always #6.25 clk = ~clk;
    ad936x_phy_tx dut (
        .i_rst_n(rst_n), .i_TR_mode(1'b0), .i_data_clk(clk),
        .i_tx_data_ch1_i(tx_i), .i_tx_data_ch1_q(tx_q),
        .i_tx_data_ch2_i(12'd0), .i_tx_data_ch2_q(12'd0),
        .i_tx_data_vaild(valid),
        .o_tx_clk_p(clk_p), .o_tx_clk_n(clk_n),
        .o_tx_data_p(data_p), .o_tx_data_n(data_n),
        .o_tx_frame_p(frame_p), .o_tx_frame_n(frame_n)
    );
    initial begin
        repeat (4) @(negedge clk);
        rst_n = 1;
        valid = 1;
        tx_i = 12'h4ac;
        tx_q = 12'h936;
        @(negedge clk);
        valid = 0;
        @(posedge clk); #1;
        if (dut.r_tx_frame !== 1 || dut.r_tx_data_ODDR_pe !== 6'h12 ||
            dut.r_tx_data_ODDR_ne !== 6'h24) $fatal(1, "first MSB half invalid");
        @(negedge clk);
        valid = 1;
        tx_i = 12'h32d;
        tx_q = 12'hde0;
        @(posedge clk); #1;
        if (dut.r_tx_frame !== 0 || dut.r_tx_data_ODDR_pe !== 6'h2c ||
            dut.r_tx_data_ODDR_ne !== 6'h36) $fatal(1, "first LSB half invalid");
        @(negedge clk);
        valid = 0;
        @(posedge clk); #1;
        if (dut.r_tx_frame !== 1 || dut.r_tx_data_ODDR_pe !== 6'h0c ||
            dut.r_tx_data_ODDR_ne !== 6'h37) $fatal(1, "second MSB half invalid frame=%b i=%h q=%h cnt=%h hold=%h", dut.r_tx_frame, dut.r_tx_data_ODDR_pe, dut.r_tx_data_ODDR_ne, dut.r_tx_cnt, dut.r_tx_hold_ch1_i);
        @(posedge clk); #1;
        if (dut.r_tx_frame !== 0 || dut.r_tx_data_ODDR_pe !== 6'h2d ||
            dut.r_tx_data_ODDR_ne !== 6'h20) $fatal(1, "second LSB half invalid");
        $display("PHY_TX_PASS");
        $finish;
    end
endmodule