# syntax=docker/dockerfile:1
# Ubuntu 18.04 + ROS Melodic for the X3plus runtime.
#
# Build on an ARM64 KV260:
#   docker build --pull -t x3plus:melodic-arm64 .
#
# Build on an x86_64 workstation for the KV260:
#   docker buildx build --platform linux/arm64 --load \
#     -t x3plus:melodic-arm64 .

FROM ubuntu:18.04

# This Dockerfile is deliberately target-specific. A native KV260 build (or an
# explicit linux/arm64 Buildx build) must never silently produce an amd64 image.
ARG TARGETARCH=arm64

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    ROS_DISTRO=melodic \
    ROBOT_TYPE=X3plus \
    ROBOT_SERIAL=/dev/myserial \
    LIDAR_SERIAL=/dev/ydlidar \
    RPLIDAR_TYPE=4ROS \
    LIDAR_BAUDRATE=512000 \
    LIDAR_DEVICE_TYPE=0 \
    LIDAR_TYPE=0 \
    ROS_MASTER_URI=http://127.0.0.1:11311 \
    ROS_HOSTNAME=127.0.0.1
ENV CMAKE_PREFIX_PATH=/usr/local:/opt/ros/melodic

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY context/ros.key /tmp/ros.key

RUN apt-get \
      -o Acquire::ForceIPv4=true \
      -o Acquire::Retries=5 \
      -o Acquire::http::Timeout=30 \
      -o Acquire::https::Timeout=30 \
      update \
    && apt-get \
      -o Acquire::ForceIPv4=true \
      -o Acquire::Retries=5 \
      -o Acquire::http::Timeout=30 \
      -o Acquire::https::Timeout=30 \
      install -y --no-install-recommends \
      ca-certificates \
      curl \
      gnupg2 \
      lsb-release \
      dirmngr \
    && apt-key add /tmp/ros.key \
    && rm -f /tmp/ros.key \
    && echo "deb https://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu bionic main" \
      > /etc/apt/sources.list.d/ros1.list \
    && apt-get \
      -o Acquire::ForceIPv4=true \
      -o Acquire::Retries=5 \
      -o Acquire::http::Timeout=30 \
      -o Acquire::https::Timeout=30 \
      update \
    && apt-get \
      -o Acquire::ForceIPv4=true \
      -o Acquire::Retries=5 \
      -o Acquire::http::Timeout=30 \
      -o Acquire::https::Timeout=30 \
      install -y --no-install-recommends \
      build-essential \
      cmake \
      git \
      python \
      python-dev \
      python-numpy \
      python-serial \
      python-setuptools \
      python-catkin-pkg \
      python-empy \
      python-rospkg \
      python-rosdep \
      python-wstool \
      python-catkin-tools \
      pkg-config \
      libeigen3-dev \
      libgoogle-glog-dev \
      libudev-dev \
      libusb-1.0-0-dev \
      libuvc-dev \
      libboost-all-dev \
      libopencv-dev \
      ros-melodic-ros-base \
      ros-melodic-actionlib \
      ros-melodic-actionlib-msgs \
      ros-melodic-amcl \
      ros-melodic-camera-info-manager \
      ros-melodic-cv-bridge \
      ros-melodic-dynamic-reconfigure \
      ros-melodic-dwa-local-planner \
      ros-melodic-gmapping \
      ros-melodic-geometry-msgs \
      ros-melodic-joy \
      ros-melodic-imu-filter-madgwick \
      ros-melodic-image-geometry \
      ros-melodic-image-transport \
      ros-melodic-message-filters \
      ros-melodic-map-server \
      ros-melodic-message-generation \
      ros-melodic-message-runtime \
      ros-melodic-move-base \
      ros-melodic-nav-msgs \
      ros-melodic-nodelet \
      ros-melodic-robot-localization \
      ros-melodic-robot-state-publisher \
      ros-melodic-rgbd-launch \
      ros-melodic-roscpp \
      ros-melodic-rospy \
      ros-melodic-rviz \
      ros-melodic-sensor-msgs \
      ros-melodic-std-msgs \
      ros-melodic-tf \
      ros-melodic-tf2 \
      ros-melodic-tf2-ros \
      ros-melodic-uuid-msgs \
      ros-melodic-visualization-msgs \
      ros-melodic-std-srvs \
      ros-melodic-xacro \
    && (rosdep init 2>/dev/null || true) \
    && rm -rf /var/lib/apt/lists/*

# Fail before source compilation if this is not an ARM64 target.
RUN test "$(dpkg --print-architecture)" = "arm64" \
    && test "${TARGETARCH}" = "arm64"

# Rosmaster_Lib is consumed by the Python 2 ROS driver. Keep the source package
# on PYTHONPATH because setuptools may install it as a non-importable egg.
ENV PYTHONPATH=/opt/rosmaster
ENV OPENNI2_REDIST=/usr/local/lib

WORKDIR /opt/x3plus_ws

COPY context/src/ /opt/x3plus_ws/src/
COPY context/ydlidar-sdk/ /opt/ydlidar-sdk/
COPY context/rosmaster/ /opt/rosmaster/
COPY context/entrypoint.sh /opt/x3plus_ws/entrypoint.sh
COPY context/roscore.sh /opt/x3plus_ws/roscore.sh

RUN chmod +x /opt/x3plus_ws/entrypoint.sh /opt/x3plus_ws/roscore.sh \
    && install -d /usr/local/lib/OpenNI2/Drivers \
    && install -m 0755 /opt/x3plus_ws/src/astra_camera/include/openni2_redist/arm64/libOpenNI2.so /usr/local/lib/ \
    && install -m 0644 /opt/x3plus_ws/src/astra_camera/include/openni2_redist/arm64/OpenNI.ini /usr/local/lib/ \
    && install -m 0755 /opt/x3plus_ws/src/astra_camera/include/openni2_redist/arm64/OpenNI2/Drivers/*.so /usr/local/lib/OpenNI2/Drivers/ \
    && install -m 0644 /opt/x3plus_ws/src/astra_camera/include/openni2_redist/arm64/OpenNI2/Drivers/*.ini /usr/local/lib/OpenNI2/Drivers/ \
    && ldconfig \
    && cd /opt/ydlidar-sdk \
    && mkdir -p /tmp/ydlidar-sdk-build \
    && cd /tmp/ydlidar-sdk-build \
    && cmake /opt/ydlidar-sdk \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_INSTALL_PREFIX=/usr/local \
         -DBUILD_EXAMPLES=OFF \
         -DBUILD_TEST=OFF \
    && make install -j"$(nproc)" \
    && python /opt/rosmaster/setup.py install \
    && mkdir -p /maps /opt/x3plus_ws/log /root/yahboomcar_ws/src/yahboomcar_nav \
    && ln -s /maps /root/yahboomcar_ws/src/yahboomcar_nav/maps \
    && source /opt/ros/melodic/setup.bash \
    && cd /opt/x3plus_ws \
    && catkin_make -DCMAKE_BUILD_TYPE=Release \
    && rm -rf /root/.cache /tmp/*

ENTRYPOINT ["/opt/x3plus_ws/entrypoint.sh"]
CMD ["bash"]
