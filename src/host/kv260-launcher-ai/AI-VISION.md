# KV260 独立 AI 视觉

本地工作副本：`/home/amd/kv260-launcher-ai`。板端部署：`/home/ubuntu/x3plus-kv260-docker`，推理运行时：`/home/ubuntu/kv260_B3136`。

在 **KV260 X3plus ROS 启动器 → AI 视觉 → 打开 AI 视觉界面** 打开专属窗口，或直接打开桌面的 **KV260 AI 视觉**。窗口打开只显示状态；点击“启动视觉”才加载模型和相机。已有 B3136 实例时不会加载第二次。

```bash
DISPLAY=:0 XAUTHORITY=/run/user/1000/gdm/Xauthority \
  python3 /home/ubuntu/x3plus-kv260-docker/launcher_vision_ui.py
```

窗口包含实时 640×480 检测画面、启动/安全停止、恢复默认、画面保存、日志、FPS、RGB-D 配对、阶段耗时和生效配置号。

| 控件 | 范围/选择 | 实现 |
|---|---|---|
| 亮度 | −255～255，默认 0 | HLS color LUT |
| 对比度 | 0～4，默认 1 | `clip(round(contrast*(value-128)+128+brightness))` |
| 饱和度 | 0～2，默认 1 | HLS 定点 Q12，0 为灰度 |
| 直方图均衡 | 关闭／当前帧／上一帧 | HLS 亮度直方图/CDF |
| 增强同时用于 DPU 推理 | 默认关闭 | `ENHANCE_TENSOR` 分支 |
| 显示画面 | HLS 增强图／原始图 | 只切换显示，保持检测框与该帧绑定 |

默认增强预览与模型原图输入独立。勾选“增强同时用于 DPU 推理”后，模型读取增强后的图像；过度增强可能改变置信度和误检情况，不保证准确率提升。当前帧均衡先统计本帧再输出；上一帧均衡应用历史 LUT 并统计本帧，首帧及参数改变后重建历史，场景突变时可能存在一帧滞后。此处为全局亮度均衡，不是 CLAHE。

参数拖动合并为 180 ms 更新，运行时在 HLS `ap_done` 后更新 LUT 和寄存器；每帧检测消息中的 `preprocessing` 包含实际配置 ID 和参数。画面需经过完整推理流水线，显示调节有几百毫秒反馈延迟。重置仅恢复图像参数，不重载 FPGA。模型固定为现有 416×416 YOLOv4。

UI 使用普通用户 Python/Tk。控制与状态目录为 `/run/user/1000/kv260-b3136-ui`：`controls.json`、`status.json` 与一个最新 `frame.ppm`。运行时采用原子替换，有界队列/CMA；不持续保存图像。画面保存到 `/home/ubuntu/Pictures/KV260-AI`，PPM 为无损 RGB 图像。GUI 关闭保留推理；“安全停止”经现有固定 sudo 入口向推理主进程发 SIGINT，等待 `CLEANUP_OK`。出现 DRAINING 时保留 DMA 和锁，不强制终止。

启动器 `vision`、`stop-vision` 和停止全部服务已连接 B3136。旧版固定 sudo 入口 `/home/ubuntu/kv260_yolov4_deploy/remote_camera_yolov4.py` 仅增加固定 `KV260_B3136_ACTION=run/stop/test` 分发；其他调用仍运行原程序。新路径不添加 sudoers 规则。旧推理运行时，新路径会拒绝重载 overlay。

结果主题为 `/yolov4_b3136/detections`（ROS2 JSON），与旧版 `/yolov4/detections` 不同。RGB-D 深度仍为归一化中央 ROI 近似值，未标定/配准。

OFDM 通信的“采集 AI 视觉当前帧”和“拍照发送并显示回传”默认复用此窗口的共享画面，不再依赖旧 `/yolov4/image`。先启动 AI 视觉，兼容 ROS 图片主题留空；点击后等待新帧，保存含检测框/距离的无损 PNG，再通过原有 TCP 5001 图片回环发送并显示实际校验通过的回传文件。采集内容跟随“显示画面”的原始/增强选择；增强是否影响模型仍由“增强同时用于 DPU 推理”决定。PNG 和对应帧的配置、检测、SHA256 元数据保存在 `~/.local/state/kv260-launcher/ofdm-images/`，JSON 仅留本地。视觉停止或没有新帧时采集失败，不发送遗留画面。“停止采集”只取消截图；停止推理使用“安全停止”。配置过 `OFDM_YOLO_TOPIC=/yolov4/image` 时需删除该覆盖或清空界面字段；显式填写图片主题保留旧 ROS 兼容模式，不能填写 JSON 检测主题。

2026-10-14 OFDM 适配验证：截图/界面/载荷 16 项回归及启动器 35 项回归通过。真实嵌入式图片页按钮触发 B3136 采集、发送、回传显示成功，首轮 PNG 524,120 字节，CRC32 `1e09cf3e`，SHA256 `9e615f5b6d489159852b0b61e9952ab96d4a214d4a38dea4613979a15f8286c8`，传输 0.765 秒，发送与回传逐字节一致。`validate_ofdm_ai_live.py` 可复测此路径，需要视觉已运行且 OFDM TCP 客户端空闲；证据为 `logs/ofdm-ai-live-validation.json/.log`、`logs/ofdm-ai-live-desktop.png`。此次首次启动因 CMA 预留不足被现有保护拒绝并完成清理，稍后重试正常；未降低保护阈值。停止全部服务脚本经源码确认调用 `stop-astra-rgbd-yolov4.sh`；本次没有执行全停，以保留其他服务。

修改前备份在 `/home/ubuntu/kv260-launcher-backups/hls-ai-20261014`。回退前先安全停止推理，再恢复对应启动器、入口和运行源码。

验证命令与证据：

```bash
cd /home/ubuntu/kv260_B3136
python3 -m unittest test_controls -v
KV260_B3136_ACTION=test sudo -n --preserve-env=KV260_B3136_ACTION \
  /usr/local/share/pynq-venv/bin/python3 \
  /home/ubuntu/kv260_yolov4_deploy/remote_camera_yolov4.py

cd /home/ubuntu/x3plus-kv260-docker
python3 -m unittest test_launcher -v
```

自检额外覆盖增强预览与原图张量隔离、增强推理输入、饱和度灰度/裁剪、当前帧均衡、上一帧历史及配置重置。`validate_vision_live.py` 是板端真实相机 GUI 集成测试，会启动推理、依次调整六组参数并安全停止；不要在其他视觉实例运行时执行。

2026-10-14 验证：两个参数测试、启动器原 35 项测试、启动器/独立窗口 X11 烟雾测试均通过；增强硬件自检七组通过。首次 GUI 真实调参约 30 秒完成 183 帧，183 帧深度配对，182 条发布，平均 6.15 FPS，延迟 P50/P95 355/385 ms。最终版本复测含桌面截图，共 53.38 秒、329 帧/329 条发布，其中 325 帧满足深度时间窗，平均 6.16 FPS，最近 256 帧延迟 P50/P95 356/389 ms；六组配置均收到实际帧确认，SIGINT 后 CLEANUP_OK、进程退出且无推理/深度残留。独立 ROS2 验证收到 81 条消息，全部配对并使用 HLS 后处理，零验证错误。这里是功能与连通性验证，不是标注数据集精度测试。

额外计时字段 `pre_submit_ms`、`pre_kernel_wait_ms`、`pre_tensor_sync_ms`、`pre_preview_copy_ms` 用于区分主机搬运和 HLS 等待。一次默认设置的真实帧观测为 6.43/4.33/0.32/13.89 ms，主机调度会导致波动；`pre_kernel_wait_ms` 仍包括 MMIO/poll，并非纯硬件周期。新 GUI 不宣称提高检测 FPS。

证据在 `/home/ubuntu/kv260_B3136/logs`，已同步到本地同名工程 `logs`：`enhancement-selftest.log`、`launcher-ai-tests.log`、`vision-live-validation.json/.log`、`ros-enhanced.json/.log`、`vision-live-desktop.png`。运行任务日志使用原有 256 KiB 轮转 `~/.local/state/kv260-launcher/vision.log`。截图通过 `capture_desktop.py` 读取当前板端 1920×1080 RGB565 X11 桌面；该工具为本板验证用途。