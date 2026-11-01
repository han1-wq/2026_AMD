`timescale 1ns / 1ps
module tb_pilot_rotate_precision;
    reg clk = 0;
    always #5 clk = ~clk;
    reg reset = 1;
    reg in_valid = 0;
    reg [31:0] phasor = 0;
    reg [63:0] sample = 0;
    wire out_valid;
    wire [63:0] rotated;
    reg [5:0] expected_valid = 0;
    reg [63:0] expected [0:5];
    reg signed [63:0] si, sq, pc, ps, ri, rq;
    integer n, k, checked = 0;
    integer seed = 32'h12345678;
    pilot_rotate_full_precision dut (
        .clk(clk), .reset(reset), .in_valid(in_valid),
        .phasor(phasor), .sample(sample),
        .out_valid(out_valid), .rotated(rotated)
    );
    // Independent 64-bit reference, including arithmetic floor for negatives.
    always @(posedge clk) begin
        if (reset) expected_valid = 0;
        else begin
            expected_valid = {expected_valid[4:0], in_valid};
            for (k = 5; k > 0; k = k - 1) expected[k] = expected[k-1];
            si = $signed(sample[31:0]); sq = $signed(sample[63:32]);
            pc = $signed(phasor[15:0]); ps = $signed(phasor[31:16]);
            ri = (si * pc - sq * ps) >>> 15;
            rq = (si * ps + sq * pc) >>> 15;
            if (ri > 2147483647) ri = 2147483647;
            if (ri < -64'sd2147483648) ri = -64'sd2147483648;
            if (rq > 2147483647) rq = 2147483647;
            if (rq < -64'sd2147483648) rq = -64'sd2147483648;
            expected[0] = {rq[31:0], ri[31:0]};
        end
        #1;
        if (out_valid !== expected_valid[5]) $fatal(1, "ROTATE_VALID_FAIL");
        if (out_valid) begin
            if (rotated !== expected[5])
                $fatal(1, "ROTATE_DATA_FAIL got=%h expected=%h", rotated, expected[5]);
            checked = checked + 1;
        end
    end
    task drive;
        input [31:0] i, q;
        input [15:0] c, s;
        begin
            @(negedge clk);
            in_valid = 1;
            sample = {q, i}; phasor = {s, c};
        end
    endtask
    initial begin
        repeat (2) @(negedge clk);
        reset = 0;
        drive(-32'sd312, 32'd24, 16'd32767, 16'd0);
        drive(32'd1, -32'sd1, 16'd0, 16'h8000);
        drive(32'h80000000, 32'h80000000, 16'h8000, 16'h8000);
        drive(32'h7fffffff, 32'h80000000, 16'h7fff, 16'h7fff);
        for (n = -1024; n <= 1024; n = n + 1)
            drive(n, -n, 16'd23170, -16'sd23170);
        for (n = 0; n < 2000; n = n + 1) begin
            drive($random(seed), $random(seed), $random(seed), $random(seed));
            if (n % 7 == 0) begin
                @(negedge clk); in_valid = 0;
            end
        end
        // Reset with occupied pipeline must discard all pending valids.
        @(negedge clk); reset = 1; in_valid = 0;
        repeat (2) @(negedge clk);
        reset = 0;
        drive(32'd127, -32'sd127, 16'd32767, 16'd0);
        @(negedge clk); in_valid = 0;
        repeat (8) @(negedge clk);
        if (checked < 4000) $fatal(1, "ROTATE_MISSING_OUTPUT");
        $display("PILOT_ROTATE_PRECISION_PASS checked=%0d", checked);
        $finish;
    end
endmodule