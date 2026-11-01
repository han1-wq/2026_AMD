# 离线验证矩阵与验收门槛

此表描述[统一回归实现](/home/amd/kv260-ofdm-reproduction/sim/run_software_checks.py)，不是本次技能补充重新运行各业务测试的声明。历史打包结果查看[原summary](/home/amd/kv260-ofdm-reproduction/sim/results/packaging-validation/summary.json)及[原摘要](/home/amd/kv260-ofdm-reproduction/report/PACKAGING_SUMMARY.md)。新增代码/环境可能改变通过数，不能硬编码旧计数为验收。

## 当前白名单

| 任务名 | 实际入口/范围 | 成功判据 | 未覆盖 |
|---|---|---|---|
| environment | 标准Python版本/platform | 退出0，记录版本 | 依赖全部可用 |
| numpy_environment | 指定Python导入NumPy | 退出0，版本可见 | torch/ROS/板端环境 |
| ofdm_host | OFDM host目录test_*.py | unittest成功，跳过独列 | 实机UART/TCP/RF |
| vision_controls | B3136 test_controls.py | unittest成功 | overlay、DPU、相机 |
| navigation | navigation-fix目录test_*.py | unittest成功 | 导航实机、ARM64构建 |
| so101_protocol | test_teleop.py | unittest成功 | 真实舵机、标定、UI |
| hls_host_config | test_host_config.py | unittest成功 | HLS核C/RTL数值矩阵 |
| hls_link_config | test_link_config.py | unittest成功 | 有效xo、v++链接、实现 |
| b3136_artifacts | artifacts.sha256 | 所有入册工件校验且退出0 | 运行源码/当前板卡匹配 |
| ofdm_xsa | check_dma_xsa.py与TOP.xsa | 退出0且DMA_XSA_PASS | bit/ELF已烧录或RF可用 |
| dma_packets | iverilog编译与vvp执行 | 两段退出0，DMA_PACKETS_PASS | 实际AXI/射频环境 |
| dma_control | iverilog编译与vvp执行 | 两段退出0，DMA_CONTROL_PASS | 完整平台实现 |
| dma_link | cc编译与本机运行 | 两段退出0，DMA_LINK_PASS | 真实网络/无线电 |
| dma_services | cc编译与本机运行 | 两段退出0，DMA_SINGLE_BOARD_SERVICES_PASS | 双板或RF实验 |
| dma_phy | cc编译与本机运行 | 两段退出0，BOARD_PHY_PASS | 真实PHY初始化 |

统一入口总计20个任务记录（环境、软件/工件检查和5组编译/运行），不等于20条单元测试。记录完整需summary.complete=true、summary.ok=true、每项ok=true，并核查日志；现有标志匹配是子串检查，人工还要检查错误输出。

## 运行准备

先审查上述任务与测试文件是否自归档以来变更，确认没有新增设备访问。检查Python、NumPy、bash、cc、iverilog、vvp、sha256sum。不会自动安装依赖到原环境。

同一个python3已具备NumPy时：

```bash
python3 -B /home/amd/kv260-ofdm-reproduction/sim/run_software_checks.py --python python3
```

如果NumPy在另一个已有解释器中，按脚本的`--numpy-python`传入经确认的绝对解释器路径。不要把原机器的虚拟环境路径当作交付内容。默认新建UTC命名输出目录；有`--output`时也必须位于包内且未存在。每任务默认超时180秒，可用正整数`--timeout`修改并记录理由。

## 不属于当前白名单

- HLS完整csim/synth/cosim/export、Vivado综合/实现、XSCT固件构建、ARM64 Docker构建。
- B3136板端增强测试、probe_hardware、run_vision自检、实时ROS/相机验证。
- 启动器所有测试、RoArm控制台tests、SO101 UI test_server：并非说它们必有硬件动作，而是本次统一回归尚未覆盖，执行前须审查。
- validate_vision_live、validate_ofdm_ai_live、串口/TCP benchmark、任何标定/遥操作/JTAG。

## 技能库自检

新增检查器只读技能目录、目录JSON、文档链接目标和导入技能字节，不导入工程模块，不执行文档代码块。

```bash
python3 -B /home/amd/kv260-ofdm-reproduction/skill/tools/check_skills.py
python3 -B -m unittest discover -s /home/amd/kv260-ofdm-reproduction/skill/tools -p 'test_*.py' -v
```

检查器退出0且JSON ok=true才算结构检查通过。该结果证明目录/引用/章节约束，不证明技术内容、硬件安全或技能中的操作已执行。

可复用性补充：结构检查现在要求复用方法、已验证效果和经验来源；后两项必须带来源链接。链接存在不能证明陈述真实，仍需人工审核。`--relocate`映射来源根并严格核查完整包；`--standalone`只核查skill内部并列出未检查的外部引用。数值/资源/PYNQ预检及迁移测试属于新增工具层，不加入上面20个历史业务任务计数。实际覆盖见[本轮记录](/home/amd/kv260-ofdm-reproduction/skill/evidence/reuse-validation.json)。