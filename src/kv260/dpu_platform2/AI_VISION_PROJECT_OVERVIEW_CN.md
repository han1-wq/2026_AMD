# KV260 AI 视觉加速工程详细介绍

**工程目录：** `/home/amd/Workspace/dpu_platform2`  
**整理日期：** 2026-10-30  
**当前硬件构建证据日期：** 2026-10-14  
**文档定位：** 用于工程介绍、技术交流和后续软件接入；依据本地源码、实际 Block Design、生成文件及构建报告整理，不把设计目标、仿真结果和板端实测混为一谈。

## 1. 工程概述

本工程是一套面向 AMD/Xilinx Kria KV260 的 AI 视觉硬件加速平台，采用“ARM 处理系统负责控制和应用逻辑，FPGA 可编程逻辑负责图像处理与神经网络计算”的软硬件协同架构。

工程不仅集成 DPU 神经网络推理核，还加入两个专用 HLS 加速核：

- **图像预处理核 `image_preprocess_1`**：把 DDR 中的原始 BGR 图像转换为模型要求的 RGB INT8 输入张量，并提供可选图像增强与预览输出。
- **YOLO 后处理核 `yolo_postprocess_1`**：把 DPU 输出的三尺度 INT8 特征张量转换为检测框、类别和置信度，并执行可选的按类别非极大值抑制。

两个核分别位于推理前后，构成“图像预处理 → DPU 推理 → 检测后处理”的硬件计算链路。工程还保留独立 Softmax 核 `sfm_xrt_top_1`，但它不是 YOLO 框解码或 NMS 模块，也不是这条检测链路必须经过的阶段。

工程目标是减少 ARM 端反复执行像素处理、量化、检测解码和 NMS 的负担。**CPU 占用降低幅度、端到端 FPS、功耗和加速比尚不能仅凭硬件实现报告确定，需要完整软件接入后的板端测试。**

### 1.1 当前配置

| 项目 | 当前工程配置 |
|---|---|
| 目标平台 | KV260，器件 `xck26-sfvc784-2LV-c` |
| 工具版本 | Vivado / Vitis / Vitis HLS 2022.1 |
| DPU 实例 | 单个 `DPUCZDX8G_1` |
| DPU 架构 | **B3136，启用 URAM** |
| DPU 时钟 | 标称 300 MHz `aclk`、600 MHz `ap_clk_2` |
| 图像预处理核 | `local:vision:image_preprocess:1.0` |
| YOLO 后处理核 | `local:vision:yolo_postprocess:1.0` |
| 两个视觉核时钟 | 标称 **200 MHz**，平台元数据传播值约 199.998 MHz |
| 数据交换 | AXI4 Memory-Mapped 访问 DDR，由主机管理缓冲区与调度 |
| 控制接口 | AXI4-Lite，可轮询完成，硬件中断已连接 |
| 已有硬件产物 | 基础平台 XSA、最终链接工程 bitstream、`dpu.xclbin` |

**版本说明：** 早期文档中的 B4096、视觉核 100 MHz、“仅完成 BD 集成、尚未生成 bitstream”等内容描述历史阶段。当前 DPU 配置、BD 和 2026-10-14 构建报告已经变化，应优先以实际文件为准。基础平台不含 DPU；完整系统由后续 Vitis 链接加入 DPU 和 Softmax。

## 2. 系统架构与任务划分

### 2.1 数据流

```text
ARM 端采集或读取图像、准备缓冲区
                  │
                  ▼
           DDR：BGR888 输入图像
                  │
                  ▼
        image_preprocess_1 图像预处理
          │                       │
          ▼                       ▼
 DDR：416×416×3 RGB INT8     DDR：原分辨率增强预览
          │                       │
          ▼                       └──► ARM 端显示/发布
       DPUCZDX8G_1
          │
          ▼
 DDR：YOLO 三尺度 INT8 输出
          │
          ▼
 ARM 端按 ABI 排序/打包输出张量
          │
          ▼
       yolo_postprocess_1
          │
          ▼
 DDR：检测框、分数、类别、anchor ID
          │
          ▼
 ARM 端坐标还原、裁剪、绘图、跟踪与业务逻辑
```

上图是任务依赖关系，不表示所有阶段已经在板端应用中自动串接。当前后处理适配器会把三个输出张量复制到连续 staging buffer，仍需设备执行器完成分配、同步和寄存器操作。

### 2.2 ARM 与 FPGA 的职责

| 环节 | 当前职责划分 |
|---|---|
| USB/UVC 相机采集、MJPEG 解码 | ARM/系统软件；预处理核不直接接收压缩 JPEG |
| 图像增强、缩放、Letterbox、通道转换、量化 | 图像预处理 HLS 核 |
| 神经网络主体计算 | DPU，执行与其架构和指纹匹配的模型 |
| 三尺度检测解码、置信度过滤、可选 NMS | YOLO 后处理 HLS 核 |
| 后处理张量整理、设备内存和缓存管理 | 主机软件 |
| Letterbox 坐标还原与最终图像边界裁剪 | 主机软件，在 NMS 之后执行 |
| 深度图处理、ROI 深度统计、目标跟踪、ROS2、绘图显示 | 应用层功能，不属于这两个 HLS 核 |

### 2.3 与 DDR 的连接

- 两个视觉核的输入读接口经 `vision_read_sc` 汇聚到 PS 的 `S_AXI_HP2_FPD`。
- 预处理张量、预处理预览和后处理结果三个写接口经 `vision_write_sc` 汇聚到 `S_AXI_HP3_FPD`。
- HP2/HP3 数据端口配置为 128 位，SmartConnect 处理主接口间的数据宽度适配；后处理结果接口为 256 位。
- DPU 保留 HPC0、HP0、HP1 连接，未与视觉核直接通过 AXI4-Stream 连接。
- 图像核使用 AXI Master 自行读写 DDR，因此这条路径不依赖单独的 AXI DMA 搬运模块。

分配不同端口有助于组织访问，但不等于物理 DDR 带宽互不影响。并发 DPU 流量下的实际性能必须测量。

## 3. 图像预处理加速核

### 3.1 功能与输入输出

`image_preprocess` 是按帧启动的内存映射 HLS IP。其输入是未压缩 BGR888 图像，输出为模型张量、增强预览或二者同时输出。

| 项目 | 接口约束 |
|---|---|
| 输入格式 | BGR888，每像素 B、G、R 各 8 位 |
| 输入宽度 | 416～1920 像素 |
| 输入高度 | 416～1080 像素 |
| 输入行跨度 | 字节单位，16 字节对齐，至少 `width×3`，不超过 5760 |
| 张量格式 | 固定 `[1,416,416,3]`，NHWC、RGB、INT8 |
| 张量有效大小 | **519,168 字节** |
| 预览格式 | 原始输入分辨率的增强 BGR888 图像 |
| 预览缓冲区容量 | 至少 `preview_stride×height` 字节 |
| LUT 缓冲区 | 512 字节：256 字节颜色 LUT + 256 字节 INT8 量化 LUT |
| 缓冲区要求 | 设备物理起始地址 64 字节对齐，各缓冲区不能重叠 |

支持到 1920×1080 表示接受该尺寸，不代表已验证 1080p 的实时帧率。宽或高小于 416 的输入不被当前硬件接受，应使用软件回退或另行实现支持；例如 320×240 输入不在支持范围内。

### 3.2 处理流程

```text
DDR 读取 → 128 位数据解包为 BGR 像素
         → 保留原始像素，同时生成增强像素
         → 可选颜色 LUT → 可选饱和度 → 可选亮度均衡
         → 分支选择与双线性缩放
         → Letterbox 填边 → BGR 转 RGB → INT8 查表量化
         → 打包并写回张量

增强像素另一路 → 原分辨率预览打包 → 写回 DDR
```

推理分支由 `ENHANCE_TENSOR` 标志选择原始像素或增强像素，因此可实现“显示端增强，模型输入保持原始分布”。增强并不一定提高识别精度，默认关闭并保留独立分支有助于控制数值兼容风险。

### 3.3 双线性缩放与 Letterbox

主机按输入宽高计算等比例缩放尺寸，硬件执行缩放和居中填边：

```text
scale = min(416 / width, 416 / height)
resized_w = round(width × scale)
resized_h = round(height × scale)
pad_x = floor((416 - resized_w) / 2)
pad_y = floor((416 - resized_h) / 2)
```

例如 640×480 图像缩放为 416×312，上下各填充 52 行灰色像素。填充值在量化前为 128；若剩余边长为奇数，多出的一个像素落在右侧或下侧。

内部使用半像素坐标映射、Q11 插值权重和两个源图像行缓冲区，不需要将整帧放入片上 RAM。坐标生成与双线性插值采用确定的定点舍入规则。主机负责生成等比例几何，硬件检查范围与居中填边关系，不应把非法或任意缩放配置当作标准 Letterbox。

**与 OpenCV 的兼容边界：** 已有对比覆盖的默认测试中，量化后最大差异为 1 INT8 LSB；不宣称与所有 OpenCV 版本的 `INTER_LINEAR` 逐位一致，也不把该结果扩大为全部图像的误差保证。

### 3.4 亮度、对比度与饱和度

主机辅助程序通过颜色 LUT 实现亮度和对比度：

```text
color(v) = clip_uint8(round_even(contrast × (v - 128) + 128 + brightness))
```

辅助程序接受对比度 0～4、亮度整数 -255～255。硬件读取 LUT，而不是每个像素都执行一套通用浮点表达式。首版颜色 LUT 对三个通道使用相同映射，不能将其描述成三个可独立设置的颜色曲线。

饱和度以亮度为基准调节各通道与亮度的差值：

```text
Y ≈ (77R + 150G + 29B + 128) >> 8
C' ≈ clip_uint8(Y + saturation × (C - Y))
```

实际实现采用定点运算和最近偶数舍入。饱和度参数使用 Q12，4096 表示 1.0，范围为 0～8192，即 0～2.0。0 对应去色，1 对应不改变该步骤的饱和度。

### 3.5 全局亮度直方图均衡

均衡作用于亮度分量，而不是分别均衡 R/G/B；保留色度信息后再重建彩色图像。支持三种模式：

| 模式 | 行为 | 特点 |
|---|---|---|
| `EQ_OFF = 0` | 关闭均衡 | 不执行亮度均衡 |
| `EQ_CURRENT = 1` | 统计当前帧，再处理同一帧 | 图像读取两遍；使用当前帧统计 |
| `EQ_PREVIOUS = 2` | 用上一帧统计处理当前帧，同时统计当前帧 | 图像读取一遍；统计有一帧滞后 |

上一帧模式首次运行、显式复位历史、尺寸或相关配置改变时，会旁路均衡，避免使用无效统计。颜色 LUT 内容改变时主机必须更新 `config_id`；软重启后需明确复位历史。

直方图使用 256 个亮度 bin。统计更新保留真实 RAM 数据依赖，相关统计循环 II 为 2，不能把整个核描述为所有模式都能每周期处理一个完整输出像素。CDF 归一化使用受限位宽的精确整数运算；常量图像生成恒等均衡 LUT，但启用均衡时的色度转换往返仍可能影响像素，因此不等于所有路径逐位恒等。

### 3.6 通道转换与 INT8 量化

模型张量通道顺序为 RGB。量化 LUT 由模型实际 `fix_point` 生成：

```text
q(v) = clip_int8(round_even(v × 2^(fix_point - 8)))
```

该式对应本应用的 `/256` 归一化约定，不能擅自替换成 `/255`。辅助程序中的默认 fix_point 只是默认参数，实际调用必须读取模型 tensor 属性，确认形状、类型和量化信息一致。

### 3.7 输出模式、状态和接口

| 输出模式 | 行为 |
|---|---|
| `TENSOR_ONLY = 0` | 仅写推理张量 |
| `PREVIEW_ONLY = 1` | 仅写增强预览 |
| `TENSOR_AND_PREVIEW = 2` | 同时写张量和预览 |

控制接口传入源/目的地址、尺寸、stride、容量、缩放几何、模式、增强参数、帧 ID 和配置 ID。完成时返回状态、完成帧/配置 ID、有效张量字节数、有效预览字节数及 ABI 版本 `0x00010000`。

状态值：0 成功；1 尺寸错误；2 stride 错误；3 容量不足；4 模式错误；5 几何错误；6 饱和度错误。失败时有效输出字节数为零；返回的帧 ID 只能标识本次请求，不能替代成功状态判断。

`preview_bytes` 表示有效像素字节数 `width×height×3`，不包含行尾 padding；分配容量仍需按 `stride×height` 计算。

三个 AXI Master bundle 分别为 `gmem_in`、`gmem_out`、`gmem_preview`，输入图像和 LUT 共用读接口。AXI4-Lite 寄存器偏移以匹配该 IP 导出的寄存器头文件/HWH 为准。当前 ABI 没有硬件周期计数器，主机应测量启动至完成时间。

### 3.8 HLS 实现特点

- 使用 DATAFLOW 和流 FIFO 组织读内存、解包、颜色处理、缩放、打包和写内存等阶段。
- 使用双行 BRAM 缓冲实现缩放，而不是分配整帧片上缓存。
- 使用 LUT 处理量化、颜色映射和亮度均衡，减少重复非线性计算。
- 当前优化版本缩窄坐标和行控制位宽，使用精确恢复除法生成坐标，保持原接口与定点语义。
- 颜色和插值循环已有 II=1 的调度证据，但存在统计、启动、访存和输出节拍限制，不能由局部 II 推导整帧或整系统吞吐。

## 4. YOLO 后处理加速核

### 4.1 功能定位与模型边界

`yolo_postprocess` 将 DPU 输出转换成检测结果。其支持的是明确的 YOLOv4 416/COCO 风格 ABI，不是自动适配任意 YOLO 模型的通用后处理器。

| 项目 | 要求 |
|---|---|
| 模型输入尺寸 | 416×416 |
| 输出尺度及打包顺序 | **52、26、13** |
| 每尺度张量形状 | `[1,H,H,255]`，NHWC、INT8 |
| 每网格 anchor 数 | 3 |
| 每 anchor 数据 | 4 个坐标参数 + 1 个 objectness + 80 个类别 logit，共 85 字节 |
| 类别选择 | 每个 anchor 仅保留最高分的一个类别，不是多标签输出 |
| 总 anchor 数 | **10,647** |
| 有效输入字节数 | **904,995** |
| 16 字节对齐后的最小输入分配 | **905,008 字节** |
| 查找表大小 | **5,376 个 u32，21,504 字节** |
| 候选框上限 | **256** |
| 输出最小容量 | **256 条 × 32 字节 = 8,192 字节** |

三个尺度连续打包，中间不插入额外 padding，仅整个分配末尾补齐。不能假定 DPU runner 的输出顺序已经是 52/26/13；适配器通过形状识别尺度并排序。

主机 LUT 构造与适配检查针对以下 anchors：

| 网格 | anchors（宽，高） |
|---|---|
| 52×52 | (10,13)、(16,30)、(33,23) |
| 26×26 | (30,61)、(62,45)、(59,119) |
| 13×13 | (116,90)、(156,198)、(373,326) |

这些是当前软件 ABI 的约束；不能绕过检查后宣称任意 anchors 或 YOLOv5/YOLOv8 已受支持。

### 4.2 解码流程

1. 逐尺度载入 sigmoid 和宽高查找表。
2. 顺序扫描每个 anchor 的 85 个 INT8 数据。
3. 查表计算 objectness，在 80 个有符号类别 logit 中选出最大值。
4. 仅对选中的类别做 sigmoid 查表，与 objectness 相乘得到最终分数。
5. 根据置信度阈值过滤，解码中心坐标和框宽高。
6. 在候选数不超过 256 的条件下，输出候选框或执行按类别贪心 NMS 后输出。

利用 sigmoid 的单调性，先选最大 logit 再查一次类别 sigmoid，避免每个 anchor 做 80 次类别 sigmoid 查表。即使 anchor 不通过阈值，输入数据仍顺序读取完毕，不能把置信度过滤描述成完全跳过该 anchor 的 DDR 读取。

### 4.3 量化查表与框解码

主机读取每个输出 tensor 的实际 `fix_point`，为三个尺度分别建立查找表。INT8 的 256 种位模式用作表索引。

```text
实数 logit = signed_int8 × 2^(-fix_point)
score = sigmoid(objectness) × sigmoid(best_class_logit)
cx = (grid_x + sigmoid(tx)) × stride
cy = (grid_y + sigmoid(ty)) × stride
w = anchor_w × exp(tw)
h = anchor_h × exp(th)
```

这些表达式用于说明算法语义；硬件中采用定点 LUT 和整数运算，不在线执行通用浮点 sigmoid/exp。主机表生成对 sigmoid 输入裁剪至 [-30,30]、exp 输入裁剪至 [-10,10]；宽高表预先融合 anchor 和半宽/半高系数。

主要数值格式为：sigmoid 值 Q15、最终分数 Q30、坐标 Q8、NMS 阈值 Q16。具体以寄存器参数和数据打包定义为准。

### 4.4 非极大值抑制 NMS

硬件使用按类别贪心 NMS：每轮选择剩余最高分框，抑制同类别且 IoU 严格大于阈值的框。不同类别之间不互相抑制，不在 NMS 前裁剪坐标。

为避免除法，比较写为：

```text
(intersection_area << 16) > union_area × nms_q16
```

当前安装版本采用分段 DSP 乘法和寄存器进位组合：面积保留完整 64 位，联合面积使用 65 位，阈值乘积保留 82 位。它与早期文档中的串行 shift/add 版本不同，不能混用两者的资源和调度结果。

候选框存放在 BRAM 中，运算资源循环复用，没有构建 256×256 的全并行比较阵列。这样控制面积，但延迟随候选数量和重叠关系变化，不能承诺固定整帧时延。

`enable_nms=0` 时硬件输出解码候选框，软件可继续执行 NMS。运行时关闭 NMS 不会移除 FPGA 中已综合的 NMS 电路。

### 4.5 结果记录与异常处理

每条结果为 32 字节，包含八个 32 位字段：

| 字段 | 格式/含义 |
|---|---|
| `x1,y1,x2,y2` | 有符号 Q8，基于 416×416 Letterbox 图像的未裁剪坐标 |
| `score` | 无符号 Q30 |
| `class` | 类别编号 |
| `anchor_id` | 全局 anchor 编号 |
| `reserved` | 保留，写零 |

状态 0 为成功，1 为参数非法，2 为候选溢出。**候选超过 256 时不会返回可接受的截断检测结果，主机必须对整帧执行原软件后处理。** 溢出时 `detection_count=0`，`candidate_count` 饱和在 256，不代表真实全部候选数量。

硬件在输出前完成候选扫描，非法或溢出请求不会产生有效检测记录；旧缓冲区内容可能仍存在，只能读取成功状态下 `detection_count` 指定的范围。

容量参数单位也不同：`input_words` 为 128 位字数、`table_words` 为 32 位字数、`output_capacity` 为 32 字节记录数，不应统一当成字节数写入寄存器。

### 4.6 数值兼容边界

查表量化、定点坐标和 Q16 IoU 阈值可能改变接近阈值的决策。相同分数的排序、浮点 sigmoid 饱和造成的类别平局、软件 IoU 的微小 epsilon 与硬件严格比较也存在差异。因此已有独立参考测试和 RTL 协同仿真不等于完整数据集精度验收；上线前仍需对检测框数量、类别、坐标、置信度及 mAP/业务指标进行回归。

## 5. 平台集成与控制方式

### 5.1 地址、时钟、复位与中断

| 项目 | 图像预处理 | YOLO 后处理 |
|---|---|---|
| BD 实例 | `image_preprocess_1` | `yolo_postprocess_1` |
| AXI-Lite 基地址 | `0x86000000` | `0x86010000` |
| 地址窗口 | 64 KiB | 64 KiB |
| 控制互连输出 | `ps8_0_axi_periph/M01_AXI` | `ps8_0_axi_periph/M02_AXI` |
| 时钟 | `clk_wiz_1/clk_out3` | `clk_wiz_1/clk_out3` |
| 核复位 | `proc_sys_reset_2/peripheral_aresetn` | 同左 |
| 完成中断 | `vision_irq_concat/In0` → PS IRQ1 bit 0 | `vision_irq_concat/In1` → PS IRQ1 bit 1 |

这里的中断 bit 位置不是 Linux IRQ 编号。使用中断还需要正确的设备树、驱动或用户态框架支持；不启用 HLS 中断时可轮询完成。

基础平台已把两个视觉核需要的 HP2/HP3 和控制端口从可供 Vitis 链接器分配的资源中移除，避免被 DPU 再次占用。DPU 和 Softmax 由后续链接添加，使用保留的 AXI 资源和原 AXI INTC 中断路径。

### 5.2 静态外设与 XRT compute unit 的区别

当前 `dpu.xclbin.info` 列出的 XRT kernels 为 `DPUCZDX8G` 和 `sfm_xrt_top`。两个 HLS 视觉核位于静态平台中；最终 routed 报告和 BD 都确认它们存在，不能因为 XRT kernel 列表中没有它们就判断它们未进入硬件。

反过来，存在于 bitstream 也不等于能通过 XRT kernel 名称直接启动。主机需通过与平台匹配的 MMIO/驱动方式访问其 AXI-Lite 寄存器。工程中的主机辅助模块提供 ABI 参数与数据适配，但不等于完整的板端设备执行器。

### 5.3 内存与缓存一致性

两个视觉核通过非一致性 HP 端口访问 DDR，主机必须管理以下事项：

1. 使用真正的设备可访问物理缓冲区，不能把 NumPy/普通进程虚拟地址当作设备地址。
2. 检查 64 字节起始对齐、非重叠关系、stride、容量和实际可访问地址范围。
3. CPU 写入输入和 LUT 后执行相应 flush/sync，再启动硬件。
4. 硬件完成后，在 CPU 读取输出前执行 invalidate/sync。
5. DPU 消费输入或后处理读取 DPU 输出时，保持正确的所有权和完成顺序。
6. 超时后不能立即回收缓冲区；先确认旧任务停止或完成恢复，避免迟到写入。

DDR_LOW/DDR_HIGH 映射是地址窗口，不表示窗口全部对应已安装物理内存。硬件参数校验也不能证明物理地址、缓冲区寿命和缓存操作正确。

## 6. 软件调用流程

以下为接入完整应用时应实现的调度顺序，而非声明现有摄像头应用已经执行该流程。

### 6.1 初始化

1. 加载同一构建版本的硬件产物与配套硬件描述，确认两个视觉核寄存器映射。
2. 创建 DPU runner，读取模型输入输出形状、dtype、量化参数和 DPU 架构兼容信息。
3. 确认预处理所需的 RGB NHWC INT8 416×416 输入约定，以及后处理需要的三尺度 80 类输出约定。
4. 分配图像、LUT、张量、预览、后处理 staging 和结果缓冲区。
5. 构造与模型实际 fix_point 对应的预处理量化 LUT 和后处理解码 LUT。

当前 DPU 为 B3136；不能直接假定原 B4096 模型二进制仍兼容，应按当前 DPU 指纹/架构核查或重新编译模型。

### 6.2 每帧执行

1. 采集或读取 BGR 图像，写入源缓冲区并同步。
2. 设置预处理地址、几何、模式、帧 ID、配置 ID 和增强参数。
3. 启动预处理，等待完成，检查状态、ID 和有效字节数。
4. 将张量交给 DPU。若 runner 暂不支持共享设备缓冲区，先采用可验证的显式拷贝，不虚构零拷贝能力。
5. 等待 DPU 完成，按 52/26/13 顺序整理 INT8 输出，写入后处理连续缓冲区。
6. 同步后处理输入与 LUT，启动后处理并等待完成。
7. 成功时读取有效记录；溢出时整帧执行原软件解码与 NMS；其他错误明确处理。
8. 在 NMS 后还原 Letterbox 坐标并裁剪至原图，再执行绘图、跟踪或深度融合。

要跨帧重叠执行，可进一步设计双缓冲/多缓冲与状态机，但本介绍不把该调度优化当作已实现功能。

### 6.3 已有软件辅助模块

| 文件 | 职责 |
|---|---|
| `/home/amd/Workspace/HLS_IP/image_preprocess/host/config.py` | 生成颜色/量化 LUT；验证地址、容量、几何与增强参数；生成调用参数 |
| `/home/amd/Workspace/HLS_IP/yolo_postprocess/host/config.py` | 生成三尺度解码表；验证缓冲区；解析结果并还原坐标 |
| `/home/amd/Workspace/HLS_IP/yolo_postprocess/host/adapter.py` | 校验模型 ABI；排序、复制打包输出；调用注入的 executor；处理溢出回退 |

后处理 adapter 中的 `execute` 由调用者提供，负责真实设备执行、内存同步、等待与超时恢复。它不是已经实现的板端 MMIO 驱动。

工程附带的应用样例是 ResNet50 图片分类，包含图像读取、CPU 预处理、DPU 调用、CPU Softmax 与 Top-5 输出。它可帮助理解 DPU runner 使用方式，但既不证明模型与当前 B3136 二进制兼容，也不证明两个视觉核已经接入应用。源码为：

`/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd/src/app/samples/src/resnet50.cpp`

## 7. 实现结果与验证证据

### 7.1 最终链接系统已完成的阶段

2026-10-14 的最终 Vitis 构建日志记录了综合、布局布线、bitstream 生成和 XCLBIN 打包完成。最终 routed 加速器报告明确包含 DPU、Softmax、图像预处理和 YOLO 后处理四个实例。

本次文档整理还以 SHA-256 对比了基础平台已安装 IP 与最终链接工程生成目录中的 HDL/初始化数据：图像核 **94 个文件**、后处理核 **30 个文件**均找到内容一致的对应文件。部分初始化数据位于实例生成目录而非 `ipshared`，校验包含这两种位置。这是静态文件一致性检查，不替代 bitstream 板端功能测试，也不等于对全部工具产物做完整可复现构建审计。

### 7.2 最终系统资源

以下来自 2026-10-14 的最终 DPU 链接工程 routed 总资源报告，不是 HLS 估算，也不是不含 DPU 的候选基础平台数据。

| 资源 | 使用量 | 总量 | 占比 |
|---|---:|---:|---:|
| LUT | 80,948 | 117,120 | 69.12% |
| FF/CLB Registers | 128,151 | 234,240 | 54.71% |
| BRAM Tile | 119 | 144 | 82.64% |
| URAM | 40 | 64 | 62.50% |
| DSP | 642 | 1,248 | 51.44% |
| 已占用 CLB 位置 | 14,623 | 14,640 | 99.88% |

CLB 位置占用高不表示其中每个 LUT 都已用满，但说明逻辑分布接近覆盖全部 CLB 位置；不能只看剩余 LUT 就断言添加逻辑很容易。

最终 routed 加速器报告中的两个视觉核局部资源为：

| 核 | LUT | Registers | DSP |
|---|---:|---:|---:|
| `image_preprocess_1` | 12,416 | 12,827 | 37 |
| `yolo_postprocess_1` | 4,371 | 7,204 | 25 |

局部核资源不包含全部共享互连、PS 包装和平台逻辑，不能简单相加作为整个新增子系统的增量成本。不同阶段的 BRAM 报告口径也可能不同，因此整系统 BRAM 以总资源报告为准。

### 7.3 最终系统时序

2026-10-14 02:32:06 的 post-route physical optimization 后时序报告给出：

| 指标 | 结果 |
|---|---:|
| 建立时间最差裕量 WNS | **+0.001 ns** |
| 建立时间总负裕量 TNS | 0 |
| 保持时间最差裕量 WHS | **+0.007 ns** |
| 保持时间总负裕量 THS | 0 |
| 最差脉宽裕量 WPWS | +0.071 ns |
| setup/hold/pulse-width 失败端点 | 0 |

报告结论为满足用户指定时序约束。但 setup 裕量只有 1 ps，不能描述为“时序裕量充足”。后续变更、重新布局布线、时钟或约束调整后必须重新检查。

“现有约束下通过 STA”也不等于约束方法学全部无问题。候选平台记录中存在原平台时钟方法学警告；最终时序摘要也不是完整 CDC、方法学和板端验证的替代品。

### 7.4 核级功能验证

被集成的优化候选记录包括：

- 两个核的算术回归、C 仿真、HLS 综合、映射综合、Verilog RTL smoke 协同仿真和 IP 导出通过。
- 图像核 24 组 C 仿真场景及参数保护检查；坐标除法、Q11 舍入、LUT 算术等专项验证。
- 后处理核 8 组 C 仿真场景及参数保护/独立浮点参考；面积、NMS 和宽位阈值乘积专项验证。
- OpenCV 对比覆盖 519,168 个 INT8 字节，最大误差 1 LSB；填边正确，九组 fix_point 的量化 LUT 一致。
- RTL smoke 是代表性事务覆盖，不是对所有尺寸、图像和候选组合的穷尽验证。

这些是既有验证记录；编写本文时没有重新运行 HLS 综合、RTL 仿真或完整 Vivado 构建。

### 7.5 延迟数据的正确解读

候选验证记录中的 RTL smoke 周期数如下：

| 项目 | 记录的周期数 | 按标称 200 MHz 折算 |
|---|---:|---:|
| 图像核 smoke 事务范围 | 260～1,126,267 | 1.30 μs～约 5.631 ms |
| YOLO 核 smoke 事务范围 | 1,390,494～1,397,142 | 约 6.952～6.986 ms |

图像核范围包含不同测试事务，低端数值不能当作完整有效图像帧处理时间。上述范围也不是所有合法输入的最坏延迟保证；尤其 NMS 工作量与候选数相关。

**不能用这些仿真延迟直接宣布系统 FPS 或加速倍数。** 板端总延迟还包括图像采集/解码、缓冲区拷贝、缓存同步、DPU 执行、DDR 竞争、主机调度、显示和软件回退。

## 8. 工程组织与主要产物

| 位置 | 用途 |
|---|---|
| `/home/amd/Workspace/dpu_platform2/kv260_hardware_platform/kv260_hardware_platform/kv260_hardware_platform.xpr` | 基础 Vivado 平台，包含两个静态视觉核 |
| `/home/amd/Workspace/dpu_platform2/kv260_hardware_platform/kv260_hardware_platform/ip_repo/vision` | 实际安装的两个 HLS IP 快照 |
| `/home/amd/Workspace/dpu_platform2/kv260_hardware_platform/kv260_hardware_platform/vision_integration` | 集成/更新脚本、快照清单、备份和阶段记录 |
| `/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_base/export/dpu_base/dpu_base.xpfm` | Vitis 平台描述 |
| `/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_kernels/src/prj/Vitis/dpu_conf.vh` | 当前 DPU 配置，B3136 + URAM |
| `/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu-link.cfg` | DPU/Softmax 实例数量、时钟和内存连接配置 |
| `/home/amd/Workspace/HLS_IP/timing_extreme_20261014/sources/image_preprocess/src/image_preprocess.cpp` | 被集成优化版本的图像核 C++ 源码 |
| `/home/amd/Workspace/HLS_IP/timing_extreme_20261014/sources/yolo_postprocess/src/yolo_postprocess.cpp` | 被集成优化版本的 YOLO 核 C++ 源码 |
| `/home/amd/Workspace/dpu_platform2/bd_accelerator_integration` | 较早的生成后链接工程集成记录，不代表当前全部状态 |

主要交付产物：

- XCLBIN：`/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.xclbin`
- 最终 bitstream：`/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.build/link/int/system.bit`
- 基础平台 XSA：`/home/amd/Workspace/dpu_platform2/kv260_hardware_platform/kv260_hardware_platform/kv260_hardware_platform.xsa`
- 最终链接 Vivado 工程：`/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.build/link/vivado/vpl/prj/prj.xpr`

基础平台 XSA 与最终包含 DPU 的系统 bitstream 角色不同，不能把任意 XSA/HWH 与任意 bitstream 混用。修改核或基础平台后，应按“更新 IP/BD → 重新构建平台 → 导出 XSA → 更新 Vitis 平台 → 重新链接 DPU”的链路保持产物一致，而不是只替换某个旧硬件文件。

## 9. 当前边界与后续验收

### 9.1 已有明确证据

- 两个视觉核有实现源码、导出的 RTL/IP 和主机辅助模块。
- 当前基础平台与最终链接 BD 都包含两个核。
- 最终系统完成综合、布局布线并生成 bitstream/XCLBIN。
- 当前约束下 setup、hold 和脉宽检查通过。
- 已有核级 C 仿真、代表性 RTL 协同仿真和数值对比记录。

### 9.2 仍不能宣称完成

- 完整摄像头应用已经在板端调用两个核并长期稳定运行。
- VART TensorBuffer 到两个静态 HLS 核之间已经实现零拷贝。
- 特定相机模式或 1080p 下保证固定 FPS。
- CPU 占用、功耗、端到端延迟相对软件基线的明确改善比例。
- 全部真实数据集上的精度等价，以及所有候选分布下的后处理延迟保证。
- 任意模型尺寸、类别数、anchors 或其他 YOLO 版本的自动兼容。

### 9.3 建议验收顺序

1. **基础访问**：加载匹配硬件，核对寄存器、ABI、轮询/中断、错误返回和超时恢复。
2. **单核正确性**：固定输入对比软件参考，覆盖边界尺寸、stride、增强模式、量化设置、候选溢出。
3. **完整链路**：接入同一模型，逐帧对比张量和检测结果，确认帧 ID、缓冲区所有权和坐标映射。
4. **性能**：分别记录采集、预处理、DPU、后处理、拷贝/同步和显示时间，记录候选数与回退比例。
5. **并发与稳定性**：持续运行、多缓冲、配置切换、复位/超时、并发 DDR 流量及温度条件。
6. **数据集精度**：评估增强开关、resize 微差、分数/IoU 边界及 NMS 平局行为对业务指标的影响。

## 10. 介绍摘要

本工程围绕 KV260 构建了一个由图像预处理 HLS 核、DPU 神经网络推理核和 YOLO 后处理 HLS 核组成的 AI 视觉加速平台。预处理核完成图像增强、缩放、Letterbox、通道转换和 INT8 量化；后处理核完成三尺度检测输出解码、置信度过滤和可选按类别 NMS。系统通过 AXI-Lite 控制和 DDR 缓冲区交换实现软硬件协同，ARM 端保留采集、调度、坐标还原和业务处理。

当前实现采用 B3136 DPU、200 MHz 视觉核，已完成完整系统硬件构建并生成 bitstream 与 XCLBIN。工程价值在于将推理前后的主要计算也纳入硬件加速，而不只加速神经网络本身。下一阶段重点是主机执行器、缓存与缓冲区管理、完整应用接入，以及板端性能和精度验收。

## 附录：主要核查依据

以下均为本地工程文件；文档中的“通过”指相应记录所述阶段，不表示本文编写时重新运行。

1. 当前 DPU 配置：`/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_kernels/src/prj/Vitis/dpu_conf.vh`，第 42、53 行附近。
2. 最终 BD：`/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.build/link/vivado/vpl/prj/prj.srcs/sources_1/bd/kv260_hardware_platform/kv260_hardware_platform.bd`。
3. 最终构建日志：`/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu_trd_system_hw_link_Hardware.build.ui.log`。
4. 最终时序：`/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.build/reports/link/imp/impl_1_kv260_hardware_platform_wrapper_timing_summary_postroute_physopted.rpt`，第 133～159 行附近。
5. 总资源：`/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.build/reports/link/imp/impl_1_full_util_routed.rpt`。
6. 核资源：`/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.build/reports/link/imp/impl_1_kernel_util_routed.rpt`。
7. XCLBIN 描述：`/home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.xclbin.info`。
8. 平台连接记录：`/home/amd/Workspace/dpu_platform2/kv260_hardware_platform/kv260_hardware_platform/vision_integration/README.md`，第 31～53 行附近；其中构建状态段属于更早阶段。
9. 候选功能与调度证据：`/home/amd/Workspace/HLS_IP/timing_extreme_20261014/README.md`，第 62～90 行；其中不含 DPU 的候选时序不能替代最终系统时序。
10. 图像核接口：`/home/amd/Workspace/HLS_IP/timing_extreme_20261014/sources/image_preprocess/src/image_preprocess.h`；实现见同目录下绝对路径 `/home/amd/Workspace/HLS_IP/timing_extreme_20261014/sources/image_preprocess/src/image_preprocess.cpp`。
11. 后处理核接口：`/home/amd/Workspace/HLS_IP/timing_extreme_20261014/sources/yolo_postprocess/src/yolo_postprocess.h`；实现见绝对路径 `/home/amd/Workspace/HLS_IP/timing_extreme_20261014/sources/yolo_postprocess/src/yolo_postprocess.cpp`。

**本文变更范围：** 仅新增本说明文档，未修改硬件、HLS 源码、主机程序、构建脚本或既有报告，未执行综合、布局布线、烧录或板端性能测试。