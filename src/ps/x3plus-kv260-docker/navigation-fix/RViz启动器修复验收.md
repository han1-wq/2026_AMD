# KV260 / PC RViz 启动器修复验收

## 已修复并同步

- KV260 导航视图与 PC 使用一致的 `navigation.rviz`，包含订阅
  `/navigation/start_pose` 的 `Saved Start Pose` MarkerArray。
- KV260 建图入口改用与 PC 一致的 `slam.rviz`，不再加载镜像内的旧建图配置。
- 两份查看器 launch 增加 `viewer_name` 参数。PC 默认节点为
  `/pc_slam_rviz`、`/pc_navigation_rviz`；KV260 显式使用
  `/kv260_slam_rviz`、`/kv260_navigation_rviz`。
- 板端查看器按模式、配置签名、镜像名称、ROS Master、ROS 地址及显示地址判断复用；
  不一致则只停止并重建查看器，旧版无标签容器也会重建。
- 板端脚本改为后台启动查看器，检查容器仍运行后返回，避免桌面启动器一直占用
  RViz 任务锁而无法切换模式。命令行启动另有短期互斥锁。
- 板端导航启动测试同步为当前 `/navigation_guard/stop` 语义，确认同地图复用
  保留定位，不调用旧的 `/navigation_guard/reset`。

未修改底盘驱动、导航门控生产代码、运动控制参数或机械臂功能。
保存及恢复地图绑定起点仍由 PC 控制台操作；RViz 只显示其标记。
关闭查看器不停止导航，也不撤销已发送的导航目标。

## 自动验证结果

| 检查 | 结果 |
| --- | --- |
| 本机 RViz 配置和模拟 Docker 启动测试 | 17 项通过 |
| 板端同一组 RViz 测试 | 17 项通过 |
| 本机导航启动 / 运行同步测试 | 6 项通过 |
| 板端导航启动 / 运行同步测试 | 6 项通过 |
| 本机控制台和起点功能测试 | 30 项通过，11 项 GUI 测试跳过 |
| 板端脚本 `bash -n` | 通过 |
| 同步的 9 个文件独立回读 SHA-256 | 与本机及安装清单一致 |
| 板端容器内原有 12 个受管运行文件 | 校验通过 |
| 板端实际 ROS `roslaunch --nodes` 解析 | 四个节点名均与上文一致 |

模式切换测试覆盖双向切换、同模式复用、网络变更、配置更新、旧容器迁移、
已退出容器清理、镜像缺失、停止失败、启动后提前退出及非法模式。
这些启动测试使用隔离的 Docker/X11 模拟，不代表真实窗口或 ROS 通信验证。
实际 ROS launch 解析使用断网临时容器，只解析文件，没有启动 RViz 或硬件节点。
测试后板端运行节点仍只有 `/rosout`。

## 证据与备份

- 安装清单：
  `/home/amd/x3plus-kv260-docker/navigation-fix/rviz-launcher-install-result.json`
- 板端测试与运行文件校验日志：
  `/home/amd/x3plus-kv260-docker/navigation-fix/rviz-launcher-board-tests.log`
- 实际 ROS launch 解析日志：
  `/home/amd/x3plus-kv260-docker/navigation-fix/rviz-launcher-launch-parse.log`
- 板端修改前备份及存在性清单：
  `/home/ubuntu/x3plus-kv260-docker/navigation-fix/rviz-launcher-backup-20261021-045129/`
- 本机修改前备份：
  `/home/amd/x3plus-kv260-docker/navigation-fix/rviz-launcher-backup-20261020-214917/`

回滚板端时以备份目录的 `manifest.json` 为准：恢复 `existed: true` 的原文件，
移除 `existed: false` 的新增文件。运行中的查看器需要关闭并重新启动才能加载配置。

## 尚未验证

- 两端真实图形桌面同时打开 RViz，确认不会替换节点，以及建图 / 导航窗口切换。
- 实际地图、激光、机器人模型、起点标记、定位及代价地图的画面与通信。
- 受控硬件 bringup、定位、导航目标门控和停止行为；需另行授权并做好现场安全措施。

本次没有启动底盘或雷达，没有发送导航目标、初始定位或速度指令。