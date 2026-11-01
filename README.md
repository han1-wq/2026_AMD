# KV260 / OFDM / 机器人软硬件复现交付包

本目录将本机已有 KV260 视觉加速、OFDM 通信、导航、机械臂与上位机工程分类归档。原始工程不移动、不修改。整理基准：2026-10-30。

**这是带来源清单和实际软件测试结果的交付快照，不是整机“一键构建、烧录并运动”的认证版本。** 缺失依赖、旧路径和未实现功能见 `report/KNOWN_GAPS.md`。

## 目录结构

| 目录 | 内容 |
|---|---|
| `src/` | KV260、OFDM、PS 软件和上位机源码；保留各工程内部布局 |
| `sim/` | 仿真、软件验证入口、原有验证材料及本次打包检查结果 |
| `build/` | 构建脚本、工程快照、综合/实现报告及打包工具 |
| `board/` | 上板工件、部署/运行脚本、原有板测输出 |
| `data/` | 测试向量、参考结果、模型及数据索引 |
| `skill/` | 通用协作/PYNQ技能、12个项目案例、可复制提示词/模板、数值/资源/工件校验与来源证据；保留原技能 |
| `report/` | 设计报告、来源清单、已知缺口和本次协作记录 |

## 1. 源码位置

```text
src/
├── kv260/
│   ├── HLS_IP/                  # 前处理、后处理与时序优化实验
│   └── dpu_platform2/           # Vivado/Vitis 平台、BD、约束与DPU相关工程
├── ofdm/
│   └── eeSDR_ofdm_loopback/     # RTL、板级约束、IP、PS固件和主机程序
├── ps/
│   ├── kv260_B3136/             # HLS+DPU RGB-D视觉运行程序
│   ├── x3plus-kv260-docker/     # ROS1导航、底盘、Docker及PC工具
│   ├── lerobot-deploy/          # ACT CPU环境、SO101协议与遥操作UI
│   ├── roarm_ws/                # RoArm ROS2/MoveIt工作区
│   ├── kv260_ofa_yolo_deploy/   # 历史视觉分支，不能与B3136工件混用
│   └── kv260_yolo_ros/          # 其他视觉部署与ROS源码
└── host/
    ├── kv260-launcher-ai/       # 图形启动器、视觉调节及OFDM联动
    └── roarm-vision-console/    # 上位机视觉/编码器控制台
```

OFDM 上位机位于 `src/ofdm/eeSDR_ofdm_loopback/host/`；导航 PC 控制台与 RViz 配置位于 `src/ps/x3plus-kv260-docker/pc-console/`、`remote-rviz/`。为避免拆散依赖，没有将它们强行移出原工程。

构建输出、模型、日志等使用**包内相对软链接**保留原工程视图，没有链接回原始 `/home/amd/...` 工程。各分类目录中的 `INDEX.csv` 给出入口、真实文件和原始来源；不要将链接数量当成独立源码数量。

## 2. 先验证交付包

Linux 开发机执行：

```bash
cd /home/amd/kv260-ofdm-reproduction
sha256sum -c /home/amd/kv260-ofdm-reproduction/report/SHA256SUMS
python3 -B /home/amd/kv260-ofdm-reproduction/build/verify_delivery.py
```

第二条命令重新检查原样复制文件与来源清单、包内链接和常见敏感文件，并写 `report/verification.json`。如原工程仍在本机，可加 `--compare-originals`，会只读比较原文件，不修改它们。

全包 SHA 清单不包含它自身、全包 JSON 清单及会更新的验证报告/日志，具体见 `verification.json`。后续测试、构建或修改会使旧清单不再代表当前目录；只有审查变更后才使用 `--seal` 重新封存，不应靠重新封存掩盖异常。

## 3. 无硬件软件回归

依赖：Linux、Bash、Python 3、NumPy、Icarus Verilog (`iverilog`/`vvp`)、C 编译器 (`cc`)、`sha256sum`。GUI测试在没有显示环境时会跳过。完整 GUI/UART 使用还需 Tk、Pillow、PySerial；本次协议单元测试没有打开真实串口。

本机已验证命令（使用已有 NumPy 环境，不把其虚拟环境复制进交付包）：

```bash
python3 -B /home/amd/kv260-ofdm-reproduction/sim/run_software_checks.py \
  --python /usr/bin/python3 \
  --numpy-python /home/amd/roarm-vision-console/.venv/bin/python
```

在另一台机器上，将 `--numpy-python` 替换为实际安装 NumPy 的解释器；如同一个解释器已满足依赖，只需 `--python`。默认输出到新的 `sim/results/<UTC时间>/`，包含各命令、工作目录、退出码、耗时、日志和 `summary.json`。

回归只执行：OFDM主机协议、视觉控制、导航离线测试、SO101模拟协议、HLS主机配置、工件哈希、XSA检查和5组DMA RTL/C测试。不会调用串口、相机、SSH、FPGA编程或实机运动入口。

本次结果固定保存在 `sim/results/packaging-validation/`。不要用 `--output` 覆盖它；输出目录已存在时脚本拒绝执行。

## 4. 构建入口

### 4.1 HLS（开发机，工具版本2022.1）

先做C仿真：

```bash
bash /home/amd/kv260-ofdm-reproduction/build/build_hls.sh image_preprocess csim
bash /home/amd/kv260-ofdm-reproduction/build/build_hls.sh yolo_postprocess csim
```

完整阶段（C仿真、综合、协同仿真、IP导出）：

```bash
bash /home/amd/kv260-ofdm-reproduction/build/build_hls.sh image_preprocess all
bash /home/amd/kv260-ofdm-reproduction/build/build_hls.sh yolo_postprocess all
```

默认工具路径 `/tools/Xilinx/Vitis_HLS/2022.1/bin/vitis_hls`，可用 `VITIS_HLS` 覆盖。输出通过相对链接写入 `build/hls/`。这会修改交付副本中的构建结果；需要保留归档证据时先复制整个包到新的工作目录再构建。本次未执行 Vivado/HLS 综合和实现。

### 4.2 OFDM固件（开发机）

```bash
bash /home/amd/kv260-ofdm-reproduction/build/build_ofdm_firmware.sh \
  /home/amd/kv260-ofdm-reproduction/build/output/ofdm_sw_new 10 1
```

目标工作目录必须不存在。默认 XSCT 为2022.1，可通过 `XSCT` 覆盖。使用包内 `TOP.xsa`，运行原 `build_dma_sw.tcl`，不执行JTAG。成功标志为 `DMA_SOFTWARE_COMPLETE`。

### 4.3 KV260平台和Docker

- 原 Vivado/Vitis工程在 `src/kv260/dpu_platform2/`；原构建脚本与报告索引在 `build/scripts/`、`build/reports/`。
- OFDM现有硬件工程在 `build/projects/ofdm/build_hw/`；完整从RTL重建入口缺口见报告，不能把保留了XPR等同于全流程已可重现。
- X3plus、LeRobot的Dockerfile保留在各自源码根目录，亦可从 `build/scripts/` 浏览。
- 分类链接是**浏览索引**，不保证经链接路径直接执行原脚本时 `__file__`/`BASH_SOURCE` 正确；请使用本节包装脚本或 `src/` 中的原工程入口。

## 5. 上板交付与验证

本次没有连接或操作任何硬件。`board/projects/` 是原工程入口，`board/artifacts/` 是可见配套工件，`board/results/imported/` 是历史记录。

### 5.1 传输注意

整体传输可使用保留相对链接的 `rsync -a` 或 `tar`。**只传某个子项目时要解引用包内链接**，否则其 `overlay/`、`compiled/` 等会指向不存在的上级路径。示例仅在用户确认板端地址、目录与覆盖范围后执行：

```bash
# 先把 KV260_HOST 设置为此次实验实际SSH目标，不内嵌密码。
: "${KV260_HOST:?请先设置板端SSH目标}"
rsync -aL /home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/ \
  "$KV260_HOST:/home/ubuntu/kv260_B3136/"
```

不要无差别对整个包使用 `-L`：分类索引会产生大量重复内容。

### 5.2 视觉板端顺序

1. 具备匹配的PYNQ/VART/XRT、ROS2 Humble和Astra环境；本包不含完整系统安装镜像。
2. 在板端工程目录执行 `sha256sum -c artifacts.sha256`。
3. 停止其他FPGA应用，人工确认后运行 `run_vision.sh --self-test --headless`；该操作会加载overlay。
4. 按原README进行相机/ROS2验证，保存新输出到独立目录。
5. 看到 `CLEANUP_OK` 并确认进程退出；`DRAINING`时不强杀主进程或重载overlay。

### 5.3 导航与机械臂

- 导航启动器依赖尚缺，停止在缺口处，不通过删校验绕过。
- X3plus驱动初始化会下发机械臂初始姿态；先确认空间、设备身份、串口独占、动力和急停条件。
- SO101先运行模拟协议测试，再按真实设备身份完成标定与只读探测；运行密钥需重新生成。
- RoArm、SO101、X3plus控制协议不能互换；设备标定不能跨设备照搬。
- `quality_interlock=false`是原导航默认值；近似RGB-D深度不是精确抓取坐标。
- ACT-DPU、Spartan-7双臂控制及ROS1/ROS2闭环桥接不在已完成承诺范围。

## 6. 报告、数据和授权

- `report/PACKAGING_SUMMARY.md`：本次交付数量和实际验证摘要。
- `report/source_manifest.csv`：原文件路径、交付路径、大小、SHA-256。
- `report/source_inventory.json`：11个来源、已知提交与本机环境。
- `report/excluded_files.json`：凭据、缓存、归档、失效链接等排除原因。
- `report/absolute_path_references.csv`：旧绝对路径审查索引，原源码没有被批量替换。
- `report/design/`：设计报告、原README、协议和原历史结论索引。
- `report/COLLABORATION_LOG.md`：本次协作摘要，不冒充完整历史聊天导出。
- `skill/`：总调度与12个项目专题技能，覆盖HLS前后处理、平台、OFDM/DMA/固件、视觉、导航、ACT、SO101、RoArm及上位机；附验证矩阵、排障、交接模板及结构校验器。入口为 `/home/amd/kv260-ofdm-reproduction/skill/README.md`；不构成自动运动授权，也不代表已安装到IDE。

旧日志、失败记录和早期版本均按来源保留；历史通过不代表本次实机通过。原始报告日期、旧模型名称等也按原文保留，有冲突时以当前代码和可追溯证据为准。第三方源码、SDK、模型、截图和设备数据公开发布前需另外检查许可证及隐私。