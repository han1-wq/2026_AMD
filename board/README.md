# 上板材料

存放 FPGA/模型配套工件、运行/部署入口和历史实测输出。

- `artifacts/kv260_B3136/overlay/`：B3136配套overlay；模型在 `data/models/kv260_B3136/`，运行目录已有相对链接。
- `artifacts/index/INDEX.csv`：各工程已有bit/bin/XSA/HWH/xclbin/ELF等索引。并非不同文件都能互换。
- `projects/`：对应的完整源码项目入口。
- `scripts/INDEX.csv`：部署/启动/停止脚本索引；包含会驱动真实设备的入口，不自动执行。
- `results/imported/`：已有KV260、LeRobot和RoArm输出；保留失败和早期记录，不统称成功。

任何加载overlay、JTAG编程、串口标定、驱动启动和运动操作均需人工确认硬件条件。本次归档不执行这些操作。

只传单个子项目时使用解引用相对链接的复制方式，避免丢失overlay/模型。整体传输保留链接；参考根README。