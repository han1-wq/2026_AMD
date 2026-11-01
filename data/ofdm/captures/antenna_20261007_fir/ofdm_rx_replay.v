`timescale 1ns/1ps
module ofdm_rx_replay;
reg clk=0, reset=1, valid=0;
reg [15:0] ri=0, rq=0;
always #6.25 clk=~clk;
wire bv, fs, ok; wire [7:0] b; wire [15:0] len;
integer fd, rc, n, vi, ii, qq, count=0, cycle=0;
reg [1023:0] input_path;
rx802p11_top rx(.sclk(clk),.reset(reset),.enable(1'b1),
 .sample_in_i(ri),.sample_in_q(rq),.sample_in_valid(valid),
 .threshold_neg_pos_value(32'd100),.peak_threshold(16'd10000),
 .fcs_data_out_valid(bv),.fcs_data_out(b),.fcs_ok_strobe(fs),.fcs_ok(ok),.pkt_length(len));
initial begin
 if (!$value$plusargs("INPUT=%s",input_path)) $fatal(1,"missing INPUT");
 fd=$fopen(input_path,"r"); if (!fd) $fatal(1,"open failed");
 repeat(100) @(negedge clk); reset=0;
 repeat(2000) @(negedge clk);
 while (!$feof(fd)) begin
   rc=$fscanf(fd,"%d %d %d\n",vi,ii,qq);
   if(rc==3) begin valid=vi;ri=ii;rq=qq; @(negedge clk); end
 end
 valid=0; $fclose(fd);
 repeat(16000) @(negedge clk);
 $fatal(1,"REPLAY_TIMEOUT bytes=%0d",count);
end
always @(posedge clk) begin
 cycle<=cycle+1;
 if(bv) begin $display("BYTE %0d %02x",count,b);count=count+1;end
 if(fs) begin $display("REPLAY_FCS ok=%0d len=%0d bytes=%0d",ok,len,count);$finish;end
end
endmodule