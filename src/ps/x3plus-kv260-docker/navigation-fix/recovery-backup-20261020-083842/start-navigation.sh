#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"

NAME="${ROBOT_NAME:-x3plus-robot}"
HOST_MAP_DIR="${MAP_DIR:-/home/ubuntu/x3plus-maps}"
CONTAINER_MAP_DIR="${MAP_CONTAINER_DIR:-/maps}"
MAP_NAME="${1:-${NAV_MAP:-}}"

# Reject a stale/misidentified device before switching navigation/SLAM modes.
/usr/bin/python3 "${SCRIPT_DIR}/launcher_core.py" --check
/usr/bin/python3 "${SCRIPT_DIR}/launcher_core.py" --container "${NAME}"

usage() {
  echo "用法：$0 <地图名称>" >&2
  echo "示例：$0 office_map" >&2
}

if [[ -z "${MAP_NAME}" ]]; then
  usage
  exit 2
fi
if [[ ! "${MAP_NAME}" =~ ^[A-Za-z0-9][A-Za-z0-9_-]{0,63}$ ]]; then
  echo "错误：地图名称只能以英文或数字开头，并且只能包含英文、数字、下划线和短横线（最长 64 个字符）。" >&2
  exit 2
fi

HOST_YAML="${HOST_MAP_DIR}/${MAP_NAME}.yaml"
if [[ ! -s "${HOST_YAML}" ]]; then
  echo "错误：地图 YAML 不存在或为空：${HOST_YAML}" >&2
  exit 1
fi

image_ref="$(awk '$1 == "image:" {print $2; exit}' "${HOST_YAML}")"
if [[ -z "${image_ref}" || "${image_ref}" == *..* ]]; then
  echo "错误：地图 YAML 的 image 字段无效：${image_ref:-<empty>}" >&2
  exit 1
fi
case "${image_ref}" in
  /maps/*)
    HOST_PGM="${HOST_MAP_DIR}/${image_ref#/maps/}"
    ;;
  /*)
    echo "错误：地图图像路径不在 /maps 挂载目录内：${image_ref}" >&2
    exit 1
    ;;
  *)
    HOST_PGM="${HOST_MAP_DIR}/${image_ref}"
    ;;
esac
if [[ ! -s "${HOST_PGM}" ]]; then
  echo "错误：地图图像不存在或为空：${HOST_PGM}" >&2
  exit 1
fi

if ! docker inspect "${NAME}" >/dev/null 2>&1 || \
   ! docker inspect "${NAME}" --format '{{.State.Running}}' | grep -qx true; then
  echo "错误：机器人容器 ${NAME} 未运行，请先启动基础环境。" >&2
  exit 1
fi

mount_source="$(docker inspect "${NAME}" --format '{{range .Mounts}}{{if eq .Destination "/maps"}}{{.Source}}{{end}}{{end}}')"
if [[ -z "${mount_source}" ]]; then
  echo "错误：机器人容器没有将地图目录挂载到 /maps。" >&2
  exit 1
fi
if [[ "$(readlink -f "${mount_source}")" != "$(readlink -f "${HOST_MAP_DIR}")" ]]; then
  echo "错误：容器 /maps 挂载路径与 MAP_DIR 不一致。" >&2
  echo "容器挂载：${mount_source}" >&2
  echo "配置目录：${HOST_MAP_DIR}" >&2
  exit 1
fi
docker exec "${NAME}" test -r "${CONTAINER_MAP_DIR}/${MAP_NAME}.yaml" || {
  echo "错误：容器内找不到地图：${CONTAINER_MAP_DIR}/${MAP_NAME}.yaml" >&2
  exit 1
}

/usr/bin/python3 "${SCRIPT_DIR}/navigation-fix/sync-runtime.py" --container "${NAME}" --check

ros_cmd() {
  timeout --kill-after=2s 6 docker exec "${NAME}" bash -c \
    "source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; $*"
}

node_pattern_alive() {
  local pattern="$1"
  ros_cmd "rosnode list | grep -Eq '${pattern}'"
}

topic_has_publisher() {
  ros_cmd "rostopic info '$1' 2>/dev/null | sed -n '/Publishers:/,/Subscribers:/p' | grep -q '^ \\*'"
}

tf_ready() {
  local target="$1"
  local source="$2"
  timeout --kill-after=2s 8 docker exec "${NAME}" bash -c \
    "source /opt/ros/melodic/setup.bash; python -c 'import sys,time,rospy,tf; rospy.init_node(\"x3plus_navigation_health\", anonymous=True, disable_signals=True); listener=tf.TransformListener(); listener.waitForTransform(sys.argv[1], sys.argv[2], rospy.Time(0), rospy.Duration(3.0)); rospy.signal_shutdown(\"transform-check-complete\"); time.sleep(0.2)' '${target}' '${source}'" \
    >/dev/null 2>&1
}

navigation_healthy() {
  node_pattern_alive '^/map_server(_[0-9]+)?$' && \
    node_pattern_alive '^/amcl$' && \
    node_pattern_alive '^/move_base(_node)?$' && \
    node_pattern_alive '^/navigation_guard$' && \
    topic_has_publisher /map && \
    tf_ready map odom
}

navigation_launch_alive() {
  ros_cmd "pgrep -f -- '^/usr/bin/python /opt/ros/melodic/bin/roslaunch yahboomcar_nav yahboomcar_navigation\.launch' >/dev/null 2>&1"
}

navigation_map_matches() {
  ros_cmd "pgrep -af -- '^/usr/bin/python /opt/ros/melodic/bin/roslaunch yahboomcar_nav yahboomcar_navigation\.launch' | grep -F -- 'map:=${CONTAINER_MAP_DIR}/${MAP_NAME}' >/dev/null 2>&1"
}

# Apply even when reusing a healthy navigation instance, before any early exit.
/usr/bin/python3 "${SCRIPT_DIR}/launcher_modes.py" prepare-navigation

if navigation_healthy && navigation_map_matches; then
  ros_cmd 'rosservice call /navigation_guard/reset "{}" | grep -q "success: True"'
  echo "导航服务已运行；已撤销上次定位确认和目标，请重新设置 2D Pose Estimate。"
  echo "当前地图：${MAP_NAME}"
  exit 0
fi

if navigation_launch_alive || node_pattern_alive '^/(navigation_guard|map_server(_[0-9]+)?|amcl|move_base(_node)?)$'; then
  if navigation_healthy; then
    echo "检测到另一张地图的导航实例，先停止导航再切换地图：${MAP_NAME}"
  else
    echo "检测到未完全健康的导航实例，先清理后重新启动。"
  fi
  "${SCRIPT_DIR}/stop-navigation.sh"
fi

rm -f /tmp/x3plus-navigation.log
MAP_ARG="${CONTAINER_MAP_DIR}/${MAP_NAME}"
docker exec -d "${NAME}" bash -c \
  "source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; exec roslaunch yahboomcar_nav yahboomcar_navigation.launch use_rviz:=false map:=${MAP_ARG} >/tmp/x3plus-navigation.log 2>&1"
echo "导航已启动，地图：${MAP_NAME}；等待 map_server、AMCL、move_base 和 TF..."

for attempt in $(seq 1 60); do
  if navigation_healthy; then
    echo "导航服务已启动（第 ${attempt}/60 次检查），等待定位确认，速度尚未放行。"
    echo "在导航 RViz 使用 2D Pose Estimate 设置实际位姿；/navigation/ready 为 true 后才可下发目标。"
    exit 0
  fi
  sleep 1
done

echo "错误：导航未能就绪，最近的启动日志如下：" >&2
ros_cmd 'tail -n 160 /tmp/x3plus-navigation.log 2>/dev/null || true' >&2 || true
"${SCRIPT_DIR}/stop-navigation.sh" >/dev/null 2>&1 || true
exit 1
