#ifdef NDEBUG
#undef NDEBUG
#endif
#include "yolo_postprocess.h"
#include <algorithm>
#include <cassert>
#include <cmath>
#include <cstring>
#include <fstream>
#include <iostream>
#include <random>
#include <vector>

static const int anchors[3][3][2] = {{{10,13},{16,30},{33,23}},
    {{30,61},{62,45},{59,119}},{{116,90},{156,198},{373,326}}};
static const int fixes[3] = {4,5,6};
static double sigmoid(double v) { return 1/(1+std::exp(-std::max(-30.0,std::min(30.0,v)))); }
struct Ref { double x1,y1,x2,y2,score; unsigned cls,id; };

static std::vector<Ref> reference(const std::vector<signed char>& bytes, bool nms) {
    std::vector<Ref> result;
    unsigned id=0;
    for (unsigned s=0; s<3; ++s) {
        unsigned grid=52>>s, stride=8<<s;
        for (unsigned y=0; y<grid; ++y) for (unsigned x=0; x<grid; ++x)
            for (unsigned a=0; a<3; ++a,++id) {
                auto p=&bytes[id*85];
                unsigned cls=0;
                for(unsigned c=1;c<80;++c) if(p[5+c]>p[5+cls]) cls=c;
                double scale=std::ldexp(1.0,-fixes[s]);
                double score=sigmoid(p[4]*scale)*sigmoid(p[5+cls]*scale);
                if(score<0.3) continue;
                double cx=(x+sigmoid(p[0]*scale))*stride;
                double cy=(y+sigmoid(p[1]*scale))*stride;
                double hw=std::exp(std::max(-10.0,std::min(10.0,p[2]*scale)))*anchors[s][a][0]/2;
                double hh=std::exp(std::max(-10.0,std::min(10.0,p[3]*scale)))*anchors[s][a][1]/2;
                result.push_back({cx-hw,cy-hh,cx+hw,cy+hh,score,cls,id});
            }
    }
    if(!nms) return result;
    std::stable_sort(result.begin(),result.end(),[](const Ref&a,const Ref&b){return a.score>b.score;});
    std::vector<Ref> kept;
    for(auto b:result) {
        bool remove=false;
        for(auto a:kept) if(a.cls==b.cls) {
            double intersection=std::max(0.0,std::min(a.x2,b.x2)-std::max(a.x1,b.x1))*
                std::max(0.0,std::min(a.y2,b.y2)-std::max(a.y1,b.y1));
            double total=(a.x2-a.x1)*(a.y2-a.y1)+(b.x2-b.x1)*(b.y2-b.y1)-intersection+1e-9;
            if(intersection/total>0.6) remove=true;
        }
        if(!remove) kept.push_back(b);
    }
    return kept;
}

int main(int argc,char**argv) {
    bool smoke=argc>1 && std::strcmp(argv[1],"--smoke")==0;
    std::vector<unsigned> lut(ypost::LUT_WORDS);
    for(unsigned s=0;s<3;++s) for(unsigned v=0;v<256;++v) {
        double z=std::ldexp(double(v<128?int(v):int(v)-256),-fixes[s]);
        lut[s*1792+v]=std::nearbyint(sigmoid(z)*32768);
        for(unsigned a=0;a<3;++a) for(unsigned d=0;d<2;++d)
            lut[s*1792+(1+2*a+d)*256+v]=std::nearbyint(std::exp(std::max(-10.0,std::min(10.0,z)))*anchors[s][a][d]*128);
    }
    std::vector<signed char> bytes(ypost::ANCHORS*85,-128);
    std::vector<ap_uint<128>> input(ypost::INPUT_WORDS);
    std::vector<ap_uint<256>> output(257);
    std::mt19937 rng(83);
    for(unsigned test=0;test<(smoke?5u:8u);++test) {
        std::fill(bytes.begin(),bytes.end(),-128);
        unsigned active=test==0?0:test==1?50:test==2?257:test==3?256:test==4?2:100;
        for(unsigned k=0;k<active;++k) {
            unsigned id=test==4?k*3:(k*41)%ypost::ANCHORS;
            auto p=&bytes[id*85];
            for(unsigned c=0;c<4;++c) p[c]=int(rng()%65)-32;
            p[4]=48+int(rng()%70);
            p[5+k%7]=40+int(rng()%80);
            if(test==4) {p[0]=p[1]=0;p[2]=p[3]=50;p[4]=60;p[5]=60;p[6]=-128;}
        }
        std::fill(input.begin(),input.end(),0);
        for(unsigned i=0;i<bytes.size();++i) input[i/16].range(i%16*8+7,i%16*8)=static_cast<unsigned char>(bytes[i]);
        std::fill(output.begin(),output.end(),ap_uint<256>(0xdeadbeef));
        unsigned candidates=999, detections=999;
        bool nms=test!=3 && test!=6;
        unsigned status=yolo_postprocess(input.data(),lut.data(),output.data(),ypost::INPUT_WORDS,
            ypost::LUT_WORDS,256,unsigned(std::nearbyint(0.3*(1u<<30))),39322,nms,candidates,detections);
        assert(output[256]==0xdeadbeef);
        auto all=reference(bytes,false);
        if(all.size()>256) { assert(status==ypost::OVERFLOW && detections==0 && output[0]==0xdeadbeef); }
        else {
            auto expected=reference(bytes,nms);
            assert(status==ypost::OK && candidates==all.size() && detections==expected.size());
            for(unsigned i=0;i<detections;++i) {
                auto w=output[i];
                unsigned id=w.range(223,192).to_uint();
                auto found=std::find_if(expected.begin(),expected.end(),[id](const Ref&b){return b.id==id;});
                assert(found!=expected.end());
                assert(w.range(191,160).to_uint()==found->cls);
                assert(std::abs(w.range(159,128).to_uint()/double(1u<<30)-found->score)<0.00004);
                double coords[4]={found->x1,found->y1,found->x2,found->y2};
                for(unsigned j=0;j<4;++j) {
                    ap_int<32> v=w.range(j*32+31,j*32);
                    assert(std::abs(v.to_int()/256.0-coords[j])<0.007);
                }
                expected.erase(found);
            }
            if(test==4) assert(detections==1);
        }
        if(test==1) {
            std::ofstream raw("fixture_input.bin",std::ios::binary);
            raw.write(reinterpret_cast<const char*>(bytes.data()),bytes.size());
            std::ofstream out("fixture_output.bin",std::ios::binary);
            for(unsigned i=0;i<detections;++i) for(unsigned j=0;j<32;++j) {
                unsigned char v=output[i].range(j*8+7,j*8).to_uint(); out.write(reinterpret_cast<char*>(&v),1);
            }
            std::ofstream tables("fixture_tables.bin",std::ios::binary);
            tables.write(reinterpret_cast<const char*>(lut.data()),lut.size()*4);
        }
        std::cout<<"case "<<test<<" status="<<status<<" candidates="<<candidates<<" detections="<<detections<<std::endl;
    }
    if(!smoke) {
        unsigned c=9,d=9;
        assert(yolo_postprocess(nullptr,nullptr,nullptr,0,0,0,0,0,0,c,d)==ypost::INVALID && c==0 && d==0);
        for(unsigned field=0;field<5;++field) {
            unsigned status=yolo_postprocess(nullptr,nullptr,nullptr,ypost::INPUT_WORDS,
                field==0?0:ypost::LUT_WORDS,field==1?0:256,field==2?0:1,
                field==3?65537:0,field==4?2:0,c,d);
            assert(status==ypost::INVALID && c==0 && d==0);
        }
    }
    std::cout<<"PASS independent floating reference and guards"<<std::endl;
}