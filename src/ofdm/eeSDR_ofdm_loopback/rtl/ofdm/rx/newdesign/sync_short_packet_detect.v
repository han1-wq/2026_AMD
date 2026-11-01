module sync_short_packet_detect(
//threshold for short preamble detect
//FOR CFO
    input   wire                                        sclk                                        ,
    input   wire                                        reset                                       ,
    input   wire                                        enable                                      ,
    input   wire            [15:0]                      sample_in_i                                 ,
    input   wire            [15:0]                      sample_in_q                                 ,
    input   wire                                        sample_in_valid                             ,
    output  reg                                         short_preamble_detected                     ,
    input   wire            [31:0]                      threshold_neg_pos_value                     ,
    output  reg             [31:0]                      accu_avg_out_i                              ,
    output  reg             [31:0]                      accu_avg_out_q                              ,
    output  reg                                         accu_avg_out_valid
);

    wire                [31:0]                      w_sampledelay_out;
    wire                                            w_sampledelay_out_valid;
    reg                 [31:0]                      r_sampledelay_out_conj;
    reg                                             r_sampledelay_out_conj_valid;
    reg                 [31:0]                      r_sample_in_r;
    reg                 [31:0]                      r_sample_in_rr;
    reg                                             r_sample_in_v_r;
    reg                                             r_sample_in_v_rr;
    wire                                            w_complex_delay_mult_out_valid;
    wire                [31:0]                      w_complex_delay_mult_out_q;
    wire                [31:0]                      w_complex_delay_mult_out_i;
    wire                                            w_sample_delay_avg_out_i_valid;
    wire                [31:0]                      w_sample_delay_avg_out_i;
    wire                                            w_sample_delay_avg_out_q_valid;
    wire                [31:0]                      w_sample_delay_avg_out_q;
    reg                                             r_smp_dly_mag_est_valid_pre2;
    reg                                             r_smp_dly_mag_est_valid_pre1;
    reg                                             r_smp_dly_mag_est_valid;
    reg                 [31:0]                      r_smp_dly_mag_est_abs_i;
    reg                 [31:0]                      r_smp_dly_mag_est_abs_q;
    reg                 [31:0]                      r_smp_dly_mag_est_max;
    reg                 [31:0]                      r_smp_dly_mag_est_min;
    reg                 [31:0]                      r_smp_dly_mag_est;

    //current
    reg                 [31:0]                      r_sample_in_reg;
    reg                 [31:0]                      r_sample_in_conj;
    reg                                             r_sample_in_conj_valid;
    wire                                            w_complex_curr_mult_out_valid;
    wire                [31:0]                      w_complex_curr_mult_out_i;
    wire                [31:0]                      w_complex_curr_mult_out_q;
    wire                                            w_sample_curr_avg_out_i_valid;
    wire                [31:0]                      w_sample_curr_avg_out_i;
    wire                                            w_sample_curr_avg_out_q_valid;
    wire                [31:0]                      w_sample_curr_avg_out_q;
    reg                                             r_smp_curr_mag_est_valid_pre2;
    reg                                             r_smp_curr_mag_est_valid_pre1;
    reg                                             r_smp_curr_mag_est_valid;
    reg                 [31:0]                      r_smp_curr_mag_est_abs_i;
    reg                 [31:0]                      r_smp_curr_mag_est_abs_q;
    reg                 [31:0]                      r_smp_curr_mag_est_max;
    reg                 [31:0]                      r_smp_curr_mag_est_min;
    reg                 [31:0]                      r_smp_curr_mag_est;
    reg                 [31:0]                      r_smp_curr_mag_est_075;

    reg                 [31:0]                      r_min_pos;
    reg                 [31:0]                      r_min_neg;
    // These synchronous clears come from a late magnitude comparison.
    // Fold them into local D logic instead of the slower shared reset pins.
    (* extract_reset = "no" *) reg [31:0] r_pos_cnt;
    (* extract_reset = "no" *) reg [31:0] r_neg_cnt;
    (* extract_reset = "no" *) reg [31:0] r_threshold_cnt;

    // Balanced unsigned comparison: two-bit LUT terms, then byte terms,
    // then one word result. Explicit Boolean leaves avoid a carry chain in
    // front of the detector/counter reset fanout. All cycles are unchanged.
    function automatic f_unsigned_gt32;
        input [31:0] a, b;
        reg [15:0] gt2, eq2;
        reg [3:0] gt8, eq8;
        integer k;
        begin
            for (k = 0; k < 16; k = k + 1) begin
                gt2[k] = (a[2*k+1] && !b[2*k+1]) ||
                    ((a[2*k+1] == b[2*k+1]) && a[2*k] && !b[2*k]);
                eq2[k] = a[2*k +: 2] == b[2*k +: 2];
            end
            for (k = 0; k < 4; k = k + 1) begin
                gt8[k] = gt2[4*k+3] ||
                    (eq2[4*k+3] && gt2[4*k+2]) ||
                    (&eq2[4*k+2 +: 2] && gt2[4*k+1]) ||
                    (&eq2[4*k+1 +: 3] && gt2[4*k]);
                eq8[k] = &eq2[4*k +: 4];
            end
            f_unsigned_gt32 = gt8[3] || (eq8[3] && gt8[2]) ||
                (&eq8[2 +: 2] && gt8[1]) || (&eq8[1 +: 3] && gt8[0]);
        end
    endfunction
    wire                                            w_threshold_exceeded = f_unsigned_gt32(r_threshold_cnt, threshold_neg_pos_value);
    wire                                            w_magnitude_exceeded = f_unsigned_gt32(r_smp_dly_mag_est, r_smp_curr_mag_est_075);

    reg                                             r_smp_dly_mag_est_valid_dly;

    //----------------------------------------------------------------
    //Dalay 16 sample = 1 short sync length
    //latency 1
    //----------------------------------------------------------------

    delay_samples #(  //输入比输出超前一个时钟周期
        .DWIDTH                                       (32),
        .DDELAY                                       (16)
    ) u_delay_samples (
        .sclk                                         (sclk),
        .enable                                       (enable),
        .reset                                        (reset),
        .sample_in                                    ({sample_in_q, sample_in_i}),
        .sample_in_valid                              (sample_in_valid),
        .sampledelay_out                              (w_sampledelay_out),
        .sampledelay_out_valid                        (w_sampledelay_out_valid)
    );

    //----------------------------------------------------------------
    //delay 16 sample conjugate  I+Q->I-Q
    //latency 1
    //----------------------------------------------------------------
    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_sampledelay_out_conj <= 'd0;
            r_sampledelay_out_conj_valid <= 1'b0;
        end
        else if (enable == 1'b1) begin
            r_sampledelay_out_conj_valid <= w_sampledelay_out_valid;
            r_sampledelay_out_conj[31:16] <= (~w_sampledelay_out[31:16]) + 1;
            //-Q
            r_sampledelay_out_conj[15:0] <= w_sampledelay_out[15:0];
            //I
        end
    end

    //----------------------------------------------------------------
    //(delay 16 sample conjugate) complex * (current sample)
    //latency 3
    //----------------------------------------------------------------
    //current sample to align delay 16 sample  sampledelay_out_conj_valid
    always @(posedge sclk) begin
        r_sample_in_r <= {sample_in_q, sample_in_i};
        r_sample_in_rr <= r_sample_in_r;
        {r_sample_in_v_rr, r_sample_in_v_r} <= {r_sample_in_v_r, sample_in_valid};
    end

    complex_multiplier u_mult_delay (
        .aclk                                         (sclk),  // input wire aclk
        .s_axis_a_tvalid                              (r_sampledelay_out_conj_valid),  // input wire s_axis_a_tvalid
        .s_axis_a_tdata                               (r_sampledelay_out_conj),  // input wire [31:0] s_axis_a_tdata
        .s_axis_b_tvalid                              (r_sample_in_v_rr),  // input wire s_axis_b_tvalid
        .s_axis_b_tdata                               (r_sample_in_rr),  // input wire [31:0] s_axis_b_tdata
        .m_axis_dout_tvalid                           (w_complex_delay_mult_out_valid),  // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata                            ({w_complex_delay_mult_out_q, w_complex_delay_mult_out_i})  // output wire [63:0] m_axis_dout_tdata
    );

    //----------------------------------------------------------------
    //accumulation 16 complex result and average
    //latency 1
    //----------------------------------------------------------------

    accum_avg #(
        .DWIDTH                                       (32),
        .DDELAY                                       (16)
    ) u_accum_avg_dly_i (
        .sclk                                         (sclk),
        .enable                                       (enable),
        .reset                                        (reset),
        .sample_in                                    (w_complex_delay_mult_out_i),
        .sample_in_valid                              (w_complex_delay_mult_out_valid),
        .sample_avg_out                               (w_sample_delay_avg_out_i),
        .sample_avg_out_valid                         (w_sample_delay_avg_out_i_valid)
    );

    accum_avg #(
        .DWIDTH                                       (32),
        .DDELAY                                       (16)
    ) u_accum_avg_dly_q (
        .sclk                                         (sclk),
        .enable                                       (enable),
        .reset                                        (reset),
        .sample_in                                    (w_complex_delay_mult_out_q),
        .sample_in_valid                              (w_complex_delay_mult_out_valid),
        .sample_avg_out                               (w_sample_delay_avg_out_q),
        .sample_avg_out_valid                         (w_sample_delay_avg_out_q_valid)
    );

    //----------------------------------------------------------------
    //magnitude - estimator
    // url : http://dspguru.com/dsp/tricks/magnitude-estimator
    //alpha = 1; beta =1/4;
    //avg err = 0.006
    //latency 3
    //---------------------------------------------------------------

    always @(posedge sclk) begin
        r_smp_dly_mag_est_valid_pre2 <= w_sample_delay_avg_out_i_valid;
        r_smp_dly_mag_est_valid_pre1 <= r_smp_dly_mag_est_valid_pre2;
        r_smp_dly_mag_est_valid <= r_smp_dly_mag_est_valid_pre1;
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_smp_dly_mag_est_abs_i <= 'd0;
            r_smp_dly_mag_est_abs_q <= 'd0;
            r_smp_dly_mag_est_max <= 'd0;
            r_smp_dly_mag_est_min <= 'd0;
            r_smp_dly_mag_est <= 'd0;
        end
        else if (enable == 1'b1) begin
            r_smp_dly_mag_est_abs_i <= w_sample_delay_avg_out_i[31] ? (~w_sample_delay_avg_out_i) + 1: w_sample_delay_avg_out_i;
            //abs
            r_smp_dly_mag_est_abs_q <= w_sample_delay_avg_out_q[31] ? (~w_sample_delay_avg_out_q) + 1: w_sample_delay_avg_out_q;
            //abs
            r_smp_dly_mag_est_max <= (r_smp_dly_mag_est_abs_i > r_smp_dly_mag_est_abs_q) ? r_smp_dly_mag_est_abs_i: r_smp_dly_mag_est_abs_q;
            //max
            r_smp_dly_mag_est_min <= (r_smp_dly_mag_est_abs_i > r_smp_dly_mag_est_abs_q) ? r_smp_dly_mag_est_abs_q: r_smp_dly_mag_est_abs_i;
            //min
            r_smp_dly_mag_est <= r_smp_dly_mag_est_max + (r_smp_dly_mag_est_min >> 2);
            //mag_est~= alpha* max + beta*min
        end

    end

    //----------------------------------------------------------------
    //current sample data conjugate I+Q -> I-Q
    //latency 1
    //----------------------------------------------------------------

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_sample_in_conj <= 'd0;
            r_sample_in_conj_valid <= 1'b0;
            r_sample_in_reg <= 'd0;
        end
        else if (enable == 1'b1) begin
            r_sample_in_conj_valid <= sample_in_valid;
            r_sample_in_reg <= {sample_in_q, sample_in_i};
            r_sample_in_conj[31:16] <= (~sample_in_q) + 1;
            //-Q
            r_sample_in_conj[15:0] <= sample_in_i;
            //I
        end
    end

    //----------------------------------------------------------------
    //(current sample conjugate) complex * (current sample)
    //latency 3
    //----------------------------------------------------------------

    complex_multiplier u_mult_current (
        .aclk                                         (sclk),  // input wire aclk
        .s_axis_a_tvalid                              (r_sample_in_conj_valid),  // input wire s_axis_a_tvalid
        .s_axis_a_tdata                               (r_sample_in_conj),  // input wire [31:0] s_axis_a_tdata
        .s_axis_b_tvalid                              (r_sample_in_conj_valid),  // input wire s_axis_b_tvalid
        .s_axis_b_tdata                               (r_sample_in_reg),  // input wire [31:0] s_axis_b_tdata
        .m_axis_dout_tvalid                           (w_complex_curr_mult_out_valid),  // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata                            ({w_complex_curr_mult_out_q, w_complex_curr_mult_out_i})  // output wire [63:0] m_axis_dout_tdata
    );

    //----------------------------------------------------------------
    //accumulation 16 complex result and average
    //latency 1
    //----------------------------------------------------------------

    accum_avg #(
        .DWIDTH                                       (32),
        .DDELAY                                       (16)
    ) u_accum_avg_curr_i (
        .sclk                                         (sclk),
        .enable                                       (enable),
        .reset                                        (reset),
        .sample_in                                    (w_complex_curr_mult_out_i),
        .sample_in_valid                              (w_complex_curr_mult_out_valid),
        .sample_avg_out                               (w_sample_curr_avg_out_i),
        .sample_avg_out_valid                         (w_sample_curr_avg_out_i_valid)
    );

    accum_avg #(
        .DWIDTH                                       (32),
        .DDELAY                                       (16)
    ) u_accum_avg_curr_q (
        .sclk                                         (sclk),
        .enable                                       (enable),
        .reset                                        (reset),
        .sample_in                                    (w_complex_curr_mult_out_q),
        .sample_in_valid                              (w_complex_curr_mult_out_valid),
        .sample_avg_out                               (w_sample_curr_avg_out_q),
        .sample_avg_out_valid                         (w_sample_curr_avg_out_q_valid)
    );

    //----------------------------------------------------------------
    //magnitude - estimator
    // url : http://dspguru.com/dsp/tricks/magnitude-estimator
    //alpha = 1; beta =1/4;
    //avg err = 0.006
    //latency 3
    //---------------------------------------------------------------

    always @(posedge sclk) begin
        r_smp_curr_mag_est_valid_pre2 <= w_sample_curr_avg_out_i_valid;
        r_smp_curr_mag_est_valid_pre1 <= r_smp_curr_mag_est_valid_pre2;
        r_smp_curr_mag_est_valid <= r_smp_curr_mag_est_valid_pre1;
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_smp_curr_mag_est_abs_i <= 'd0;
            r_smp_curr_mag_est_abs_q <= 'd0;
            r_smp_curr_mag_est_max <= 'd0;
            r_smp_curr_mag_est_min <= 'd0;
            r_smp_curr_mag_est <= 'd0;
        end
        else if (enable == 1'b1) begin
            r_smp_curr_mag_est_abs_i <= w_sample_curr_avg_out_i[31] ? (~w_sample_curr_avg_out_i) + 1: w_sample_curr_avg_out_i;
            //abs
            r_smp_curr_mag_est_abs_q <= w_sample_curr_avg_out_q[31] ? (~w_sample_curr_avg_out_q) + 1: w_sample_curr_avg_out_q;
            //abs
            r_smp_curr_mag_est_max <= (r_smp_curr_mag_est_abs_i > r_smp_curr_mag_est_abs_q) ? r_smp_curr_mag_est_abs_i: r_smp_curr_mag_est_abs_q;
            //max
            r_smp_curr_mag_est_min <= (r_smp_curr_mag_est_abs_i > r_smp_curr_mag_est_abs_q) ? r_smp_curr_mag_est_abs_q: r_smp_curr_mag_est_abs_i;
            //min
            r_smp_curr_mag_est <= r_smp_curr_mag_est_max + (r_smp_curr_mag_est_min >> 2);
            //mag_est~= alpha* max + beta*min
        end

    end

    //----------------------------------------------------------------
    //smp_curr_mag_est * 0.75 = (smp_curr_mag_est>>1) + (smp_curr_mag_est>>1);
    //latency 1
    //---------------------------------------------------------------

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_smp_curr_mag_est_075 <= 'd0;
        end
        else if (enable == 1'b1) begin
            r_smp_curr_mag_est_075 <= {1'b0, r_smp_curr_mag_est[31:1]} + {2'd0, r_smp_curr_mag_est[31:2]};
        end
    end

    //----------------------------------------------------------------
    //short sync detect
    //latency
    //---------------------------------------------------------------

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_min_pos <= 'd0;
            r_min_neg <= 'd0;
        end
        else if (enable == 1'b1) begin
            r_min_pos <= (threshold_neg_pos_value >> 2) - 1'b1;
            r_min_neg <= (threshold_neg_pos_value >> 2) - 1'b1;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_pos_cnt <= 'd0;
            r_neg_cnt <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (r_smp_dly_mag_est_valid == 1'b1) begin
                if (w_magnitude_exceeded) begin
                    //检测数据是否有波动
                    if (sample_in_q[15] == 1'b0) begin
                        r_pos_cnt <= r_pos_cnt + 1'b1;
                    end
                    else begin
                        r_neg_cnt <= r_neg_cnt + 1'b1;
                    end
                end
                else begin
                    r_pos_cnt <= 'd0;
                    r_neg_cnt <= 'd0;
                end
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_threshold_cnt <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (r_smp_dly_mag_est_valid == 1'b1) begin
                if (w_magnitude_exceeded) begin
                    if (w_threshold_exceeded) begin
                        //检测阈值持续时间
                        r_threshold_cnt <= 'd0;
                    end
                    else begin
                        r_threshold_cnt <= r_threshold_cnt + 1'b1;
                    end
                end
                else begin
                    r_threshold_cnt <= 'd0;
                end
            end
        end
        else
        begin
            r_threshold_cnt <= 'd0;
        end
    end

    reg                                             r_nums_cnt_suc_flag;
    //add

    always @(posedge sclk) begin
        // Unsigned count > (min-1) is count >= min, except that min=0
        // wraps the old subtraction to 0xffffffff and must always fail.
        // Remove the subtract/compare carry cascade without adding latency.
        r_nums_cnt_suc_flag <= (r_min_pos != 0 && r_pos_cnt >= r_min_pos) &
        (r_min_neg != 0 && r_neg_cnt >= r_min_neg);
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            short_preamble_detected <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (r_smp_dly_mag_est_valid == 1'b1) begin
                if (w_magnitude_exceeded) begin
                    if (w_threshold_exceeded) begin
                        short_preamble_detected <= r_nums_cnt_suc_flag;
                        //同时满足这三个条件分组检测完成 检测成功信号要在复位之后才能被重置为0
                    end
                    else begin
                        short_preamble_detected <= 1'b0;
                    end
                end
                else begin
                    short_preamble_detected <= 1'b0;
                end
            end
        end
        else
        begin
            short_preamble_detected <= 1'b0;
        end
    end

    //----------------------------------------------------------------
    //for cfo get angle
    //latency  1
    //---------------------------------------------------------------

    always @(posedge sclk) begin
        r_smp_dly_mag_est_valid_dly <= r_smp_dly_mag_est_valid;
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            accu_avg_out_valid <= 1'b0;
            accu_avg_out_i <= 'd0;
            accu_avg_out_q <= 'd0;
        end
        else if (short_preamble_detected == 1'b1 && r_smp_dly_mag_est_valid_dly == 1'b1) begin
            accu_avg_out_valid <= 1'b1;
            accu_avg_out_i <= w_sample_delay_avg_out_i;
            accu_avg_out_q <= w_sample_delay_avg_out_q;
        end
        else begin
            accu_avg_out_valid <= 1'b0;
            accu_avg_out_i <= 'd0;
            accu_avg_out_q <= 'd0;
        end
    end

    //test

    reg                                             r_corr_ok;

    always @(posedge sclk) begin
        r_corr_ok <= w_magnitude_exceeded;
    end

endmodule
