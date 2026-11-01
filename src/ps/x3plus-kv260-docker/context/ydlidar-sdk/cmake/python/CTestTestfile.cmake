# CMake generated Testfile for 
# Source directory: /home/jetson/software/YDLidar-SDK-master/python
# Build directory: /home/jetson/software/YDLidar-SDK-master/cmake/python
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(ydlidar_py_test "/usr/bin/python" "/home/jetson/software/YDLidar-SDK-master/python/test/pytest.py")
set_tests_properties(ydlidar_py_test PROPERTIES  ENVIRONMENT "PYTHONPATH=/home/jetson/yahboomcar_ws/devel/lib/python2.7/dist-packages:/home/jetson/software/world_canvas/devel/lib/python2.7/dist-packages:/opt/ros/melodic/lib/python2.7/dist-packages:/home/jetson/software/YDLidar-SDK-master/cmake/python")
subdirs("examples")
