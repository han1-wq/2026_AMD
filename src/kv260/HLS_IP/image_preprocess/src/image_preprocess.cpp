#include "image_preprocess.h"
#include <hls_stream.h>

using namespace image_hls;

namespace {
struct Pair { Pixel original; Pixel enhanced; };
struct Coordinate { ap_uint<11> index; ap_uint<12> weight; };

// Keep startup validation out of the top-level datapath register enables.
// This runs once per frame; extra validation cycles do not change pixel II.
static unsigned validate_settings(
    unsigned width, unsigned height, unsigned src_stride, unsigned src_capacity,
    unsigned tensor_capacity, unsigned preview_stride, unsigned preview_capacity,
    unsigned resized_w, unsigned resized_h, unsigned pad_x, unsigned pad_y,
    unsigned output_mode, unsigned flags, unsigned eq_mode, unsigned saturation_q12) {
#pragma HLS INLINE off
#pragma HLS PIPELINE II=1
    if (width < TARGET || height < TARGET || width > MAX_WIDTH || height > MAX_HEIGHT) return BAD_SIZE;
    if (output_mode > TENSOR_AND_PREVIEW || eq_mode > EQ_PREVIOUS || (flags & ~15u)) return BAD_MODE;
    if (src_stride % 16 || src_stride < width*3 || src_stride > MAX_WIDTH*3) return BAD_STRIDE;
    if (output_mode != TENSOR_ONLY && (preview_stride % 16 || preview_stride < width*3 || preview_stride > MAX_WIDTH*3)) return BAD_STRIDE;
    ap_uint<13> source_stride = src_stride, destination_stride = preview_stride;
    ap_uint<11> frame_height = height;
    ap_uint<24> source_required = source_stride*frame_height;
    ap_uint<24> preview_required = destination_stride*frame_height;
#pragma HLS BIND_OP variable=source_required op=mul impl=fabric latency=2
#pragma HLS BIND_OP variable=preview_required op=mul impl=fabric latency=2
    if (src_capacity < source_required ||
        (output_mode != PREVIEW_ONLY && tensor_capacity < TENSOR_BYTES) ||
        (output_mode != TENSOR_ONLY && preview_capacity < preview_required)) return BAD_CAPACITY;
    if (saturation_q12 > 8192) return BAD_SATURATION;
    if (!resized_w || !resized_h || resized_w > TARGET || resized_h > TARGET ||
        resized_w > width || resized_h > height || pad_x != (TARGET-resized_w)/2 ||
        pad_y != (TARGET-resized_h)/2) return BAD_GEOMETRY;
    return OK;
}

static unsigned word_address(unsigned row, unsigned stride_words, unsigned column) {
#pragma HLS INLINE
    ap_uint<11> y = row;
    ap_uint<9> stride = stride_words;
    ap_uint<20> base = y * stride;
#pragma HLS BIND_OP variable=base op=mul impl=fabric
    return unsigned(base) + column;
}

static unsigned pixel_count(unsigned width, unsigned height) {
#pragma HLS INLINE
    ap_uint<11> w = width, h = height;
    ap_uint<22> count = w*h;
#pragma HLS BIND_OP variable=count op=mul impl=fabric
    return count;
}

static int round_shift_even(int value, unsigned bits) {
#pragma HLS INLINE
    // Round the magnitude, then restore sign; no signed right-shift assumption.
    int magnitude = value < 0 ? -value : value;
    int q = magnitude >> bits;
    unsigned remainder = magnitude & ((1u << bits) - 1);
    unsigned half = 1u << (bits - 1);
    if (remainder > half || (remainder == half && (q & 1))) ++q;
    return value < 0 ? -q : q;
}

static ap_uint<8> clip(int x) {
#pragma HLS INLINE
    return x < 0 ? 0 : (x > 255 ? 255 : x);
}

static unsigned luma(Pixel p) {
#pragma HLS INLINE
    // Explicit shift/add constants prevent MAC fusion from consuming DSPs.
    unsigned b = p.range(7, 0), g = p.range(15, 8), r = p.range(23, 16);
    unsigned rb = (r << 6) + (r << 3) + (r << 2) + r;
    unsigned gb = (g << 7) + (g << 4) + (g << 2) + (g << 1);
    unsigned bb = (b << 5) - (b << 1) - b;
    return (rb + gb + bb + 128) >> 8;
}

static Pixel adjust(Pixel p, ap_uint<8> color[3][256], unsigned flags,
                    unsigned saturation) {
#pragma HLS INLINE
    int c[3];
#pragma HLS ARRAY_PARTITION variable=c complete
    for (unsigned k = 0; k < 3; ++k) {
#pragma HLS UNROLL
        ap_uint<8> v = p.range(k * 8 + 7, k * 8);
        c[k] = (flags & COLOR_LUT) ? color[k][v] : v;
    }
    Pixel mapped;
    for (unsigned k = 0; k < 3; ++k) {
#pragma HLS UNROLL
        mapped.range(k*8+7,k*8) = c[k];
    }
    int y = luma(mapped);
    Pixel result = 0;
    for (unsigned k = 0; k < 3; ++k) {
#pragma HLS UNROLL
        ap_int<10> delta = c[k] - y;
        ap_uint<14> gain = saturation;
        ap_int<25> product = delta * gain;
        int v = (flags & SATURATION)
            ? round_shift_even((y << 12) + int(product), 12) : c[k];
        result.range(k * 8 + 7, k * 8) = clip(v);
    }
    return result;
}

static Pixel equalize(Pixel p, const ap_uint<8> lut[256], bool enabled) {
#pragma HLS INLINE
    if (!enabled) return p;
    int b = p.range(7, 0), g = p.range(15, 8), r = p.range(23, 16);
    int r43 = (r << 5) + (r << 3) + (r << 1) + r;
    int g85 = (g << 6) + (g << 4) + (g << 2) + g;
    int g107 = (g << 6) + (g << 5) + (g << 3) + (g << 1) + g;
    int b21 = (b << 4) + (b << 2) + b;
    int cb = int(clip(round_shift_even(32768 - r43 - g85 + (b << 7), 8))) - 128;
    int cr = int(clip(round_shift_even(32768 + (r << 7) - g107 - b21, 8))) - 128;
    int y = int(lut[luma(p)]) << 8;
    // Multiplying signed chroma via positive magnitudes avoids shifting negatives.
    int acb = cb < 0 ? -cb : cb, acr = cr < 0 ? -cr : cr;
    int cr359 = (acr << 8) + (acr << 6) + (acr << 5) + (acr << 2) + (acr << 1) + acr;
    int cb88 = (acb << 6) + (acb << 4) + (acb << 3);
    int cr183 = (acr << 7) + (acr << 5) + (acr << 4) + (acr << 2) + (acr << 1) + acr;
    int cb454 = (acb << 8) + (acb << 7) + (acb << 6) + (acb << 2) + (acb << 1);
    cr359 = cr < 0 ? -cr359 : cr359;
    cb88 = cb < 0 ? -cb88 : cb88;
    cr183 = cr < 0 ? -cr183 : cr183;
    cb454 = cb < 0 ? -cb454 : cb454;
    Pixel result;
    result.range(23,16) = clip(round_shift_even(y + cr359, 8));
    result.range(15,8) = clip(round_shift_even(y - cb88 - cr183, 8));
    result.range(7,0) = clip(round_shift_even(y + cb454, 8));
    return result;
}

static void read_words(const Word *src, hls::stream<Word> &words,
                       unsigned width, unsigned height, unsigned stride) {
#pragma HLS INLINE off
    unsigned count = (width * 3 + 15) / 16;
    for (unsigned y = 0; y < height; ++y) {
#pragma HLS LOOP_TRIPCOUNT min=416 max=1080
        for (unsigned x = 0; x < count; ++x) {
#pragma HLS PIPELINE II=1
#pragma HLS LOOP_TRIPCOUNT min=78 max=360
            words.write(src[word_address(y, stride / 16, x)]);
        }
    }
}

static void unpack(hls::stream<Word> &words, hls::stream<Pixel> &pixels,
                   unsigned width, unsigned height) {
#pragma HLS INLINE off
    for (unsigned y = 0; y < height; ++y) {
#pragma HLS LOOP_TRIPCOUNT min=416 max=1080
        ap_uint<152> reservoir = 0;
        unsigned bits = 0;
        for (unsigned x = 0; x < width; ++x) {
#pragma HLS PIPELINE II=1
#pragma HLS LOOP_TRIPCOUNT min=416 max=1920
            if (bits < 24) {
                reservoir |= ap_uint<152>(words.read()) << bits;
                bits += 128;
            }
            pixels.write(reservoir.range(23,0));
            reservoir >>= 24;
            bits -= 24;
        }
    }
}

static void histogram_pixels(hls::stream<Pixel> &pixels, ap_uint<32> hist[256],
                             ap_uint<8> color[3][256], unsigned flags,
                             unsigned saturation, unsigned count) {
#pragma HLS INLINE off
    for (unsigned i = 0; i < count; ++i) {
#pragma HLS PIPELINE II=2
#pragma HLS LOOP_TRIPCOUNT min=173056 max=2073600
        Pixel p = adjust(pixels.read(), color, flags, saturation);
        unsigned y = luma(p);
        // Real RAM dependency: deliberately retained, including repeated bins.
        hist[y] = hist[y] + 1;
    }
}

static void statistics_pass(const Word *src, unsigned width, unsigned height,
                            unsigned stride, ap_uint<8> color[3][256],
                            unsigned flags, unsigned saturation,
                            ap_uint<32> hist[256]) {
#pragma HLS INLINE off
#pragma HLS DATAFLOW
    hls::stream<Word> words("statistics_words");
    hls::stream<Pixel> pixels("statistics_pixels");
#pragma HLS STREAM variable=words depth=64
#pragma HLS STREAM variable=pixels depth=64
    read_words(src, words, width, height, stride);
    unpack(words, pixels, width, height);
    histogram_pixels(pixels, hist, color, flags, saturation, pixel_count(width,height));
}

static void build_lut(const ap_uint<32> hist[256], ap_uint<8> lut[256], unsigned n) {
#pragma HLS INLINE off
    unsigned first = 0;
    for (unsigned i = 0; i < 256; ++i) {
#pragma HLS PIPELINE II=1
        if (!first && hist[i]) first = hist[i];
    }
    // The validated frame has at most 1920*1080 pixels. The quotient is
    // always in [0,255], so a 32-bit general-purpose divider is unnecessary.
    ap_uint<22> denominator = n - first;
    ap_uint<22> cdf = 0;
    for (unsigned i = 0; i < 256; ++i) {
#pragma HLS PIPELINE off
        cdf += hist[i];
        if (!denominator) lut[i] = i;
        else {
            ap_uint<22> normalized = cdf >= first
                ? ap_uint<22>(cdf - first) : ap_uint<22>(0);
            ap_uint<30> remainder = normalized * 255;
            ap_uint<8> q = 0;
            // Restoring division for exactly eight quotient bits. Keep the
            // remainder for nearest-even rounding instead of multiplying q
            // back by the denominator.
            for (int bit = 7; bit >= 0; --bit) {
#pragma HLS PIPELINE off
                ap_uint<30> step = ap_uint<30>(denominator) << bit;
                if (remainder >= step) {
                    remainder -= step;
                    q[bit] = 1;
                }
            }
            ap_uint<23> twice = ap_uint<23>(remainder) << 1;
            if (twice > denominator || (twice == denominator && q[0])) ++q;
            lut[i] = q;
        }
    }
}

static void make_coordinates(Coordinate coordinates[TARGET], unsigned src,
                             unsigned dst) {
#pragma HLS INLINE off
    for (unsigned i = 0; i < dst; ++i) {
#pragma HLS PIPELINE off
#pragma HLS LOOP_TRIPCOUNT min=1 max=416
        // Exact rational half-pixel coordinates, then Q11 nearest-even weight.
        int numerator = int((2*i + 1)*src) - int(dst);
        unsigned denominator = 2*dst;
        unsigned index = numerator > 0 ? unsigned(numerator)/denominator : 0;
        unsigned rem = numerator > 0 ? unsigned(numerator)%denominator : 0;
        unsigned q = (rem*2048)/denominator;
        unsigned r = rem*2048 - q*denominator;
        if (2*r > denominator || (2*r == denominator && (q & 1))) ++q;
        if (index >= src - 1) { index = src - 1; q = 0; }
        coordinates[i].index = index;
        coordinates[i].weight = q;
    }
}

static void color_stage(hls::stream<Pixel> &input, hls::stream<Pair> &output,
                        hls::stream<ap_uint<8> > &hist_pixels,
                        ap_uint<8> color[3][256], const ap_uint<8> eq[256],
                        unsigned flags, unsigned saturation, bool eq_enabled,
                        unsigned count) {
#pragma HLS INLINE off
    for (unsigned i = 0; i < count; ++i) {
#pragma HLS PIPELINE II=1
#pragma HLS LOOP_TRIPCOUNT min=173056 max=2073600
        Pair p;
        p.original = input.read();
        Pixel adjusted = adjust(p.original, color, flags, saturation);
        hist_pixels.write(luma(adjusted));
        p.enhanced = equalize(adjusted, eq, eq_enabled);
        output.write(p);
    }
}

static void collect_or_drain(hls::stream<ap_uint<8> > &input,
                             ap_uint<32> hist[256], bool collect, unsigned count) {
#pragma HLS INLINE off
    if (collect) {
      for (unsigned i = 0; i < count; ++i) {
#pragma HLS PIPELINE II=2
#pragma HLS LOOP_TRIPCOUNT min=173056 max=2073600
        unsigned y = input.read();
        hist[y] = hist[y] + 1;
      }
    } else {
      for (unsigned i = 0; i < count; ++i) {
#pragma HLS PIPELINE II=1
#pragma HLS LOOP_TRIPCOUNT min=173056 max=2073600
        input.read();
      }
    }
}

static Pixel interpolate(Pixel a, Pixel b, Pixel c, Pixel d,
                         unsigned wx, unsigned wy) {
#pragma HLS INLINE
    Pixel out;
    for (unsigned k = 0; k < 3; ++k) {
#pragma HLS UNROLL
        ap_uint<8> va = a.range(8*k+7,8*k), vb = b.range(8*k+7,8*k);
        ap_uint<8> vc = c.range(8*k+7,8*k), vd = d.range(8*k+7,8*k);
        ap_uint<12> x = wx, y = wy;
        ap_int<9> dt = int(vb)-int(va), db = int(vd)-int(vc);
        ap_int<21> tx = dt*x, bx = db*x;
        ap_int<20> top = (int(va) << 11) + tx;
        ap_int<20> bottom = (int(vc) << 11) + bx;
        ap_int<20> vertical_delta = bottom-top;
        ap_int<32> vertical_product = vertical_delta*y;
        ap_int<32> sum = (ap_int<32>(top) << 11) + vertical_product + (1 << 21);
        out.range(8*k+7,8*k) = ap_uint<8>(sum >> 22);
    }
    return out;
}

static void resize_and_split(hls::stream<Pair> &input,
                             hls::stream<Pixel> &tensor,
                             hls::stream<Pixel> &preview,
                             unsigned width, unsigned height,
                             unsigned resized_w, unsigned resized_h,
                             unsigned pad_x, unsigned pad_y,
                             unsigned mode, unsigned flags,
                             const Coordinate xc[TARGET], const Coordinate yc[TARGET],
                             ap_uint<8> quant[3][256]) {
#pragma HLS INLINE off
    Pixel rows[2][MAX_WIDTH];
#pragma HLS ARRAY_PARTITION variable=rows complete dim=1
#pragma HLS BIND_STORAGE variable=rows type=ram_2p impl=bram
    unsigned consumed = 0;
    if (mode != PREVIEW_ONLY) {
        for (unsigned dy = 0; dy < TARGET; ++dy) {
            bool content_y = dy >= pad_y && dy < pad_y+resized_h;
            unsigned sy = 0, wy = 0;
            if (content_y) {
                Coordinate coord = yc[dy-pad_y];
                sy = coord.index;
                wy = coord.weight;
                unsigned needed = sy+1 < height ? sy+1 : sy;
                while (consumed <= needed) {
#pragma HLS LOOP_TRIPCOUNT min=0 max=5
                    for (unsigned x = 0; x < width; ++x) {
#pragma HLS PIPELINE II=1
#pragma HLS LOOP_TRIPCOUNT min=416 max=1920
                        Pair p = input.read();
                        rows[consumed & 1][x] = (flags & ENHANCE_TENSOR) ? p.enhanced : p.original;
                        if (mode == TENSOR_AND_PREVIEW) preview.write(p.enhanced);
                    }
                    ++consumed;
                }
            }
            for (unsigned dx = 0; dx < TARGET; ++dx) {
#pragma HLS PIPELINE II=1
                Pixel p = 0x808080;
                if (content_y && dx >= pad_x && dx < pad_x+resized_w) {
                    Coordinate coord = xc[dx-pad_x];
                    unsigned sx = coord.index;
                    unsigned sx1 = sx+1 < width ? sx+1 : sx;
                    unsigned sy1 = sy+1 < height ? sy+1 : sy;
                    p = interpolate(rows[sy & 1][sx], rows[sy & 1][sx1],
                                    rows[sy1 & 1][sx], rows[sy1 & 1][sx1],
                                    coord.weight, wy);
                }
                Pixel rgb;
                for (unsigned k = 0; k < 3; ++k) {
#pragma HLS UNROLL
                    ap_uint<8> v = p.range((2-k)*8+7,(2-k)*8);
                    rgb.range(k*8+7,k*8) = quant[k][v];
                }
                tensor.write(rgb);
            }
        }
    }
    while (consumed < height) {
#pragma HLS LOOP_TRIPCOUNT min=0 max=1080
        for (unsigned x = 0; x < width; ++x) {
#pragma HLS PIPELINE II=1
#pragma HLS LOOP_TRIPCOUNT min=416 max=1920
            Pair p = input.read();
            if (mode != TENSOR_ONLY) preview.write(p.enhanced);
        }
        ++consumed;
    }
}

static void pack(hls::stream<Pixel> &pixels, hls::stream<Word> &words,
                 unsigned width, unsigned height, bool enabled) {
#pragma HLS INLINE off
    if (!enabled) return;
    for (unsigned y = 0; y < height; ++y) {
#pragma HLS LOOP_TRIPCOUNT min=416 max=1080
        ap_uint<152> reservoir = 0;
        unsigned bits = 0;
        for (unsigned x = 0; x < width; ++x) {
#pragma HLS PIPELINE II=1
#pragma HLS LOOP_TRIPCOUNT min=416 max=1920
            reservoir |= ap_uint<152>(pixels.read()) << bits;
            bits += 24;
            if (bits >= 128) {
                words.write(reservoir.range(127,0));
                reservoir >>= 128;
                bits -= 128;
            }
        }
        if (bits) words.write(reservoir.range(127,0));
    }
}

static void write_words(Word *dst, hls::stream<Word> &words,
                        unsigned width, unsigned height, unsigned stride,
                        bool enabled) {
#pragma HLS INLINE off
    if (!enabled) return;
    unsigned count = (width*3+15)/16;
    for (unsigned y = 0; y < height; ++y) {
#pragma HLS LOOP_TRIPCOUNT min=416 max=1080
        for (unsigned x = 0; x < count; ++x) {
#pragma HLS PIPELINE II=1
#pragma HLS LOOP_TRIPCOUNT min=78 max=360
            dst[word_address(y,stride/16,x)] = words.read();
        }
    }
}

static void output_pass(const Word *src, Word *tensor, Word *preview,
                        unsigned width, unsigned height, unsigned stride,
                        unsigned preview_stride, unsigned rw, unsigned rh,
                        unsigned px, unsigned py, unsigned mode, unsigned flags,
                        unsigned saturation, bool eq_enabled, bool collect,
                        ap_uint<8> color[3][256], ap_uint<8> quant[3][256],
                        const ap_uint<8> eq[256], ap_uint<32> hist[256],
                        const Coordinate xc[TARGET], const Coordinate yc[TARGET]) {
#pragma HLS INLINE off
#pragma HLS DATAFLOW
    hls::stream<Word> in_words("in_words"), tensor_words("tensor_words"), preview_words("preview_words");
    hls::stream<Pixel> in_pixels("in_pixels"), tensor_pixels("tensor_pixels"), preview_pixels("preview_pixels");
    hls::stream<Pair> pairs("pairs");
    hls::stream<ap_uint<8> > hist_pixels("hist_pixels");
#pragma HLS STREAM variable=in_words depth=64
#pragma HLS STREAM variable=tensor_words depth=64
#pragma HLS STREAM variable=preview_words depth=64
#pragma HLS STREAM variable=in_pixels depth=64
#pragma HLS STREAM variable=tensor_pixels depth=64
#pragma HLS STREAM variable=preview_pixels depth=64
#pragma HLS STREAM variable=pairs depth=64
#pragma HLS STREAM variable=hist_pixels depth=64
    read_words(src, in_words, width, height, stride);
    unpack(in_words, in_pixels, width, height);
    color_stage(in_pixels, pairs, hist_pixels, color, eq, flags, saturation, eq_enabled, pixel_count(width,height));
    collect_or_drain(hist_pixels, hist, collect, pixel_count(width,height));
    resize_and_split(pairs, tensor_pixels, preview_pixels, width, height,
                     rw, rh, px, py, mode, flags, xc, yc, quant);
    pack(tensor_pixels, tensor_words, TARGET, TARGET, mode != PREVIEW_ONLY);
    pack(preview_pixels, preview_words, width, height, mode != TENSOR_ONLY);
    write_words(tensor, tensor_words, TARGET, TARGET, TARGET*3, mode != PREVIEW_ONLY);
    write_words(preview, preview_words, width, height, preview_stride, mode != TENSOR_ONLY);
}
}

extern "C" unsigned image_preprocess(
    const Word *src, Word *tensor, Word *preview, const Word *luts,
    unsigned width, unsigned height, unsigned src_stride,
    unsigned src_capacity, unsigned tensor_capacity, unsigned preview_stride,
    unsigned preview_capacity, unsigned resized_w, unsigned resized_h,
    unsigned pad_x, unsigned pad_y, unsigned output_mode, unsigned flags,
    unsigned eq_mode, unsigned saturation_q12, unsigned frame_id,
    unsigned config_id, unsigned &completed_frame_id,
    unsigned &completed_config_id, unsigned &tensor_bytes,
    unsigned &preview_bytes, unsigned &abi_version) {
#pragma HLS INTERFACE m_axi port=src offset=slave bundle=gmem_in depth=388800 max_read_burst_length=32 num_read_outstanding=2
#pragma HLS INTERFACE m_axi port=luts offset=slave bundle=gmem_in depth=32 max_read_burst_length=32 num_read_outstanding=2
#pragma HLS INTERFACE m_axi port=tensor offset=slave bundle=gmem_out depth=32448 max_write_burst_length=32 num_write_outstanding=2
#pragma HLS INTERFACE m_axi port=preview offset=slave bundle=gmem_preview depth=388800 max_write_burst_length=32 num_write_outstanding=2
#pragma HLS INTERFACE s_axilite port=src bundle=control
#pragma HLS INTERFACE s_axilite port=luts bundle=control
#pragma HLS INTERFACE s_axilite port=tensor bundle=control
#pragma HLS INTERFACE s_axilite port=preview bundle=control
#pragma HLS INTERFACE s_axilite port=width bundle=control
#pragma HLS INTERFACE s_axilite port=height bundle=control
#pragma HLS INTERFACE s_axilite port=src_stride bundle=control
#pragma HLS INTERFACE s_axilite port=src_capacity bundle=control
#pragma HLS INTERFACE s_axilite port=tensor_capacity bundle=control
#pragma HLS INTERFACE s_axilite port=preview_stride bundle=control
#pragma HLS INTERFACE s_axilite port=preview_capacity bundle=control
#pragma HLS INTERFACE s_axilite port=resized_w bundle=control
#pragma HLS INTERFACE s_axilite port=resized_h bundle=control
#pragma HLS INTERFACE s_axilite port=pad_x bundle=control
#pragma HLS INTERFACE s_axilite port=pad_y bundle=control
#pragma HLS INTERFACE s_axilite port=output_mode bundle=control
#pragma HLS INTERFACE s_axilite port=flags bundle=control
#pragma HLS INTERFACE s_axilite port=eq_mode bundle=control
#pragma HLS INTERFACE s_axilite port=saturation_q12 bundle=control
#pragma HLS INTERFACE s_axilite port=frame_id bundle=control
#pragma HLS INTERFACE s_axilite port=config_id bundle=control
#pragma HLS INTERFACE s_axilite port=completed_frame_id bundle=control
#pragma HLS INTERFACE s_axilite port=completed_config_id bundle=control
#pragma HLS INTERFACE s_axilite port=tensor_bytes bundle=control
#pragma HLS INTERFACE s_axilite port=preview_bytes bundle=control
#pragma HLS INTERFACE s_axilite port=abi_version bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control
    abi_version = ABI_VERSION;
    tensor_bytes = preview_bytes = 0;
    completed_frame_id = frame_id;
    completed_config_id = config_id;
    unsigned status = validate_settings(width, height, src_stride, src_capacity,
        tensor_capacity, preview_stride, preview_capacity, resized_w, resized_h,
        pad_x, pad_y, output_mode, flags, eq_mode, saturation_q12);
    if (status != OK) return status;

    ap_uint<8> color[3][256], quant[3][256], eq[256];
#pragma HLS ARRAY_PARTITION variable=color complete dim=1
#pragma HLS ARRAY_PARTITION variable=quant complete dim=1
#pragma HLS BIND_STORAGE variable=color type=ram_2p impl=lutram
#pragma HLS BIND_STORAGE variable=quant type=ram_2p impl=lutram
#pragma HLS BIND_STORAGE variable=eq type=ram_2p impl=lutram
    ap_uint<32> hist[256];
#pragma HLS BIND_STORAGE variable=hist type=ram_2p impl=bram
    static ap_uint<8> previous[256];
    static bool history_valid = false;
    static unsigned previous_width = 0, previous_height = 0, previous_config = 0;
    static unsigned previous_flags = 0, previous_saturation = 0;
#pragma HLS BIND_STORAGE variable=previous type=ram_2p impl=lutram
    bool use_history = history_valid && eq_mode == EQ_PREVIOUS && !(flags & RESET_HISTORY)
        && previous_width == width && previous_height == height && previous_config == config_id
        && previous_flags == (flags & (COLOR_LUT | SATURATION)) && previous_saturation == saturation_q12;
    for (unsigned word = 0; word < 32; ++word) {
        Word v = luts[word];
        for (unsigned byte = 0; byte < 16; ++byte) {
#pragma HLS PIPELINE II=1
            unsigned i = (word & 15)*16+byte;
            for (unsigned channel = 0; channel < 3; ++channel) {
#pragma HLS UNROLL
                if (word < 16) color[channel][i] = v.range(byte*8+7,byte*8);
                else quant[channel][i] = v.range(byte*8+7,byte*8);
            }
        }
    }
    for (unsigned i = 0; i < 256; ++i) {
#pragma HLS PIPELINE II=1
        hist[i] = 0;
        eq[i] = use_history ? previous[i] : ap_uint<8>(i);
    }
    Coordinate xc[TARGET], yc[TARGET];
#pragma HLS BIND_STORAGE variable=xc type=ram_1p impl=bram
#pragma HLS BIND_STORAGE variable=yc type=ram_1p impl=bram
    make_coordinates(xc, width, resized_w);
    make_coordinates(yc, height, resized_h);
    if (eq_mode == EQ_CURRENT) {
        statistics_pass(src, width, height, src_stride, color, flags, saturation_q12, hist);
        build_lut(hist, eq, pixel_count(width,height));
    }
    output_pass(src, tensor, preview, width, height, src_stride, preview_stride,
                resized_w, resized_h, pad_x, pad_y, output_mode, flags, saturation_q12,
                eq_mode == EQ_CURRENT || use_history, eq_mode == EQ_PREVIOUS,
                color, quant, eq, hist, xc, yc);
    history_valid = eq_mode == EQ_PREVIOUS;
    if (eq_mode == EQ_PREVIOUS) build_lut(hist, previous, pixel_count(width,height));
    previous_width = width; previous_height = height; previous_config = config_id;
    previous_flags = flags & (COLOR_LUT | SATURATION); previous_saturation = saturation_q12;
    tensor_bytes = output_mode != PREVIEW_ONLY ? TENSOR_BYTES : 0;
    preview_bytes = output_mode != TENSOR_ONLY ? pixel_count(width,height)*3 : 0;
    return OK;
}