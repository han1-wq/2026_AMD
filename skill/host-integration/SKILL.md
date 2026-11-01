---
name: kv260-host-integration
description: Trace launcher modules, vision frame freshness, OFDM returned-file checks and independent service lifecycles without live actions.
---

# 上位机、视觉采集与OFDM跨模块集成

## 适用场景

检查启动器/GUI模块、共享帧、OFDM图片回传、状态显示及停止语义；定位旧路径和缺依赖。不是自动启动所有服务的一键演示。

## 输入与前置条件

- 明确主机/板端角色、要修改的模块和接口，不因同名文件就合并不同工程。
- 区分纯GUI状态、启动服务、采集图像、发送OFDM和实机机器人动作的权限。
- 显示环境、Tk/Pillow/PySerial等依赖按当前代码检查；无DISPLAY时不伪造桌面验证。
- 凭据、SSH目标、旧socket和设备路径必须重新确认，不沿用历史个人配置。

## 权威来源

- [AI视觉与OFDM交接说明](/home/amd/kv260-ofdm-reproduction/src/host/kv260-launcher-ai/AI-VISION.md)
- [启动器核心](/home/amd/kv260-ofdm-reproduction/src/host/kv260-launcher-ai/launcher_core.py)
- [视觉界面](/home/amd/kv260-ofdm-reproduction/src/host/kv260-launcher-ai/launcher_vision_ui.py)
- [视觉截图适配](/home/amd/kv260-ofdm-reproduction/src/host/kv260-launcher-ai/launcher_yolo_capture.py)
- [DMA界面](/home/amd/kv260-ofdm-reproduction/src/host/kv260-launcher-ai/launcher_dma_ui.py)
- [缺失依赖说明](/home/amd/kv260-ofdm-reproduction/report/KNOWN_GAPS.md)

## 执行流程

1. 建立依赖表：入口、导入模块、配置、sudo分发、服务启动脚本、运行状态目录；标出每项是否存在/版本匹配。
2. 追踪按钮到实际命令：打开窗口不应隐式启动推理；停止采集、关闭窗口、安全停止推理、停止全部服务是不同动作。
3. 核对控制请求与运行时applied config_id、原始/增强显示分支、帧序号和新鲜度，避免显示旧帧却标为新结果。
4. 当前视觉截图默认共享画面；JSON检测主题不能当图像主题。显式旧ROS图片兼容模式需单独记录。
5. OFDM发送前应等待实际新帧，保存图片和对应本地元数据；配置、帧与SHA绑定，不发送停止后的遗留画面。
6. 发送成功必须检查实际回传文件校验，而非socket发送完成或UI按钮状态；回传展示不能引用旧路径结果。
7. 审查后台任务取消、失败传播、锁/进程唯一性、日志轮转和有界队列；跨系统停止顺序不得破坏FPGA排空。
8. 测试分纯逻辑/模拟GUI/真实GUI/硬件集成四层。先审查每个test文件的导入和subprocess mock，明确白名单后才运行。

统一软件回归目前只覆盖B3136参数和OFDM主机等明确任务，**没有证明全部启动器测试已重跑**。原validate_vision_live和validate_ofdm_ai_live文件会涉及真实视觉或链路，不作为离线测试调用。

## 验收与输出

- 输出依赖图、按钮→进程/动作映射、端点/消息schema、帧新鲜度与错误状态清单。
- 测试日志必须注明是否有真实显示、是否模拟网络、是否打开硬件及实际覆盖文件。
- 真正端到端验收需要输入截图、对应配置、发送/回传文件SHA、协议完成和UI显示证据；缺哪一段就列哪一段。
- ROS1/ROS2桥接和不同机器部署的权限/路径另列验收，不从本机单测推断可部署。

## 常见故障

| 现象 | 检查顺序 |
|---|---|
| GUI导入失败 | 模块位置→版本→依赖；不拼接另一工程同名文件 |
| 有检测却无法截帧 | JSON主题/图像主题区分→共享帧时间→配置ID |
| UI停止但推理还在 | 按钮语义→实际信号→DRAINING/CLEANUP→进程状态 |
| 图片回传显示旧内容 | 新会话ID→目标替换条件→回传SHA→展示路径 |
| 自动启动失败 | 先查缺失固定入口/sudo分发，不添加宽泛sudoers规则 |

## 禁止与停止条件

不运行live验证、修改系统服务/权限、自动SSH或关闭未知用户进程。共享帧过期、端点不明、资源锁冲突或停止状态未确认时，不开始新推理/传输。

## 调用示例

使用P3只读梳理自己项目的采集→回传→显示接口，列旧帧与失败负例，不启动GUI/板端服务。

## 复用方法

替换服务、消息schema、帧身份、超时和权限；用P3追踪一个按钮到实际进程/设备的路径，再建立采集→发送→回传→显示证据表。接口/服务缺失时记录缺口，不拼接其他项目同名文件。

## 已验证效果

[已知缺口](/home/amd/kv260-ofdm-reproduction/report/KNOWN_GAPS.md)记录启动器依赖等实际归档缺口；[回归矩阵](/home/amd/kv260-ofdm-reproduction/skill/references/VALIDATION_MATRIX.md)不覆盖所有启动器测试。本技能本轮为静态接口审查，不宣称完整GUI或硬件端到端通过。

## 经验来源

[截图适配实现](/home/amd/kv260-ofdm-reproduction/src/host/kv260-launcher-ai/launcher_yolo_capture.py)与[交接说明](/home/amd/kv260-ofdm-reproduction/src/host/kv260-launcher-ai/AI-VISION.md)区分共享帧、JSON检测消息和采集停止语义；提炼“显示存在≠新帧、关闭GUI≠服务退出”的审查步骤。
