---
name: kv260-x3plus-navigation
description: Validate the archived ROS1 navigation bundle and offline behavior while separating ARM64 deployment, ROS2 bridging and motion risks.
---

# X3plus ROS1导航与部署审查

## 适用场景

整理ARM64 Docker上下文、检查导航离线行为、定位启动器依赖和质量联锁。此技能不自动启动底盘、雷达、SLAM、导航或机械臂。

## 输入与前置条件

- 指定源码副本、目标CPU架构、容器镜像来源和是否允许构建/联网。
- 真实部署须提供设备稳定路径、地图、网络/ROS主机配置、现场安全与停机办法。
- 不用旧README中的IP、用户或设备名作为当前事实。
- 依赖NumPy的离线测试与容器构建是两个阶段，测试通过不证明ARM64镜像能运行。

## 权威来源

- [部署原文](/home/amd/kv260-ofdm-reproduction/src/ps/x3plus-kv260-docker/README-KV260.md)
- [Dockerfile](/home/amd/kv260-ofdm-reproduction/src/ps/x3plus-kv260-docker/Dockerfile)
- [部署包检查脚本](/home/amd/kv260-ofdm-reproduction/src/ps/x3plus-kv260-docker/verify-bundle.sh)
- [离线导航测试目录](/home/amd/kv260-ofdm-reproduction/src/ps/x3plus-kv260-docker/navigation-fix/)
- [驱动初始化](/home/amd/kv260-ofdm-reproduction/src/ps/x3plus-kv260-docker/context/src/yahboomcar_bringup/scripts/Mcnamu_X3plus.py)
- [导航launch](/home/amd/kv260-ofdm-reproduction/src/ps/x3plus-kv260-docker/context/src/yahboomcar_nav/launch/yahboomcar_navigation.launch)
- [缺口与风险](/home/amd/kv260-ofdm-reproduction/report/KNOWN_GAPS.md)

## 执行流程

1. 核对Docker上下文和公钥例外；固定哈希证明与归档一致，不证明仓库密钥当前有效或在线构建必成功。
2. 区分amd64主机验证和aarch64板端构建；不把VM的对象文件/共享库复制为板端产物。
3. 检查离线导航测试列表和导入路径；只能执行现有审查范围，不扩展到全部ROS源码测试发现。
4. 建立启动依赖图：主服务/容器、底盘雷达驱动、SLAM或定位、导航、RViz。每个硬件驱动只能有一个所有者。
5. 明确容器启动和驱动初始化的差异：原run-robot容器启动不等于立即运动，但包含特权与设备映射，仍不是离线检查；驱动构造会下发机械臂初始姿态。
6. 审查quality_interlock当前默认false及enable_multipoint默认false；显式记录实际值，不声称已有严格默认质量停车保护。
7. 启动器缺launcher-env.sh、launcher_core.py、launcher_network.py等依赖时按实际文件核查；不要从另一个项目静默拼同名模块。
8. ROS1导航与ROS2视觉必须单独定义桥接消息、时间戳/坐标系、失效/超时行为；目录共存不等于桥接实现。

离线命令（先确认python3有NumPy）：

```bash
cd /home/amd/kv260-ofdm-reproduction/src/ps/x3plus-kv260-docker
bash /home/amd/kv260-ofdm-reproduction/src/ps/x3plus-kv260-docker/verify-bundle.sh
env -u DISPLAY -u PYTHONPATH PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s /home/amd/kv260-ofdm-reproduction/src/ps/x3plus-kv260-docker/navigation-fix -p 'test_*.py' -v
```

## 验收与输出

输出部署上下文校验、导航单测日志、目标架构、启动依赖图和未解决模块列表。实机验收另需地图/定位、传感器时间/坐标、速度命令来源及停车证据；此文档不预设成功。

外部依赖下载、密钥有效性、基础镜像可用性未在线验证时明确写未验证。原历史部署报告只能作为参考。

## 常见故障

- 容器可启动但模块缺失：核对上下文、镜像版本和启动器路径，不直接重装整个ROS环境。
- 里程计/雷达错乱：检查设备身份、串口独占和帧名，而非立即调导航参数。
- 导航质量差但不停车：核对联锁实际配置和实现覆盖，不把false解释为已启用。
- ROS2看不到ROS1主题：先确认桥接是否存在，不只反复更改ROS_DOMAIN_ID。

## 禁止与停止条件

禁止自动启动硬件节点、发送cmd_vel、初始姿态、标定或修改串口权限/特权配置。来源模块版本不明、急停未确认或质量状态未知时不得进入运动阶段。

## 调用示例

使用P3核对自己的导航依赖、初始化动作和联锁默认值，输出部署阻塞，不启动容器/驱动。

## 复用方法

替换底盘、架构、ROS版本、容器依赖及设备身份；用P3审查入口到设备写入的实际调用链。离线测试/上下文检查与真实导航分开；未确认驱动初始化动作或急停就停止部署。

## 已验证效果

[历史导航日志](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/navigation.log)96项通过；[上下文检查日志](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/x3plus_bundle.log)记录原部署文件检查。未证明新机器镜像构建、ROS桥接或安全停车。

## 经验来源

[驱动构造](/home/amd/kv260-ofdm-reproduction/src/ps/x3plus-kv260-docker/context/src/yahboomcar_bringup/scripts/Mcnamu_X3plus.py)能观察到初始姿态下发，[launch](/home/amd/kv260-ofdm-reproduction/src/ps/x3plus-kv260-docker/context/src/yahboomcar_nav/launch/yahboomcar_navigation.launch)显示quality_interlock默认false；由源码事实提炼“启动不是无动作、默认联锁需核对”，不声称发生过事故。
