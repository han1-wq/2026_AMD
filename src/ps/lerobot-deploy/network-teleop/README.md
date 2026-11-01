# SO101 本机 → KV260 局域网遥操作

本机主臂 R07252801 / 5B91026450，KV260 从臂 R12252801 / 5B91028053。
本机目录 `/home/amd/lerobot-deploy/network-teleop`；KV260 目录
`/home/ubuntu/lerobot-deploy/network-teleop`。两端使用同一份 `session.key`（权限 600）。
使用现有 LeRobot 源码，不替换已有驱动。Python 通信层仅依赖标准库。

## 无运动联调（默认）

在 KV260 终端先运行：

```bash
bash /home/ubuntu/lerobot-deploy/network-teleop/run-follower.sh --duration 12
```

然后在本机终端运行：

```bash
bash /home/amd/lerobot-deploy/network-teleop/run-leader.sh --duration 10
```

默认两端完全不导入舵机驱动、不打开串口；发送模拟的 ±2 归一化单位腕部轨迹。
客户端结束会导致从端打印 `STOP EOFError` 和 `HOLD`，并退出 1；这是断连测试的预期结果。
一次连接结束后服务退出，必须人工重启两端，不会自动恢复跟随。

## 实机运行

确保运动空间空闲。从臂必须已设置为位置模式，
舵机内标定与 JSON 文件一致；主臂必须已关闭扭矩。本程序拒绝自动标定、改模式或释放扭矩。
不再要求初始姿态对齐；身体关节范围 -100…100，夹爪 0…100，单位不是度。
启动时从臂会先以当前位置设置目标，再启用扭矩。

KV260：

```bash
bash /home/ubuntu/lerobot-deploy/network-teleop/run-follower.sh --hardware
```

本机：

```bash
bash /home/amd/lerobot-deploy/network-teleop/run-leader.sh --hardware
```

两端必须选择相同模式。默认 20 Hz；每次目标截取到从臂当前位置 ±5 个单位，
与原本本机 `max_relative_target=5.0` 一致。没有额外的速度限制或跟随误差退出逻辑。
串口读写最多重试 10 次。
正常停止在前台按 Ctrl+C；也可在本机另一个终端执行：

```bash
docker stop --time 10 so101-network-leader
```

## 断连和有效期

TCP 使用有界 JSON 行帧及 HMAC-SHA256。服务绑定 192.168.43.182:5101，
只接受来源 192.168.43.123；地址变化时更新启动脚本或通过 `--host` / `--peer` 覆盖。
会话采用服务端随机挑战和严格序号，每次仅一个请求在途，不缓冲未来目标。
默认挑战有效期 1 秒，以 KV260 单调时钟计算，无需同步墙上时钟。
消息认证不提供加密；共享密钥不得提交或公开。

失联、超时、非法目标、异常退出和 Ctrl+C 均尝试读取从臂当前位置，逐个确认写入保持目标，
再关闭串口且保留扭矩。断线后仍供电；支撑好机械臂后才能切断电源。
这属于软件保护：串口调用和重试可能延长 1 秒的响应时间；系统卡死、SIGKILL、
断电或总线故障无法保证执行保持。若出现 `HOLD_FAILED`，必须现场采取停止措施。
广播运动目标写入本身无舵机确认，保持动作使用逐个有应答写入。

## 本地协议测试

```bash
cd /home/amd/lerobot-deploy/network-teleop
python3 -B -m unittest -v test_teleop
```

只读硬件检查（核对标定/位置模式/位置；不写寄存器，不启用扭矩）：

```bash
# 本机
bash /home/amd/lerobot-deploy/network-teleop/run-leader.sh --hardware --probe
# KV260
bash /home/ubuntu/lerobot-deploy/network-teleop/run-follower.sh --hardware --probe
```

本机启动脚本固定容器名以避免重复控制，不可同时启动探测和发送端。
服务默认等待客户端最多 60 秒，之后退出；可用 `--accept-timeout` 调整到 1–300 秒。