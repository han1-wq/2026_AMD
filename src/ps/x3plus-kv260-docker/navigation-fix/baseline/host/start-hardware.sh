#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"

BASE="${SCRIPT_DIR}"
NAME="${ROBOT_NAME:-x3plus-robot}"
LOCK_FILE="/tmp/x3plus-hardware-start.lock"

exec 9>"${LOCK_FILE}"
flock -n 9 || {
  echo "Another hardware start is already in progress; waiting is not safe for a duplicate caller." >&2
  exit 1
}

"${BASE}/run-master.sh"
"${BASE}/run-robot.sh"

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

hardware_healthy() {
  node_alive /driver_node && \
    node_alive /ydlidar_lidar_publisher && \
    topic_has_publisher /scan && \
    topic_has_publisher /odom && \
    tf_ready base_footprint laser
}

hardware_launch_alive() {
  ros_cmd "pgrep -f -- '^/usr/bin/python /opt/ros/melodic/bin/roslaunch yahboomcar_nav laser_bringup\.launch' >/dev/null 2>&1"
}

if hardware_healthy; then
  echo "Hardware already healthy; no duplicate roslaunch was started."
  exit 0
fi

if hardware_launch_alive; then
  echo "Hardware roslaunch exists but is unhealthy; refusing automatic restart." >&2
  echo "Ensure the robot is safely stopped, inspect USB/TF/logs, then explicitly stop and retry." >&2
  exit 1
fi

# This is the original manual startup command. Do not reject the normal
# intermediate state while roslaunch is registering its child nodes.
rm -f /tmp/x3plus-hardware.log
docker exec -d "${NAME}" bash -c \
  'source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; exec roslaunch yahboomcar_nav laser_bringup.launch >/tmp/x3plus-hardware.log 2>&1'
echo "Hardware roslaunch started; waiting for driver, lidar, /scan, /odom and TF..."

for attempt in $(seq 1 30); do
  if hardware_healthy; then
    echo "Hardware is ready (attempt ${attempt}/30)."
    exit 0
  fi
  sleep 1
done

echo "Hardware did not become ready. Last launch output:" >&2
ros_cmd 'tail -n 120 /tmp/x3plus-hardware.log 2>/dev/null || true' >&2 || true
exit 1
