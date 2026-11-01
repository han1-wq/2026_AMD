`timescale 1ns/1ps
module tb_rs_packets #(
    parameter INTERLEAVE=0
);
    reg clk=0, reset=1;
    always #6.25 clk=~clk;
    reg enc_start=0, enc_valid=0, dec_start=0, dec_valid=0;
    reg [10:0] input_length=0;
    reg [11:0] encoded_length=0;
    reg [7:0] enc_data=0, dec_data=0;
    wire ev, es, dv, ds, failed;
    wire [7:0] ed, dd, corrected;
    wire [11:0] el, dl;
    rs_packet_encoder #(.INTERLEAVE(INTERLEAVE)) encoder(clk,reset,enc_start,input_length,enc_valid,enc_data,ev,es,ed,el);
    rs_packet_decoder #(.INTERLEAVE(INTERLEAVE)) decoder(clk,reset,dec_start,encoded_length,dec_valid,dec_data,
                              ds,dv,dd,dl,failed,corrected);
    wire fv, fs, fok;
    wire [7:0] fd;
    wire [15:0] fl;
    // Named connections keep the actual corrected-byte path explicit.
    fcs_for_data_field check_crc(
        .clk(clk),.rst(reset),.fcs_data_in_valid(dv),.fcs_data_in(dd),
        .fcs_data_out_valid(fv),.fcs_data_out(fd),.fcs_ok_strobe(fs),.fcs_ok(fok),
        .pkt_length(fl),.data_field_param_gain_stb(ds),
        .data_field_param_gain_ok(1'b1),.data_field_psdu_byte_length(dl));
    reg ready=0;
    wire mv, ml;
    wire [7:0] md;
    wire [31:0] accepted,dropped,overflow,timed_out;
    ofdm_dma_rx dma(.clk(clk),.reset(reset),.packet_start(dec_start),
        .rx_valid(fv),.rx_byte(fd),.fcs_strobe(fs),.fcs_ok(fok && !failed),.rx_length(fl),
        .m_data(md),.m_valid(mv),.m_last(ml),.m_ready(ready),
        .accepted(accepted),.dropped(dropped),.overflow(overflow),.timed_out(timed_out));
    reg [7:0] original[0:1027], reference_code[0:1107], damaged[0:1107];
    integer file_handle,rc,cases,c,payload_length,code_length,error_count,expect_ok;
    integer i,enc_count,dec_count,dma_count,cycles,good=0,bad=0;
    integer max_decode_cycles=0,decode_cycles;
    reg seen_fcs;
    reg [4095:0] vector_path;
    always @(posedge clk) if(!reset) begin
        if(ev) begin
            if(enc_count>=code_length || ed!==reference_code[enc_count])
                $fatal(1,"ENCODER case=%0d index=%0d got=%02x expected=%02x",c,enc_count,ed,reference_code[enc_count]);
            if(el!=code_length || es!=(enc_count==0)) $fatal(1,"ENCODER metadata");
            enc_count=enc_count+1;
        end
        if(dv) begin
            if(expect_ok && dd!==original[dec_count])
                $fatal(1,"DECODER case=%0d index=%0d got=%02x expected=%02x failed=%0d",c,dec_count,dd,original[dec_count],failed);
            dec_count=dec_count+1;
        end
        if(fs) begin
            if((fok && !failed)!==expect_ok[0] || fl!=payload_length || dec_count!=payload_length+4)
                $fatal(1,"CRC case=%0d ok=%0d failed=%0d expected=%0d count=%0d length=%0d",c,fok,failed,expect_ok,dec_count,fl);
            if(expect_ok && corrected!=error_count)
                $fatal(1,"CORRECTED case=%0d got=%0d expected=%0d",c,corrected,error_count);
            seen_fcs=1;
        end
        if(mv && ready) begin
            if(!expect_ok || md!==original[dma_count] || ml!=(dma_count==payload_length-1))
                $fatal(1,"DMA case=%0d index=%0d",c,dma_count);
            dma_count=dma_count+1;
        end
    end
    initial begin
        if(!$value$plusargs("VECTORS=%s",vector_path)) $fatal(1,"Missing VECTORS");
        file_handle=$fopen(vector_path,"r");
        if(!file_handle) $fatal(1,"Cannot open vectors");
        rc=$fscanf(file_handle,"%d",cases);
        repeat(5) @(negedge clk);
        reset=0;
        for(c=0;c<cases;c=c+1) begin
            rc=$fscanf(file_handle,"%d %d %d %d",payload_length,code_length,error_count,expect_ok);
            if(rc!=4) $fatal(1,"Truncated vector header");
            for(i=0;i<payload_length+4;i=i+1) rc=$fscanf(file_handle,"%h",original[i]);
            for(i=0;i<code_length;i=i+1) rc=$fscanf(file_handle,"%h",reference_code[i]);
            for(i=0;i<code_length;i=i+1) rc=$fscanf(file_handle,"%h",damaged[i]);
            enc_count=0; dec_count=0; dma_count=0; seen_fcs=0;
            input_length=payload_length+4; encoded_length=code_length;
            enc_start=1;
            @(negedge clk); enc_start=0;
            for(i=0;i<payload_length+4;i=i+1) begin
                enc_valid=1; enc_data=original[i]; @(negedge clk);
                if(i%7==3) begin enc_valid=0; repeat(2) @(negedge clk); end
            end
            enc_valid=0; cycles=0;
            while(enc_count<code_length && cycles<10000) begin @(negedge clk); cycles=cycles+1; end
            if(enc_count!=code_length) $fatal(1,"Encoder timeout");
            @(negedge clk); dec_start=1;
            @(negedge clk); dec_start=0;
            for(i=0;i<code_length;i=i+1) begin
                dec_valid=1; dec_data=damaged[i]; @(negedge clk);
                if(i%13==0) begin dec_valid=0; repeat(3) @(negedge clk); end
            end
            dec_valid=0; decode_cycles=0;
            while(!seen_fcs && decode_cycles<30000) begin @(negedge clk); decode_cycles=decode_cycles+1; end
            if(!seen_fcs) $fatal(1,"Decoder timeout case=%0d state=%0d",c,decoder.state);
            if(decode_cycles>max_decode_cycles) max_decode_cycles=decode_cycles;
            repeat(3) @(negedge clk);
            if(expect_ok) begin
                good=good+1; cycles=0;
                while(dma_count<payload_length && cycles<10000) begin
                    ready=(cycles%5!=0); @(negedge clk); cycles=cycles+1;
                end
                if(dma_count!=payload_length) $fatal(1,"DMA timeout");
            end else bad=bad+1;
            ready=0;
            repeat(4) @(negedge clk);
            if(accepted!=good || dropped!=bad || overflow!=0 || timed_out!=0)
                $fatal(1,"DMA counters case=%0d accepted=%0d dropped=%0d",c,accepted,dropped);
            $display("RS_PACKET_PASS case=%0d payload=%0d encoded=%0d errors=%0d expected_ok=%0d failed=%0d decode_cycles=%0d",
                     c,payload_length,code_length,error_count,expect_ok,failed,decode_cycles);
        end
        $display("RS_REGRESSION_PASS cases=%0d accepted=%0d rejected=%0d max_decode_cycles=%0d",cases,good,bad,max_decode_cycles);
        $finish;
    end
    initial begin #(64'd3000000000); $fatal(1,"Watchdog"); end
endmodule