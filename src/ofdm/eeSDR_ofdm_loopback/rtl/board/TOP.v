`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/03 10:35:07
// Design Name: 
// Module Name: TOP
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


module TOP(
    DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
//LED
    i_clk_50M,
    o_LED,
//ad936x spi
    ad936x_phy_spi_clk,
    ad936x_phy_spi_mosi,
    ad936x_phy_spi_miso,
    ad936x_phy_spi_ss,
//ad936x lvds rx&tx
    data_clk_n,
    data_clk_p,
    fb_clk_n,
    fb_clk_p,
    rx_data_n,
    rx_data_p,
    rx_frame_n,
    rx_frame_p,
    tx_data_n,
    tx_data_p,
    tx_frame_n,
    tx_frame_p,
//ad936x ctrl
    EN_AGC,
    ENABLE,   
    RESET,
    TXNRX,
    SYNC_IN, 
    CTRL_IN
);
inout [14:0]DDR_addr;
inout [2:0]DDR_ba;
inout DDR_cas_n;
inout DDR_ck_n;
inout DDR_ck_p;
inout DDR_cke;
inout DDR_cs_n;
inout [3:0]DDR_dm;
inout [31:0]DDR_dq;
inout [3:0]DDR_dqs_n;
inout [3:0]DDR_dqs_p;
inout DDR_odt;
inout DDR_ras_n;
inout DDR_reset_n;
inout DDR_we_n;
inout FIXED_IO_ddr_vrn;
inout FIXED_IO_ddr_vrp;
inout [53:0]FIXED_IO_mio;
inout FIXED_IO_ps_clk;
inout FIXED_IO_ps_porb;
inout FIXED_IO_ps_srstb;

//ad936x spi
input ad936x_phy_spi_miso;
output ad936x_phy_spi_mosi;
output ad936x_phy_spi_clk;
output ad936x_phy_spi_ss;
//ad936x lvds rx&tx
input data_clk_n;
input data_clk_p;
output fb_clk_n;
output fb_clk_p;
input [5:0]rx_data_n;
input [5:0]rx_data_p;
input rx_frame_n;
input rx_frame_p;
output [5:0]tx_data_n;
output [5:0]tx_data_p;
output tx_frame_n;
output tx_frame_p;
//ad936x ctrl
output EN_AGC;   
output ENABLE;    
output RESET;
output TXNRX;
output SYNC_IN; 
output [3:0] CTRL_IN;

wire [31:0]GPIO_O;
wire [2:0] w_ofdm_status;
wire [3:0] w_heartbeat;
(* ASYNC_REG = "TRUE" *) reg [2:0] r_status_sync_1 = 0;
(* ASYNC_REG = "TRUE" *) reg [2:0] r_status_sync_2 = 0;

assign  EN_AGC = GPIO_O[0];
assign  ENABLE = GPIO_O[1];
assign  RESET = GPIO_O[2];
assign  TXNRX = GPIO_O[3];
assign  SYNC_IN = GPIO_O[4];
assign  CTRL_IN = GPIO_O[8:5];
ZYNQ_bd_wrapper u_ZYNQ_bd_wrapper(
    .DDR_addr(DDR_addr),
    .DDR_ba(DDR_ba),
    .DDR_cas_n(DDR_cas_n),
    .DDR_ck_n(DDR_ck_n),
    .DDR_ck_p(DDR_ck_p),
    .DDR_cke(DDR_cke),
    .DDR_cs_n(DDR_cs_n),
    .DDR_dm(DDR_dm),
    .DDR_dq(DDR_dq),
    .DDR_dqs_n(DDR_dqs_n),
    .DDR_dqs_p(DDR_dqs_p),
    .DDR_odt(DDR_odt),
    .DDR_ras_n(DDR_ras_n),
    .DDR_reset_n(DDR_reset_n),
    .DDR_we_n(DDR_we_n),
    .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
    .FIXED_IO_mio(FIXED_IO_mio),
    .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
    .GPIO_O(GPIO_O),
    .SPI0_MISO_I(ad936x_phy_spi_miso),
    .SPI0_MOSI_O(ad936x_phy_spi_mosi),
    .SPI0_SCLK_O(ad936x_phy_spi_clk),
    .SPI0_SS_O(ad936x_phy_spi_ss),
    .data_clk_n(data_clk_n),
    .data_clk_p(data_clk_p),
    .fb_clk_n(fb_clk_n),
    .fb_clk_p(fb_clk_p),
    .rx_data_n(rx_data_n),
    .rx_data_p(rx_data_p),
    .rx_frame_n(rx_frame_n),
    .rx_frame_p(rx_frame_p),
    .tx_data_n(tx_data_n),
    .tx_data_p(tx_data_p),
    .tx_frame_n(tx_frame_n),
    .tx_frame_p(tx_frame_p),
    .ofdm_status(w_ofdm_status)
);

//PL LED
input           i_clk_50M;
output  [3:0]   o_LED;
always @(posedge i_clk_50M) begin
    r_status_sync_1 <= w_ofdm_status;
    r_status_sync_2 <= r_status_sync_1;
end
assign o_LED = {r_status_sync_2, w_heartbeat[0]};
LED_TOP u_LED_TOP(
    .i_clk_50M(i_clk_50M),
    .o_LED(w_heartbeat)
);
endmodule
