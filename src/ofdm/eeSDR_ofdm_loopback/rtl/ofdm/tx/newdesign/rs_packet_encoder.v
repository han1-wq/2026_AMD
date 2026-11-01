`timescale 1ns/1ps
// Capture payload+FCS, encode shortened RS(255,239), then replay contiguously.
// INTERLEAVE=1: balanced 1..5 codewords, column-wise byte serialization.
// Scatter writes fuse the block interleaver into the existing code RAM.
// s_start precedes the first s_valid. No input backpressure: <=1028 bytes.
// Roots alpha^0..alpha^15; highest-degree symbol first.
// INTERLEAVE=0 preserves the original full-block/short-tail wire format.
module rs_packet_encoder #(
    parameter INTERLEAVE = 1'b1
) (
    input wire clk, reset, s_start,
    input wire [10:0] s_length,
    input wire s_valid,
    input wire [7:0] s_data,
    output reg m_valid, m_start,
    output reg [7:0] m_data,
    output reg [11:0] m_length
);
    localparam IDLE=0, CAPTURE=1, READ=2, DATA=3, PARITY=4, PRIME=5, REPLAY=6;
    reg [2:0] state;
    (* ram_style="block" *) reg [7:0] source_mem[0:1027];
    (* ram_style="block" *) reg [7:0] code_mem[0:1107];
    reg [10:0] length_q, wr, rd;
    reg [11:0] out_wr, out_rd;
    reg [7:0] byte_q, block_count;
    wire [2:0] input_blocks, input_extra;
    wire [7:0] input_short;
    rs_block_layout layout(s_length, input_blocks, input_short, input_extra);
    reg [2:0] blocks, extra, lane;
    reg [7:0] short_bytes;
    wire [7:0] block_data_length = short_bytes + (lane<extra ? 8'd1 : 8'd0);
    wire [11:0] column = state==DATA ? {4'd0,block_count} :
        {4'd0,block_data_length}+{8'd0,parity_index};
    wire [11:0] code_address = INTERLEAVE ? column*blocks+lane : out_wr;
    reg [3:0] parity_index;
    reg [7:0] parity[0:15];
    wire [7:0] feedback = byte_q ^ parity[0];
    wire [7:0] product[0:15];
    // g(x)=product(i=0..15)(x+alpha^i), descending coefficients, omit x^16.
    localparam [127:0] G=128'h3b0d68bd44d11e08a34129e56232243b;
    genvar g;
    generate for(g=0;g<16;g=g+1) begin: mult
        rs_gf_mul u_mul(feedback, G[127-g*8 -: 8], product[g]);
    end endgenerate
    integer i;
    always @(posedge clk) begin
        if (!reset && state==CAPTURE && s_valid && wr<length_q) source_mem[wr] <= s_data;
        if (state==READ) byte_q <= source_mem[rd];
        if (!reset && (state==DATA || state==PARITY))
            code_mem[code_address] <= state==DATA ? byte_q : parity[parity_index];
        if (state==REPLAY) m_data <= code_mem[out_rd];
        if(reset) begin
            state<=IDLE; m_valid<=0; m_start<=0; m_length<=0;
            wr<=0; rd<=0; out_wr<=0; out_rd<=0; length_q<=0;
            block_count<=0; parity_index<=0;
            blocks<=1; extra<=0; lane<=0; short_bytes<=0;
            for(i=0;i<16;i=i+1) parity[i]<=0;
        end else begin
            m_valid<=state==REPLAY;
            m_start<=state==REPLAY && out_rd==0;
            case(state)
                IDLE: if(s_start) begin
                    length_q<=s_length; wr<=0; rd<=0; out_wr<=0;
                    blocks<=input_blocks; extra<=input_extra; lane<=0; short_bytes<=input_short;
                    block_count<=0;
                    for(i=0;i<16;i=i+1) parity[i]<=0;
                    if(s_length>=5 && s_length<=1028) state<=CAPTURE;
                end
                CAPTURE: if(s_valid) begin
                    wr<=wr+1'b1;
                    if(wr==length_q-1) state<=READ;
                end
                READ: state<=DATA;
                DATA: begin
                    for(i=0;i<15;i=i+1) parity[i]<=parity[i+1]^product[i];
                    parity[15]<=product[15];
                    rd<=rd+1'b1; out_wr<=out_wr+1'b1;
                    block_count<=block_count+1'b1;
                    if((INTERLEAVE ? block_count==block_data_length-1 : block_count==238) || rd==length_q-1) begin
                        parity_index<=0; state<=PARITY;
                    end else state<=READ;
                end
                PARITY: begin
                    out_wr<=out_wr+1'b1;
                    parity_index<=parity_index+1'b1;
                    if(parity_index==15) begin
                        block_count<=0;
                        lane<=lane+1'b1;
                        for(i=0;i<16;i=i+1) parity[i]<=0;
                        if(rd==length_q) begin
                            m_length<=out_wr+1'b1; state<=PRIME;
                        end else state<=READ;
                    end
                end
                PRIME: begin out_rd<=0; state<=REPLAY; end
                REPLAY: begin
                    out_rd<=out_rd+1'b1;
                    if(out_rd==m_length-1) state<=IDLE;
                end
                default: state<=IDLE;
            endcase
        end
    end
endmodule