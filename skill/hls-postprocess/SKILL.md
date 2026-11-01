---
name: kv260-hls-postprocess
description: Validate YOLO output packing, fixed-point decode and NMS, overflow fallback and postprocessing integration evidence.
---

# HLS YOLO后处理与整帧回退

## 适用场景

检查三个DPU输出尺度的打包、查表反量化、候选筛选、NMS、输出解码和溢出回退；评估资源/周期变化是否真正改善端到端流水线。

## 输入与前置条件

- 模型输入尺寸、类别/anchor配置、三个输出shape及各自fix_point必须可追溯。
- 明确核输出是letterbox坐标还是原图坐标；软件还负责坐标恢复/裁剪等工作。
- 确认当前源码、导出IP和B3136集成应用是否为同一版本。独立IP README中的“尚未接入”与后来的B3136说明属于不同阶段，不能混读。
- 不在生产板上试探寄存器地址；构建输出须与历史结果隔离。

## 权威来源

- [独立IP说明](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/yolo_postprocess/README.md)
- [接口头文件](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/yolo_postprocess/src/yolo_postprocess.h)
- [配置/查表构造](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/yolo_postprocess/host/config.py)
- [主机适配与回退](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/yolo_postprocess/host/adapter.py)
- [原构建Tcl](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/yolo_postprocess/scripts/build.tcl)
- [B3136集成说明](/home/amd/kv260-ofdm-reproduction/src/ps/kv260_B3136/README.md)

## 执行流程

1. 按52、26、13网格核对NHWC张量顺序、INT8解释、anchor-major记录和连续打包，不依赖DPU返回数组的偶然顺序。
2. 用实际每尺度fix_point构造表；检查64字节物理起始对齐、不重叠、同步与所有权。
3. 核对输入实际有效字节与分配尾部padding；输出最多256条32字节记录，不能读取detection_count之后的旧内容。
4. 检查score Q30、坐标Q8、阈值Q16及符号解释。等分排序、严格IoU比较和近阈值量化差异需单独测试，不能承诺float逐位一致。
5. 对0候选、1候选、同类/异类重叠、边界框、256候选、257候选、invalid配置建立独立向量。
6. **状态2**必须触发原始整帧CPU解码/NMS；candidate_count饱和并非真实总候选数。禁止保留硬件前256个作为成功结果。
7. 先C矩阵再RTL smoke；修改NMS比较逻辑后检查所有边界向量，并说明RTL覆盖小于C覆盖。
8. 测性能时包括DPU结束等待、打包/复制、同步、内核等待、结果恢复、回退频率；不能只报告核周期。

仅获准构建后，按当前源码依赖顺序执行：

```bash
bash /home/amd/kv260-ofdm-reproduction/build/build_hls.sh yolo_postprocess csim
bash /home/amd/kv260-ofdm-reproduction/build/build_hls.sh yolo_postprocess synth
bash /home/amd/kv260-ofdm-reproduction/build/build_hls.sh yolo_postprocess cosim
bash /home/amd/kv260-ofdm-reproduction/build/build_hls.sh yolo_postprocess export
```

完整Python数值对照需先审查原检查脚本的应用路径和C仿真输出依赖，不把缺失dump替换为零数组。统一软件回归目前只有前处理配置测试，**不包含本核的完整C/RTL数值测试**。

## 验收与输出

- 按状态分别记录detections有效性，证明overflow执行整帧回退且不消费截断结果。
- 保存逐向量类别、框、置信度差异和明确容差；近阈值/tie用例不能删除以求通过。
- 记录综合资源与集成时序；孤立核综合达标不表示平台有足够空间。
- 输出运行时交接表及仍需数据集精度验证的范围；不得用少数自检图像代替mAP/召回率验收。

## 常见故障

| 现象 | 核对项 |
|---|---|
| 类别/框无规律 | scale排序、带符号INT8、fix_point、anchor记录布局 |
| 等分框不同 | 原算法tie顺序、量化误差；保留差异解释 |
| 拥挤场景骤慢 | 候选溢出及CPU回退比例，不能关闭回退掩盖 |
| cosim链接错误 | 工具自带编译器与环境；不默认替换AP_GCC_PATH |
| 浮点参考极慢 | 原README的libm措施仅为特定x86_64历史环境，不作为通用预加载规则 |

## 禁止与停止条件

未验证模型ABI或查表内容时停止集成；未完成DPU/核任务时不释放缓冲；不把运行时关闭NMS解释为已移除综合硬件资源。不得靠放宽置信度/取消溢出检查保证通过。

## 调用示例

“检查257候选时是否完整回退CPU，列出适配层和运行时需对齐的状态/缓冲规则；不启动HLS或板端程序。”

## 复用方法

用P1记录自己的检测输出格式和状态字，建立容量N与N+1、阈值/tie、非法配置用例。将本案例三尺度、256和状态2替换为当前接口定义；缺少整帧回退接口则输出设计缺口，不截断结果装作成功。

## 已验证效果

[历史软件矩阵](/home/amd/kv260-ofdm-reproduction/skill/references/VALIDATION_MATRIX.md)明确未覆盖此核完整数值C/RTL。本技能目前已核对[适配器源码](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/yolo_postprocess/host/adapter.py)的状态/回退设计；不宣称本轮执行该核或精度达标。

## 经验来源

[原IP说明](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/yolo_postprocess/README.md)及[适配器](/home/amd/kv260-ofdm-reproduction/src/kv260/HLS_IP/yolo_postprocess/host/adapter.py)呈现固定容量和溢出回退，提炼“局部硬件输出不等于完整帧正确”的观察。是否在自己数据集触发须实测，不编造溢出频率。