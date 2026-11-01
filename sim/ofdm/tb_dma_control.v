`timescale 1ns/1ps
module tb_dma_control;
    reg clk=0; always #5 clk=~clk;
    reg resetn=0;
    reg [7:0] awaddr=0,araddr=0;
    reg awvalid=0,wvalid=0,bready=0,arvalid=0,rready=0;
    reg [31:0] wdata=0; reg [3:0] wstrb=0;
    wire awready,wready,bvalid,arready,rvalid,enable;
    wire [1:0] bresp,rresp; wire [31:0] rdata;
    ofdm_dma_control dut(clk,resetn,awaddr,awvalid,awready,wdata,wstrb,
        wvalid,wready,bresp,bvalid,bready,araddr,arvalid,arready,rdata,rresp,
        rvalid,rready,enable,32'd10,32'd9,32'd8,32'd7,32'd6,32'd5,32'd4,32'd3,32'd2);
    task address;
        input [7:0] value;
        begin
            @(negedge clk); awaddr=value; awvalid=1;
            @(posedge clk); while(!awready) @(posedge clk);
            @(negedge clk); awvalid=0;
        end
    endtask
    task data;
        input [31:0] value; input [3:0] mask;
        begin
            @(negedge clk); wdata=value; wstrb=mask; wvalid=1;
            @(posedge clk); while(!wready) @(posedge clk);
            @(negedge clk); wvalid=0;
        end
    endtask
    task response;
        input [1:0] expected;
        begin
            wait(bvalid);
            repeat(4) begin
                @(negedge clk);
                if(!bvalid || bresp!==expected || awready || wready) $fatal(1,"write response stall");
            end
            bready=1; @(negedge clk); bready=0;
        end
    endtask
    task read;
        input [7:0] addr; input [31:0] expected;
        begin
            @(negedge clk); araddr=addr; arvalid=1;
            @(posedge clk); while(!arready) @(posedge clk);
            @(negedge clk); arvalid=0;
            wait(rvalid);
            repeat(4) begin
                @(negedge clk);
                if(!rvalid || rdata!==expected || rresp!=0 || arready) $fatal(1,"read response");
            end
            rready=1; @(negedge clk); rready=0;
        end
    endtask
    initial begin
        repeat(4) @(negedge clk); resetn=1;
        read(0,32'h444d4101); read(4,0); read(8,1024);
        address(4); repeat(3) @(negedge clk); data(1,1); response(0);
        if(!enable) $fatal(1,"enable write");
        data(0,0); repeat(3) @(negedge clk); address(4); response(0);
        read(4,1);
        fork address(8); data(0,15); join
        response(2); read(4,1);
        fork address(4); data(0,15); join
        response(0); read(4,0);
        read('h10,10); read('h14,9); read('h18,8); read('h1c,7);
        read('h20,6); read('h24,5); read('h28,4); read('h2c,3); read('h30,2);
        $display("DMA_CONTROL_PASS"); $finish;
    end
    initial begin #100000; $fatal(1,"watchdog"); end
endmodule