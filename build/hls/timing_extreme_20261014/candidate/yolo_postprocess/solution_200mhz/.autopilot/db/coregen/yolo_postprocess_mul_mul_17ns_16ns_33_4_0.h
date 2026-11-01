// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __yolo_postprocess_mul_mul_17ns_16ns_33_4_0__HH__
#define __yolo_postprocess_mul_mul_17ns_16ns_33_4_0__HH__
#include "yolo_postprocess_mul_mul_17ns_16ns_33_4_0_DSP48_1.h"
#include <systemc>

template<
    int ID,
    int NUM_STAGE,
    int din0_WIDTH,
    int din1_WIDTH,
    int dout_WIDTH>
SC_MODULE(yolo_postprocess_mul_mul_17ns_16ns_33_4_0) {
    sc_core::sc_in_clk clk;
    sc_core::sc_in<sc_dt::sc_logic> reset;
    sc_core::sc_in<sc_dt::sc_logic> ce;
    sc_core::sc_in< sc_dt::sc_lv<din0_WIDTH> >   din0;
    sc_core::sc_in< sc_dt::sc_lv<din1_WIDTH> >   din1;
    sc_core::sc_out< sc_dt::sc_lv<dout_WIDTH> >   dout;



    yolo_postprocess_mul_mul_17ns_16ns_33_4_0_DSP48_1 yolo_postprocess_mul_mul_17ns_16ns_33_4_0_DSP48_1_U;

    SC_CTOR(yolo_postprocess_mul_mul_17ns_16ns_33_4_0):  yolo_postprocess_mul_mul_17ns_16ns_33_4_0_DSP48_1_U ("yolo_postprocess_mul_mul_17ns_16ns_33_4_0_DSP48_1_U") {
        yolo_postprocess_mul_mul_17ns_16ns_33_4_0_DSP48_1_U.clk(clk);
        yolo_postprocess_mul_mul_17ns_16ns_33_4_0_DSP48_1_U.rst(reset);
        yolo_postprocess_mul_mul_17ns_16ns_33_4_0_DSP48_1_U.ce(ce);
        yolo_postprocess_mul_mul_17ns_16ns_33_4_0_DSP48_1_U.a(din0);
        yolo_postprocess_mul_mul_17ns_16ns_33_4_0_DSP48_1_U.b(din1);
        yolo_postprocess_mul_mul_17ns_16ns_33_4_0_DSP48_1_U.p(dout);

    }

};

#endif //
