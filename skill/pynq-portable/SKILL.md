---
name: pynq-portable-evidence-workflow
description: Reuse a device-independent classic PYNQ artifact and buffer-contract review with offline preflight and explicit hardware validation limits.
---

# 通用PYNQ工件、缓冲与验收工作流

## 适用场景

经典Zynq/PYNQ的bit+HWH Overlay项目：离线检查工件、明确IP/缓冲/完成语义，再规划受控板测。无需本项目的416×416、YOLO、B3136名称或任何机械臂。不是PYNQ所有平台通用驱动；xclbin-only、部分重配置或厂商扩展先重新确认接口。

## 输入与前置条件

- 用户自己的板卡/器件、系统镜像、PYNQ/驱动/工具版本；缺失写未知。
- 可信构建清单中的bit、HWH与SHA，HWH中预期实例名；不能为消除失败重新计算“预期”哈希。
- 输入/输出shape、dtype、layout、stride、设备地址宽度、容量、对齐、控制寄存器、完成状态与超时策略。
- 当前阶段默认仅离线；板测另需设备独占、可恢复方案、输出目录与明确授权。

## 权威来源

- [官方资料核对与版本边界](/home/amd/kv260-ofdm-reproduction/skill/references/PYNQ_SOURCES.md)
- [本项目实际PYNQ使用源码](/home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/runtime/hardware.py)
- [通用离线工具](/home/amd/kv260-ofdm-reproduction/skill/tools/validate_evidence.py)
- [输入合同](/home/amd/kv260-ofdm-reproduction/skill/references/EVIDENCE_SCHEMAS.md)

## 执行流程

1. **离线工件门禁**：核验来源哈希、同名bit/HWH和预期MODULE实例；只读XML，不导入PYNQ或构造Overlay。
2. **版本/接口表**：确认MMIO或DMA/stream的实际路径；寄存器来自匹配HWH/驱动，不能照抄B3136偏移。实例存在不能证明ABI正确。
3. **缓冲合同**：区分CPU虚拟地址与device_address。需要PL访问的内存按目标PYNQ设备分配，shape/dtype/字节数和对齐来自自己的IP合同，不把项目64字节对齐变成PYNQ普遍要求。
4. **缓存与所有权**：根据coherent/驱动行为确定CPU写→设备读、设备写→CPU读同步；显式记录是否由驱动负责，不能只看NumPy数组已赋值。完成前禁止覆盖/释放缓冲。
5. **控制合同**：确认启动、done/idle/error及超时路径。m_axi+MMIO与AXI DMA不是同一种流程；流DMA另需审核TLAST/长度和收发顺序，不套用MMIO状态位。
6. **板测计划**：只在另行授权后，从小确定性向量开始，比对独立参考，再加边界/异常/连续多次实验。Overlay默认构造可下载bit；download=False也不是可在任何PC安全运行的离线预检替代品。
7. **超时处理**：停止提交新工作，保留缓冲和独占状态；确认硬件完成/受控恢复后才释放。不要在异常finally中无条件free仍在使用的缓冲，不自动重载Overlay。
8. **效果记录**：功能结果、端到端耗时、缓存/搬运、释放/退出、未覆盖分别记录；不从核时钟推加速比。

## 验收与输出

离线输出：工件合同、预检JSON、IP/缓冲所有权表、缺口、板测方案。实机输出只有实际执行后才能填：设备版本、输入/输出SHA、误差、超时/退出证据、重复次数和测时范围。不得将预检成功等同硬件可运行。

## 常见故障

| 触发/观察 | 排查步骤 | 失效边界 |
|---|---|---|
| 换bit后驱动字段不符 | 核对bit/HWH同次构建→实例→寄存器ABI→版本 | 只有同名文件不能判配套 |
| 输出像上一轮 | 核对帧号→完成→所有权→同步→有效长度 | 不能盲目清缓存掩盖竞态 |
| 传输等待不返回 | 确认实际传输路径→错误状态→长度/流边界→时钟复位 | 不凭经验随机写寄存器 |
| 设备超时后内存仍占用 | 确认在途任务与独占→受控恢复计划 | 不能立即free/kill/reload |

这些是源码/官方行为归纳出的排查方法，不是声称四种故障都曾在本项目实机发生。

## 禁止与停止条件

不默认import硬件模块、构造Overlay、allocate、打开设备、写MMIO或重载FPGA。工件来源不明、平台不符、无法确定所有权或超时恢复时停止。用户提供的评分条款在“若提交的Skill面向PYNQ框架”处截断；不推测后续条件，也不承诺取得加分。

## 调用示例

```text
项目绝对路径={自己的项目}；板卡/PYNQ版本={实际值或未知}。
bit/HWH/可信清单={绝对路径}；IP接口与数据合同={引用}。
请按通用PYNQ技能只做离线审查，不import PYNQ、不构造Overlay。
先输出工件一致性、缓冲/同步/完成所有权表和缺口，再生成最小板测计划。
没有实机结果时不得写“上板成功”，不得沿用KV260案例尺寸、地址或性能数字。
```

## 复用方法

复制skill目录、用本机绝对SKILL_ROOT定位；按[合同](/home/amd/kv260-ofdm-reproduction/skill/references/EVIDENCE_SCHEMAS.md)填写自己的JSON并运行`validate_evidence.py pynq`。仅离线预检无需安装PYNQ。板端步骤是供审核的计划，不提供猜测的通用MMIO/驱动代码。

## 已验证效果

[工具测试](/home/amd/kv260-ofdm-reproduction/skill/tools/test_validate_evidence.py)已实际验证合成bit/HWH的正例、篡改/缺文件、不同主干、缺IP、重复IP和DTD拒绝路径；[本轮记录](/home/amd/kv260-ofdm-reproduction/skill/evidence/reuse-validation.json)保存实际运行结果。未执行任何PYNQ分配、Overlay加载、DMA或实机数值测试，尚不能宣称通用板卡兼容或实机性能效果。

本轮还实际对归档B3136的dpu.bit/dpu.hwh运行离线预检：哈希取自原artifacts.sha256，核对image_preprocess_1及yolo_postprocess_1两个实例，退出0。输入见[归档预检合同](/home/amd/kv260-ofdm-reproduction/skill/evidence/pynq-archived-contract.json)。它说明该预检能读取真实归档文件，仍不证明bit/HWH语义、器件兼容或硬件运行。

## 经验来源

[B3136硬件源码](/home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/runtime/hardware.py)可观察到HWH派生偏移、device_address、flush、busy/超时保留缓冲等明确设计；[官方资料](/home/amd/kv260-ofdm-reproduction/skill/references/PYNQ_SOURCES.md)核对默认下载和同步接口。本技能把这些项目观察抽象成合同，不复制应用尺寸、寄存器和安全阈值为通用常量。