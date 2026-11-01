# 两个视觉 HLS 核的基础平台集成

工程：`/home/amd/Workspace/dpu_platform2/kv260_hardware_platform/kv260_hardware_platform/kv260_hardware_platform.xpr`

两个核已实际写入该工程的 `kv260_hardware_platform.bd`，使用已优化的 HLS 导出。
IP 快照位于工程内的 `ip_repo/vision`，XPR 使用相对路径引用，不依赖临时 HLS build 目录。
`ip_snapshot_sha256.json` 记录全部 294 个快照文件的校验值；上游两个产物清单也已保存。

## 2026-10-14 最新核更新

两个核的本地 IP 快照已替换为
`/home/amd/Workspace/HLS_IP/timing_extreme_20261014/candidate/` 中通过验证的导出：
image_preprocess 211 个文件，yolo_postprocess 83 个文件。接口、寄存器地址、
中断、复位和标称 200 MHz 时钟保持原配置。版本 VLNV 仍为 1.0，具体修订
以完整 SHA-256 清单为准。

`update_latest.tcl` 刷新 IP catalog、升级两个 BD 实例、重新生成输出文件和
wrapper，并将 synth_1/impl_1 标记为需要刷新。`latest_update_status.json`
记录更新与验证状态；`reports/latest_20261014/` 保存报告。
备份位置记录在 `latest_backup_path.txt`，包含更新前 XPR、完整 sources、
两个 IP 快照和原校验清单。

本轮只更新工程，不重新生成 bitstream 或 XSA。原有实现报告及 XSA 仍属于
旧核，必须重新综合、实现和导出硬件后才能部署最新核。独立候选工程的
已验证结果为全局 setup WNS +0.157 ns、hold WHS +0.010 ns；这不是本工程
更新后重新实现的结果。详细证据见候选目录的 README.md 和 comparison.json。

更新时检测到已有 Vivado GUI 会话打开此工程。请关闭并重新打开工程，载入
磁盘上的最新版本；避免从旧会话保存工程或 BD 覆盖此次更新。

## 连接

| 项目 | 连接 |
| --- | --- |
| 两个核、读写 SmartConnect、HP2/HP3 AXI 时钟 | `clk_wiz_1/clk_out3`，标称 200 MHz |
| 核低有效复位 | `proc_sys_reset_2/peripheral_aresetn` |
| SmartConnect、控制接口低有效复位 | `proc_sys_reset_2/interconnect_aresetn` |
| image_preprocess 控制 | `ps8_0_axi_periph/M01_AXI`，`0x86000000`，64 KiB |
| yolo_postprocess 控制 | `ps8_0_axi_periph/M02_AXI`，`0x86010000`，64 KiB |
| 两个核的 gmem_in | `vision_read_sc` → PS `S_AXI_HP2_FPD` |
| 图像 gmem_out、gmem_preview，YOLO gmem_out | `vision_write_sc` → PS `S_AXI_HP3_FPD` |
| 图像完成中断 | `vision_irq_concat/In0` → PS `pl_ps_irq1[0]` |
| YOLO 完成中断 | `vision_irq_concat/In1` → PS `pl_ps_irq1[1]` |

原有 PS 控制时钟保持不变，AXI Interconnect 为 M01/M02 自动生成时钟转换器。
平台原始参考时钟传播后，200 MHz 输出的 `FREQ_HZ` 为 **199998000 Hz**；
这是原平台标称 200 MHz 的现成时钟，不是先前链接工程的 100 MHz 配置。
全部五个内存主接口仅映射 PS DDR_LOW/DDR_HIGH。地址窗口不代表实际安装的 DDR 容量，
软件必须使用有效的设备物理缓冲区并遵守原 HLS ABI 的对齐、缓存同步和大小约束。

HP2/HP3、M01/M02 已从 `PFM.AXI_PORT` 的可用资源中移除，避免 Vitis 重复分配。
HP0/HP1/HPC0/HPC1、M03–M07 和原来的 32 路 AXI INTC 平台中断资源仍保留给链接器。
静态核使用独立 PS IRQ1，原 `axi_intc_0/irq` → PS IRQ0 不变。

## 后续构建

1. 用 Vivado 2022.1 打开上述 XPR。两个核已经在 BD 中，无需再次运行集成脚本。
2. 重新运行 Synthesis、Implementation、Generate Bitstream。现有 synth_1/impl_1
   已标记 `NEEDS_REFRESH=1`；若 GUI 提示重置过期运行，选择重置并重新构建。
3. 重新 Export Hardware，按平台流程导出新的 XSA；工程内原有 XSA 仍是旧产物。
4. 若后续通过 Vitis 构建 DPU，先用新 XSA 更新/重建 Vitis 平台，再重新链接 DPU。
   仅重新构建使用旧 XSA/XPFM 的应用不会包含本次修改。
5. 两核作为静态 AXI-Lite 外设随平台保留。软件需按各核寄存器 ABI 配置地址、启动和等待完成；
   BD 集成不会自动把 VART/XRT 推理流程改成调用这两个核。可轮询完成；使用中断时需更新对应设备树/驱动。

## 校验与复查

已执行 Vivado BD 校验、输出文件生成、wrapper 生成，以及关闭后重新打开工程的连接校验。
生成的 BD RTL 包含两个 HLS 实例，IP 状态报告显示 Up-to-date。
本次没有启动完整综合、布局布线、bitstream 或 XSA 导出，最终 200 MHz 时序以实现报告为准。

复查命令（从任意目录执行；生成校验报告，不重新添加 IP）：

```sh
/tools/Xilinx/Vivado/2022.1/bin/vivado -mode batch -notrace \
  -source /home/amd/Workspace/dpu_platform2/kv260_hardware_platform/kv260_hardware_platform/vision_integration/integrate.tcl \
  -tclargs verify
```

校验脚本逐项检查时钟、复位、AXI 连接、两个寄存器窗口、五个 DDR 主地址空间、中断和平台端口保留。
`reports/apply`、`reports/verify` 保存 BD Tcl、连接、地址、IP 和运行状态。
`apply` 模式仅适用于未集成的原始基础平台；对已集成工程执行会报错，避免重复加入。

当前工具提示：

- `axi_intc_0/intr` 是原有平台留给 Vitis 链接器的中断输入。基础平台阶段未接，
  Vivado 给出 BD 41-759 并在生成 HDL 时置零；后续 Vitis 链接负责连接 DPU 等中断。
- HLS 固定时钟元数据为 200000000 Hz，实际连接传播为 199998000 Hz，产生 BD 41-927。
- HLS ARLOCK/AWLOCK 为 2 位，SmartConnect 为 1 位，产生 BD 41-2384；已检查五个
  AXI 适配器的 RTL，两者均固定为 `2'b00`，截去高位不改变事务语义。
- PS 和 AXI 互连间的可选 ARUSER/AWUSER 位宽差异会产生 BD 41-237。
- 原平台声明的 `M_AXI_HPM0_FPD/M_AXI_HPM1_FPD` 未启用，且可扩展的控制输出
  尚待链接器扩展，Vivado 仍给出 PFM 的 BD 41-2589 master-interface 提示。
  本次保留这些原平台配置；新 XSA 的 Vitis 平台生成和 DPU 链接尚未执行验证。

改动前的 XPR 和完整 sources 目录已备份，位置见 `backup_path.txt`。