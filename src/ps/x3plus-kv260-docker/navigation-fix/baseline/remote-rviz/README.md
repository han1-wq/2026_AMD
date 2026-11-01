# KV260 SLAM 的电脑端 RViz

已于 2026-10-08 实机验证：KV260 `192.168.137.60` 运行硬件驱动和
gmapping；电脑 Ubuntu 虚拟机 `192.168.137.149` 运行 RViz。
电脑实收 `/map`、约 10 Hz 的 `/scan`、`/odom` 和 TF，RViz 显示
`Global Status: Ok`。地图为 800×800，分辨率 0.05 米。

## 重新启动

在 KV260 上依次执行（也可以使用板上现有启动器）：

```bash
/home/ubuntu/x3plus-kv260-docker/start-hardware.sh
/home/ubuntu/x3plus-kv260-docker/start-slam.sh
```

在电脑图形桌面的终端执行：

```bash
/home/amd/x3plus-kv260-docker/remote-rviz/start-pc-rviz.sh
```

脚本自动选择访问 KV260 的电脑网卡地址，检查 Master，
创建 `x3plus-pc-slam-rviz` 容器。已运行时不会重复启动。
本配置只提供观察工具，不包含导航、初始定位或发布点工具。

中文上位机入口：`/home/amd/x3plus-kv260-docker/pc-console/start-pc-console.sh`。
支持配置 IP、端口、检查发布者和实测 TF，以及在 SLAM / 导航查看器之间切换。
操作说明位于 `/home/amd/x3plus-kv260-docker/pc-console/README.md`。

命令行导航查看器：

```bash
/home/amd/x3plus-kv260-docker/remote-rviz/start-pc-rviz.sh navigation --replace
```

`--replace` 会先停止当前电脑查看器再切换。导航入口仅启动 RViz；导航服务
需要另行在 KV260 上运行。同一模式但网络配置变化时也会重建查看器。

只关闭电脑上的显示，不影响 KV260 建图：

```bash
docker stop x3plus-pc-slam-rviz
```

检查电脑实际接收的数据（查看器运行时）：

```bash
docker exec x3plus-pc-slam-rviz bash -c 'source /opt/ros/melodic/setup.bash; python /pc-rviz/check-slam.py'
```

当前只启动 SLAM，没有启动 move_base、键盘或手柄控制，也没有下发运动目标。
静止时地图主要覆盖当前位置雷达可见区域；完整建图需要后续受控移动。
gmapping 不一定在机器人静止时持续发布新地图。

## 网络和显示设置

KV260 的 `/home/ubuntu/x3plus-kv260-docker/KV260.env` 已改为：

```bash
export ROS_MASTER_URI=http://192.168.137.60:11311
export ROS_HOSTNAME=192.168.137.60
```

板上 `run-master.sh` 已修复为向 Master 容器传递 ROS_HOSTNAME。
两个活动容器已通过快照重建，保留原来的容器内驱动修复和地图挂载。
地图目录仍为 `/home/ubuntu/x3plus-maps`。

电脑容器采用现有 RViz 容器验证过的 privileged、host network、host IPC
设置，以及 X11 授权文件和 DRI 设备映射。普通隔离设置在此次测试中导致
Qt/D-Bus 初始化退出；调整后窗口正常。尚未单独确认最小必需权限和硬件
OpenGL 加速，不能仅凭窗口打开就认定 GPU 加速生效。

若更换 KV260 IP，两端 ROS 地址和容器环境都需要同步更新；只设置电脑
`KV260_IP` 不会改变板上的配置。ROS 1 需要双方的节点动态端口可达。

## 此次变更的备份

KV260 配置与容器检查结果：
`/home/ubuntu/x3plus-kv260-docker/remote-rviz-backup-20261008-110729/`。

旧容器已停止并禁用自动重启，保留为：

- `x3plus-master-before-remote-20261008`
- `x3plus-robot-before-remote-20261008`

当前容器基于保留可写层的镜像：

- `x3plus:remote-master-20261008`
- `x3plus:remote-robot-20261008`

不要同时启动备份与活动容器，否则会争用 Master 端口或机器人串口。
新 Master/机器人容器设有自动重启；电脑查看器不设自动重启。
板上硬件和 SLAM 是显式启动的进程，重启后需重新启动。