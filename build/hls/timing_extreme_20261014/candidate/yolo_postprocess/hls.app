<AutoPilot:project xmlns:AutoPilot="com.autoesl.autopilot.project" projectType="C/C++" name="yolo_postprocess" top="yolo_postprocess">
    <Simulation argv="">
        <SimFlow name="csim" setup="false" optimizeCompile="true" clean="true" ldflags="" mflags=""/>
    </Simulation>
    <files>
        <file name="/home/amd/Workspace/HLS_IP/timing_extreme_20261014/sources/yolo_postprocess/tb/test_yolo_postprocess.cpp" sc="0" tb="1" cflags=" -I/home/amd/Workspace/HLS_IP/timing_extreme_20261014/sources/yolo_postprocess/src -std=c++14 -O2  -Wno-unknown-pragmas" csimflags=" -Wno-unknown-pragmas" blackbox="false"/>
        <file name="/home/amd/Workspace/HLS_IP/timing_extreme_20261014/sources/yolo_postprocess/src/yolo_postprocess.cpp" sc="0" tb="false" cflags="-std=c++14 -O2 -I/home/amd/Workspace/HLS_IP/timing_extreme_20261014/sources/yolo_postprocess/src" csimflags="" blackbox="false"/>
    </files>
    <solutions>
        <solution name="solution_200mhz" status=""/>
    </solutions>
</AutoPilot:project>

