#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"

NAME="${ROBOT_NAME:-x3plus-robot}"
/usr/bin/python3 "${SCRIPT_DIR}/launcher_core.py" --check
/usr/bin/python3 "${SCRIPT_DIR}/launcher_core.py" --container "${NAME}"
MAP_TYPE="${MAP_TYPE:-gmapping}"
LOCK_FILE="/tmp/x3plus-slam-start.lock"

exec 9>"${LOCK_FILE}"
flock -n 9 || {
  echo "Another SLAM start is already in progress; refusing a duplicate." >&2
  exit 1
}

docker inspect "${NAME}" --format '{{.State.Running}}' 2>/dev/null | grep -qx true || {
  echo "Container ${NAME} is not running. Start hardware first." >&2
  exit 1
}

ros_cmd() {
  timeout --kill-after=2s 6 docker exec "${NAME}" bash -c \
    "source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; $*"
}

node_alive() {
  ros_cmd "rosnode ping -c 1 '$1' >/dev/null 2>&1"
}

topic_has_publisher() {
  ros_cmd "rostopic info '$1' 2>/dev/null | sed -n '/Publishers:/,/Subscribers:/p' | grep -q '^ \\*'"
}

tf_ready() {
  local target="$1"
  local source="$2"
  timeout --kill-after=2s 8 docker exec "${NAME}" bash -c \
    "source /opt/ros/melodic/setup.bash; python -c 'import sys,rospy,tf; rospy.init_node(\"x3plus_health_tf\", anonymous=True, disable_signals=True); listener=tf.TransformListener(); listener.waitForTransform(sys.argv[1], sys.argv[2], rospy.Time(0), rospy.Duration(3.0))' '${target}' '${source}'" \
    >/dev/null 2>&1
}

navigation_node_alive() {
  ros_cmd "rosnode list | grep -Eq '^/(map_server(_[0-9]+)?|amcl|move_base(_node)?)$'"
}

navigation_launch_alive() {
  ros_cmd "pgrep -f -- '^/usr/bin/python /opt/ros/melodic/bin/roslaunch yahboomcar_nav yahboomcar_navigation\.launch' >/dev/null 2>&1"
}

slam_healthy() {
  node_alive /slam_gmapping && topic_has_publisher /map
}

slam_launch_alive() {
  ros_cmd "pgrep -f -- '^/usr/bin/python /opt/ros/melodic/bin/roslaunch yahboomcar_nav yahboomcar_map\.launch' >/dev/null 2>&1"
}

# Keep exactly one map/TF producer. Starting SLAM while navigation is active
# would otherwise leave map_server/AMCL and gmapping competing for /map and
# map -> odom. Navigation is stopped safely; hardware remains running.
if navigation_launch_alive || navigation_node_alive; then
  echo "Navigation is active; stopping navigation before starting SLAM (hardware/lidar stay running)."
  "${SCRIPT_DIR}/stop-navigation.sh"
fi

if slam_healthy; then
  echo "SLAM and /map are already healthy; no duplicate roslaunch was started."
  exit 0
fi

for node in /driver_node /ydlidar_lidar_publisher; do
  node_alive "${node}" || {
    echo "Required node ${node} is not alive. Run ./start-hardware.sh first." >&2
    exit 1
  }
done
topic_has_publisher /scan || { echo "No /scan publisher; refusing to start SLAM." >&2; exit 1; }
topic_has_publisher /odom || { echo "No /odom publisher; refusing to start SLAM." >&2; exit 1; }
tf_ready odom base_footprint || { echo "Missing odom -> base_footprint TF; refusing to start SLAM." >&2; exit 1; }
tf_ready base_footprint laser || { echo "Missing base_footprint -> laser TF; refusing to start SLAM." >&2; exit 1; }

if slam_launch_alive; then
  echo "SLAM roslaunch is already running; waiting for /slam_gmapping and /map."
else
  rm -f /tmp/x3plus-slam.log
  docker exec -d "${NAME}" bash -c \
    "source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; exec roslaunch yahboomcar_nav yahboomcar_map.launch use_rviz:=false map_type:=${MAP_TYPE} >/tmp/x3plus-slam.log 2>&1"
  echo "${MAP_TYPE} roslaunch started; waiting for slam_gmapping and /map..."
fi

for attempt in $(seq 1 30); do
  if slam_healthy; then
    echo "SLAM is ready (attempt ${attempt}/30)."
    exit 0
  fi
  sleep 1
done

echo "SLAM did not become ready. Last launch output:" >&2
ros_cmd 'tail -n 120 /tmp/x3plus-slam.log 2>/dev/null || true' >&2 || true
exit 1
