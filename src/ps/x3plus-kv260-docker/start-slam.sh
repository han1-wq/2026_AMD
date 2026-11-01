#!/usr/bin/env bash
set -euo pipefail

NAME="${ROBOT_NAME:-x3plus-robot}"
MAP_TYPE="${MAP_TYPE:-gmapping}"

docker inspect "${NAME}" >/dev/null 2>&1 || {
  echo "Container ${NAME} does not exist. Run ./run-robot.sh first." >&2
  exit 1
}
docker inspect "${NAME}" --format '{{.State.Running}}' | grep -qx true || {
  echo "Container ${NAME} is not running." >&2
  exit 1
}

echo "Starting ${MAP_TYPE} SLAM in ${NAME}. Hardware/lidar must already be running. RViz is disabled on KV260."
exec docker exec -it "${NAME}" bash -lc \
  "source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; exec roslaunch yahboomcar_nav yahboomcar_map.launch use_rviz=false map_type=${MAP_TYPE}"