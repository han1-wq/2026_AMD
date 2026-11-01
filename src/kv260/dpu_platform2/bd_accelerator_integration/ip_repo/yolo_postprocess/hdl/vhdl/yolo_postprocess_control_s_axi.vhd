-- ==============================================================
-- Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
-- Tool Version Limit: 2022.04
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity yolo_postprocess_control_s_axi is
generic (
    C_S_AXI_ADDR_WIDTH    : INTEGER := 8;
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
    input_r               :out  STD_LOGIC_VECTOR(63 downto 0);
    tables                :out  STD_LOGIC_VECTOR(63 downto 0);
    output_r              :out  STD_LOGIC_VECTOR(63 downto 0);
    input_words           :out  STD_LOGIC_VECTOR(31 downto 0);
    table_words           :out  STD_LOGIC_VECTOR(31 downto 0);
    output_capacity       :out  STD_LOGIC_VECTOR(31 downto 0);
    confidence_q30        :out  STD_LOGIC_VECTOR(31 downto 0);
    nms_q16               :out  STD_LOGIC_VECTOR(31 downto 0);
    enable_nms            :out  STD_LOGIC_VECTOR(31 downto 0);
    candidate_count       :in   STD_LOGIC_VECTOR(31 downto 0);
    candidate_count_ap_vld :in   STD_LOGIC;
    detection_count       :in   STD_LOGIC_VECTOR(31 downto 0);
    detection_count_ap_vld :in   STD_LOGIC
);
end entity yolo_postprocess_control_s_axi;

-- ------------------------Address Info-------------------
-- 0x00 : Control signals
--        bit 0  - ap_start (Read/Write/COH)
--        bit 1  - ap_done (Read/COR)
--        bit 2  - ap_idle (Read)
--        bit 3  - ap_ready (Read/COR)
--        bit 7  - auto_restart (Read/Write)
--        bit 9  - interrupt (Read)
--        others - reserved
-- 0x04 : Global Interrupt Enable Register
--        bit 0  - Global Interrupt Enable (Read/Write)
--        others - reserved
-- 0x08 : IP Interrupt Enable Register (Read/Write)
--        bit 0 - enable ap_done interrupt (Read/Write)
--        bit 1 - enable ap_ready interrupt (Read/Write)
--        others - reserved
-- 0x0c : IP Interrupt Status Register (Read/COR)
--        bit 0 - ap_done (Read/COR)
--        bit 1 - ap_ready (Read/COR)
--        others - reserved
-- 0x10 : Data signal of ap_return
--        bit 31~0 - ap_return[31:0] (Read)
-- 0x18 : Data signal of input_r
--        bit 31~0 - input_r[31:0] (Read/Write)
-- 0x1c : Data signal of input_r
--        bit 31~0 - input_r[63:32] (Read/Write)
-- 0x20 : reserved
-- 0x24 : Data signal of tables
--        bit 31~0 - tables[31:0] (Read/Write)
-- 0x28 : Data signal of tables
--        bit 31~0 - tables[63:32] (Read/Write)
-- 0x2c : reserved
-- 0x30 : Data signal of output_r
--        bit 31~0 - output_r[31:0] (Read/Write)
-- 0x34 : Data signal of output_r
--        bit 31~0 - output_r[63:32] (Read/Write)
-- 0x38 : reserved
-- 0x3c : Data signal of input_words
--        bit 31~0 - input_words[31:0] (Read/Write)
-- 0x40 : reserved
-- 0x44 : Data signal of table_words
--        bit 31~0 - table_words[31:0] (Read/Write)
-- 0x48 : reserved
-- 0x4c : Data signal of output_capacity
--        bit 31~0 - output_capacity[31:0] (Read/Write)
-- 0x50 : reserved
-- 0x54 : Data signal of confidence_q30
--        bit 31~0 - confidence_q30[31:0] (Read/Write)
-- 0x58 : reserved
-- 0x5c : Data signal of nms_q16
--        bit 31~0 - nms_q16[31:0] (Read/Write)
-- 0x60 : reserved
-- 0x64 : Data signal of enable_nms
--        bit 31~0 - enable_nms[31:0] (Read/Write)
-- 0x68 : reserved
-- 0x6c : Data signal of candidate_count
--        bit 31~0 - candidate_count[31:0] (Read)
-- 0x70 : Control signal of candidate_count
--        bit 0  - candidate_count_ap_vld (Read/COR)
--        others - reserved
-- 0x7c : Data signal of detection_count
--        bit 31~0 - detection_count[31:0] (Read)
-- 0x80 : Control signal of detection_count
--        bit 0  - detection_count_ap_vld (Read/COR)
--        others - reserved
-- (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

architecture behave of yolo_postprocess_control_s_axi is
    type states is (wridle, wrdata, wrresp, wrreset, rdidle, rddata, rdreset);  -- read and write fsm states
    signal wstate  : states := wrreset;
    signal rstate  : states := rdreset;
    signal wnext, rnext: states;
    constant ADDR_AP_CTRL                : INTEGER := 16#00#;
    constant ADDR_GIE                    : INTEGER := 16#04#;
    constant ADDR_IER                    : INTEGER := 16#08#;
    constant ADDR_ISR                    : INTEGER := 16#0c#;
    constant ADDR_AP_RETURN_0            : INTEGER := 16#10#;
    constant ADDR_INPUT_R_DATA_0         : INTEGER := 16#18#;
    constant ADDR_INPUT_R_DATA_1         : INTEGER := 16#1c#;
    constant ADDR_INPUT_R_CTRL           : INTEGER := 16#20#;
    constant ADDR_TABLES_DATA_0          : INTEGER := 16#24#;
    constant ADDR_TABLES_DATA_1          : INTEGER := 16#28#;
    constant ADDR_TABLES_CTRL            : INTEGER := 16#2c#;
    constant ADDR_OUTPUT_R_DATA_0        : INTEGER := 16#30#;
    constant ADDR_OUTPUT_R_DATA_1        : INTEGER := 16#34#;
    constant ADDR_OUTPUT_R_CTRL          : INTEGER := 16#38#;
    constant ADDR_INPUT_WORDS_DATA_0     : INTEGER := 16#3c#;
    constant ADDR_INPUT_WORDS_CTRL       : INTEGER := 16#40#;
    constant ADDR_TABLE_WORDS_DATA_0     : INTEGER := 16#44#;
    constant ADDR_TABLE_WORDS_CTRL       : INTEGER := 16#48#;
    constant ADDR_OUTPUT_CAPACITY_DATA_0 : INTEGER := 16#4c#;
    constant ADDR_OUTPUT_CAPACITY_CTRL   : INTEGER := 16#50#;
    constant ADDR_CONFIDENCE_Q30_DATA_0  : INTEGER := 16#54#;
    constant ADDR_CONFIDENCE_Q30_CTRL    : INTEGER := 16#58#;
    constant ADDR_NMS_Q16_DATA_0         : INTEGER := 16#5c#;
    constant ADDR_NMS_Q16_CTRL           : INTEGER := 16#60#;
    constant ADDR_ENABLE_NMS_DATA_0      : INTEGER := 16#64#;
    constant ADDR_ENABLE_NMS_CTRL        : INTEGER := 16#68#;
    constant ADDR_CANDIDATE_COUNT_DATA_0 : INTEGER := 16#6c#;
    constant ADDR_CANDIDATE_COUNT_CTRL   : INTEGER := 16#70#;
    constant ADDR_DETECTION_COUNT_DATA_0 : INTEGER := 16#7c#;
    constant ADDR_DETECTION_COUNT_CTRL   : INTEGER := 16#80#;
    constant ADDR_BITS         : INTEGER := 8;

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
    signal int_input_r         : UNSIGNED(63 downto 0) := (others => '0');
    signal int_tables          : UNSIGNED(63 downto 0) := (others => '0');
    signal int_output_r        : UNSIGNED(63 downto 0) := (others => '0');
    signal int_input_words     : UNSIGNED(31 downto 0) := (others => '0');
    signal int_table_words     : UNSIGNED(31 downto 0) := (others => '0');
    signal int_output_capacity : UNSIGNED(31 downto 0) := (others => '0');
    signal int_confidence_q30  : UNSIGNED(31 downto 0) := (others => '0');
    signal int_nms_q16         : UNSIGNED(31 downto 0) := (others => '0');
    signal int_enable_nms      : UNSIGNED(31 downto 0) := (others => '0');
    signal int_candidate_count_ap_vld : STD_LOGIC;
    signal int_candidate_count : UNSIGNED(31 downto 0) := (others => '0');
    signal int_detection_count_ap_vld : STD_LOGIC;
    signal int_detection_count : UNSIGNED(31 downto 0) := (others => '0');


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
                    when ADDR_INPUT_R_DATA_0 =>
                        rdata_data <= RESIZE(int_input_r(31 downto 0), 32);
                    when ADDR_INPUT_R_DATA_1 =>
                        rdata_data <= RESIZE(int_input_r(63 downto 32), 32);
                    when ADDR_TABLES_DATA_0 =>
                        rdata_data <= RESIZE(int_tables(31 downto 0), 32);
                    when ADDR_TABLES_DATA_1 =>
                        rdata_data <= RESIZE(int_tables(63 downto 32), 32);
                    when ADDR_OUTPUT_R_DATA_0 =>
                        rdata_data <= RESIZE(int_output_r(31 downto 0), 32);
                    when ADDR_OUTPUT_R_DATA_1 =>
                        rdata_data <= RESIZE(int_output_r(63 downto 32), 32);
                    when ADDR_INPUT_WORDS_DATA_0 =>
                        rdata_data <= RESIZE(int_input_words(31 downto 0), 32);
                    when ADDR_TABLE_WORDS_DATA_0 =>
                        rdata_data <= RESIZE(int_table_words(31 downto 0), 32);
                    when ADDR_OUTPUT_CAPACITY_DATA_0 =>
                        rdata_data <= RESIZE(int_output_capacity(31 downto 0), 32);
                    when ADDR_CONFIDENCE_Q30_DATA_0 =>
                        rdata_data <= RESIZE(int_confidence_q30(31 downto 0), 32);
                    when ADDR_NMS_Q16_DATA_0 =>
                        rdata_data <= RESIZE(int_nms_q16(31 downto 0), 32);
                    when ADDR_ENABLE_NMS_DATA_0 =>
                        rdata_data <= RESIZE(int_enable_nms(31 downto 0), 32);
                    when ADDR_CANDIDATE_COUNT_DATA_0 =>
                        rdata_data <= RESIZE(int_candidate_count(31 downto 0), 32);
                    when ADDR_CANDIDATE_COUNT_CTRL =>
                        rdata_data(0) <= int_candidate_count_ap_vld;
                    when ADDR_DETECTION_COUNT_DATA_0 =>
                        rdata_data <= RESIZE(int_detection_count(31 downto 0), 32);
                    when ADDR_DETECTION_COUNT_CTRL =>
                        rdata_data(0) <= int_detection_count_ap_vld;
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
    input_r              <= STD_LOGIC_VECTOR(int_input_r);
    tables               <= STD_LOGIC_VECTOR(int_tables);
    output_r             <= STD_LOGIC_VECTOR(int_output_r);
    input_words          <= STD_LOGIC_VECTOR(int_input_words);
    table_words          <= STD_LOGIC_VECTOR(int_table_words);
    output_capacity      <= STD_LOGIC_VECTOR(int_output_capacity);
    confidence_q30       <= STD_LOGIC_VECTOR(int_confidence_q30);
    nms_q16              <= STD_LOGIC_VECTOR(int_nms_q16);
    enable_nms           <= STD_LOGIC_VECTOR(int_enable_nms);

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
                if (w_hs = '1' and waddr = ADDR_INPUT_R_DATA_0) then
                    int_input_r(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_input_r(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INPUT_R_DATA_1) then
                    int_input_r(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_input_r(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_TABLES_DATA_0) then
                    int_tables(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_tables(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_TABLES_DATA_1) then
                    int_tables(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_tables(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_OUTPUT_R_DATA_0) then
                    int_output_r(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_output_r(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_OUTPUT_R_DATA_1) then
                    int_output_r(63 downto 32) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_output_r(63 downto 32));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_INPUT_WORDS_DATA_0) then
                    int_input_words(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_input_words(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_TABLE_WORDS_DATA_0) then
                    int_table_words(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_table_words(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_OUTPUT_CAPACITY_DATA_0) then
                    int_output_capacity(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_output_capacity(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_CONFIDENCE_Q30_DATA_0) then
                    int_confidence_q30(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_confidence_q30(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_NMS_Q16_DATA_0) then
                    int_nms_q16(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_nms_q16(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_ENABLE_NMS_DATA_0) then
                    int_enable_nms(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_enable_nms(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_candidate_count <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (candidate_count_ap_vld = '1') then
                    int_candidate_count <= UNSIGNED(candidate_count);
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_candidate_count_ap_vld <= '0';
            elsif (ACLK_EN = '1') then
                if (candidate_count_ap_vld = '1') then
                    int_candidate_count_ap_vld <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_CANDIDATE_COUNT_CTRL) then
                    int_candidate_count_ap_vld <= '0'; -- clear on read
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_detection_count <= (others => '0');
            elsif (ACLK_EN = '1') then
                if (detection_count_ap_vld = '1') then
                    int_detection_count <= UNSIGNED(detection_count);
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_detection_count_ap_vld <= '0';
            elsif (ACLK_EN = '1') then
                if (detection_count_ap_vld = '1') then
                    int_detection_count_ap_vld <= '1';
                elsif (ar_hs = '1' and raddr = ADDR_DETECTION_COUNT_CTRL) then
                    int_detection_count_ap_vld <= '0'; -- clear on read
                end if;
            end if;
        end if;
    end process;


-- ----------------------- Memory logic ------------------

end architecture behave;
