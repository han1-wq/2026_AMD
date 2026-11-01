#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"

RVIZ_MODE="${1:-map}"
case "${RVIZ_MODE}" in
  map)
    RVIZ_LABEL="建图地图"
    RVIZ_LAUNCH="view_map.launch"
    ;;
  navigate)
    RVIZ_LABEL="导航避障"
    RVIZ_LAUNCH="view_navigate.launch"
    ;;
  *)
    echo "错误：RViz 模式必须是 map 或 navigate。" >&2
    exit 2
    ;;
esac

NAME="${RVIZ_CONTAINER_NAME:-x3plus-rviz}"
IMAGE="${RVIZ_IMAGE:-x3plus:melodic-arm64}"
DISPLAY_VALUE="${DISPLAY:-:0}"
XAUTHORITY_HOST="${XAUTHORITY:-/run/user/1000/gdm/Xauthority}"
ROS_MASTER_URI_VALUE="${ROS_MASTER_URI:-http://127.0.0.1:11311}"
ROS_HOSTNAME_VALUE="${ROS_HOSTNAME:-127.0.0.1}"
# The image does not contain the KV260 host's xlnx userspace driver.
# Use Mesa software rendering by default; set RVIZ_SOFTWARE_RENDERING=0 to try hardware.
RVIZ_SOFTWARE_RENDERING="${RVIZ_SOFTWARE_RENDERING:-1}"
RVIZ_MESA_DRIVER="${RVIZ_MESA_DRIVER:-swrast}"

if [[ ! -e /tmp/.X11-unix/X0 ]]; then
  echo "错误：宿主机 X11 display socket 不存在：/tmp/.X11-unix/X0" >&2
  exit 1
fi
if [[ ! -r "${XAUTHORITY_HOST}" ]]; then
  echo "错误：找不到 X11 授权文件：${XAUTHORITY_HOST}" >&2
  exit 1
fi

if docker inspect "${NAME}" >/dev/null 2>&1; then
  state="$(docker inspect "${NAME}" --format '{{.State.Status}}')"
  if [[ "${state}" == running ]]; then
    echo "${NAME} 已在运行，请使用现有 ${RVIZ_LABEL} RViz 窗口，避免重复启动。"
    exit 0
  fi
  docker rm "${NAME}" >/dev/null 2>&1 || true
fi

dri_args=()
for device in /dev/dri/card0 /dev/dri/renderD128; do
  if [[ -e "${device}" ]]; then
    dri_args+=("--device=${device}:${device}")
  fi
done

if ((${#dri_args[@]} > 0)); then
  if [[ "${RVIZ_SOFTWARE_RENDERING}" == 1 ]]; then
    echo "已映射宿主机 DRI 图形设备（RViz 默认使用 Mesa 软件渲染）：${dri_args[*]}"
  else
    echo "已映射宿主机 DRI 图形设备（尝试硬件渲染）：${dri_args[*]}"
  fi
else
  echo "警告：宿主机没有可用 DRI 设备，RViz 将使用软件渲染。" >&2
fi

echo "启动 RViz（${RVIZ_LABEL}）：ROS_MASTER_URI=${ROS_MASTER_URI_VALUE} DISPLAY=${DISPLAY_VALUE}"
docker run --rm --name "${NAME}" \
  --net=host --ipc=host \
  --env "DISPLAY=${DISPLAY_VALUE}" \
  --env XAUTHORITY=/root/.Xauthority \
  --env "ROS_MASTER_URI=${ROS_MASTER_URI_VALUE}" \
  --env "ROS_HOSTNAME=${ROS_HOSTNAME_VALUE}" \
  --env XDG_RUNTIME_DIR=/tmp/runtime-root \
  --env QT_X11_NO_MITSHM=1 \
  --env "LIBGL_ALWAYS_SOFTWARE=${RVIZ_SOFTWARE_RENDERING}" \
  --env "MESA_LOADER_DRIVER_OVERRIDE=${RVIZ_MESA_DRIVER}" \
  --volume /tmp/.X11-unix:/tmp/.X11-unix:rw \
  --volume "${XAUTHORITY_HOST}:/root/.Xauthority:ro" \
  --volume "${SCRIPT_DIR}/remote-rviz:/pc-rviz:ro" \
  --tmpfs /tmp/runtime-root:rw,exec,mode=700 \
  "${dri_args[@]}" \
  "${IMAGE}" bash -c "source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; if [[ '${RVIZ_MODE}' == navigate ]]; then exec roslaunch /pc-rviz/navigation-view.launch; else exec roslaunch yahboomcar_nav ${RVIZ_LAUNCH}; fi"
