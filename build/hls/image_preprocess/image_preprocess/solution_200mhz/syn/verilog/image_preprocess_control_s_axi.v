// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
`timescale 1ns/1ps
module image_preprocess_control_s_axi
#(parameter
    C_S_AXI_ADDR_WIDTH = 9,
    C_S_AXI_DATA_WIDTH = 32
)(
    input  wire                          ACLK,
    input  wire                          ARESET,
    input  wire                          ACLK_EN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] AWADDR,
    input  wire                          AWVALID,
    output wire                          AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0] WDATA,
    input  wire [C_S_AXI_DATA_WIDTH/8-1:0] WSTRB,
    input  wire                          WVALID,
    output wire                          WREADY,
    output wire [1:0]                    BRESP,
    output wire                          BVALID,
    input  wire                          BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] ARADDR,
    input  wire                          ARVALID,
    output wire                          ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0] RDATA,
    output wire [1:0]                    RRESP,
    output wire                          RVALID,
    input  wire                          RREADY,
    output wire                          interrupt,
    output wire                          ap_start,
    input  wire                          ap_done,
    input  wire                          ap_ready,
    input  wire                          ap_idle,
    input  wire [31:0]                   ap_return,
    output wire [63:0]                   src,
    output wire [63:0]                   tensor,
    output wire [63:0]                   preview,
    output wire [63:0]                   luts,
    output wire [31:0]                   width,
    output wire [31:0]                   height,
    output wire [31:0]                   src_stride,
    output wire [31:0]                   src_capacity,
    output wire [31:0]                   tensor_capacity,
    output wire [31:0]                   preview_stride,
    output wire [31:0]                   preview_capacity,
    output wire [31:0]                   resized_w,
    output wire [31:0]                   resized_h,
    output wire [31:0]                   pad_x,
    output wire [31:0]                   pad_y,
    output wire [31:0]                   output_mode,
    output wire [31:0]                   flags,
    output wire [31:0]                   eq_mode,
    output wire [31:0]                   saturation_q12,
    output wire [31:0]                   frame_id,
    output wire [31:0]                   config_id,
    input  wire [31:0]                   completed_frame_id,
    input  wire                          completed_frame_id_ap_vld,
    input  wire [31:0]                   completed_config_id,
    input  wire                          completed_config_id_ap_vld,
    input  wire [31:0]                   tensor_bytes,
    input  wire                          tensor_bytes_ap_vld,
    input  wire [31:0]                   preview_bytes,
    input  wire                          preview_bytes_ap_vld,
    input  wire [31:0]                   abi_version,
    input  wire                          abi_version_ap_vld
);
//------------------------Address Info-------------------
// 0x000 : Control signals
//         bit 0  - ap_start (Read/Write/COH)
//         bit 1  - ap_done (Read/COR)
//         bit 2  - ap_idle (Read)
//         bit 3  - ap_ready (Read/COR)
//         bit 7  - auto_restart (Read/Write)
//         bit 9  - interrupt (Read)
//         others - reserved
// 0x004 : Global Interrupt Enable Register
//         bit 0  - Global Interrupt Enable (Read/Write)
//         others - reserved
// 0x008 : IP Interrupt Enable Register (Read/Write)
//         bit 0 - enable ap_done interrupt (Read/Write)
//         bit 1 - enable ap_ready interrupt (Read/Write)
//         others - reserved
// 0x00c : IP Interrupt Status Register (Read/COR)
//         bit 0 - ap_done (Read/COR)
//         bit 1 - ap_ready (Read/COR)
//         others - reserved
// 0x010 : Data signal of ap_return
//         bit 31~0 - ap_return[31:0] (Read)
// 0x018 : Data signal of src
//         bit 31~0 - src[31:0] (Read/Write)
// 0x01c : Data signal of src
//         bit 31~0 - src[63:32] (Read/Write)
// 0x020 : reserved
// 0x024 : Data signal of tensor
//         bit 31~0 - tensor[31:0] (Read/Write)
// 0x028 : Data signal of tensor
//         bit 31~0 - tensor[63:32] (Read/Write)
// 0x02c : reserved
// 0x030 : Data signal of preview
//         bit 31~0 - preview[31:0] (Read/Write)
// 0x034 : Data signal of preview
//         bit 31~0 - preview[63:32] (Read/Write)
// 0x038 : reserved
// 0x03c : Data signal of luts
//         bit 31~0 - luts[31:0] (Read/Write)
// 0x040 : Data signal of luts
//         bit 31~0 - luts[63:32] (Read/Write)
// 0x044 : reserved
// 0x048 : Data signal of width
//         bit 31~0 - width[31:0] (Read/Write)
// 0x04c : reserved
// 0x050 : Data signal of height
//         bit 31~0 - height[31:0] (Read/Write)
// 0x054 : reserved
// 0x058 : Data signal of src_stride
//         bit 31~0 - src_stride[31:0] (Read/Write)
// 0x05c : reserved
// 0x060 : Data signal of src_capacity
//         bit 31~0 - src_capacity[31:0] (Read/Write)
// 0x064 : reserved
// 0x068 : Data signal of tensor_capacity
//         bit 31~0 - tensor_capacity[31:0] (Read/Write)
// 0x06c : reserved
// 0x070 : Data signal of preview_stride
//         bit 31~0 - preview_stride[31:0] (Read/Write)
// 0x074 : reserved
// 0x078 : Data signal of preview_capacity
//         bit 31~0 - preview_capacity[31:0] (Read/Write)
// 0x07c : reserved
// 0x080 : Data signal of resized_w
//         bit 31~0 - resized_w[31:0] (Read/Write)
// 0x084 : reserved
// 0x088 : Data signal of resized_h
//         bit 31~0 - resized_h[31:0] (Read/Write)
// 0x08c : reserved
// 0x090 : Data signal of pad_x
//         bit 31~0 - pad_x[31:0] (Read/Write)
// 0x094 : reserved
// 0x098 : Data signal of pad_y
//         bit 31~0 - pad_y[31:0] (Read/Write)
// 0x09c : reserved
// 0x0a0 : Data signal of output_mode
//         bit 31~0 - output_mode[31:0] (Read/Write)
// 0x0a4 : reserved
// 0x0a8 : Data signal of flags
//         bit 31~0 - flags[31:0] (Read/Write)
// 0x0ac : reserved
// 0x0b0 : Data signal of eq_mode
//         bit 31~0 - eq_mode[31:0] (Read/Write)
// 0x0b4 : reserved
// 0x0b8 : Data signal of saturation_q12
//         bit 31~0 - saturation_q12[31:0] (Read/Write)
// 0x0bc : reserved
// 0x0c0 : Data signal of frame_id
//         bit 31~0 - frame_id[31:0] (Read/Write)
// 0x0c4 : reserved
// 0x0c8 : Data signal of config_id
//         bit 31~0 - config_id[31:0] (Read/Write)
// 0x0cc : reserved
// 0x0d0 : Data signal of completed_frame_id
//         bit 31~0 - completed_frame_id[31:0] (Read)
// 0x0d4 : Control signal of completed_frame_id
//         bit 0  - completed_frame_id_ap_vld (Read/COR)
//         others - reserved
// 0x0e0 : Data signal of completed_config_id
//         bit 31~0 - completed_config_id[31:0] (Read)
// 0x0e4 : Control signal of completed_config_id
//         bit 0  - completed_config_id_ap_vld (Read/COR)
//         others - reserved
// 0x0f0 : Data signal of tensor_bytes
//         bit 31~0 - tensor_bytes[31:0] (Read)
// 0x0f4 : Control signal of tensor_bytes
//         bit 0  - tensor_bytes_ap_vld (Read/COR)
//         others - reserved
// 0x100 : Data signal of preview_bytes
//         bit 31~0 - preview_bytes[31:0] (Read)
// 0x104 : Control signal of preview_bytes
//         bit 0  - preview_bytes_ap_vld (Read/COR)
//         others - reserved
// 0x110 : Data signal of abi_version
//         bit 31~0 - abi_version[31:0] (Read)
// 0x114 : Control signal of abi_version
//         bit 0  - abi_version_ap_vld (Read/COR)
//         others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

//------------------------Parameter----------------------
localparam
    ADDR_AP_CTRL                    = 9'h000,
    ADDR_GIE                        = 9'h004,
    ADDR_IER                        = 9'h008,
    ADDR_ISR                        = 9'h00c,
    ADDR_AP_RETURN_0                = 9'h010,
    ADDR_SRC_DATA_0                 = 9'h018,
    ADDR_SRC_DATA_1                 = 9'h01c,
    ADDR_SRC_CTRL                   = 9'h020,
    ADDR_TENSOR_DATA_0              = 9'h024,
    ADDR_TENSOR_DATA_1              = 9'h028,
    ADDR_TENSOR_CTRL                = 9'h02c,
    ADDR_PREVIEW_DATA_0             = 9'h030,
    ADDR_PREVIEW_DATA_1             = 9'h034,
    ADDR_PREVIEW_CTRL               = 9'h038,
    ADDR_LUTS_DATA_0                = 9'h03c,
    ADDR_LUTS_DATA_1                = 9'h040,
    ADDR_LUTS_CTRL                  = 9'h044,
    ADDR_WIDTH_DATA_0               = 9'h048,
    ADDR_WIDTH_CTRL                 = 9'h04c,
    ADDR_HEIGHT_DATA_0              = 9'h050,
    ADDR_HEIGHT_CTRL                = 9'h054,
    ADDR_SRC_STRIDE_DATA_0          = 9'h058,
    ADDR_SRC_STRIDE_CTRL            = 9'h05c,
    ADDR_SRC_CAPACITY_DATA_0        = 9'h060,
    ADDR_SRC_CAPACITY_CTRL          = 9'h064,
    ADDR_TENSOR_CAPACITY_DATA_0     = 9'h068,
    ADDR_TENSOR_CAPACITY_CTRL       = 9'h06c,
    ADDR_PREVIEW_STRIDE_DATA_0      = 9'h070,
    ADDR_PREVIEW_STRIDE_CTRL        = 9'h074,
    ADDR_PREVIEW_CAPACITY_DATA_0    = 9'h078,
    ADDR_PREVIEW_CAPACITY_CTRL      = 9'h07c,
    ADDR_RESIZED_W_DATA_0           = 9'h080,
    ADDR_RESIZED_W_CTRL             = 9'h084,
    ADDR_RESIZED_H_DATA_0           = 9'h088,
    ADDR_RESIZED_H_CTRL             = 9'h08c,
    ADDR_PAD_X_DATA_0               = 9'h090,
    ADDR_PAD_X_CTRL                 = 9'h094,
    ADDR_PAD_Y_DATA_0               = 9'h098,
    ADDR_PAD_Y_CTRL                 = 9'h09c,
    ADDR_OUTPUT_MODE_DATA_0         = 9'h0a0,
    ADDR_OUTPUT_MODE_CTRL           = 9'h0a4,
    ADDR_FLAGS_DATA_0               = 9'h0a8,
    ADDR_FLAGS_CTRL                 = 9'h0ac,
    ADDR_EQ_MODE_DATA_0             = 9'h0b0,
    ADDR_EQ_MODE_CTRL               = 9'h0b4,
    ADDR_SATURATION_Q12_DATA_0      = 9'h0b8,
    ADDR_SATURATION_Q12_CTRL        = 9'h0bc,
    ADDR_FRAME_ID_DATA_0            = 9'h0c0,
    ADDR_FRAME_ID_CTRL              = 9'h0c4,
    ADDR_CONFIG_ID_DATA_0           = 9'h0c8,
    ADDR_CONFIG_ID_CTRL             = 9'h0cc,
    ADDR_COMPLETED_FRAME_ID_DATA_0  = 9'h0d0,
    ADDR_COMPLETED_FRAME_ID_CTRL    = 9'h0d4,
    ADDR_COMPLETED_CONFIG_ID_DATA_0 = 9'h0e0,
    ADDR_COMPLETED_CONFIG_ID_CTRL   = 9'h0e4,
    ADDR_TENSOR_BYTES_DATA_0        = 9'h0f0,
    ADDR_TENSOR_BYTES_CTRL          = 9'h0f4,
    ADDR_PREVIEW_BYTES_DATA_0       = 9'h100,
    ADDR_PREVIEW_BYTES_CTRL         = 9'h104,
    ADDR_ABI_VERSION_DATA_0         = 9'h110,
    ADDR_ABI_VERSION_CTRL           = 9'h114,
    WRIDLE                          = 2'd0,
    WRDATA                          = 2'd1,
    WRRESP                          = 2'd2,
    WRRESET                         = 2'd3,
    RDIDLE                          = 2'd0,
    RDDATA                          = 2'd1,
    RDRESET                         = 2'd2,
    ADDR_BITS                = 9;

//------------------------Local signal-------------------
    reg  [1:0]                    wstate = WRRESET;
    reg  [1:0]                    wnext;
    reg  [ADDR_BITS-1:0]          waddr;
    wire [C_S_AXI_DATA_WIDTH-1:0] wmask;
    wire                          aw_hs;
    wire                          w_hs;
    reg  [1:0]                    rstate = RDRESET;
    reg  [1:0]                    rnext;
    reg  [C_S_AXI_DATA_WIDTH-1:0] rdata;
    wire                          ar_hs;
    wire [ADDR_BITS-1:0]          raddr;
    // internal registers
    reg                           int_ap_idle;
    reg                           int_ap_ready = 1'b0;
    wire                          task_ap_ready;
    reg                           int_ap_done = 1'b0;
    wire                          task_ap_done;
    reg                           int_task_ap_done = 1'b0;
    reg                           int_ap_start = 1'b0;
    reg                           int_interrupt = 1'b0;
    reg                           int_auto_restart = 1'b0;
    reg                           auto_restart_status = 1'b0;
    wire                          auto_restart_done;
    reg                           int_gie = 1'b0;
    reg  [1:0]                    int_ier = 2'b0;
    reg  [1:0]                    int_isr = 2'b0;
    reg  [31:0]                   int_ap_return;
    reg  [63:0]                   int_src = 'b0;
    reg  [63:0]                   int_tensor = 'b0;
    reg  [63:0]                   int_preview = 'b0;
    reg  [63:0]                   int_luts = 'b0;
    reg  [31:0]                   int_width = 'b0;
    reg  [31:0]                   int_height = 'b0;
    reg  [31:0]                   int_src_stride = 'b0;
    reg  [31:0]                   int_src_capacity = 'b0;
    reg  [31:0]                   int_tensor_capacity = 'b0;
    reg  [31:0]                   int_preview_stride = 'b0;
    reg  [31:0]                   int_preview_capacity = 'b0;
    reg  [31:0]                   int_resized_w = 'b0;
    reg  [31:0]                   int_resized_h = 'b0;
    reg  [31:0]                   int_pad_x = 'b0;
    reg  [31:0]                   int_pad_y = 'b0;
    reg  [31:0]                   int_output_mode = 'b0;
    reg  [31:0]                   int_flags = 'b0;
    reg  [31:0]                   int_eq_mode = 'b0;
    reg  [31:0]                   int_saturation_q12 = 'b0;
    reg  [31:0]                   int_frame_id = 'b0;
    reg  [31:0]                   int_config_id = 'b0;
    reg                           int_completed_frame_id_ap_vld;
    reg  [31:0]                   int_completed_frame_id = 'b0;
    reg                           int_completed_config_id_ap_vld;
    reg  [31:0]                   int_completed_config_id = 'b0;
    reg                           int_tensor_bytes_ap_vld;
    reg  [31:0]                   int_tensor_bytes = 'b0;
    reg                           int_preview_bytes_ap_vld;
    reg  [31:0]                   int_preview_bytes = 'b0;
    reg                           int_abi_version_ap_vld;
    reg  [31:0]                   int_abi_version = 'b0;

//------------------------Instantiation------------------


//------------------------AXI write fsm------------------
assign AWREADY = (wstate == WRIDLE);
assign WREADY  = (wstate == WRDATA);
assign BRESP   = 2'b00;  // OKAY
assign BVALID  = (wstate == WRRESP);
assign wmask   = { {8{WSTRB[3]}}, {8{WSTRB[2]}}, {8{WSTRB[1]}}, {8{WSTRB[0]}} };
assign aw_hs   = AWVALID & AWREADY;
assign w_hs    = WVALID & WREADY;

// wstate
always @(posedge ACLK) begin
    if (ARESET)
        wstate <= WRRESET;
    else if (ACLK_EN)
        wstate <= wnext;
end

// wnext
always @(*) begin
    case (wstate)
        WRIDLE:
            if (AWVALID)
                wnext = WRDATA;
            else
                wnext = WRIDLE;
        WRDATA:
            if (WVALID)
                wnext = WRRESP;
            else
                wnext = WRDATA;
        WRRESP:
            if (BREADY)
                wnext = WRIDLE;
            else
                wnext = WRRESP;
        default:
            wnext = WRIDLE;
    endcase
end

// waddr
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (aw_hs)
            waddr <= AWADDR[ADDR_BITS-1:0];
    end
end

//------------------------AXI read fsm-------------------
assign ARREADY = (rstate == RDIDLE);
assign RDATA   = rdata;
assign RRESP   = 2'b00;  // OKAY
assign RVALID  = (rstate == RDDATA);
assign ar_hs   = ARVALID & ARREADY;
assign raddr   = ARADDR[ADDR_BITS-1:0];

// rstate
always @(posedge ACLK) begin
    if (ARESET)
        rstate <= RDRESET;
    else if (ACLK_EN)
        rstate <= rnext;
end

// rnext
always @(*) begin
    case (rstate)
        RDIDLE:
            if (ARVALID)
                rnext = RDDATA;
            else
                rnext = RDIDLE;
        RDDATA:
            if (RREADY & RVALID)
                rnext = RDIDLE;
            else
                rnext = RDDATA;
        default:
            rnext = RDIDLE;
    endcase
end

// rdata
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (ar_hs) begin
            rdata <= 'b0;
            case (raddr)
                ADDR_AP_CTRL: begin
                    rdata[0] <= int_ap_start;
                    rdata[1] <= int_task_ap_done;
                    rdata[2] <= int_ap_idle;
                    rdata[3] <= int_ap_ready;
                    rdata[7] <= int_auto_restart;
                    rdata[9] <= int_interrupt;
                end
                ADDR_GIE: begin
                    rdata <= int_gie;
                end
                ADDR_IER: begin
                    rdata <= int_ier;
                end
                ADDR_ISR: begin
                    rdata <= int_isr;
                end
                ADDR_AP_RETURN_0: begin
                    rdata <= int_ap_return[31:0];
                end
                ADDR_SRC_DATA_0: begin
                    rdata <= int_src[31:0];
                end
                ADDR_SRC_DATA_1: begin
                    rdata <= int_src[63:32];
                end
                ADDR_TENSOR_DATA_0: begin
                    rdata <= int_tensor[31:0];
                end
                ADDR_TENSOR_DATA_1: begin
                    rdata <= int_tensor[63:32];
                end
                ADDR_PREVIEW_DATA_0: begin
                    rdata <= int_preview[31:0];
                end
                ADDR_PREVIEW_DATA_1: begin
                    rdata <= int_preview[63:32];
                end
                ADDR_LUTS_DATA_0: begin
                    rdata <= int_luts[31:0];
                end
                ADDR_LUTS_DATA_1: begin
                    rdata <= int_luts[63:32];
                end
                ADDR_WIDTH_DATA_0: begin
                    rdata <= int_width[31:0];
                end
                ADDR_HEIGHT_DATA_0: begin
                    rdata <= int_height[31:0];
                end
                ADDR_SRC_STRIDE_DATA_0: begin
                    rdata <= int_src_stride[31:0];
                end
                ADDR_SRC_CAPACITY_DATA_0: begin
                    rdata <= int_src_capacity[31:0];
                end
                ADDR_TENSOR_CAPACITY_DATA_0: begin
                    rdata <= int_tensor_capacity[31:0];
                end
                ADDR_PREVIEW_STRIDE_DATA_0: begin
                    rdata <= int_preview_stride[31:0];
                end
                ADDR_PREVIEW_CAPACITY_DATA_0: begin
                    rdata <= int_preview_capacity[31:0];
                end
                ADDR_RESIZED_W_DATA_0: begin
                    rdata <= int_resized_w[31:0];
                end
                ADDR_RESIZED_H_DATA_0: begin
                    rdata <= int_resized_h[31:0];
                end
                ADDR_PAD_X_DATA_0: begin
                    rdata <= int_pad_x[31:0];
                end
                ADDR_PAD_Y_DATA_0: begin
                    rdata <= int_pad_y[31:0];
                end
                ADDR_OUTPUT_MODE_DATA_0: begin
                    rdata <= int_output_mode[31:0];
                end
                ADDR_FLAGS_DATA_0: begin
                    rdata <= int_flags[31:0];
                end
                ADDR_EQ_MODE_DATA_0: begin
                    rdata <= int_eq_mode[31:0];
                end
                ADDR_SATURATION_Q12_DATA_0: begin
                    rdata <= int_saturation_q12[31:0];
                end
                ADDR_FRAME_ID_DATA_0: begin
                    rdata <= int_frame_id[31:0];
                end
                ADDR_CONFIG_ID_DATA_0: begin
                    rdata <= int_config_id[31:0];
                end
                ADDR_COMPLETED_FRAME_ID_DATA_0: begin
                    rdata <= int_completed_frame_id[31:0];
                end
                ADDR_COMPLETED_FRAME_ID_CTRL: begin
                    rdata[0] <= int_completed_frame_id_ap_vld;
                end
                ADDR_COMPLETED_CONFIG_ID_DATA_0: begin
                    rdata <= int_completed_config_id[31:0];
                end
                ADDR_COMPLETED_CONFIG_ID_CTRL: begin
                    rdata[0] <= int_completed_config_id_ap_vld;
                end
                ADDR_TENSOR_BYTES_DATA_0: begin
                    rdata <= int_tensor_bytes[31:0];
                end
                ADDR_TENSOR_BYTES_CTRL: begin
                    rdata[0] <= int_tensor_bytes_ap_vld;
                end
                ADDR_PREVIEW_BYTES_DATA_0: begin
                    rdata <= int_preview_bytes[31:0];
                end
                ADDR_PREVIEW_BYTES_CTRL: begin
                    rdata[0] <= int_preview_bytes_ap_vld;
                end
                ADDR_ABI_VERSION_DATA_0: begin
                    rdata <= int_abi_version[31:0];
                end
                ADDR_ABI_VERSION_CTRL: begin
                    rdata[0] <= int_abi_version_ap_vld;
                end
            endcase
        end
    end
end


//------------------------Register logic-----------------
assign interrupt         = int_interrupt;
assign ap_start          = int_ap_start;
assign task_ap_done      = (ap_done && !auto_restart_status) || auto_restart_done;
assign task_ap_ready     = ap_ready && !int_auto_restart;
assign auto_restart_done = auto_restart_status && (ap_idle && !int_ap_idle);
assign src               = int_src;
assign tensor            = int_tensor;
assign preview           = int_preview;
assign luts              = int_luts;
assign width             = int_width;
assign height            = int_height;
assign src_stride        = int_src_stride;
assign src_capacity      = int_src_capacity;
assign tensor_capacity   = int_tensor_capacity;
assign preview_stride    = int_preview_stride;
assign preview_capacity  = int_preview_capacity;
assign resized_w         = int_resized_w;
assign resized_h         = int_resized_h;
assign pad_x             = int_pad_x;
assign pad_y             = int_pad_y;
assign output_mode       = int_output_mode;
assign flags             = int_flags;
assign eq_mode           = int_eq_mode;
assign saturation_q12    = int_saturation_q12;
assign frame_id          = int_frame_id;
assign config_id         = int_config_id;
// int_interrupt
always @(posedge ACLK) begin
    if (ARESET)
        int_interrupt <= 1'b0;
    else if (ACLK_EN) begin
        if (int_gie && (|int_isr))
            int_interrupt <= 1'b1;
        else
            int_interrupt <= 1'b0;
    end
end

// int_ap_start
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_start <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AP_CTRL && WSTRB[0] && WDATA[0])
            int_ap_start <= 1'b1;
        else if (ap_ready)
            int_ap_start <= int_auto_restart; // clear on handshake/auto restart
    end
end

// int_ap_done
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_done <= 1'b0;
    else if (ACLK_EN) begin
            int_ap_done <= ap_done;
    end
end

// int_task_ap_done
always @(posedge ACLK) begin
    if (ARESET)
        int_task_ap_done <= 1'b0;
    else if (ACLK_EN) begin
        if (task_ap_done)
            int_task_ap_done <= 1'b1;
        else if (ar_hs && raddr == ADDR_AP_CTRL)
            int_task_ap_done <= 1'b0; // clear on read
    end
end

// int_ap_idle
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_idle <= 1'b0;
    else if (ACLK_EN) begin
            int_ap_idle <= ap_idle;
    end
end

// int_ap_ready
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_ready <= 1'b0;
    else if (ACLK_EN) begin
        if (task_ap_ready)
            int_ap_ready <= 1'b1;
        else if (ar_hs && raddr == ADDR_AP_CTRL)
            int_ap_ready <= 1'b0;
    end
end

// int_auto_restart
always @(posedge ACLK) begin
    if (ARESET)
        int_auto_restart <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AP_CTRL && WSTRB[0])
            int_auto_restart <=  WDATA[7];
    end
end

// auto_restart_status
always @(posedge ACLK) begin
    if (ARESET)
        auto_restart_status <= 1'b0;
    else if (ACLK_EN) begin
        if (int_auto_restart)
            auto_restart_status <= 1'b1;
        else if (ap_idle)
            auto_restart_status <= 1'b0;
    end
end

// int_gie
always @(posedge ACLK) begin
    if (ARESET)
        int_gie <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_GIE && WSTRB[0])
            int_gie <= WDATA[0];
    end
end

// int_ier
always @(posedge ACLK) begin
    if (ARESET)
        int_ier <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_IER && WSTRB[0])
            int_ier <= WDATA[1:0];
    end
end

// int_isr[0]
always @(posedge ACLK) begin
    if (ARESET)
        int_isr[0] <= 1'b0;
    else if (ACLK_EN) begin
        if (int_ier[0] & ap_done)
            int_isr[0] <= 1'b1;
        else if (ar_hs && raddr == ADDR_ISR)
            int_isr[0] <= 1'b0; // clear on read
    end
end

// int_isr[1]
always @(posedge ACLK) begin
    if (ARESET)
        int_isr[1] <= 1'b0;
    else if (ACLK_EN) begin
        if (int_ier[1] & ap_ready)
            int_isr[1] <= 1'b1;
        else if (ar_hs && raddr == ADDR_ISR)
            int_isr[1] <= 1'b0; // clear on read
    end
end

// int_ap_return
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_return <= 0;
    else if (ACLK_EN) begin
        if (ap_done)
            int_ap_return <= ap_return;
    end
end

// int_src[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_src[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SRC_DATA_0)
            int_src[31:0] <= (WDATA[31:0] & wmask) | (int_src[31:0] & ~wmask);
    end
end

// int_src[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_src[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SRC_DATA_1)
            int_src[63:32] <= (WDATA[31:0] & wmask) | (int_src[63:32] & ~wmask);
    end
end

// int_tensor[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_tensor[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_TENSOR_DATA_0)
            int_tensor[31:0] <= (WDATA[31:0] & wmask) | (int_tensor[31:0] & ~wmask);
    end
end

// int_tensor[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_tensor[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_TENSOR_DATA_1)
            int_tensor[63:32] <= (WDATA[31:0] & wmask) | (int_tensor[63:32] & ~wmask);
    end
end

// int_preview[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_preview[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_PREVIEW_DATA_0)
            int_preview[31:0] <= (WDATA[31:0] & wmask) | (int_preview[31:0] & ~wmask);
    end
end

// int_preview[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_preview[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_PREVIEW_DATA_1)
            int_preview[63:32] <= (WDATA[31:0] & wmask) | (int_preview[63:32] & ~wmask);
    end
end

// int_luts[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_luts[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_LUTS_DATA_0)
            int_luts[31:0] <= (WDATA[31:0] & wmask) | (int_luts[31:0] & ~wmask);
    end
end

// int_luts[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_luts[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_LUTS_DATA_1)
            int_luts[63:32] <= (WDATA[31:0] & wmask) | (int_luts[63:32] & ~wmask);
    end
end

// int_width[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_width[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_WIDTH_DATA_0)
            int_width[31:0] <= (WDATA[31:0] & wmask) | (int_width[31:0] & ~wmask);
    end
end

// int_height[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_height[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_HEIGHT_DATA_0)
            int_height[31:0] <= (WDATA[31:0] & wmask) | (int_height[31:0] & ~wmask);
    end
end

// int_src_stride[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_src_stride[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SRC_STRIDE_DATA_0)
            int_src_stride[31:0] <= (WDATA[31:0] & wmask) | (int_src_stride[31:0] & ~wmask);
    end
end

// int_src_capacity[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_src_capacity[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SRC_CAPACITY_DATA_0)
            int_src_capacity[31:0] <= (WDATA[31:0] & wmask) | (int_src_capacity[31:0] & ~wmask);
    end
end

// int_tensor_capacity[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_tensor_capacity[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_TENSOR_CAPACITY_DATA_0)
            int_tensor_capacity[31:0] <= (WDATA[31:0] & wmask) | (int_tensor_capacity[31:0] & ~wmask);
    end
end

// int_preview_stride[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_preview_stride[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_PREVIEW_STRIDE_DATA_0)
            int_preview_stride[31:0] <= (WDATA[31:0] & wmask) | (int_preview_stride[31:0] & ~wmask);
    end
end

// int_preview_capacity[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_preview_capacity[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_PREVIEW_CAPACITY_DATA_0)
            int_preview_capacity[31:0] <= (WDATA[31:0] & wmask) | (int_preview_capacity[31:0] & ~wmask);
    end
end

// int_resized_w[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_resized_w[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_RESIZED_W_DATA_0)
            int_resized_w[31:0] <= (WDATA[31:0] & wmask) | (int_resized_w[31:0] & ~wmask);
    end
end

// int_resized_h[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_resized_h[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_RESIZED_H_DATA_0)
            int_resized_h[31:0] <= (WDATA[31:0] & wmask) | (int_resized_h[31:0] & ~wmask);
    end
end

// int_pad_x[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_pad_x[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_PAD_X_DATA_0)
            int_pad_x[31:0] <= (WDATA[31:0] & wmask) | (int_pad_x[31:0] & ~wmask);
    end
end

// int_pad_y[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_pad_y[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_PAD_Y_DATA_0)
            int_pad_y[31:0] <= (WDATA[31:0] & wmask) | (int_pad_y[31:0] & ~wmask);
    end
end

// int_output_mode[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_output_mode[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_OUTPUT_MODE_DATA_0)
            int_output_mode[31:0] <= (WDATA[31:0] & wmask) | (int_output_mode[31:0] & ~wmask);
    end
end

// int_flags[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_flags[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_FLAGS_DATA_0)
            int_flags[31:0] <= (WDATA[31:0] & wmask) | (int_flags[31:0] & ~wmask);
    end
end

// int_eq_mode[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_eq_mode[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_EQ_MODE_DATA_0)
            int_eq_mode[31:0] <= (WDATA[31:0] & wmask) | (int_eq_mode[31:0] & ~wmask);
    end
end

// int_saturation_q12[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_saturation_q12[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_SATURATION_Q12_DATA_0)
            int_saturation_q12[31:0] <= (WDATA[31:0] & wmask) | (int_saturation_q12[31:0] & ~wmask);
    end
end

// int_frame_id[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_frame_id[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_FRAME_ID_DATA_0)
            int_frame_id[31:0] <= (WDATA[31:0] & wmask) | (int_frame_id[31:0] & ~wmask);
    end
end

// int_config_id[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_config_id[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_CONFIG_ID_DATA_0)
            int_config_id[31:0] <= (WDATA[31:0] & wmask) | (int_config_id[31:0] & ~wmask);
    end
end

// int_completed_frame_id
always @(posedge ACLK) begin
    if (ARESET)
        int_completed_frame_id <= 0;
    else if (ACLK_EN) begin
        if (completed_frame_id_ap_vld)
            int_completed_frame_id <= completed_frame_id;
    end
end

// int_completed_frame_id_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_completed_frame_id_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (completed_frame_id_ap_vld)
            int_completed_frame_id_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_COMPLETED_FRAME_ID_CTRL)
            int_completed_frame_id_ap_vld <= 1'b0; // clear on read
    end
end

// int_completed_config_id
always @(posedge ACLK) begin
    if (ARESET)
        int_completed_config_id <= 0;
    else if (ACLK_EN) begin
        if (completed_config_id_ap_vld)
            int_completed_config_id <= completed_config_id;
    end
end

// int_completed_config_id_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_completed_config_id_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (completed_config_id_ap_vld)
            int_completed_config_id_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_COMPLETED_CONFIG_ID_CTRL)
            int_completed_config_id_ap_vld <= 1'b0; // clear on read
    end
end

// int_tensor_bytes
always @(posedge ACLK) begin
    if (ARESET)
        int_tensor_bytes <= 0;
    else if (ACLK_EN) begin
        if (tensor_bytes_ap_vld)
            int_tensor_bytes <= tensor_bytes;
    end
end

// int_tensor_bytes_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_tensor_bytes_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (tensor_bytes_ap_vld)
            int_tensor_bytes_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_TENSOR_BYTES_CTRL)
            int_tensor_bytes_ap_vld <= 1'b0; // clear on read
    end
end

// int_preview_bytes
always @(posedge ACLK) begin
    if (ARESET)
        int_preview_bytes <= 0;
    else if (ACLK_EN) begin
        if (preview_bytes_ap_vld)
            int_preview_bytes <= preview_bytes;
    end
end

// int_preview_bytes_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_preview_bytes_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (preview_bytes_ap_vld)
            int_preview_bytes_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_PREVIEW_BYTES_CTRL)
            int_preview_bytes_ap_vld <= 1'b0; // clear on read
    end
end

// int_abi_version
always @(posedge ACLK) begin
    if (ARESET)
        int_abi_version <= 0;
    else if (ACLK_EN) begin
        if (abi_version_ap_vld)
            int_abi_version <= abi_version;
    end
end

// int_abi_version_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_abi_version_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (abi_version_ap_vld)
            int_abi_version_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_ABI_VERSION_CTRL)
            int_abi_version_ap_vld <= 1'b0; // clear on read
    end
end

//synthesis translate_off
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (int_gie & ~int_isr[0] & int_ier[0] & ap_done)
            $display ("// Interrupt Monitor : interrupt for ap_done detected @ \"%0t\"", $time);
        if (int_gie & ~int_isr[1] & int_ier[1] & ap_ready)
            $display ("// Interrupt Monitor : interrupt for ap_ready detected @ \"%0t\"", $time);
    end
end
//synthesis translate_on

//------------------------Memory logic-------------------

endmodule
