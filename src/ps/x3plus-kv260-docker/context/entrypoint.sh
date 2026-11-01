#!/usr/bin/env bash
set -euo pipefail

source "/opt/ros/${ROS_DISTRO:-melodic}/setup.bash"
source /opt/x3plus_ws/devel/setup.bash

export ROBOT_TYPE="${ROBOT_TYPE:-X3plus}"
export ROBOT_SERIAL="${ROBOT_SERIAL:-/dev/myserial}"
export LIDAR_SERIAL="${LIDAR_SERIAL:-/dev/ydlidar}"
export RPLIDAR_TYPE="${RPLIDAR_TYPE:-4ROS}"
export LIDAR_BAUDRATE="${LIDAR_BAUDRATE:-512000}"
export LIDAR_DEVICE_TYPE="${LIDAR_DEVICE_TYPE:-0}"
export LIDAR_TYPE="${LIDAR_TYPE:-0}"
export ROS_MASTER_URI="${ROS_MASTER_URI:-http://127.0.0.1:11311}"
export LD_LIBRARY_PATH="/usr/local/lib:/opt/x3plus_ws/devel/lib/astra_camera:${LD_LIBRARY_PATH:-}"
export OPENNI2_REDIST="${OPENNI2_REDIST:-/usr/local/lib}"

# Preserve the original map.sh workflow while keeping output on the persistent
# /maps volume mounted by run-robot.sh.
mkdir -p /maps
if [[ ! -e /maps/map.sh ]]; then
  cat > /maps/map.sh <<'MAP_SCRIPT'
#!/usr/bin/env bash
set -euo pipefail
MAP_DIR="${MAP_DIR:-/maps}"
MAP_NAME="${1:-map}"
mkdir -p "${MAP_DIR}"
exec rosrun map_server map_saver -f "${MAP_DIR}/${MAP_NAME}"
MAP_SCRIPT
  chmod +x /maps/map.sh
fi

if [[ -z "${ROS_HOSTNAME:-}" && -n "${ROS_IP:-}" ]]; then
  export ROS_HOSTNAME="${ROS_IP}"
elif [[ -z "${ROS_HOSTNAME:-}" ]]; then
  export ROS_HOSTNAME="127.0.0.1"
fi

echo "ROS distribution : ${ROS_DISTRO:-melodic}"
echo "ROS master       : ${ROS_MASTER_URI}"
echo "Robot type       : ${ROBOT_TYPE}"
echo "Robot serial     : ${ROBOT_SERIAL}"
echo "Lidar serial     : ${LIDAR_SERIAL}"
echo "Lidar baudrate   : ${LIDAR_BAUDRATE}"

exec "$@"
