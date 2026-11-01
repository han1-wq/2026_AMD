`timescale 1ns/1ps
module tb_rs_control #(
    parameter INTERLEAVE=1
);
    reg clk=0, reset=1, start=0, valid=0;
    always #5 clk=~clk;
    reg [11:0] length=0;
    reg [7:0] data=0;
    wire ms,mv,failed;
    wire [7:0] md,corrected;
    wire [11:0] ml;
    rs_packet_decoder #(.INTERLEAVE(INTERLEAVE)) dut(clk,reset,start,length,valid,data,ms,mv,md,ml,failed,corrected);
    reg enc_start=0, enc_valid=0;
    reg [10:0] enc_length=5;
    wire ev,es;
    wire [7:0] ed;
    wire [11:0] el;
    integer enc_count=0;
    integer expected_encoded, t;
    reg enc_check=0;
    rs_packet_encoder #(.INTERLEAVE(INTERLEAVE)) enc(clk,reset,enc_start,enc_length,enc_valid,8'd0,ev,es,ed,el);
    always @(posedge clk) if(enc_check && ev) begin
        if(ed!==0 || el!=expected_encoded || es!=(enc_count==0))
            $fatal(1,"Encoder recovery data index=%0d data=%h length=%0d start=%b blocks=%0d short=%0d extra=%0d",
                   enc_count,ed,el,es,enc.blocks,enc.short_bytes,enc.extra);
        enc_count=enc_count+1;
    end
    task enc_begin;
        begin
            @(negedge clk); enc_start=1;
            @(negedge clk); enc_start=0;
        end
    endtask
    integer count=0, metadata=0, i, k, check_length=5, cycles;
    reg checking=0;
    always @(posedge clk) if(checking) begin
        if(ms) metadata=metadata+1;
        if(mv) begin
            count=count+1;
            if(md!==0 || failed || ml!=check_length) $fatal(1,"Bad recovery output");
        end
    end
    task begin_packet(input integer size);
        begin
            @(negedge clk); length=size; start=1; valid=0;
            @(negedge clk); start=0;
        end
    endtask
    task send_zeros(input integer size);
        integer n;
        begin
            for(n=0;n<size;n=n+1) begin
                valid=1; data=0; @(negedge clk);
            end
            valid=0;
        end
    endtask
    task recover(input integer size);
        begin
            check_length=size-16*((size+254)/255);
            checking=0;
            begin_packet(size);
            count=0; metadata=0; checking=1;
            send_zeros(size);
            cycles=0;
            while(count<check_length && cycles<10000) begin
                @(negedge clk); cycles=cycles+1;
            end
            repeat(3) @(negedge clk);
            if(count!=check_length || metadata!=1 || failed)
                $fatal(1,"Recovery failed count=%0d expected=%0d metadata=%0d failed=%b k=%0d",
                       count,check_length,metadata,failed,k);
            checking=0;
        end
    endtask
    initial begin
        repeat(4) @(negedge clk); reset=0;
        for(i=0;i<4096;i=i+1) begin
            if(i<21 || i>1108 || (i%255!=0 && i%255<17)) begin
                begin_packet(i);
                if(!failed || ms || mv) $fatal(1,"Invalid length accepted %0d",i);
            end
        end
        recover(21);
        // Abort capture, syndrome accumulation, BM, Chien and replay.
        for(k=0;k<5;k=k+1) begin
            begin_packet(21);
            if(k==0) send_zeros(7);
            else begin
                data=8'h42; valid=1; @(negedge clk);
                send_zeros(20);
                case(k)
                    1: repeat(7) @(negedge clk);
                    2: wait(dut.state==7);
                    3: wait(dut.state==13);
                    4: wait(mv);
                endcase
                @(negedge clk);
            end
            reset=1; valid=0;
            repeat(2) @(negedge clk); reset=0;
            repeat(2) @(negedge clk);
            if(mv || ms || failed) $fatal(1,"Reset did not abort");
            recover(21);
        end
        begin_packet(21); send_zeros(6);
        recover(1108); // s_start alone replaces an incomplete packet.
        // New packet replaces a five-lane frame in capture, syndrome, BM,
        // Chien and replay. Nonzero first column exercises real correction.
        for(k=0;k<5;k=k+1) begin
            begin_packet(1108);
            if(k==0) send_zeros(23);
            else begin
                data=8'h42; valid=1; @(negedge clk); send_zeros(1107);
                case(k)
                    1: repeat(7) @(negedge clk);
                    2: wait(dut.state==7);
                    3: wait(dut.state==13);
                    4: wait(mv);
                endcase
            end
            recover(k%2 ? 21 : 1108);
        end
        // Invalid TX lengths must not capture/replay or leave stale state.
        for(i=0;i<2048;i=i+1) if(i<5 || i>1028) begin
            enc_length=i; enc_begin;
            enc_valid=1; @(negedge clk); enc_valid=0;
            if(ev || es || enc.state!=0) $fatal(1,"Invalid encoder length accepted");
        end
        for(t=0;t<3;t=t+1) begin
        enc_length=t==0 ? 5 : t==1 ? 240 : 1028;
        expected_encoded=enc_length+16*((enc_length+238)/239);
        for(k=0;k<3;k=k+1) begin
            enc_begin;
            enc_valid=1;
            if(k==0) repeat(2) @(negedge clk);
            else repeat(enc_length) @(negedge clk);
            enc_valid=0;
            if(k==1) wait(enc.state==4);
            if(k==2) wait(ev);
            @(negedge clk); reset=1;
            repeat(2) @(negedge clk); reset=0;
            if(ev || es) $fatal(1,"Encoder reset did not abort");
            enc_count=0; enc_check=1;
            enc_begin; enc_valid=1;
            repeat(enc_length) @(negedge clk); enc_valid=0;
            cycles=0;
            while(enc_count<expected_encoded && cycles<5000) begin
                @(negedge clk); cycles=cycles+1;
            end
            repeat(3) @(negedge clk);
            if(enc_count!=expected_encoded) $fatal(1,"Encoder recovery count");
            enc_check=0;
        end
        end
        $display("RS_CONTROL_PASS malformed_lengths decoder_reset_capture_syndrome_BM_Chien_replay encoder_reset_capture_parity_replay restart");
        $finish;
    end
    initial begin #10000000; $fatal(1,"Control timeout state=%0d",dut.state); end
endmodule