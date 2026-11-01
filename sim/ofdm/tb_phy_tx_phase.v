`timescale 1ns / 1ps

// Check complete LVDS words, with valid on either serializer phase.
// Use the Xilinx ODDR model (or the SAME_EDGE model in tb_phy_tx.v).
module tb_phy_tx_phase;
    reg clk = 0, rst_n = 0, valid = 0;
    reg [11:0] tx_i = 0, tx_q = 0;
    wire [5:0] data_p, data_n;
    wire frame_p, frame_n, clk_p, clk_n;
    reg [5:0] high_i, high_q, low_i;
    reg [11:0] expected_i [0:31], expected_q [0:31];
    integer sent = 0, received = 0, phase = 0, k;
    reg have_high = 0;
    always #6.25 clk = ~clk;
    ad936x_phy_tx dut (
        .i_rst_n(rst_n), .i_TR_mode(1'b0), .i_data_clk(clk),
        .i_tx_data_ch1_i(tx_i), .i_tx_data_ch1_q(tx_q),
        .i_tx_data_ch2_i(12'd0), .i_tx_data_ch2_q(12'd0),
        .i_tx_data_vaild(valid), .o_tx_clk_p(clk_p), .o_tx_clk_n(clk_n),
        .o_tx_data_p(data_p), .o_tx_data_n(data_n),
        .o_tx_frame_p(frame_p), .o_tx_frame_n(frame_n)
    );
    always @(posedge clk) begin
        #1;
        if (frame_p) high_i = data_p;
        else low_i = data_p;
    end
    always @(negedge clk) begin
        #1;
        if (!rst_n) have_high = 0;
        else if (frame_p) begin
            high_q = data_p;
            have_high = 1;
        end else if (have_high) begin
            // Ignore idle zero and repetitions after the final word.
            if (received < sent && ({high_i,low_i} != 0 || {high_q,data_p} != 0)) begin
                if ({high_i,low_i} !== expected_i[received] ||
                    {high_q,data_p} !== expected_q[received])
                    $fatal(1, "PHY_WORD_FAIL phase=%0d index=%0d got=%03h,%03h expected=%03h,%03h",
                           phase, received, {high_i,low_i}, {high_q,data_p},
                           expected_i[received], expected_q[received]);
                received = received + 1;
            end
            have_high = 0;
        end
    end
    initial begin
        if ($value$plusargs("PHASE=%d", phase)) begin end
        // Allow the vendor glbl power-on reset to expire.
        repeat (20) @(negedge clk);
        #2; rst_n = 1;
        repeat (phase) @(negedge clk);
        for (k = 0; k < 24; k = k + 1) begin
            #2;
            tx_i = 12'h123 + k * 12'h137;
            tx_q = 12'he97 - k * 12'h153;
            expected_i[sent] = tx_i;
            expected_q[sent] = tx_q;
            sent = sent + 1;
            valid = 1;
            @(negedge clk); #2; valid = 0;
            @(negedge clk);
        end
        repeat (8) @(negedge clk);
        if (received != sent) $fatal(1, "PHY_WORD_COUNT received=%0d sent=%0d", received, sent);
        $display("PHY_PHASE_PASS phase=%0d words=%0d", phase, received);
        $finish;
    end
endmodule