# 部署验证记录

## KV260 两台附加 USB 摄像头核验

后续并发探索又测试5组低分辨率/低帧率/混合格式配置与反向启动，均未通过双路采集。
MJPEG请求15 fps被设备改回60/30 fps；YUYV低分辨率和720p低帧率仍报ENOSPC。
实际检查到两设备选择最大等时传输档位，支持USB带宽预留限制的判断。
详细结果见 `/home/amd/lerobot-deploy/teleop-ui/camera-check/DUAL_CAPTURE.md`
及板端同名目录；没有修改内核驱动参数，也没有中断遥操作。

- Integrated Camera（0c45:64ab）：通过
  `/dev/v4l/by-id/usb-XHH-260202-H_Integrated_Camera-video-index0`
  采集 1280×720 MJPEG，读取并解码 120 帧，导出的 JPEG 已人工视觉核验。
  设备声明 60 fps，此次短采集不代表已验证持续 60 fps；解码有 APP 字段警告但得到正常图像。
- Web Camera（4a54:5232）：通过
  `/dev/v4l/by-id/usb-Generic_Web_Camera_20250708V1.000-video-index0`
  单独采集 1280×720 MJPEG，得到 45 帧和正常 JPEG，已视觉核验。
- 两路 720p 同时启动失败一路；降低到 Integrated 640×480 MJPEG/60 和
  Web 640×360 MJPEG/30 后仍失败一路，报 `VIDIOC_STREAMON: No space left on device`。
  两台位于同一 USB 2.0 Hub，存在 USB 带宽分配限制；没有宣称双路并发已通过。
- `video-index1` 节点不具备 capture 能力，不作为第二台摄像头。
  另外还识别到 Astra Pro RGB，此次未采集它，也未验证其深度输出。
- Integrated 未提供独立 USB 序列号，当前型号可区分；未来同型号设备可能冲突。
  视频编号变化时应使用上述稳定路径，不固定使用 `/dev/video2`、`/dev/video4`。
- 截图及结果保存在两端 `teleop-ui/camera-check`；采集后摄像头已释放，
  两端遥操作仍运行，从臂当前会话写入计数 13,500，反馈继续更新。

## 浏览器上位机部署验证

本机 `/home/amd/lerobot-deploy/teleop-ui` 和板端
`/home/ubuntu/lerobot-deploy/teleop-ui` 已部署管理服务，复用原有遥操作脚本。
本机访问 `http://127.0.0.1:8088`，KV260 访问 `http://192.168.43.182:8089`。
本机桌面与应用菜单提供“SO101 遥操作”入口，可自动登录。

- 两端管理服务各 11 项测试通过，覆盖认证、重放、跨域、模式冲突、重复操作、
  启动顺序、回滚与无硬件进程生命周期。
- Firefox 79 实际浏览器检查通过：两端页面服务连接正常、6 个关节行、
  令牌 fragment 已清除、停止按钮可用。记录在本机
  `/home/amd/lerobot-deploy/teleop-ui/browser-result.log`。
- 只读接管已有实机运行，未重启机械臂进程。部署前后从臂计数从 7,100
  增长到至少 16,400；两端管理 API 确认实机进程运行，反馈持续更新。
- 未点击实机启动/停止按钮，因此没有将按钮的实机启停和真实失联保持记为已验证。
- 页面关闭不停止遥操作；上位机服务启动不自动启动机械臂。用户服务已启用，
  当前板端 linger 未启用，尚未验证整机重启后未登录自动运行管理服务。

## 当前版本：恢复本机限幅行为并启动实机

已移除初始姿态差值拒绝、额外速度限制和跟随误差退出逻辑；使用原本本机
`max_relative_target=5.0` 的逐次目标限幅。网络指令有效期默认改为 1 秒，
保留消息校验、过期拒绝与失联保持扭矩。下方旧版的 300 ms 和初始对齐要求不再适用。

更新后的两端 11 项测试通过，包含大初始偏差仍启动并限幅的回归测试。
用户授权后已启动实机，首个目标从腕部反馈 72.105 限幅到 67.105；
第 100 个目标时腕部反馈为 59.386、目标 58.633，确认发生真实位置跟随。
运行记录：KV260 `/home/ubuntu/lerobot-deploy/network-teleop/live-server.log`；
本机 `/home/amd/lerobot-deploy/network-teleop/live-client.log`。
本机可执行 `docker stop --time 10 so101-network-leader` 停止，断连后从臂尝试保持并保留扭矩。

## 初始版本的历史验证

- 本机及 KV260 Python 标准库单元测试：11 项通过，覆盖消息分片/连续帧、签名错误、
  超大帧、超时、断连、无效数值、重放、速度限制、启动姿态不一致和模拟保持写入。
- 两端只读硬件探测通过：六关节舵机标定与文件一致、位置模式正确，主臂扭矩关闭。
  没有执行运动目标写入、扭矩切换或标定写入。
- 实际网络默认 300 ms 有效期测试：一次传输超过 100 个目标后超时；再次测试也超时。
  接收端按预期终止，未自动重连。日志 `dry-run-server.log`、`dry-run-disconnect-server.log`。
- 实际网络故障注入：主动断开、非法目标、过期响应、重放序号全部被拒绝并终止会话。
  对应 `lan-disconnect.log`、`lan-invalid.log`、`lan-expired.log`、`lan-replay.log`。
- 临时设置 1 秒有效期的模拟诊断：4 秒内发送 75 个目标，客户端正常结束，服务端记录 EOF
  并进入模拟保持。默认仍为 300 ms。日志 `diagnostic-1s-client.log`、`diagnostic-1s-server.log`。
- 12 次 ping：0% 丢包，平均 16.868 ms，最大 73.386 ms；此短样本不能排除偶发长延迟。

只读探测姿态（归一化单位，非角度）：

| 关节 | 主臂 | 从臂 |
| --- | ---: | ---: |
| shoulder_pan | -5.123 | -0.812 |
| shoulder_lift | -99.747 | -96.459 |
| elbow_flex | 99.636 | 100.000 |
| wrist_flex | 54.227 | 70.175 |
| wrist_roll | 0.709 | 1.151 |
| gripper | 0.249 | 3.223 |

当前腕部差约 15.95，大于 5 单位启动阈值。需要人工对齐后重新探测，不应关闭该保护。
当前 Wi-Fi 链路在 300 ms 门限下不稳定，尚未验证持续实机跟随。
软件保持仅完成 mock 验证；故障注入测试在模拟模式执行，真实保持动作尚未执行验证。
运行进程未作为后台服务安装；每次使用需手动启动，两端异常后不会自动恢复。