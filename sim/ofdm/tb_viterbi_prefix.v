`timescale 1ns / 1ps
// Uses the generated Vivado Viterbi IP (no behavioral decoder substitute).
module tb_viterbi_prefix;
    reg clk = 0, rst = 1, valid = 0, params_valid = 0;
    always #5 clk = ~clk;
    reg [2:0] a = 0, b = 0;
    reg [1:0] erased = 0, code_rate = 0;
    reg [5:0] rate = 6;
    wire ready, decoded, decoded_valid;
    reg expected [0:647];
    reg [2:0] ma [0:647], mb [0:647];
    reg [1:0] erasures [0:647];
    reg [6:0] encoder;
    reg [15:0] prbs;
    integer rates [0:7];
    integer test_id, n, count, seen = 0, checked = 0, cycles;
    reg pa, pb;
    viterbi_decoders #(.DATA_STREAM(1)) dut (
        .clk(clk), .rst(rst),
        .bpsk_decoder_data_in_valid(valid),
        .bpsk_decoder_data_in_chnl_0(a), .bpsk_decoder_data_in_chnl_1(b),
        .qam64_decoder_data_in_valid(1'b0),
        .qam64_decoder_data_in_chnl_0(3'd0), .qam64_decoder_data_in_chnl_1(3'd0),
        .bpsk_decoder_data_out_valid(decoded_valid), .bpsk_decoder_data_out(decoded),
        .qam64_decoder_data_out_valid(), .qam64_decoder_data_out(),
        .data_field_param_gain_stb(params_valid), .data_field_param_gain_ok(1'b1),
        .data_field_ofdm_nums(12'd3), .data_field_rate(rate),
        .data_field_modulation(2'd0), .data_field_conv_code_rate(code_rate),
        .data_erasures(erased), .data_ready(ready)
    );
    always @(posedge clk) begin
        if (rst) seen = 0;
        else if (decoded_valid) begin
            if (seen >= count || decoded !== expected[seen])
                $fatal(1, "VITERBI_PREFIX_FAIL test=%0d rate=%0d bit=%0d got=%b expected=%b",
                       test_id, rate, seen, decoded, expected[seen]);
            seen = seen + 1;
            checked = checked + 1;
        end
    end
    initial begin
        rates[0]=6; rates[1]=9; rates[2]=12; rates[3]=18;
        rates[4]=24; rates[5]=36; rates[6]=48; rates[7]=54;
        for (test_id=0; test_id<16; test_id=test_id+1) begin
            @(negedge clk); rst=1; valid=0; params_valid=0;
            repeat (8) @(negedge clk);
            rate=rates[test_id%8]; count=12*rate;
            code_rate=rate==48 ? 1 : (test_id%2 ? 2 : 0);
            encoder=0; prbs=16'hb39d;
            for (n=0; n<count; n=n+1) begin
                expected[n]=n<count-6 ? prbs[0] : 0;
                prbs={prbs[14:0],prbs[15]^prbs[13]^prbs[12]^prbs[10]};
                encoder={encoder[5:0],expected[n]};
                // Newest bit is at bit zero: reverse the IP's octal
                // polynomial notation, matching the transmitter shift order.
                pa=^(encoder & 7'b1101101); pb=^(encoder & 7'b1001111);
                // Exercise all eight offset-binary confidence codes.
                ma[n]=pa ? 4+n%4 : 3-n%4;
                mb[n]=pb ? 4+(n+1)%4 : 3-(n+1)%4;
                erasures[n][0]=code_rate==2 && n%3==2;
                erasures[n][1]=(code_rate==1 && n%2==1) || (code_rate==2 && n%3==1);
                // Ambiguous initial observation: known encoder history and
                // subsequent parity must recover the very first decoded bit.
                if (test_id>=8 && n==0) begin ma[n]=3; mb[n]=4; end
            end
            rst=0; params_valid=1;
            @(negedge clk); params_valid=0;
            for (n=0; n<count; n=n+1) begin
                a=ma[n]; b=mb[n]; erased=erasures[n]; valid=1;
                @(posedge clk);
                while (!ready) @(posedge clk);
                @(negedge clk); valid=0;
                if (test_id%2) repeat (n%5) @(negedge clk);
            end
            cycles=0;
            while (seen<count && cycles<4000) begin
                @(negedge clk); cycles=cycles+1;
            end
            if (seen!=count) $fatal(1, "VITERBI_PREFIX_TIMEOUT rate=%0d seen=%0d expected=%0d",rate,seen,count);
            repeat (300) @(negedge clk);
            if (ready) $fatal(1, "VITERBI_PREFIX_EXTRA_INPUT");
        end
        $display("VITERBI_PREFIX_PASS frames=16 bits=%0d",checked);
        $finish;
    end
    initial begin
        #2000000;
        $fatal(1, "VITERBI_PREFIX_GLOBAL_TIMEOUT");
    end
endmodule