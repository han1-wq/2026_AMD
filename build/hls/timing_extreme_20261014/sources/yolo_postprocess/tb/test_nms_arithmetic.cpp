// Include the implementation to compare internal NMS arithmetic exactly.
#include "../src/yolo_postprocess.cpp"
#include <algorithm>
#include <cassert>
#include <iostream>
#include <random>

static bool reference(const Box& a, const Box& b, unsigned threshold) {
    int left = std::max(a.x1, b.x1), top = std::max(a.y1, b.y1);
    int right = std::min(a.x2, b.x2), bottom = std::min(a.y2, b.y2);
    if (right <= left || bottom <= top) return false;
    using Wide = unsigned __int128;
    Wide intersection = Wide(int64_t(right) - left) * (int64_t(bottom) - top);
    Wide total = Wide(int64_t(a.x2) - a.x1) * (int64_t(a.y2) - a.y1)
               + Wide(int64_t(b.x2) - b.x1) * (int64_t(b.y2) - b.y1) - intersection;
    return (intersection << 16) > total * threshold;
}

int main() {
    // Exercise every partial-product carry boundary and the full unsigned ABI.
    const unsigned edges[] = {0u, 1u, 65535u, 65536u, 65537u,
                              0x7fffffffu, 0x80000000u, 0xfffffffeu, 0xffffffffu};
    for (unsigned w : edges) for (unsigned h : edges)
        assert(area(w, h).to_uint64() == uint64_t(w) * h);
    std::mt19937 area_rng(121);
    for (unsigned i = 0; i < 50000; ++i) {
        uint64_t low = (uint64_t(area_rng()) << 32) | area_rng();
        unsigned high = area_rng() & 1, limit = area_rng() % 131072;
        ap_uint<65> total = (ap_uint<65>(high) << 64) | low;
        unsigned __int128 expected = ((static_cast<unsigned __int128>(high) << 64) | low) * limit;
        ap_uint<82> actual = threshold_product(total, limit);
        assert(actual.range(63,0).to_uint64() == uint64_t(expected));
        assert(actual.range(81,64).to_uint() == unsigned(expected >> 64));
    }
    for (unsigned i = 0; i < 50000; ++i) {
        unsigned w = area_rng(), h = area_rng();
        assert(area(w, h).to_uint64() == uint64_t(w) * h);
    }
    Box a = {-100, -100, 100, 100, 1, 0, 0};
    Box b = a;
    Box full = {INT32_MIN, INT32_MIN, INT32_MAX, INT32_MAX, 1, 0, 0};
    for (unsigned threshold : {0u, 1u, 32768u, 65535u, 65536u})
        assert(suppress(full, full, threshold) == reference(full, full, threshold));
    for (unsigned threshold : {0u, 1u, 32768u, 39322u, 65535u, 65536u}) {
        assert(suppress(a, b, threshold) == reference(a, b, threshold));
        b = {100, -100, 300, 100, 1, 0, 1};
        assert(!suppress(a, b, threshold));
        b = a;
    }
    // Intersection=100, union=200: exact IoU threshold must not suppress.
    a = {0, 0, 20, 10, 1, 0, 0}; b = {0, 0, 10, 10, 1, 0, 1};
    assert(!suppress(a, b, 32768));
    assert(suppress(a, b, 32767));
    std::mt19937 rng(83);
    for (unsigned trial = 0; trial < 20000; ++trial) {
        // Large legal coordinates exercise product bits above 64 after Q16
        // scaling, along with negative and overlapping box coordinates.
        int x = int(rng() % 1000000000) - 500000000;
        int y = int(rng() % 1000000000) - 500000000;
        a = {x, y, x + int(rng() % 1500000000), y + int(rng() % 1500000000), 1, 0, 0};
        x = int(rng() % 1000000000) - 500000000;
        y = int(rng() % 1000000000) - 500000000;
        b = {x, y, x + int(rng() % 1500000000), y + int(rng() % 1500000000), 1, 0, 1};
        unsigned threshold = rng() % 65537;
        assert(suppress(a, b, threshold) == reference(a, b, threshold));
    }
    std::cout << "PASS 50081 full-width area products, exact NMS products and strict threshold boundaries\n";
}