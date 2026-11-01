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
#define AUTOTB_TVIN_input_r "../tv/cdatafile/c.yolo_postprocess.autotvin_input_r.dat"
#define AUTOTB_TVOUT_input_r "../tv/cdatafile/c.yolo_postprocess.autotvout_input_r.dat"
#define AUTOTB_TVIN_tables "../tv/cdatafile/c.yolo_postprocess.autotvin_tables.dat"
#define AUTOTB_TVOUT_tables "../tv/cdatafile/c.yolo_postprocess.autotvout_tables.dat"
#define AUTOTB_TVIN_output_r "../tv/cdatafile/c.yolo_postprocess.autotvin_output_r.dat"
#define AUTOTB_TVOUT_output_r "../tv/cdatafile/c.yolo_postprocess.autotvout_output_r.dat"
#define AUTOTB_TVIN_input_words "../tv/cdatafile/c.yolo_postprocess.autotvin_input_words.dat"
#define AUTOTB_TVOUT_input_words "../tv/cdatafile/c.yolo_postprocess.autotvout_input_words.dat"
#define AUTOTB_TVIN_table_words "../tv/cdatafile/c.yolo_postprocess.autotvin_table_words.dat"
#define AUTOTB_TVOUT_table_words "../tv/cdatafile/c.yolo_postprocess.autotvout_table_words.dat"
#define AUTOTB_TVIN_output_capacity "../tv/cdatafile/c.yolo_postprocess.autotvin_output_capacity.dat"
#define AUTOTB_TVOUT_output_capacity "../tv/cdatafile/c.yolo_postprocess.autotvout_output_capacity.dat"
#define AUTOTB_TVIN_confidence_q30 "../tv/cdatafile/c.yolo_postprocess.autotvin_confidence_q30.dat"
#define AUTOTB_TVOUT_confidence_q30 "../tv/cdatafile/c.yolo_postprocess.autotvout_confidence_q30.dat"
#define AUTOTB_TVIN_nms_q16 "../tv/cdatafile/c.yolo_postprocess.autotvin_nms_q16.dat"
#define AUTOTB_TVOUT_nms_q16 "../tv/cdatafile/c.yolo_postprocess.autotvout_nms_q16.dat"
#define AUTOTB_TVIN_enable_nms "../tv/cdatafile/c.yolo_postprocess.autotvin_enable_nms.dat"
#define AUTOTB_TVOUT_enable_nms "../tv/cdatafile/c.yolo_postprocess.autotvout_enable_nms.dat"
#define AUTOTB_TVIN_candidate_count "../tv/cdatafile/c.yolo_postprocess.autotvin_candidate_count.dat"
#define AUTOTB_TVOUT_candidate_count "../tv/cdatafile/c.yolo_postprocess.autotvout_candidate_count.dat"
#define AUTOTB_TVIN_detection_count "../tv/cdatafile/c.yolo_postprocess.autotvin_detection_count.dat"
#define AUTOTB_TVOUT_detection_count "../tv/cdatafile/c.yolo_postprocess.autotvout_detection_count.dat"
#define AUTOTB_TVIN_gmem_in "../tv/cdatafile/c.yolo_postprocess.autotvin_gmem_in.dat"
#define AUTOTB_TVOUT_gmem_in "../tv/cdatafile/c.yolo_postprocess.autotvout_gmem_in.dat"
#define AUTOTB_TVIN_gmem_out "../tv/cdatafile/c.yolo_postprocess.autotvin_gmem_out.dat"
#define AUTOTB_TVOUT_gmem_out "../tv/cdatafile/c.yolo_postprocess.autotvout_gmem_out.dat"
#define AUTOTB_TVOUT_return "../tv/cdatafile/c.yolo_postprocess.autotvout_ap_return.dat"

#define INTER_TCL "../tv/cdatafile/ref.tcl"

// tvout file define:
#define AUTOTB_TVOUT_PC_input_r "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_input_r.dat"
#define AUTOTB_TVOUT_PC_tables "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_tables.dat"
#define AUTOTB_TVOUT_PC_output_r "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_output_r.dat"
#define AUTOTB_TVOUT_PC_input_words "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_input_words.dat"
#define AUTOTB_TVOUT_PC_table_words "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_table_words.dat"
#define AUTOTB_TVOUT_PC_output_capacity "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_output_capacity.dat"
#define AUTOTB_TVOUT_PC_confidence_q30 "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_confidence_q30.dat"
#define AUTOTB_TVOUT_PC_nms_q16 "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_nms_q16.dat"
#define AUTOTB_TVOUT_PC_enable_nms "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_enable_nms.dat"
#define AUTOTB_TVOUT_PC_candidate_count "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_candidate_count.dat"
#define AUTOTB_TVOUT_PC_detection_count "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_detection_count.dat"
#define AUTOTB_TVOUT_PC_gmem_in "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_gmem_in.dat"
#define AUTOTB_TVOUT_PC_gmem_out "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_gmem_out.dat"
#define AUTOTB_TVOUT_PC_return "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_ap_return.dat"


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
  input_r_depth = 0;
  tables_depth = 0;
  output_r_depth = 0;
  input_words_depth = 0;
  table_words_depth = 0;
  output_capacity_depth = 0;
  confidence_q30_depth = 0;
  nms_q16_depth = 0;
  enable_nms_depth = 0;
  candidate_count_depth = 0;
  detection_count_depth = 0;
  gmem_in_depth = 0;
  gmem_out_depth = 0;
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
  total_list << "{input_r " << input_r_depth << "}\n";
  total_list << "{tables " << tables_depth << "}\n";
  total_list << "{output_r " << output_r_depth << "}\n";
  total_list << "{input_words " << input_words_depth << "}\n";
  total_list << "{table_words " << table_words_depth << "}\n";
  total_list << "{output_capacity " << output_capacity_depth << "}\n";
  total_list << "{confidence_q30 " << confidence_q30_depth << "}\n";
  total_list << "{nms_q16 " << nms_q16_depth << "}\n";
  total_list << "{enable_nms " << enable_nms_depth << "}\n";
  total_list << "{candidate_count " << candidate_count_depth << "}\n";
  total_list << "{detection_count " << detection_count_depth << "}\n";
  total_list << "{gmem_in " << gmem_in_depth << "}\n";
  total_list << "{gmem_out " << gmem_out_depth << "}\n";
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
    int input_r_depth;
    int tables_depth;
    int output_r_depth;
    int input_words_depth;
    int table_words_depth;
    int output_capacity_depth;
    int confidence_q30_depth;
    int nms_q16_depth;
    int enable_nms_depth;
    int candidate_count_depth;
    int detection_count_depth;
    int gmem_in_depth;
    int gmem_out_depth;
    int return_depth;
    int trans_num;
  private:
    ofstream mFile;
    const char* mName;
};


struct __cosim_s16__ { char data[16]; };
struct __cosim_s32__ { char data[32]; };
extern "C" int yolo_postprocess_hw_stub_wrapper(volatile void *, volatile void *, volatile void *, int, int, int, int, int, int, volatile void *, volatile void *);

extern "C" int apatb_yolo_postprocess_hw(volatile void * __xlx_apatb_param_input_r, volatile void * __xlx_apatb_param_tables, volatile void * __xlx_apatb_param_output_r, int __xlx_apatb_param_input_words, int __xlx_apatb_param_table_words, int __xlx_apatb_param_output_capacity, int __xlx_apatb_param_confidence_q30, int __xlx_apatb_param_nms_q16, int __xlx_apatb_param_enable_nms, volatile void * __xlx_apatb_param_candidate_count, volatile void * __xlx_apatb_param_detection_count) {
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
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_candidate_count);
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
          std::vector<sc_bv<32> > candidate_count_pc_buffer(1);
          int i = 0;
          bool has_unknown_value = false;
          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            has_unknown_value |= RTLOutputCheckAndReplacement(AESL_token);
  
            // push token into output port buffer
            if (AESL_token != "") {
              candidate_count_pc_buffer[i] = AESL_token.c_str();;
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (has_unknown_value) {
            cerr << "WARNING: [SIM 212-201] RTL produces unknown value 'x' or 'X' on port " 
                 << "candidate_count" << ", possible cause: There are uninitialized variables in the C design."
                 << endl; 
          }
  
          if (i > 0) {((char*)__xlx_apatb_param_candidate_count)[0*4+0] = candidate_count_pc_buffer[0].range(7, 0).to_int64();
((char*)__xlx_apatb_param_candidate_count)[0*4+1] = candidate_count_pc_buffer[0].range(15, 8).to_int64();
((char*)__xlx_apatb_param_candidate_count)[0*4+2] = candidate_count_pc_buffer[0].range(23, 16).to_int64();
((char*)__xlx_apatb_param_candidate_count)[0*4+3] = candidate_count_pc_buffer[0].range(31, 24).to_int64();
}
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  {
      static ifstream rtl_tv_out_file;
      if (!rtl_tv_out_file.is_open()) {
        rtl_tv_out_file.open(AUTOTB_TVOUT_PC_detection_count);
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
          std::vector<sc_bv<32> > detection_count_pc_buffer(1);
          int i = 0;
          bool has_unknown_value = false;
          rtl_tv_out_file >> AESL_token; //data
          while (AESL_token != "[[/transaction]]"){

            has_unknown_value |= RTLOutputCheckAndReplacement(AESL_token);
  
            // push token into output port buffer
            if (AESL_token != "") {
              detection_count_pc_buffer[i] = AESL_token.c_str();;
              i++;
            }
  
            rtl_tv_out_file >> AESL_token; //data or [[/transaction]]
            if (AESL_token == "[[[/runtime]]]" || rtl_tv_out_file.eof())
              exit(1);
          }
          if (has_unknown_value) {
            cerr << "WARNING: [SIM 212-201] RTL produces unknown value 'x' or 'X' on port " 
                 << "detection_count" << ", possible cause: There are uninitialized variables in the C design."
                 << endl; 
          }
  
          if (i > 0) {((char*)__xlx_apatb_param_detection_count)[0*4+0] = detection_count_pc_buffer[0].range(7, 0).to_int64();
((char*)__xlx_apatb_param_detection_count)[0*4+1] = detection_count_pc_buffer[0].range(15, 8).to_int64();
((char*)__xlx_apatb_param_detection_count)[0*4+2] = detection_count_pc_buffer[0].range(23, 16).to_int64();
((char*)__xlx_apatb_param_detection_count)[0*4+3] = detection_count_pc_buffer[0].range(31, 24).to_int64();
}
        } // end transaction
      } // end file is good
    } // end post check logic bolck
  #ifdef USE_BINARY_TV_FILE
{
transaction<256> tr(256);
aesl_fh.read(AUTOTB_TVOUT_PC_gmem_out, tr.p, tr.tbytes);
if (little_endian()) { tr.reorder(); }
tr.send<32>((char*)__xlx_apatb_param_output_r, 256, 0);
}
#else
try {
static PostCheck<256> pc(AUTOTB_TVOUT_PC_gmem_out);
pc.psize = 32;
pc.param = (char*)__xlx_apatb_param_output_r;
pc.depth = 256;
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
unsigned __xlx_offset_byte_param_input_r = 0;
unsigned __xlx_offset_byte_param_tables = 0;
unsigned __xlx_offset_byte_param_output_r = 0;
#ifdef USE_BINARY_TV_FILE
{
aesl_fh.touch(AUTOTB_TVIN_gmem_in, 'b');
transaction<128> tr(57907);
__xlx_offset_byte_param_input_r = 0*16;
if (__xlx_apatb_param_input_r) {
  tr.import<16>((char*)__xlx_apatb_param_input_r, 56563, 0);
}
__xlx_offset_byte_param_tables = 56563*16;
if (__xlx_apatb_param_tables) {
  tr.import<16>((char*)__xlx_apatb_param_tables, 1344, 0);
}
aesl_fh.write(AUTOTB_TVIN_gmem_in, tr.p, tr.tbytes);
tcl_file.set_num(57907, &tcl_file.gmem_in_depth);
}
#else
aesl_fh.touch(AUTOTB_TVIN_gmem_in);
{
aesl_fh.write(AUTOTB_TVIN_gmem_in, begin_str(AESL_transaction));
__xlx_offset_byte_param_input_r = 0*16;
if (__xlx_apatb_param_input_r) {
for (size_t i = 0; i < 56563; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_input_r + i * 16;
std::string s = formatData(pos, 128);
aesl_fh.write(AUTOTB_TVIN_gmem_in, s);
}
}
__xlx_offset_byte_param_tables = 56563*16;
if (__xlx_apatb_param_tables) {
for (size_t i = 0; i < 1344; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_tables + i * 16;
std::string s = formatData(pos, 128);
aesl_fh.write(AUTOTB_TVIN_gmem_in, s);
}
}
tcl_file.set_num(57907, &tcl_file.gmem_in_depth);
aesl_fh.write(AUTOTB_TVIN_gmem_in, end_str());
}
#endif
#ifdef USE_BINARY_TV_FILE
{
aesl_fh.touch(AUTOTB_TVIN_gmem_out, 'b');
transaction<256> tr(256);
__xlx_offset_byte_param_output_r = 0*32;
if (__xlx_apatb_param_output_r) {
  tr.import<32>((char*)__xlx_apatb_param_output_r, 256, 0);
}
aesl_fh.write(AUTOTB_TVIN_gmem_out, tr.p, tr.tbytes);
tcl_file.set_num(256, &tcl_file.gmem_out_depth);
}
#else
aesl_fh.touch(AUTOTB_TVIN_gmem_out);
{
aesl_fh.write(AUTOTB_TVIN_gmem_out, begin_str(AESL_transaction));
__xlx_offset_byte_param_output_r = 0*32;
if (__xlx_apatb_param_output_r) {
for (size_t i = 0; i < 256; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_output_r + i * 32;
std::string s = formatData(pos, 256);
aesl_fh.write(AUTOTB_TVIN_gmem_out, s);
}
}
tcl_file.set_num(256, &tcl_file.gmem_out_depth);
aesl_fh.write(AUTOTB_TVIN_gmem_out, end_str());
}
#endif
// print input_r Transactions
{
aesl_fh.write(AUTOTB_TVIN_input_r, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_offset_byte_param_input_r;
aesl_fh.write(AUTOTB_TVIN_input_r, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.input_r_depth);
aesl_fh.write(AUTOTB_TVIN_input_r, end_str());
}

// print tables Transactions
{
aesl_fh.write(AUTOTB_TVIN_tables, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_offset_byte_param_tables;
aesl_fh.write(AUTOTB_TVIN_tables, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.tables_depth);
aesl_fh.write(AUTOTB_TVIN_tables, end_str());
}

// print output_r Transactions
{
aesl_fh.write(AUTOTB_TVIN_output_r, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_offset_byte_param_output_r;
aesl_fh.write(AUTOTB_TVIN_output_r, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.output_r_depth);
aesl_fh.write(AUTOTB_TVIN_output_r, end_str());
}

// print input_words Transactions
{
aesl_fh.write(AUTOTB_TVIN_input_words, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_input_words;
aesl_fh.write(AUTOTB_TVIN_input_words, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.input_words_depth);
aesl_fh.write(AUTOTB_TVIN_input_words, end_str());
}

// print table_words Transactions
{
aesl_fh.write(AUTOTB_TVIN_table_words, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_table_words;
aesl_fh.write(AUTOTB_TVIN_table_words, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.table_words_depth);
aesl_fh.write(AUTOTB_TVIN_table_words, end_str());
}

// print output_capacity Transactions
{
aesl_fh.write(AUTOTB_TVIN_output_capacity, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_output_capacity;
aesl_fh.write(AUTOTB_TVIN_output_capacity, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.output_capacity_depth);
aesl_fh.write(AUTOTB_TVIN_output_capacity, end_str());
}

// print confidence_q30 Transactions
{
aesl_fh.write(AUTOTB_TVIN_confidence_q30, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_confidence_q30;
aesl_fh.write(AUTOTB_TVIN_confidence_q30, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.confidence_q30_depth);
aesl_fh.write(AUTOTB_TVIN_confidence_q30, end_str());
}

// print nms_q16 Transactions
{
aesl_fh.write(AUTOTB_TVIN_nms_q16, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_nms_q16;
aesl_fh.write(AUTOTB_TVIN_nms_q16, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.nms_q16_depth);
aesl_fh.write(AUTOTB_TVIN_nms_q16, end_str());
}

// print enable_nms Transactions
{
aesl_fh.write(AUTOTB_TVIN_enable_nms, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)&__xlx_apatb_param_enable_nms;
aesl_fh.write(AUTOTB_TVIN_enable_nms, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.enable_nms_depth);
aesl_fh.write(AUTOTB_TVIN_enable_nms, end_str());
}

// print candidate_count Transactions
{
aesl_fh.write(AUTOTB_TVIN_candidate_count, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_candidate_count;
aesl_fh.write(AUTOTB_TVIN_candidate_count, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.candidate_count_depth);
aesl_fh.write(AUTOTB_TVIN_candidate_count, end_str());
}

// print detection_count Transactions
{
aesl_fh.write(AUTOTB_TVIN_detection_count, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_detection_count;
aesl_fh.write(AUTOTB_TVIN_detection_count, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.detection_count_depth);
aesl_fh.write(AUTOTB_TVIN_detection_count, end_str());
}

CodeState = CALL_C_DUT;
int ap_return = yolo_postprocess_hw_stub_wrapper(__xlx_apatb_param_input_r, __xlx_apatb_param_tables, __xlx_apatb_param_output_r, __xlx_apatb_param_input_words, __xlx_apatb_param_table_words, __xlx_apatb_param_output_capacity, __xlx_apatb_param_confidence_q30, __xlx_apatb_param_nms_q16, __xlx_apatb_param_enable_nms, __xlx_apatb_param_candidate_count, __xlx_apatb_param_detection_count);
CodeState = DUMP_OUTPUTS;
#ifdef USE_BINARY_TV_FILE
{
aesl_fh.touch(AUTOTB_TVOUT_gmem_out, 'b');
transaction<256> tr(256);
__xlx_offset_byte_param_output_r = 0*32;
if (__xlx_apatb_param_output_r) {
  tr.import<32>((char*)__xlx_apatb_param_output_r, 256, 0);
}
aesl_fh.write(AUTOTB_TVOUT_gmem_out, tr.p, tr.tbytes);
tcl_file.set_num(256, &tcl_file.gmem_out_depth);
}
#else
aesl_fh.touch(AUTOTB_TVOUT_gmem_out);
{
aesl_fh.write(AUTOTB_TVOUT_gmem_out, begin_str(AESL_transaction));
__xlx_offset_byte_param_output_r = 0*32;
if (__xlx_apatb_param_output_r) {
for (size_t i = 0; i < 256; ++i) {
unsigned char *pos = (unsigned char*)__xlx_apatb_param_output_r + i * 32;
std::string s = formatData(pos, 256);
aesl_fh.write(AUTOTB_TVOUT_gmem_out, s);
}
}
tcl_file.set_num(256, &tcl_file.gmem_out_depth);
aesl_fh.write(AUTOTB_TVOUT_gmem_out, end_str());
}
#endif
// print candidate_count Transactions
{
aesl_fh.write(AUTOTB_TVOUT_candidate_count, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_candidate_count;
aesl_fh.write(AUTOTB_TVOUT_candidate_count, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.candidate_count_depth);
aesl_fh.write(AUTOTB_TVOUT_candidate_count, end_str());
}

// print detection_count Transactions
{
aesl_fh.write(AUTOTB_TVOUT_detection_count, begin_str(AESL_transaction));
{
auto *pos = (unsigned char*)__xlx_apatb_param_detection_count;
aesl_fh.write(AUTOTB_TVOUT_detection_count, formatData(pos, 32));
}
  tcl_file.set_num(1, &tcl_file.detection_count_depth);
aesl_fh.write(AUTOTB_TVOUT_detection_count, end_str());
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
