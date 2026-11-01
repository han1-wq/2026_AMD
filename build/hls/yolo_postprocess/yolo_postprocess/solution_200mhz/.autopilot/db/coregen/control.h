// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read/COR)
//        bit 7  - auto_restart (Read/Write)
//        bit 9  - interrupt (Read)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0 - enable ap_done interrupt (Read/Write)
//        bit 1 - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/COR)
//        bit 0 - ap_done (Read/COR)
//        bit 1 - ap_ready (Read/COR)
//        others - reserved
// 0x10 : Data signal of ap_return
//        bit 31~0 - ap_return[31:0] (Read)
// 0x18 : Data signal of input_r
//        bit 31~0 - input_r[31:0] (Read/Write)
// 0x1c : Data signal of input_r
//        bit 31~0 - input_r[63:32] (Read/Write)
// 0x20 : reserved
// 0x24 : Data signal of tables
//        bit 31~0 - tables[31:0] (Read/Write)
// 0x28 : Data signal of tables
//        bit 31~0 - tables[63:32] (Read/Write)
// 0x2c : reserved
// 0x30 : Data signal of output_r
//        bit 31~0 - output_r[31:0] (Read/Write)
// 0x34 : Data signal of output_r
//        bit 31~0 - output_r[63:32] (Read/Write)
// 0x38 : reserved
// 0x3c : Data signal of input_words
//        bit 31~0 - input_words[31:0] (Read/Write)
// 0x40 : reserved
// 0x44 : Data signal of table_words
//        bit 31~0 - table_words[31:0] (Read/Write)
// 0x48 : reserved
// 0x4c : Data signal of output_capacity
//        bit 31~0 - output_capacity[31:0] (Read/Write)
// 0x50 : reserved
// 0x54 : Data signal of confidence_q30
//        bit 31~0 - confidence_q30[31:0] (Read/Write)
// 0x58 : reserved
// 0x5c : Data signal of nms_q16
//        bit 31~0 - nms_q16[31:0] (Read/Write)
// 0x60 : reserved
// 0x64 : Data signal of enable_nms
//        bit 31~0 - enable_nms[31:0] (Read/Write)
// 0x68 : reserved
// 0x6c : Data signal of candidate_count
//        bit 31~0 - candidate_count[31:0] (Read)
// 0x70 : Control signal of candidate_count
//        bit 0  - candidate_count_ap_vld (Read/COR)
//        others - reserved
// 0x7c : Data signal of detection_count
//        bit 31~0 - detection_count[31:0] (Read)
// 0x80 : Control signal of detection_count
//        bit 0  - detection_count_ap_vld (Read/COR)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define CONTROL_ADDR_AP_CTRL              0x00
#define CONTROL_ADDR_GIE                  0x04
#define CONTROL_ADDR_IER                  0x08
#define CONTROL_ADDR_ISR                  0x0c
#define CONTROL_ADDR_AP_RETURN            0x10
#define CONTROL_BITS_AP_RETURN            32
#define CONTROL_ADDR_INPUT_R_DATA         0x18
#define CONTROL_BITS_INPUT_R_DATA         64
#define CONTROL_ADDR_TABLES_DATA          0x24
#define CONTROL_BITS_TABLES_DATA          64
#define CONTROL_ADDR_OUTPUT_R_DATA        0x30
#define CONTROL_BITS_OUTPUT_R_DATA        64
#define CONTROL_ADDR_INPUT_WORDS_DATA     0x3c
#define CONTROL_BITS_INPUT_WORDS_DATA     32
#define CONTROL_ADDR_TABLE_WORDS_DATA     0x44
#define CONTROL_BITS_TABLE_WORDS_DATA     32
#define CONTROL_ADDR_OUTPUT_CAPACITY_DATA 0x4c
#define CONTROL_BITS_OUTPUT_CAPACITY_DATA 32
#define CONTROL_ADDR_CONFIDENCE_Q30_DATA  0x54
#define CONTROL_BITS_CONFIDENCE_Q30_DATA  32
#define CONTROL_ADDR_NMS_Q16_DATA         0x5c
#define CONTROL_BITS_NMS_Q16_DATA         32
#define CONTROL_ADDR_ENABLE_NMS_DATA      0x64
#define CONTROL_BITS_ENABLE_NMS_DATA      32
#define CONTROL_ADDR_CANDIDATE_COUNT_DATA 0x6c
#define CONTROL_BITS_CANDIDATE_COUNT_DATA 32
#define CONTROL_ADDR_CANDIDATE_COUNT_CTRL 0x70
#define CONTROL_ADDR_DETECTION_COUNT_DATA 0x7c
#define CONTROL_BITS_DETECTION_COUNT_DATA 32
#define CONTROL_ADDR_DETECTION_COUNT_CTRL 0x80
