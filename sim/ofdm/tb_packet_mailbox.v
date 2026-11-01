`timescale 1ns/1ps
module tb_packet_mailbox;
    reg axi_clk = 0, data_clk = 0, resetn = 0, data_rst = 1;
    always #5 axi_clk = ~axi_clk;
    always #6.25 data_clk = ~data_clk;
    reg [7:0] awaddr = 0, araddr = 0;
    reg awvalid = 0, wvalid = 0, bready = 1, arvalid = 0, rready = 1;
    reg [31:0] wdata = 0;
    reg [3:0] wstrb = 15;
    wire awready, wready, bvalid, arready, rvalid;
    wire [1:0] bresp, rresp;
    wire [31:0] rdata;
    reg cmd_ready = 0, data_ready = 0, tx_done = 0;
    reg [1:0] tx_error = 0;
    reg rx_valid = 0, fcs_strobe = 0, fcs_ok = 0;
    reg [7:0] rx_byte = 0;
    reg [15:0] rx_length = 0;
    wire cmd_valid, data_valid, data_last;
    wire [10:0] cmd_length;
    wire [5:0] cmd_rate;
    wire [1:0] cmd_upsample;
    wire [7:0] data_byte;
    wire [2:0] led;
    integer n, packet, count = 0;
    reg [31:0] value;
    ofdm_packet_mailbox dut (.* , .s_axi_aclk(axi_clk), .s_axi_aresetn(resetn),
        .s_axi_awaddr(awaddr), .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wvalid(wvalid),
        .s_axi_wready(wready), .s_axi_bresp(bresp), .s_axi_bvalid(bvalid),
        .s_axi_bready(bready), .s_axi_araddr(araddr), .s_axi_arvalid(arvalid),
        .s_axi_arready(arready), .s_axi_rdata(rdata), .s_axi_rresp(rresp),
        .s_axi_rvalid(rvalid), .s_axi_rready(rready), .status_led(led));

    task write_reg(input [7:0] address, input [31:0] word);
        begin
            @(negedge axi_clk);
            awaddr = address; wdata = word; awvalid = 1; wvalid = 1;
            @(posedge axi_clk);
            @(negedge axi_clk);
            awvalid = 0; wvalid = 0;
            wait(bvalid);
            if (bresp != 0) $fatal(1, "write error addr=%h", address);
            @(posedge axi_clk);
        end
    endtask
    task read_reg(input [7:0] address, output [31:0] word);
        begin
            @(negedge axi_clk);
            araddr = address; arvalid = 1;
            @(posedge axi_clk);
            @(negedge axi_clk);
            arvalid = 0;
            wait(rvalid);
            word = rdata;
            @(posedge axi_clk);
        end
    endtask
    initial begin
        repeat(6) @(negedge axi_clk);
        resetn = 1; data_rst = 0;
        for (packet = 0; packet < 2; packet = packet + 1) begin
            for (n = 0; n < 16; n = n + 1)
                write_reg(8'h40 + 4*n, {4{8'(n + packet*37)}} + 32'h03020100);
            write_reg(0, 1);
            read_reg(4, value);
            if (!value[0] || value[1]) $fatal(1, "busy flag wrong");
            wait(cmd_valid);
            if (cmd_length != 64 || cmd_rate != 54) $fatal(1, "metadata wrong");
            @(negedge data_clk); cmd_ready = 1;
            @(negedge data_clk); cmd_ready = 0; data_ready = 1;
            count = 0;
            while (count < 64) begin
                @(posedge data_clk);
                if (data_valid && data_ready) begin
                    if (data_byte !== 8'((count / 4) + packet*37 + (count % 4)) ||
                        data_last !== (count == 63)) $fatal(1, "TX byte %0d", count);
                    count = count + 1;
                end
            end
            @(negedge data_clk); data_ready = 0;
            for (n = 0; n < 64; n = n + 1) begin
                @(negedge data_clk);
                rx_byte = (n/4) + packet*37 + (n%4);
                rx_valid = 1;
            end
            @(negedge data_clk); rx_valid = 0;
            fcs_strobe = 1; fcs_ok = packet == 0; rx_length = 64;
            @(negedge data_clk); fcs_strobe = 0;
            wait(dut.done);
            read_reg(4, value);
            if (value[2] !== (packet == 0) || !value[1]) $fatal(1, "status=%h", value);
            read_reg(8, value);
            if (value != 64) $fatal(1, "length=%h", value);
            for (n = 0; n < 16; n = n + 1) begin
                read_reg(8'h80 + n*4, value);
                if (value !== ({4{8'(n + packet*37)}} + 32'h03020100))
                    $fatal(1, "RX word %0d %h", n, value);
            end
        end
        $display("MAILBOX_PASS");
        $finish;
    end
    initial begin #2000000; $fatal(1, "mailbox timeout"); end
endmodule