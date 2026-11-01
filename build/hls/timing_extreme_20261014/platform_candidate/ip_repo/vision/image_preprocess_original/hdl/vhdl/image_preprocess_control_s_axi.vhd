-- ==============================================================
-- Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
-- Tool Version Limit: 2022.04
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity image_preprocess_control_s_axi is
generic (
    C_S_AXI_ADDR_WIDTH    : INTEGER := 9;
    C_S_AXI_DATA_WIDTH    : INTEGER := 32);
port (
    ACLK                  :in   STD_LOGIC;
    ARESET                :in   STD_LOGIC;
    ACLK_EN               :in   STD_LOGIC;
    AWADDR                :in   STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    AWVALID               :in   STD_LOGIC;
    AWREADY               :out  STD_LOGIC;
    WDATA                 :in   STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    WSTRB                 :in   STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH/8-1 downto 0);
    WVALID                :in   STD_LOGIC;
    WREADY                :out  STD_LOGIC;
    BRESP                 :out  STD_LOGIC_VECTOR(1 downto 0);
    BVALID                :out  STD_LOGIC;
    BREADY                :in   STD_LOGIC;
    ARADDR                :in   STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    ARVALID               :in   STD_LOGIC;
    ARREADY               :out  STD_LOGIC;
    RDATA                 :out  STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    RRESP                 :out  STD_LOGIC_VECTOR(1 downto 0);
    RVALID                :out  STD_LOGIC;
    RREADY                :in   STD_LOGIC;
    interrupt             :out  STD_LOGIC;
    ap_start              :out  STD_LOGIC;
    ap_done               :in   STD_LOGIC;
    ap_ready              :in   STD_LOGIC;
    ap_idle               :in   STD_LOGIC;
    ap_return             :in   STD_LOGIC_VECTOR(31 downto 0);
    src                   :out  STD_LOGIC_VECTOR(63 downto 0);
    tensor                :out  STD_LOGIC_VECTOR(63 downto 0);
    preview               :out  STD_LOGIC_VECTOR(63 downto 0);
    luts                  :out  STD_LOGIC_VECTOR(63 downto 0);
    width                 :out  STD_LOGIC_VECTOR(31 downto 0);
    height                :out  STD_LOGIC_VECTOR(31 downto 0);
    src_stride            :out  STD_LOGIC_VECTOR(31 downto 0);
    src_capacity          :out  STD_LOGIC_VECTOR(31 downto 0);
    tensor_capacity       :out  STD_LOGIC_VECTOR(31 downto 0);
    preview_stride        :out  STD_LOGIC_VECTOR(31 downto 0);
    preview_capacity      :out  STD_LOGIC_VECTOR(31 downto 0);
    resized_w             :out  STD_LOGIC_VECTOR(31 downto 0);
    resized_h             :out  STD_LOGIC_VECTOR(31 downto 0);
    pad_x                 :out  STD_LOGIC_VECTOR(31 downto 0);
    pad_y                 :out  STD_LOGIC_VECTOR(31 downto 0);
    output_mode           :out  STD_LOGIC_VECTOR(31 downto 0);
    flags                 :out  STD_LOGIC_VECTOR(31 downto 0);
    eq_mode               :out  STD_LOGIC_VECTOR(31 downto 0);
    saturation_q12        :out  STD_LOGIC_VECTOR(31 downto 0);
    frame_id              :out  STD_LOGIC_VECTOR(31 downto 0);
    config_id             :out  STD_LOGIC_VECTOR(31 downto 0);
    completed_frame_id    :in   STD_LOGIC_VECTOR(31 downto 0);
    completed_frame_id_ap_vld :in   STD_LOGIC;
    completed_config_id   :in   STD_LOGIC_VECTOR(31 downto 0);
    completed_config_id_ap_vld :in   STD_LOGIC;
    tensor_bytes          :in   STD_LOGIC_VECTOR(31 downto 0);
    tensor_bytes_ap_vld   :in   STD_LOGIC;
    preview_bytes         :in   STD_LOGIC_VECTOR(31 downto 0);
    preview_bytes_ap_vld  :in   STD_LOGIC;
    abi_version           :in   STD_LOGIC_VECTOR(31 downto 0);
    abi_version_ap_vld    :in   STD_LOGIC
);
end entity image_preprocess_control_s_axi;

-- ------------------------Address Info-------------------
-- 0x000 : Control signals
--         bit 0  - ap_start (Read/Write/COH)
--         bit 1  - ap_done (Read/COR)
--         bit 2  - ap_idle (Read)
--         bit 3  - ap_ready (Read/COR)
--         bit 7  - auto_restart (Read/Write)
--         bit 9  - interrupt (Read)
--         others - reserved
-- 0x004 : Global Interrupt Enable Register
--         bit 0  - Global Interrupt Enable (Read/Write)
--         others - reserved
-- 0x008 : IP Interrupt Enable Register (Read/Write)
--         bit 0 - enable ap_done interrupt (Read/Write)
--         bit 1 - enable ap_ready interrupt (Read/Write)
--         others - reserved
-- 0x00c : IP Interrupt Status Register (Read/COR)
--         bit 0 - ap_done (Read/COR)
--         bit 1 - ap_ready (Read/COR)
--         others - reserved
-- 0x010 : Data signal of ap_return
--         bit 31~0 - ap_return[31:0] (Read)
-- 0x018 : Data signal of src
--         bit 31~0 - src[31:0] (Read/Write)
-- 0x01c : Data signal of src
--         bit 31~0 - src[63:32] (Read/Write)
-- 0x020 : reserved
-- 0x024 : Data signal of tensor
--         bit 31~0 - tensor[31:0] (Read/Write)
-- 0x028 : Data signal of tensor
--         bit 31~0 - tensor[63:32] (Read/Write)
-- 0x02c : reserved
-- 0x030 : Data signal of preview
--         bit 31~0 - preview[31:0] (Read/Write)
-- 0x034 : Data signal of preview
--         bit 31~0 - preview[63:32] (Read/Write)
-- 0x038 : reserved
-- 0x03c : Data signal of luts
--         bit 31~0 - luts[31:0] (Read/Write)
-- 0x040 : Data signal of luts
--         bit 31~0 - luts[63:32] (Read/Write)
-- 0x044 : reserved
-- 0x048 : Data signal of width
--         bit 31~0 - width[31:0] (Read/Write)
-- 0x04c : reserved
-- 0x050 : Data signal of height
--         bit 31~0 - height[31:0] (Read/Write)
-- 0x054 : reserved
-- 0x058 : Data signal of src_stride
--         bit 31~0 - src_stride[31:0] (Read/Write)
-- 0x05c : reserved
-- 0x060 : Data signal of src_capacity
--         bit 31~0 - src_capacity[31:0] (Read/Write)
-- 0x064 : reserved
-- 0x068 : Data signal of tensor_capacity
--         bit 31~0 - tensor_capacity[31:0] (Read/Write)
-- 0x06c : reserved
-- 0x070 : Data signal of preview_stride
--         bit 31~0 - preview_stride[31:0] (Read/Write)
-- 0x074 : reserved
-- 0x078 : Data signal of preview_capacity
--         bit 31~0 - preview_capacity[31:0] (Read/Write)
-- 0x07c : reserved
-- 0x080 : Data signal of resized_w
--         bit 31~0 - resized_w[31:0] (Read/Write)
-- 0x084 : reserved
-- 0x088 : Data signal of resized_h
--         bit 31~0 - resized_h[31:0] (Read/Write)
-- 0x08c : reserved
-- 0x090 : Data signal of pad_x
--         bit 31~0 - pad_x[31:0] (Read/Write)
-- 0x094 : reserved
-- 0x098 : Data signal of pad_y
--         bit 31~0 - pad_y[31:0] (Read/Write)
-- 0x09c : reserved
-- 0x0a0 : Data signal of output_mode
--         bit 31~0 - output_mode[31:0] (Read/Write)
-- 0x0a4 : reserved
-- 0x0a8 : Data signal of flags
--         bit 31~0 - flags[31:0] (Read/Write)
-- 0x0ac : reserved
-- 0x0b0 : Data signal of eq_mode
--         bit 31~0 - eq_mode[31:0] (Read/Write)
-- 0x0b4 : reserved
-- 0x0b8 : Data signal of saturation_q12
--         bit 31~0 - saturation_q12[31:0] (Read/Write)
-- 0x0bc : reserved
-- 0x0c0 : Data signal of frame_id
--         bit 31~0 - frame_id[31:0] (Read/Write)
-- 0x0c4 : reserved
-- 0x0c8 : Data signal of config_id
--         bit 31~0 - config_id[31:0] (Read/Write)
-- 0x0cc : reserved
-- 0x0d0 : Data signal of completed_frame_id
--         bit 31~0 - completed_frame_id[31:0] (Read)
-- 0x0d4 : Control signal of completed_frame_id
--         bit 0  - completed_frame_id_ap_vld (Read/COR)
--         others - reserved
-- 0x0e0 : Data signal of completed_config_id
--         bit 31~0 - completed_config_id[31:0] (Read)
-- 0x0e4 : Control signal of completed_config_id
--         bit 0  - completed_config_id_ap_vld (Read/COR)
--         others - reserved
-- 0x0f0 : Data signal of tensor_bytes
--         bit 31~0 - tensor_bytes[31:0] (Read)
-- 0x0f4 : Control signal of tensor_bytes
--         bit 0  - tensor_bytes_ap_vld (Read/COR)
--         others - reserved
-- 0x100 : Data signal of preview_bytes
--         bit 31~0 - preview_bytes[31:0] (Read)
-- 0x104 : Control signal of preview_bytes
--         bit 0  - preview_bytes_ap_vld (Read/COR)
--         others - reserved
-- 0x110 : Data signal of abi_version
--         bit 31~0 - abi_version[31:0] (Read)
-- 0x114 : Control signal of abi_version
--         bit 0  - abi_version_ap_vld (Read/COR)
--         others - reserved
-- (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

architecture behave of image_preprocess_control_s_axi is
    type states is (wridle, wrdata, wrresp, wrreset, rdidle, rddata, rdreset);  -- read and write fsm states
    signal wstate  : states := wrreset;
    signal rstate  : states := rdreset;
    signal wnext, rnext: states;
    constant ADDR_AP_CTRL                    : INTEGER := 16#000#;
    constant ADDR_GIE                        : INTEGER := 16#004#;
    constant ADDR_IER                        : INTEGER := 16#008#;
    constant ADDR_ISR                        : INTEGER := 16#00c#;
    constant ADDR_AP_RETURN_0                : INTEGER := 16#010#;
    constant ADDR_SRC_DATA_0                 : INTEGER := 16#018#;
    constant ADDR_SRC_DATA_1                 : INTEGER := 16#01c#;
    constant ADDR_SRC_CTRL                   : INTEGER := 16#020#;
    constant ADDR_TENSOR_DATA_0              : INTEGER := 16#024#;
    constant ADDR_TENSOR_DATA_1              : INTEGER := 16#028#;
    constant ADDR_TENSOR_CTRL                : INTEGER := 16#02c#;
    constant ADDR_PREVIEW_DATA_0             : INTEGER := 16#030#;
    constant ADDR_PREVIEW_DATA_1             : INTEGER := 16#034#;
    constant ADDR_PREVIEW_CTRL               : INTEGER := 16#038#;
    constant ADDR_LUTS_DATA_0                : INTEGER := 16#03c#;
    constant ADDR_LUTS_DATA_1                : INTEGER := 16#040#;
    constant ADDR_LUTS_CTRL                  : INTEGER := 16#044#;
    constant ADDR_WIDTH_DATA_0               : INTEGER := 16#048#;
    constant ADDR_WIDTH_CTRL                 : INTEGER := 16#04c#;
    constant ADDR_HEIGHT_DATA_0              : INTEGER := 16#050#;
    constant ADDR_HEIGHT_CTRL                : INTEGER := 16#054#;
    constant ADDR_SRC_STRIDE_DATA_0          : INTEGER := 16#058#;
    constant ADDR_SRC_STRIDE_CTRL            : INTEGER := 16#05c#;
    constant ADDR_SRC_CAPACITY_DATA_0        : INTEGER := 16#060#;
    constant ADDR_SRC_CAPACITY_CTRL          : INTEGER := 16#064#;
    constant ADDR_TENSOR_CAPACITY_DATA_0     : INTEGER := 16#068#;
    constant ADDR_TENSOR_CAPACITY_CTRL       : INTEGER := 16#06c#;
    constant ADDR_PREVIEW_STRIDE_DATA_0      : INTEGER := 16#070#;
    constant ADDR_PREVIEW_STRIDE_CTRL        : INTEGER := 16#074#;
    constant ADDR_PREVIEW_CAPACITY_DATA_0    : INTEGER := 16#078#;
    constant ADDR_PREVIEW_CAPACITY_CTRL      : INTEGER := 16#07c#;
    constant ADDR_RESIZED_W_DATA_0           : INTEGER := 16#080#;
    constant ADDR_RESIZED_W_CTRL             : INTEGER := 16#084#;
    constant ADDR_RESIZED_H_DATA_0           : INTEGER := 16#088#;
    constant ADDR_RESIZED_H_CTRL             : INTEGER := 16#08c#;
    constant ADDR_PAD_X_DATA_0               : INTEGER := 16#090#;
    constant ADDR_PAD_X_CTRL                 : INTEGER := 16#094#;
    constant ADDR_PAD_Y_DATA_0               : INTEGER := 16#098#;
    constant ADDR_PAD_Y_CTRL                 : INTEGER := 16#09c#;
    constant ADDR_OUTPUT_MODE_DATA_0         : INTEGER := 16#0a0#;
    constant ADDR_OUTPUT_MODE_CTRL           : INTEGER := 16#0a4#;
    constant ADDR_FLAGS_DATA_0               : INTEGER := 16#0a8#;
    constant ADDR_FLAGS_CTRL                 : INTEGER := 16#0ac#;
    constant ADDR_EQ_MODE_DATA_0             : INTEGER := 16#0b0#;
    constant ADDR_EQ_MODE_CTRL               : INTEGER := 16#0b4#;
    constant ADDR_SATURATION_Q12_DATA_0      : INTEGER := 16#0b8#;
    constant ADDR_SATURATION_Q12_CTRL        : INTEGER := 16#0bc#;
    constant ADDR_FRAME_ID_DATA_0            : INTEGER := 16#0c0#;
    constant ADDR_FRAME_ID_CTRL              : INTEGER := 16#0c4#;
    constant ADDR_CONFIG_ID_DATA_0           : INTEGER := 16#0c8#;
    constant ADDR_CONFIG_ID_CTRL             : INTEGER := 16#0cc#;
    constant ADDR_COMPLETED_FRAME_ID_DATA_0  : INTEGER := 16#0d0#;
    constant ADDR_COMPLETED_FRAME_ID_CTRL    : INTEGER := 16#0d4#;
    constant ADDR_COMPLETED_CONFIG_ID_DATA_0 : INTEGER := 16#0e0#;
    constant ADDR_COMPLETED_CONFIG_ID_CTRL   : INTEGER := 16#0e4#;
    constant ADDR_TENSOR_BYTES_DATA_0        : INTEGER := 16#0f0#;
    constant ADDR_TENSOR_BYTES_CTRL          : INTEGER := 16#0f4#;
    constant ADDR_PREVIEW_BYTES_DATA_0       : INTEGER := 16#100#;
    constant ADDR_PREVIEW_BYTES_CTRL         : INTEGER := 16#104#;
    constant ADDR_ABI_VERSION_DATA_0         : INTEGER := 16#110#;
    constant ADDR_ABI_VERSION_CTRL           : INTEGER := 16#114#;
    constant ADDR_BITS         : INTEGER := 9;

    signal waddr               : UNSIGNED(ADDR_BITS-1 downto 0);
    signal wmask               : UNSIGNED(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal aw_hs               : STD_LOGIC;
    signal w_hs                : STD_LOGIC;
    signal rdata_data          : UNSIGNED(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal ar_hs               : STD_LOGIC;
    signal raddr               : UNSIGNED(ADDR_BITS-1 downto 0);
    signal AWREADY_t           : STD_LOGIC;
    signal WREADY_t            : STD_LOGIC;
    signal ARREADY_t           : STD_LOGIC;
    signal RVALID_t            : STD_LOGIC;
    -- internal registers
    signal int_ap_idle         : STD_LOGIC := '0';
    signal int_ap_ready        : STD_LOGIC := '0';
    signal task_ap_ready       : STD_LOGIC;
    signal int_ap_done         : STD_LOGIC := '0';
    signal task_ap_done        : STD_LOGIC;
    signal int_task_ap_done    : STD_LOGIC := '0';
    signal int_ap_start        : STD_LOGIC := '0';
    signal int_interrupt       : STD_LOGIC := '0';
    signal int_auto_restart    : STD_LOGIC := '0';
    signal auto_restart_status : STD_LOGIC := '0';
    signal auto_restart_done   : STD_LOGIC;
    signal int_gie             : STD_LOGIC := '0';
    signal int_ier             : UNSIGNED(1 downto 0) := (others => '0');
    signal int_isr             : UNSIGNED(1 downto 0) := (others => '0');
    signal int_ap_return       : UNSIGNED(31 downto 0);
    signal int_src             : UNSIGNED(63 downto 0) := (others => '0');
    signal int_tensor          : UNSIGNED(63 downto 0) := (others => '0');
    signal int_preview         : UNSIGNED(63 downto 0) := (others => '0');
    signal int_luts            : UNSIGNED(63 downto 0) := (others => '0');
    signal int_width           : UNSIGNED(31 downto 0) := (others => '0');
    signal int_height          : UNSIGNED(31 downto 0) := (others => '0');
    signal int_src_stride      : UNSIGNED(31 downto 0) := (others => '0');
    signal int_src_capacity    : UNSIGNED(31 downto 0) := (others => '0');
    signal int_tensor_capacity : UNSIGNED(31 downto 0) := (others => '0');
    signal int_preview_stride  : UNSIGNED(31 downto 0) := (others => '0');
    signal int_preview_capacity : UNSIGNED(31 downto 0) := (others => '0');
    signal int_resized_w       : UNSIGNED(31 downto 0) := (others => '0');
    signal int_resized_h       : UNSIGNED(31 downto 0) := (others => '0');
    signal int_pad_x           : UNSIGNED(31 downto 0) := (others => '0');
    signal int_pad_y           : UNSIGNED(31 downto 0) := (others => '0');
    signal int_output_mode     : UNSIGNED(31 downto 0) := (others => '0');
    signal int_flags           : UNSIGNED(31 downto 0) := (others => '0');
    signal int_eq_mode         : UNSIGNED(31 downto 0) := (others => '0');
    signal int_saturation_q12  : UNSIGNED(31 downto 0) := (others => '0');
    signal int_frame_id        : UNSIGNED(31 downto 0) := (others => '0');
    signal int_config_id       : UNSIGNED(31 downto 0) := (others => '0');
    signal int_completed_frame_id_ap_vld : STD_LOGIC;
    signal int_completed_frame_id : UNSIGNED(31 downto 0) := (others => '0');
    signal int_completed_config_id_ap_vld : STD_LOGIC;
    signal int_completed_config_id : UNSIGNED(31 downto 0) := (others => '0');
    signal int_tensor_bytes_ap_vld : STD_LOGIC;
    signal int_tensor_bytes    : UNSIGNED(31 downto 0) := (others => '0');
    signal int_preview_bytes_ap_vld : STD_LOGIC;
    signal int_preview_bytes   : UNSIGNED(31 downto 0) := (others => '0');
    signal int_abi_version_ap_vld : STD_LOGIC;
    signal int_abi_version     : UNSIGNED(31 downto 0) := (others => '0');


begin
-- ----------------------- Instantiation------------------


-- ----------------------- AXI WRITE ---------------------
    AWREADY_t <=  '1' when wstate = wridle else '0';
    AWREADY   <=  AWREADY_t;
    WREADY_t  <=  '1' when wstate = wrdata else '0';
    WREADY    <=  WREADY_t;
    BRESP     <=  "00";  -- OKAY
    BVALID    <=  '1' when wstate = wrresp else '0';
    wmask     <=  (31 downto 24 => WSTRB(3), 23 downto 16 => WSTRB(2), 15 downto 8 => WSTRB(1), 7 downto 0 => WSTRB(0));
    aw_hs     <=  AWVALID and AWREADY_t;
    w_hs      <=  WVALID and WREADY_t;

    -- write FSM
    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                wstate <= wrreset;
            elsif (ACLK_EN = '1') then
                wstate <= wnext;
            end if;
        end if;
    end process;

    process (wstate, AWVALID, WVALID, BREADY)
    begin
        case (wstate) is
        when wridle =>
            if (AWVALID = '1') then
                wnext <= wrdata;
            else
                wnext <= wridle;
            end if;
        when wrdata =>
            if (WVALID = '1') then
                wnext <= wrresp;
            else
                wnext <= wrdata;
            end if;
        when wrresp =>
            if (BREADY = '1') then
                wnext <= wridle;
            else
                wnext <= wrresp;
            end if;
        when others =>
            wnext <= wridle;
        end case;
    end process;

    waddr_proc : process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (aw_hs = '1') then
                    waddr <= UNSIGNED(AWADDR(ADDR_BITS-1 downto 0));
                end if;
            end if;
        end if;
    end process;

-- ----------------------- AXI READ ----------------------
    ARREADY_t <= '1' when (rstate = rdidle) else '0';
    ARREADY <= ARREADY_t;
    RDATA   <= STD_LOGIC_VECTOR(rdata_data);
    RRESP   <= "00";  -- OKAY
    RVALID_t  <= '1' when (rstate = rddata) else '0';
    RVALID    <= RVALID_t;
    ar_hs   <= ARVALID and ARREADY_t;
    raddr   <= UNSIGNED(ARADDR(ADDR_BITS-1 downto 0));

    -- read FSM
    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                rstate <= rdreset;
            elsif (ACLK_EN = '1') then
                rstate <= rnext;
            end if;
        end if;
    end process;

    process (rstate, ARVALID, RREADY, RVALID_t)
    begin
        case (rstate) is
        when rdidle =>
            if (ARVALID = '1') then
                rnext <= rddata;
            else
                rnext <= rdidle;
            end if;
        when rddata =>
            if (RREADY = '1' and RVALID_t = '1') then
                rnext <= rdidle;
            else
                rnext <= rddata;
            end if;
        when others =>
            rnext <= rdidle;
        end case;
    end process;

    rdata_proc : process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (ar_hs = '1') then
                    rdata_data <= (others => '0');
                    case (TO_INTEGER(raddr)) is
                    when ADDR_AP_CTRL =>
                        rdata_data(9) <= int_interrupt;
                        rdata_data(7) <= int_auto_restart;
                        rdata_data(3) <= int_ap_ready;
                        rdata_data(2) <= int_ap_idle;
                        rdata_data(1) <= int_task_ap_done;
                        rdata_data(0) <= int_ap_start;
                    when ADDR_GIE =>
                        rdata_data(0) <= int_gie;
                    when ADDR_IER =>
                        rdata_data(1 downto 0) <= int_ier;
                    when ADDR_ISR =>
                        rdata_data(1 downto 0) <= int_isr;
                    when ADDR_AP_RETURN_0 =>
                        rdata_data <= RESIZE(int_ap_return(31 downto 0), 32);
                    when ADDR_SRC_DATA_0 =>
                        rdata_data <= RESIZE(int_src(31 downto 0), 32);
                    when ADDR_SRC_DATA_1 =>
                        rdata_data <= RESIZE(int_src(63 downto 32), 32);
                    when ADDR_TENSOR_DATA_0 =>
                        rdata_data <= RESIZE(int_tensor(31 downto 0), 32);
                    when ADDR_TENSOR_DATA_1 =>
                        rdata_data <= RESIZE(int_tensor(63 downto 32), 32);
                    when ADDR_PREVIEW_DATA_0 =>
                        rdata_data <= RESIZE(int_preview(31 downto 0), 32);
                    when ADDR_PREVIEW_DATA_1 =>
                        rdata_data <= RESIZE(int_preview(63 downto 32), 32);
                    when ADDR_LUTS_DATA_0 =>
                        rdata_data <= RESIZE(int_luts(31 downto 0), 32);
                    when ADDR_LUTS_DATA_1 =>
                        rdata_data <= RESIZE(int_luts(63 downto 32), 32);
                    when ADDR_WIDTH_DATA_0 =>
                        rdata_data <= RESIZE(int_width(31 downto 0), 32);
                    when ADDR_HEIGHT_DATA_0 =>
                        rdata_data <= RESIZE(int_height(31 downto 0), 32);
                    when ADDR_SRC_STRIDE_DATA_0 =>
                        rdata_data <= RESIZE(int_src_stride(31 downto 0), 32);
                    when ADDR_SRC_CAPACITY_DATA_0 =>
                        rdata_data <= RESIZE(int_src_capacity(31 downto 0), 32);
                    when ADDR_TENSOR_CAPACITY_DATA_0 =>
                        rdata_data <= RESIZE(int_tensor_capacity(31 downto 0), 32);
                    when ADDR_PREVIEW_STRIDE_DATA_0 =>
                        rdata_data <= RESIZE(int_preview_stride(31 downto 0), 32);
                    when ADDR_PREVIEW_CAPACITY_DATA_0 =>
                        rdata_data <= RESIZE(int_preview_capacity(31 downto 0), 32);
                    when ADDR_RESIZED_W_DATA_0 =>
                        rdata_data <= RESIZE(int_resized_w(31 downto 0), 32);
                    when ADDR_RESIZED_H_DATA_0 =>
                        rdata_data <= RESIZE(int_resized_h(31 downto 0), 32);
                    when ADDR_PAD_X_DATA_0 =>
                        rdata_data <= RESIZE(int_pad_x(31 downto 0), 32);
                    when ADDR_PAD_Y_DATA_0 =>
                        rdata_data <= RESIZE(int_pad_y(31 downto 0), 32);
                    when ADDR_OUTPUT_MODE_DATA_0 =>
                        rdata_data <= RESIZE(int_output_mode(31 downto 0), 32);
                    when ADDR_FLAGS_DATA_0 =>
                        rdata_data <= RESIZE(int_flags(31 downto 0), 32);
                    when ADDR_EQ_MODE_DATA_0 =>
                        rdata_data <= RESIZE(int_eq_mode(31 downto 0), 32);
                    when ADDR_SATURATION_Q12_DATA_0 =>
                        rdata_data <= RESIZE(int_saturation_q12(31 downto 0), 32);
                    when ADDR_FRAME_ID_DATA_0 =>
                        rdata_data <= RESIZE(int_frame_id(31 downto 0), 32);
                    when ADDR_CONFIG_ID_DATA_0 =>
                        rdata_data <= RESIZE(int_config_id(31 downto 0), 32);
                    when ADDR_COMPLETED_FRAME_ID_DATA_0 =>
                        rdata_data <= RESIZE(int_completed_frame_id(31 downto 0), 32);
                    when ADDR_COMPLETED_FRAME_ID_CTRL =>
                        rdata_data(0) <= int_completed_frame_id_ap_vld;
                    when ADDR_COMPLETED_CONFIG_ID_DATA_0 =>
                        rdata_data <= RESIZE(int_completed_config_id(31 downto 0), 32);
                    when ADDR_COMPLETED_CONFIG_ID_CTRL =>
                        rdata_data(0) <= int_completed_config_id_ap_vld;
                    when ADDR_TENSOR_BYTES_DATA_0 =>
                        rdata_data <= RESIZE(int_tensor_bytes(31 downto 0), 32);
                    when ADDR_TENSOR_BYTES_CTRL =>
                        rdata_data(0) <= int_tensor_bytes_ap_vld;
                    when ADDR_PREVIEW_BYTES_DATA_0 =>
                        rdata_data <= RESIZE(int_preview_bytes(31 downto 0), 32);
                    when ADDR_PREVIEW_BYTES_CTRL =>
                        rdata_data(0) <= int_preview_bytes_ap_vld;
                    when ADDR_ABI_VERSION_DATA_0 =>
                        rdata_data <= RESIZE(int_abi_version(31 downto 0), 32);
                    when ADDR_ABI_VERSION_CTRL =>
                        rdata_data(0) <= int_abi_version_ap_vld;
                    when others =>
                        NULL;
                    end case;
                end if;
            end if;
        end if;
    end process;

-- ----------------------- Register logic ----------------
    interrupt            <= int_interrupt;
    ap_start             <= int_ap_start;
    task_ap_done         <= (ap_done and not auto_restart_status) or auto_restart_done;
    task_ap_ready        <= ap_ready and not int_auto_restart;
    auto_restart_done    <= auto_restart_status and (ap_idle and not int_ap_idle);
    src                  <= STD_LOGIC_VECTOR(int_src);
    tensor               <= STD_LOGIC_VECTOR(int_tensor);
    preview              <= STD_LOGIC_VECTOR(int_preview);
    luts                 <= STD_LOGIC_VECTOR(int_luts);
    width                <= STD_LOGIC_VECTOR(int_width);
    height               <= STD_LOGIC_VECTOR(int_height);
    src_stride           <= STD_LOGIC_VECTOR(int_src_stride);
    src_capacity         <= STD_LOGIC_VECTOR(int_src_capacity);
    tensor_capacity      <= STD_LOGIC_VECTOR(int_tensor_capacity);
    preview_stride       <= STD_LOGIC_VECTOR(int_preview_stride);
    preview_capacity     <= STD_LOGIC_VECTOR(int_preview_capacity);
    resized_w            <= STD_LOGIC_VECTOR(int_resized_w);
    resized_h            <= STD_LOGIC_VECTOR(int_resized_h);
    pad_x                <= STD_LOGIC_VECTOR(int_pad_x);
    pad_y                <= STD_LOGIC_VECTOR(int_pad_y);
    output_mode          <= STD_LOGIC_VECTOR(int_output_mode);
    flags                <= STD_LOGIC_VECTOR(int_flags);
    eq_mode              <= STD_LOGIC_VECTOR(int_eq_mode);
    saturation_q12       <= STD_LOGIC_VECTOR(int_saturation_q12);
    frame_id             <= STD_LOGIC_VECTOR(int_frame_id);
    config_id            <= STD_LOGIC_VECTOR(int_config_id);

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_interrupt <= '0';
            elsif (ACLK_EN = '1') then
                if (int_gie = '1' and (int_isr(0) or int_isr(1)) = '1') then
                    int_interrupt <= '1';
                else
                    int_interrupt <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_ap_start <= '0';
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_AP_CTRL and WSTRB(0) = '1' and WDATA(0) = '1') then
                    int_ap_start <= '1';
                elsif (ap_ready = '1') then
                    int_ap_start <= int_auto_restart; -- clear on handshake/auto restart
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_ap_done <= '0';
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_ap_done <= ap_done;
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_task_ap_done <= '0';
            elsif (ACLK_EN = '1') then
                if (task_ap_done = '1') then
                    int_task_ap_done <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_AP_CTRL) then
                    int_task_ap_done <= '0'; -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_ap_idle <= '0';
            elsif (ACLK_EN = '1') then
                if (true) then
                    int_ap_idle <= ap_idle;
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_ap_ready <= '0';
            elsif (ACLK_EN = '1') then
                if (task_ap_ready = '1') then
                    int_ap_ready <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_AP_CTRL) then
                    int_ap_ready <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_auto_restart <= '0';
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_AP_CTRL and WSTRB(0) = '1') then
                    int_auto_restart <= WDATA(7);
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                auto_restart_status <= '0';
            elsif (ACLK_EN = '1') then
                if (int_auto_restart = '1') then
                    auto_restart_status <= '1';
                elsif (ap_idle = '1') then
                    auto_restart_status <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_gie <= '0';
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_GIE and WSTRB(0) = '1') then
                    int_gie <= WDATA(0);
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_ier <= (others=>'0');
            elsif (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_IER and WSTRB(0) = '1') then
                    int_ier <= UNSIGNED(WDATA(1 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_isr(0) <= '0';
            elsif (ACLK_EN = '1') then
                if (int_ier(0) = '1' and ap_done = '1') then
                    int_isr(0) <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_ISR) then
                    int_isr(0) <= '0'; -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_isr(1) <= '0';
            elsif (ACLK_EN = '1') then
                if (int_ier(1) = '1' and ap_ready = '1') then
                    int_isr(1) <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_ISR) then
                    int_isr(1) <= '0'; -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_ap_return <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (ap_done = '1') then
                    int_ap_return <= UNSIGNED(ap_return);
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_SRC_DATA_0) then
                    int_src(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_src(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_SRC_DATA_1) then
                    int_src(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_src(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_TENSOR_DATA_0) then
                    int_tensor(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_tensor(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_TENSOR_DATA_1) then
                    int_tensor(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_tensor(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_PREVIEW_DATA_0) then
                    int_preview(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_preview(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_PREVIEW_DATA_1) then
                    int_preview(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_preview(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_LUTS_DATA_0) then
                    int_luts(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_luts(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_LUTS_DATA_1) then
                    int_luts(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_luts(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_WIDTH_DATA_0) then
                    int_width(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_width(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_HEIGHT_DATA_0) then
                    int_height(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_height(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_SRC_STRIDE_DATA_0) then
                    int_src_stride(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_src_stride(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_SRC_CAPACITY_DATA_0) then
                    int_src_capacity(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_src_capacity(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_TENSOR_CAPACITY_DATA_0) then
                    int_tensor_capacity(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_tensor_capacity(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_PREVIEW_STRIDE_DATA_0) then
                    int_preview_stride(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_preview_stride(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_PREVIEW_CAPACITY_DATA_0) then
                    int_preview_capacity(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_preview_capacity(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_RESIZED_W_DATA_0) then
                    int_resized_w(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_resized_w(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_RESIZED_H_DATA_0) then
                    int_resized_h(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_resized_h(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_PAD_X_DATA_0) then
                    int_pad_x(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_pad_x(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_PAD_Y_DATA_0) then
                    int_pad_y(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_pad_y(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_OUTPUT_MODE_DATA_0) then
                    int_output_mode(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_output_mode(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_FLAGS_DATA_0) then
                    int_flags(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_flags(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_EQ_MODE_DATA_0) then
                    int_eq_mode(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_eq_mode(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_SATURATION_Q12_DATA_0) then
                    int_saturation_q12(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_saturation_q12(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_FRAME_ID_DATA_0) then
                    int_frame_id(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_frame_id(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_CONFIG_ID_DATA_0) then
                    int_config_id(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_config_id(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_completed_frame_id <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (completed_frame_id_ap_vld = '1') then
                    int_completed_frame_id <= UNSIGNED(completed_frame_id);
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_completed_frame_id_ap_vld <= '0';
            elsif (ACLK_EN = '1') then
                if (completed_frame_id_ap_vld = '1') then
                    int_completed_frame_id_ap_vld <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_COMPLETED_FRAME_ID_CTRL) then
                    int_completed_frame_id_ap_vld <= '0'; -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_completed_config_id <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (completed_config_id_ap_vld = '1') then
                    int_completed_config_id <= UNSIGNED(completed_config_id);
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_completed_config_id_ap_vld <= '0';
            elsif (ACLK_EN = '1') then
                if (completed_config_id_ap_vld = '1') then
                    int_completed_config_id_ap_vld <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_COMPLETED_CONFIG_ID_CTRL) then
                    int_completed_config_id_ap_vld <= '0'; -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_tensor_bytes <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (tensor_bytes_ap_vld = '1') then
                    int_tensor_bytes <= UNSIGNED(tensor_bytes);
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_tensor_bytes_ap_vld <= '0';
            elsif (ACLK_EN = '1') then
                if (tensor_bytes_ap_vld = '1') then
                    int_tensor_bytes_ap_vld <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_TENSOR_BYTES_CTRL) then
                    int_tensor_bytes_ap_vld <= '0'; -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_preview_bytes <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (preview_bytes_ap_vld = '1') then
                    int_preview_bytes <= UNSIGNED(preview_bytes);
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_preview_bytes_ap_vld <= '0';
            elsif (ACLK_EN = '1') then
                if (preview_bytes_ap_vld = '1') then
                    int_preview_bytes_ap_vld <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_PREVIEW_BYTES_CTRL) then
                    int_preview_bytes_ap_vld <= '0'; -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_abi_version <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (abi_version_ap_vld = '1') then
                    int_abi_version <= UNSIGNED(abi_version);
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_abi_version_ap_vld <= '0';
            elsif (ACLK_EN = '1') then
                if (abi_version_ap_vld = '1') then
                    int_abi_version_ap_vld <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_ABI_VERSION_CTRL) then
                    int_abi_version_ap_vld <= '0'; -- clear on read
                end if;
            end if;
        end if;
    end process;


-- ----------------------- Memory logic ------------------

end architecture behave;
