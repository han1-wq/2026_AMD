#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"

RVIZ_MODE="${1:-map}"
case "${RVIZ_MODE}" in
  map)
    RVIZ_LABEL="建图地图"
    VIEWER_MODE=slam
    ;;
  navigate)
    RVIZ_LABEL="导航避障"
    VIEWER_MODE=navigation
    ;;
  *)
    echo "错误：RViz 模式必须是 map 或 navigate。" >&2
    exit 2
    ;;
esac

NAME="${RVIZ_CONTAINER_NAME:-x3plus-rviz}"
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/${NAME}-$(id -u).lock"
flock -n 9 || { echo '另一个 RViz 启动/切换操作正在进行。' >&2; exit 1; }
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

VIEWER_LAUNCH="${SCRIPT_DIR}/remote-rviz/${VIEWER_MODE}-view.launch"
VIEWER_CONFIG="${SCRIPT_DIR}/remote-rviz/${VIEWER_MODE}.rviz"
# Recreate legacy viewers and reload edited bind-mounted configurations.
VIEWER_SIGNATURE="$(sha256sum "${VIEWER_LAUNCH}" "${VIEWER_CONFIG}" | sha256sum | cut -d ' ' -f 1)"
docker image inspect "${IMAGE}" >/dev/null
if docker inspect "${NAME}" >/dev/null 2>&1; then
  state="$(docker inspect "${NAME}" --format '{{.State.Status}}')"
  if [[ "${state}" == running ]]; then
    running_mode="$(docker inspect "${NAME}" --format '{{index .Config.Labels "x3plus.viewer.mode"}}')"
    running_signature="$(docker inspect "${NAME}" --format '{{index .Config.Labels "x3plus.viewer.signature"}}')"
    running_image="$(docker inspect "${NAME}" --format '{{.Config.Image}}')"
    running_env="$(docker inspect "${NAME}" --format '{{range .Config.Env}}{{println .}}{{end}}')"
    if [[ "${running_mode}" == "${VIEWER_MODE}" && "${running_signature}" == "${VIEWER_SIGNATURE}" && "${running_image}" == "${IMAGE}" ]] &&
       grep -Fqx "ROS_MASTER_URI=${ROS_MASTER_URI_VALUE}" <<< "${running_env}" &&
       grep -Fqx "ROS_HOSTNAME=${ROS_HOSTNAME_VALUE}" <<< "${running_env}" &&
       grep -Fqx "DISPLAY=${DISPLAY_VALUE}" <<< "${running_env}"; then
      echo "${NAME} 已在运行，模式、网络与配置一致，复用现有 ${RVIZ_LABEL} RViz 窗口。"
      exit 0
    fi
    echo 'RViz 模式、网络或配置已变化，重建查看器。'
    docker stop -t 5 "${NAME}" >/dev/null
  fi
  # --rm viewers disappear on stop; older persistent containers need removal.
  if docker inspect "${NAME}" >/dev/null 2>&1; then
    docker rm "${NAME}" >/dev/null
  fi
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
docker run -d --rm --name "${NAME}" \
  --label "x3plus.viewer.mode=${VIEWER_MODE}" \
  --label "x3plus.viewer.signature=${VIEWER_SIGNATURE}" \
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
  "${IMAGE}" bash -c "source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; exec roslaunch /pc-rviz/${VIEWER_MODE}-view.launch viewer_name:=kv260_${VIEWER_MODE}_rviz"

sleep 3
if [[ "$(docker inspect "${NAME}" --format '{{.State.Running}}')" != true ]]; then
  docker logs --tail 60 "${NAME}" >&2 || true
  echo 'RViz 未能保持运行，请检查显示与 ROS 日志。' >&2
  exit 1
fi
echo "RViz 已启动（${RVIZ_LABEL}）；可直接点击另一模式按钮切换。"
