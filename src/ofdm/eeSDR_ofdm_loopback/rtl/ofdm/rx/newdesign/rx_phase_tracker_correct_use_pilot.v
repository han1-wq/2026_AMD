`define WRITE_TEST_FILE 1
module rx_phase_tracker_correct_use_pilot #(parameter CSI_WIDTH = 16, DATA_WIDTH = 32) (
    input   wire                                        sclk                                        ,
    input   wire                                        enable                                      ,
    input   wire                                        reset                                       ,
    input   wire            [CSI_WIDTH-1:0]                      h_csi_i                                     ,
    input   wire            [CSI_WIDTH-1:0]                      h_csi_q                                     ,
    input   wire                                        h_csi_valid                                 ,
    input   wire            [DATA_WIDTH-1:0]                      channel_data_i                              ,
    input   wire            [DATA_WIDTH-1:0]                      channel_data_q                              ,
    input   wire                                        channel_data_valid                          ,
    output  wire            [CSI_WIDTH-1:0]                      signal_csi_i                                ,
    output  wire            [CSI_WIDTH-1:0]                      signal_csi_q                                ,
    output  wire                                        signal_csi_valid                            ,
    output  wire            [DATA_WIDTH-1:0]                      signal_chnl_out_i                           ,
    output  wire            [DATA_WIDTH-1:0]                      signal_chnl_out_q                           ,
    output  wire                                        signal_chnl_out_valid                       ,
    output  wire            [CSI_WIDTH-1:0]                      data_csi_i                                  ,
    output  wire            [CSI_WIDTH-1:0]                      data_csi_q                                  ,
    output  wire                                        data_csi_valid                              ,
    output  wire            [DATA_WIDTH-1:0]                      data_chnl_out_i                             ,
    output  wire            [DATA_WIDTH-1:0]                      data_chnl_out_q                             ,
    output  wire                                        data_chnl_out_valid
);

    parameter                                       FIXDIVPI2 = 32'd333772;
    //(2^21/(2*3.1415926)) FIX32_21
    //0 is plus 1 is neg
    parameter                                       S = 127'b1111111000111011000101001011111010101000010110111100111001010110011000001101101011101000110010001000000100100110100111101110000;

    reg                 [5:0]                       r_h_csi_cnt;
    reg                                             r_h_csi_wr_en;
    reg                 [2*CSI_WIDTH-1:0]                      r_h_csi_wr_data;
    reg                 [5:0]                       r_channel_cnt;
    reg                                             r_channel_wr_en;
    reg                 [2*DATA_WIDTH-1:0]                      r_channel_wr_data;
    reg                 [2*DATA_WIDTH-1:0]                      r_pilot1234;
    reg                 [2*DATA_WIDTH-1:0]                      r_pilot1234_t;
    reg                 [126:0]                     r_shift_p;
    reg                                             r_channel_data_valid_t;
    wire        signed  [DATA_WIDTH-1:0]                      w_neg_channel_data_q;
    wire        signed  [DATA_WIDTH-1:0]                      w_neg_channel_data_i;
    reg                                             r_calc_phase_en;
    reg                                             r_calc_phase_en_t;
    wire                                            w_phase_valid;
    wire        signed  [31:0]                      w_phase;
    reg                 [1:0]                       r_phase_cnt;
    reg         signed  [31:0]                      r_phase_1;
    reg         signed  [31:0]                      r_phase_2;
    reg         signed  [31:0]                      r_phase_3;
    reg         signed  [31:0]                      r_phase_4;
    reg                                             r_calc_phase_avg_en;
    wire        signed  [33:0]                      w_sum_phase;
    reg         signed  [31:0]                      r_avg_phase_beta;
    wire        signed  [33:0]                      w_p2_plus_3p1;
    reg         signed  [33:0]                      r_sm_p1p2;
    wire        signed  [33:0]                      w_p3_plus_3p4;
    reg         signed  [33:0]                      r_sm_p3p4;
    reg         signed  [33:0]                      r_sm_p1p2p3p4;
    reg         signed  [33:0]                      r_sm_sita;
    reg         signed  [33:0]                      r_symbol_slope;
    reg         signed  [33:0]                      r_sm_sita_negx26;
    reg         signed  [33:0]                      r_sm_negx26_p_avg;
    reg                                             r_avg_phase_valid;
    reg                                             r_calc_sm_sita_en1;
    reg                                             r_calc_sm_sita_en2;
    reg                                             r_sm_sita_valid;
    reg                                             r_sm_sita_negx26_v;
    reg                                             r_sm_negx26_p_avg_v;
    reg                                             r_freq_offset_valid;
    reg                 [5:0]                       r_freq_offset_cnt;
    reg                                             r_add_double_flag;
    reg         signed  [39:0]                      r_dds_phase;
    wire                [63:0]                      w_ram_addr;
    reg                 [5:0]                       r_mult_dly_flag;
    wire                                            w_ram_addr_valid;
    wire        signed  [11:0]                      w_neg_ram_addr;
    wire        signed  [31:0]                      w_dds_amp;
    wire                                            w_dds_amp_valid;
    wire                                            w_rd_chnl_fifo_en;
    wire        signed  [2*DATA_WIDTH-1:0]                      w_rd_chnl_fifo_data;
    wire        signed  [2*DATA_WIDTH-1:0]                      w_comp_mult_out_data;
    wire                                            w_comp_mult_out_valid;
    reg                                             r_signal_chnl_out_valid_t;
    reg                                             r_data_frame_flag;
    wire                                            w_rd_csi_fifo_en;
    wire        signed  [2*CSI_WIDTH-1:0]                      w_rd_csi_fifo_data;

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_h_csi_cnt <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (h_csi_valid == 1'b1 && r_h_csi_cnt != 'd51) begin
                r_h_csi_cnt <= r_h_csi_cnt + 1'b1;
            end
            else if (h_csi_valid == 1'b1 && r_h_csi_cnt == 'd51) begin
                r_h_csi_cnt <= 'd0;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_h_csi_wr_en <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (h_csi_valid == 1'b1 && (r_h_csi_cnt == 'd5 || r_h_csi_cnt == 'd19 || r_h_csi_cnt == 'd32 || r_h_csi_cnt == 'd46)) begin
                r_h_csi_wr_en <= 1'b0;
            end
            else if (h_csi_valid == 1'b1) begin
                r_h_csi_wr_en <= 1'b1;
            end
            else begin
                r_h_csi_wr_en <= 1'b0;
            end
        end
    end

    always @(posedge sclk) begin
        r_h_csi_wr_data <= {h_csi_q, h_csi_i};
    end

    pilot_stream_fifo #(
        .WIDTH                                        (2*CSI_WIDTH)) u_sfifo_64x32_csi (
        .clk                                          (sclk),  // input wire clk
        .srst                                         (reset),  // input wire srst
        .din                                          (r_h_csi_wr_data),  // input wire [31:0] din
        .wr_en                                        (r_h_csi_wr_en),  // input wire wr_en
        .rd_en                                        (w_rd_csi_fifo_en),  // input wire rd_en
        .dout                                         (w_rd_csi_fifo_data),  // output wire [31:0] dout
        .full                                         (),  // output wire full
        .empty                                        ()  // output wire empty
    );

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_channel_cnt <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (channel_data_valid == 1'b1 && r_channel_cnt != 'd51) begin
                r_channel_cnt <= r_channel_cnt + 1'b1;
            end
            else if (channel_data_valid == 1'b1 && r_channel_cnt == 'd51) begin
                r_channel_cnt <= 'd0;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_channel_wr_en <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (channel_data_valid == 1'b1 && (r_channel_cnt == 'd5 || r_channel_cnt == 'd19 || r_channel_cnt == 'd32 || r_channel_cnt == 'd46)) begin
                r_channel_wr_en <= 1'b0;
            end
            else if (channel_data_valid == 1'b1) begin
                r_channel_wr_en <= 1'b1;
            end
            else begin
                r_channel_wr_en <= 1'b0;
            end
        end
    end

    always @(posedge sclk) begin
        // Keep the equalizer product intact until after phase rotation.
        r_channel_wr_data <= {channel_data_q, channel_data_i};
    end

    pilot_stream_fifo #(
        .WIDTH                                        (2*DATA_WIDTH)) u_sfifo_64x64_channel (
        .clk                                          (sclk),  // input wire clk
        .srst                                         (reset),  // input wire srst
        .din                                          (r_channel_wr_data),  // input wire [63:0] din
        .wr_en                                        (r_channel_wr_en),  // input wire wr_en
        .rd_en                                        (w_rd_chnl_fifo_en),  // input wire rd_en
        .dout                                         (w_rd_chnl_fifo_data),  // output wire [63:0] dout
        .full                                         (),  // output wire full
        .empty                                        ()  // output wire empty
    );

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_channel_data_valid_t <= 1'b0;
        end
        else if (enable == 1'b1) begin
            r_channel_data_valid_t <= channel_data_valid;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_shift_p <= S;
        end
        else if (r_channel_data_valid_t == 1'b1 && channel_data_valid == 1'b0) begin
            r_shift_p <= {r_shift_p[0], r_shift_p[126:1]};
        end
    end

    assign w_neg_channel_data_q = (~channel_data_q) + 1;
    assign w_neg_channel_data_i = (~channel_data_i) + 1;

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_pilot1234 <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (channel_data_valid == 1'b1 && (r_channel_cnt == 'd5 || r_channel_cnt == 'd19 || r_channel_cnt == 'd32)) begin
                if (r_shift_p[0] == 1'b0) begin
                    //[111-1]
                    r_pilot1234 <= {channel_data_q, channel_data_i};
                end
                else begin
                    //[---1]
                    r_pilot1234 <= {w_neg_channel_data_q, w_neg_channel_data_i};
                end

            end
            else if (channel_data_valid == 1'b1 && r_channel_cnt == 'd46) begin
                if (r_shift_p[0] == 1'b1) begin
                    //[---1]
                    r_pilot1234 <= {channel_data_q, channel_data_i};
                end
                else begin
                    //[111-]
                    r_pilot1234 <= {w_neg_channel_data_q, w_neg_channel_data_i};
                end
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_calc_phase_en <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (channel_data_valid == 1'b1 && (r_channel_cnt == 'd5 || r_channel_cnt == 'd19 || r_channel_cnt == 'd32 || r_channel_cnt == 'd46)) begin
                r_calc_phase_en <= 1'b1;
            end
            else begin
                r_calc_phase_en <= 1'b0;
            end
        end
    end

    always @(posedge sclk) begin
        r_calc_phase_en_t <= r_calc_phase_en;
        r_pilot1234_t <= r_pilot1234;
    end
    //phase FIX32_29
    localparam integer LP_NORM_WIDTH = 1 << $clog2(DATA_WIDTH);
    function [63:0] f_cordic_vector;
        input [2*DATA_WIDTH-1:0] vector;
        reg signed [LP_NORM_WIDTH-1:0] vi, vq;
        reg [LP_NORM_WIDTH-1:0] occupied;
        integer shift;
        begin
            vi = $signed(vector[DATA_WIDTH-1:0]);
            vq = $signed(vector[2*DATA_WIDTH-1:DATA_WIDTH]);
            // Joint leading-sign detection, in log2(width) constant-shift
            // stages rather than DATA_WIDTH+29 dependent compare/shifts.
            // Complementing negatives retains the old -2**29 boundary.
            occupied = ((vi ^ {LP_NORM_WIDTH{vi[LP_NORM_WIDTH-1]}}) |
                        (vq ^ {LP_NORM_WIDTH{vq[LP_NORM_WIDTH-1]}})) << 1;
            for (shift = LP_NORM_WIDTH/2; shift > 0; shift = shift / 2) begin
                if ((occupied >> (LP_NORM_WIDTH-shift)) == 0) begin
                    occupied = occupied << shift;
                    vi = vi << shift;
                    vq = vq << shift;
                end
            end
            vi = vi >>> (LP_NORM_WIDTH-30);
            vq = vq >>> (LP_NORM_WIDTH-30);
            f_cordic_vector = {vq[31:0], vi[31:0]};
        end
    endfunction

    cordic_arctan_coarse u_cordic_arctan_coarse_use_pilot (
        .aclk                                         (sclk),  // input wire aclk
        .s_axis_cartesian_tvalid                      (r_calc_phase_en_t),  // input wire s_axis_cartesian_tvalid
        .s_axis_cartesian_tdata                       (f_cordic_vector(r_pilot1234_t)),  // input wire [63:0] s_axis_cartesian_tdata
        .m_axis_dout_tvalid                           (w_phase_valid),  // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata                            (w_phase)  // output wire [31:0] m_axis_dout_tdata FIX32_29
    );

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_phase_cnt <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (w_phase_valid == 1'b1 && r_phase_cnt == 'd3) begin
                r_phase_cnt <= 'd0;
            end
            else if (w_phase_valid == 1'b1) begin
                r_phase_cnt <= r_phase_cnt + 1'b1;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_phase_1 <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (w_phase_valid == 1'b1 && r_phase_cnt == 'd0) begin
                r_phase_1 <= w_phase;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_phase_2 <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (w_phase_valid == 1'b1 && r_phase_cnt == 'd1) begin
                r_phase_2 <= w_phase;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_phase_3 <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (w_phase_valid == 1'b1 && r_phase_cnt == 'd2) begin
                r_phase_3 <= w_phase;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_phase_4 <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (w_phase_valid == 1'b1 && r_phase_cnt == 'd3) begin
                r_phase_4 <= w_phase;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_calc_phase_avg_en <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (w_phase_valid == 1'b1 && r_phase_cnt == 'd3) begin
                r_calc_phase_avg_en <= 1'b1;
            end
            else begin
                r_calc_phase_avg_en <= 1'b0;
            end
        end
    end
    //fix34_29
    assign w_sum_phase = {{2 {r_phase_1[31]}}, r_phase_1} + {{2 {r_phase_2[31]}}, r_phase_2} + {{2 {r_phase_3[31]}}, r_phase_3} + {{2 {r_phase_4[31]}}, r_phase_4};
    //fix32_29
    always @(posedge sclk) begin
        r_avg_phase_beta <= w_sum_phase >>> 2;
    end

    //fix34_29
    assign w_p2_plus_3p1 = {r_phase_1[31], r_phase_1, 1'b0} + {{2 {r_phase_1[31]}}, r_phase_1} + {{2 {r_phase_2[31]}}, r_phase_2};
    always @(posedge sclk) begin
        r_sm_p1p2 <= w_p2_plus_3p1;
    end

    assign w_p3_plus_3p4 = {r_phase_4[31], r_phase_4, 1'b0} + {{2 {r_phase_4[31]}}, r_phase_4} + {{2 {r_phase_3[31]}}, r_phase_3};
    always @(posedge sclk) begin
        r_sm_p3p4 <= w_p3_plus_3p4;
    end

    always @(posedge sclk) begin
        r_sm_p1p2p3p4 <= r_sm_p3p4 - r_sm_p1p2;
    end

    always @(posedge sclk) begin
        r_sm_sita <= (r_sm_p1p2p3p4 >>> 7) - (r_sm_p1p2p3p4 >>> 11) - (r_sm_p1p2p3p4 >>> 12);
    end

    always @(posedge sclk) begin
        r_sm_sita_negx26 <= (~ ( (r_sm_sita <<< 4) + (r_sm_sita <<< 3) + (r_sm_sita <<< 1))) + 1;
    end

    always @(posedge sclk) begin
        r_sm_negx26_p_avg <= r_sm_sita_negx26 + {{2 {r_avg_phase_beta[31]}}, r_avg_phase_beta};
    end

    always @(posedge sclk) begin
        {r_sm_negx26_p_avg_v, r_sm_sita_negx26_v, r_sm_sita_valid, r_calc_sm_sita_en2, r_calc_sm_sita_en1, r_avg_phase_valid} <= {r_sm_sita_negx26_v, r_sm_sita_valid, r_calc_sm_sita_en2, r_calc_sm_sita_en1, r_avg_phase_valid, r_calc_phase_avg_en};
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_freq_offset_valid <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (r_freq_offset_valid == 1'b1 && r_freq_offset_cnt == 'd47) begin
                r_freq_offset_valid <= 1'b0;
            end
            else if (r_sm_negx26_p_avg_v == 1'b1) begin
                r_freq_offset_valid <= 1'b1;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_freq_offset_cnt <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (r_freq_offset_cnt == 'd47 && r_freq_offset_valid == 1'b1) begin
                r_freq_offset_cnt <= 'd0;
            end
            else if (r_freq_offset_valid == 1'b1) begin
                r_freq_offset_cnt <= r_freq_offset_cnt + 1'b1;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_add_double_flag <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (r_freq_offset_valid == 1'b1 && (r_freq_offset_cnt == 'd3 || r_freq_offset_cnt == 'd16 || r_freq_offset_cnt == 'd22 || r_freq_offset_cnt == 'd28 || r_freq_offset_cnt == 'd41)) begin
                r_add_double_flag <= 1'b1;
            end
            else begin
                r_add_double_flag <= 1'b0;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_dds_phase <= 'd0;
            r_symbol_slope <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (r_sm_negx26_p_avg_v == 1'b1) begin
                r_dds_phase <= r_sm_negx26_p_avg;
                r_symbol_slope <= r_sm_sita;
            end
            else if (r_freq_offset_valid == 1'b1 && r_add_double_flag == 1'b1) begin
                r_dds_phase <= r_dds_phase + (r_symbol_slope <<< 1);
            end
            else if (r_freq_offset_valid == 1'b1) begin
                r_dds_phase <= r_dds_phase + r_symbol_slope;
            end
            else if (r_freq_offset_valid == 1'b0) begin
                r_dds_phase <= 'd0;
            end
        end
    end
    //---------------------------------------------------------------------------
    //fix40_29--->fix32_21; remove low 8bit
    //INA fix32_21 =-pi~pi
    //2^12 dds lut addr=0~2047 =pi~-pi
    //INB fix32_21 = (1/(2*pi))*2^21
    //OUTC fix64_42 =2^42~0 =-pi~pi
    //---------------------------------------------------------------------------
    mult_atan2_s32_for_pilot u_mult_atan2_s32_ramaddr (
        .CLK                                          (sclk),  // input wire CLK
        .A                                            (r_dds_phase[39:8]),  // input wire [31:0] A
        .B                                            (FIXDIVPI2),  // input wire [31:0] B
        .P                                            (w_ram_addr)  // output wire [63:0] P
    );

    always @(posedge sclk) begin
        r_mult_dly_flag <= {r_mult_dly_flag[4:0], r_freq_offset_valid};
    end
    assign w_ram_addr_valid = r_mult_dly_flag[5];
    //---------------------------------------------------------------------------
    //ram_addr fix64_42
    //ram_addr[41:0] == -pi~pi
    //use dds 2^12 phase width
    //ram_addr[41:30]==-pi~pi
    //latency = 6
    //use tuser = ram_addr_valid
    //---------------------------------------------------------------------------
    //e^-j
    //fix16_15
    assign w_neg_ram_addr = (~w_ram_addr[41:30]) + 1;
    dds_pilot u_dds_pilot_use_pilot (
        .aclk                                         (sclk),  // input wire aclk
        .s_axis_phase_tvalid                          (enable),  // input wire s_axis_phase_tvalid
        .s_axis_phase_tdata                           ({4'd0, w_neg_ram_addr}),  // input wire [15:0] s_axis_phase_tdata
        .s_axis_phase_tuser                           (w_ram_addr_valid),  // input wire [0:0] s_axis_phase_tuser
        .m_axis_data_tvalid                           (),  // output wire m_axis_data_tvalid
        .m_axis_data_tdata                            (w_dds_amp),  // output wire [31:0] m_axis_data_tdata
        .m_axis_data_tuser                            (w_dds_amp_valid)  // output wire [0:0] m_axis_data_tuser
    );

    //---------------------------------------------------------------------------
    // Full 32-bit equalizer data times Q1.15 DDS; remove fractional bits
    // only after the 49-bit complex sum. Six cycles match the old CMPY.
    //---------------------------------------------------------------------------
    assign w_rd_chnl_fifo_en = w_dds_amp_valid;
    pilot_rotate_full_precision #(.WIDTH(DATA_WIDTH)) u_complex_mult_use_pilot (
        .clk(sclk), .reset(reset),
        .in_valid(w_dds_amp_valid), .phasor(w_dds_amp),
        .sample(w_rd_chnl_fifo_data),
        .out_valid(w_comp_mult_out_valid), .rotated(w_comp_mult_out_data)
    );

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_signal_chnl_out_valid_t <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (r_data_frame_flag == 1'b0) begin
                r_signal_chnl_out_valid_t <= w_comp_mult_out_valid;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_data_frame_flag <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (r_signal_chnl_out_valid_t == 1'b1 && signal_chnl_out_valid == 1'b0) begin
                r_data_frame_flag <= 1'b1;
            end
        end
    end

    assign signal_chnl_out_valid = (r_data_frame_flag == 1'b0) ? w_comp_mult_out_valid: 1'b0;
    assign signal_chnl_out_q = (r_data_frame_flag == 1'b0) ? w_comp_mult_out_data[2*DATA_WIDTH-1:DATA_WIDTH]: 'd0;
    assign signal_chnl_out_i = (r_data_frame_flag == 1'b0) ? w_comp_mult_out_data[DATA_WIDTH-1:0]: 'd0;

    assign w_rd_csi_fifo_en = w_comp_mult_out_valid;
    assign signal_csi_valid = (r_data_frame_flag == 1'b0) ? w_comp_mult_out_valid: 1'b0;
    assign signal_csi_q = (r_data_frame_flag == 1'b0) ? w_rd_csi_fifo_data[2*CSI_WIDTH-1:CSI_WIDTH]: 'd0;
    assign signal_csi_i = (r_data_frame_flag == 1'b0) ? w_rd_csi_fifo_data[CSI_WIDTH-1:0]: 'd0;

    //data file
    assign data_chnl_out_valid = (r_data_frame_flag == 1'b1) ? w_comp_mult_out_valid: 1'b0;
    assign data_chnl_out_q = (r_data_frame_flag == 1'b1) ? w_comp_mult_out_data[2*DATA_WIDTH-1:DATA_WIDTH]: 'd0;
    assign data_chnl_out_i = (r_data_frame_flag == 1'b1) ? w_comp_mult_out_data[DATA_WIDTH-1:0]: 'd0;

    assign data_csi_valid = (r_data_frame_flag == 1'b1) ? w_comp_mult_out_valid: 1'b0;
    assign data_csi_q = (r_data_frame_flag == 1'b1) ? w_rd_csi_fifo_data[2*CSI_WIDTH-1:CSI_WIDTH]: 'd0;
    assign data_csi_i = (r_data_frame_flag == 1'b1) ? w_rd_csi_fifo_data[CSI_WIDTH-1:0]: 'd0;

endmodule

// Preserve the old overall unity scale: the former >>7, CMPY >>1 and
// output >>7 totalled >>15, but quantized small inputs before rotation.
module pilot_rotate_full_precision #(parameter WIDTH = 32) (
    input wire clk, reset, in_valid,
    input wire [31:0] phasor,
    input wire [2*WIDTH-1:0] sample,
    output wire out_valid,
    output reg [2*WIDTH-1:0] rotated
);
    reg [5:0] r_valid;
    reg signed [WIDTH-1:0] r_i, r_q;
    reg signed [15:0] r_cos, r_sin;
    reg signed [WIDTH+15:0] r_ic, r_qs, r_is, r_qc;
    reg signed [WIDTH+16:0] r_sum_i, r_sum_q;
    reg [2*WIDTH-1:0] r_scaled, r_delay;

    function [WIDTH-1:0] f_saturate;
        input signed [WIDTH+16:0] product;
        reg signed [WIDTH+16:0] scaled;
        begin
            scaled = product >>> 15;
            if (scaled > $signed({1'b0, {(WIDTH-1){1'b1}}})) f_saturate = {1'b0, {(WIDTH-1){1'b1}}};
            else if (scaled < $signed({1'b1, {(WIDTH-1){1'b0}}})) f_saturate = {1'b1, {(WIDTH-1){1'b0}}};
            else f_saturate = scaled[WIDTH-1:0];
        end
    endfunction

    assign out_valid = r_valid[5];
    always @(posedge clk) begin
        if (reset) r_valid <= 0;
        else r_valid <= {r_valid[4:0], in_valid};
        r_i <= sample[WIDTH-1:0];
        r_q <= sample[2*WIDTH-1:WIDTH];
        r_cos <= phasor[15:0];
        r_sin <= phasor[31:16];
        r_ic <= r_i * r_cos;
        r_qs <= r_q * r_sin;
        r_is <= r_i * r_sin;
        r_qc <= r_q * r_cos;
        r_sum_i <= {r_ic[WIDTH+15], r_ic} - {r_qs[WIDTH+15], r_qs};
        r_sum_q <= {r_is[WIDTH+15], r_is} + {r_qc[WIDTH+15], r_qc};
        r_scaled <= {f_saturate(r_sum_q), f_saturate(r_sum_i)};
        r_delay <= r_scaled;
        rotated <= r_delay;
    end
endmodule

// CORDIC/phase/DDS latency exceeds one 80-cycle OFDM interval. At least
// two 48-carrier symbols must fit before the oldest symbol is drained.
module pilot_stream_fifo #(parameter WIDTH = 64) (
    input   wire                                        clk                                         ,
    input   wire                                        srst                                        ,
    input   wire            [WIDTH - 1:0]               din                                         ,
    input   wire                                        wr_en                                       ,
    input   wire                                        rd_en                                       ,
    output  wire            [WIDTH - 1:0]               dout                                        ,
    output  wire                                        full                                        ,
    output  wire                                        empty
);
    (* ram_style = "block" *) reg [WIDTH - 1:0] r_memory[0:255];
    reg                 [7:0]                       r_wr_ptr;
    reg                 [7:0]                       r_rd_ptr;
    reg                 [8:0]                       r_count;
    reg                 [WIDTH - 1:0]               r_read_data;
    reg                 [WIDTH - 1:0]               r_forward_data;
    reg                                             r_forward_valid;
    wire                                            w_pop = rd_en && !empty;
    wire                                            w_push = wr_en && (!full || w_pop);
    wire                [7:0]                       w_read_address = w_pop ? r_rd_ptr + 8'd1: r_rd_ptr;
    assign empty = r_count == 0;
    assign full = r_count == 256;
    // Synchronous look-ahead preserves the first-word-visible interface and
    // one-word-per-clock throughput. Forward an empty/last-word replacement
    // explicitly; never depend on the RAM's same-address read/write behavior.
    assign dout = r_forward_valid ? r_forward_data: r_read_data;
    always @(posedge clk) begin
        r_read_data <= r_memory[w_read_address];
        if (!srst && w_push) r_memory[r_wr_ptr] <= din;
        if (srst) r_forward_valid <= 1'b0;
        else r_forward_valid <= w_push && r_wr_ptr == w_read_address;
        if (w_push) r_forward_data <= din;
    end
    always @(posedge clk) begin
        if (srst) begin
            r_wr_ptr <= 0;
            r_rd_ptr <= 0;
            r_count <= 0;
        end else begin
            if (w_push) r_wr_ptr <= r_wr_ptr + 1'b1;
            if (w_pop) r_rd_ptr <= r_rd_ptr + 1'b1;
            case ({w_push, w_pop})
                2'b10: r_count <= r_count + 1'b1;
                2'b01: r_count <= r_count - 1'b1;
                default: r_count <= r_count;
            endcase
        end
    end
endmodule
