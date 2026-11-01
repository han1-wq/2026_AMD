`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/03 11:07:41
// Design Name: 
// Module Name: LED_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LED_TOP(
    input         i_clk_50M,
    output [3:0]  o_LED
);

parameter Time1us = 6'd49;
reg [5:0] Count1us;
//1us计数器
always @(posedge i_clk_50M) begin       
    if(Count1us == Time1us)begin
        Count1us <= 6'd0;
    end
    else Count1us <= Count1us + 1'b1;
end
//1ms计数器
parameter Time1ms = 10'd999;
reg [9:0] Count1ms;
always @(posedge i_clk_50M) begin
    if(Count1ms == Time1ms && Count1us == Time1us)begin
        Count1ms <= 10'd0;
    end
    else if (Count1us == Time1us) begin
        Count1ms <= Count1ms + 1'b1;
    end
end
//1s计数器
parameter Time1s = 10'd999;
reg [9:0] Count1s;
reg Count1s_EN; //标志是亮是灭
always @(posedge i_clk_50M) begin
    if(Count1s == Time1s && Count1ms == Time1ms && Count1us == Time1us)begin
        Count1s <= 10'd0;
        Count1s_EN <= ~Count1s_EN;
    end
    else if (Count1ms == Time1ms && Count1us == Time1us) begin
        Count1s <= Count1s + 1'b1;
    end
end
//LED切换 2s计数器 一亮一灭是2s
parameter Time2s = 11'd1999;
reg [10:0] Count2s;
reg [3:0] LED_which;
always @(posedge i_clk_50M) begin
    if(Count2s == Time2s && Count1ms == Time1ms && Count1us == Time1us)begin
        Count2s <= 11'd0;
        if (LED_which >= 4'd3) begin
            LED_which <= 4'd0;
        end
        else LED_which <= LED_which + 1'b1;
    end
    else if (Count1ms == Time1ms && Count1us == Time1us) begin
        Count2s <= Count2s + 1'b1;
    end
end
reg LED_State; 
//breath
always @(posedge i_clk_50M) begin
    if ((Count1s_EN == 1'b1 && (Count1ms < Count1s)) || (Count1s_EN == 1'b0 && (Count1ms > Count1s))) begin
        LED_State <= 1'b0;
    end
    else LED_State <= 1'b1;
end

assign o_LED[0] = (LED_which == 4'd0) ? LED_State : 1'b0;
assign o_LED[1] = (LED_which == 4'd1) ? LED_State : 1'b0;
assign o_LED[2] = (LED_which == 4'd2) ? LED_State : 1'b0;
assign o_LED[3] = (LED_which == 4'd3) ? LED_State : 1'b0;
endmodule
