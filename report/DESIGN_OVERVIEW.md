# 设计资料导览

本报告根据本次可见目录和原设计资料整理模块关系，不新增硬件性能结论。原文入口及原始文件路径见 `design/INDEX.csv`。

## OFDM

主路径：Host UART/TCP → Zynq PS协议/SG-DMA → OFDM TX/RF → OFDM RX/校验 → DMA/PS → Host。

RTL在 `src/ofdm/eeSDR_ofdm_loopback/rtl/`，PS固件在 `firmware/`，主机在 `host/`。原 `工程设计与实现报告.md`、`系统详细流程图.md` 和协议文档保留。现有XSA内容检查和RTL/C测试不证明实际射频链路、时序收敛或当前烧录版本匹配。硬件全流程重建脚本仍有缺口。

## KV260视觉

主路径：采集 → HLS前处理 → DPU B3136 → HLS后处理 → ROS2/显示。

`src/kv260/HLS_IP/` 存两个HLS核、主机配置与测试；`src/kv260/dpu_platform2/` 保存平台资料；`src/ps/kv260_B3136/` 保存运行程序。模型和overlay分别归类到 `data/models/`、`board/artifacts/`，运行目录通过包内链接保持原布局。历史OFA/YOLO分支单独保存，不默认混用指纹、模型或寄存器ABI。

## 导航与PS

`src/ps/x3plus-kv260-docker/` 包含ARM64 ROS1 Docker上下文、底盘/雷达/导航驱动与PC工具。离线导航测试、部署包文件检查已运行；没有重建Docker或验证实际导航。

驱动初始化中的机械臂姿态设置、导航默认质量联锁关闭等风险已在源码中定位，见 `safety_source_evidence.json`。ROS1导航与ROS2视觉间的桥接不因归档而获得实现。

## 机械臂与上位机

- `src/ps/lerobot-deploy/`：固定LeRobot源码、CPU环境描述、SO101协议与UI；缩小ACT验证和历史标定数据单独归档。
- `src/ps/roarm_ws/`：ROS2/MoveIt工作区。
- `src/host/roarm-vision-console/`：图像、编码器反馈、受限动作调度与已有技能文档。
- `src/host/kv260-launcher-ai/`：桌面启动器、视觉控制、OFDM/DMA交互相关模块。

本次仅运行明确白名单的软件测试。不声称正式ACT策略已训练、ACT已映射DPU、Spartan-7执行工程已完成，或双臂闭环控制已验收。

## 资料等级

| 等级 | 含义 | 示例 |
|---|---|---|
| 本次文件检查 | 文件存在、哈希匹配、链接完整 | `verification.json` |
| 本次软件验证 | 当前交付副本运行，保存命令与退出码 | `sim/results/packaging-validation/` |
| 历史实验记录 | 原样导入，未在本次重新执行 | `board/results/imported/` |
| 设计/待补齐 | 原报告陈述、代码可见能力或未闭合依赖 | `KNOWN_GAPS.md` |

严禁把这些等级相互替代。原文中的“已通过”仅代表原文描述的历史阶段；验收应按当前板卡、固件、环境、配置和真实日志重新建立证据。