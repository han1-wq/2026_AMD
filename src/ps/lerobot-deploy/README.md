# LeRobot CPU 软件环境

## 范围

仅安装软件，不连接相机或串口，不执行标定、遥操作、舵机编号或机器人运动。
本机使用独立 Ubuntu 22.04 Docker；KV260 保留系统，使用独立 Python 3.10 venv。
本项目不修改既有 X3plus、RoArm、视觉服务的环境。

## 固定源码

- 仓库：https://github.com/JoyandAI/lerobot.git
- 提交：`072e8355fbb9a7b520915d44877aa876794efb31`
- 源码声明版本：0.4.3。不是一个已确认存在的 v0.4.3 Git 标签。
- PyTorch 2.8.0 CPU、torchvision 0.23.0、PyAV 15.1.0。
- x86_64 使用 TorchCodec 0.6.0；ARM64 按源码的依赖标记不安装 TorchCodec，默认使用 PyAV。
- 安装基础依赖和 feetech SDK，不安装 SmolVLA/π0 等可选依赖。

## 本机

构建文件：`/home/amd/lerobot-deploy/Dockerfile`。
镜像：`lerobot-cpu:joyandai-0.4.3`。

```bash
/home/amd/lerobot-deploy/run-local.sh
```

此脚本创建临时容器并使用当前用户 UID/GID。数据持久化在
`/home/amd/lerobot-deploy/workspace`，映射为容器的 `/workspace`。
容器不映射相机、串口、Docker socket 或图形桌面。
退出 shell 后临时容器删除，挂载目录的数据保留。

软件自检（含一次随机小模型 CPU 训练更新）：

```bash
/home/amd/lerobot-deploy/run-local.sh python /deployment/validate_environment.py --train --output /workspace/local-validation.json
```

## KV260

安装目录：`/home/ubuntu/lerobot-deploy`。
虚拟环境：`/home/ubuntu/lerobot-deploy/venv`。

在板端终端执行：

```bash
/home/ubuntu/lerobot-deploy/run.sh
```

或直接执行命令：

```bash
/home/ubuntu/lerobot-deploy/run.sh python /home/ubuntu/lerobot-deploy/validate_environment.py --output /home/ubuntu/lerobot-deploy/validation.json
```

不设置开机启动，没有常驻推理或训练服务。默认限制数值库使用 2 个线程。

## 与教程的区别

教程中的 CUDA 参数应替换为 CPU；本机当前为无可见 NVIDIA GPU 的 VMware 环境。
软件环境可用于 CPU 训练，不表示正式 ACT 训练速度足够快。

未照搬教程的 x86_64 Miniconda 安装器到 ARM64。
未配置全局 pip 镜像，也未替换系统 Python。
本机系统 FFmpeg 使用 Ubuntu 22.04 软件源版本，而非教程推荐的 7.1.1；
PyAV wheel 自带另一套 FFmpeg 库。是否可用以视频编解码测试为准，
不能把系统 ffmpeg 命令的版本与 PyAV 的库版本混为一谈。

## 验收范围

`validate_environment.py` 检查 CPU torch、torchvision NMS 扩展、
随机缩小 ACT（单张 64×64 图像）、动作分块推理、模型保存/重载、
视频编码与 LeRobot 默认后端解码。本机另检查反向传播和一次优化器更新。
此测试没有加载训练好的抓取策略，耗时不能代表默认 ACT 或真实机器人表现。

两端已通过验收；最终安装与测试结果见 `/home/amd/lerobot-deploy/STATUS.md`。
完整依赖版本记录位于 `/home/amd/lerobot-deploy/artifacts`。