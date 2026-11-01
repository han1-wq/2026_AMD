`timescale 1ns/1ps
// Byte AXIS, after the BD width converter / asynchronous FIFO. Each TLAST
// delimits 16 bytes of local metadata followed by 1..1024 wireless bytes.
// Metadata: length:u16, rate:u8, upsample:u8, cookie:u32, reserved:8 bytes.
module ofdm_dma_tx #(
    parameter SLOT_BITS = 2,
    parameter TIMEOUT_CYCLES = 800000 // 10 ms at the board's 80 MHz data clock
) (
    input wire clk, reset,
    input wire [7:0] s_data, input wire s_valid, s_last,
    output wire s_ready,
    output wire cmd_valid, input wire cmd_ready,
    output wire [10:0] cmd_length, output wire [5:0] cmd_rate,
    output wire [1:0] cmd_upsample,
    output wire [7:0] data_byte, output wire data_valid, data_last,
    input wire data_ready, tx_done, input wire [1:0] tx_error,
    output reg [31:0] submitted, completed, rejected, failed, last_cookie,
    output wire phy_reset
);
    localparam SLOTS = 1 << SLOT_BITS;
    (* ram_style = "block" *) reg [7:0] mem [0:SLOTS*1024-1];
    reg [10:0] lengths [0:SLOTS-1];
    reg [5:0] rates [0:SLOTS-1];
    reg [1:0] ups [0:SLOTS-1];
    reg [31:0] cookies [0:SLOTS-1];
    reg [SLOT_BITS:0] wr_ptr, rd_ptr;
    wire full = (wr_ptr[SLOT_BITS] != rd_ptr[SLOT_BITS]) &&
                (wr_ptr[SLOT_BITS-1:0] == rd_ptr[SLOT_BITS-1:0]);
    wire empty = wr_ptr == rd_ptr;
    reg [10:0] pos;
    reg [15:0] length_in;
    reg [7:0] rate_in, up_in;
    reg [31:0] cookie_in;
    reg bad;
    wire supported = rate_in == 6 || rate_in == 9 || rate_in == 12 ||
        rate_in == 18 || rate_in == 24 || rate_in == 36 ||
        rate_in == 48 || rate_in == 54;
    assign s_ready = !full;
    wire [9:0] payload_offset = pos - 11'd16;
    always @(posedge clk)
        if (s_valid && s_ready && pos >= 16 && pos < 1040)
            mem[{wr_ptr[SLOT_BITS-1:0], payload_offset}] <= s_data;

    always @(posedge clk) begin
        if (reset) begin
            wr_ptr <= 0; pos <= 0; length_in <= 0; rate_in <= 0;
            up_in <= 0; cookie_in <= 0; bad <= 0;
            submitted <= 0; rejected <= 0;
        end else if (s_valid && s_ready) begin
            case (pos)
                0: length_in[7:0] <= s_data;
                1: length_in[15:8] <= s_data;
                2: rate_in <= s_data;
                3: up_in <= s_data;
                4: cookie_in[7:0] <= s_data;
                5: cookie_in[15:8] <= s_data;
                6: cookie_in[23:16] <= s_data;
                7: cookie_in[31:24] <= s_data;
                default: begin end
            endcase
            if ((pos >= 8 && pos < 16 && s_data != 0) || pos >= 1040)
                bad <= 1;
            if (s_last) begin
                if (!bad && pos >= 16 && pos < 1040 && length_in >= 1 &&
                    length_in <= 1024 && pos == length_in + 15 &&
                    supported && up_in == 0) begin
                    lengths[wr_ptr[SLOT_BITS-1:0]] <= length_in[10:0];
                    rates[wr_ptr[SLOT_BITS-1:0]] <= rate_in[5:0];
                    ups[wr_ptr[SLOT_BITS-1:0]] <= up_in[1:0];
                    cookies[wr_ptr[SLOT_BITS-1:0]] <= cookie_in;
                    wr_ptr <= wr_ptr + 1'b1;
                    submitted <= submitted + 1'b1;
                end else rejected <= rejected + 1'b1;
                pos <= 0; bad <= 0;
            end else if (pos < 1041) pos <= pos + 1'b1;
        end
    end

    localparam IDLE=0, COMMAND=1, READ=2, SEND=3, WAIT_DONE=4, RECOVER=5;
    reg [2:0] state;
    reg [31:0] elapsed;
    assign phy_reset = reset || state == RECOVER;
    reg [9:0] index;
    reg [7:0] byte_q;
    always @(posedge clk)
        if (state == READ) byte_q <= mem[{rd_ptr[SLOT_BITS-1:0], index}];
    assign cmd_valid = state == COMMAND;
    assign cmd_length = lengths[rd_ptr[SLOT_BITS-1:0]];
    assign cmd_rate = rates[rd_ptr[SLOT_BITS-1:0]];
    assign cmd_upsample = ups[rd_ptr[SLOT_BITS-1:0]];
    assign data_byte = byte_q;
    assign data_valid = state == SEND;
    assign data_last = {1'b0,index} == cmd_length - 1'b1;
    always @(posedge clk) begin
        if (reset) begin
            rd_ptr <= 0; state <= IDLE; index <= 0; elapsed <= 0;
            completed <= 0; failed <= 0; last_cookie <= 0;
        end else begin
            if (state == IDLE) elapsed <= 0;
            else elapsed <= elapsed + 1'b1;
            case (state)
                IDLE: if (!empty) begin state <= COMMAND; index <= 0; end
                COMMAND: if (cmd_ready) state <= READ;
                READ: state <= SEND;
                SEND: if (data_ready) begin
                    if (data_last) state <= WAIT_DONE;
                    else begin index <= index + 1'b1; state <= READ; end
                end
                WAIT_DONE: begin end
                // Hold PHY reset long enough for the encoder/FIFOs to reset.
                RECOVER: if (elapsed == 63) begin state <= IDLE; elapsed <= 0; end
                default: state <= IDLE;
            endcase
            // A rejected OFDM command may complete before the payload phase.
            if (tx_done && (state == READ || state == SEND || state == WAIT_DONE)) begin
                last_cookie <= cookies[rd_ptr[SLOT_BITS-1:0]];
                if (tx_error != 0) failed <= failed + 1'b1;
                else completed <= completed + 1'b1;
                rd_ptr <= rd_ptr + 1'b1;
                state <= IDLE;
            end else if (state != IDLE && state != RECOVER && elapsed >= TIMEOUT_CYCLES-1) begin
                last_cookie <= cookies[rd_ptr[SLOT_BITS-1:0]];
                failed <= failed + 1'b1;
                rd_ptr <= rd_ptr + 1'b1;
                state <= RECOVER; elapsed <= 0;
            end
        end
    end
endmodule