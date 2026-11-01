#include "yolo_postprocess.h"

namespace {
struct Box {
    int x1, y1, x2, y2;
    unsigned score, cls, id;
};

// Shared fabric multipliers preserve DSP headroom for the DPU.
ap_uint<64> area(unsigned w, unsigned h) {
#pragma HLS INLINE off
    ap_uint<64> value = ap_uint<32>(w) * ap_uint<32>(h);
#pragma HLS BIND_OP variable=value op=mul impl=fabric
    return value;
}

bool suppress(const Box& a, const Box& b, unsigned threshold) {
#pragma HLS INLINE off
    int left = a.x1 > b.x1 ? a.x1 : b.x1;
    int top = a.y1 > b.y1 ? a.y1 : b.y1;
    int right = a.x2 < b.x2 ? a.x2 : b.x2;
    int bottom = a.y2 < b.y2 ? a.y2 : b.y2;
    if (right <= left || bottom <= top) return false;
    ap_uint<64> intersection = area(unsigned(right-left), unsigned(bottom-top));
    ap_uint<65> total = ap_uint<65>(area(unsigned(a.x2-a.x1), unsigned(a.y2-a.y1)))
                      + area(unsigned(b.x2-b.x1), unsigned(b.y2-b.y1)) - intersection;
    ap_uint<82> scaled = total * ap_uint<17>(threshold);
#pragma HLS BIND_OP variable=scaled op=mul impl=fabric
    return (ap_uint<82>(intersection) << 16) > scaled;
}

ap_uint<256> pack(const Box& b) {
    ap_uint<256> result = 0;
    result.range(31,0) = unsigned(b.x1);
    result.range(63,32) = unsigned(b.y1);
    result.range(95,64) = unsigned(b.x2);
    result.range(127,96) = unsigned(b.y2);
    result.range(159,128) = b.score;
    result.range(191,160) = b.cls;
    result.range(223,192) = b.id;
    return result;
}
}

unsigned yolo_postprocess(const ap_uint<128>* input, const unsigned* tables,
                         ap_uint<256>* output, unsigned input_words,
                         unsigned table_words, unsigned output_capacity,
                         unsigned confidence_q30, unsigned nms_q16,
                         unsigned enable_nms, unsigned& candidate_count,
                         unsigned& detection_count) {
#pragma HLS INTERFACE m_axi port=input offset=slave bundle=gmem_in depth=56563 max_read_burst_length=32 num_read_outstanding=2
#pragma HLS INTERFACE m_axi port=tables offset=slave bundle=gmem_in depth=5376
#pragma HLS INTERFACE m_axi port=output offset=slave bundle=gmem_out depth=256 max_write_burst_length=16 num_write_outstanding=2
#pragma HLS INTERFACE s_axilite port=input bundle=control
#pragma HLS INTERFACE s_axilite port=tables bundle=control
#pragma HLS INTERFACE s_axilite port=output bundle=control
#pragma HLS INTERFACE s_axilite port=input_words bundle=control
#pragma HLS INTERFACE s_axilite port=table_words bundle=control
#pragma HLS INTERFACE s_axilite port=output_capacity bundle=control
#pragma HLS INTERFACE s_axilite port=confidence_q30 bundle=control
#pragma HLS INTERFACE s_axilite port=nms_q16 bundle=control
#pragma HLS INTERFACE s_axilite port=enable_nms bundle=control
#pragma HLS INTERFACE s_axilite port=candidate_count bundle=control
#pragma HLS INTERFACE s_axilite port=detection_count bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control
    candidate_count = detection_count = 0;
    if (input_words < ypost::INPUT_WORDS || table_words < ypost::LUT_WORDS ||
        output_capacity < ypost::MAX_CANDIDATES || confidence_q30 == 0 ||
        confidence_q30 > (1u<<30) || nms_q16 > 65536 || enable_nms > 1)
        return ypost::INVALID;
    Box boxes[ypost::MAX_CANDIDATES];
#pragma HLS BIND_STORAGE variable=boxes type=ram_2p impl=bram
    unsigned lut[7][256];
#pragma HLS BIND_STORAGE variable=lut type=ram_2p impl=bram
    ap_uint<128> word = 0;
    unsigned byte_index = 0, id = 0, count = 0;
    bool overflow = false;
    for (unsigned scale = 0; scale < 3; ++scale) {
        for (unsigned bank = 0; bank < 7; ++bank)
            for (unsigned v = 0; v < 256; ++v) {
#pragma HLS PIPELINE II=1
                lut[bank][v] = tables[scale*1792+bank*256+v];
            }
        unsigned grid = scale == 0 ? 52 : scale == 1 ? 26 : 13;
        unsigned stride = scale == 0 ? 8 : scale == 1 ? 16 : 32;
        for (unsigned y = 0; y < grid; ++y)
            for (unsigned x = 0; x < grid; ++x)
                for (unsigned anchor = 0; anchor < 3; ++anchor, ++id) {
                    unsigned coords[4];
#pragma HLS ARRAY_PARTITION variable=coords complete
                    unsigned obj = 0, cls = 0;
                    int best_logit = -129;
                    for (unsigned c = 0; c < 85; ++c, ++byte_index) {
#pragma HLS PIPELINE II=1
                        if ((byte_index & 15) == 0) word = input[byte_index >> 4];
                        unsigned v = word.range((byte_index%16)*8+7, (byte_index%16)*8);
                        if (c < 4) coords[c] = v;
                        else if (c == 4) obj = lut[0][v];
                        else {
                            int logit = v < 128 ? int(v) : int(v)-256;
                            if (logit > best_logit) { best_logit = logit; cls = c-5; }
                        }
                    }
                    unsigned score = obj * lut[0][unsigned(best_logit)&255];
                    if (score < confidence_q30) continue;
                    if (count == ypost::MAX_CANDIDATES) { overflow = true; continue; }
                    int cx = int(x*stride*256 + ((lut[0][coords[0]]*stride+64)>>7));
                    int cy = int(y*stride*256 + ((lut[0][coords[1]]*stride+64)>>7));
                    int hw = int(lut[1+2*anchor][coords[2]]);
                    int hh = int(lut[2+2*anchor][coords[3]]);
                    Box b = {cx-hw, cy-hh, cx+hw, cy+hh, score, cls, id};
                    boxes[count++] = b;
                }
    }
    candidate_count = count;
    if (overflow) return ypost::OVERFLOW; // No partial detections are valid.
    unsigned written = 0;
    if (!enable_nms) {
        for (unsigned i = 0; i < count; ++i) output[written++] = pack(boxes[i]);
    } else {
        for (unsigned iteration = 0; iteration < count; ++iteration) {
            unsigned best_score = 0, best_index = 0;
            for (unsigned i = 0; i < count; ++i) {
#pragma HLS PIPELINE II=1
                if (boxes[i].score > best_score) { best_score = boxes[i].score; best_index = i; }
            }
            if (!best_score) break;
            Box selected = boxes[best_index];
            output[written++] = pack(selected);
            boxes[best_index].score = 0;
            for (unsigned i = 0; i < count; ++i) {
                Box b = boxes[i];
                if (b.score && b.cls == selected.cls && suppress(selected, b, nms_q16))
                    boxes[i].score = 0;
            }
        }
    }
    detection_count = written;
    return ypost::OK;
}