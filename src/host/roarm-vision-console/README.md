# RoArm 本机视觉控制台

工作目录：`/home/amd/roarm-vision-console`。

## 启动

```bash
cd /home/amd/roarm-vision-console
.venv/bin/python server.py --port 8877
```

浏览器访问 <http://127.0.0.1:8877>。模型默认使用 Responses、
`gpt-6-astra`、Medium。API 密钥可在界面输入，只保存在服务进程内存，
不写配置文件、不传到 KV260、不放入运行日志。服务重启后需要重新输入。
也支持启动时通过 `ROARM_API_KEY` 环境变量传入，不要在终端命令中写出明文密钥。

本次新部署服务使用 `--port 8878`，地址 <http://127.0.0.1:8878>；旧 8877
观察服务已停止。代码更新不会自动重载已导入模块；重启需重新在页面配置密钥。

使用项目现有虚拟环境中的 requests、NumPy 和 Pillow；本机显示不依赖 OpenCV。
KV260 ROS 图像压缩仍使用其已有 OpenCV。

## 当前能力与限制

- 实时 RGB/YOLO、原始深度伪彩图、检测信息、帧新鲜度、同步差。
- 通过既有 `RoarmDriver` 和 SDK 读取串口反馈。ROS 域 99、localhost，
  移除驱动的模拟 joint_states 订阅；视觉读取使用域 0。
- 使用 `skills/visual-servo/SKILL.md` 请求图像相对观察与短动作建议。
- 单次分析、最多 20 次连续观察、可中断的本机观察循环。
- 模型返回时标记观察帧时间及模型延迟；延迟结果不会直接用于运动。
- `/api/servo` 启动最多 20 次模型决策的实机闭环：当前图像、上一步图像、
  编码器反馈和已执行动作送入模型。模型选择一个单关节弧度短步，控制器校验后
  调用 SDK `joint_radian_ctrl`，读取到位反馈并等待动作后的新画面。
- 仅关节 1–5；单步 0.003–0.012 rad，SDK speed=30、acc=5；本连接累计
  运动 ≤0.18 rad、各关节相对初始姿态 ≤0.08 rad。夹爪开合、任意串口命令、
  复位和扭矩切换不开放。运动异常后该远端连接不再接受动作。
- 标定要求局部自由空间证据；接近要求尖端可见和该关节的实际标定历史；推动
  另需接触和远离相机方向证据。模型置信度 ≥0.85。RGB 深度未配准，不能
  当作接触证据。全图变化检查只是粗略守卫，不构成完整碰撞检测。
- “停止观察任务”立即取消后续循环并丢弃在途模型结果；HTTP 模型请求本身可能
  持续至超时（最长约 100 秒）。已发出的单个短步可能完成；它不是机械臂硬件急停。
- 模型报告完成后进入“完成证据待核验”，不自动宣布推动成功。每轮前后图像、
  决策和实际反馈保存在 `inspection/servo-时间/`。代码测试通过不代表实物推动成功。
- 动作记录区分 `dispatch=not_sent/sent/unknown` 与 `motion_verified`。
  场景变化丢弃属于未发送；发送后错误保存为 `*-failed.json`，包含可获得的
  前后编码器、目标和错误。上位机与远端均检查同向、至少 0.001 rad 位移、
  不超过 0.004 rad 目标误差；零位移即使处于目标容差内也不能判成功。

临时远端代码通过 SSH 内存运行，`PYTHONDONTWRITEBYTECODE=1`；
不修改 `roarm_ws` 功能文件。SSH 复用
`/run/user/1000/kv260-desktop-amd-16080.sock`。

## 测试

```bash
cd /home/amd/roarm-vision-console
.venv/bin/python -m unittest discover -s tests -v
```

测试不移动真实机械臂。实机反馈及源文件校验结果保存在
`/home/amd/roarm-vision-console/inspection/`。