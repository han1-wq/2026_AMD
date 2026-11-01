# 源码

按 `kv260/`、`ofdm/`、`ps/`、`host/` 分组保存11个原工程。

- `kv260/HLS_IP/`：图像前处理、YOLO后处理源码/主机配置、testbench及优化实验。
- `kv260/dpu_platform2/`：Vivado/Vitis平台、Block Design、自定义IP、约束及工程材料。
- `ofdm/eeSDR_ofdm_loopback/`：RTL、IP配置、board、PS固件、上位机及原仿真视图。
- `ps/`：KV260 B3136视觉、X3plus导航、LeRobot、RoArm及历史视觉分支。
- `host/`：独立启动器及RoArm视觉控制台；与PS项目紧耦合的PC工具保留在原工程内部。

内部引用优先保持原布局；跨分类目录使用交付包内部相对链接，不链接回原工程。执行脚本前仍要审核其硬编码旧绝对路径。没有将不同项目的同名启动器文件强行合并。

原样复制文件在 `report/source_manifest.csv` 中逐一记录。新包装脚本在 `build/`、`sim/`，没有修改原源码来“修复”尚未解决的集成缺口。具体排除规则、第三方许可及隐私注意事项见根README和报告。