# KV260 B3136 ROS2 RGB-D YOLOv4

已在 `ubuntu@192.168.43.182` 的 `/home/ubuntu/kv260_B3136` 完成两个 HLS 核、DPU 和相机流水线实测。默认配置为 **1 个 VART runner、2 个帧槽**。本地部署目录为 `/home/amd/kv260_B3136`。

## 启动

在 KV260 上执行（需要 sudo 权限）：

```bash
bash /home/ubuntu/kv260_B3136/run_vision.sh --self-test --headless

bash /home/ubuntu/kv260_B3136/run_vision.sh --headless --seconds 90 \
  --summary /home/ubuntu/kv260_B3136/logs/run.json \
  --snapshot /home/ubuntu/kv260_B3136/logs/run.jpg
```

持续运行时省略 `--seconds`；Ctrl+C 请求排空并退出。桌面显示时省略 `--headless`，需要可访问的 X11 `DISPLAY` / `XAUTHORITY`。后续已确认 OpenCV 桌面窗口显示，并集成独立 Tk AI 视觉界面，见下节。程序不会自动修改 X11 授权。

## 独立 AI 视觉与 HLS 调节

在现有 **KV260 X3plus ROS 启动器 → AI 视觉 → 打开 AI 视觉界面**，或桌面 **KV260 AI 视觉** 打开窗口。点击启动后可调整亮度（−255～255）、对比度（0～4）、饱和度（0～2）、直方图均衡（关闭/当前帧/上一帧）。默认仅增强预览，勾选“增强同时用于 DPU 推理”才改变模型输入；支持原图/增强图显示切换、恢复默认和保存画面。

界面命令为 `/usr/bin/python3 /home/ubuntu/x3plus-kv260-docker/launcher_vision_ui.py`，需要上述 X11 环境。关闭界面保留推理；停止使用“安全停止”。窗口打开不自动启动相机。启动器开始/停止/停止全部服务均已接入 B3136。

使用 `--control-dir /run/user/1000/kv260-b3136-ui` 启用完整 HLS 预览和 GUI 控制。输出同时包含原图推理张量或增强推理张量以及 640×480 BGR 预览。应用 CMA 合计 4,721,760 字节（约 4.50 MiB）；未启用控制目录时保留原 tensor-only 路径。每帧 ROS2 消息新增 `preprocessing`，记录实际亮度/对比度/饱和度/均衡/推理分支和 `config_id`。

参数只在上一帧 `ap_done` 后由单一前处理线程写入；LUT 变更增加配置号，参数变更重置上一帧均衡历史。没有额外 OpenCV 色彩增强路径。当前帧均衡多一次源帧统计；上一帧均衡首帧/参数变更后不应用旧历史。增强不保证提升模型精度。

详细使用与兼容性说明：本地 `/home/amd/kv260-launcher-ai/AI-VISION.md`，板端 `/home/ubuntu/x3plus-kv260-docker/AI-VISION.md`。板端自检日志 `logs/enhancement-selftest.log` 已通过原六项自检和七项增强检查。界面启动/退出烟雾测试以及原启动器 35 项测试通过。

真实 GUI 首次六组调参测试完成 183 帧、183 深度配对、182 条发布，约 29.76 秒，平均 6.15 FPS，P50/P95 延迟 355/385 ms。最终版本复测包含桌面截图，共 53.38 秒、329 帧/329 条发布、325 帧深度配对，平均 6.16 FPS，最近 256 帧 P50/P95 延迟 356/389 ms；界面停止后有 CLEANUP_OK、进程退出，无推理/深度残留。独立 ROS2 检查收到 81 条有效消息，零错误。结果见 `logs/vision-live-validation.json`、`logs/vision-final-gui-run.log` 和 `logs/ros-enhanced.json`；实际桌面截图 `logs/vision-live-desktop.png` 已同步本地。完整预览新增主机搬运开销，不声称提高 FPS，吞吐仍主要受 DPU 约 157 ms 限制。

RGB 使用 Astra UVC 持久设备名、640×480 MJPG。深度由现有 Astra OpenNI2 节点发布，320×240、16UC1/mm、约 30 FPS。已有深度节点时添加 `--external-depth`。可用 `--camera-device` 或 `ASTRA_COLOR_DEVICE` 指定 RGB，`ASTRA_DEVICE_URI` 指定 OpenNI2 设备。

启动脚本校验 `artifacts.sha256`，加载板端现有 PYNQ / ROS2 Humble / Astra 工作区环境，限制数值库线程，并持有 `/run/lock/kv260-b3136.lock`。运行前应停止其他 FPGA/DPU 应用；脚本仅识别部分已知旧推理程序，并非全局 FPGA 资源管理器。

## 数据流与资源

采集 → HLS `image_preprocess_1` → DPU B3136 → HLS `yolo_postprocess_1` → ROS2 / 可选显示。

- RGB 待处理队列和结果队列各保留最新一帧；帧槽数量固定，不无限缓存图像。
- HLS 输入使用物理 CMA 地址、显式缓存同步和 HWH 中的寄存器偏移。前处理使用 RGB、416×312 内容、上下各 52 行填充、416×416 INT8 输入。
- 输入 fix point 为 6，三个输出 fix point 为 2。输出按 52/26/13 尺度放置于连续打包缓冲，VART 输出直接使用其 NumPy 视图，避免逐帧拼接。
- VART Python runner 内部仍有 host/device 搬运，不宣称 DPU 零拷贝。
- 默认应用 CMA 缓冲总计 3,800,224 字节（3.62 MiB），另有 VART、XRT、模型及系统 CMA 占用。
- 后处理最多容纳 256 个候选。状态 2 表示溢出，整帧回退 CPU 解码与 NMS，不发布被截断的硬件结果。

ROS2 输入主题为 `/camera/depth/image_raw`，输出主题为 `/yolov4_b3136/detections`（`std_msgs/msg/String` JSON，BEST_EFFORT、depth=1）。消息包括序号、时间戳、深度偏差、阶段耗时、是否使用 HLS 后处理、候选数、类别/置信度/坐标及近似深度。

**深度未标定、未配准**：使用归一化中央 ROI 的有效深度中位数，消息标记 `uncalibrated_normalized_roi`，画面标注近似值。RGB 时间戳为 V4L2 读取后的主机时间，深度时间戳来自节点发布前主机时间；时间接近不代表严格曝光同步。默认允许时间偏差 100 ms。

## 2026-10-14 板端验证

对比测试阈值为 confidence=0.30、NMS=0.60，均使用相同模型与两个 HLS 核，无窗口。场景为实验台与人员；不是固定图像精度测试。吞吐包含流水线启动后的填充/停止时间，延迟从 RGB `read()` 返回后计至后处理结束，不含传感器、UVC 内部缓存或显示/DDS 传输耗时。

| 配置 | 时间 | 帧数 | 平均 FPS | P50 / P95 延迟 ms | 最终 RSS MiB |
|---|---:|---:|---:|---:|---:|
| 1 runner / 3 槽 | 30.16 s | 188 | 6.23 | 505 / 538 | 279.5 |
| 2 runner / 3 槽 | 30.31 s | 197 | 6.50 | 486 / 516 | 280.5 |
| 1 runner / 2 槽 | 30.11 s | 187 | 6.21 | 349 / 381 | 281.9 |
| 默认配置复测 | 90.11 s | 568 | 6.30 | 349 / 380 | 282.5 |

双 runner 在这次短测中增加约 4% 吞吐；2 槽在接近单 runner / 3 槽吞吐的同时降低约 156 ms 中位延迟并减少 1,424,176 字节应用 CMA，因此选择 1 runner / 2 槽为默认。各轮系统 CMA 状态与后台负载不同，不将系统 CmaFree 差值直接归因于帧槽配置。

90 秒复测：

- 568 帧完成推理、深度配对和发布；无非法深度消息，无候选溢出。
- 最近 256 帧平均前处理 6.31 ms、DPU 157.35 ms、后处理 34.08 ms；稳态区间约 6.35 FPS。这些是主机阶段耗时，包含缓存同步/调度/搬运，不是纯硬件周期。
- 最近 256 帧 P50/P95 延迟为 348.72/379.71 ms。统计缓冲有界，超过 256 帧后不代表全程分位数。
- 最终 RSS 289,252 KiB；含模型加载的进程 RSS 高水位 391,584 KiB（382.4 MiB）。不包含独立深度节点等其他进程的 RSS。
- 采样最小 MemAvailable 1,624,992 KiB（约 1.55 GiB）；采样最小 CmaFree 50,916 KiB（约 49.7 MiB），为每 5 秒及结束时采样，不是连续系统低水位。
- 出现 `CLEANUP_OK`；进程退出后 CmaFree 为 175,408 KiB。停止后没有推理/深度残留进程。系统 CMA 数字会随其他活动变化，不承诺恢复到固定值。

独立 `verify_ros.py` 在 30 秒默认配置测试中收到 187 条消息，187 条有深度配对并标记使用 HLS 后处理，检查序号递增、坐标范围、类别、置信度、深度单位和时间戳一致性，结果无错误。200 个检测中 197 个有有效近似深度。可在另一个终端执行：

```bash
source /opt/ros/humble/setup.bash
/usr/local/share/pynq-venv/bin/python3 /home/ubuntu/kv260_B3136/verify_ros.py \
  --seconds 45 --summary /home/ubuntu/kv260_B3136/logs/ros-verify.json
```

硬件自检输出 `SELF_TEST_OK`，覆盖：

- 常量图像的 DMA、BGR→RGB、填充及 INT8 量化逐字节一致。
- 固定种子随机图像与板端 OpenCV 前处理比较，519,168 字节中 12,444 字节不同（2.40%），最大差值 1 个 INT8 单位。HLS 单次 Q22 舍入与 OpenCV 中间舍入有差异；这是该测试图像的观测结果，不是对所有图像的误差保证。
- 重叠同类框 NMS、全部三个尺度和九组 anchor、带符号输出解码，对照 CPU 的坐标容差 0.03 原图像素、分数容差 1e-4。
- 257 个候选触发整帧 CPU 回退，回退坐标/分数/类别逐项一致。
- 实际 DPU 执行完成，扩展自检记录约 156 ms。

原自检失败是等分候选的保留顺序差异。测试改用明确不同的分数；生产路径仍允许等分时 HLS/CPU 保留不同的重叠框。固定点阈值附近也可能产生决策差异。尚未完成标注数据集的 mAP/召回率对比；快照中存在重复/误检，不能用本次连通性与自检结果代替检测精度验收。也没有测量同模型纯 CPU 前后处理基线的端到端性能，不能声称 HLS 相对旧程序的加速比。

## 停止与故障

SIGINT / SIGTERM 由应用统一接收，ROS2 初始化禁用其默认信号接管，待工作线程排空后关闭执行器和上下文。修复后 SIGINT 测试处理 30 帧，退出码 0，`stop_reason=SIGINT`，有 `CLEANUP_OK`，无 ROS 线程异常或残留进程。

现有 Astra OpenNI2 子进程在停止测试中未在 5 秒 SIGINT 宽限期内退出；包装器会再发 SIGTERM，最多再等待 3 秒，必要时强制结束**深度子进程**。这与保护 FPGA DMA 的推理主进程不同，完整退出可能额外等待数秒。

如果出现 `DRAINING`，主进程会保留 DMA 缓冲与 FPGA 锁，等待加速器空闲。**不要对推理主进程直接 SIGKILL，也不要同时重新加载 overlay。** 当前已测正常结束与 SIGINT，不包含硬件故障注入、随机 AXI 停顿或长期耐久性测试。

`SUMMARY.success` 表示推理路径的结果；还需查看 `CLEANUP_OK` 和进程退出情况以确认释放完成。错误堆栈和 `DRAINING` 原因保留在对应日志中。

## 验证文件

日志、JSON 与快照位于本地 `/home/amd/kv260_B3136/logs`，并在板端 `/home/ubuntu/kv260_B3136/logs` 保留：

- `self-test-expanded.log`：扩展硬件自检通过。
- `camera-w1.*` / `camera-w2.*` / `camera-w1-s2.*`：三组 30 秒配置对比。
- `camera-final.*`：90 秒最终性能测试与快照。
- `ros-w1-s2.json`：独立 ROS2 订阅检查。
- `camera-stop-fixed.*` / `stop-fixed-controller.log`：信号修复后的 SIGINT 测试，退出码 0。

早期失败和试验日志保留供追溯：`camera-stop.log` 包含修复前的 ROS2 线程异常，`camera-sigint.*` 是在信号发送前已定时结束的测试，均不作为最终停止验收证据。

本地/板端 Python 源码与启动脚本哈希逐项一致，两个配置模块与 HLS `host/config.py` 一致；Python 语法、shell 语法及全部七项模型/overlay 工件 SHA256 校验通过。`artifacts.sha256` 校验的是模型与 overlay 工件，不包含运行源码。