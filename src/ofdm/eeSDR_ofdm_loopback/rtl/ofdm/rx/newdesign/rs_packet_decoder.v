`timescale 1ns/1ps
// Shortened RS(255,239), GF(256)/0x11d, roots alpha^0..alpha^15.
// One packet buffer, no backpressure at the descrambler. A new s_start aborts
// any unfinished packet. Metadata and corrected bytes are replayed to FCS.
// Berlekamp-Massey, Chien search, Forney, then syndrome recheck. CRC remains
// essential: >8 errors may decode to another valid codeword.
// INTERLEAVE=1 scatters received columns into balanced codeword rows in mem.
// No extra packet RAM, replay pass, or change to the RS correction algorithm.
module rs_packet_decoder #(
    parameter INTERLEAVE = 1'b1
) (
    input wire clk, reset, s_start,
    input wire [11:0] s_length,
    input wire s_valid,
    input wire [7:0] s_data,
    output reg m_start, m_valid,
    output wire [7:0] m_data,
    output reg [11:0] m_length,
    output reg failed,
    output reg [7:0] corrected
);
    function [7:0] mul;
        input [7:0] a,b;
        reg [7:0] x,y;
        integer k;
        begin
            x=a; y=0;
            for(k=0;k<8;k=k+1) begin
                if(b[k]) y=y^x;
                x=(x<<1) ^ (x[7] ? 8'h1d : 8'h00);
            end
            mul=y;
        end
    endfunction
    function [7:0] power;
        input integer exponent;
        integer k;
        reg [7:0] x;
        begin
            x=1;
            for(k=0;k<exponent;k=k+1) x=mul(x,2);
            power=x;
        end
    endfunction
    reg [7:0] inverse[0:255];
    integer init_i;
    initial begin
        inverse[0]=0;
        for(init_i=0;init_i<255;init_i=init_i+1)
            inverse[power(init_i)]=power((255-init_i)%255);
    end
    localparam IDLE=0,CAPTURE=1,BLOCK=2,READ=3,SYNDROME=4,CHECK=5,
        BM_INIT=6,BM_DISC=7,BM_SCALE=8,BM_UPDATE=9,BM_NEXT=10,
        OMEGA=11,CHIEN_INIT=12,CHIEN=13,EVAL_O=14,EVAL_D=15,
        MAG_SCALE=16,MAG_APPLY=17,NEXT_POS=18,VERIFY=19,
        BLOCK_DONE=20,META=21,OUT_READ=22,OUT_SEND=23;
    reg [4:0] state;
    (* ram_style="block" *) reg [7:0] mem[0:1107];
    reg [11:0] length_q, wr, base, pos, out_pos;
    wire [2:0] input_count = s_length<=255 ? 3'd1 : s_length<=510 ? 3'd2 :
        s_length<=765 ? 3'd3 : s_length<=1020 ? 3'd4 : 3'd5;
    wire [10:0] input_data_length = s_length-({9'd0,input_count}<<4);
    wire [2:0] input_blocks, input_extra;
    wire [7:0] input_short;
    rs_block_layout layout(input_data_length, input_blocks, input_short, input_extra);
    reg [2:0] blocks, extra, capture_lane, block_lane, output_lane;
    reg [7:0] short_bytes;
    reg [11:0] capture_base, capture_column;
    wire [11:0] capture_address = INTERLEAVE ? capture_base+capture_column : wr;
    wire [7:0] output_data_length = short_bytes+(output_lane<extra ? 8'd1 : 8'd0);
    reg [7:0] n, scan, byte_q;
    reg [7:0] synd[0:15], locator[0:16], backup[0:16], saved[0:16];
    reg [7:0] omega[0:15], terms[0:8];
    reg [4:0] iteration, index, degree, shift, roots;
    reg [7:0] discrepancy, previous, scale, accum, x, eval_o, eval_d;
    reg verify_pass;
    reg [7:0] a,b;
    wire correction_write = state==MAG_APPLY && eval_d!=0;
    wire [11:0] write_address = correction_write ? base+n-1-scan : capture_address;
    wire [7:0] write_data = correction_write ? byte_q^product : s_data;
    wire [11:0] read_address = state==OUT_READ ? out_pos :
        state==CHIEN ? base+n-1-scan : base+pos;
    assign m_data=byte_q;
    wire [7:0] product;
    rs_gf_mul u_mul(a,b,product);
    wire [7:0] syndrome_next[0:15];
    wire [7:0] term_next[0:8];
    genvar g;
    generate for(g=0;g<16;g=g+1) begin: syndrome_mult
        wire [7:0] p;
        rs_gf_mul u_mul(synd[g],power(g),p);
        assign syndrome_next[g]=p^byte_q;
    end
    for(g=0;g<9;g=g+1) begin: chien_mult
        rs_gf_mul u_mul(terms[g],power((255-g)%255),term_next[g]);
    end endgenerate
    reg [7:0] synd_or, root_value;
    integer i,j;
    always @* begin
        synd_or=0; root_value=0;
        for(j=0;j<16;j=j+1) synd_or=synd_or|synd[j];
        for(j=0;j<9;j=j+1) root_value=root_value^terms[j];
        a=0; b=0;
        case(state)
            BM_DISC: begin a=locator[index]; b=synd[iteration-index]; end
            BM_SCALE: begin a=discrepancy; b=inverse[previous]; end
            BM_UPDATE: begin a=scale; b=backup[index-shift]; end
            OMEGA: begin a=locator[index]; b=synd[iteration-index]; end
            EVAL_O: begin a=eval_o; b=x; end
            EVAL_D: begin a=eval_d; b=x; end
            MAG_SCALE: begin a=eval_o; b=inverse[eval_d]; end
            MAG_APPLY: begin a=scale; b=inverse[x]; end
            default: begin end
        endcase
    end
    always @(posedge clk) begin
        if(!reset && !s_start &&
           (correction_write || (state==CAPTURE && s_valid && wr<length_q)))
            mem[write_address]<=write_data;
        if(state==READ || state==OUT_READ || (state==CHIEN && root_value==0))
            byte_q<=mem[read_address];
        if(reset || s_start) begin
            state<=IDLE; m_start<=0; m_valid<=0; failed<=0; corrected<=0;
            length_q<=s_length; wr<=0; base<=0; pos<=0; out_pos<=0;
            blocks<=input_blocks; extra<=input_extra; short_bytes<=input_short;
            capture_lane<=0; block_lane<=0; output_lane<=0;
            capture_base<=0; capture_column<=0;
            m_length<=0; n<=0; scan<=0; verify_pass<=0;
            iteration<=0; index<=0; degree<=0; shift<=0; roots<=0;
            discrepancy<=0; previous<=0; scale<=0; accum<=0;
            x<=0; eval_o<=0; eval_d<=0;
            for(i=0;i<16;i=i+1) begin synd[i]<=0; omega[i]<=0; end
            for(i=0;i<17;i=i+1) begin locator[i]<=0; backup[i]<=0; saved[i]<=0; end
            for(i=0;i<9;i=i+1) terms[i]<=0;
            if(!reset && s_start) begin
                // L=255*q+r: r must be 0 or 17..254. Min payload is 1.
                if(s_length>=21 && s_length<=1108 &&
                   (s_length%255==0 || s_length%255>=17)) begin
                    m_length<=s_length-16*((s_length+254)/255);
                    state<=CAPTURE;
                end else failed<=1;
            end
        end else begin
            m_start<=0; m_valid<=0;
            case(state)
                CAPTURE: if(s_valid) begin
                    wr<=wr+1'b1;
                    if(capture_lane==blocks-1) begin
                        capture_lane<=0; capture_base<=0; capture_column<=capture_column+1'b1;
                    end else begin
                        capture_lane<=capture_lane+1'b1;
                        capture_base<=capture_base+short_bytes+12'd16+(capture_lane<extra ? 12'd1 : 12'd0);
                    end
                    if(wr==length_q-1) state<=BLOCK;
                end
                BLOCK: begin
                    n<=INTERLEAVE ? short_bytes+8'd16+(block_lane<extra ? 8'd1 : 8'd0) :
                        (length_q-base>=255 ? 255 : length_q-base);
                    pos<=0; verify_pass<=0;
                    for(i=0;i<16;i=i+1) synd[i]<=0;
                    state<=READ;
                end
                READ: state<=SYNDROME;
                SYNDROME: begin
                    for(i=0;i<16;i=i+1) synd[i]<=syndrome_next[i];
                    pos<=pos+1'b1;
                    state<=pos==n-1 ? CHECK : READ;
                end
                CHECK: begin
                    if(synd_or==0) state<=BLOCK_DONE;
                    else if(verify_pass) begin failed<=1; state<=BLOCK_DONE; end
                    else state<=BM_INIT;
                end
                BM_INIT: begin
                    for(i=0;i<17;i=i+1) begin locator[i]<=i==0; backup[i]<=i==0; end
                    degree<=0; shift<=1; previous<=1; iteration<=0;
                    discrepancy<=synd[0]; index<=1; state<=BM_DISC;
                end
                BM_DISC: begin
                    if(index<=degree && index<=iteration) begin
                        discrepancy<=discrepancy^product; index<=index+1'b1;
                    end else state<=BM_SCALE;
                end
                BM_SCALE: begin
                    scale<=product; index<=0;
                    for(i=0;i<17;i=i+1) saved[i]<=locator[i];
                    if(discrepancy==0) begin shift<=shift+1'b1; state<=BM_NEXT; end
                    else state<=BM_UPDATE;
                end
                BM_UPDATE: begin
                    if(index>=shift) locator[index]<=locator[index]^product;
                    if(index==16) begin
                        if(2*degree<=iteration) begin
                            degree<=iteration+1-degree;
                            for(i=0;i<17;i=i+1) backup[i]<=saved[i];
                            previous<=discrepancy; shift<=1;
                        end else shift<=shift+1'b1;
                        state<=BM_NEXT;
                    end else index<=index+1'b1;
                end
                BM_NEXT: begin
                    if(iteration==15) begin
                        iteration<=0; index<=0; accum<=0;
                        if(degree==0 || degree>8) begin failed<=1; state<=BLOCK_DONE; end
                        else state<=OMEGA;
                    end else begin
                        iteration<=iteration+1'b1; index<=1;
                        discrepancy<=synd[iteration+1'b1]; state<=BM_DISC;
                    end
                end
                OMEGA: begin
                    if(index==iteration) begin
                        omega[iteration]<=accum^product;
                        accum<=0; index<=0; iteration<=iteration+1'b1;
                        if(iteration==15) state<=CHIEN_INIT;
                    end else begin accum<=accum^product; index<=index+1'b1; end
                end
                CHIEN_INIT: begin
                    for(i=0;i<9;i=i+1) terms[i]<=locator[i];
                    scan<=0; x<=1; roots<=0; state<=CHIEN;
                end
                CHIEN: begin
                    if(root_value==0) begin
                        roots<=roots+1'b1; eval_o<=0; eval_d<=0;
                        index<=15; state<=EVAL_O;
                    end else state<=NEXT_POS;
                end
                EVAL_O: begin eval_o<=product^omega[index]; state<=EVAL_D; end
                EVAL_D: begin
                    eval_d<=product ^ (index[0] ? 8'd0 : locator[index+1'b1]);
                    if(index==0) state<=MAG_SCALE;
                    else begin index<=index-1'b1; state<=EVAL_O; end
                end
                MAG_SCALE: begin
                    scale<=product;
                    if(eval_d==0) failed<=1;
                    state<=MAG_APPLY;
                end
                MAG_APPLY: begin
                    if(eval_d!=0) corrected<=corrected+1'b1;
                    state<=NEXT_POS;
                end
                NEXT_POS: begin
                    if(scan==n-1) state<=VERIFY;
                    else begin
                        scan<=scan+1'b1; x<=mul(x,8'h8e);
                        for(i=0;i<9;i=i+1) terms[i]<=term_next[i];
                        state<=CHIEN;
                    end
                end
                VERIFY: begin
                    if(roots!=degree) begin failed<=1; state<=BLOCK_DONE; end
                    else begin
                        pos<=0; verify_pass<=1;
                        for(i=0;i<16;i=i+1) synd[i]<=0;
                        state<=READ;
                    end
                end
                BLOCK_DONE: begin
                    if(base+n==length_q) begin out_pos<=0; pos<=0; state<=META; end
                    else begin base<=base+n; block_lane<=block_lane+1'b1; state<=BLOCK; end
                end
                META: begin m_start<=1; state<=OUT_READ; end
                OUT_READ: state<=OUT_SEND;
                OUT_SEND: begin
                    m_valid<=1;
                    if(out_pos==length_q-17) state<=IDLE;
                    else begin
                        if(INTERLEAVE ? pos==output_data_length-1 : pos==238) begin
                            out_pos<=out_pos+17; pos<=0; output_lane<=output_lane+1'b1;
                        end
                        else begin out_pos<=out_pos+1'b1; pos<=pos+1'b1; end
                        state<=OUT_READ;
                    end
                end
                default: state<=IDLE;
            endcase
        end
    end
endmodule