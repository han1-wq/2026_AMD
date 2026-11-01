---
name: kv260-lerobot-act
description: Trace the pinned LeRobot CPU environment and distinguish reduced random ACT checks, dataset readiness, trained policies and unimplemented accelerators.
---

# LeRobot / ACT环境、数据与模型证据

## 适用场景

核对LeRobot源码版本/本地补丁、CPU依赖、模型保存重载与数据准备；规划正式ACT实验。不能把小随机模型自检当作训练好的抓取策略或DPU部署。

## 输入与前置条件

- 明确环境检查、数据审计、训练、推理或加速设计中的哪一项被授权。
- 需要记录源码提交与本地差异、解释器/架构、依赖锁定、模型/数据版本及输出目录。
- 模型下载、容器构建、训练和修改现有venv均不属于默认文档/审计操作。
- 数据中的相机、动作维度、单位、频率、标定与设备身份必须说明，不从其他机械臂复制。

## 权威来源

- [项目README](/home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/README.md)
- [软件环境检查实现](/home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/validate_environment.py)
- [锁定依赖与历史环境证据](/home/amd/kv260-ofdm-reproduction/build/environment/lerobot/)
- [版本与本地差异记录](/home/amd/kv260-ofdm-reproduction/report/repository_revision.json)
- [工作数据归档](/home/amd/kv260-ofdm-reproduction/data/lerobot/workspace/)
- [已知缺口](/home/amd/kv260-ofdm-reproduction/report/KNOWN_GAPS.md)

## 执行流程

1. 将版本拆成commit、源码声明版本、本地修改三项。归档记录的0.4.3不是已确认Git标签；dirty文件也不是上游原版。
2. 对齐CPU环境与架构。原环境说明区分x86_64 TorchCodec与ARM64 PyAV路径；不要在新机器直接照抄不匹配wheel。
3. 阅读validate_environment完整实现，确认导入/写入/训练/保存/视频编解码范围及参数，再决定运行。
4. 环境验证至少区分：CPU torch可用、torchvision扩展、ACT小模型前向、保存重载、编解码；可选反向更新是另一项，不等于正式训练。
5. 检查数据集schema、episode边界、采样率、时间对齐、动作单位、观察维度、相机身份、标定、训练/验证分割和授权。
6. 正式策略实验须明确真实数据、完整模型配置、随机种子、优化配置、资源预算、恢复点和非实机评估指标；没有数据时输出缺口，不制造训练曲线。
7. 若讨论ACT→DPU，先列算子/动态shape/量化/host-device切分及误差验证需求；本包不提供“已完成ACT-DPU”的承诺。
8. 向遥操作/机械臂交接时提供动作空间与归一化合同；CPU推理成功不能直接接入舵机运动。

本技能不提供未经当前环境审查的安装/训练命令。先打开上述验证脚本和依赖证据；对已有venv只做只读检查，另建环境必须有对应授权与路径。

## 验收与输出

- 环境审计输出版本/架构/锁文件哈希、当前可用与缺失模块，以及本地补丁说明。
- 模型验证输出模型配置/输入维度、随机权重或已训练权重标识、输入输出摘要、保存重载结果和耗时边界。
- 数据审计输出可用episode数、缺失项、分割/同步/单位检查，未知项不写0充数。
- 训练完成、闭环成功和DPU加速是不同交付物，必须各有真实日志和验收。

## 常见故障

- 视频导入失败：区分系统ffmpeg版本与PyAV链接库，不以命令版本替代库测试。
- NMS扩展不可用：检查torch/torchvision/架构匹配，而不是跳过检查宣布环境可用。
- 只有小模型权重：标记随机缩小自检工件，不能宣传已训练抓取能力。
- 源码与commit不一致：保留本地补丁身份和文件哈希，不重置原工程。

## 禁止与停止条件

不自动pip安装到系统/现有venv、不下载未知权重、不在真实机器人上试策略、不把设备标定当通用数据。未核实数据、动作单位或模型来源时停止训练/部署结论。

## 调用示例

使用P1/P3区分自己材料的环境自检与正式训练效果，列数据/模型/动作单位缺口，不训练或连接机器人。

## 复用方法

替换框架版本、动作维度、观察相机、采样率、数据授权和训练/部署目标。用P1/P3分开环境验证、随机小模型、正式训练、离线评估与闭环；没有真实数据/动作单位时不规划运动实验。

## 已验证效果

[环境脚本](/home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/validate_environment.py)可观察到缩小随机ACT和保存/重载、可选反向更新；本轮只审查实现，不重跑环境或训练。[回归矩阵](/home/amd/kv260-ofdm-reproduction/skill/references/VALIDATION_MATRIX.md)没有把它列为已跑业务项；不能宣称训练成功或抓取能力。

## 经验来源

[脚本备注](/home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/validate_environment.py)明确64×64随机缩小模型不是实机性能保证，[版本记录](/home/amd/kv260-ofdm-reproduction/report/repository_revision.json)区分提交/本地变更。由此提炼“环境自检≠已训练策略”的证据分层。
