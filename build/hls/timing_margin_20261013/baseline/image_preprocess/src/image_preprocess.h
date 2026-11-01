#ifndef IMAGE_PREPROCESS_H
#define IMAGE_PREPROCESS_H

#include <ap_int.h>
#include <stdint.h>

namespace image_hls {
typedef ap_uint<128> Word;
typedef ap_uint<24> Pixel; // byte 0 B, byte 1 G, byte 2 R
static const unsigned MAX_WIDTH = 1920;
static const unsigned MAX_HEIGHT = 1080;
static const unsigned TARGET = 416;
static const unsigned TENSOR_BYTES = TARGET * TARGET * 3;
static const unsigned MAX_FRAME_WORDS = MAX_WIDTH * MAX_HEIGHT * 3 / 16;
static const unsigned ABI_VERSION = 0x00010000;
enum OutputMode { TENSOR_ONLY = 0, PREVIEW_ONLY = 1, TENSOR_AND_PREVIEW = 2 };
enum EqualizeMode { EQ_OFF = 0, EQ_CURRENT = 1, EQ_PREVIOUS = 2 };
enum Flags { COLOR_LUT = 1, SATURATION = 2, ENHANCE_TENSOR = 4, RESET_HISTORY = 8 };
enum Status { OK = 0, BAD_SIZE = 1, BAD_STRIDE = 2, BAD_CAPACITY = 3,
              BAD_MODE = 4, BAD_GEOMETRY = 5, BAD_SATURATION = 6 };
}

// All capacities/strides are bytes. Buffers must be distinct and 64-byte aligned.
// luts: 16 words of uint8 color LUT followed by 16 words of int8 quantization LUT.
// config_id must change when the color LUT or its interpretation changes.
// No register or memory argument may change until ap_done. Disable auto_restart.
extern "C" unsigned image_preprocess(
    const image_hls::Word *src, image_hls::Word *tensor,
    image_hls::Word *preview, const image_hls::Word *luts,
    unsigned width, unsigned height, unsigned src_stride,
    unsigned src_capacity, unsigned tensor_capacity, unsigned preview_stride,
    unsigned preview_capacity, unsigned resized_w, unsigned resized_h,
    unsigned pad_x, unsigned pad_y, unsigned output_mode, unsigned flags,
    unsigned eq_mode, unsigned saturation_q12, unsigned frame_id,
    unsigned config_id, unsigned &completed_frame_id,
    unsigned &completed_config_id, unsigned &tensor_bytes,
    unsigned &preview_bytes, unsigned &abi_version);

#endif