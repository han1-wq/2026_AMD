`timescale 1ns / 1ps
module tb_fine_cfo_scale;
    reg clk = 0;
    always #5 clk = ~clk;
    reg reset = 1;
    reg [63:0] product = 0;
    wire [15:0] out_i, out_q;
    wire valid;
    wire [15:0] coarse_i, coarse_q;
    wire coarse_valid;
    integer sample;
    rx_fine_cfo_correct_use_lt dut (
        .sclk(clk), .reset(reset), .enable(1'b1),
        .sample_in_i(16'd0), .sample_in_q(16'd0), .sample_in_valid(1'b0),
        .second_peak_delay_8s(1'b0), .align_lt1_in_i(16'd0),
        .align_lt1_in_q(16'd0), .align_lt1_valid(1'b0),
        .fine_cfo_out_i(out_i), .fine_cfo_out_q(out_q), .fine_cfo_out_valid(valid)
    );
    rx_coarse_cfo_use_st coarse (
        .sclk(clk), .reset(reset), .enable(1'b1),
        .sample_in_i(16'd0), .sample_in_q(16'd0), .sample_in_valid(1'b0),
        .accu_avg_in_i(32'd0), .accu_avg_in_q(32'd0), .accu_avg_valid(1'b0),
        .correct_coarse_i(coarse_i), .correct_coarse_q(coarse_q),
        .correct_coarse_valid(coarse_valid)
    );
    task check;
        input [31:0] p_i, p_q;
        input [15:0] expected_i, expected_q;
        begin
            @(negedge clk);
            product = {p_q, p_i};
            @(posedge clk);
            #1;
            if (!valid || out_i !== expected_i || out_q !== expected_q ||
                !coarse_valid || coarse_i !== expected_i || coarse_q !== expected_q)
                $fatal(1, "SCALE_FAIL product=%h got=%h,%h expected=%h,%h",
                       product, out_i, out_q, expected_i, expected_q);
        end
    endtask
    initial begin
        force dut.w_cor_mult_out = product;
        force dut.w_cor_mult_out_valid = 1'b1;
        force coarse.w_mult_out = product;
        force coarse.w_mult_out_valid = 1'b1;
        @(negedge clk);
        reset = 0;
        // Exhaust the representable sample range at zero rotation.
        for (sample = -32768; sample <= 32767; sample = sample + 1)
            check(sample * 16384, sample * 16384, sample[15:0], sample[15:0]);
        check(32'sd607000000, -32'sd607000000, 16'd32767, 16'h8000);
        check(32'h7fffffff, 32'h80000000, 16'h7fff, 16'h8000);
        check(32'sd536854527, -32'sd536870912, 16'h7ffe, 16'h8000);
        check(32'sd536854528, -32'sd536870913, 16'h7fff, 16'h8000);
        check(32'sd100000000, -32'sd100000000, 16'd6103, -16'sd6104);
        $display("FINE_CFO_SCALE_PASS samples=65536 boundaries=5");
        $display("COARSE_CFO_SCALE_PASS samples=65536 boundaries=5");
        $finish;
    end
endmodule