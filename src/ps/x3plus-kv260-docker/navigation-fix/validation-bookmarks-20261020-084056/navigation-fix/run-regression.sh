#!/usr/bin/env bash
set -euo pipefail
cp -a /project/context/src/yahboomcar_nav/. /opt/x3plus_ws/src/yahboomcar_nav/
source /opt/ros/melodic/setup.bash
source /opt/x3plus_ws/devel/setup.bash
export ROS_PACKAGE_PATH="/project/context/src:${ROS_PACKAGE_PATH}"
export ROS_MASTER_URI=http://127.0.0.1:11311 ROS_IP=127.0.0.1 ROS_HOSTNAME=127.0.0.1
roscore >"/project/navigation-fix/${1:-regression.py}-roscore.log" 2>&1 &
master_pid=$!
trap 'kill -TERM "$master_pid" 2>/dev/null || true' EXIT
for attempt in $(seq 1 50); do
  if rosparam list >/dev/null 2>&1; then break; fi
  sleep .1
done
export ROBOT_TYPE=X3plus
python "/project/navigation-fix/${1:-regression.py}"
