`timescale 1ns / 1ps

// Board integration: single-channel OFDM on channel 1 of the generic PHY.
module ad936x_ofdm_TOP #(
    parameter DMA_ENABLE = 0,
    parameter RS_ENABLE = 1,
    parameter RS_INTERLEAVE = 1
) (
    input   	wire            rst_n				,
    input   	wire            TR_mode				,
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 axi_clk CLK" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi_clk, ASSOCIATED_BUSIF s_axi, ASSOCIATED_RESET axi_resetn, FREQ_HZ 80000000" *)
    input   wire            axi_clk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 axi_resetn RST" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi_resetn, POLARITY ACTIVE_LOW" *)
    input   wire            axi_resetn,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWADDR" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 80000000, ID_WIDTH 0, ADDR_WIDTH 8, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1" *)
    input   wire [7:0]      s_axi_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWPROT" *)
    input   wire [2:0]      s_axi_awprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWVALID" *)
    input   wire            s_axi_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWREADY" *)
    output  wire            s_axi_awready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WDATA" *)
    input   wire [31:0]     s_axi_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WSTRB" *)
    input   wire [3:0]      s_axi_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WVALID" *)
    input   wire            s_axi_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WREADY" *)
    output  wire            s_axi_wready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BRESP" *)
    output  wire [1:0]      s_axi_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BVALID" *)
    output  wire            s_axi_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BREADY" *)
    input   wire            s_axi_bready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARADDR" *)
    input   wire [7:0]      s_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARPROT" *)
    input   wire [2:0]      s_axi_arprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARVALID" *)
    input   wire            s_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARREADY" *)
    output  wire            s_axi_arready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RDATA" *)
    output  wire [31:0]     s_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RRESP" *)
    output  wire [1:0]      s_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RVALID" *)
    output  wire            s_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RREADY" *)
    input   wire            s_axi_rready,

    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_tx TDATA" *)
    input wire [7:0] s_axis_tx_tdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_tx TVALID" *)
    input wire s_axis_tx_tvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_tx TREADY" *)
    output wire s_axis_tx_tready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_tx TLAST" *)
    input wire s_axis_tx_tlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_rx TDATA" *)
    output wire [7:0] m_axis_rx_tdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_rx TVALID" *)
    output wire m_axis_rx_tvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_rx TREADY" *)
    input wire m_axis_rx_tready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_rx TLAST" *)
    output wire m_axis_rx_tlast,

    input   	wire            data_clk_p			,
    input   	wire            data_clk_n			,
    input   	wire  [5:0]     rx_data_p			,
    input   	wire  [5:0]     rx_data_n			,
    input   	wire            rx_frame_p			,
    input   	wire            rx_frame_n			,

    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 data_clk CLK" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME data_clk, ASSOCIATED_BUSIF s_axis_tx:m_axis_rx, FREQ_HZ 80000000" *)
    output  	wire            data_clk			,
    output  	wire            rx_frame			,

    output  	wire [11:0]     rx_data_ch1_i		,
    output  	wire [11:0]     rx_data_ch1_q		,
    output  	wire [11:0]     rx_data_ch2_i		,
    output  	wire [11:0]     rx_data_ch2_q		,
    output  	wire            rx_data_ch1_vaild	,
    output  	wire            rx_data_ch2_vaild	,

    output  	wire            fb_clk_p			,
    output  	wire            fb_clk_n			,
    output  	wire  [5:0]     tx_data_p			,
    output  	wire  [5:0]     tx_data_n			,
    output  	wire            tx_frame_p			,
    output  	wire            tx_frame_n			,

    output  	wire  [2:0]     ofdm_status
);

  wire  data_clk_AD936x;
  // TR_mode is written in the PS/AXI clock domain and consumed by both PHY
  // halves in the AD9361 data-clock domain. Synchronize it before it reaches
  // the PHY state machines and DDR output controls.
  (* ASYNC_REG = "TRUE" *) reg r_tr_mode_sync1 = 1'b0;
  (* ASYNC_REG = "TRUE" *) reg r_tr_mode_sync2 = 1'b0;

  always @(posedge data_clk_AD936x) begin
    if (w_rst) begin
      r_tr_mode_sync1 <= 1'b0;
      r_tr_mode_sync2 <= 1'b0;
    end
    else begin
      r_tr_mode_sync1 <= TR_mode;
      r_tr_mode_sync2 <= r_tr_mode_sync1;
    end
  end

    clk_wiz_0 clk_wiz_0_inst
   	(
    	// Clock out ports
    	.clk_out1(data_clk),     // output clk_out1
   		// Clock in ports
    	.clk_in1(data_clk_AD936x)
	);  // input clk_in1

    wire 						w_rst;
    wire 						w_tx_cmd_ready, w_tx_data_ready, w_tx_cmd_valid, w_tx_data_valid;
    wire 						w_tx_data_last;
    wire 			[7:0] 		w_tx_data;
    wire 			[10:0] 		w_tx_length;
    wire 			[5:0] 		w_tx_rate;
    wire 			[1:0] 		w_tx_upsample;
    wire 						w_tx_sample_valid, w_tx_done;
    wire 			[15:0] 		w_tx_sample_i, w_tx_sample_q;
    wire 			[1:0] 		w_tx_error;
    wire 						w_tx_scaled_valid, w_rx_scaled_valid;
    wire 	signed 	[11:0] 		w_tx_scaled_i, w_tx_scaled_q;
    wire 	signed 	[15:0] 		w_rx_scaled_i, w_rx_scaled_q;
    wire 						w_fcs_strobe, w_fcs_ok, w_payload_valid;
    wire 			[7:0] 		w_payload_byte;
    wire 			[15:0] 		w_rx_length;
    wire [2:0] w_mailbox_status;
    wire w_rx_packet_start;


    assign w_rst = !rst_n;
    assign ofdm_status = w_mailbox_status;

    // ila_0 probe map, sampled by the AD9361 forwarded data clock:
    // probe0  w_rst
    // probe1  w_tx_sample_valid (TX sample trigger)
    // probe2  w_tx_sample_i
    // probe3  w_tx_sample_q
    // probe4  {w_tx_scaled_valid, w_tx_done, w_tx_error}
    // probe5  w_tx_scaled_i
    // probe6  w_tx_scaled_q
    // probe7  rx_data_ch1_vaild
    // probe8  rx_data_ch1_i
    // probe9  rx_data_ch1_q
    // probe10 w_rx_scaled_valid
    // probe11 w_rx_scaled_i
    // probe12 w_rx_scaled_q
    // probe13 {w_payload_valid, w_fcs_strobe, w_fcs_ok, mailbox status, 1'b0}
    // probe14 w_payload_byte
    // probe15 w_rx_length
    // probe16 {ofdm_status, 7'b0}
    // probe17 {w_tx_cmd_valid, w_tx_data_valid, w_tx_data_last}
    // probe18 w_tx_length
    ila_0 	u_ila_0 (
        .clk(data_clk),
        .probe0(w_rst),
        .probe1(w_tx_sample_valid),
        .probe2(w_tx_sample_i),
        .probe3(w_tx_sample_q),
        .probe4({w_tx_scaled_valid, w_tx_done, w_tx_error}),
        .probe5(w_tx_scaled_i),
        .probe6(w_tx_scaled_q),
        .probe7(rx_data_ch1_vaild),
        .probe8(rx_data_ch1_i),
        .probe9(rx_data_ch1_q),
        .probe10(w_rx_scaled_valid),
        .probe11(w_rx_scaled_i),
        .probe12(w_rx_scaled_q),
        .probe13({w_payload_valid, w_fcs_strobe, w_fcs_ok, w_mailbox_status, 1'b0}),
        .probe14(w_payload_byte),
        .probe15(w_rx_length),
        .probe16({ofdm_status, 7'b0}),
        .probe17({w_tx_cmd_valid, w_tx_data_valid, w_tx_data_last}),
        .probe18(w_tx_length)
    );


    wire w_tx_phy_reset;
    generate if (DMA_ENABLE == 0) begin : g_mailbox
    assign w_tx_phy_reset = w_rst;
    assign s_axis_tx_tready = 1'b0;
    assign m_axis_rx_tdata = 0;
    assign m_axis_rx_tvalid = 1'b0;
    assign m_axis_rx_tlast = 1'b0;
    ofdm_packet_mailbox u_packet_mailbox (
        .s_axi_aclk(axi_clk), .s_axi_aresetn(axi_resetn),
        .s_axi_awaddr(s_axi_awaddr), .s_axi_awvalid(s_axi_awvalid), .s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata), .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid), .s_axi_wready(s_axi_wready),
        .s_axi_bresp(s_axi_bresp), .s_axi_bvalid(s_axi_bvalid), .s_axi_bready(s_axi_bready),
        .s_axi_araddr(s_axi_araddr), .s_axi_arvalid(s_axi_arvalid), .s_axi_arready(s_axi_arready),
        .s_axi_rdata(s_axi_rdata), .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid), .s_axi_rready(s_axi_rready),
        .data_clk(data_clk), .data_rst(w_rst),
        .cmd_ready(w_tx_cmd_ready), .cmd_valid(w_tx_cmd_valid),
        .cmd_length(w_tx_length), .cmd_rate(w_tx_rate), .cmd_upsample(w_tx_upsample),
        .data_ready(w_tx_data_ready), .data_valid(w_tx_data_valid),
        .data_last(w_tx_data_last), .data_byte(w_tx_data),
        .tx_done(w_tx_done), .tx_error(w_tx_error),
        .rx_valid(w_payload_valid), .rx_byte(w_payload_byte),
        .fcs_strobe(w_fcs_strobe), .fcs_ok(w_fcs_ok), .rx_length(w_rx_length),
        .status_led(w_mailbox_status)
    );
    end else begin : g_dma
        wire enabled;
        wire tx_ready_internal;
        wire packet_reset = w_rst || !enabled;
        wire [31:0] ts, tc, tr, tf, cookie, ra, rd, ro, rt;
        assign s_axis_tx_tready = enabled && tx_ready_internal;
        assign w_mailbox_status = {tf != 0 || tr != 0 || rd != 0, ra != 0, enabled};
        ofdm_dma_control u_control (
            .clk(axi_clk), .resetn(axi_resetn),
            .awaddr(s_axi_awaddr), .awvalid(s_axi_awvalid), .awready(s_axi_awready),
            .wdata(s_axi_wdata), .wstrb(s_axi_wstrb), .wvalid(s_axi_wvalid), .wready(s_axi_wready),
            .bresp(s_axi_bresp), .bvalid(s_axi_bvalid), .bready(s_axi_bready),
            .araddr(s_axi_araddr), .arvalid(s_axi_arvalid), .arready(s_axi_arready),
            .rdata(s_axi_rdata), .rresp(s_axi_rresp), .rvalid(s_axi_rvalid), .rready(s_axi_rready),
            .enable(enabled), .tx_submitted(ts), .tx_completed(tc), .tx_rejected(tr),
            .tx_failed(tf), .tx_cookie(cookie), .rx_accepted(ra), .rx_dropped(rd),
            .rx_overflow(ro), .rx_timeout(rt)
        );
        ofdm_dma_tx u_dma_tx (
            .clk(data_clk), .reset(packet_reset),
            .s_data(s_axis_tx_tdata), .s_valid(s_axis_tx_tvalid && enabled),
            .s_last(s_axis_tx_tlast), .s_ready(tx_ready_internal),
            .cmd_valid(w_tx_cmd_valid), .cmd_ready(w_tx_cmd_ready),
            .cmd_length(w_tx_length), .cmd_rate(w_tx_rate), .cmd_upsample(w_tx_upsample),
            .data_byte(w_tx_data), .data_valid(w_tx_data_valid), .data_last(w_tx_data_last),
            .data_ready(w_tx_data_ready), .tx_done(w_tx_done), .tx_error(w_tx_error),
            .submitted(ts), .completed(tc), .rejected(tr), .failed(tf), .last_cookie(cookie),
            .phy_reset(w_tx_phy_reset)
        );
        ofdm_dma_rx u_dma_rx (
            .clk(data_clk), .reset(packet_reset), .packet_start(w_rx_packet_start),
            .rx_valid(w_payload_valid), .rx_byte(w_payload_byte),
            .fcs_strobe(w_fcs_strobe), .fcs_ok(w_fcs_ok), .rx_length(w_rx_length),
            .m_data(m_axis_rx_tdata), .m_valid(m_axis_rx_tvalid), .m_last(m_axis_rx_tlast),
            .m_ready(m_axis_rx_tready), .accepted(ra), .dropped(rd), .overflow(ro), .timed_out(rt)
        );
    end endgenerate


    tx802p11_ip #(.RS_ENABLE(RS_ENABLE), .RS_INTERLEAVE(RS_INTERLEAVE)) u_ofdm_tx (
        .clk				(data_clk), 
		.reset				(w_tx_phy_reset),
        .cmd_valid			(w_tx_cmd_valid), 
		.cmd_ready			(w_tx_cmd_ready),
        .cmd_length			(w_tx_length), 
		.cmd_rate			(w_tx_rate),
        .cmd_upsample		(w_tx_upsample), 
		.s_valid			(w_tx_data_valid),
        .s_last				(w_tx_data_last), 
		.s_data				(w_tx_data),
        .s_ready			(w_tx_data_ready), 
		.m_valid			(w_tx_sample_valid),
        .m_re				(w_tx_sample_i), 
		.m_im				(w_tx_sample_q),
        .busy				(), 
		.done				(w_tx_done), 
		.error				(w_tx_error)
    );


    ofdm_iq_scale 	u_iq_scale (
        .iw_clk				(data_clk), 
		.iw_rst				(w_rst),
        .iw_tx_valid		(w_tx_sample_valid), 
		.iw_tx_clear		(w_tx_done || w_tx_phy_reset),
        .iw_tx_i			(w_tx_sample_i), 
		.iw_tx_q			(w_tx_sample_q),
        .ow_tx_valid		(w_tx_scaled_valid),
        .ow_tx_i			(w_tx_scaled_i), 
		.ow_tx_q			(w_tx_scaled_q),
        .iw_rx_valid		(rx_data_ch1_vaild), 
		.iw_rx_i			(rx_data_ch1_i),
        .iw_rx_q			(rx_data_ch1_q), 
		.ow_rx_valid		(w_rx_scaled_valid),
        .ow_rx_i			(w_rx_scaled_i), 
		.ow_rx_q			(w_rx_scaled_q)
    );


    rx802p11_top #(.RS_ENABLE(RS_ENABLE), .RS_INTERLEAVE(RS_INTERLEAVE)) u_ofdm_rx (
        .sclk					(data_clk), 
		.reset					(w_rst), 
		.enable					(1'b1),
        .sample_in_i			(w_rx_scaled_i), 
		.sample_in_q			(w_rx_scaled_q),
        .sample_in_valid		(w_rx_scaled_valid),
        .short_preamble_detected(),
        .threshold_neg_pos_value(32'd100), 
		.peak_threshold			(16'd10000),
        .fcs_data_out_valid		(w_payload_valid), 
		.fcs_data_out			(w_payload_byte),
        .fcs_ok_strobe			(w_fcs_strobe), 
		.fcs_ok					(w_fcs_ok),
        .pkt_length				(w_rx_length), 
        .packet_start                   (w_rx_packet_start),
		.data_csi_i				(), 
		.data_csi_q				(),
        .data_csi_valid			(), 
		.data_chnl_out_i		(), 
		.data_chnl_out_q		(),
        .data_chnl_out_valid	()
    );

    ad936x_phy_TOP 	u_phy (
        .rst_n				(!w_rst), 
        .TR_mode			(r_tr_mode_sync2),
        .data_clk_p			(data_clk_p), 
		.data_clk_n			(data_clk_n),
        .rx_data_p			(rx_data_p), 
		.rx_data_n			(rx_data_n),
        .rx_frame_p			(rx_frame_p), 
		.rx_frame_n			(rx_frame_n),
        .data_clk			(data_clk_AD936x), 
		.rx_frame			(rx_frame),
        .rx_data_ch1_i		(rx_data_ch1_i), 
		.rx_data_ch1_q		(rx_data_ch1_q),
        .rx_data_ch2_i		(rx_data_ch2_i), 
		.rx_data_ch2_q		(rx_data_ch2_q),
        .rx_data_ch1_vaild	(rx_data_ch1_vaild),
        .rx_data_ch2_vaild	(rx_data_ch2_vaild),
        .tx_data_ch1_i		(w_tx_scaled_i), 
		.tx_data_ch1_q		(w_tx_scaled_q),
        .tx_data_ch2_i		(12'd0), 
		.tx_data_ch2_q		(12'd0),
        .tx_data_vaild		(w_tx_scaled_valid),
        .fb_clk_p			(fb_clk_p), 
		.fb_clk_n			(fb_clk_n),
        .tx_data_p			(tx_data_p), 
		.tx_data_n			(tx_data_n),
        .tx_frame_p			(tx_frame_p), 
		.tx_frame_n			(tx_frame_n)
    );


endmodule