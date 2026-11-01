# PYNQ官方来源与适用边界

核对日期：本地2026-10-30（UTC已进入2026-10-31）。以下为官方文档/源码摘意；latest/master并非版本锁，移植时还需核对目标镜像的实际PYNQ版本。本轮只查询公开资料，没有安装库或访问板卡。

源码核对入口为Overlay.__init__：download默认True、调用设备/元数据路径、依据download决定下载；其Note明确同目录同主干HWH。官方网页是外部可变资料，未伪装成已封存版本或本机依赖。

## Overlay行为

经典Overlay默认构造会下载bit，download=False可禁止该次下载；bit/HWH需匹配。即使禁止下载，构造仍涉及设备/元数据，不能等同不导入PYNQ的离线XML预检。官方源码也要求HWH邻接bit且同主干。来源地址：

```text
https://pynq.readthedocs.io/en/latest/pynq_libraries/overlay.html
https://github.com/Xilinx/PYNQ/blob/master/pynq/overlay.py
```

## 缓冲行为

官方allocate文档定义device_address用于设备访问；coherent描述一致性；flush/sync_to_device用于使CPU侧修改对设备可见，invalidate/sync_from_device用于使设备修改对CPU可见。具体驱动是否自动同步需核对其版本，不能将额外同步当性能免费的通用补丁。来源地址：

```text
https://pynq.readthedocs.io/en/latest/pynq_libraries/allocate.html
```

## 与项目观察的对应

[本包hardware.py](/home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/runtime/hardware.py)导入allocate和DpuOverlay、从HWH建立偏移、将device_address交给IP、按阶段flush、超时保持busy与缓冲。这里只证明源码可观察设计，不证明所有错误路径均实机验证。普通AXI DMA与该MMIO路径不能混用。

本技能没有依赖PYNQ作为离线工具的库；官方资料用于审查方法，不表示本机已安装该框架。未收到完整PYNQ评分细则，不推测剩余要求。