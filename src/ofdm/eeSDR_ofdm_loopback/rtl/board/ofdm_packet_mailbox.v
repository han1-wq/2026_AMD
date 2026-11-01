`timescale 1ns / 1ps

// One outstanding 64-byte request. The wide buses are bundled CDC transfers:
// the source holds each bus stable until the synchronized toggle is acknowledged.
// Both domains must be reset together (overlapping assertion, local release).
module ofdm_packet_mailbox #(
    // Active data-clock cycles, including the expiry cycle. 100 ms at 80 MHz.
    parameter integer P_TIMEOUT_CYCLES = 8000000
) (
    input wire s_axi_aclk, s_axi_aresetn,
    input wire [7:0] s_axi_awaddr, input wire s_axi_awvalid, output wire s_axi_awready,
    input wire [31:0] s_axi_wdata, input wire [3:0] s_axi_wstrb,
    input wire s_axi_wvalid, output wire s_axi_wready,
    output reg [1:0] s_axi_bresp, output reg s_axi_bvalid, input wire s_axi_bready,
    input wire [7:0] s_axi_araddr, input wire s_axi_arvalid, output wire s_axi_arready,
    output reg [31:0] s_axi_rdata, output wire [1:0] s_axi_rresp,
    output reg s_axi_rvalid, input wire s_axi_rready,
    input wire data_clk, input wire data_rst,
    input wire cmd_ready, output wire cmd_valid,
    output wire [10:0] cmd_length, output wire [5:0] cmd_rate,
    output wire [1:0] cmd_upsample,
    input wire data_ready, output wire data_valid,
    output wire data_last, output wire [7:0] data_byte,
    input wire tx_done, input wire [1:0] tx_error,
    input wire rx_valid, input wire [7:0] rx_byte,
    input wire fcs_strobe, input wire fcs_ok, input wire [15:0] rx_length,
    output wire [2:0] status_led
);
    reg [511:0] tx_buffer, rx_buffer, tx_snapshot, rx_snapshot;
    reg [15:0] rx_length_d, rx_length_snapshot;
    reg [4:0] flags_d, flags_snapshot;
    reg start_toggle, done_toggle;
    (* ASYNC_REG = "TRUE" *) reg [1:0] start_sync, done_sync;
    reg done_seen, busy, done;
    reg [7:0] awaddr_q;
    reg aw_pending, w_pending;
    reg [31:0] wdata_q;
    reg [3:0] wstrb_q;
    integer i;

    assign s_axi_awready = !aw_pending && !s_axi_bvalid;
    assign s_axi_wready = !w_pending && !s_axi_bvalid;
    assign s_axi_arready = !s_axi_rvalid;
    assign s_axi_rresp = 2'b00;
    assign status_led = {done && !flags_snapshot[0], done && flags_snapshot[0], busy};

    always @(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            tx_buffer <= 0;
            rx_snapshot <= 0;
            flags_snapshot <= 0;
            rx_length_snapshot <= 0;
            start_toggle <= 0;
            done_sync <= 0;
            done_seen <= 0;
            busy <= 0;
            done <= 0;
            aw_pending <= 0;
            w_pending <= 0;
            s_axi_bvalid <= 0;
            s_axi_bresp <= 0;
            s_axi_rvalid <= 0;
            s_axi_rdata <= 0;
        end else begin
            done_sync <= {done_sync[0], done_toggle};
            if (busy && done_sync[1] != done_seen) begin
                done_seen <= done_sync[1];
                rx_snapshot <= rx_buffer;
                rx_length_snapshot <= rx_length_d;
                flags_snapshot <= flags_d;
                busy <= 0;
                done <= 1;
            end
            if (s_axi_awready && s_axi_awvalid) begin
                awaddr_q <= s_axi_awaddr;
                aw_pending <= 1;
            end
            if (s_axi_wready && s_axi_wvalid) begin
                wdata_q <= s_axi_wdata;
                wstrb_q <= s_axi_wstrb;
                w_pending <= 1;
            end
            if (aw_pending && w_pending) begin
                aw_pending <= 0;
                w_pending <= 0;
                s_axi_bvalid <= 1;
                s_axi_bresp <= 0;
                if (awaddr_q == 8'h00 && wstrb_q[0] && wdata_q[0] && !busy) begin
                    start_toggle <= ~start_toggle;
                    busy <= 1;
                    done <= 0;
                end else if (awaddr_q >= 8'h40 && awaddr_q < 8'h80 && !busy) begin
                    for (i = 0; i < 4; i = i + 1)
                        if (wstrb_q[i]) tx_buffer[(awaddr_q[5:2]*32)+(i*8) +: 8] <= wdata_q[i*8 +: 8];
                end else if ((awaddr_q == 8'h00 && wstrb_q[0] && wdata_q[0] && busy) ||
                             (awaddr_q >= 8'h40 && awaddr_q < 8'h80 && busy))
                    s_axi_bresp <= 2'b10;
            end else if (s_axi_bvalid && s_axi_bready) s_axi_bvalid <= 0;

            if (s_axi_arready && s_axi_arvalid) begin
                s_axi_rvalid <= 1;
                if (s_axi_araddr == 8'h04)
                    s_axi_rdata <= {25'd0, flags_snapshot, done, busy};
                else if (s_axi_araddr == 8'h08)
                    s_axi_rdata <= {16'd0, rx_length_snapshot};
                else if (s_axi_araddr >= 8'h40 && s_axi_araddr < 8'h80)
                    s_axi_rdata <= tx_buffer[s_axi_araddr[5:2]*32 +: 32];
                else if (s_axi_araddr >= 8'h80 && s_axi_araddr < 8'hc0)
                    s_axi_rdata <= done ? rx_snapshot[s_axi_araddr[5:2]*32 +: 32] : 0;
                else s_axi_rdata <= 0;
            end else if (s_axi_rvalid && s_axi_rready) s_axi_rvalid <= 0;
        end
    end

    localparam [1:0] IDLE = 0, COMMAND = 1, PAYLOAD = 2, WAIT_RX = 3;
    reg [1:0] state;
    reg start_seen, mismatch;
    reg [6:0] tx_index, rx_count;
    localparam integer TIMEOUT_WIDTH = P_TIMEOUT_CYCLES > 1 ? $clog2(P_TIMEOUT_CYCLES) : 1;
    localparam [TIMEOUT_WIDTH-1:0] TIMEOUT_LAST = P_TIMEOUT_CYCLES - 1;
    reg [TIMEOUT_WIDTH-1:0] timeout_count;
    // Terminal events sample the byte presented on THIS clock edge, not just
    // the previous registered count/mismatch. Count saturates on overflow.
    wire [6:0] rx_count_next = rx_valid && rx_count != 127 ? rx_count + 7'd1 : rx_count;
    wire mismatch_next = mismatch || (rx_valid &&
        (rx_count >= 64 || rx_byte != tx_snapshot[rx_count*8 +: 8]));
    assign cmd_valid = state == COMMAND;
    assign cmd_length = 11'd64;
    assign cmd_rate = 6'd54;
    assign cmd_upsample = 0;
    assign data_valid = state == PAYLOAD;
    assign data_last = tx_index == 63;
    assign data_byte = tx_snapshot[tx_index*8 +: 8];

    always @(posedge data_clk) begin
        if (data_rst) begin
            start_sync <= 0;
            start_seen <= 0;
            done_toggle <= 0;
            tx_snapshot <= 0;
            rx_buffer <= 0;
            rx_length_d <= 0;
            flags_d <= 0;
            state <= IDLE;
            tx_index <= 0;
            rx_count <= 0;
            mismatch <= 0;
            timeout_count <= 0;
        end else begin
            start_sync <= {start_sync[0], start_toggle};
            if (state == IDLE && start_sync[1] != start_seen) begin
                start_seen <= start_sync[1];
                tx_snapshot <= tx_buffer;
                rx_buffer <= 0;
                rx_count <= 0;
                mismatch <= 0;
                tx_index <= 0;
                timeout_count <= 0;
                state <= COMMAND;
            end else if (state != IDLE) begin
                // Timeout has priority and does not accept a byte on expiry.
                if (timeout_count == TIMEOUT_LAST) begin
                    flags_d <= {1'b1, 1'b0, mismatch, 1'b0, 1'b0};
                    rx_length_d <= {9'd0, rx_count};
                    done_toggle <= ~done_toggle;
                    state <= IDLE;
                end else begin
                    timeout_count <= timeout_count + 1'b1;
                    if (state == COMMAND && cmd_ready) state <= PAYLOAD;
                    if (state == PAYLOAD && data_ready) begin
                        if (data_last) state <= WAIT_RX;
                        else tx_index <= tx_index + 1'b1;
                    end
                    if (rx_valid) begin
                        if (rx_count < 64)
                            rx_buffer[rx_count*8 +: 8] <= rx_byte;
                        mismatch <= mismatch_next;
                        rx_count <= rx_count_next;
                    end
                    // TX error wins over FCS, but normal TX done must not mask
                    // FCS. These are independent events on the receive path.
                    if (tx_done && tx_error != 0) begin
                        flags_d <= {1'b0, 1'b1, mismatch_next, 1'b0, 1'b0};
                        rx_length_d <= {9'd0, rx_count_next};
                        done_toggle <= ~done_toggle;
                        state <= IDLE;
                    end else if (fcs_strobe && state == WAIT_RX) begin
                        flags_d <= {1'b0, 1'b0, mismatch_next || rx_count_next != 64 || rx_length != 64,
                                    fcs_ok, fcs_ok && !mismatch_next && rx_count_next == 64 && rx_length == 64};
                        rx_length_d <= rx_length;
                        done_toggle <= ~done_toggle;
                        state <= IDLE;
                    end
                end
            end
        end
    end
endmodule