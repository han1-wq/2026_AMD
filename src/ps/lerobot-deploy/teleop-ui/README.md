# SO101 遥操作上位机

本机管理页面：`http://127.0.0.1:8088`。
KV260 从臂页面：`http://192.168.43.182:8089`。
本机点击应用菜单或桌面的 **SO101 遥操作** 自动登录。
也可执行 `python3 /home/amd/lerobot-deploy/teleop-ui/open-ui.py`；
加 `--board` 打开 KV260 页面。访问令牌放在 URL fragment，页面读取后立即清除，
仅保存在当前浏览器标签的 sessionStorage 中。直接输入网址时需输入对应 `ui.token` 内容。

本机目录 `/home/amd/lerobot-deploy/teleop-ui`，板端目录
`/home/ubuntu/lerobot-deploy/teleop-ui`。Python 标准库服务 + 原生 HTML/CSS/JS，无额外安装依赖。

## 操作

- **启动实机遥操作**：先启动 KV260 接收端，再启动本机发送端，沿用现有脚本和串口标定。
- **模拟联调**：相同网络链路，使用模拟关节，不打开串口。
- **停止遥操作**：本机停止发送端，再停止板端；从臂按既有程序尝试保持位置且保持扭矩。
- 实机和模拟不会互相覆盖，需先停止当前会话。重复启动同模式不会创建第二个进程。
- 页面能识别在终端启动的已有进程，打开页面不会中断正在运行的遥操作。
- KV260 页面只管理接收端；单独启动接收端仍需本机发送端，接收端默认等待 60 秒。
- 关闭浏览器或重启上位机服务不等于停止遥操作。停止使用页面按钮，或本机执行
  `docker stop --time 10 so101-network-leader`。

位置反馈取自现有从臂日志（约每 100 次写入更新），不是逐帧遥测。
显示的是实际反馈与限幅后的下发目标，不是主臂原始位置。
停止后的值标记为历史数据。日志保留当前会话与上一会话 `.previous`。
原本 ±5 逐次目标限幅、20 Hz 和 1 秒有效期保持不变。

## 服务管理

本机：

```bash
systemctl --user status so101-ui-local --no-pager
systemctl --user restart so101-ui-local
journalctl --user -u so101-ui-local -n 30 --no-pager
```

KV260：

```bash
systemctl --user status so101-ui-board --no-pager
systemctl --user restart so101-ui-board
journalctl --user -u so101-ui-board -n 30 --no-pager
```

服务启用后在用户服务管理器启动时运行。若希望未登录即启动，可配置用户 linger；
是否已启用以 `loginctl show-user <用户名> -p Linger` 为准。
服务本身不会自动开始机械臂运动。IP 改变时同步修改网络遥操作脚本、服务参数及启动器。

## 访问控制

本机只监听回环地址；板端监听 8089 并只接受指定 Host。
管理接口要求独立访问令牌或两端 HMAC 签名，校验来源、请求时戳和重放，
不提供任意命令执行、文件访问或 shell 接口。
`api.key` 为两端共享管理密钥；`ui.token` 为各自浏览器令牌；本机 `board-ui.token`
是板端令牌副本，便于打开板端页面。这些文件权限 600，不能提交到版本库。
当前 HTTP 用于可信局域网，不提供传输加密；不要将端口映射到公网。
HMAC 管理请求要求两端时钟误差不超过 30 秒；遥操作运动协议仍不依赖墙上时钟。

## 测试

```bash
cd /home/amd/lerobot-deploy/teleop-ui
python3 -B -m unittest -v test_server
```

测试包含认证、重放、跨站来源、重复操作、模式冲突、启动顺序、失败回滚、
停止错误传播及无硬件子进程的真实启动/停止。