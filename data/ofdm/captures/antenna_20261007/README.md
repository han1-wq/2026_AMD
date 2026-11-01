# 天线实测诊断，2026-10-07

本目录保存本次 v6 板上串口结果、ILA CSV 和采集日志。未重新烧录 PL，
未修改 RF 设置。脚本为当时使用的诊断记录，其中路径指向 `/tmp`，不是通用工具。
payload 触发在 seq=142 超时时未及时退出，已终止该批处理；随后将比较条件
全部设为 don't-care 并完成一次无条件采集，解除等待触发状态。
只有 140、141 的 payload 触发 CSV 是完整有效捕获。

## 已确认事实

- 110–115：发送相同的 00..3f，全部 flags=0x10、length=0。
- 120–131：发送按序号确定的随机数据，6 次超时、6 次 flags=0x04。
- TX 触发捕获 4096 点，每包有 640 个 OFDM TX 样本，RX valid 间隔恒为 2。
  解码输出较晚：错误包仅有前 32 字节进入这个窗口，不能解释成丢了后半包。
- 140、141：使用 payload-valid 触发，均抓到 64 个有效字节，
  与对应 JSON 中的 UART rx 完全相同。FCS strobe 在 CSV 样本 600，
  FCS OK=0，length=64。错误已经存在于 mailbox/UART 之前。
- 120–131 的有效 RX 样本无数字满量程削顶。幅度统计以
  `w_rx_scaled_i/q` 按 16 位有符号数解析后除以 16，单位为 ADC 码。
  未证明模拟前端在任何情况下都没有失真，也未完全排除 LVDS 时序误码。

## 已复现的代码缺陷

`ofdm_iq_scale` 在 TX done 时清零 IQ，但旧代码没有为这个零样本置 valid。
`ad936x_phy_tx` 只接受有效样本，空闲时继续发送最后一个已接受样本。
因此 scaler 总线上已经是零，但串行输出仍保持包尾非零 IQ。

修复：`ow_tx_valid <= iw_tx_valid || iw_tx_clear;`，将包尾清零作为有效传输。
不改变 PHY 的字内握手和保持行为。当前 TX 的 done 在最后一个 TX beat
两拍后出现；此修复依赖当前接口 done 与 sample valid 不重叠的正常完成时序。

新增 `sim/tb_phy_tx_idle.v` 将实际 scaler 和 PHY 相连，在 LVDS 引脚重组字，
检查数据包及空闲输出。旧 scaler 实测失败：
`PHY_IDLE_NOT_ZERO phase=0 i=9a4 q=552`；修复后两个发送相位均通过。

## 波形与缺陷之间的联系

对每包 TX/RX 搜索 135..145 个 RX 样本的起点，拟合
`RX[n] = h * TX[n] + dc + residual[n]`。
所得 dc 与 `-h * 上一包最后一个 TX 样本` 接近，例如：

| seq | 实测 dc（ADC 码） | 前一包尾预测 dc（ADC 码） |
|---|---|---|
| 121 | 26.5 + j134.0 | 22.7 + j138.3 |
| 122 | 97.8 + j31.3 | 98.4 + j31.1 |
| 123 | 99.8 - j41.1 | 100.7 - j40.2 |
| 125 | 37.3 + j4.3 | 37.3 + j3.2 |
| 129 | 24.9 + j33.0 | 26.3 + j36.4 |

这强烈支持持续发射的包尾样本与接收直流校正相互作用，给下一包引入偏置。
未读取 AD9361 内部直流校正状态，因此该内部机制属于有实测支持的推断。
单复数增益拟合残差仍有约 66–89 ADC 码 RMS，包含频响、噪声等影响，
不能将其直接当作均衡后 EVM，也不能证明修复后所有 64-QAM 误码都会消失。

## 用户原始 9 次结果

第 2、4、6、7 次为超时，返回缓冲区零值不计入 BER。
其余每包 TX/RX 均为 64 字节，按原始文本统计：

| 原始序号 | 错误字节 | 错误比特/512 |
|---|---|---|
| 1 | 26 | 105 |
| 3 | 64 | 271 |
| 5 | 41 | 172 |
| 8 | 27 | 106 |
| 9 | 37 | 129 |

注意：早期临时计算误抄了第 9 次 RX 中间部分，得到 26 字节/88 bit；
该数值作废，上表已使用用户原始 RX 重新计算。

## 镜像和边界

Hardware Manager 接受 v6 TOP.ltx，发现一个 ILA，深度 4096、19 ports。
磁盘文件 SHA256（不等价于运行中 PS 镜像的独立读回证明）：

- TOP.bit: `20fa32896f9c67da6e9d905df253c5ff1e51900abaa025de1e17c6c61ca55f01`
- TOP.ltx: `99233122a46a4a5b6c8c40ff05f3510afc7a6a591a9d259f8894003bbdea5e72`
- AD936x_PS.elf: `19fa9a396b2599fdcb46b0fd6c7b29c4beb695c3ce570a659b14f49fa0c1dbe2`

磁盘 PS 源码参数为 800 MHz、40 MS/s、40 MHz RF 带宽、RX MGC 12 dB、
TX 衰减 10 dB；不是通过 SPI 回读确认的运行值。

当前修复尚未生成/下载新 bitstream，实机恢复情况待上板 A/B 验证。
仅重新下载旧 Vitis ELF 不会包含此 PL RTL 修复。

## 修复验证

- 原有 PHY 1T1R、两种相位、2T2R 回归通过。
- 新增 scaler/PHY 联合包尾测试两个相位通过；旧 scaler 在同一测试失败。
- IQ scale 单元测试通过，clear 产生一个有效零样本。
- v6 真实 IP 仿真：54 Mbps、64 字节、gain=1、RX_SHIFT=4、无 CFO/额外
  干扰、连续两包 payload/FCS 通过；累计样本数 641、1282。
- 信道平滑、软判决、pilot rotation、真实 IP Viterbi prefix 和粗/细 CFO
  缩放单元测试通过。
- RF testbench 更新了零样本计数，并在下一命令握手时重置包内节拍检查，
  以免将包间空闲误判为包内 valid 间断。独立仿真目录 `/tmp/ofdm_idle_sim`。
- 日志 `rf_chain_final.log`、`dsp_units.log`、`phy_regression.log`、
  `ila_cleanup.log` 保存最终结果。git diff --check 通过。

这些验证证明握手缺陷已修复且测试基线未退化，不是修复后实机 BER 结果。