# X3plus KV260 上位机

这是电脑端的中文 Tkinter 上位机，用于配置 ROS 1 网络并启动电脑上的
RViz。它不启动 KV260 硬件、SLAM 或导航节点，也不主动发布 `/cmd_vel`。

## 启动

在电脑 Ubuntu 图形桌面中执行：

```bash
/home/amd/x3plus-kv260-docker/pc-console/start-pc-console.sh
```

也可以从应用程序菜单打开 **X3plus KV260 上位机**。

首次使用时填写：

- `主机 IP`：运行 Docker RViz 的电脑在机器人网络上的 IPv4 地址，可点击“自动检测网卡”，自动选择到 KV260 的路由地址，也可从下拉框选择其他启用网卡。
- `KV260 IP`：KV260 在机器人网络上的 IPv4 地址。
- `ROS Master 端口`：默认 `11311`。

配置保存到：
`/home/amd/.config/x3plus-pc-console/config.json`（设置 `XDG_CONFIG_HOME` 时使用该目录）。
“恢复默认值”恢复 KV260 `192.168.137.60`、端口 `11311` 并重新检测主机 IP，
点击“保存配置”持久保存。保存不会立即改变运行中的 RViz；点击启动按钮应用。
示例配置：`/home/amd/x3plus-kv260-docker/pc-console/config.example.json`。

## 两个 RViz 选项

### SLAM 地图 RViz

启动已经验证过的 SLAM 查看配置，显示 `/map`、`/scan`、网格和机器人坐标轴。
KV260 上必须已经运行硬件驱动、雷达和 gmapping。

### 导航 RViz

启动镜像中 `yahboomcar_nav` 的 `view_navigate.launch` 和导航 RViz 配置，
包含地图、TF、代价地图、`2D Pose Estimate` 和 `2D Nav Goal` 工具。
这个按钮只启动电脑上的 RViz，**不会**在 KV260 上启动 `map_server`、AMCL
或 `move_base`。如要真正导航，需先在 KV260 上停止 SLAM，再按项目文档启动
`yahboomcar_navigation.launch`，并确认 `/map` 与定位 TF 正常。

同一时间只运行一个电脑 RViz。点击另一个模式时，上位机会先停止当前查看器
再切换。相同模式、相同网络配置不会重复启动；配置变化后重新创建容器。
关闭上位机窗口会保留 RViz。停止 RViz 不会停止板上的导航或机器人运动。

2026-10-20 定位恢复修复：同一地图、同一 AMCL 会话定位健康时，首次初始化后可以连续下发 `2D Nav Goal`，无需每个目标前重设位姿。门控遇到短暂协方差超限、激光或 TF 过期时仍立即停车并撤销目标；在首次异常起 5 秒内恢复且连续稳定 2 秒后，允许接收新目标。被撤销的目标不会自动续跑。持续异常、地图变化、定位跳变、AMCL 重启或人工 reset 仍需初始化。此板端修改已完成本机隔离验证，KV260 当前断开，尚未部署。

“检查实际数据与 TF”现在同时采集公开和内部 move_base 状态、门控前后速度。状态栏分开显示当前数据故障和历史定位锁定原因，避免协方差已恢复仍显示不清楚的拒绝状态。部署、测试证据及实车复测步骤见 `/home/amd/x3plus-kv260-docker/navigation-fix/导航门控恢复修复说明.md`。

## 地图绑定起点书签（2026-10-20 新增）

电脑端已实现“保存当前位置 / 显示起点 / 恢复起点定位”。**本轮仅修改本机源码并完成隔离测试，尚未部署新的板端门控**；旧板端没有书签服务时会报错，不会退回到无检查的直接发布。

使用条件：已加载最终保存地图的 AMCL 导航，导航 RViz 使用当前网络配置，板端运行对应版本的门控。当前版本明确要求 `/map` 的唯一发布者是 `/map_server`、`/amcl_pose` 的唯一发布者是 `/amcl`；节点改名或命名空间不同会拒绝，需要另行适配。SLAM/gmapping 建图中不支持此功能。

1. 在地面设置可重复摆车的位置线和车头方向箭头。先用 `2D Pose Estimate` 初始化，等待门控通过，再人工核对实车位置、车头与激光轮廓。
2. 保持小车静止，在起点名称框输入名称，点击“保存当前位置”，确认定位真实正确。同名覆盖需明确确认。保存的是 `map → base_footprint` 的 x/y/yaw，不是地图 origin。
3. 点击“显示起点”只显示 RViz 蓝色箭头和名称，不重设 AMCL、不发导航目标，也不会停车。标记不是当前实车定位，也不是目标。
4. 下次使用必须选相同地图，并把静止实车摆回同一位置、保持同一车头方向。点击“恢复起点定位”，核对坐标与朝向并确认实物摆放。
5. 板端再次核对地图指纹、请求时效与静止里程计，先撤销定位确认和旧目标，再发布一次新 `/initialpose`。恢复后重新等待定位检查并人工核对激光；需要运动时必须另发新导航目标。恢复不会自动导航。

书签默认保存至 `/home/amd/.config/x3plus-pc-console/start-poses.json`（遵循 `XDG_CONFIG_HOME`）。按地图尺寸、分辨率、二维原点及全部占据栅格计算 SHA-256；地图名相同但内容变化也会拒绝。地图变化会撤销确认并清除旧箭头。初始方差固定为 x/y 各 `0.25 m²`、yaw 为 `(15°)²`，不把 AMCL 收敛后的极小协方差当作重新摆车精度。

保存及恢复要求最近约 1 秒有连续新鲜 `/odom`，六个速度分量绝对值均不超过 `0.01`（线速度 m/s，角速度 rad/s）；此判断只是软件检查，不能证明实车物理静止或位置正确。恢复请求绑定当前门控地图会话，3 秒过期，并拒绝重复 ID；ROS1 仍须在可信网络使用，这不是权限认证。

**定位限制：**新增射线遮挡检查能拒绝已复现的反向朝向错误，但对称场景仍可能扫描完全相同，`ready` 不是定位唯一性证明。搬到未知位置时不要恢复书签；请重新人工初始化，或使用独立物理参照／外部定位。`/initialpose` 不是重置 gmapping 的接口。尚无新版本 ARM 性能、真实扫描回放及实车精度验收。

测试及证据说明见 `/home/amd/x3plus-kv260-docker/navigation-fix/导航复测与起点标定方案.md`。

## 状态显示（只读检查）

界面以只读 XML-RPC 方式检查 ROS Master，显示：

- ROS Master 是否可连接
- `/map`、`/scan` 是否有发布者
- TF 发布者、AMCL 定位和 `move_base` 分别显示
- `/cmd_vel` 发布者（有无发布者不等于机器人正在运动或静止）
- 电脑 RViz 容器、模式和实际网络配置；Docker 失败会单独报告

每 5 秒刷新的是 Master 注册信息，不能证明消息可达、节点存活或 TF 链有效。
点击“检查实际数据与 TF”会在 RViz 容器中运行约 6 秒的只读订阅器，检查
`/map`、`/scan`、`/amcl_pose`、`/move_base/status`，以及 `map → base_footprint`
和 `map → 雷达消息坐标系` 的 TF 连通性及时间戳。日志列出所有收到的数据。
实测结果带时间，不会持续更新；AMCL 未初始化、地图非锁存或网络延迟时，
一次检查可能没有收到消息，需结合节点日志判断。没有 RViz 容器时只检查注册信息。
“查看 RViz 日志”读取最近 100 行容器日志。启动、停止和检查均在后台执行。

状态检查脚本也可以单独执行：

```bash
python3 /home/amd/x3plus-kv260-docker/pc-console/ros-status.py \
  --master http://192.168.137.60:11311
```

停止电脑查看器：

```bash
/home/amd/x3plus-kv260-docker/remote-rviz/start-pc-rviz.sh stop
```

这不会停止 KV260 上的硬件、SLAM 或导航节点。

## 网络要求

电脑端使用 host network、host IPC 和 X11 映射运行 RViz。ROS 1 节点需要双向
访问：KV260 必须能够连接到电脑端的 `ROS_HOSTNAME`，电脑也必须能访问
KV260 的 `ROS_MASTER_URI`。防火墙不能阻止 ROS Master 的 `11311` 端口和
ROS 节点动态端口。

电脑 RViz 启动器仍位于：
`/home/amd/x3plus-kv260-docker/remote-rviz/start-pc-rviz.sh`。
命令行模式如下：

```bash
KV260_IP=192.168.137.60 PC_ROS_IP=192.168.137.149 \
  /home/amd/x3plus-kv260-docker/remote-rviz/start-pc-rviz.sh slam

KV260_IP=192.168.137.60 PC_ROS_IP=192.168.137.149 \
  ROS_MASTER_PORT=11311 \
  /home/amd/x3plus-kv260-docker/remote-rviz/start-pc-rviz.sh navigation --replace
```

当前 VMware 图形环境沿用已经验证的 privileged、X11 映射和 host IPC 设置。
`LIBGL_ALWAYS_SOFTWARE` 默认保持 `0`，以复用当前已成功运行的容器；如图形
驱动再次导致 RViz 启动失败，可在启动前设置 `RVIZ_SOFTWARE_RENDERING=1`。

## KV260 上的服务准备

以下命令在 KV260 执行，前提是现有 `x3plus-master` 和 `x3plus-robot` 容器
正在运行且两端 ROS 网络地址已配置。硬件、SLAM、导航各使用独立终端，
已经运行的服务不要重复启动。首次部署见 `/home/amd/x3plus-kv260-docker/README-KV260.md`。

硬件与雷达（持续运行）：

```bash
docker exec -it x3plus-robot bash -lc '
  source /opt/ros/melodic/setup.bash
  source /opt/x3plus_ws/devel/setup.bash
  roslaunch yahboomcar_nav laser_bringup.launch
'
```

SLAM（硬件启动后，在另一终端执行）：

```bash
docker exec -it x3plus-robot bash -lc '
  source /opt/ros/melodic/setup.bash
  source /opt/x3plus_ws/devel/setup.bash
  roslaunch yahboomcar_nav yahboomcar_map.launch use_rviz:=false map_type:=gmapping
'
```

转为导航前，先在 SLAM 仍运行时保存地图：

```bash
docker exec -it x3plus-robot bash -lc '
  source /opt/ros/melodic/setup.bash
  rosrun map_server map_saver -f /maps/x3plus_map
'
```

随后在启动 SLAM 的终端按 Ctrl+C 停止建图，保留硬件进程；如果建图由其他
启动器启动，则在对应启动器中停止。确认不再有 gmapping 发布 `map → odom`，
然后在新终端启动导航（地图必须已存在于容器 `/maps` 挂载目录）：

```bash
docker exec -it x3plus-robot bash -lc '
  source /opt/ros/melodic/setup.bash
  source /opt/x3plus_ws/devel/setup.bash
  roslaunch yahboomcar_nav yahboomcar_navigation.launch use_rviz:=false map:=/maps/x3plus_map
'
```

在电脑打开导航 RViz，用 **2D Pose Estimate** 设置初始位姿，确认雷达与地图
对齐、AMCL 和 TF 有效，再用 **2D Nav Goal** 下发目标。导航服务能够控制机器人；
上位机的“停止 RViz”仅关闭电脑显示。停止导航服务应在其启动终端按 Ctrl+C。

## 验证命令

2026-10-10 实测环境：电脑 `192.168.43.123`，KV260 `192.168.43.182:11311`。

- 上位机回归测试 24 项通过；板端启动器测试 82 项通过；板端 OFDM 组件
  离线/伪终端测试 23 项通过。
- 实际完成 SLAM 查看器的启动、受控重连和状态诊断；重连后再次收到
  `800×800` 地图、6 秒约 60 帧 `/scan`，`map → base_footprint` 和
  `map → laser` TF 检查通过。RViz 截图确认 `Global Status: Ok`、地图、雷达
  和机器人位置可见。
- 上位机已验证地址变化、网关变化、路由失效、配置损坏、诊断超时/失败、
  实测结果失效和重连保留当前模式；保存网络方案不会自动改写手动网卡选择。
- KV260 保持原有 SLAM 服务，没有发送导航目标。导航 RViz 和导航启动配置
  存在并已做静态检查，但完整 AMCL、move_base、实际运动到点尚未验收。
- Astra RGB-D + DPU YOLOv4 已完成 120 帧无窗口推理并正常退出；独立 ROS 2
  只读订阅收到深度 554 帧、彩色 95 帧、检测 22 条和标注图像 20 帧。
  检测消息包含有效毫米深度和跟踪信息。订阅验证使用临时 UDP Fast DDS
  配置，未修改正在运行的应用配置。
- OFDM 主机端正确识别 FT2232 `0403:6010` 的 interface 1，并完成发送尝试，
  但板端没有返回响应而超时；因此 OFDM 对端固件、运行状态或接线仍未验收。
- 尚未执行换 Wi-Fi、物理断网或重启后的恢复试验，也没有自动重启板端任务。

```bash
python3 -m unittest discover -s /home/amd/x3plus-kv260-docker/pc-console -p 'test_*.py' -v
bash -n /home/amd/x3plus-kv260-docker/remote-rviz/start-pc-rviz.sh
```

ROS 2 摄像头/YOLO 的只读验证器位于
`/home/amd/x3plus-kv260-docker/pc-console/probe-ros2.py`；它只订阅
`/camera/color/image_raw`、`/camera/depth/image_raw`、`/yolov4/image` 和
`/yolov4/detections`，不会发布控制命令。