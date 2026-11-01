`timescale 1ns/1ps
// Same clock as packet adapters. The BD performs AXI clock conversion.
module ofdm_dma_control (
    input wire clk, resetn,
    input wire [7:0] awaddr, input wire awvalid, output wire awready,
    input wire [31:0] wdata, input wire [3:0] wstrb,
    input wire wvalid, output wire wready,
    output reg [1:0] bresp, output reg bvalid, input wire bready,
    input wire [7:0] araddr, input wire arvalid, output wire arready,
    output reg [31:0] rdata, output wire [1:0] rresp,
    output reg rvalid, input wire rready,
    output reg enable,
    input wire [31:0] tx_submitted, tx_completed, tx_rejected, tx_failed,
    input wire [31:0] tx_cookie, rx_accepted, rx_dropped, rx_overflow, rx_timeout
);
    reg aw_pending, w_pending;
    reg [7:0] addr_q;
    reg [31:0] data_q;
    reg [3:0] strb_q;
    assign awready = !aw_pending && !bvalid;
    assign wready = !w_pending && !bvalid;
    assign arready = !rvalid;
    assign rresp = 0;
    always @(posedge clk) begin
        if (!resetn) begin
            aw_pending <= 0; w_pending <= 0; bvalid <= 0; bresp <= 0;
            rvalid <= 0; rdata <= 0; enable <= 0;
            addr_q <= 0; data_q <= 0; strb_q <= 0;
        end else begin
            if (awready && awvalid) begin aw_pending <= 1; addr_q <= awaddr; end
            if (wready && wvalid) begin w_pending <= 1; data_q <= wdata; strb_q <= wstrb; end
            if (bvalid && bready) bvalid <= 0;
            if (aw_pending && w_pending) begin
                aw_pending <= 0; w_pending <= 0; bvalid <= 1;
                bresp <= addr_q == 4 ? 2'b00 : 2'b10;
                if (addr_q == 4 && strb_q[0]) enable <= data_q[0];
            end
            if (rvalid && rready) rvalid <= 0;
            if (arready && arvalid) begin
                rvalid <= 1;
                case (araddr)
                    8'h00: rdata <= 32'h444d4101;
                    8'h04: rdata <= {31'b0,enable};
                    8'h08: rdata <= 1024;
                    8'h10: rdata <= tx_submitted;
                    8'h14: rdata <= tx_completed;
                    8'h18: rdata <= tx_rejected;
                    8'h1c: rdata <= tx_failed;
                    8'h20: rdata <= tx_cookie;
                    8'h24: rdata <= rx_accepted;
                    8'h28: rdata <= rx_dropped;
                    8'h2c: rdata <= rx_overflow;
                    8'h30: rdata <= rx_timeout;
                    default: rdata <= 0;
                endcase
            end
        end
    end
endmodule