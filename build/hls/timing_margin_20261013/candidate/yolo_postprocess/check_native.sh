set -eu
cd /home/amd/Workspace/HLS_IP/timing_margin_20261013/candidate/yolo_postprocess
g++ -std=c++14 -O2 -Wno-unknown-pragmas -I/tools/Xilinx/Vitis_HLS/2022.1/include -I/home/amd/Workspace/HLS_IP/yolo_postprocess/src /home/amd/Workspace/HLS_IP/yolo_postprocess/src/yolo_postprocess.cpp /home/amd/Workspace/HLS_IP/yolo_postprocess/tb/test_yolo_postprocess.cpp -o native_full
timeout 30 ./native_full
