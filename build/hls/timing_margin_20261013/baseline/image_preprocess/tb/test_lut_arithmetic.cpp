// Include the implementation to exercise the internal LUT builder directly.
#include "../src/image_preprocess.cpp"
#include <cassert>
#include <iostream>
#include <random>

static void check(const unsigned counts[256]) {
    ap_uint<32> hist[256];
    ap_uint<8> lut[256];
    unsigned n = 0, first = 0;
    for (unsigned i = 0; i < 256; ++i) {
        hist[i] = counts[i];
        n += counts[i];
        if (!first && counts[i]) first = counts[i];
    }
    assert(n && n <= image_hls::MAX_WIDTH * image_hls::MAX_HEIGHT);
    build_lut(hist, lut, n);
    unsigned cdf = 0, denominator = n - first;
    for (unsigned i = 0; i < 256; ++i) {
        cdf += counts[i];
        unsigned expected = i;
        if (denominator) {
            uint64_t numerator = uint64_t(cdf >= first ? cdf - first : 0) * 255;
            expected = numerator / denominator;
            uint64_t rem = numerator % denominator;
            if (2 * rem > denominator ||
                (2 * rem == denominator && (expected & 1))) ++expected;
        }
        assert(lut[i].to_uint() == expected);
    }
}

int main() {
    unsigned counts[256] = {};
    // Constant frame, first nonzero bin away from zero, largest valid count.
    counts[123] = image_hls::MAX_WIDTH * image_hls::MAX_HEIGHT;
    check(counts);
    counts[123] = 0;
    // Largest denominator/numerator and a CDF one pixel below its maximum.
    counts[0] = 1;
    counts[254] = image_hls::MAX_WIDTH * image_hls::MAX_HEIGHT - 2;
    counts[255] = 1;
    check(counts);
    counts[254] = counts[255] = 0;
    // Both nearest-even directions: 255/6=42.5 and 3*255/6=127.5.
    counts[0] = 1; counts[1] = 1; counts[2] = 2; counts[3] = 3;
    check(counts);
    std::mt19937 rng(20261013);
    for (unsigned trial = 0; trial < 2000; ++trial) {
        for (unsigned i = 0; i < 256; ++i)
            counts[i] = trial % 2 ? rng() % 8000 : (rng() % 8 ? 0 : rng() % 8000);
        check(counts);
    }
    std::cout << "PASS exact LUT division and nearest-even boundaries\n";
}