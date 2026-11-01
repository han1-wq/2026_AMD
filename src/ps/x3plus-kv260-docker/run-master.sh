#!/usr/bin/env bash
set -euo pipefail

IMAGE="${IMAGE:-x3plus:melodic-arm64}"
NAME="${MASTER_NAME:-x3plus-master}"
ROS_MASTER_URI="${ROS_MASTER_URI:-http://127.0.0.1:11311}"

docker rm -f "${NAME}" >/dev/null 2>&1 || true
docker run -d --name "${NAME}" --restart unless-stopped \
  --net=host --ipc=host \
  -e "ROS_MASTER_URI=${ROS_MASTER_URI}" \
  "${IMAGE}" /opt/x3plus_ws/roscore.sh

echo "ROS master is running in ${NAME}"
echo "ROS_MASTER_URI=${ROS_MASTER_URI}"
docker logs --tail 20 "${NAME}"