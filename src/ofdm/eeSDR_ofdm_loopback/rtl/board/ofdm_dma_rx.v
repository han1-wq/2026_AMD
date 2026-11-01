`timescale 1ns/1ps
// Store before commit: no unchecked/partial packet can enter the DMA stream.
// packet_start is the successfully decoded SIGNAL event, before payload data.
module ofdm_dma_rx #(
    parameter SLOT_BITS = 3,
    parameter TIMEOUT_CYCLES = 8000000
) (
    input wire clk, reset, packet_start,
    input wire rx_valid, input wire [7:0] rx_byte,
    input wire fcs_strobe, fcs_ok, input wire [15:0] rx_length,
    output wire [7:0] m_data, output wire m_valid, m_last,
    input wire m_ready,
    output reg [31:0] accepted, dropped, overflow, timed_out
);
    localparam SLOTS = 1 << SLOT_BITS;
    (* ram_style = "block" *) reg [7:0] mem [0:SLOTS*1024-1];
    reg [10:0] lengths [0:SLOTS-1];
    reg [SLOT_BITS:0] wr_ptr, rd_ptr;
    wire full = (wr_ptr[SLOT_BITS] != rd_ptr[SLOT_BITS]) &&
        (wr_ptr[SLOT_BITS-1:0] == rd_ptr[SLOT_BITS-1:0]);
    reg active, discard;
    reg [10:0] count;
    reg [31:0] timer;
    wire [11:0] count_next = {1'b0,count} + (rx_valid ? 12'd1 : 12'd0);
    always @(posedge clk)
        if (active && !discard && rx_valid && count < 1024 && !packet_start)
            mem[{wr_ptr[SLOT_BITS-1:0],count[9:0]}] <= rx_byte;
    always @(posedge clk) begin
        if (reset) begin
            wr_ptr <= 0; active <= 0; discard <= 0; count <= 0; timer <= 0;
            accepted <= 0; dropped <= 0; overflow <= 0; timed_out <= 0;
        end else if (packet_start) begin
            if (active) dropped <= dropped + 1'b1;
            active <= 1; discard <= full; count <= 0; timer <= 0;
            if (full) overflow <= overflow + 1'b1;
        end else if (active) begin
            timer <= timer + 1'b1;
            if (rx_valid) begin
                if (count < 1025) count <= count + 1'b1;
                if (count >= 1024) discard <= 1;
            end
            if (fcs_strobe) begin
                active <= 0;
                if (!discard && fcs_ok && count_next > 0 && count_next <= 1024 &&
                    count_next == rx_length) begin
                    lengths[wr_ptr[SLOT_BITS-1:0]] <= count_next[10:0];
                    wr_ptr <= wr_ptr + 1'b1;
                    accepted <= accepted + 1'b1;
                end else dropped <= dropped + 1'b1;
            end else if (timer == TIMEOUT_CYCLES-1) begin
                active <= 0;
                timed_out <= timed_out + 1'b1;
                dropped <= dropped + 1'b1;
            end
        end
    end
    // Synchronous RAM read. The held output remains stable under AXIS stalls.
    localparam IDLE=0, READ=1, SEND=2;
    reg [1:0] state;
    reg [9:0] index;
    reg [7:0] byte_q;
    always @(posedge clk)
        if (state == READ) byte_q <= mem[{rd_ptr[SLOT_BITS-1:0],index}];
    assign m_valid = state == SEND;
    assign m_data = byte_q;
    assign m_last = {1'b0,index} == lengths[rd_ptr[SLOT_BITS-1:0]] - 1'b1;
    always @(posedge clk) begin
        if (reset) begin rd_ptr <= 0; state <= IDLE; index <= 0; end
        else case (state)
            IDLE: if (rd_ptr != wr_ptr) begin state <= READ; index <= 0; end
            READ: state <= SEND;
            SEND: if (m_ready) begin
                if (m_last) begin rd_ptr <= rd_ptr + 1'b1; state <= IDLE; end
                else begin index <= index + 1'b1; state <= READ; end
            end
            default: state <= IDLE;
        endcase
    end
endmodule