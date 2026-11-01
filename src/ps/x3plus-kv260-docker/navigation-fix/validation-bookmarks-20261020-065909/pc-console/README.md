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

## 状态显示

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