#include "../src/image_preprocess.cpp"
#include <cassert>
#include <cstdint>
#include <iostream>
#include <random>

static void check(unsigned src, unsigned dst) {
    Coordinate actual[image_hls::TARGET];
    make_coordinates(actual, src, dst);
    for (unsigned i = 0; i < dst; ++i) {
        uint64_t numerator = uint64_t(2*i+1)*src-dst;
        unsigned denominator = 2*dst;
        unsigned index = numerator/denominator;
        uint64_t scaled = (numerator%denominator)*2048;
        unsigned weight = scaled/denominator, remainder = scaled%denominator;
        if (2*remainder > denominator ||
            (2*remainder == denominator && (weight&1))) ++weight;
        if (index >= src-1) { index = src-1; weight = 0; }
        assert(actual[i].index == index);
        assert(actual[i].weight == weight);
    }
}

int main() {
    for (unsigned src : {416u, 417u, 640u, 1080u, 1919u, 1920u})
        for (unsigned dst = 1; dst <= image_hls::TARGET; ++dst) check(src, dst);
    std::mt19937 rng(20261014);
    for (unsigned i = 0; i < 1000; ++i) check(416+rng()%1505, 1+rng()%416);
    for (unsigned denominator = 2; denominator <= 832; denominator += 2) {
        for (unsigned numerator : {0u, 1u, denominator-1, denominator,
                                   denominator+1, 1703936u, 2097151u}) {
            ap_uint<10> remainder;
            ap_uint<21> quotient = coordinate_divide(numerator, denominator, remainder);
            assert(quotient == numerator/denominator);
            assert(remainder == numerator%denominator);
        }
    }
    std::cout << "PASS exact coordinates, Q11 ties and divider boundaries\n";
}