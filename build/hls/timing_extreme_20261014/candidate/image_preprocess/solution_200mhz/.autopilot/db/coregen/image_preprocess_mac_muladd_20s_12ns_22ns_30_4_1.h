// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1__HH__
#define __image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1__HH__
#include "image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1_DSP48_11.h"
#include <systemc>

template<
    int ID,
    int NUM_STAGE,
    int din0_WIDTH,
    int din1_WIDTH,
    int din2_WIDTH,
    int dout_WIDTH>
SC_MODULE(image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1) {
    sc_core::sc_in_clk clk;
    sc_core::sc_in<sc_dt::sc_logic> reset;
    sc_core::sc_in<sc_dt::sc_logic> ce;
    sc_core::sc_in< sc_dt::sc_lv<din0_WIDTH> >   din0;
    sc_core::sc_in< sc_dt::sc_lv<din1_WIDTH> >   din1;
    sc_core::sc_in< sc_dt::sc_lv<din2_WIDTH> >   din2;
    sc_core::sc_out< sc_dt::sc_lv<dout_WIDTH> >   dout;



    image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1_DSP48_11 image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1_DSP48_11_U;

    SC_CTOR(image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1):  image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1_DSP48_11_U ("image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1_DSP48_11_U") {
        image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1_DSP48_11_U.clk(clk);
        image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1_DSP48_11_U.rst(reset);
        image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1_DSP48_11_U.ce(ce);
        image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1_DSP48_11_U.in0(din0);
        image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1_DSP48_11_U.in1(din1);
        image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1_DSP48_11_U.in2(din2);
        image_preprocess_mac_muladd_20s_12ns_22ns_30_4_1_DSP48_11_U.dout(dout);

    }

};

#endif //
