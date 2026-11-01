<AutoPilot:project xmlns:AutoPilot="com.autoesl.autopilot.project" projectType="C/C++" name="image_preprocess" top="image_preprocess">
    <Simulation argv="">
        <SimFlow name="csim" setup="false" optimizeCompile="true" clean="true" ldflags="" mflags=""/>
    </Simulation>
    <files>
        <file name="/home/amd/Workspace/HLS_IP/image_preprocess/tb/test_image_preprocess.cpp" sc="0" tb="1" cflags=" -I/home/amd/Workspace/HLS_IP/image_preprocess/src -std=c++14 -O2  -Wno-unknown-pragmas" csimflags=" -Wno-unknown-pragmas" blackbox="false"/>
        <file name="/home/amd/Workspace/HLS_IP/image_preprocess/src/image_preprocess.cpp" sc="0" tb="false" cflags="-std=c++14 -O2 -I/home/amd/Workspace/HLS_IP/image_preprocess/src" csimflags="" blackbox="false"/>
    </files>
    <solutions>
        <solution name="solution_200mhz" status=""/>
    </solutions>
</AutoPilot:project>

