`timescale 1ns / 1ps

// Exercise the real scaler/serializer handshake, including the packet tail.
// The old scaler cleared its bus without valid, leaving a permanent RF tone.
module tb_phy_tx_idle;
    reg clk = 0, rst = 1, valid = 0, clear = 0;
    reg signed [15:0] tx_i = 0, tx_q = 0;
    wire scaled_valid;
    wire [11:0] scaled_i, scaled_q;
    wire [5:0] data_p;
    wire frame_p;
    reg [5:0] high_i, high_q, low_i;
    reg have_high = 0, check_idle = 0;
    integer phase = 0, k, received = 0, idle_words = 0;
    reg [11:0] expected_i [0:7], expected_q [0:7];
    always #6.25 clk = ~clk;
    ofdm_iq_scale scale (
        .iw_clk(clk), .iw_rst(rst), .iw_tx_valid(valid), .iw_tx_clear(clear),
        .iw_tx_i(tx_i), .iw_tx_q(tx_q), .ow_tx_valid(scaled_valid),
        .ow_tx_i(scaled_i), .ow_tx_q(scaled_q),
        .iw_rx_valid(1'b0), .iw_rx_i(12'd0), .iw_rx_q(12'd0),
        .ow_rx_valid(), .ow_rx_i(), .ow_rx_q()
    );
    ad936x_phy_tx phy (
        .i_rst_n(!rst), .i_TR_mode(1'b0), .i_data_clk(clk),
        .i_tx_data_ch1_i(scaled_i), .i_tx_data_ch1_q(scaled_q),
        .i_tx_data_ch2_i(12'd0), .i_tx_data_ch2_q(12'd0),
        .i_tx_data_vaild(scaled_valid), .o_tx_clk_p(), .o_tx_clk_n(),
        .o_tx_data_p(data_p), .o_tx_data_n(),
        .o_tx_frame_p(frame_p), .o_tx_frame_n()
    );
    always @(posedge clk) begin
        #1;
        if (frame_p) high_i = data_p;
        else low_i = data_p;
    end
    always @(negedge clk) begin
        #1;
        if (rst) have_high = 0;
        else if (frame_p) begin
            high_q = data_p;
            have_high = 1;
        end else if (have_high) begin
            if (check_idle) begin
                if ({high_i,low_i,high_q,data_p} !== 24'd0)
                    $fatal(1, "PHY_IDLE_NOT_ZERO phase=%0d i=%03h q=%03h",
                           phase, {high_i,low_i}, {high_q,data_p});
                idle_words = idle_words + 1;
            end else if (received < 8 && ({high_i,low_i} != 0 || {high_q,data_p} != 0)) begin
                if ({high_i,low_i} !== expected_i[received] ||
                    {high_q,data_p} !== expected_q[received])
                    $fatal(1, "PHY_IDLE_PACKET_CORRUPTED index=%0d", received);
                received = received + 1;
            end
            have_high = 0;
        end
    end
    initial begin
        if ($value$plusargs("PHASE=%d", phase)) begin end
        repeat (20) @(negedge clk);
        #2; rst = 0;
        repeat (phase) @(negedge clk);
        for (k = 0; k < 8; k = k + 1) begin
            #2;
            expected_i[k] = 12'h123 + k * 12'h137;
            expected_q[k] = 12'he97 - k * 12'h153;
            tx_i = {expected_i[k],4'b0};
            tx_q = {expected_q[k],4'b0};
            valid = 1;
            @(negedge clk); #2; valid = 0;
            @(negedge clk);
        end
        // Captured hardware asserts done two clocks after the final TX beat.
        #2; clear = 1;
        @(negedge clk); #2; clear = 0;
        repeat (8) @(negedge clk);
        #2; check_idle = 1;
        repeat (16) @(negedge clk);
        #2;
        if (received != 8 || idle_words < 6)
            $fatal(1, "PHY_IDLE_COUNT received=%0d idle=%0d", received, idle_words);
        $display("PHY_IDLE_PASS phase=%0d words=%0d idle=%0d", phase, received, idle_words);
        $finish;
    end
endmodule