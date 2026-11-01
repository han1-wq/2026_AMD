# KV260 双 USB 摄像头并发探索

实际环境：Linux 5.15.0-1077-xilinx-zynqmp，Integrated Camera 0c45:64ab 与
Web Camera 4a54:5232 均经 USB 2.0 480M 总线，连接同一外部 Hub。
测试全程使用 by-id 路径，不修改机器人控制、曝光参数或内核驱动参数。

## 实测矩阵

每组尝试并发读取约 8 秒，成功流直接复制到 null 输出，排除解码/编码性能影响。

| Integrated | Web | 结果 |
| --- | --- | --- |
| MJPEG 640×480 请求15 fps | MJPEG 640×360 请求15 fps | 驱动分别改为60/30 fps，后一路 ENOSPC |
| YUYV 640×480 30 fps | YUYV 640×360 30 fps | 后一路 ENOSPC |
| YUYV 640×480 30 fps | MJPEG 640×360 30 fps | 后一路 ENOSPC |
| MJPEG 640×480 60 fps | YUYV 640×360 30 fps | 后一路 ENOSPC |
| YUYV 1280×720 10 fps | YUYV 1280×720 15 fps | 后一路 ENOSPC |

反向启动 Web，再启动 Integrated，均请求低分辨率 YUYV 5 fps：
两路均被驱动改为30 fps，Web持续采到241帧，Integrated启动ENOSPC。
所以不是仅某一台摄像头失败或单一启动顺序问题。

## 带宽证据

- Integrated 低分辨率 YUYV 运行时选择 alternate setting 3；USB描述符为
  每125微秒 3×1020字节的等时端点。
- Web 低分辨率 YUYV 运行时选择 alternate setting 7；USB描述符为
  每125微秒 3×1024字节的等时端点。
- 两者最大端点预留负载合计约392.832 Mbps，尚未计入协议开销和其他周期传输。
  原始480 Mbps链路速度不能当作可用等时视频带宽。
- sysfs 的 wMaxPacketSize 显示值不包含完整的高带宽事务数，档位容量依据 lsusb 描述符。
- `VIDIOC_STREAMON: No space left on device` 是USB流带宽分配失败；不是磁盘空间不足。
- 请求低帧率、采集后丢帧或缩放图像，不等同于降低设备协商的USB带宽预留。

## 可行方向及限制

1. 将一路接到本机，再通过网络传图：分开USB主控，避免当前两台在KV260上的冲突；
   需要另测网络负载、编码性能和延迟，尚未实施。
2. 使用真正独立的USB总线/主控，或更换为带宽协商正常的摄像头、真正USB3摄像头。
   仅换同一Hub接口、换有源Hub或把USB2摄像头插入USB3Hub，不保证获得独立带宽。
   当前KV260枚举显示所有这些USB2摄像头仍汇聚于同一个480M根总线。
3. 驱动层带宽修正：需核对当前内核UVC实现、设备声明与实际负载后受控验证。
   未修改 quirks、未卸载uvcvideo、未验证补丁；不能宣称此法已经有效。
4. 轮流打开摄像头可避免并发预留，但不是真正的双路连续采集，有重开与曝光延迟。

原始证据：matrix-results.json、reverse-results.json；复现脚本 explore_dual.py。
脚本在摄像头已被占用时拒绝测试，子进程设有时限，并记录实际协商结果。
早前两台各自720p截图已正常解码；本轮未得到双路成功组合，因此未进行长期双路验证。
测试结束后摄像头无占用，两端实机遥操作仍运行，当前会话目标写入22,900次且反馈更新。