---
name: kv260-b3136-vision
description: Audit B3136 vision artifacts, frame and buffer ownership, control updates, approximate depth and safe drain evidence.
---

# KV260 B3136视觉流水线与生命周期

## 适用场景

检查HLS前处理→DPU→HLS后处理→ROS2/显示的配套关系，排查帧槽、增强配置、深度匹配或退出排空。默认离线，不打开相机、不加载overlay。

## 输入与前置条件

- 指定B3136版本及模型/overlay清单，不混用历史OFA/YOLO分支。
- 明确本任务属于离线逻辑、板端观察还是会改变硬件状态的自检。
- 板测必须确认PYNQ/VART/XRT/ROS2/Astra环境、CMA、FPGA独占、相机身份和输出目录。
- 应用默认参数是快照事实，不是对所有负载的性能保证。

## 权威来源

- [运行说明](/home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/README.md)
- [主运行代码](/home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/vision_hls.py)
- [启动包装器](/home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/run_vision.sh)
- [工件SHA清单](/home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/artifacts.sha256)
- [离线参数测试](/home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/test_controls.py)
- [ROS消息检查器](/home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/verify_ros.py)

## 执行流程

1. 先校验artifacts清单，确认模型、bit、HWH、xclbin配套；该清单不覆盖全部运行源码，源码还要对照来源清单。
2. 画出帧所有权：采集、前处理、DPU、后处理、显示/发布各自持有哪一槽；检查完成前不复用DMA缓冲。
3. 核对实际HWH寄存器、缓存同步、连续打包和每尺度fix_point；后处理overflow必须整帧CPU回退。
4. 参数更新只在安全完成点生效；比较requested配置、applied config_id和实际帧内容。默认增强预览不应静默改变DPU输入。
5. 深度输出标记未标定/未配准，记录时间差/有效ROI；时间近似匹配不等于曝光同步，近似距离不转成抓取坐标。
6. 离线运行参数测试后，若获明确板测授权，再按原README审查启动链及self-test副作用。
7. 板测采集时间窗、完成帧数、发布数、队列丢弃、P50/P95统计窗口、各阶段耗时、回退次数和资源变化；不混用窗口统计与全程统计。
8. 退出需同时检查结果状态、CLEANUP_OK、进程退出与资源所有权；DRAINING说明仍在等待，不能解锁后强行重载。

离线命令：

```bash
cd /home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136
sha256sum -c /home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/artifacts.sha256
PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s /home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136 -p 'test_controls.py' -v
```

此处刻意不使用`test_*.py`：同目录有板端增强测试。`--self-test --headless`也会加载overlay，不是离线命令；不能自动执行。

## 验收与输出

- 离线交付：工件校验结果、参数单测日志、源码/模型配套证据、仍未验证的板端条件。
- 板测交付（仅实际执行后）：新日志、实际配置、帧/时间数据、错误及正常退出证据。
- mAP/召回率、加速比、长期耐久性需各自实验，不能从自检或历史FPS推出。
- 发布主题是JSON检测信息，不是图像主题；跨ROS版本桥接另行验收。

## 常见故障

- CMA不足：检查资源占用与残留任务，不降低保护阈值或并发重载overlay。
- 配置已写但画面没变：检查生效config_id、最新帧新鲜度和选择的显示/推理分支。
- SUMMARY成功但进程未退：继续检查排空/ROS/深度子进程，不提前宣布释放。
- 输出错位：检查scale排序、帧绑定、letterbox恢复和深度近似映射。

## 禁止与停止条件

不SIGKILL有在途DMA的主进程、不在DRAINING时重载、不强抢FPGA锁、不把GUI关闭视为推理停止。板端环境缺失或工件不匹配时停止在启动之前。

## 调用示例

使用P3离线检查自己的预览/推理分支、配置生效和退出状态，输出缺口，不访问相机。

## 复用方法

新题目先用通用PYNQ工作流，再按自身流水线画帧/缓冲所有权图；替换模型、分辨率、队列、状态字、性能指标。使用P3记录配置生效、过期帧、超时排空的测试，不能套用原CMA保留量或默认FPS。

## 已验证效果

[历史参数日志](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/vision_controls.log)2项通过，[历史工件日志](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/b3136_artifacts.log)为工件SHA检查。都不证明本轮相机、Overlay、DPU或完整退出已上板验收。

## 经验来源

[运行实现](/home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/vision_hls.py)和[缓冲实现](/home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/runtime/hardware.py)呈现所有权/排空/超时设计，提炼“SUMMARY不是进程退出、配置写入不是当前帧生效”的检查规则；不编造本轮硬件故障。
