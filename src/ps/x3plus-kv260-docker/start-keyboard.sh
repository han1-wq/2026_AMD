#!/usr/bin/env bash
set -euo pipefail

NAME="${ROBOT_NAME:-x3plus-robot}"

docker inspect "${NAME}" >/dev/null 2>&1 || {
  echo "Container ${NAME} does not exist. Run ./run-robot.sh first." >&2
  exit 1
}
docker inspect "${NAME}" --format '{{.State.Running}}' | grep -qx true || {
  echo "Container ${NAME} is not running." >&2
  exit 1
}

echo "Keyboard control requires this Terminal to remain focused."
echo "Press SPACE or k for an immediate stop; press Ctrl-C to quit."
exec docker exec -it "${NAME}" bash -lc \
  'source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; exec roslaunch yahboomcar_ctrl yahboom_keyboard.launch'