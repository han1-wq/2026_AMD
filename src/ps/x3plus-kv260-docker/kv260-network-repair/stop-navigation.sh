#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"

NAME="${ROBOT_NAME:-x3plus-robot}"

if ! docker inspect "${NAME}" >/dev/null 2>&1 || \
   ! docker inspect "${NAME}" --format '{{.State.Running}}' | grep -qx true; then
  echo "机器人容器 ${NAME} 未运行，无需停止导航。"
  exit 0
fi

launch_pids() {
  docker exec "${NAME}" ps -eo pid=,args= 2>/dev/null \
    | awk '$0 ~ /[r]oslaunch yahboomcar_nav yahboomcar_navigation.launch/ {print $1}'
}

navigation_nodes() {
  timeout --kill-after=2s 6 docker exec "${NAME}" bash -c \
    'source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; rosnode list | grep -E "^/(map_server(_[0-9]+)?|amcl|move_base(_node)?)$" || true'
}

pids="$(launch_pids || true)"
nodes="$(navigation_nodes || true)"
if [[ -z "${pids}" && -z "${nodes}" ]]; then
  echo "导航已停止。"
  exit 0
fi

timeout --kill-after=2s 5 docker exec "${NAME}" bash -c \
  'source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; rostopic pub -1 /cmd_vel geometry_msgs/Twist "{linear: {x: 0.0, y: 0.0, z: 0.0}, angular: {x: 0.0, y: 0.0, z: 0.0}}"' \
  >/dev/null 2>&1 || true

for pid in ${pids}; do
  docker exec "${NAME}" kill -TERM "${pid}" >/dev/null 2>&1 || true
done

for attempt in $(seq 1 20); do
  if [[ -z "$(launch_pids || true)" ]]; then
    break
  fi
  sleep 1
done

# Clean up nodes if roslaunch had already exited or left a child behind.
nodes="$(navigation_nodes || true)"
if [[ -n "${nodes}" ]]; then
  timeout --kill-after=2s 6 docker exec "${NAME}" bash -c \
    "source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; rosnode kill ${nodes} >/dev/null 2>&1 || true" \
    >/dev/null 2>&1 || true
fi

for pid in $(launch_pids || true); do
  docker exec "${NAME}" kill -KILL "${pid}" >/dev/null 2>&1 || true
done

echo "导航已停止；底盘与雷达保持运行。"
