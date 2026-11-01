# 仿真和验证

存放仿真/测试脚本索引、独立验证入口及其输出。

- `run_software_checks.py`：本次新增的无硬件回归入口。
- `ofdm/`：原OFDM testbench、回归脚本及历史仿真目录。
- `projects/`：HLS、导航、SO101、RoArm等项目级测试入口，保留原相对导入布局。
- `scripts/INDEX.csv`：707个分类入口（包含历史/生成testbench；不是707项本次测试）。
- `results/packaging-validation/`：本次实际执行日志及逐命令退出码。
- `results/imported/INDEX.csv`：历史仿真/验证结果索引；未重新运行，不算本次通过。

为兼容OFDM脚本的父目录推导，本目录的 `rtl`、`firmware`、`host`、`board` 等为包内源码链接，`sim`链接回 `ofdm/`，没有指向原工程。

执行方法见根README。不要从分类脚本索引直接执行带相对路径的脚本；应从项目入口调用或使用已验证的包装脚本。软件测试通过不等于射频、FPGA或机器人实机验收。