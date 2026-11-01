`timescale 1ns / 1ps

module ODDR #(
    parameter DDR_CLK_EDGE = "SAME_EDGE", INIT = 0, SRTYPE = "SYNC"
) (
    output reg Q, input C, CE, D1, D2, R, S
);
    reg d2_hold;
    always @(posedge C) if (CE) begin Q <= D1; d2_hold <= D2; end
    always @(negedge C) if (CE) Q <= d2_hold;
endmodule
module OBUFDS #(parameter IOSTANDARD = "DEFAULT", SLEW = "SLOW")
    (output O, OB, input I);
    assign O = I;
    assign OB = ~I;
endmodule

module tb_phy_tx_2t2r;
    reg clk = 0, rst_n = 0, valid = 0, mode = 1;
    reg [11:0] ch1_i = 0, ch1_q = 0, ch2_i = 0, ch2_q = 0;
    wire [5:0] data_p, data_n;
    wire frame_p, frame_n, clk_p, clk_n;
    always #6.25 clk = ~clk;

    ad936x_phy_tx dut (
        .i_rst_n(rst_n), .i_TR_mode(mode), .i_data_clk(clk),
        .i_tx_data_ch1_i(ch1_i), .i_tx_data_ch1_q(ch1_q),
        .i_tx_data_ch2_i(ch2_i), .i_tx_data_ch2_q(ch2_q),
        .i_tx_data_vaild(valid), .o_tx_clk_p(clk_p), .o_tx_clk_n(clk_n),
        .o_tx_data_p(data_p), .o_tx_data_n(data_n),
        .o_tx_frame_p(frame_p), .o_tx_frame_n(frame_n)
    );

    task check_word(input [5:0] i, input [5:0] q, input [1:0] count);
        begin
            @(posedge clk); #1;
            if (dut.r_tx_cnt !== count || dut.r_tx_data_ODDR_pe !== i ||
                dut.r_tx_data_ODDR_ne !== q)
                $fatal(1, "2T2R_FAIL count=%0d got=%h/%h expected=%h/%h",
                       dut.r_tx_cnt, dut.r_tx_data_ODDR_pe,
                       dut.r_tx_data_ODDR_ne, i, q);
        end
    endtask

    initial begin
        repeat (3) @(negedge clk);
        rst_n = 1;
        @(negedge clk);
        ch1_i = 12'h4ac; ch1_q = 12'h936;
        ch2_i = 12'hd21; ch2_q = 12'h6be;
        valid = 1;
        @(posedge clk); #1;
        if (dut.r_tx_cnt !== 2'd1 || dut.r_tx_data_ODDR_pe !== 6'h12 ||
            dut.r_tx_data_ODDR_ne !== 6'h24)
            $fatal(1, "2T2R first half invalid");
        @(negedge clk); valid = 0;
        check_word(6'h2c, 6'h36, 2'd2);
        check_word(6'h34, 6'h1a, 2'd3);
        check_word(6'h21, 6'h3e, 2'd0);

        // Start a second sample, then change live inputs without valid:
        // all four halves must stay frozen from the accepted sample.
        @(negedge clk);
        ch1_i = 12'h789; ch1_q = 12'h456;
        ch2_i = 12'habc; ch2_q = 12'hdef;
        valid = 1;
        @(posedge clk); #1;
        if (dut.r_tx_data_ODDR_pe !== 6'h1e || dut.r_tx_data_ODDR_ne !== 6'h11)
            $fatal(1, "2T2R second first half invalid");
        @(negedge clk); valid = 0;
        ch1_i = 12'hfff; ch1_q = 12'h000;
        ch2_i = 12'h000; ch2_q = 12'hfff;
        check_word(6'h09, 6'h16, 2'd2);
        check_word(6'h2a, 6'h37, 2'd3);
        check_word(6'h3c, 6'h2f, 2'd0);

        @(negedge clk); mode = 0;
        @(posedge clk); #1;
        if (dut.r_tx_cnt !== 0 || dut.r_tx_data_ODDR_pe !== 0 ||
            dut.r_tx_data_ODDR_ne !== 0) $fatal(1, "mode transition not cleared");
        $display("PHY_TX_2T2R_PASS");
        $finish;
    end
endmodule