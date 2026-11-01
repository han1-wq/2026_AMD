#pragma once
#include <ap_int.h>

namespace ypost {
constexpr unsigned MAX_CANDIDATES = 256;
constexpr unsigned ANCHORS = 10647;
constexpr unsigned INPUT_WORDS = (ANCHORS * 85 + 15) / 16;
constexpr unsigned LUT_WORDS = 3 * 7 * 256;
enum Status { OK = 0, INVALID = 1, OVERFLOW = 2 };
// Packed input: grids 52,26,13; NHWC, 3 anchors x 85 signed bytes.
// LUT per scale: sigmoid Q15, then half-width/height Q8 for each anchor.
// Output: x1,y1,x2,y2 signed Q8, score Q30, class, anchor index, zero.
}

unsigned yolo_postprocess(const ap_uint<128>* input, const unsigned* tables,
                         ap_uint<256>* output, unsigned input_words,
                         unsigned table_words, unsigned output_capacity,
                         unsigned confidence_q30, unsigned nms_q16,
                         unsigned enable_nms, unsigned& candidate_count,
                         unsigned& detection_count);