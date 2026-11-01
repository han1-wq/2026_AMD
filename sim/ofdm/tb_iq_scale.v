`timescale 1ns / 1ps
module tb_iq_scale;
    reg clk = 0;
    reg rst = 1;
    reg tx_valid = 0;
    reg tx_clear = 0;
    reg signed [15:0] tx_i = 0, tx_q = 0;
    reg rx_valid = 0;
    reg signed [11:0] rx_i = 0, rx_q = 0;
    wire tx_out_valid, rx_out_valid;
    wire signed [11:0] tx_out_i, tx_out_q;
    wire signed [15:0] rx_out_i, rx_out_q;
    always #6.25 clk = ~clk;

    ofdm_iq_scale dut (
        .iw_clk(clk), .iw_rst(rst),
        .iw_tx_valid(tx_valid), .iw_tx_clear(tx_clear),
        .iw_tx_i(tx_i), .iw_tx_q(tx_q),
        .ow_tx_valid(tx_out_valid), .ow_tx_i(tx_out_i), .ow_tx_q(tx_out_q),
        .iw_rx_valid(rx_valid), .iw_rx_i(rx_i), .iw_rx_q(rx_q),
        .ow_rx_valid(rx_out_valid), .ow_rx_i(rx_out_i), .ow_rx_q(rx_out_q)
    );

    initial begin
        repeat (4) @(negedge clk);
        rst = 0;
        tx_valid = 1;
        rx_valid = 1;
        tx_i = 16'sd32767;
        tx_q = -16'sd32768;
        rx_i = -12'sd2048;
        rx_q = 12'sd2047;
        @(negedge clk);
        if (!tx_out_valid || !rx_out_valid || tx_out_i !== 12'sd2047 ||
            tx_out_q !== -12'sd2048 || rx_out_i !== -16'sd32768 ||
            rx_out_q !== 16'sd32752) $fatal(1, "rail conversion failed");
        tx_i = -16'sd17;
        tx_q = 16'sd31;
        rx_i = -12'sd2;
        rx_q = 12'sd1;
        @(negedge clk);
        if (tx_out_i !== -12'sd2 || tx_out_q !== 12'sd1 ||
            rx_out_i !== -16'sd32 || rx_out_q !== 16'sd16)
            $fatal(1, "signed conversion failed");
        tx_valid = 0;
        rx_valid = 0;
        tx_clear = 1;
        @(negedge clk);
        if (!tx_out_valid || rx_out_valid || tx_out_i !== 0 || tx_out_q !== 0)
            $fatal(1, "idle clear failed");
        tx_clear = 0;
        @(negedge clk);
        if (tx_out_valid || tx_out_i !== 0 || tx_out_q !== 0)
            $fatal(1, "clear must produce exactly one valid zero word");
        $display("IQ_SCALE_PASS");
        $finish;
    end
endmodule