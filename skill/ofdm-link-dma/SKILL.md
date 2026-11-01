---
name: ofdm-link-dma
description: Distinguish legacy mailbox and SG-DMA protocols, validate offline host and DMA regressions and require returned-data evidence.
---

# OFDM主机协议与DMA链路验证

## 适用场景

排查UART/TCP编解码、文件分片重组、SG-DMA控制/服务状态机及回传判定。默认仅模拟传输，不能因测试名含loopback就连接射频或真实串口。

## 输入与前置条件

- 指定协议代际：旧mailbox固定帧还是当前SG-DMA的OF分片协议。
- 明确待测源码、固定输入字节/文件、期望输出、超时/退出规则和独立结果目录。
- Python测试按已审核目录执行；DMA回归需要Icarus Verilog/vvp和C编译器。
- 实机还需要匹配bit/ELF/XSA、设备身份、网络地址/端口及RF条件；这些不是离线测试前提。

## 权威来源

- [协议原文](/home/amd/kv260-ofdm-reproduction/src/ofdm/eeSDR_ofdm_loopback/host/PROTOCOL.md)
- [图片协议实现](/home/amd/kv260-ofdm-reproduction/src/ofdm/eeSDR_ofdm_loopback/host/dma_image.py)
- [UART DMA客户端](/home/amd/kv260-ofdm-reproduction/src/ofdm/eeSDR_ofdm_loopback/host/dma_uart.py)
- [固件链路层](/home/amd/kv260-ofdm-reproduction/src/ofdm/eeSDR_ofdm_loopback/firmware/dma_app/link.c)
- [已审查回归入口](/home/amd/kv260-ofdm-reproduction/sim/run_software_checks.py)
- [验证矩阵](/home/amd/kv260-ofdm-reproduction/skill/references/VALIDATION_MATRIX.md)

## 执行流程

1. 比较host帧定义与固件头部、长度、端序、session/message/fragment字段；禁止将旧69/73字节mailbox帧与DMA帧混用。
2. 将“本地入队接受”“收到RX记录”“CRC正确”“字节完全一致”“ACK窗口完成”分别记录。单独入队成功不代表无线回传。
3. UART保持一个请求在途；检查错误长度、损坏CRC、旧session、陈旧序号、截断输入及串口身份歧义测试。
4. TCP单板loopback在同一个连接上同时上传/排空接收；不能用同一板上先send后receive替代该流程。
5. 文件输出必须与输入不同；最终文件仅在完整数据、CRC/字节比对和协议完成后替换。失败不能展示旧目标文件为新结果。
6. 运行离线主机单测；GUI因无DISPLAY跳过时写明跳过，不“补算通过”。
7. 运行已有DMA五组编译/执行对：packets、control、link、services、phy。每组都检查编译与运行结果、PASS标志和错误日志。
8. 将软件模拟覆盖和实际RF未覆盖的部分分开交接，后续板测另行建立证据。

主机离线测试（不调用dma_uart/dma_image主入口）：

```bash
cd /home/amd/kv260-ofdm-reproduction/src/ofdm/eeSDR_ofdm_loopback
env -u DISPLAY -u PYTHONPATH PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s /home/amd/kv260-ofdm-reproduction/src/ofdm/eeSDR_ofdm_loopback/host -p 'test_*.py' -v
```

完整离线DMA组使用统一回归，不在本技能重复手写编译参数：

```bash
python3 -B /home/amd/kv260-ofdm-reproduction/sim/run_software_checks.py --help
```

阅读help后按验证矩阵选择已有标准库/NumPy解释器；该脚本没有“只跑DMA”的过滤参数，不虚构`--suite`选项。

## 验收与输出

- 主机测试退出0且unittest无失败；逐项记录跳过数。
- DMA组分别出现DMA_PACKETS_PASS、DMA_CONTROL_PASS、DMA_LINK_PASS、DMA_SINGLE_BOARD_SERVICES_PASS、BOARD_PHY_PASS，并要求对应进程退出0。
- 本次硬件数据验收若获准执行，应保存输入/回传文件SHA与逐字节比较、payload大小和测时边界；不预填结果。
- 误码率、射频吞吐、端到端时延只能来自相应实际实验，不能由C/RTL模拟推出。

## 常见故障

- 只有enqueue ACK：检查是否收到相同session/message的RX数据。
- TCP似乎卡住：检查是否只上传不排空RX、另一个客户端占用或窗口未完成。
- 设备auto歧义：要求操作员选择稳定设备身份，不选择列表第一个端口。
- 回传图片看起来相似但SHA不同：区分协议文件一致性与有损图像重新编码；按实验目标独立验收。

## 禁止与停止条件

不自动重放失败事务，不同时占用串口，不在无RF/硬件授权时运行benchmark或live脚本；不删除CRC、session、大小或输出替换保护。未知固件版本时停止通信层实机排查。

## 调用示例

使用P3仅用模拟流复现自己协议的分片/CRC失败，核验失败时不替换目标文件，不连接设备。

## 复用方法

使用P3替换协议字段、帧长/端序、CRC、session和超时；保留“接受→回传→完整性→最终替换”的状态拆分。先用模拟流和固定向量，不沿用设备/IP。新协议没有对应字段时明确替代的身份/完整性机制。

## 已验证效果

[历史主机日志](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/ofdm_host.log)执行54项，50通过、4跳过；[summary](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/summary.json)记录五组DMA编译/运行通过。仅软件模拟；本轮未重跑，也未证明真实射频或吞吐。

## 经验来源

[协议定义](/home/amd/kv260-ofdm-reproduction/src/ofdm/eeSDR_ofdm_loopback/host/PROTOCOL.md)及[主机测试日志](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/ofdm_host.log)提供帧/错误路径与GUI跳过观察，因此不把ACK或unittest的总数当回传成功/通过数。
