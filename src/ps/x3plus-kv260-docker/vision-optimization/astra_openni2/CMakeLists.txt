cmake_minimum_required(VERSION 3.8)
project(astra_openni2)

if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
endif()
add_compile_options(-Wall -Wextra -Wpedantic -O2)

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(std_msgs REQUIRED)

set(OPENNI2_REDIST "$ENV{OPENNI2_REDIST}" CACHE PATH "Orbbec OpenNI2 bundle")
if(NOT OPENNI2_REDIST)
  set(OPENNI2_REDIST "/home/ubuntu/x3plus-kv260-docker/context/src/astra_camera/include/openni2_redist/arm64")
endif()
if(NOT EXISTS "${OPENNI2_REDIST}/libOpenNI2.so")
  message(FATAL_ERROR "Missing bundled libOpenNI2.so: ${OPENNI2_REDIST}")
endif()

add_executable(astra_openni2_node src/astra_openni2_node.cpp)
target_include_directories(astra_openni2_node PRIVATE /usr/include/openni2)
ament_target_dependencies(astra_openni2_node rclcpp sensor_msgs std_msgs)
target_link_libraries(astra_openni2_node "${OPENNI2_REDIST}/libOpenNI2.so")
set_target_properties(astra_openni2_node PROPERTIES
  BUILD_RPATH "${OPENNI2_REDIST}"
  INSTALL_RPATH "${OPENNI2_REDIST}")

install(TARGETS astra_openni2_node DESTINATION lib/${PROJECT_NAME})
install(DIRECTORY launch DESTINATION share/${PROJECT_NAME})
ament_package()
