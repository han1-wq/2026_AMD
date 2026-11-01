#!/usr/bin/env bash
set -euo pipefail

source "/opt/ros/${ROS_DISTRO:-melodic}/setup.bash"
source /opt/x3plus_ws/devel/setup.bash
exec roscore
