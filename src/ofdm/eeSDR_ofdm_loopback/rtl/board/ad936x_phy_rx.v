`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: eeWeek
// Engineer: Week8
// 
// Create Date: 2026/01/22 15:18:43
// Design Name: 
// Module Name: ad936x_phy_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: ad936x_lvds_rx
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ad936x_phy_rx(
   //system signal
   input   wire            i_rst_n,
   input   wire            i_TR_mode,
   //phy signal
   input   wire            i_rx_clk_p,
   input   wire            i_rx_clk_n,

   input   wire    [5:0]   i_rx_data_p,
   input   wire    [5:0]   i_rx_data_n,

   input   wire            i_rx_frame_p,
   input   wire            i_rx_frame_n,

   output  wire            o_data_clk,
   output  wire            o_rx_fream,
   
   output  wire    [11:0]  o_rx_data_ch1_i,
   output  wire    [11:0]  o_rx_data_ch1_q,

   output  wire    [11:0]  o_rx_data_ch2_i,
   output  wire    [11:0]  o_rx_data_ch2_q,

   output  wire            o_rx_data_ch1_vaild,
   output  wire            o_rx_data_ch2_vaild
);

// rx_clk process
wire w_rx_clk_IBUFDS;
IBUFDS #(
   .DIFF_TERM("FALSE"),       // Differential Termination
   .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
   .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
) w_rx_clk_IBUFDS_inst (
   .O(w_rx_clk_IBUFDS),  // Buffer output
   .I(i_rx_clk_p),  // Diff_p buffer input (connect directly to top-level port)
   .IB(i_rx_clk_n) // Diff_n buffer input (connect directly to top-level port)
);

BUFG w_rx_clk_BUFG_inst (
   .O(o_data_clk), // 1-bit output: Clock output
   .I(w_rx_clk_IBUFDS)  // 1-bit input: Clock input
);

// rx_frame process
wire w_rx_frame;
wire w_rx_frame_IDDR_pe;
wire w_rx_frame_IDDR_ne;
IBUFDS #(
   .DIFF_TERM("FALSE"),       // Differential Termination
   .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
   .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
) w_rx_frame_IBUFDS_inst (
   .O(w_rx_frame),  // Buffer output
   .I(i_rx_frame_p),  // Diff_p buffer input (connect directly to top-level port)
   .IB(i_rx_frame_n) // Diff_n buffer input (connect directly to top-level port)
);

IDDR #(
   .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                 //    or "SAME_EDGE_PIPELINED" 
   .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
   .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
   .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
) w_rx_frame_IDDR_inst (
   .Q1(w_rx_frame_IDDR_pe), // 1-bit output for positive edge of clock
   .Q2(w_rx_frame_IDDR_ne), // 1-bit output for negative edge of clock
   .C(o_data_clk),   // 1-bit clock input
   .CE(1'b1), // 1-bit clock enable input
   .D(w_rx_frame),   // 1-bit DDR data input
   .R(1'b0),   // 1-bit reset
   .S(1'b0)    // 1-bit set
);

assign o_rx_fream = w_rx_frame;

// rx_data process
wire [5:0] w_rx_data_IBUFDS;
wire [5:0] w_rx_data_IDDR_pe;
wire [5:0] w_rx_data_IDDR_ne;

genvar index;
generate for (index=0; index<6 ; index=index+1) begin
   IBUFDS #(
   .DIFF_TERM("FALSE"),       // Differential Termination
   .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
   .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
   ) w_rx_data_IBUFDS_inst (
      .O(w_rx_data_IBUFDS[index]),  // Buffer output
      .I(i_rx_data_p[index]),  // Diff_p buffer input (connect directly to top-level port)
      .IB(i_rx_data_n[index]) // Diff_n buffer input (connect directly to top-level port)
   );
   IDDR #(
   .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                 //    or "SAME_EDGE_PIPELINED" 
   .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
   .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
   .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) w_rx_data_IDDR_inst (
      .Q1(w_rx_data_IDDR_pe[index]), // 1-bit output for positive edge of clock
      .Q2(w_rx_data_IDDR_ne[index]), // 1-bit output for negative edge of clock
      .C(o_data_clk),   // 1-bit clock input
      .CE(1'b1), // 1-bit clock enable input
      .D(w_rx_data_IBUFDS[index]),   // 1-bit DDR data input
      .R(1'b0),   // 1-bit reset
      .S(1'b0)    // 1-bit set
   );
   end
endgenerate

reg [3:0] r_rx_frame_shift = 'd0;
reg [23:0] r_rx_data_shift = 'd0;
always @(posedge o_data_clk) begin
   if(!i_rst_n)begin
      r_rx_frame_shift <= 4'd0;
      r_rx_data_shift <= 23'd0;
   end
   else begin
      r_rx_frame_shift <= {r_rx_frame_shift[1:0],w_rx_frame_IDDR_pe,w_rx_frame_IDDR_ne};
      r_rx_data_shift <= {r_rx_data_shift[11:0],w_rx_data_IDDR_pe,w_rx_data_IDDR_ne};   
   end
end

reg [11:0] r_rx_data_ch1_i;
reg [11:0] r_rx_data_ch1_q;
reg [11:0] r_rx_data_ch2_i;
reg [11:0] r_rx_data_ch2_q;
reg        r_rx_data_ch1_vaild;
reg        r_rx_data_ch2_vaild;
always @(posedge o_data_clk) begin
   case ({r_rx_frame_shift,i_TR_mode})
      5'b11000: begin   //1T1R
         r_rx_data_ch1_i <= {r_rx_data_shift[23:18],r_rx_data_shift[11:6]};
         r_rx_data_ch1_q <= {r_rx_data_shift[17:12],r_rx_data_shift[5:0]};
         r_rx_data_ch1_vaild <= 1'b1;
      end
      5'b11111: begin   //2T2R
         r_rx_data_ch1_i <= {r_rx_data_shift[23:18],r_rx_data_shift[11:6]};
         r_rx_data_ch1_q <= {r_rx_data_shift[17:12],r_rx_data_shift[5:0]};
         r_rx_data_ch1_vaild <= 1'b1;
      end
      5'b00001:begin   //2T2R
         r_rx_data_ch2_i <= {r_rx_data_shift[23:18],r_rx_data_shift[11:6]};
         r_rx_data_ch2_q <= {r_rx_data_shift[17:12],r_rx_data_shift[5:0]};
         r_rx_data_ch2_vaild <= 1'b1;
      end
      default: begin
         r_rx_data_ch1_vaild <= 1'b0;
         r_rx_data_ch2_vaild <= 1'b0;
      end
   endcase
end


assign o_frame_shift = r_rx_frame_shift;
assign o_data_shift = r_rx_data_shift;

assign o_rx_data_ch1_i = r_rx_data_ch1_i;
assign o_rx_data_ch1_q = r_rx_data_ch1_q;

assign o_rx_data_ch2_i = r_rx_data_ch2_i;
assign o_rx_data_ch2_q = r_rx_data_ch2_q;

assign o_rx_data_ch1_vaild = r_rx_data_ch1_vaild;
assign o_rx_data_ch2_vaild = r_rx_data_ch2_vaild;
endmodule