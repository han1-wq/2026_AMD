#include "image_preprocess.h"
#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

using namespace image_hls;
typedef std::vector<unsigned char> Bytes;

namespace {
int failures = 0;
void check(bool condition, const std::string &message) {
    if (!condition) { std::cerr << "FAIL: " << message << '\n'; ++failures; }
}
int clamp(int x) { return std::max(0, std::min(255, x)); }
// Independent floating-point golden model; nearbyint is ties-to-even under FE_TONEAREST.
int rn(double x) { return int(std::nearbyint(x)); }
struct Settings {
    unsigned w = 640, h = 480, mode = TENSOR_AND_PREVIEW;
    unsigned flags = 0, eq = EQ_OFF, saturation = 4096, config = 1;
    double alpha = 1;
    int beta = 0, fix = 6, pattern = 0;
};

struct ReferenceState {
    bool valid = false;
    unsigned w = 0, h = 0, flags = 0, saturation = 0, config = 0;
    Bytes lut;
} reference_state;

Bytes make_source(const Settings &s) {
    Bytes image(s.w*s.h*3);
    unsigned seed = 0x12345678;
    for (unsigned y = 0; y < s.h; ++y) {
        for (unsigned x = 0; x < s.w; ++x) {
            for (unsigned c = 0; c < 3; ++c) {
                seed = 1664525u*seed + 1013904223u;
                unsigned v = seed >> 24;
                if (s.pattern == 1) v = 73;
                if (s.pattern == 2) v = x < s.w/2 ? 40 : 190;
                if (s.pattern == 3) v = (x+y+c*53) % 256;
                if (s.pattern == 4) v = 0;
                if (s.pattern == 5) v = 255;
                if (s.pattern == 6) v = ((x/8+y/8)&1) ? 255 : 0;
                if (s.pattern == 7) v = (x*3/s.w == c) ? 255 : 0;
                image[(y*s.w+x)*3+c] = v;
            }
        }
    }
    return image;
}

Bytes color_lut(const Settings &s) {
    Bytes lut(256);
    for (int i = 0; i < 256; ++i) lut[i] = clamp(rn(s.alpha*(i-128)+128+s.beta));
    return lut;
}
Bytes quant_lut(const Settings &s) {
    Bytes lut(256);
    for (int i = 0; i < 256; ++i) {
        int q = std::max(-128, std::min(127, rn(std::ldexp(double(i), s.fix-8))));
        lut[i] = static_cast<unsigned char>(q);
    }
    return lut;
}
unsigned luminance(const unsigned char *p) {
    return unsigned(std::floor((29.0*p[0]+150.0*p[1]+77.0*p[2]+128.0)/256.0));
}

Bytes golden_enhance(const Bytes &src, const Settings &s) {
    Bytes adjusted(src.size());
    Bytes lut = color_lut(s);
    for (unsigned i = 0; i < src.size(); i += 3) {
        unsigned char p[3];
        for (unsigned c = 0; c < 3; ++c) p[c] = (s.flags & COLOR_LUT) ? lut[src[i+c]] : src[i+c];
        double y = luminance(p);
        for (unsigned c = 0; c < 3; ++c)
            adjusted[i+c] = (s.flags & SATURATION)
                ? clamp(rn(y + double(s.saturation)/4096.0*(int(p[c])-y))) : p[c];
    }
    std::vector<unsigned> hist(256, 0);
    for (unsigned i = 0; i < adjusted.size(); i += 3) ++hist[luminance(&adjusted[i])];
    unsigned first = 0, cumulative = 0, n = s.w*s.h;
    for (unsigned i = 0; i < 256 && !first; ++i) first = hist[i];
    Bytes new_lut(256);
    for (unsigned i = 0; i < 256; ++i) {
        cumulative += hist[i];
        new_lut[i] = n == first ? i : clamp(rn(255.0*std::max(0, int(cumulative)-int(first))/(n-first)));
    }
    bool previous = reference_state.valid && s.eq == EQ_PREVIOUS && !(s.flags & RESET_HISTORY)
        && reference_state.w == s.w && reference_state.h == s.h && reference_state.config == s.config
        && reference_state.flags == (s.flags & (COLOR_LUT | SATURATION))
        && reference_state.saturation == s.saturation;
    Bytes applied = s.eq == EQ_CURRENT ? new_lut : reference_state.lut;
    Bytes result = adjusted;
    if (s.eq == EQ_CURRENT || previous) {
        for (unsigned i = 0; i < adjusted.size(); i += 3) {
            double b = adjusted[i], g = adjusted[i+1], r = adjusted[i+2];
            double cb = clamp(rn(128+(-43*r-85*g+128*b)/256.0))-128;
            double cr = clamp(rn(128+(128*r-107*g-21*b)/256.0))-128;
            double y = applied[luminance(&adjusted[i])];
            result[i] = clamp(rn(y+454*cb/256.0));
            result[i+1] = clamp(rn(y-(88*cb+183*cr)/256.0));
            result[i+2] = clamp(rn(y+359*cr/256.0));
        }
    }
    reference_state.valid = s.eq == EQ_PREVIOUS;
    reference_state.w = s.w; reference_state.h = s.h; reference_state.config = s.config;
    reference_state.flags = s.flags & (COLOR_LUT | SATURATION);
    reference_state.saturation = s.saturation; reference_state.lut = new_lut;
    return result;
}

Bytes golden_tensor(const Bytes &src, const Settings &s, unsigned rw, unsigned rh) {
    Bytes quant = quant_lut(s), result(TENSOR_BYTES, quant[128]);
    unsigned px = (TARGET-rw)/2, py = (TARGET-rh)/2;
    for (unsigned y = 0; y < rh; ++y) {
        double fy = (y+0.5)*s.h/rh-0.5;
        int iy = std::max(0, int(std::floor(fy)));
        int iy1 = std::min(int(s.h)-1, iy+1);
        double wy = iy == int(s.h)-1 ? 0 : rn((fy-iy)*2048)/2048.0;
        for (unsigned x = 0; x < rw; ++x) {
            double fx = (x+0.5)*s.w/rw-0.5;
            int ix = std::max(0, int(std::floor(fx)));
            int ix1 = std::min(int(s.w)-1, ix+1);
            double wx = ix == int(s.w)-1 ? 0 : rn((fx-ix)*2048)/2048.0;
            for (unsigned c = 0; c < 3; ++c) {
                double top = src[(iy*s.w+ix)*3+c]*(1-wx)+src[(iy*s.w+ix1)*3+c]*wx;
                double bottom = src[(iy1*s.w+ix)*3+c]*(1-wx)+src[(iy1*s.w+ix1)*3+c]*wx;
                unsigned v = unsigned(std::floor(top*(1-wy)+bottom*wy+0.5));
                result[((y+py)*TARGET+x+px)*3+(2-c)] = quant[v];
            }
        }
    }
    return result;
}

void put_byte(std::vector<Word> &words, unsigned i, unsigned char value) {
    words[i/16].range((i%16)*8+7,(i%16)*8) = value;
}
unsigned char get_byte(const std::vector<Word> &words, unsigned i) {
    return words[i/16].range((i%16)*8+7,(i%16)*8).to_uint();
}
void compare(const Bytes &expected, const std::vector<Word> &actual,
             unsigned width, unsigned height, unsigned stride, const std::string &name) {
    unsigned errors = 0;
    for (unsigned y = 0; y < height; ++y) {
        for (unsigned x = 0; x < width*3; ++x) {
            unsigned got = get_byte(actual, y*stride+x);
            unsigned want = expected[y*width*3+x];
            if (got != want) {
                if (errors < 3) std::cerr << name << " y=" << y << " byte=" << x
                                        << " expected=" << want << " actual=" << got << '\n';
                ++errors;
            }
        }
    }
    check(errors == 0, name+" differing bytes="+std::to_string(errors));
}

void run_case(const std::string &name, const Settings &s, bool dump = false) {
    static unsigned frame = 0;
    ++frame;
    unsigned stride = (s.w*3+15)&~15u;
    double scale = std::min(double(TARGET)/s.w, double(TARGET)/s.h);
    unsigned rw = rn(s.w*scale), rh = rn(s.h*scale);
    Bytes src_bytes = make_source(s), enhanced = golden_enhance(src_bytes, s);
    Bytes expected = golden_tensor((s.flags & ENHANCE_TENSOR) ? enhanced : src_bytes, s, rw, rh);
    // Co-simulation wrappers serialize the full declared m_axi depth.
    std::vector<Word> src(MAX_FRAME_WORDS+1, 0), tensor(TENSOR_BYTES/16+1, 0), preview(MAX_FRAME_WORDS+1, 0), luts(32,0);
    Word guard = ~Word(0);
    src.back() = tensor.back() = preview.back() = guard;
    src[stride*s.h/16] = preview[stride*s.h/16] = guard;
    for (unsigned y = 0; y < s.h; ++y)
        for (unsigned x = 0; x < s.w*3; ++x) put_byte(src, y*stride+x, src_bytes[y*s.w*3+x]);
    Bytes color = color_lut(s), quant = quant_lut(s);
    for (unsigned i = 0; i < 256; ++i) { put_byte(luts, i, color[i]); put_byte(luts, i+256, quant[i]); }
    unsigned done_frame=0, done_config=0, tb=0, pb=0, abi=0;
    unsigned status = image_preprocess(src.data(), tensor.data(), preview.data(), luts.data(),
        s.w, s.h, stride, stride*s.h, TENSOR_BYTES, stride, stride*s.h,
        rw, rh, (TARGET-rw)/2, (TARGET-rh)/2, s.mode, s.flags, s.eq, s.saturation,
        frame, s.config, done_frame, done_config, tb, pb, abi);
    check(status == OK, name+" status");
    check(done_frame == frame && done_config == s.config && abi == ABI_VERSION, name+" metadata");
    check(tb == (s.mode == PREVIEW_ONLY ? 0 : TENSOR_BYTES), name+" tensor count");
    check(pb == (s.mode == TENSOR_ONLY ? 0 : s.w*s.h*3), name+" preview count");
    check(src.back() == guard && tensor.back() == guard && preview.back() == guard, name+" guard words");
    check(src[stride*s.h/16] == guard && preview[stride*s.h/16] == guard, name+" capacity guard");
    if (s.mode != PREVIEW_ONLY) compare(expected, tensor, TARGET, TARGET, TARGET*3, name+" tensor");
    else check(tensor.front() == 0, name+" disabled tensor unchanged");
    if (s.mode != TENSOR_ONLY) {
        compare(enhanced, preview, s.w, s.h, stride, name+" preview");
        for (unsigned y = 0; y < s.h; ++y)
            for (unsigned x = s.w*3; x < stride; ++x) check(get_byte(preview,y*stride+x)==0,name+" tail zero");
    } else check(preview.front() == 0, name+" disabled preview unchanged");
    if (dump) {
        std::ofstream input("opencv_source.bgr", std::ios::binary);
        input.write(reinterpret_cast<const char *>(src_bytes.data()), src_bytes.size());
        Bytes actual(TENSOR_BYTES);
        for (unsigned i = 0; i < TENSOR_BYTES; ++i) actual[i] = get_byte(tensor,i);
        std::ofstream output("opencv_tensor.int8", std::ios::binary);
        output.write(reinterpret_cast<const char *>(actual.data()), actual.size());
    }
    std::cout << "CASE " << name << " completed\n";
}

void invalid_cases() {
    // Every call must reject before touching any AXI memory pointer.
    unsigned f,c,t,p,a;
    for (unsigned k = 0; k < 7; ++k) {
        unsigned status = image_preprocess(0,0,0,0, k==0 ? 0 : 640,480,
            k==1 ? 1919 : 1920, k==2 ? 1 : 921600,519168,1920,921600,
            k==4 ? 417 : 416,312,0,52,k==3 ? 3 : 0,k==6 ? 16 : 0,0,k==5 ? 8193 : 4096,
            77,88,f,c,t,p,a);
        const unsigned expected[] = {BAD_SIZE,BAD_STRIDE,BAD_CAPACITY,BAD_MODE,BAD_GEOMETRY,BAD_SATURATION,BAD_MODE};
        check(status == expected[k] && t == 0 && p == 0, "invalid request "+std::to_string(k));
    }
}
}

int main(int argc, char **argv) {
    bool smoke = argc > 1 && std::string(argv[1]) == "--smoke";
    Settings s;
    if (smoke) {
        s.pattern=3;
        s.flags=COLOR_LUT|SATURATION|ENHANCE_TENSOR; s.alpha=1.25; s.beta=-12; s.saturation=6144;
        s.eq=EQ_CURRENT;
        run_case("rtl_smoke_current_equalization",s);
        s.w = s.h = 416; s.eq=EQ_PREVIOUS; s.flags|=RESET_HISTORY; s.pattern=2;
        run_case("rtl_previous_first",s);
        s.flags &= ~RESET_HISTORY; s.pattern=1;
        run_case("rtl_previous_second",s);
        ++s.config; s.mode=PREVIEW_ONLY;
        run_case("rtl_previous_config_reset_preview",s);
        s.eq=EQ_OFF; s.mode=TENSOR_ONLY; s.flags=0; s.pattern=3;
        run_case("rtl_bypass_tensor_only",s);
    } else {
        run_case("baseline_random_640x480",s,true);
        s.mode=TENSOR_ONLY; s.pattern=3; s.fix=8; run_case("quantization_clip",s);
        s.w=641; s.h=479; s.mode=TENSOR_AND_PREVIEW; s.fix=6; run_case("odd_stride",s);
        s=Settings(); s.flags=COLOR_LUT|SATURATION|ENHANCE_TENSOR;
        s.alpha=1.5; s.beta=-20; s.saturation=6144; run_case("enhanced_tensor_preview",s);
        s.flags=COLOR_LUT|SATURATION; run_case("raw_tensor_enhanced_preview",s);
        s.flags|=ENHANCE_TENSOR; s.saturation=0; s.eq=EQ_CURRENT; run_case("gray_equalize",s);
        s=Settings(); s.pattern=1; s.eq=EQ_CURRENT; s.flags=ENHANCE_TENSOR; run_case("constant_histogram",s);
        s.pattern=2; run_case("two_bin_histogram",s);
        s=Settings(); s.eq=EQ_PREVIOUS; s.flags=ENHANCE_TENSOR|RESET_HISTORY; run_case("previous_first",s);
        s.flags=ENHANCE_TENSOR; s.pattern=2; run_case("previous_second",s);
        s.config++; run_case("previous_config_reset",s);
        s.eq=EQ_OFF; run_case("previous_leave_mode",s);
        s.eq=EQ_PREVIOUS; run_case("previous_reenter",s);
        s=Settings(); s.mode=PREVIEW_ONLY; s.flags=COLOR_LUT|SATURATION;
        s.alpha=4; s.beta=255; s.saturation=8192; run_case("preview_only_limits",s);
        s.alpha=0; s.beta=-255; run_case("preview_black",s);
        s=Settings(); s.w=s.h=416; s.pattern=3; run_case("identity_resize",s);
        s=Settings(); s.w=1920; s.h=1080; s.pattern=3; s.mode=TENSOR_ONLY; run_case("maximum_geometry",s);
        s=Settings(); s.mode=TENSOR_ONLY; s.pattern=4; run_case("all_black",s);
        s.pattern=5; run_case("all_white",s);
        s.pattern=6; run_case("checkerboard",s);
        s.pattern=7; run_case("bgr_color_bars",s);
        s=Settings(); s.w=1280; s.h=720; s.pattern=3; s.mode=TENSOR_ONLY; run_case("hd_geometry",s);
        s.w=1920; s.h=416; run_case("wide_geometry",s);
        s.w=416; s.h=1080; run_case("tall_geometry",s);
        invalid_cases();
    }
    std::cout << (failures ? "FAIL" : "PASS") << ": " << failures << " failures\n";
    return failures ? EXIT_FAILURE : EXIT_SUCCESS;
}