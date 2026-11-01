`timescale 1ns/1ps
// Balanced shortening, preserving ceil(M/239) codewords and 16 parity/lane.
// First long_blocks lanes contain short_bytes+1 data bytes; others short_bytes.
// Callers validate 5 <= data_length <= 1028. Constant divisors only.
module rs_block_layout (
    input wire [10:0] data_length,
    output wire [2:0] blocks,
    output wire [7:0] short_bytes,
    output wire [2:0] long_blocks
);
    assign blocks = data_length<=239 ? 3'd1 : data_length<=478 ? 3'd2 :
        data_length<=717 ? 3'd3 : data_length<=956 ? 3'd4 : 3'd5;
    assign short_bytes = data_length<=239 ? data_length : data_length<=478 ? data_length/2 :
        data_length<=717 ? data_length/3 : data_length<=956 ? data_length/4 : data_length/5;
    assign long_blocks = data_length<=239 ? 0 : data_length<=478 ? data_length%2 :
        data_length<=717 ? data_length%3 : data_length<=956 ? data_length%4 : data_length%5;
endmodule