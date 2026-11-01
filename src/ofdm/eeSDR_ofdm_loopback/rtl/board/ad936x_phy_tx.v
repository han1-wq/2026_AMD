`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/01/27 20:15:23
// Design Name: 
// Module Name: ad936x_phy_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: ad936x_lvds_tx
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ad936x_phy_tx(
   //system signal
   input    wire              i_rst_n,
   input    wire              i_TR_mode,

   //phy signal
   input    wire              i_data_clk,
   input    wire  [11:0]      i_tx_data_ch1_i,
   input    wire  [11:0]      i_tx_data_ch1_q,
   input    wire  [11:0]      i_tx_data_ch2_i,
   input    wire  [11:0]      i_tx_data_ch2_q,

   input    wire              i_tx_data_vaild,

   output   wire              o_tx_clk_p,
   output   wire              o_tx_clk_n,

   output   wire  [5:0]       o_tx_data_p,
   output   wire  [5:0]       o_tx_data_n,

   output   wire              o_tx_frame_p,
   output   wire              o_tx_frame_n
);
// A valid pulse accepts one complete IQ sample.  The AD9361 consumes the
// sample over several DDR half-cycles, so the input must not be read again
// while those half-cycles are being emitted.
reg [11:0] r_tx_hold_ch1_i = 12'd0;
reg [11:0] r_tx_hold_ch1_q = 12'd0;
reg [11:0] r_tx_hold_ch2_i = 12'd0;
reg [11:0] r_tx_hold_ch2_q = 12'd0;
reg [11:0] r_tx_pending_ch1_i = 12'd0;
reg [11:0] r_tx_pending_ch1_q = 12'd0;
reg [11:0] r_tx_pending_ch2_i = 12'd0;
reg [11:0] r_tx_pending_ch2_q = 12'd0;
reg         r_tx_pending = 1'b0;
reg         r_tx_active = 1'b0;

reg [1:0]   r_tx_cnt = 2'd0;
reg         r_tx_mode_d = 1'b0;
reg         r_tx_frame = 1'b0;
reg [5:0]   r_tx_data_ODDR_pe = 6'd0;
reg [5:0]   r_tx_data_ODDR_ne = 6'd0;

always @(posedge i_data_clk) begin
   if (!i_rst_n) begin
      r_tx_cnt <= 2'd0;
      r_tx_mode_d <= i_TR_mode;
      r_tx_frame <= 1'b0;
      r_tx_data_ODDR_pe <= 6'd0;
      r_tx_data_ODDR_ne <= 6'd0;
      r_tx_hold_ch1_i <= 12'd0;
      r_tx_hold_ch1_q <= 12'd0;
      r_tx_hold_ch2_i <= 12'd0;
      r_tx_hold_ch2_q <= 12'd0;
      r_tx_pending_ch1_i <= 12'd0;
      r_tx_pending_ch1_q <= 12'd0;
      r_tx_pending_ch2_i <= 12'd0;
      r_tx_pending_ch2_q <= 12'd0;
      r_tx_pending <= 1'b0;
      r_tx_active <= 1'b0;
   end
   else begin
      r_tx_mode_d <= i_TR_mode;
      if (i_TR_mode != r_tx_mode_d) begin
         // A mode change changes the LVDS word layout.  Do not emit a
         // half-word from the previous layout after the change.
         r_tx_cnt <= 2'd0;
         r_tx_frame <= 1'b0;
         r_tx_data_ODDR_pe <= 6'd0;
         r_tx_data_ODDR_ne <= 6'd0;
         r_tx_hold_ch1_i <= 12'd0;
         r_tx_hold_ch1_q <= 12'd0;
         r_tx_hold_ch2_i <= 12'd0;
         r_tx_hold_ch2_q <= 12'd0;
         r_tx_pending_ch1_i <= 12'd0;
         r_tx_pending_ch1_q <= 12'd0;
         r_tx_pending_ch2_i <= 12'd0;
         r_tx_pending_ch2_q <= 12'd0;
         r_tx_pending <= 1'b0;
         r_tx_active <= 1'b0;
      end
      else if (i_TR_mode) begin
         // 2T2R consumes one complete sample in four data-clock cycles.
         // A valid sample at phase 0 starts immediately.  A valid sample at
         // another phase is queued until the current four-half-word sample
         // has completed, so no half-word can mix two IQ samples.
         // Before the first accepted sample, valid defines the beginning
         // of the 2T2R word even if the free-running idle phase is nonzero.
         // Once active, a valid at a nonzero phase is queued below.
         if (i_tx_data_vaild && !r_tx_active && (r_tx_cnt != 2'd0)) begin
            r_tx_hold_ch1_i <= i_tx_data_ch1_i;
            r_tx_hold_ch1_q <= i_tx_data_ch1_q;
            r_tx_hold_ch2_i <= i_tx_data_ch2_i;
            r_tx_hold_ch2_q <= i_tx_data_ch2_q;
            r_tx_frame <= 1'b1;
            r_tx_data_ODDR_pe <= i_tx_data_ch1_i[11:6];
            r_tx_data_ODDR_ne <= i_tx_data_ch1_q[11:6];
            r_tx_cnt <= 2'd1;
            r_tx_active <= 1'b1;
         end
         else begin
         case (r_tx_cnt)
            2'd0: begin
               r_tx_frame <= 1'b1;
               if (i_tx_data_vaild) begin
                  r_tx_hold_ch1_i <= i_tx_data_ch1_i;
                  r_tx_hold_ch1_q <= i_tx_data_ch1_q;
                  r_tx_hold_ch2_i <= i_tx_data_ch2_i;
                  r_tx_hold_ch2_q <= i_tx_data_ch2_q;
                  r_tx_data_ODDR_pe <= i_tx_data_ch1_i[11:6];
                  r_tx_data_ODDR_ne <= i_tx_data_ch1_q[11:6];
                  r_tx_active <= 1'b1;
               end
               else if (r_tx_pending) begin
                  r_tx_hold_ch1_i <= r_tx_pending_ch1_i;
                  r_tx_hold_ch1_q <= r_tx_pending_ch1_q;
                  r_tx_hold_ch2_i <= r_tx_pending_ch2_i;
                  r_tx_hold_ch2_q <= r_tx_pending_ch2_q;
                  r_tx_data_ODDR_pe <= r_tx_pending_ch1_i[11:6];
                  r_tx_data_ODDR_ne <= r_tx_pending_ch1_q[11:6];
                  r_tx_pending <= 1'b0;
               end
               else begin
                  r_tx_data_ODDR_pe <= r_tx_hold_ch1_i[11:6];
                  r_tx_data_ODDR_ne <= r_tx_hold_ch1_q[11:6];
               end
            end
            2'd1: begin
               r_tx_frame <= 1'b1;
               r_tx_data_ODDR_pe <= r_tx_hold_ch1_i[5:0];
               r_tx_data_ODDR_ne <= r_tx_hold_ch1_q[5:0];
            end
            2'd2: begin
               r_tx_frame <= 1'b0;
               r_tx_data_ODDR_pe <= r_tx_hold_ch2_i[11:6];
               r_tx_data_ODDR_ne <= r_tx_hold_ch2_q[11:6];
            end
            default: begin
               r_tx_frame <= 1'b0;
               r_tx_data_ODDR_pe <= r_tx_hold_ch2_i[5:0];
               r_tx_data_ODDR_ne <= r_tx_hold_ch2_q[5:0];
            end
         endcase
         if (i_tx_data_vaild && (r_tx_cnt != 2'd0)) begin
            r_tx_pending_ch1_i <= i_tx_data_ch1_i;
            r_tx_pending_ch1_q <= i_tx_data_ch1_q;
            r_tx_pending_ch2_i <= i_tx_data_ch2_i;
            r_tx_pending_ch2_q <= i_tx_data_ch2_q;
            r_tx_pending <= 1'b1;
         end
         r_tx_cnt <= r_tx_cnt + 1'b1;
         if ((r_tx_cnt == 2'd3) && !i_tx_data_vaild)
            r_tx_active <= 1'b0;
         end
      end
      else begin
         // 1T1R consumes one complete sample in two data-clock cycles.
         // A valid sample on the low-half cycle is queued for the following
         // high half while the current sample finishes unchanged.
         if (r_tx_cnt[0] == 1'b0) begin
            r_tx_frame <= 1'b1;
            if (i_tx_data_vaild) begin
               r_tx_hold_ch1_i <= i_tx_data_ch1_i;
               r_tx_hold_ch1_q <= i_tx_data_ch1_q;
               r_tx_data_ODDR_pe <= i_tx_data_ch1_i[11:6];
               r_tx_data_ODDR_ne <= i_tx_data_ch1_q[11:6];
            end
            else if (r_tx_pending) begin
               r_tx_hold_ch1_i <= r_tx_pending_ch1_i;
               r_tx_hold_ch1_q <= r_tx_pending_ch1_q;
               r_tx_data_ODDR_pe <= r_tx_pending_ch1_i[11:6];
               r_tx_data_ODDR_ne <= r_tx_pending_ch1_q[11:6];
               r_tx_pending <= 1'b0;
            end
            else begin
               r_tx_data_ODDR_pe <= r_tx_hold_ch1_i[11:6];
               r_tx_data_ODDR_ne <= r_tx_hold_ch1_q[11:6];
            end
         end
         else begin
            r_tx_frame <= 1'b0;
            r_tx_data_ODDR_pe <= r_tx_hold_ch1_i[5:0];
            r_tx_data_ODDR_ne <= r_tx_hold_ch1_q[5:0];
         end
         if (i_tx_data_vaild && (r_tx_cnt[0] == 1'b1)) begin
            r_tx_pending_ch1_i <= i_tx_data_ch1_i;
            r_tx_pending_ch1_q <= i_tx_data_ch1_q;
            r_tx_pending <= 1'b1;
         end
         // A valid pulse is the capture boundary.  Keep the next state at
         // the high half so the accepted sample cannot be skipped.
         if (i_tx_data_vaild)
            r_tx_cnt <= 2'd0;
         else
            r_tx_cnt <= {1'b0, ~r_tx_cnt[0]};
      end
   end
end

//tx_clk ODDR->OBUFDS
wire w_tx_clk_ODDR;
ODDR #(
   .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
   .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
   .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
) w_tx_clk_ODDR_inst (
   .Q(w_tx_clk_ODDR),   // 1-bit DDR output
   .C(i_data_clk),   // 1-bit clock input
   .CE(1'b1), // 1-bit clock enable input
   .D1(1'b0), // 1-bit data input (positive edge)
   .D2(1'b1), // 1-bit data input (negative edge)
   .R(1'b0),   // 1-bit reset
   .S(1'b0)    // 1-bit set
);
OBUFDS #(
   .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
   .SLEW("SLOW")           // Specify the output slew rate
) tx_clk_OBUFDS_inst (
   .O(o_tx_clk_p),     // Diff_p output (connect directly to top-level port)
   .OB(o_tx_clk_n),   // Diff_n output (connect directly to top-level port)
   .I(w_tx_clk_ODDR)      // Buffer input
);

//tx_frame ODDR->OBUFDS
wire w_tx_frame_ODDR;
ODDR #(
   .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
   .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
   .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
) w_tx_frame_ODDR_inst (
   .Q(w_tx_frame_ODDR),   // 1-bit DDR output
   .C(i_data_clk),   // 1-bit clock input
   .CE(1'b1), // 1-bit clock enable input
   .D1(r_tx_frame), // 1-bit data input (positive edge)
   .D2(r_tx_frame), // 1-bit data input (negative edge)
   .R(1'b0),   // 1-bit reset
   .S(1'b0)    // 1-bit set
);
OBUFDS #(
   .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
   .SLEW("SLOW")           // Specify the output slew rate
) tx_frame_OBUFDS_inst (
   .O(o_tx_frame_p),     // Diff_p output (connect directly to top-level port)
   .OB(o_tx_frame_n),   // Diff_n output (connect directly to top-level port)
   .I(w_tx_frame_ODDR)      // Buffer input
);

//tx_data ODDR->OBUFDS
wire [5:0] w_tx_data_ODDR;
genvar index;
generate for (index=0; index<6 ; index=index+1) begin
   ODDR #(
      .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
      .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) w_tx_data_ODDR_inst (
      .Q(w_tx_data_ODDR[index]),   // 1-bit DDR output
      .C(i_data_clk),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D1(r_tx_data_ODDR_pe[index]), // 1-bit data input (positive edge)
      .D2(r_tx_data_ODDR_ne[index]), // 1-bit data input (negative edge)
      .R(1'b0),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
   OBUFDS #(
      .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
   ) tx_data_OBUFDS_inst (
      .O(o_tx_data_p[index]),     // Diff_p output (connect directly to top-level port)
      .OB(o_tx_data_n[index]),   // Diff_n output (connect directly to top-level port)
      .I(w_tx_data_ODDR[index])      // Buffer input
   );
end
endgenerate


endmodule