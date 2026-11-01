#include "../src/image_preprocess.cpp"
#include <array>
#include <cassert>
#include <cstdint>
#include <iostream>
#include <random>

using Request = std::array<unsigned, 15>;

static unsigned reference(const Request& r) {
    const unsigned w=r[0], h=r[1], stride=r[2], cap=r[3], tensor=r[4];
    const unsigned ps=r[5], pc=r[6], rw=r[7], rh=r[8], px=r[9], py=r[10];
    const unsigned mode=r[11], flags=r[12], eq=r[13], sat=r[14];
    if (w < TARGET || h < TARGET || w > MAX_WIDTH || h > MAX_HEIGHT) return BAD_SIZE;
    if (mode > TENSOR_AND_PREVIEW || eq > EQ_PREVIOUS || (flags & ~15u)) return BAD_MODE;
    if (stride % 16 || stride < w*3 || stride > MAX_WIDTH*3) return BAD_STRIDE;
    if (mode != TENSOR_ONLY && (ps % 16 || ps < w*3 || ps > MAX_WIDTH*3)) return BAD_STRIDE;
    if (uint64_t(cap) < uint64_t(stride)*h ||
        (mode != PREVIEW_ONLY && tensor < TENSOR_BYTES) ||
        (mode != TENSOR_ONLY && uint64_t(pc) < uint64_t(ps)*h)) return BAD_CAPACITY;
    if (sat > 8192) return BAD_SATURATION;
    if (!rw || !rh || rw > TARGET || rh > TARGET || rw > w || rh > h ||
        px != (TARGET-rw)/2 || py != (TARGET-rh)/2) return BAD_GEOMETRY;
    return OK;
}

static void test(const Request& r) {
    unsigned actual=validate_settings(r[0],r[1],r[2],r[3],r[4],r[5],r[6],
        r[7],r[8],r[9],r[10],r[11],r[12],r[13],r[14]);
    assert(actual == reference(r));
    if (actual != OK) {
        unsigned frame=0, config=0, tensor=1, preview=1, abi=0;
        unsigned status=image_preprocess(nullptr,nullptr,nullptr,nullptr,
            r[0],r[1],r[2],r[3],r[4],r[5],r[6],r[7],r[8],r[9],r[10],
            r[11],r[12],r[13],r[14],77,88,frame,config,tensor,preview,abi);
        assert(status == actual && frame == 77 && config == 88);
        assert(tensor == 0 && preview == 0 && abi == ABI_VERSION);
    }
}

int main() {
    const Request valid={{640,480,1920,921600,TENSOR_BYTES,1920,921600,
                           416,312,0,52,TENSOR_AND_PREVIEW,0,EQ_OFF,4096}};
    const unsigned edges[]={0,1,15,16,415,416,417,1080,1081,1920,1921,
                            5759,5760,5761,8192,8193,921599,921600,0xffffffffu};
    test(valid);
    for (unsigned mode=0; mode<3; ++mode) {
        Request r=valid;r[11]=mode;
        for (unsigned field=0;field<r.size();++field) for (unsigned value:edges) {
            Request changed=r;changed[field]=value;test(changed);
        }
    }
    std::mt19937 rng(613);
    for (unsigned i=0;i<30000;++i) {
        Request r=valid;
        r[0]=416+rng()%(1920-416+1);r[1]=416+rng()%(1080-416+1);
        r[2]=r[5]=(r[0]*3+15)&~15u;r[3]=r[6]=r[2]*r[1];
        r[11]=rng()%3;r[12]=rng()%16;r[13]=rng()%3;r[14]=rng()%8193;
        r[7]=1+rng()%416;r[8]=1+rng()%416;r[9]=(416-r[7])/2;r[10]=(416-r[8])/2;
        if (i%3) r[rng()%r.size()]=rng();
        if (i%5==0) r[rng()%r.size()]=edges[rng()%(sizeof(edges)/sizeof(edges[0]))];
        test(r);
    }
    std::cout << "PASS validation boundaries, randomized requests and error priority\n";
}