#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"
result=0

# Refuse to claim success when Docker is unavailable.
timeout 5 docker info --format '{{.ServerVersion}}' >/dev/null || result=1

ROBOT_NAME="${ROBOT_NAME:-x3plus-robot}"
MASTER_NAME="${MASTER_NAME:-x3plus-master}"

if docker inspect "${ROBOT_NAME}" >/dev/null 2>&1 && \
   docker inspect "${ROBOT_NAME}" --format '{{.State.Running}}' | grep -qx true; then
  timeout --kill-after=2s 7 docker exec "${ROBOT_NAME}" bash -lc \
    'source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; rostopic pub -1 /cmd_vel geometry_msgs/Twist "{linear: {x: 0.0, y: 0.0, z: 0.0}, angular: {x: 0.0, y: 0.0, z: 0.0}}"' \
    >/dev/null 2>&1 || echo "警告：零速度消息未确认发送，将继续停止机器人容器。" >&2
fi

stop_container() {
  local name="$1"
  if ! docker inspect "${name}" >/dev/null 2>&1; then
    return 0
  fi
  if docker inspect "${name}" --format '{{.State.Running}}' | grep -qx true; then
    timeout --kill-after=2s 18 docker stop -t 10 "${name}" || {
      echo "错误：未确认容器 ${name} 停止。" >&2
      result=1
    }
  fi
}

# Stop, do not remove: the protected writable layers contain runtime fixes.
stop_container "${ROBOT_NAME}"
stop_container "${MASTER_NAME}"
"${SCRIPT_DIR}/stop-rviz.sh" || result=1
"${SCRIPT_DIR}/stop-astra-rgbd-yolov4.sh" || result=1
if (( result == 0 )); then
  echo "全部停止操作完成；机器人/master 容器、可写层和地图已保留。"
else
  echo "部分停止操作失败，请检查日志和实际服务状态。" >&2
fi
exit "${result}"
