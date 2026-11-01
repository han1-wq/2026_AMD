#!/usr/bin/env bash
set -euo pipefail

ROBOT_NAME="${ROBOT_NAME:-x3plus-robot}"
MASTER_NAME="${MASTER_NAME:-x3plus-master}"

if docker inspect "${ROBOT_NAME}" >/dev/null 2>&1; then
  docker exec "${ROBOT_NAME}" bash -lc \
    'source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; rostopic pub -1 /cmd_vel geometry_msgs/Twist "{}"' \
    >/dev/null 2>&1 || true
fi
docker rm -f "${ROBOT_NAME}" "${MASTER_NAME}" >/dev/null 2>&1 || true
echo "Stopped ${ROBOT_NAME} and ${MASTER_NAME}; sent a zero velocity command when possible."