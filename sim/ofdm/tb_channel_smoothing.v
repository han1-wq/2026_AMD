`timescale 1ns / 1ps
module tb_channel_smoothing #(parameter SMOOTH = 1);
    reg clk = 0;
    always #5 clk = ~clk;
    reg reset = 1, valid = 0;
    reg signed [22:0] si = 0, sq = 0;
    wire signed [24:0] hi, hq;
    wire signed [50:0] yi, yq;
    wire hv, yv;
    localparam [51:0] LT = 52'b0011001010000001100101000001100101011111001101010000;
    reg signed [63:0] ref_i [0:51], ref_q [0:51];
    reg signed [63:0] smooth_i [0:51], smooth_q [0:51];
    reg signed [63:0] want_i, want_q, vi, vq;
    integer profile, n, k, j, wt, half_lo, half_hi, hcount = 0, ycount = 0, checked = 0;
    rx_estimate_channel_info #(.CHANNEL_SMOOTH(SMOOTH)) dut (
        .sclk(clk), .reset(reset), .enable(1'b1),
        .sample_in_i(si), .sample_in_q(sq), .sample_in_valid(valid),
        .h_csi_out_i(hi), .h_csi_out_q(hq), .h_csi_out_valid(hv),
        .channel_data_i(yi), .channel_data_q(yq), .channel_data_valid(yv)
    );
    always @(posedge clk) begin
        if (reset) begin hcount = 0; ycount = 0; end
        else begin
            if (hv) begin
                if (hcount >= 52 || hi !== smooth_i[hcount][24:0] || hq !== smooth_q[hcount][24:0])
                    $fatal(1, "CSI_FAIL profile=%0d bin=%0d got=(%0d,%0d) expected=(%0d,%0d)",
                           profile, hcount, hi, hq, smooth_i[hcount], smooth_q[hcount]);
                hcount = hcount + 1;
            end
            if (yv) begin
                vi = ycount*101-3000; vq = 2000-ycount*73;
                want_i = vi*smooth_i[ycount] + vq*smooth_q[ycount];
                want_q = vq*smooth_i[ycount] - vi*smooth_q[ycount];
                if (ycount >= 52 || yi !== want_i[50:0] || yq !== want_q[50:0])
                    $fatal(1, "EQUALIZER_FAIL profile=%0d bin=%0d", profile, ycount);
                ycount = ycount + 1; checked = checked + 1;
            end
        end
    end
    initial begin
        for (profile=0; profile<4; profile=profile+1) begin
            @(negedge clk); reset=1; valid=0;
            repeat (12) @(negedge clk);
            for (n=0; n<52; n=n+1) begin
                case (profile)
                    0: begin ref_i[n]=1234; ref_q[n]=-987; end
                    1: begin ref_i[n]=n<26 ? 100000+n*300 : -300000+n*500;
                             ref_q[n]=n<26 ? -200000+n*500 : 400000-n*700; end
                    2: begin ref_i[n]=n%2 ? 4194302 : -4194302;
                             ref_q[n]=n%3 ? -4194302 : 4194302; end
                    3: begin ref_i[n]=(n*1777)%9999-5000; ref_q[n]=(n*1337)%7777-3333; end
                endcase
                // Sum of two LTFs; the second differs by a small signed term.
                ref_i[n]=2*ref_i[n]+1; ref_q[n]=2*ref_q[n]-1;
            end
            for (n=0; n<52; n=n+1) begin
                smooth_i[n]=0; smooth_q[n]=0;
                half_lo=n<26 ? 0 : 26; half_hi=n<26 ? 25 : 51;
                for (k=-2; k<=2; k=k+1) begin
                    j=n+k;
                    if (j<half_lo) j=half_lo;
                    if (j>half_hi) j=half_hi;
                    wt=k==0 ? 6 : ((k==1 || k==-1) ? 4 : 1);
                    smooth_i[n]=smooth_i[n]+wt*ref_i[j];
                    smooth_q[n]=smooth_q[n]+wt*ref_q[j];
                end
                smooth_i[n]=SMOOTH ? smooth_i[n]>>>4 : ref_i[n];
                smooth_q[n]=SMOOTH ? smooth_q[n]>>>4 : ref_q[n];
            end
            reset=0;
            for (k=0; k<2; k=k+1) begin
                for (n=0; n<52; n=n+1) begin
                    vi=(ref_i[n]-1)/2+k; vq=(ref_q[n]+1)/2-k;
                    si=LT[51-n] ? -vi : vi; sq=LT[51-n] ? -vq : vq;
                    valid=1;
                    @(negedge clk);
                    if (n%7==0) begin valid=0; @(negedge clk); end
                end
                valid=0;
                repeat (16) @(negedge clk);
            end
            for (n=0; n<52; n=n+1) begin
                si=n*101-3000; sq=2000-n*73; valid=1;
                @(negedge clk);
                if (n%3==0) begin valid=0; @(negedge clk); end
            end
            valid=0;
            repeat (20) @(negedge clk);
            if (hcount!=52 || ycount!=52) $fatal(1,"CHANNEL_COUNT_FAIL");
        end
        $display("CHANNEL_SMOOTHING_PASS smooth=%0d carriers=%0d",SMOOTH,checked);
        $finish;
    end
    initial begin #100000; $fatal(1,"TIMEOUT"); end
endmodule