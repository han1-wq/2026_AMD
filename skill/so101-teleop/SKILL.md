---
name: so101-teleop-safety
description: Audit SO101 simulated protocol, authentication, sequence expiry, device calibration and disconnect holding without enabling hardware.
---

# SO101协议、遥操作与管理界面

## 适用场景

检查局域网遥操作协议和UI状态管理、认证、超时/重放、断连行为。离线协议测试是默认范围；网络dry-run也需要确认端点，不能默认连接原README中的主机。

## 输入与前置条件

- 明确模拟协议、网络模拟、只读设备探测还是实机遥操作；四种范围不能混用。
- 实机阶段需主/从臂身份、串口稳定路径、设备自身标定与JSON匹配、模式/扭矩条件和现场停机准备。
- 私有session/API/UI密钥由部署者管理，不随包复制；现有排除不等于程序可无密钥运行。
- 不把身体关节归一化范围或夹爪范围当角度/弧度。

## 权威来源

- [网络遥操作说明](/home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/network-teleop/README.md)
- [协议与硬件分支](/home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/network-teleop/teleop.py)
- [模拟协议测试](/home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/network-teleop/test_teleop.py)
- [UI及停止语义](/home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/teleop-ui/README.md)
- [历史验证说明](/home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/network-teleop/VALIDATION.md)

## 执行流程

1. 阅读模拟/实机分支，确认离线测试不会实例化真实驱动或打开串口；只用当前白名单文件。
2. 检查有界JSON帧、HMAC、随机挑战、序号、过期判定、一个请求在途和异常退出。
3. 区分遥操作挑战的服务端单调时钟与UI管理请求的墙钟校验；不把两类时钟要求混成“所有通信无需时钟校验”。
4. 保留未认证、重复、过期、非法目标、断连和保持失败的负例。不能通过放宽重放/有效期让测试通过。
5. 审查实际目标限幅与单位；当前说明中的±5、20Hz等为快照设置，不是安全速度保证，亦没有额外跟随误差退出保护的承诺。
6. 网络模拟若获准执行，记录两端模式一致、实际地址、密钥由何种安全方式供应、端口和预期断连退出；默认dry-run的断连退出1不能机械地等同故障。
7. 实机probe虽声明不写寄存器/不启扭矩，仍会打开真实设备，需单独授权和串口独占；不得与发送端并行。
8. UI验收分启动顺序、重复请求、模式冲突、错误回滚、停止错误传播；浏览器关闭不等于遥操作停止，反馈日志不等于逐帧遥测。

离线模拟协议命令：

```bash
cd /home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/network-teleop
PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s /home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/network-teleop -p 'test_teleop.py' -v
```

UI的test_server不在当前统一回归白名单中；若需运行，先逐项审查子进程mock、监听地址、文件写入和设备依赖，不能因名字含test就执行。

## 验收与输出

输出协议测试退出码/数量、认证负例、超时/断连预期与实际结果。实机结果须另记录发出的目标、实际位置、保持尝试/失败和最终状态。

断连保持仍保留扭矩和供电，串口重试会影响响应；软件保持不是硬件急停，HOLD_FAILED必须明确失败。HMAC不等于传输加密，不公开局域网管理端口。

## 常见故障

- 认证失败：核对安全分发和双方模式，不把密钥写日志或禁用认证。
- UI显示旧位置：核对反馈时间与会话标识，不声称实时到位。
- 断连后仍有扭矩：这是既有保持策略，不误报为断电停止。
- 主/从模式冲突：先结束已有会话，不偷偷切换现有运行模式。

## 禁止与停止条件

不自动标定、改舵机模式/ID、释放扭矩或启动--hardware。不跨设备沿用标定；串口故障、保持失败、身份不明、现场无人时停止升级到实机测试。

## 调用示例

使用P3检查自己协议的过期/重放与断连模拟负例，解释保持与急停差异，不打开串口。

## 复用方法

替换设备、标定、单位、会话认证、目标范围和超时；用P3生成重放/过期/断连/保持失败负例。复用状态语义而不是±5等应用数值；HOLD不等于断电急停，缺少实际停机策略时不得进入实机。

## 已验证效果

[历史协议日志](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/so101_protocol.log)11项模拟协议测试通过；本轮未重跑。结果不包含真实串口、扭矩、标定或UI管理层完整验证。

## 经验来源

[协议实现](/home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/network-teleop/teleop.py)及[原验证说明](/home/amd/kv260-ofdm-reproduction/src/ps/lerobot-deploy/network-teleop/VALIDATION.md)体现认证、过期/重放和断连保持。提炼“软件状态不等于硬件急停”；没有记录的危险动作不写成亲历事件。
