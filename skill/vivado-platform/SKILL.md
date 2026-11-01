---
name: kv260-vivado-platform
description: Audit archived Vivado and Vitis platform integration, AXI ownership, clocks, resets and report provenance before any build or hardware action.
---

# Vivado / Vitis平台与IP集成交接

## 适用场景

判断现有XPR/BD/IP/约束是否足以恢复工程；规划前后处理核加入DPU平台；审查综合、实现、时序和接口报告。不是“打开工程即重新构建”的技能。

## 输入与前置条件

- 指定平台快照、目标器件、工具版本、计划新增IP及允许改动的工作副本。
- 明确采用Vivado IP/MMIO路径还是Vitis kernel/XRT路径；不能重复拥有同一硬件实例。
- 先检查工程绝对路径和裁剪排除项；缺IP、DCP或工具许可证时先记录阻塞。
- 需要重建时保存现有工程快照和历史报告；不可直接覆盖封存结果。

## 权威来源

- [平台材料](/home/amd/kv260-ofdm-reproduction/src/kv260/dpu_platform2/)
- [前处理平台设计](/home/amd/kv260-ofdm-reproduction/src/kv260/dpu_platform2/IMAGE_PREPROCESS_HLS_DESIGN.md)
- [BD插入脚本](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/image_preprocess/scripts/integrate_bd.tcl)
- [集成验证脚本](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/image_preprocess/scripts/validate_integration.tcl)
- [报告索引](/home/amd/kv260-ofdm-reproduction/build/reports/INDEX.csv)
- [旧路径索引](/home/amd/kv260-ofdm-reproduction/report/absolute_path_references.csv)
- [缺口说明](/home/amd/kv260-ofdm-reproduction/report/KNOWN_GAPS.md)

## 执行流程

1. 读取工程文件集、顶层、BD、IP版本与约束；记录每个依赖是否实际存在，而不是只看XPR文件存在。
2. 对照工程元数据与实际PS配置：接口标记“可用”不等于已启用；插入前确认HP端口和互连槽位占用。
3. 为每个AXI主/从接口记录数据宽度、地址宽度、burst、时钟域、复位来源、地址范围和访问方。
4. 前处理插入脚本对特定cell名称/时钟/复位有假设，且不是可重复无害运行；先静态审查，禁止对已插入BD再执行。
5. 检查控制MMIO、内存映射、IRQ或polling方案与软件驱动一致；避免同时由MMIO和XRT调度。
6. 经构建授权后分阶段进行：BD验证→IP生成→综合→实现→时序/DRC/CDC检查。失败停在当前阶段，不继续导出误导性工件。
7. 同时检查setup/hold、约束覆盖、未约束路径、CDC/复位问题及资源占用；不能仅取一个正WNS宣布闭环。
8. 每次导出把XSA、bit、HWH、xclbin（如果该路径使用）、驱动寄存器头、模型指纹配成版本集合。

本技能不列“猜测的一键构建命令”。先从[构建索引](/home/amd/kv260-ofdm-reproduction/build/scripts/INDEX.csv)定位实际脚本，并审查其source路径、reset/delete/open操作与输出目录。已有XPR不补齐缺失的OFDM根级构建Tcl。

## 验收与输出

- 输出[集成交接表](/home/amd/kv260-ofdm-reproduction/skill/templates/INTEGRATION_HANDOFF.md)，包含时钟/复位/内存/控制所有权和缓冲生命周期。
- 输出构建阶段、命令、工具版本、run状态、报告路径/哈希与阻塞原因。
- HLS的5 ns调度目标、孤立综合报告和整平台布局布线证据分开描述。
- 导出Vivado IP ZIP不是生成有效`.xo`；只有实际kernel元数据及平台路径核对后才能规划v++链接。

## 常见故障

| 现象 | 处理 |
|---|---|
| XPR能打开但缺文件 | 根据来源清单与排除清单定位；不创建空IP骗过检查 |
| HP端口已占用 | 审查共享互连/带宽/时钟方案，不强行覆盖既有连接 |
| BD通过、实现失败 | 追查拥塞、时钟约束、资源与DRC，不将BD通过当时序通过 |
| 软件访问挂起 | 核对地址/时钟/复位/ABI；不随机写寄存器探测 |
| 历史报告版本不清 | 标记imported且无法绑定当前源码，不用于当前验收 |

## 禁止与停止条件

禁止隐式reset_run、删除工程、升级全部IP、导出/加载bitstream或板卡复位。缺约束、来源不明或正在运行的硬件资源未释放时停止。此阶段不需要也不运行机器人服务。

## 调用示例

使用P2只读梳理自己的IP、AXI/时钟/复位接口及缺失依赖，输出重建阶段，不启动综合。

## 复用方法

使用P2，替换器件、项目文件、时钟、约束、资源预算和报告SHA；先生成AXI/时钟/复位/所有权表。检查器qor只用于人工转录的implemented数据；不把原插入Tcl直接运行到新BD。

## 已验证效果

[原打包摘要](/home/amd/kv260-ofdm-reproduction/report/PACKAGING_SUMMARY.md)明确未调用完整FPGA工具链。本技能效果限定为依据[集成Tcl](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/image_preprocess/scripts/integrate_bd.tcl)识别依赖/假设，不宣称综合、实现或时序闭合。

## 经验来源

[集成脚本](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/image_preprocess/scripts/integrate_bd.tcl)有固定cell和接口假设，[缺口报告](/home/amd/kv260-ofdm-reproduction/report/KNOWN_GAPS.md)记录重建依赖缺口，故提炼“文件存在≠可重建、BD通过≠实现通过”。不是未经记录的实现失败案例。
