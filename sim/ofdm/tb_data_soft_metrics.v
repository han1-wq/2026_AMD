`timescale 1ns / 1ps
module tb_data_soft_metrics #(parameter CW = 25, DW = 51);
    reg clk = 0;
    always #5 clk = ~clk;
    reg rst = 1, params_valid = 0, data_valid = 0, ready = 0;
    reg [5:0] rate;
    reg [1:0] modulation, code_rate;
    reg signed [CW-1:0] hi, hq;
    reg signed [DW-1:0] yi, yq;
    wire [2:0] metric, a, b;
    wire valid, pair_valid;
    wire [1:0] erased;
    reg [2:0] expected [0:287];
    integer rates [0:7];
    integer test_id, n, axis, bit_id, bpsc, cbps, dbps;
    integer seen, pairs, punctured, cycle, checked = 0;
    integer ia, ib, ea, eb, idx;
    reg stalled;
    reg [7:0] held;
    real x, mag, distance_ref, power;
    integer confidence, hard, val;
    ofdm_data_frontend #(.CSI_WIDTH(CW), .DATA_WIDTH(DW)) dut (
        .clk(clk), .rst(rst), .params_valid(params_valid), .params_ok(1'b1),
        .rate(rate), .modulation(modulation), .code_rate(code_rate), .n_symbols(12'd1),
        .csi_i(hi), .csi_q(hq), .data_i(yi), .data_q(yq), .data_valid(data_valid),
        .demod_bit(metric), .demod_valid(valid), .decoded_a(a), .decoded_b(b),
        .erased(erased), .decoded_valid(pair_valid), .decoded_ready(ready)
    );
    function integer interleave;
        input integer k;
        integer i, s;
        begin
            s = bpsc/2;
            if (s == 0) s = 1;
            i = (cbps/16)*(k%16)+k/16;
            interleave = s*(i/s)+(i+cbps-(16*i)/cbps)%s;
        end
    endfunction
    always @(posedge clk) begin
        if (rst) begin
            seen = 0; pairs = 0; punctured = 0; stalled = 0;
        end else begin
            if (valid) begin
                if (seen >= cbps || metric !== expected[seen])
                    $fatal(1, "METRIC_FAIL rate=%0d bit=%0d got=%0d expected=%0d",
                           rate, seen, metric, expected[seen]);
                seen = seen+1;
            end
            if (stalled && (!pair_valid || {erased,b,a} !== held))
                $fatal(1, "STALL_FAIL");
            stalled = pair_valid && !ready;
            held = {erased,b,a};
            if (pair_valid && ready) begin
                ea = code_rate == 2 && pairs%3 == 2;
                eb = (code_rate == 1 && pairs%2 == 1) ||
                     (code_rate == 2 && pairs%3 == 1);
                ia = interleave(punctured);
                ib = interleave(punctured + (ea ? 0 : 1));
                if (pairs >= dbps || erased !== {eb[0],ea[0]} ||
                    a !== (ea ? 3'd3 : expected[ia]) ||
                    b !== (eb ? 3'd3 : expected[ib]))
                    $fatal(1, "PAIR_FAIL rate=%0d pair=%0d a=%0d b=%0d erased=%b",
                           rate, pairs, a, b, erased);
                punctured = punctured + 2-ea-eb;
                pairs = pairs+1;
                checked = checked+1;
            end
        end
    end
    initial begin
        rates[0]=6; rates[1]=9; rates[2]=12; rates[3]=18;
        rates[4]=24; rates[5]=36; rates[6]=48; rates[7]=54;
        for (test_id=0; test_id<16; test_id=test_id+1) begin
            @(negedge clk); rst=1; data_valid=0; params_valid=0; ready=0;
            repeat (3) @(negedge clk);
            rate=rates[test_id%8]; modulation=(test_id%8)/2;
            code_rate=rate==48 ? 1 : (test_id%2 ? 2 : 0);
            bpsc=modulation==0 ? 1 : modulation==1 ? 2 : modulation==2 ? 4 : 6;
            cbps=48*bpsc; dbps=4*rate;
            rst=0;
            // Parameters arrive after samples in alternating packets.
            params_valid=!(test_id%2);
            @(negedge clk); params_valid=0;
            for (n=0; n<48; n=n+1) begin
                // Include signed CSI, zero channel, all QAM levels and boundaries.
                hi=(n==0 ? 0 : (n%2 ? -256 : 256));
                hq=(n==0 ? 0 : (test_id>=8 ? -128 : 128));
                if (CW>16 && test_id>=8) begin hi=hi*256; hq=hq*256; end
                power=$itor(hi)*$itor(hi)+$itor(hq)*$itor(hq);
                for (axis=0; axis<2; axis=axis+1) begin
                    x=((n*7+axis*13)%65-32)/4.0;
                    if (modulation==3) x=x/6.480712890625;
                    else if (modulation==2) x=x/3.162353515625;
                    if (axis==0) yi=$rtoi(x*power/2.0);
                    else yq=$rtoi(x*power/2.0);
                    // Wide tests exceed 32-bit $rtoi: convert via real assignment.
                    if (CW>16 && test_id>=8) begin
                        if (axis==0) yi=x*power/2.0;
                        else yq=x*power/2.0;
                    end
                    x=axis==0 ? $itor(yi) : $itor(yq);
                    if (CW>16 && test_id>=8) begin
                        if (axis==0) x=yi; else x=yq;
                    end
                    mag=x<0 ? -x : x;
                    for (bit_id=0; bit_id<(bpsc==1 ? 1 : bpsc/2); bit_id=bit_id+1) begin
                        if (bit_id==0) begin hard=x>=0; distance_ref=mag*53090.0; end
                        else if (modulation==2) begin hard=mag*25906.0<power*8192.0; distance_ref=0; end
                        else if (bit_id==1) begin
                            hard=mag*53090.0<power*16384.0;
                            distance_ref=mag*53090.0-power*16384.0;
                        end else begin
                            hard=mag*53090.0>=power*8192.0 && mag*53090.0<power*24576.0;
                            distance_ref=mag*53090.0-power*8192.0;
                            if (distance_ref<0) distance_ref=-distance_ref;
                            x=mag*53090.0-power*24576.0;
                            if (x<0) x=-x;
                            if (x<distance_ref) distance_ref=x;
                        end
                        if (distance_ref<0) distance_ref=-distance_ref;
                        confidence=0;
                        if (power>0) begin
                            if (distance_ref>=power*2048.0) confidence=1;
                            if (distance_ref>=power*4096.0) confidence=2;
                            if (distance_ref>=power*6144.0) confidence=3;
                        end
                        val=modulation==3 ? (hard ? 4+confidence : 3-confidence) : (hard ? 7 : 0);
                        idx=n*bpsc+axis*(bpsc/2)+bit_id;
                        if (bpsc!=1 || axis==0) expected[idx]=val;
                    end
                end
                data_valid=1;
                @(negedge clk);
                if (n%5==0) begin data_valid=0; @(negedge clk); end
            end
            data_valid=0; params_valid=1;
            @(negedge clk); params_valid=0;
            cycle=0;
            while (pairs<dbps && cycle<2000) begin
                ready=cycle%7>2;
                @(negedge clk); cycle=cycle+1;
            end
            if (pairs!=dbps || seen!=cbps || punctured!=cbps) $fatal(1,"COUNT_FAIL");
            ready=1;
            repeat (8) @(negedge clk);
        end
        $display("DATA_SOFT_METRICS_PASS CW=%0d DW=%0d pairs=%0d", CW, DW, checked);
        $finish;
    end
    initial begin #1000000; $fatal(1,"TIMEOUT"); end
endmodule