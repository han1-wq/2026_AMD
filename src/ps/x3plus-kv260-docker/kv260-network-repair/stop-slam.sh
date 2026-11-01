#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"

NAME="${ROBOT_NAME:-x3plus-robot}"

if ! docker inspect "${NAME}" >/dev/null 2>&1 || \
   ! docker inspect "${NAME}" --format '{{.State.Running}}' | grep -qx true; then
  echo "机器人容器 ${NAME} 未运行，无需停止 SLAM。"
  exit 0
fi

slam_pids() {
  docker exec "${NAME}" ps -eo pid=,args= 2>/dev/null \
    | awk '$0 ~ /[s]lam_gmapping([[:space:]]|$)/ || $0 ~ /[r]oslaunch yahboomcar_nav yahboomcar_map.launch/ {print $1}'
}

cleanup_stale_nodes() {
  # Run only after the SLAM processes have exited. This removes stale ROS
  # master registrations without stopping live hardware nodes.
  timeout --kill-after=2s 8 docker exec "${NAME}" bash -c \
    'source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; printf "y\\n" | rosnode cleanup >/dev/null 2>&1 || true' \
    >/dev/null 2>&1 || true
}

pids="$(slam_pids || true)"
if [[ -z "${pids}" ]]; then
  cleanup_stale_nodes
  echo "SLAM 已停止。"
  exit 0
fi

# Ask the node to stop cleanly first, then terminate the launch supervisor.
timeout --kill-after=2s 5 docker exec "${NAME}" bash -c \
  'source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; rosnode kill /slam_gmapping >/dev/null 2>&1 || true' \
  >/dev/null 2>&1 || true

for pid in ${pids}; do
  docker exec "${NAME}" kill -TERM "${pid}" >/dev/null 2>&1 || true
done

for attempt in $(seq 1 15); do
  if [[ -z "$(slam_pids || true)" ]]; then
    break
  fi
  sleep 1
done

for pid in $(slam_pids || true); do
  docker exec "${NAME}" kill -KILL "${pid}" >/dev/null 2>&1 || true
done
cleanup_stale_nodes

if [[ -n "$(slam_pids || true)" ]]; then
  echo "错误：无法停止 SLAM 进程。" >&2
  exit 1
fi
echo "SLAM 已停止，底盘与雷达保持运行。"
