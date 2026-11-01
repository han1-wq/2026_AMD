`timescale 1ns/1ps
// GF(256), polynomial x^8+x^4+x^3+x^2+1 (0x11d), alpha=2.
// Shared combinational multiplier, used by the sequential decoder datapath.
module rs_gf_mul(input wire [7:0] a, b, output reg [7:0] y);
    reg [7:0] x;
    integer i;
    always @* begin
        x = a;
        y = 0;
        for (i=0; i<8; i=i+1) begin
            if (b[i]) y = y ^ x;
            x = {x[6:0],1'b0} ^ (x[7] ? 8'h1d : 8'h00);
        end
    end
endmodule