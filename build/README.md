# 构建材料

存放原构建脚本、必要工程快照、综合/实现报告和交付包维护工具。

| 入口 | 用途 |
|---|---|
| `build_hls.sh` | 包内相对路径包装，调用原HLS脚本，支持csim/synth/cosim/export/all |
| `build_ofdm_firmware.sh` | 调用原XSCT固件脚本，需要未存在的新输出目录 |
| `scripts/INDEX.csv` | 原Tcl、Makefile、Dockerfile和构建脚本分类索引 |
| `reports/INDEX.csv` | 综合、实现、HLS报告索引，全部为原始历史报告 |
| `projects/` | OFDM/Vitis构建工程材料 |
| `hls/` | HLS构建结果和时序优化实验 |
| `environment/lerobot/` | 原软件依赖锁定记录、测试/环境证据 |
| `package_sources.py` | 从本机明确列出的源目录复制；有完成清单时拒绝重打包 |
| `index_delivery.py` | 重建分类索引，不执行原项目程序 |
| `verify_delivery.py` | 检查复制哈希、链接、常见敏感项，可只读比较原文件 |

原脚本可能使用绝对路径；执行前查看根目录说明和已知缺口。不把缺失的构建流程描述为已经补齐。新包装脚本已做语法/参数检查，本次没有执行完整FPGA综合、实现或容器构建。