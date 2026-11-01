`timescale 1ns/1ps
module tb_dma_packets;
    reg clk=0; always #5 clk=~clk;
    reg reset=1;
    reg [7:0] sd=0; reg sv=0, sl=0; wire sr;
    wire cv; reg cr=0; wire [10:0] len; wire [5:0] rate; wire [1:0] up;
    wire [7:0] td; wire tv,tl; reg ready=0,done=0;
    wire [31:0] ts,tc,tr,tf,cookie;
    wire phy_reset;
    ofdm_dma_tx #(.TIMEOUT_CYCLES(10000)) tx(clk,reset,sd,sv,sl,sr,cv,cr,len,rate,up,td,tv,tl,ready,done,2'b0,ts,tc,tr,tf,cookie,phy_reset);
    reg start=0,rv=0,fs=0,ok=0; reg [7:0] rb=0; reg [15:0] rl=0;
    wire [7:0] md; wire mv,ml; reg mr=0;
    wire [31:0] ra,rd,ro,rt;
    ofdm_dma_rx #(.TIMEOUT_CYCLES(10000)) rx(clk,reset,start,rv,rb,fs,ok,rl,md,mv,ml,mr,ra,rd,ro,rt);
    integer n,i,j,k,received,expected_len;
    reg [7:0] held; reg heldlast, stalled=0;
    always @(posedge clk) if (!reset) begin
        if(stalled && (!mv || md!==held || ml!==heldlast)) $fatal(1,"RX changed under stall");
        stalled <= mv && !mr; held<=md; heldlast<=ml;
    end
    task put;
        input [7:0] b; input last;
        begin
            @(negedge clk); sd=b; sv=1; sl=last;
            @(posedge clk); while(!sr) @(posedge clk);
            @(negedge clk); sv=0; sl=0;
        end
    endtask
    task send_record;
        input integer length; input integer actual;
        integer a;
        begin
            put(length & 255,0); put(length >> 8,0); put(54,0); put(0,0);
            put(8'h7b,0);
            for(a=5;a<16;a=a+1) put(0,0);
            for(a=0;a<actual;a=a+1) put(a & 255,a==actual-1);
        end
    endtask
    task receive_tx;
        input integer length;
        integer a;
        begin
            wait(cv); if(len!=length || rate!=54 || up!=0) $fatal(1,"TX metadata");
            @(negedge clk); cr=1; @(negedge clk); cr=0;
            a=0;
            while(a<length) begin
                @(negedge clk); ready=($random & 3)!=0;
                @(posedge clk);
                if(tv && ready) begin
                    if(td!==(a & 255) || tl!==(a==length-1)) $fatal(1,"TX byte %0d",a);
                    a=a+1;
                end
            end
            @(negedge clk); ready=0; done=1;
            @(negedge clk); done=0;
        end
    endtask
    task feed_rx;
        input integer length; input good;
        integer a;
        begin
            @(negedge clk); start=1; rl=length;
            @(negedge clk); start=0;
            for(a=0;a<length;a=a+1) begin
                rv=1; rb=a & 255; @(negedge clk);
                rv=0; @(negedge clk);
            end
            fs=1; ok=good; @(negedge clk); fs=0; ok=0;
        end
    endtask
    task drain_rx;
        input integer length;
        integer a;
        begin
            a=0;
            while(a<length) begin
                @(negedge clk); mr=($random & 3)!=0;
                @(posedge clk);
                if(mv && mr) begin
                    if(md!==(a & 255) || ml!==(a==length-1)) $fatal(1,"RX byte %0d got %0d",a,md);
                    a=a+1;
                end
            end
            @(negedge clk); mr=0;
        end
    endtask
    initial begin
        repeat(5) @(negedge clk); reset=0;
        for(n=1;n<=1024;n=n==1?3:n==3?64:n==64?1024:1025) begin
            fork send_record(n,n); receive_tx(n); join
            if(tc==0 || cookie!=123) $fatal(1,"TX completion");
            fork feed_rx(n,1); drain_rx(n); join
        end
        send_record(10,9); repeat(5) @(negedge clk);
        if(tr!=1 || cv) $fatal(1,"Bad TX length accepted");
        // Queue fills while consumer is stopped; no packet may be overwritten.
        for(k=0;k<8;k=k+1) feed_rx(3,1);
        feed_rx(3,1);
        if(ro!=1) $fatal(1,"RX overflow missing");
        for(k=0;k<8;k=k+1) drain_rx(3);
        feed_rx(3,0); repeat(5) @(negedge clk);
        if(mv || rd!=2) $fatal(1,"Bad FCS was submitted");
        // New start recovers from a truncated packet.
        @(negedge clk); start=1; @(negedge clk); start=0;
        feed_rx(3,1); drain_rx(3);
        @(negedge clk); start=1; @(negedge clk); start=0;
        repeat(10002) @(negedge clk);
        if(rt!=1 || rd!=4) $fatal(1,"Timeout/resync counters");
        if(ra!=13 || tc!=4 || tf!=0) $fatal(1,"Final counters");
        // Command backpressure, payload stall, and missing completion all recover.
        for(k=0;k<3;k=k+1) begin
            send_record(3,3);
            wait(cv);
            if(k!=0) begin
                @(negedge clk); cr=1; @(negedge clk); cr=0;
                if(k==2) begin
                    ready=1; wait(tl && tv);
                    @(posedge clk); @(negedge clk); ready=0;
                    if(tx.state!=tx.WAIT_DONE) $fatal(1,"Completion timeout setup");
                end
            end
            wait(phy_reset);
            if(tf!=k+1 || tc!=4 || cv || tv) $fatal(1,"TX watchdog accounting");
            // A late completion during reset cannot consume the next slot.
            @(negedge clk); done=1; @(negedge clk); done=0;
            wait(!phy_reset);
        end
        fork send_record(3,3); receive_tx(3); join
        if(tc!=5 || tf!=3 || ts!=8) $fatal(1,"TX failed to resume");
        $display("DMA_PACKETS_PASS"); $finish;
    end
    initial begin #2000000; $fatal(1,"watchdog"); end
endmodule