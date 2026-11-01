#include <systemc>
#include <iostream>
#include <cstdlib>
#include <cstddef>
#include <stdint.h>
#include "SysCFileHandler.h"
#include "ap_int.h"
#include "ap_fixed.h"
#include <complex>
#include <stdbool.h>
#include "autopilot_cbe.h"
#include "hls_stream.h"
#include "hls_half.h"
#include "hls_signal_handler.h"

using namespace std;
using namespace sc_core;
using namespace sc_dt;

// wrapc file define:
#define AUTOTB_TVIN_src "../tv/cdatafile/c.image_preprocess.autotvin_src.dat"
#define AUTOTB_TVOUT_src "../tv/cdatafile/c.image_preprocess.autotvout_src.dat"
#define AUTOTB_TVIN_tensor "../tv/cdatafile/c.image_preprocess.autotvin_tensor.dat"
#define AUTOTB_TVOUT_tensor "../tv/cdatafile/c.image_preprocess.autotvout_tensor.dat"
#define AUTOTB_TVIN_preview "../tv/cdatafile/c.image_preprocess.autotvin_preview.dat"
#define AUTOTB_TVOUT_preview "../tv/cdatafile/c.image_preprocess.autotvout_preview.dat"
#define AUTOTB_TVIN_luts "../tv/cdatafile/c.image_preprocess.autotvin_luts.dat"
#define AUTOTB_TVOUT_luts "../tv/cdatafile/c.image_preprocess.autotvout_luts.dat"
#define AUTOTB_TVIN_width "../tv/cdatafile/c.image_preprocess.autotvin_width.dat"
#define AUTOTB_TVOUT_width "../tv/cdatafile/c.image_preprocess.autotvout_width.dat"
#define AUTOTB_TVIN_height "../tv/cdatafile/c.image_preprocess.autotvin_height.dat"
#define AUTOTB_TVOUT_height "../tv/cdatafile/c.image_preprocess.autotvout_height.dat"
#define AUTOTB_TVIN_src_stride "../tv/cdatafile/c.image_preprocess.autotvin_src_stride.dat"
#define AUTOTB_TVOUT_src_stride "../tv/cdatafile/c.image_preprocess.autotvout_src_stride.dat"
#define AUTOTB_TVIN_src_capacity "../tv/cdatafile/c.image_preprocess.autotvin_src_capacity.dat"
#define AUTOTB_TVOUT_src_capacity "../tv/cdatafile/c.image_preprocess.autotvout_src_capacity.dat"
#define AUTOTB_TVIN_tensor_capacity "../tv/cdatafile/c.image_preprocess.autotvin_tensor_capacity.dat"
#define AUTOTB_TVOUT_tensor_capacity "../tv/cdatafile/c.image_preprocess.autotvout_tensor_capacity.dat"
#define AUTOTB_TVIN_preview_stride "../tv/cdatafile/c.image_preprocess.autotvin_preview_stride.dat"
#define AUTOTB_TVOUT_preview_stride "../tv/cdatafile/c.image_preprocess.autotvout_preview_stride.dat"
#define AUTOTB_TVIN_preview_capacity "../tv/cdatafile/c.image_preprocess.autotvin_preview_capacity.dat"
#define AUTOTB_TVOUT_preview_capacity "../tv/cdatafile/c.image_preprocess.autotvout_preview_capacity.dat"
#define AUTOTB_TVIN_resized_w "../tv/cdatafile/c.image_preprocess.autotvin_resized_w.dat"
#define AUTOTB_TVOUT_resized_w "../tv/cdatafile/c.image_preprocess.autotvout_resized_w.dat"
#define AUTOTB_TVIN_resized_h "../tv/cdatafile/c.image_preprocess.autotvin_resized_h.dat"
#define AUTOTB_TVOUT_resized_h "../tv/cdatafile/c.image_preprocess.autotvout_resized_h.dat"
#define AUTOTB_TVIN_pad_x "../tv/cdatafile/c.image_preprocess.autotvin_pad_x.dat"
#define AUTOTB_TVOUT_pad_x "../tv/cdatafile/c.image_preprocess.autotvout_pad_x.dat"
#define AUTOTB_TVIN_pad_y "../tv/cdatafile/c.image_preprocess.autotvin_pad_y.dat"
#define AUTOTB_TVOUT_pad_y "../tv/cdatafile/c.image_preprocess.autotvout_pad_y.dat"
#define AUTOTB_TVIN_output_mode "../tv/cdatafile/c.image_preprocess.autotvin_output_mode.dat"
#define AUTOTB_TVOUT_output_mode "../tv/cdatafile/c.image_preprocess.autotvout_output_mode.dat"
#define AUTOTB_TVIN_flags "../tv/cdatafile/c.image_preprocess.autotvin_flags.dat"
#define AUTOTB_TVOUT_flags "../tv/cdatafile/c.image_preprocess.autotvout_flags.dat"
#define AUTOTB_TVIN_eq_mode "../tv/cdatafile/c.image_preprocess.autotvin_eq_mode.dat"
#define AUTOTB_TVOUT_eq_mode "../tv/cdatafile/c.image_preprocess.autotvout_eq_mode.dat"
#define AUTOTB_TVIN_saturation_q12 "../tv/cdatafile/c.image_preprocess.autotvin_saturation_q12.dat"
#define AUTOTB_TVOUT_saturation_q12 "../tv/cdatafile/c.image_preprocess.autotvout_saturation_q12.dat"
#define AUTOTB_TVIN_frame_id "../tv/cdatafile/c.image_preprocess.autotvin_frame_id.dat"
#define AUTOTB_TVOUT_frame_id "../tv/cdatafile/c.image_preprocess.autotvout_frame_id.dat"
#define AUTOTB_TVIN_config_id "../tv/cdatafile/c.image_preprocess.autotvin_config_id.dat"
#define AUTOTB_TVOUT_config_id "../tv/cdatafile/c.image_preprocess.autotvout_config_id.dat"
#define AUTOTB_TVIN_completed_frame_id "../tv/cdatafile/c.image_preprocess.autotvin_completed_frame_id.dat"
#define AUTOTB_TVOUT_completed_frame_id "../tv/cdatafile/c.image_preprocess.autotvout_completed_frame_id.dat"
#define AUTOTB_TVIN_completed_config_id "../tv/cdatafile/c.image_preprocess.autotvin_completed_config_id.dat"
#define AUTOTB_TVOUT_completed_config_id "../tv/cdatafile/c.image_preprocess.autotvout_completed_config_id.dat"
#define AUTOTB_TVIN_tensor_bytes "../tv/cdatafile/c.image_preprocess.autotvin_tensor_bytes.dat"
#define AUTOTB_TVOUT_tensor_bytes "../tv/cdatafile/c.image_preprocess.autotvout_tensor_bytes.dat"
#define AUTOTB_TVIN_preview_bytes "../tv/cdatafile/c.image_preprocess.autotvin_preview_bytes.dat"
#define AUTOTB_TVOUT_preview_bytes "../tv/cdatafile/c.image_preprocess.autotvout_preview_bytes.dat"
#define AUTOTB_TVIN_abi_version "../tv/cdatafile/c.image_preprocess.autotvin_abi_version.dat"
#define AUTOTB_TVOUT_abi_version "../tv/cdatafile/c.image_preprocess.autotvout_abi_version.dat"
#define AUTOTB_TVIN_gmem_in "../tv/cdatafile/c.image_preprocess.autotvin_gmem_in.dat"
#define AUTOTB_TVOUT_gmem_in "../tv/cdatafile/c.image_preprocess.autotvout_gmem_in.dat"
#define AUTOTB_TVIN_gmem_out "../tv/cdatafile/c.image_preprocess.autotvin_gmem_out.dat"
#define AUTOTB_TVOUT_gmem_out "../tv/cdatafile/c.image_preprocess.autotvout_gmem_out.dat"
#define AUTOTB_TVIN_gmem_preview "../tv/cdatafile/c.image_preprocess.autotvin_gmem_preview.dat"
#define AUTOTB_TVOUT_gmem_preview "../tv/cdatafile/c.image_preprocess.autotvout_gmem_preview.dat"
#define AUTOTB_TVOUT_return "../tv/cdatafile/c.image_preprocess.autotvout_ap_return.dat"

#define INTER_TCL "../tv/cdatafile/ref.tcl"

// tvout file define:
#define AUTOTB_TVOUT_PC_src "../tv/rtldatafile/rtl.image_preprocess.autotvout_src.dat"
#define AUTOTB_TVOUT_PC_tensor "../tv/rtldatafile/rtl.image_preprocess.autotvout_tensor.dat"
#define AUTOTB_TVOUT_PC_preview "../tv/rtldatafile/rtl.image_preprocess.autotvout_preview.dat"
#define AUTOTB_TVOUT_PC_luts "../tv/rtldatafile/rtl.image_preprocess.autotvout_luts.dat"
#define AUTOTB_TVOUT_PC_width "../tv/rtldatafile/rtl.image_preprocess.autotvout_width.dat"
#define AUTOTB_TVOUT_PC_height "../tv/rtldatafile/rtl.image_preprocess.autotvout_height.dat"
#define AUTOTB_TVOUT_PC_src_stride "../tv/rtldatafile/rtl.image_preprocess.autotvout_src_stride.dat"
#define AUTOTB_TVOUT_PC_src_capacity "../tv/rtldatafile/rtl.image_preprocess.autotvout_src_capacity.dat"
#define AUTOTB_TVOUT_PC_tensor_capacity "../tv/rtldatafile/rtl.image_preprocess.autotvout_tensor_capacity.dat"
#define AUTOTB_TVOUT_PC_preview_stride "../tv/rtldatafile/rtl.image_preprocess.autotvout_preview_stride.dat"
#define AUTOTB_TVOUT_PC_preview_capacity "../tv/rtldatafile/rtl.image_preprocess.autotvout_preview_capacity.dat"
#define AUTOTB_TVOUT_PC_resized_w "../tv/rtldatafile/rtl.image_preprocess.autotvout_resized_w.dat"
#define AUTOTB_TVOUT_PC_resized_h "../tv/rtldatafile/rtl.image_preprocess.autotvout_resized_h.dat"
#define AUTOTB_TVOUT_PC_pad_x "../tv/rtldatafile/rtl.image_preprocess.autotvout_pad_x.dat"
#define AUTOTB_TVOUT_PC_pad_y "../tv/rtldatafile/rtl.image_preprocess.autotvout_pad_y.dat"
#define AUTOTB_TVOUT_PC_output_mode "../tv/rtldatafile/rtl.image_preprocess.autotvout_output_mode.dat"
#define AUTOTB_TVOUT_PC_flags "../tv/rtldatafile/rtl.image_preprocess.autotvout_flags.dat"
#define AUTOTB_TVOUT_PC_eq_mode "../tv/rtldatafile/rtl.image_preprocess.autotvout_eq_mode.dat"
#define AUTOTB_TVOUT_PC_saturation_q12 "../tv/rtldatafile/rtl.image_preprocess.autotvout_saturation_q12.dat"
#define AUTOTB_TVOUT_PC_frame_id "../tv/rtldatafile/rtl.image_preprocess.autotvout_frame_id.dat"
#define AUTOTB_TVOUT_PC_config_id "../tv/rtldatafile/rtl.image_preprocess.autotvout_config_id.dat"
#define AUTOTB_TVOUT_PC_completed_frame_id "../tv/rtldatafile/rtl.image_preprocess.autotvout_completed_frame_id.dat"
#define AUTOTB_TVOUT_PC_completed_config_id "../tv/rtldatafile/rtl.image_preprocess.autotvout_completed_config_id.dat"
#define AUTOTB_TVOUT_PC_tensor_bytes "../tv/rtldatafile/rtl.image_preprocess.autotvout_tensor_bytes.dat"
#define AUTOTB_TVOUT_PC_preview_bytes "../tv/rtldatafile/rtl.image_preprocess.autotvout_preview_bytes.dat"
#define AUTOTB_TVOUT_PC_abi_version "../tv/rtldatafile/rtl.image_preprocess.autotvout_abi_version.dat"
#define AUTOTB_TVOUT_PC_gmem_in "../tv/rtldatafile/rtl.image_preprocess.autotvout_gmem_in.dat"
#define AUTOTB_TVOUT_PC_gmem_out "../tv/rtldatafile/rtl.image_preprocess.autotvout_gmem_out.dat"
#define AUTOTB_TVOUT_PC_gmem_preview "../tv/rtldatafile/rtl.image_preprocess.autotvout_gmem_preview.dat"
#define AUTOTB_TVOUT_PC_return "../tv/rtldatafile/rtl.image_preprocess.autotvout_ap_return.dat"


static const bool little_endian()
{
  int a = 1;
  return *(char*)&a == 1;
}

inline static void rev_endian(char* p, size_t nbytes)
{
  std::reverse(p, p+nbytes);
}

template<size_t bit_width>
struct transaction {
  typedef uint64_t depth_t;
  static const size_t wbytes = (bit_width+7)>>3;
  static const size_t dbytes = sizeof(depth_t);
  const depth_t depth;
  const size_t vbytes;
  const size_t tbytes;
  char * const p;
  typedef char (*p_dat)[wbytes];
  p_dat vp;

  transaction(depth_t depth)
    : depth(depth), vbytes(wbytes*depth), tbytes(dbytes+vbytes),
      p(new char[tbytes]) {
    *(depth_t*)p = depth;
    rev_endian(p, dbytes);
    vp = (p_dat) (p+dbytes);
  }

  void reorder() {
    rev_endian(p, dbytes);
    p_dat vp = (p_dat) (p+dbytes);
    for (depth_t i = 0; i < depth; ++i) {
      rev_endian(vp[i], wbytes);
    }
  }

  template<size_t psize>
  void import(char* param, depth_t num, int64_t offset) {
    param -= offset*psize;
    for (depth_t i = 0; i < num; ++i) {
      memcpy(vp[i], param, wbytes);
      param += psize;
      if (little_endian()) {
        rev_endian(vp[i], wbytes);
      }
    }
    vp += num;
  }

  template<size_t psize>
  void send(char* param, depth_t num) {
    for (depth_t i = 0; i < num; ++i) {
      memcpy(param, vp[i], wbytes);
      param += psize;
    }
    vp += num;
  }

  template<size_t psize>
  void send(char* param, depth_t num, int64_t skip) {
    for (depth_t i = 0; i < num; ++i) {
      memcpy(param, vp[skip+i], wbytes);
      param += psize;
    }
  }

  ~transaction() { if (p) { delete[] p; } }
};


inline static const std::string begin_str(int num)
{
  return std::string("[[transaction]]           ")
         .append(std::to_string(num))
         .append("\n");
}

inline static const std::string end_str()
{
  return std::string("[[/transaction]]\n");
}

const std::string formatData(unsigned char *pos, size_t wbits)
{
  bool LE = little_endian();
  size_t wbytes = (wbits+7)>>3;
  size_t i = LE ? wbytes-1 : 0;
  auto next = [&] () {
    auto c = pos[i];
    LE ? --i : ++i;
    return c;
  };
  std::ostringstream ss;
  ss << "0x";
  if (int t = (wbits & 0x7)) {
    if (t <= 4) {
      unsigned char mask = (1<<t)-1;
      ss << std::hex << std::setfill('0') << std::setw(1)
         << (int) (next() & mask);
      wbytes -= 1;
    }
  }
  for (size_t i = 0; i < wbytes; ++i) {
    ss << std::hex << std::setfill('0') << std::setw(2) << (int)next();
  }
  ss.put('\n');
  return ss.str();
}

static bool RTLOutputCheckAndReplacement(std::string &data)
{
  bool changed = false;
  for (size_t i = 2; i < data.size(); ++i) {
    if (data[i] == 'X' || data[i] == 'x') {
      data[i] = '0';
      changed = true;
    }
  }
  return changed;
}

struct SimException : public std::exception {
  const char *msg;
  const size_t line;
  SimException(const char *msg, const size_t line)
    : msg(msg), line(line)
  {
  }
};

template<size_t bit_width>
class PostCheck
{
  static const char *bad;
  static const char *err;
  std::fstream stream;
  std::string s;

  void send(char *p, ap_uint<bit_width> &data, size_t l, size_t rest)
  {
    if (rest == 0) {
      if (!little_endian()) {
        const size_t wbytes = (bit_width+7)>>3;
        rev_endian(p-wbytes, wbytes);
      }
    } else if (rest < 8) {
      *p = data.range(l+rest-1, l).to_uint();
      send(p+1, data, l+rest, 0);
    } else {
      *p = data.range(l+8-1, l).to_uint();
      send(p+1, data, l+8, rest-8);
    }
  }

  void readline()
  {
    std::getline(stream, s);
    if (stream.eof()) {
      throw SimException(bad, __LINE__);
    }
  }

public:
  char *param;
  size_t psize;
  size_t depth;

  PostCheck(const char *file)
  {
    stream.open(file);
    if (stream.fail()) {
      throw SimException(err, __LINE__);
    } else {
      readline();
      if (s != "[[[runtime]]]") {
        throw SimException(bad, __LINE__);
      }
    }
  }

  ~PostCheck() noexcept(false)
  {
    stream.close();
  }

  void run(size_t AESL_transaction_pc, size_t skip)
  {
    if (stream.peek() == '[') {
      readline();
    }

    for (size_t i = 0; i < skip; ++i) {
      readline();
    }

    bool foundX = false;
    for (size_t i = 0; i < depth; ++i) {
      readline();
      foundX |= RTLOutputCheckAndReplacement(s);
      ap_uint<bit_width> data(s.c_str(), 16);
      send(param+i*psize, data, 0, bit_width);
    }
    if (foundX) {
      std::cerr << "WARNING: [SIM 212-201] RTL produces unknown value "
                << "'x' or 'X' on some port, possible cause: "
                << "There are uninitialized variables in the design.\n";
    }

    if (stream.peek() == '[') {
      readline();
    }
  }
};

template<size_t bit_width>
const char* PostCheck<bit_width>::bad = "Bad TV file";

template<size_t bit_width>
const char* PostCheck<bit_width>::err = "Error on TV file";
      
class INTER_TCL_FILE {
  public:
INTER_TCL_FILE(const char* name) {
  mName = name; 
  src_depth = 0;
  tensor_depth = 0;
  preview_depth = 0;
  luts_depth = 0;
  width_depth = 0;
  height_depth = 0;
  src_stride_depth = 0;
  src_capacity_depth = 0;
  tensor_capacity_depth = 0;
  preview_stride_depth = 0;
  preview_capacity_depth = 0;
  resized_w_depth = 0;
  resized_h_depth = 0;
  pad_x_depth = 0;
  pad_y_depth = 0;
  output_mode_depth = 0;
  flags_depth = 0;
  eq_mode_depth = 0;
  saturation_q12_depth = 0;
  frame_id_depth = 0;
  config_id_depth = 0;
  completed_frame_id_depth = 0;
  completed_config_id_depth = 0;
  tensor_bytes_depth = 0;
  preview_bytes_depth = 0;
  abi_version_depth = 0;
  gmem_in_depth = 0;
  gmem_out_depth = 0;
  gmem_preview_depth = 0;
  return_depth = 0;
  trans_num =0;
}
~INTER_TCL_FILE() {
  mFile.open(mName);
  if (!mFile.good()) {
    cout << "Failed to open file ref.tcl" << endl;
    exit (1); 
  }
  string total_list = get_depth_list();
  mFile << "set depth_list {\n";
  mFile << total_list;
  mFile << "}\n";
  mFile << "set trans_num "<<trans_num<<endl;
  mFile.close();
}
string get_depth_list () {
  stringstream total_list;
  total_list << "{src " << src_depth << "}\n";
  total_list << "{tensor " << tensor_depth << "}\n";
  total_list << "{preview " << preview_depth << "}\n";
  total_list << "{luts " << luts_depth << "}\n";
  total_list << "{width " << width_depth << "}\n";
  total_list << "{height " << height_depth << "}\n";
  total_list << "{src_stride " << src_stride_depth << "}\n";
  total_list << "{src_capacity " << src_capacity_depth << "}\n";
  total_list << "{tensor_capacity " << tensor_capacity_depth << "}\n";
  total_list << "{preview_stride " << preview_stride_depth << "}\n";
  total_list << "{preview_capacity " << preview_capacity_depth << "}\n";
  total_list << "{resized_w " << resized_w_depth << "}\n";
  total_list << "{resized_h " << resized_h_depth << "}\n";
  total_list << "{pad_x " << pad_x_depth << "}\n";
  total_list << "{pad_y " << pad_y_depth << "}\n";
  total_list << "{output_mode " << output_mode_depth << "}\n";
  total_list << "{flags " << flags_depth << "}\n";
  total_list << "{eq_mode " << eq_mode_depth << "}\n";
  total_list << "{saturation_q12 " << saturation_q12_depth << "}\n";
  total_list << "{frame_id " << frame_id_depth << "}\n";
  total_list << "{config_id " << config_id_depth << "}\n";
  total_list << "{completed_frame_id " << completed_frame_id_depth << "}\n";
  total_list << "{completed_config_id " << completed_config_id_depth << "}\n";
  total_list << "{tensor_bytes " << tensor_bytes_depth << "}\n";
  total_list << "{preview_bytes " << preview_bytes_depth << "}\n";
  total_list << "{abi_version " << abi_version_depth << "}\n";
  total_list << "{gmem_in " << gmem_in_depth << "}\n";
  total_list << "{gmem_out " << gmem_out_depth << "}\n";
  total_list << "{gmem_preview " << gmem_preview_depth << "}\n";
  total_list << "{ap_return " << return_depth << "}\n";
  return total_list.str();
}
void set_num (int num , int* class_num) {
  (*class_num) = (*class_num) > num ? (*class_num) : num;
}
void set_string(std::string list, std::string* class_list) {
  (*class_list) = list;
}
  public:
    int src_depth;
    int tensor_depth;
    int preview_depth;
    int luts_depth;
    int width_depth;
    int height_depth;
    int src_stride_depth;
    int src_capacity_depth;
    int tensor_capacity_depth;
    int preview_stride_depth;
    int preview_capacity_depth;
    int resized_w_depth;
    int resized_h_depth;
    int pad_x_depth;
    int pad_y_depth;
    int output_mode_depth;
    int flags_depth;
    int eq_mode_depth;
    int saturation_q12_depth;
    int frame_id_depth;
    int config_id_depth;
    int completed_frame_id_depth;
    int completed_config_id_depth;
    int tensor_bytes_depth;
    int preview_bytes_depth;
    int abi_version_depth;
    int gmem_in_depth;
    int gmem_out_depth;
    int gmem_preview_depth;
    int return_depth;
    int trans_num;
  private:
    ofstream mFile;
    const char* mName;
};


struct __cosim_s16__ { char data[16]; };
extern "C" int image_preprocess_hw_stub_wrapper(volatile void *, volatile void *, volatile void *, volatile void *, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, volatile void *, volatile void *, volatile void *, volatile void *, volatile void *);

extern "C" int apatb_image_preprocess_hw(volatile void * __xlx_apatb_param_src, volatile void * __xlx_apatb_param_tensor, volatile void * __xlx_apatb_param_preview, volatile void * __xlx_apatb_param_luts, int __xlx_apatb_param_width, int __xlx_apatb_param_height, int __xlx_apatb_param_src_stride, int __xlx_apatb_param_src_capacity, int __xlx_apatb_param_tensor_capacity, int __xlx_apatb_param_preview_stride, int __xlx_apatb_param_preview_capacity, int __xlx_apatb_param_resized_w, int __xlx_apatb_param_resized_h, int __xlx_apatb_param_pad_x, int __xlx_apatb_param_pad_y, int __xlx_apatb_param_output_mode, int __xlx_apatb_param_flags, int __xlx_apatb_param_eq_mode, int __xlx_apatb_param_saturation_q12, int __xlx_apatb_param_frame_id, int __xlx_apatb_param_config_id, volatile void * __xlx_apatb_param_completed_frame_id, volatile void * __xlx_apatb_param_completed_config_id, volatile void * __xlx_apatb_param_tensor_bytes, volatile void * __xlx_apatb_param_preview_bytes, volatile void * __xlx_apatb_param_abi_version) {
  refine_signal_handler();
  fstream wrapc_switch_file_token;
  wrapc_switch_file_token.open(".hls_cosim_wrapc_switch.log");
static AESL_FILE_HANDLER aesl_fh;
  int AESL_i;
  if (wrapc_switch_file_token.good())
  {

    CodeState = ENTER_WRAPC_PC;
    static unsigned AESL_transaction_pc = 0;
    string AESL_token;
    string AESL_num;

    int AESL_return;
    {
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_return);
        if (rtl_tv_out_file.good()) {
          rtl_tv_out_file >> AESL_token;
          if (AESL_token != "[[[runtime]]]")
            exit(1);
        }
      }
  
      if (rtl_tv_out_file.good()) {
        rtl_tv_out_file >> AESL_token; 
        rtl_tv_out_file >> AESL_num;  // transaction number
        if (AESL_token != "[[transaction]]") {
          cerr << "Unexpected token: " << AESL_token << endl;
          exit(1);
        }
        if (atoi(AESL_num.c_str()) == AESL_transaction_pc) {
          std::vector<sc_bv<32> > return_pc_buffer(1);
          int i = 0;
          bool has_unknown_value = false;
          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            has_unknown_value |= RTLOutputCheckAndReplacement(AESL_token);
  
            // push token into output port buffer
            if (AESL_token != "") {
              return_pc_buffer[i] = AESL_token.c_str();;
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (has_unknown_value) {
            cerr << "WARNING: [SIM 212-201] RTL produces unknown value 'x' or 'X' on port " 
                 << "return" << ", possible cause: There are uninitialized variables in the C design."
                 << endl; 
          }
  
          if (i > 0) {((char*)&AESL_return)[0*4+0] = return_pc_buffer[0].range(7, 0).to_int64();
((char*)&AESL_return)[0*4+1] = return_pc_buffer[0].range(15, 8).to_int64();
((char*)&AESL_return)[0*4+2] = return_pc_buffer[0].range(23, 16).to_int64();
((char*)&AESL_return)[0*4+3] = return_pc_buffer[0].range(31, 24).to_int64();
}
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  {
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_completed_frame_id);
        if (rtl_tv_out_file.good()) {
          rtl_tv_out_file >> AESL_token;
          if (AESL_token != "[[[runtime]]]")
            exit(1);
        }
      }
  
      if (rtl_tv_out_file.good()) {
        rtl_tv_out_file >> AESL_token; 
        rtl_tv_out_file >> AESL_num;  // transaction number
        if (AESL_token != "[[transaction]]") {
          cerr << "Unexpected token: " << AESL_token << endl;
          exit(1);
        }
        if (atoi(AESL_num.c_str()) == AESL_transaction_pc) {
          std::vector<sc_bv<32> > completed_frame_id_pc_buffer(1);
          int i = 0;
          bool has_unknown_value = false;
          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            has_unknown_value |= RTLOutputCheckAndReplacement(AESL_token);
  
            // push token into output port buffer
            if (AESL_token != "") {
              completed_frame_id_pc_buffer[i] = AESL_token.c_str();;
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (has_unknown_value) {
            cerr << "WARNING: [SIM 212-201] RTL produces unknown value 'x' or 'X' on port " 
                 << "completed_frame_id" << ", possible cause: There are uninitialized variables in the C design."
                 << endl; 
          }
  
          if (i > 0) {((char*)__xlx_apatb_param_completed_frame_id)[0*4+0] = completed_frame_id_pc_buffer[0].range(7, 0).to_int64();
((char*)__xlx_apatb_param_completed_frame_id)[0*4+1] = completed_frame_id_pc_buffer[0].range(15, 8).to_int64();
((char*)__xlx_apatb_param_completed_frame_id)[0*4+2] = completed_frame_id_pc_buffer[0].range(23, 16).to_int64();
((char*)__xlx_apatb_param_completed_frame_id)[0*4+3] = completed_frame_id_pc_buffer[0].range(31, 24).to_int64();
}
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  {
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_completed_config_id);
        if (rtl_tv_out_file.good()) {
          rtl_tv_out_file >> AESL_token;
          if (AESL_token != "[[[runtime]]]")
            exit(1);
        }
      }
  
      if (rtl_tv_out_file.good()) {
        rtl_tv_out_file >> AESL_token; 
        rtl_tv_out_file >> AESL_num;  // transaction number
        if (AESL_token != "[[transaction]]") {
          cerr << "Unexpected token: " << AESL_token << endl;
          exit(1);
        }
        if (atoi(AESL_num.c_str()) == AESL_transaction_pc) {
          std::vector<sc_bv<32> > completed_config_id_pc_buffer(1);
          int i = 0;
          bool has_unknown_value = false;
          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            has_unknown_value |= RTLOutputCheckAndReplacement(AESL_token);
  
            // push token into output port buffer
            if (AESL_token != "") {
              completed_config_id_pc_buffer[i] = AESL_token.c_str();;
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (has_unknown_value) {
            cerr << "WARNING: [SIM 212-201] RTL produces unknown value 'x' or 'X' on port " 
                 << "completed_config_id" << ", possible cause: There are uninitialized variables in the C design."
                 << endl; 
          }
  
          if (i > 0) {((char*)__xlx_apatb_param_completed_config_id)[0*4+0] = completed_config_id_pc_buffer[0].range(7, 0).to_int64();
((char*)__xlx_apatb_param_completed_config_id)[0*4+1] = completed_config_id_pc_buffer[0].range(15, 8).to_int64();
((char*)__xlx_apatb_param_completed_config_id)[0*4+2] = completed_config_id_pc_buffer[0].range(23, 16).to_int64();
((char*)__xlx_apatb_param_completed_config_id)[0*4+3] = completed_config_id_pc_buffer[0].range(31, 24).to_int64();
}
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  {
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_tensor_bytes);
        if (rtl_tv_out_file.good()) {
          rtl_tv_out_file >> AESL_token;
          if (AESL_token != "[[[runtime]]]")
            exit(1);
        }
      }
  
      if (rtl_tv_out_file.good()) {
        rtl_tv_out_file >> AESL_token; 
        rtl_tv_out_file >> AESL_num;  // transaction number
        if (AESL_token != "[[transaction]]") {
          cerr << "Unexpected token: " << AESL_token << endl;
          exit(1);
        }
        if (atoi(AESL_num.c_str()) == AESL_transaction_pc) {
          std::vector<sc_bv<32> > tensor_bytes_pc_buffer(1);
          int i = 0;
          bool has_unknown_value = false;
          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            has_unknown_value |= RTLOutputCheckAndReplacement(AESL_token);
  
            // push token into output port buffer
            if (AESL_token != "") {
              tensor_bytes_pc_buffer[i] = AESL_token.c_str();;
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (has_unknown_value) {
            cerr << "WARNING: [SIM 212-201] RTL produces unknown value 'x' or 'X' on port " 
                 << "tensor_bytes" << ", possible cause: There are uninitialized variables in the C design."
                 << endl; 
          }
  
          if (i > 0) {((char*)__xlx_apatb_param_tensor_bytes)[0*4+0] = tensor_bytes_pc_buffer[0].range(7, 0).to_int64();
((char*)__xlx_apatb_param_tensor_bytes)[0*4+1] = tensor_bytes_pc_buffer[0].range(15, 8).to_int64();
((char*)__xlx_apatb_param_tensor_bytes)[0*4+2] = tensor_bytes_pc_buffer[0].range(23, 16).to_int64();
((char*)__xlx_apatb_param_tensor_bytes)[0*4+3] = tensor_bytes_pc_buffer[0].range(31, 24).to_int64();
}
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  {
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_preview_bytes);
        if (rtl_tv_out_file.good()) {
          rtl_tv_out_file >> AESL_token;
          if (AESL_token != "[[[runtime]]]")
            exit(1);
        }
      }
  
      if (rtl_tv_out_file.good()) {
        rtl_tv_out_file >> AESL_token; 
        rtl_tv_out_file >> AESL_num;  // transaction number
        if (AESL_token != "[[transaction]]") {
          cerr << "Unexpected token: " << AESL_token << endl;
          exit(1);
        }
        if (atoi(AESL_num.c_str()) == AESL_transaction_pc) {
          std::vector<sc_bv<32> > preview_bytes_pc_buffer(1);
          int i = 0;
          bool has_unknown_value = false;
          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            has_unknown_value |= RTLOutputCheckAndReplacement(AESL_token);
  
            // push token into output port buffer
            if (AESL_token != "") {
              preview_bytes_pc_buffer[i] = AESL_token.c_str();;
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (has_unknown_value) {
            cerr << "WARNING: [SIM 212-201] RTL produces unknown value 'x' or 'X' on port " 
                 << "preview_bytes" << ", possible cause: There are uninitialized variables in the C design."
                 << endl; 
          }
  
          if (i > 0) {((char*)__xlx_apatb_param_preview_bytes)[0*4+0] = preview_bytes_pc_buffer[0].range(7, 0).to_int64();
((char*)__xlx_apatb_param_preview_bytes)[0*4+1] = preview_bytes_pc_buffer[0].range(15, 8).to_int64();
((char*)__xlx_apatb_param_preview_bytes)[0*4+2] = preview_bytes_pc_buffer[0].range(23, 16).to_int64();
((char*)__xlx_apatb_param_preview_bytes)[0*4+3] = preview_bytes_pc_buffer[0].range(31, 24).to_int64();
}
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  {
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_abi_version);
        if (rtl_tv_out_file.good()) {
          rtl_tv_out_file >> AESL_token;
          if (AESL_token != "[[[runtime]]]")
            exit(1);
        }
      }
  
      if (rtl_tv_out_file.good()) {
        rtl_tv_out_file >> AESL_token; 
        rtl_tv_out_file >> AESL_num;  // transaction number
        if (AESL_token != "[[transaction]]") {
          cerr << "Unexpected token: " << AESL_token << endl;
          exit(1);
        }
        if (atoi(AESL_num.c_str()) == AESL_transaction_pc) {
          std::vector<sc_bv<32> > abi_version_pc_buffer(1);
          int i = 0;
          bool has_unknown_value = false;
          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            has_unknown_value |= RTLOutputCheckAndReplacement(AESL_token);
  
            // push token into output port buffer
            if (AESL_token != "") {
              abi_version_pc_buffer[i] = AESL_token.c_str();;
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (has_unknown_value) {
            cerr << "WARNING: [SIM 212-201] RTL produces unknown value 'x' or 'X' on port " 
                 << "abi_version" << ", possible cause: There are uninitialized variables in the C design."
                 << endl; 
          }
  
          if (i > 0) {((char*)__xlx_apatb_param_abi_version)[0*4+0] = abi_version_pc_buffer[0].range(7, 0).to_int64();
((char*)__xlx_apatb_param_abi_version)[0*4+1] = abi_version_pc_buffer[0].range(15, 8).to_int64();
((char*)__xlx_apatb_param_abi_version)[0*4+2] = abi_version_pc_buffer[0].range(23, 16).to_int64();
((char*)__xlx_apatb_param_abi_version)[0*4+3] = abi_version_pc_buffer[0].range(31, 24).to_int64();
}
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  #ifdef USE_BINARY_TV_FILE
{
transaction<128> tr(32448);
aesl_fh.read(AUTOTB_TVOUT_PC_gmem_out, tr.p, tr.tbytes);
if (little_endian()) { tr.reorder(); }
tr.send<16>((char*)__xlx_apatb_param_tensor, 32448, 0);
}
#else
try {
static PostCheck<128> pc(AUTOTB_TVOUT_PC_gmem_out);
pc.psize = 16;
pc.param = (char*)__xlx_apatb_param_tensor;
pc.depth = 32448;
pc.run(AESL_transaction_pc, 0);
} catch (SimException &e) {
  std::cout << "at line " << e.line << " occurred exception, " << e.msg << "\n";
}
#endif
#ifdef USE_BINARY_TV_FILE
{
transaction<128> tr(388800);
aesl_fh.read(AUTOTB_TVOUT_PC_gmem_preview, tr.p, tr.tbytes);
if (little_endian()) { tr.reorder(); }
tr.send<16>((char*)__xlx_apatb_param_preview, 388800, 0);
}
#else
try {
static PostCheck<128> pc(AUTOTB_TVOUT_PC_gmem_preview);
pc.psize = 16;
pc.param = (char*)__xlx_apatb_param_preview;
pc.depth = 388800;
pc.run(AESL_transaction_pc, 0);
} catch (SimException &e) {
  std::cout << "at line " << e.line << " occurred exception, " << e.msg << "\n";
}
#endif

    AESL_transaction_pc++;
    return  AESL_return;
  }
static unsigned AESL_transaction;
static INTER_TCL_FILE tcl_file(INTER_TCL);
std::vector<char> __xlx_sprintf_buffer(1024);
CodeState = ENTER_WRAPC;
CodeState = DUMP_INPUTS;
unsigned __xlx_offset_byte_param_src = 0;
unsigned __xlx_offset_byte_param_luts = 0;
unsigned __xlx_offset_byte_param_tensor = 0;
unsigned __xlx_offset_byte_param_preview = 0;
#ifdef USE_BINARY_TV_FILE
{
aesl_fh.touch(AUTOTB_TVIN_gmem_in, 'b');
transaction<128> tr(388832);
__xlx_offset_byte_param_src = 0*16;
if (__xlx_apatb_param_src) {
  tr.import<16>((char*)__xlx_apatb_param_src, 388800, 0);
}
__xlx_offset_byte_param_luts = 388800*16;
if (__xlx_apatb_param_luts) {
  tr.import<16>((char*)__xlx_apatb_param_luts, 32, 0);
}
aesl_fh.write(AUTOTB_TVIN_gmem_in, tr.p, tr.tbytes);
tcl_file.set_num(388832, &tcl_file.gmem_in_depth);
}
#else
aesl_fh.touch(AUTOTB_TVIN_gmem_in);
{
aesl_fh.write(AUTOTB_TVIN_gmem_in, begin_str(AESL_transaction));
__xlx_offset_byte_param_src = 0*16;
if (__xlx_apatb_param_src) {
for (size_t i = 0; i < 388800; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_src + i * 16;
std::string s = formatData(pos, 128);
aesl_fh.write(AUTOTB_TVIN_gmem_in, s);
}
}
__xlx_offset_byte_param_luts = 388800*16;
if (__xlx_apatb_param_luts) {
for (size_t i = 0; i < 32; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_luts + i * 16;
std::string s = formatData(pos, 128);
aesl_fh.write(AUTOTB_TVIN_gmem_in, s);
}
}
tcl_file.set_num(388832, &tcl_file.gmem_in_depth);
aesl_fh.write(AUTOTB_TVIN_gmem_in, end_str());
}
#endif
#ifdef USE_BINARY_TV_FILE
{
aesl_fh.touch(AUTOTB_TVIN_gmem_out, 'b');
transaction<128> tr(32448);
__xlx_offset_byte_param_tensor = 0*16;
if (__xlx_apatb_param_tensor) {
  tr.import<16>((char*)__xlx_apatb_param_tensor, 32448, 0);
}
aesl_fh.write(AUTOTB_TVIN_gmem_out, tr.p, tr.tbytes);
tcl_file.set_num(32448, &tcl_file.gmem_out_depth);
}
#else
aesl_fh.touch(AUTOTB_TVIN_gmem_out);
{
aesl_fh.write(AUTOTB_TVIN_gmem_out, begin_str(AESL_transaction));
__xlx_offset_byte_param_tensor = 0*16;
if (__xlx_apatb_param_tensor) {
for (size_t i = 0; i < 32448; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_tensor + i * 16;
std::string s = formatData(pos, 128);
aesl_fh.write(AUTOTB_TVIN_gmem_out, s);
}
}
tcl_file.set_num(32448, &tcl_file.gmem_out_depth);
aesl_fh.write(AUTOTB_TVIN_gmem_out, end_str());
}
#endif
#ifdef USE_BINARY_TV_FILE
{
aesl_fh.touch(AUTOTB_TVIN_gmem_preview, 'b');
transaction<128> tr(388800);
__xlx_offset_byte_param_preview = 0*16;
if (__xlx_apatb_param_preview) {
  tr.import<16>((char*)__xlx_apatb_param_preview, 388800, 0);
}
aesl_fh.write(AUTOTB_TVIN_gmem_preview, tr.p, tr.tbytes);
tcl_file.set_num(388800, &tcl_file.gmem_preview_depth);
}
#else
aesl_fh.touch(AUTOTB_TVIN_gmem_preview);
{
aesl_fh.write(AUTOTB_TVIN_gmem_preview, begin_str(AESL_transaction));
__xlx_offset_byte_param_preview = 0*16;
if (__xlx_apatb_param_preview) {
for (size_t i = 0; i < 388800; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_preview + i * 16;
std::string s = formatData(pos, 128);
aesl_fh.write(AUTOTB_TVIN_gmem_preview, s);
}
}
tcl_file.set_num(388800, &tcl_file.gmem_preview_depth);
aesl_fh.write(AUTOTB_TVIN_gmem_preview, end_str());
}
#endif
// print src Transactions
{
aesl_fh.write(AUTOTB_TVIN_src, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_offset_byte_param_src;
aesl_fh.write(AUTOTB_TVIN_src, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.src_depth);
aesl_fh.write(AUTOTB_TVIN_src, end_str());
}

// print tensor Transactions
{
aesl_fh.write(AUTOTB_TVIN_tensor, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_offset_byte_param_tensor;
aesl_fh.write(AUTOTB_TVIN_tensor, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.tensor_depth);
aesl_fh.write(AUTOTB_TVIN_tensor, end_str());
}

// print preview Transactions
{
aesl_fh.write(AUTOTB_TVIN_preview, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_offset_byte_param_preview;
aesl_fh.write(AUTOTB_TVIN_preview, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.preview_depth);
aesl_fh.write(AUTOTB_TVIN_preview, end_str());
}

// print luts Transactions
{
aesl_fh.write(AUTOTB_TVIN_luts, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_offset_byte_param_luts;
aesl_fh.write(AUTOTB_TVIN_luts, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.luts_depth);
aesl_fh.write(AUTOTB_TVIN_luts, end_str());
}

// print width Transactions
{
aesl_fh.write(AUTOTB_TVIN_width, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_width;
aesl_fh.write(AUTOTB_TVIN_width, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.width_depth);
aesl_fh.write(AUTOTB_TVIN_width, end_str());
}

// print height Transactions
{
aesl_fh.write(AUTOTB_TVIN_height, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_height;
aesl_fh.write(AUTOTB_TVIN_height, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.height_depth);
aesl_fh.write(AUTOTB_TVIN_height, end_str());
}

// print src_stride Transactions
{
aesl_fh.write(AUTOTB_TVIN_src_stride, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_src_stride;
aesl_fh.write(AUTOTB_TVIN_src_stride, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.src_stride_depth);
aesl_fh.write(AUTOTB_TVIN_src_stride, end_str());
}

// print src_capacity Transactions
{
aesl_fh.write(AUTOTB_TVIN_src_capacity, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_src_capacity;
aesl_fh.write(AUTOTB_TVIN_src_capacity, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.src_capacity_depth);
aesl_fh.write(AUTOTB_TVIN_src_capacity, end_str());
}

// print tensor_capacity Transactions
{
aesl_fh.write(AUTOTB_TVIN_tensor_capacity, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_tensor_capacity;
aesl_fh.write(AUTOTB_TVIN_tensor_capacity, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.tensor_capacity_depth);
aesl_fh.write(AUTOTB_TVIN_tensor_capacity, end_str());
}

// print preview_stride Transactions
{
aesl_fh.write(AUTOTB_TVIN_preview_stride, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_preview_stride;
aesl_fh.write(AUTOTB_TVIN_preview_stride, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.preview_stride_depth);
aesl_fh.write(AUTOTB_TVIN_preview_stride, end_str());
}

// print preview_capacity Transactions
{
aesl_fh.write(AUTOTB_TVIN_preview_capacity, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_preview_capacity;
aesl_fh.write(AUTOTB_TVIN_preview_capacity, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.preview_capacity_depth);
aesl_fh.write(AUTOTB_TVIN_preview_capacity, end_str());
}

// print resized_w Transactions
{
aesl_fh.write(AUTOTB_TVIN_resized_w, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_resized_w;
aesl_fh.write(AUTOTB_TVIN_resized_w, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.resized_w_depth);
aesl_fh.write(AUTOTB_TVIN_resized_w, end_str());
}

// print resized_h Transactions
{
aesl_fh.write(AUTOTB_TVIN_resized_h, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_resized_h;
aesl_fh.write(AUTOTB_TVIN_resized_h, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.resized_h_depth);
aesl_fh.write(AUTOTB_TVIN_resized_h, end_str());
}

// print pad_x Transactions
{
aesl_fh.write(AUTOTB_TVIN_pad_x, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_pad_x;
aesl_fh.write(AUTOTB_TVIN_pad_x, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.pad_x_depth);
aesl_fh.write(AUTOTB_TVIN_pad_x, end_str());
}

// print pad_y Transactions
{
aesl_fh.write(AUTOTB_TVIN_pad_y, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_pad_y;
aesl_fh.write(AUTOTB_TVIN_pad_y, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.pad_y_depth);
aesl_fh.write(AUTOTB_TVIN_pad_y, end_str());
}

// print output_mode Transactions
{
aesl_fh.write(AUTOTB_TVIN_output_mode, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_output_mode;
aesl_fh.write(AUTOTB_TVIN_output_mode, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.output_mode_depth);
aesl_fh.write(AUTOTB_TVIN_output_mode, end_str());
}

// print flags Transactions
{
aesl_fh.write(AUTOTB_TVIN_flags, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_flags;
aesl_fh.write(AUTOTB_TVIN_flags, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.flags_depth);
aesl_fh.write(AUTOTB_TVIN_flags, end_str());
}

// print eq_mode Transactions
{
aesl_fh.write(AUTOTB_TVIN_eq_mode, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_eq_mode;
aesl_fh.write(AUTOTB_TVIN_eq_mode, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.eq_mode_depth);
aesl_fh.write(AUTOTB_TVIN_eq_mode, end_str());
}

// print saturation_q12 Transactions
{
aesl_fh.write(AUTOTB_TVIN_saturation_q12, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_saturation_q12;
aesl_fh.write(AUTOTB_TVIN_saturation_q12, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.saturation_q12_depth);
aesl_fh.write(AUTOTB_TVIN_saturation_q12, end_str());
}

// print frame_id Transactions
{
aesl_fh.write(AUTOTB_TVIN_frame_id, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_frame_id;
aesl_fh.write(AUTOTB_TVIN_frame_id, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.frame_id_depth);
aesl_fh.write(AUTOTB_TVIN_frame_id, end_str());
}

// print config_id Transactions
{
aesl_fh.write(AUTOTB_TVIN_config_id, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_config_id;
aesl_fh.write(AUTOTB_TVIN_config_id, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.config_id_depth);
aesl_fh.write(AUTOTB_TVIN_config_id, end_str());
}

// print completed_frame_id Transactions
{
aesl_fh.write(AUTOTB_TVIN_completed_frame_id, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_completed_frame_id;
aesl_fh.write(AUTOTB_TVIN_completed_frame_id, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.completed_frame_id_depth);
aesl_fh.write(AUTOTB_TVIN_completed_frame_id, end_str());
}

// print completed_config_id Transactions
{
aesl_fh.write(AUTOTB_TVIN_completed_config_id, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_completed_config_id;
aesl_fh.write(AUTOTB_TVIN_completed_config_id, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.completed_config_id_depth);
aesl_fh.write(AUTOTB_TVIN_completed_config_id, end_str());
}

// print tensor_bytes Transactions
{
aesl_fh.write(AUTOTB_TVIN_tensor_bytes, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_tensor_bytes;
aesl_fh.write(AUTOTB_TVIN_tensor_bytes, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.tensor_bytes_depth);
aesl_fh.write(AUTOTB_TVIN_tensor_bytes, end_str());
}

// print preview_bytes Transactions
{
aesl_fh.write(AUTOTB_TVIN_preview_bytes, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_preview_bytes;
aesl_fh.write(AUTOTB_TVIN_preview_bytes, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.preview_bytes_depth);
aesl_fh.write(AUTOTB_TVIN_preview_bytes, end_str());
}

// print abi_version Transactions
{
aesl_fh.write(AUTOTB_TVIN_abi_version, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_abi_version;
aesl_fh.write(AUTOTB_TVIN_abi_version, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.abi_version_depth);
aesl_fh.write(AUTOTB_TVIN_abi_version, end_str());
}

CodeState = CALL_C_DUT;
int ap_return = image_preprocess_hw_stub_wrapper(__xlx_apatb_param_src, __xlx_apatb_param_tensor, __xlx_apatb_param_preview, __xlx_apatb_param_luts, __xlx_apatb_param_width, __xlx_apatb_param_height, __xlx_apatb_param_src_stride, __xlx_apatb_param_src_capacity, __xlx_apatb_param_tensor_capacity, __xlx_apatb_param_preview_stride, __xlx_apatb_param_preview_capacity, __xlx_apatb_param_resized_w, __xlx_apatb_param_resized_h, __xlx_apatb_param_pad_x, __xlx_apatb_param_pad_y, __xlx_apatb_param_output_mode, __xlx_apatb_param_flags, __xlx_apatb_param_eq_mode, __xlx_apatb_param_saturation_q12, __xlx_apatb_param_frame_id, __xlx_apatb_param_config_id, __xlx_apatb_param_completed_frame_id, __xlx_apatb_param_completed_config_id, __xlx_apatb_param_tensor_bytes, __xlx_apatb_param_preview_bytes, __xlx_apatb_param_abi_version);
CodeState = DUMP_OUTPUTS;
#ifdef USE_BINARY_TV_FILE
{
aesl_fh.touch(AUTOTB_TVOUT_gmem_out, 'b');
transaction<128> tr(32448);
__xlx_offset_byte_param_tensor = 0*16;
if (__xlx_apatb_param_tensor) {
  tr.import<16>((char*)__xlx_apatb_param_tensor, 32448, 0);
}
aesl_fh.write(AUTOTB_TVOUT_gmem_out, tr.p, tr.tbytes);
tcl_file.set_num(32448, &tcl_file.gmem_out_depth);
}
#else
aesl_fh.touch(AUTOTB_TVOUT_gmem_out);
{
aesl_fh.write(AUTOTB_TVOUT_gmem_out, begin_str(AESL_transaction));
__xlx_offset_byte_param_tensor = 0*16;
if (__xlx_apatb_param_tensor) {
for (size_t i = 0; i < 32448; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_tensor + i * 16;
std::string s = formatData(pos, 128);
aesl_fh.write(AUTOTB_TVOUT_gmem_out, s);
}
}
tcl_file.set_num(32448, &tcl_file.gmem_out_depth);
aesl_fh.write(AUTOTB_TVOUT_gmem_out, end_str());
}
#endif
#ifdef USE_BINARY_TV_FILE
{
aesl_fh.touch(AUTOTB_TVOUT_gmem_preview, 'b');
transaction<128> tr(388800);
__xlx_offset_byte_param_preview = 0*16;
if (__xlx_apatb_param_preview) {
  tr.import<16>((char*)__xlx_apatb_param_preview, 388800, 0);
}
aesl_fh.write(AUTOTB_TVOUT_gmem_preview, tr.p, tr.tbytes);
tcl_file.set_num(388800, &tcl_file.gmem_preview_depth);
}
#else
aesl_fh.touch(AUTOTB_TVOUT_gmem_preview);
{
aesl_fh.write(AUTOTB_TVOUT_gmem_preview, begin_str(AESL_transaction));
__xlx_offset_byte_param_preview = 0*16;
if (__xlx_apatb_param_preview) {
for (size_t i = 0; i < 388800; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_preview + i * 16;
std::string s = formatData(pos, 128);
aesl_fh.write(AUTOTB_TVOUT_gmem_preview, s);
}
}
tcl_file.set_num(388800, &tcl_file.gmem_preview_depth);
aesl_fh.write(AUTOTB_TVOUT_gmem_preview, end_str());
}
#endif
// print completed_frame_id Transactions
{
aesl_fh.write(AUTOTB_TVOUT_completed_frame_id, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_completed_frame_id;
aesl_fh.write(AUTOTB_TVOUT_completed_frame_id, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.completed_frame_id_depth);
aesl_fh.write(AUTOTB_TVOUT_completed_frame_id, end_str());
}

// print completed_config_id Transactions
{
aesl_fh.write(AUTOTB_TVOUT_completed_config_id, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_completed_config_id;
aesl_fh.write(AUTOTB_TVOUT_completed_config_id, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.completed_config_id_depth);
aesl_fh.write(AUTOTB_TVOUT_completed_config_id, end_str());
}

// print tensor_bytes Transactions
{
aesl_fh.write(AUTOTB_TVOUT_tensor_bytes, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_tensor_bytes;
aesl_fh.write(AUTOTB_TVOUT_tensor_bytes, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.tensor_bytes_depth);
aesl_fh.write(AUTOTB_TVOUT_tensor_bytes, end_str());
}

// print preview_bytes Transactions
{
aesl_fh.write(AUTOTB_TVOUT_preview_bytes, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_preview_bytes;
aesl_fh.write(AUTOTB_TVOUT_preview_bytes, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.preview_bytes_depth);
aesl_fh.write(AUTOTB_TVOUT_preview_bytes, end_str());
}

// print abi_version Transactions
{
aesl_fh.write(AUTOTB_TVOUT_abi_version, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_abi_version;
aesl_fh.write(AUTOTB_TVOUT_abi_version, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.abi_version_depth);
aesl_fh.write(AUTOTB_TVOUT_abi_version, end_str());
}

// print return Transactions
{
aesl_fh.write(AUTOTB_TVOUT_return, begin_str(AESL_transaction));
auto *pos = (unsigned char*)&ap_return;
aesl_fh.write(AUTOTB_TVOUT_return, formatData(pos, 32));

  tcl_file.set_num(1, &tcl_file.return_depth);
aesl_fh.write(AUTOTB_TVOUT_return, end_str());
}

CodeState = DELETE_CHAR_BUFFERS;
AESL_transaction++;
tcl_file.set_num(AESL_transaction , &tcl_file.trans_num);
return ap_return;
}
