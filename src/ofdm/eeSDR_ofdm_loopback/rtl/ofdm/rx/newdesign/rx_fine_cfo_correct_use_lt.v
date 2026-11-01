module rx_fine_cfo_correct_use_lt #(
    parameter                                       IDEAL_LOOPBACK = 1'b0
) (
// Clock
    input   wire                                        sclk                                        ,
    input   wire                                        reset                                       ,
    input   wire                                        enable                                      ,
    input   wire            [15:0]                      sample_in_i                                 ,
    input   wire            [15:0]                      sample_in_q                                 ,
    input   wire                                        sample_in_valid                             ,
    input   wire                                        second_peak_delay_8s                        ,
    input   wire            [15:0]                      align_lt1_in_i                              ,
    input   wire            [15:0]                      align_lt1_in_q                              ,
    input   wire                                        align_lt1_valid                             ,
    output  reg             [15:0]                      fine_cfo_out_i                              ,
    output  reg             [15:0]                      fine_cfo_out_q                              ,
    output  reg                                         fine_cfo_out_valid
);

    parameter                                       FIXDIV64X2PI = 1335089;
    //2^29*(1/(64*2*pi)

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

    wire                [31:0]                      w_cordic_out;
    wire                                            w_cordic_out_valid;

    wire                [63:0]                      w_mult_out;
    reg                 [4:0]                       r_mult_in_valid_buf;

    wire                [31:0]                      w_angle_out_div64x2pi;
    reg                                             r_angle_out_valid;

    reg         signed  [31:0]                      r_freq_ctrl;
    reg                 [31:0]                      r_phase_addr;
    reg                                             r_phase_addr_valid;
    wire        signed  [15:0]                      w_dds_data_i;
    wire        signed  [15:0]                      w_dds_data_q;
    wire                                            w_dds_data_valid;
    reg                 [31:0]                      r_al_dly0;
    reg                 [31:0]                      r_al_dly1;
    reg                 [31:0]                      r_al_dly2;
    reg                 [31:0]                      r_al_dly3;
    reg                 [31:0]                      r_al_dly4;
    reg                 [31:0]                      r_al_dly5;
    reg                 [31:0]                      r_al_dly6;
    //reg [5:0]                     al_v_buf;
    reg                 [31:0]                      r_al_dly;

    wire                [63:0]                      w_cor_mult_out;
    wire                                            w_cor_mult_out_valid;

    wire                [15:0]                      w_align_lt1_dly_i;
    wire                [15:0]                      w_align_lt1_dly_q;
    wire                                            w_align_lt1_dly_valid;

    //----------------------------------------------------------------
    //Dalay 16 sample
    //latency 1
    //----------------------------------------------------------------

    delay_samples #(
        .DWIDTH                                       (32),
        .DDELAY                                       (16)
    ) u_delay_samples_align (
        .sclk                                         (sclk),
        .enable                                       (1'b1),
        .reset                                        (reset),
        .sample_in                                    ({align_lt1_in_q, align_lt1_in_i}),
        .sample_in_valid                              (align_lt1_valid),
        .sampledelay_out                              ({w_align_lt1_dly_q, w_align_lt1_dly_i}),
        .sampledelay_out_valid                        (w_align_lt1_dly_valid)
    );

    //----------------------------------------------------------------
    //Dalay 64 sample = 1 long sync length
    //latency 1
    //----------------------------------------------------------------

    delay_samples #(
        .DWIDTH                                       (32),
        .DDELAY                                       (64)
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
        .DDELAY                                       (64)
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
        .DDELAY                                       (64)
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
    //actan cordic
    // xilinx ip core
    //fine mode
    //out rad
    //---------------------------------------------------------------
    // A common power-of-two scale preserves atan2 while using the CORDIC's
    // fractional precision even when the ADC supplies only a few codes.
    function [63:0] f_cordic_vector;
        input signed [31:0] vi_in, vq_in;
        reg signed [31:0] vi, vq;
        reg [31:0] occupied;
        integer shift;
        begin
            vi = vi_in;
            vq = vq_in;
            // Remove the redundant sign bit from the joint significance mask.
            // Binary leading-sign detection replaces 32 serial compare/shifts.
            // Complement (not abs) preserves the asymmetric negative boundary:
            // -1 must normalize to -2**29, while +1 becomes +2**28.
            occupied = ((vi ^ {32{vi[31]}}) | (vq ^ {32{vq[31]}})) << 1;
            for (shift = 16; shift > 0; shift = shift / 2) begin
                if ((occupied >> (32-shift)) == 0) begin
                    occupied = occupied << shift;
                    vi = vi << shift;
                    vq = vq << shift;
                end
            end
            // The top 30 signed bits are exactly the old arithmetic-floor
            // normalization. For an empty mask the total shift is 31.
            vi = vi >>> 2;
            vq = vq >>> 2;
            f_cordic_vector = {vq[31:0], vi[31:0]};
        end
    endfunction

    cordic_arctan u_cordic_arctan (
        .aclk                                         (sclk),  // input wire aclk
        .s_axis_cartesian_tvalid                      (second_peak_delay_8s),  // input wire s_axis_cartesian_tvalid
        .s_axis_cartesian_tdata                       (f_cordic_vector(w_sample_delay_avg_out_i, w_sample_delay_avg_out_q)),
        .m_axis_dout_tvalid                           (w_cordic_out_valid),  // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata                            (w_cordic_out)  // output wire [31:0] m_axis_dout_tdata
    );

    //----------------------------------------------------------------
    //(alpha/(64*pi))
    // in fix32_29
    //latency 3
    //----------------------------------------------------------------
    mult_atan2_s32_for_ls u_mult_atan2_s32_for_ls (
        .CLK                                          (sclk),  // input wire CLK
        .A                                            (w_cordic_out),  // input wire [31:0] A
        .B                                            (FIXDIV64X2PI),  // input wire [31:0] B
        .P                                            (w_mult_out)  // output wire [63:0] P
    );

    always @(posedge sclk) begin
        {r_angle_out_valid, r_mult_in_valid_buf} <= {r_mult_in_valid_buf[4:0], w_cordic_out_valid};
    end

    assign w_angle_out_div64x2pi = {w_mult_out[63], w_mult_out[59:58], w_mult_out[57:29]};

    //----------------------------------------------------------------
    //get freq ctrl word 32bit
    //freq_ctrl =(angle_out_div64x2pi/2^29)*2^32
    //this angle_out_div16x2pi value of actual frequency offset
    //e^jn*alhpa
    //latency 1
    //----------------------------------------------------------------

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_freq_ctrl <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (r_angle_out_valid == 1'b1) begin
                r_freq_ctrl <= {w_angle_out_div64x2pi[28:0], 3'b000};
            end
        end
    end
    //----------------------------------------------------------------
    //gen dds
    //e^-jn*alhpa
    //latency 1
    //----------------------------------------------------------------

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_phase_addr <= 'd0;
        end else if (enable == 1'b1 && w_align_lt1_dly_valid == 1'b1) begin
            r_phase_addr <= r_phase_addr - r_freq_ctrl;
            //e^-jn*alpha
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_phase_addr_valid <= 1'b0;
        end
        else if (enable == 1'b1) begin
            r_phase_addr_valid <= w_align_lt1_dly_valid;
        end
    end

    //latency =6
    dds_cfo u_dds_cfo (
        .aclk                                         (sclk),  // input wire aclk
        .aresetn                                      (~reset),  // input wire aresetn
        .s_axis_phase_tvalid                          (r_phase_addr_valid),  // input wire s_axis_phase_tvalid
        .s_axis_phase_tdata                           ({4'd0, r_phase_addr[31:20]}),  // input wire [15:0] s_axis_phase_tdata
        .m_axis_data_tvalid                           (w_dds_data_valid),  // output wire m_axis_data_tvalid
        .m_axis_data_tdata                            ({w_dds_data_q, w_dds_data_i})  // output wire [31:0] m_axis_data_tdata
    );
    //align to phase_addr_valid
    always @(posedge sclk) begin
        r_al_dly <= {w_align_lt1_dly_q, w_align_lt1_dly_i};
    end

    //align to dds_data_valid
    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            //al_v_buf <= 'd0;
            {r_al_dly6, r_al_dly5, r_al_dly4, r_al_dly3, r_al_dly2, r_al_dly1, r_al_dly0} <= 'd0;
        end
        else if (r_phase_addr_valid == 1'b1) begin
            {r_al_dly6, r_al_dly5, r_al_dly4, r_al_dly3, r_al_dly2, r_al_dly1, r_al_dly0} <= {r_al_dly5, r_al_dly4, r_al_dly3, r_al_dly2, r_al_dly1, r_al_dly0, r_al_dly};
        end
    end
    //----------------------------------------------------------------
    //offset signal * e^-jn*alpha
    //latency
    //----------------------------------------------------------------

    complex_multiplier u_mult_correct (
        .aclk                                         (sclk),  // input wire aclk
        .s_axis_a_tvalid                              (w_dds_data_valid),  // input wire s_axis_a_tvalid
        .s_axis_a_tdata                               ({w_dds_data_q, w_dds_data_i}),  // input wire [31:0] s_axis_a_tdata
        .s_axis_b_tvalid                              (w_dds_data_valid),  // input wire s_axis_b_tvalid
        .s_axis_b_tdata                               (r_al_dly5),  // input wire [31:0] s_axis_b_tdata
        .m_axis_dout_tvalid                           (w_cor_mult_out_valid),  // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata                            (w_cor_mult_out)  // output wire [63:0] m_axis_dout_tdata
    );

    // CMPY reduces the 33-bit complex product to 32 bits (one LSB removed).
    // With a Q1.15 DDS, shift by 14 for unity gain. Never discard high bits:
    // the old {sign, product[27:13]} doubled amplitude and wrapped at 32768.
    function [15:0] f_rotate_to_sample;
        input signed [31:0] product;
        reg signed [31:0] sample;
        begin
            sample = product >>> 14;
            if (sample > 32'sd32767) f_rotate_to_sample = 16'h7fff;
            else if (sample < -32'sd32768) f_rotate_to_sample = 16'h8000;
            else f_rotate_to_sample = sample[15:0];
        end
    endfunction

    //output reg

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            fine_cfo_out_valid <= 1'b0;
            fine_cfo_out_i <= 'd0;
            fine_cfo_out_q <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (IDEAL_LOOPBACK == 1'b1) begin
                // Keep the 16-sample alignment delay used by the normal path,
                // but do not apply a quantized phase estimate to an ideal direct
                // loopback.  The latter can move marginal BPSK SIGNAL samples.
                fine_cfo_out_valid <= w_align_lt1_dly_valid;
                fine_cfo_out_i <= w_align_lt1_dly_i;
                fine_cfo_out_q <= w_align_lt1_dly_q;
            end
            else begin
                fine_cfo_out_valid <= w_cor_mult_out_valid;
                fine_cfo_out_i <= f_rotate_to_sample(w_cor_mult_out[31:0]);
                fine_cfo_out_q <= f_rotate_to_sample(w_cor_mult_out[63:32]);
            end
        end
    end

endmodule
