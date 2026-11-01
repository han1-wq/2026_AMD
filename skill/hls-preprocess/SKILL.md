---
name: kv260-hls-preprocess
description: Review and validate the archived image preprocessing HLS ABI, image arithmetic, host configuration and staged build evidence.
---

# HLS图像前处理开发与验证

## 适用场景

调整图像增强、letterbox、定点量化、缓冲容量或主机配置；定位C模型与RTL/板端结果差异。不能用主机配置单测代替HLS综合、协同仿真或板测。

## 输入与前置条件

- 明确输入图像格式、尺寸、stride、模型fix_point、增强预览/推理分支和误差要求。
- 记录当前头文件、主机配置、导出IP/HWH版本；寄存器偏移由匹配导出物确定。
- 软件配置检查需要NumPy；C/RTL阶段需要已核对的2022.1工具环境。
- 构建会写交付中的build链接目标，保留历史证据时必须先使用另一个获授权工作副本。

## 权威来源

- [设计与ABI说明](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/image_preprocess/README.md)
- [接口声明](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/image_preprocess/src/image_preprocess.h)
- [主机配置](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/image_preprocess/host/config.py)
- [构建Tcl](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/image_preprocess/scripts/build.tcl)
- [封装入口](/home/amd/kv260-ofdm-reproduction/build/build_hls.sh)

## 执行流程

1. **确认算术契约**：本快照输入BGR888、输出416×416 RGB NHWC INT8；不要将通道交换、填充值和量化顺序混为一项误差。
2. **确认内存契约**：检查64字节物理地址对齐、缓冲不重叠、stride字节单位、容量覆盖、CPU/device同步和生命周期。NumPy虚拟地址不是设备地址。
3. **确认状态契约**：配置号与帧号跟踪每次请求；只有成功状态允许消费结果；错误请求即使带回ID也不能当成功。
4. **构造测试分层**：常量/渐变/随机图像→边界尺寸/stride/容量→增强开关→当前帧与上一帧均衡历史→配置切换及首帧。
5. **独立黄金参考**：逐项比较通道、letterbox几何、定点舍入和饱和；原设计明确不宣称与OpenCV所有中间舍入逐位等价。
6. **运行配置测试**：仅运行已审查的两个测试；保留解释器版本和完整输出。
7. **经构建授权后**：依次csim、synth、cosim、export。cosim必须使用当前源码的成功综合结果；现有脚本RTL采用smoke范围，不等于完整C测试矩阵。
8. **向运行时交接**：更新接口变更表、缓冲容量、配置ID规则、错误状态、生成头文件和报告哈希；不只交一个IP压缩包。

离线配置测试（python3必须已包含NumPy）：

```bash
PYTHONDONTWRITEBYTECODE=1 python3 -B /home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/image_preprocess/tb/test_host_config.py
PYTHONDONTWRITEBYTECODE=1 python3 -B /home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/image_preprocess/tb/test_link_config.py
```

仅获准构建后调用；不会由本技能自动运行：

```bash
bash /home/amd/kv260-ofdm-reproduction/build/build_hls.sh image_preprocess csim
bash /home/amd/kv260-ofdm-reproduction/build/build_hls.sh image_preprocess synth
bash /home/amd/kv260-ofdm-reproduction/build/build_hls.sh image_preprocess cosim
bash /home/amd/kv260-ofdm-reproduction/build/build_hls.sh image_preprocess export
```

## 验收与输出

记录每层命令、退出码、输入向量、误差分布/最大误差、具体失败元素和日志。构建附目标器件、时钟、uncertainty、II/latency、资源报告；本快照Tcl的目标周期5 ns不证明集成后达到200 MHz。

验收要能区分：主机配置通过、C仿真通过、smoke RTL通过、IP导出成功、整平台时序通过。每一项单独填写，不合并为“全链路通过”。

## 常见故障

- 色偏：先检查BGR/RGB，再检查LUT和量化，不先改模型。
- 第一帧/改参数后异常：检查上一帧均衡历史失效规则及config_id。
- 主机测试成功但板端失败：核对HWH/ABI、物理内存与缓存，不通过扩大容差掩盖。
- csim很快、板端仍慢：区分搬运、同步、预览复制和内核等待，不以HLS周期直接推整机FPS。

## 禁止与停止条件

不替换系统工具链、不无依据加入ROUND/额外图像处理、不用旧综合结果验新源码。找不到匹配寄存器映射、容量证据或有在途DMA时，停止运行时集成。

## 调用示例

使用P1填写自己项目的输入、shape、stride、量化和性能目标；不要把本案例的尺寸当作默认值。

“审查增强预览是否会改变默认DPU输入，检查config_id和均衡历史；先跑配置测试，列出需要补的C/RTL向量，不启动板卡。”

## 复用方法

复制“算术/内存/状态三合同→独立参考→配置/C/RTL/平台分层”的流程。将416×416、BGR/RGB、64字节和2022.1替换为自己IP的已确认规格；无法核对ABI时停止。用[通用数值工具](/home/amd/kv260-ofdm-reproduction/skill/tools/validate_evidence.py)比较导出的黄金与待测JSON，不替代C/RTL执行。

## 已验证效果

历史打包[配置日志](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/hls_host_config.log)4项、[链接配置日志](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/hls_link_config.log)3项测试通过，命令见summary.json。本轮不重计这些结果；未因此证明HLS数值、协同仿真或板端效果。

## 经验来源

[构建脚本](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/image_preprocess/scripts/build.tcl)与[配置测试](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/image_preprocess/tb/test_host_config.py)覆盖层不同，这是不能把主机测试当硬件验收的源码观察；未虚构实际发生的色偏/缓存故障。