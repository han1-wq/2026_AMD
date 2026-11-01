#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"

IMAGE="${IMAGE:-x3plus:melodic-arm64}"
NAME="${MASTER_NAME:-x3plus-master}"
ROS_MASTER_URI="${ROS_MASTER_URI:-http://127.0.0.1:11311}"
ROS_IP="${ROS_IP:-${ROS_HOSTNAME:-127.0.0.1}}"
/usr/bin/python3 "${SCRIPT_DIR}/launcher_network.py" "${NAME}"

wait_for_master() {
  local previous=""
  local candidate=""
  local stable_count=0

  local deadline=$((SECONDS + 35))
  while (( SECONDS < deadline )); do
    candidate="$(timeout --kill-after=2s 5 docker exec "${NAME}" bash -lc \
      'source /opt/ros/melodic/setup.bash; export ROS_MASTER_URI="'"${ROS_MASTER_URI}"'"; rosparam get /run_id' \
      2>/dev/null | grep -E '^[0-9a-fA-F-]{36}$' | tail -n 1 || true)"

    if [[ -n "${candidate}" ]]; then
      if [[ "${candidate}" == "${previous}" ]]; then
        stable_count=$((stable_count + 1))
      else
        previous="${candidate}"
        stable_count=1
      fi
      if (( stable_count >= 2 )); then
        echo "ROS master is ready in ${NAME} (run_id=${candidate})."
        return 0
      fi
    else
      previous=""
      stable_count=0
    fi
    sleep 1
  done

  echo "ROS Master 未在约 35 秒内就绪：${ROS_MASTER_URI}。请检查下方日志、网卡地址和容器环境。" >&2
  docker logs --tail 80 "${NAME}" >&2 || true
  return 1
}

if docker inspect "${NAME}" >/dev/null 2>&1 && [[ "${FORCE_RECREATE:-0}" != 1 ]]; then
  state="$(docker inspect "${NAME}" --format '{{.State.Status}}')"
  if [[ "${state}" == running ]]; then
    echo "ROS master container ${NAME} is already running; waiting for ROS readiness."
  else
    echo "Starting existing ROS master container ${NAME} (state: ${state})."
    docker start "${NAME}" >/dev/null
  fi
  wait_for_master
  exit 0
fi

if [[ "${FORCE_RECREATE:-0}" == 1 ]]; then
  echo "FORCE_RECREATE=1: removing ROS master container ${NAME}." >&2
  docker rm -f "${NAME}" >/dev/null 2>&1 || true
fi

docker run -d --name "${NAME}" --restart unless-stopped \
  --net=host --ipc=host \
  -e "ROS_MASTER_URI=${ROS_MASTER_URI}" \
  -e "ROS_HOSTNAME=${ROS_HOSTNAME:-127.0.0.1}" \
  -e "ROS_IP=${ROS_IP}" \
  "${IMAGE}" /opt/x3plus_ws/roscore.sh

echo "ROS master container is running: ${NAME}"
echo "ROS_MASTER_URI=${ROS_MASTER_URI}"
wait_for_master
