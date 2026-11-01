# 软件环境部署验收

## 追加：本机模型跨架构迁移验证通过

使用 `/home/amd/lerobot-deploy/verify_transfer.py` 在本机 Docker 对缩小 ACT
进行一次合成数据训练更新，保存 config.json 和 model.safetensors，连同固定输入和
本机参考输出传到 KV260。板端校验所有传输文件的 SHA-256，使用 CPU 严格加载权重。
相同输入的输出最大绝对误差为 `9.201467037200928e-07`，通过
`rtol=1e-4, atol=1e-5` 的一致性检查。
结果记录：`/home/amd/lerobot-deploy/artifacts/transfer-result.json`。

这验证了 x86_64 训练权重到 ARM64 CPU 推理的可移植性，无需重新训练或转换为 ONNX。
正式训练应迁移整个 pretrained_model 目录，包括模型配置、权重、训练保存的预处理/
后处理配置及其归一化统计状态。训练源码 save_checkpoint 已保存这些处理器文件。
板端必须使用相同的输入键、图像处理、状态/动作顺序、单位和归一化规则。
配置加载使用 PreTrainedConfig.from_pretrained，再设置 device='cpu'；
不能直接对带 type 字段的配置调用 ACTConfig.from_pretrained。

本次测试为缩小模型，不验证正式 ACT 在板端的容量、持续运行延迟或实际任务效果；
也未进行 FPGA/DPU 编译或部署。

## 结果：两端通过

本机镜像 `lerobot-cpu:joyandai-0.4.3` 已构建，镜像 ID 和大小记录在
`/home/amd/lerobot-deploy/artifacts/docker-image.json`。镜像约 2.65 GiB。
KV260 环境位于 `/home/ubuntu/lerobot-deploy`，约占 1.7 GiB；验收时板端根分区剩余约 20 GiB。

| 项目 | 本机 Docker | KV260 venv |
|---|---|---|
| 系统/架构 | Ubuntu 22.04 / x86_64 | Ubuntu 22.04 / aarch64 |
| Python | 3.10.12 | 3.10.12 |
| LeRobot | 0.4.3，同一固定源码提交 | 0.4.3，同一固定源码提交 |
| torch | 2.8.0+cpu | 2.8.0+cpu |
| torchvision | 0.23.0+cpu | 0.23.0 |
| PyAV | 15.1.0 | 15.1.0 |
| NumPy | 2.2.6 | 2.2.6 |
| feetech-servo-sdk | 1.0.0 | 1.0.0 |
| 默认视频解码 | TorchCodec 0.6.0 | PyAV |

两端 torch.version.cuda 均为 None；ARM64 torchvision 不带 +cpu 后缀，但实际 NMS 算子与 ACT CPU 推理均通过。

## 已执行的验证

- 两端 `pip check`：无依赖冲突。
- 两端 torchvision NMS 原生扩展测试。
- 两端随机初始化的缩小 ACT：单图 64×64，6 维状态/动作，4 步动作块，CPU 前向推理和有限值检查。
- 两端模型保存、重新加载以及输出一致性检查。
- 两端 PyAV H.264 编码、LeRobot 默认视频后端解码及形状检查。
- 本机额外执行一次训练损失计算、反向传播、AdamW 更新。
- 两端 `lerobot-train --help` 和 `lerobot-record --help` 返回 0。
- 两端 PyAV 均列出 libsvtav1 编码器；未验证实机 AV1 录制性能。
- 原源码工作树无修改，原有本机视觉容器及板端 X3plus 容器保持运行。

测试报告：

- `/home/amd/lerobot-deploy/artifacts/local-validation.json`
- `/home/amd/lerobot-deploy/artifacts/board-validation.json`
- 板端原报告：`/home/ubuntu/lerobot-deploy/validation.json`

缩小 ACT 的三次动作块计算：本机约 6–7 ms，板端约 104 ms。
测试进程峰值 RSS：本机约 685 MiB，板端约 536 MiB。
以上包含测试脚本的加载/保存/视频测试开销；不代表默认 ACT、实际训练模型、
高分辨率、多相机或持续控制任务的速度及内存需求。

## 安装过程中解决的问题

- 官方 PyPI 下载缓慢：LeRobot 依赖安装使用命令级清华镜像，没有修改全局 pip 配置。
- 本机 evdev 编译缺 Python.h：仅在新 Docker 镜像增加 python3-dev 后重建成功。
- 板端不安装不受该源码支持的 TorchCodec，使用仓库已有 PyAV 回退，无源码补丁。
- ARM64 torchvision 提示未来删除旧视频 API；当前固定 0.23.0 验证通过，不应直接升级到 0.24+。

## 可复现记录

固定代码提交：`072e8355fbb9a7b520915d44877aa876794efb31`。
主要版本约束位于 `/home/amd/lerobot-deploy/constraints.txt`。
完整解析后的版本记录在 `/home/amd/lerobot-deploy/artifacts/local-pip-freeze.txt`
及 `/home/amd/lerobot-deploy/artifacts/board-pip-freeze.txt`。
另有去除 editable 源码路径的 `local-dependencies.lock.txt` 和 `board-dependencies.lock.txt`，
重建时可作为各自架构的 constraints 文件使用；CPU torch 仍应从官方 CPU wheel 索引预装。
Dockerfile 固定核心版本，但未将所有传递依赖和 apt 包固定，因此未来直接重建可能解析出不同版本；
当前已构建镜像和完整版本记录才是此次验收对象。

没有真实数据集训练、预训练权重下载、相机接入、串口访问、标定、舵机设置、机器人运动或开机自启。
本机启动脚本不映射硬件，后续硬件接入必须单独配置。