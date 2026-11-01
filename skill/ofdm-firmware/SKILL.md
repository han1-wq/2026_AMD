---
name: ofdm-firmware-build
description: Validate the archived OFDM XSA and exact XSCT software-build contract while keeping JTAG programming outside scope.
---

# OFDM XSA与PS固件构建

## 适用场景

审查PS standalone固件、XSA一致性或在新工作空间构建ELF。不包含重新生成整个OFDM硬件，也不执行program/diagnose等可能接触JTAG的脚本。

## 输入与前置条件

- 已确认的TOP.xsa及SHA、固件副本、2022.1 XSCT位置、新的绝对工作目录。
- board_id与subnet是构建参数，不是本次实际网络已配置的证据。
- 实际Tcl的board_id范围2..254、subnet整数0..255；默认值10和1。以当前参数解析为准。
- 原工程build目录保留历史材料；工作目录必须不存在，不用覆盖开关规避。

## 权威来源

- [构建包装器](/home/amd/kv260-ofdm-reproduction/build/build_ofdm_firmware.sh)
- [原XSCT脚本](/home/amd/kv260-ofdm-reproduction/src/ofdm/eeSDR_ofdm_loopback/firmware/build_dma_sw.tcl)
- [XSA检查器](/home/amd/kv260-ofdm-reproduction/src/ofdm/eeSDR_ofdm_loopback/firmware/check_dma_xsa.py)
- [包内XSA](/home/amd/kv260-ofdm-reproduction/build/projects/ofdm/build_hw/TOP.xsa)
- [原bring-up说明](/home/amd/kv260-ofdm-reproduction/src/ofdm/eeSDR_ofdm_loopback/firmware/DMA_BRINGUP.md)

## 执行流程

1. 阅读包装器与Tcl完整参数传递；确认未调用program_dma或connect等硬件动作。
2. 运行静态XSA检查并记录退出码与DMA_XSA_PASS；检查通过仅说明脚本检查范围内的元数据。
3. 核对XSA中处理器与脚本ps7_cortexa9_0匹配，不因为交付根名称含KV260就把它改成K26处理器。
4. 审查脚本当前平台/domain/lwip配置；tcp_mss、tcp_wnd及link/services缓冲共同决定边界，不能只改一侧追求吞吐。
5. 在获准的软件构建阶段选择新目录，记录XSCT版本、环境、XSA哈希、源码哈希和board/subnet参数。
6. 构建结束后检查退出码、DMA_SOFTWARE_COMPLETE以及实际ELF存在；提取ELF架构/段信息时使用已安装匹配工具，不执行ELF。
7. 记录BSP和编译宏、链接选项及输出哈希；创建ELF与XSA/bit版本配对记录，未配对时不可进入烧录。
8. 硬件全流程缺失入口继续列为阻塞，不用当前软件构建成功覆盖该缺口。

离线检查：

```bash
python3 -B /home/amd/kv260-ofdm-reproduction/src/ofdm/eeSDR_ofdm_loopback/firmware/check_dma_xsa.py /home/amd/kv260-ofdm-reproduction/build/projects/ofdm/build_hw/TOP.xsa
bash /home/amd/kv260-ofdm-reproduction/build/build_ofdm_firmware.sh --help
```

仅允许构建后执行下例；若目录已存在，选择新的经确认路径，不能删旧目录：

```bash
bash /home/amd/kv260-ofdm-reproduction/build/build_ofdm_firmware.sh /home/amd/kv260-ofdm-reproduction/build/output/ofdm_skill_firmware 10 1
```

## 验收与输出

产出环境/输入指纹、完整构建日志、退出码、ELF路径/哈希、宏配置和配套关系。输出文件存在不等于从当前源码构建成功，必须有同一次日志和时间范围。

板卡启动出现DMA ready、UART/TCP/RF回环等属于后续硬件实验，本技能的构建完成记录不得预填这些通过项。

## 常见故障

| 故障 | 处置 |
|---|---|
| Workspace must not exist | 使用新目录，保护历史工程 |
| Missing tool | 记录XSCT缺失，不自动安装/替换全局环境 |
| XSA检查失败 | 核对匹配硬件导出，不注释检查器 |
| BSP/lwip编译异常 | 保存工具版本和完整错误，不改成其他处理器碰碰运气 |
| 只有ELF没有COMPLETE | 可能是旧文件或中途失败，不能算本次通过 |

## 禁止与停止条件

不执行JTAG connect/program/reset、QSPI检查或闪存写入；不批量替换原工程绝对路径；不生成空XSA/ELF来补目录；board_id/subnet不合法时停止，不隐式截断。

## 调用示例

使用P3核对自己的固件包装器、Tcl参数和XSA，输出构建前提，不调用XSCT或JTAG。

## 复用方法

替换XSA、处理器、BSP、工具版本、参数范围和全新输出目录，用P3输出“输入工件→构建→ELF→硬件配套”的独立门禁；不直接复制Zynq-7000处理器名到KV260或自己的器件。

## 已验证效果

[历史XSA日志](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/ofdm_xsa.log)包含DMA_XSA_PASS；[工具检查记录](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/new_tools_checks.json)检查包装脚本。本轮不执行XSCT/JTAG，不能据此认定固件已重建。

## 经验来源

[原Tcl](/home/amd/kv260-ofdm-reproduction/src/ofdm/eeSDR_ofdm_loopback/firmware/build_dma_sw.tcl)固定处理器及参数范围，说明根目录名不能决定硬件架构；[缺口报告](/home/amd/kv260-ofdm-reproduction/report/KNOWN_GAPS.md)区分软件构建与硬件重建缺口。
