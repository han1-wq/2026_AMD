# 可复用协作技能包（对照3.3.5.2）

目标是让陌生队伍复用“输入合同→提示词协作→最小实验→校验→证据交接”，而非仅复现作者机器。提供**提示词工作流、案例/报告模板、离线校验脚本、踩坑清单**。新队伍从通用两项开始，原12专题作为有源码和历史记录支撑的案例；原始工程和导入材料不改。

**证据边界**：脚本有可重放正/负测试；提示词为经验提炼模板，尚无跨模型/跨队伍稳定成功率验证；PYNQ仅离线预检与源码/官方资料审查，未开展通用板卡实测。不能把内容齐全写成已满足所有评分或已取得加分。用户提供的PYNQ条款在句中截断，剩余条件未收到。

## 陌生队伍快速开始

1. 只复制本skill目录到自己选定的项目，或保留整个交付包。使用Python 3.8+标准库，不需要原机器、NumPy、EDA工具或PYNQ才能测试新增工具。
2. 在shell设置`SKILL_ROOT`为**本机skill目录绝对路径**；先运行下述只读检查/临时目录单测。
3. 用[通用工作流](/home/amd/kv260-ofdm-reproduction/skill/reusable-workflows/SKILL.md)和[P1/P2/P3提示词](/home/amd/kv260-ofdm-reproduction/skill/templates/REUSABLE_PROMPTS.md)，替换路径、规格、版本、权限与验收指标；未知项写未知。
4. PYNQ题目再读[通用PYNQ技能](/home/amd/kv260-ofdm-reproduction/skill/pynq-portable/SKILL.md)，用自己的工件合同预检。不要执行旧专题中绑定本机的命令。

```bash
: "${SKILL_ROOT:?请设置为本机skill目录的绝对路径}"
python3 -B "$SKILL_ROOT/tools/check_skills.py" --root "$SKILL_ROOT/.." --standalone
python3 -B -m unittest discover -s "$SKILL_ROOT/tools" -p 'test_*.py' -v
python3 -B "$SKILL_ROOT/tools/validate_evidence.py" golden "$SKILL_ROOT/examples/reference.json" "$SKILL_ROOT/examples/candidate-pass.json"
```

负例：将最后一个参数换成`candidate-fail.json`，**预期退出1且mismatches=1**，不是运行环境坏了。这三个文件明确是合成演示数据，不是业务测量。

`--standalone`仅检查skill内部：外部源码/日志链接会列入`external_references_not_checked`，不能当全文来源已核验。完整包迁移后用`--relocate`代替它，外部引用也必须存在。校验器只映射路径，不修改文件、不执行文档命令。文档/catalog绝对路径保留为来源定位；迁移阅读时用catalog的package_root前缀映射到自己的包根，不能把旧绝对路径当本机文件。

若希望迁移后文档内链接可直接打开，使用[副本导出工具](/home/amd/kv260-ofdm-reproduction/skill/tools/export_skills.py)。`DESTINATION_ROOT`必须是包外、父目录已存在但自身不存在的绝对目录；工具创建其skill子目录，仅改新副本的自编Markdown和catalog路径，原包/导入技能字节不动。JSON/日志保留历史记录路径，不伪装为新机器实测。未随skill复制的工程源码/报告仍明确列为未检查。

```bash
: "${SKILL_ROOT:?请设置当前skill目录绝对路径}"
: "${DESTINATION_ROOT:?请设置全新目标根目录绝对路径}"
python3 -B "$SKILL_ROOT/tools/export_skills.py" --source-skill "$SKILL_ROOT" --destination-root "$DESTINATION_ROOT"
```

导出后将SKILL_ROOT改为新根下skill的绝对路径，重复上面的测试命令。失效条件：已有目标、源skill校验失败、源中有软链接/特殊文件均拒绝；中断后的部分输出需检查，不可当完整交付。导出效果由`test_export_skills.py`实际验证，不代表外部项目资料已迁移。

## 评分项对应的通用入口

| 项目 | 适用范围与用法 | 失效条件 | 已验证效果/来源 |
|---|---|---|---|
| [通用协作](/home/amd/kv260-ofdm-reproduction/skill/reusable-workflows/SKILL.md) | P1划分、P2瓶颈、P3失败回归，填参数后分轮使用 | 无源码/规格/独立参考，只能输出缺口 | 工具有正负单测；提示词无稳定性统计，来源是本包证据分层观察 |
| [通用PYNQ](/home/amd/kv260-ofdm-reproduction/skill/pynq-portable/SKILL.md) | bit/HWH离线预检、IP/缓冲所有权及板测计划 | 不支持xclbin-only/部分重配置；缺ABI/独占停止 | 合成工件负例已跑；依据官方资料及B3136源码，未上板 |

## 12个项目案例：如何迁移及何时失效

所有专题都明确写有“复用方法、已验证效果、经验来源”并引用实际来源。下面历史计数来自原打包日志，不重计成本轮执行；静态观察不冒充亲历失败。

| 案例 | 使用方法/适用范围 | 失效条件 | 已验证效果与经验来源 |
|---|---|---|---|
| delivery-audit | 换清单/允许变化，先比较再封存 | 未解释差异、仍在写入、来源不可读 | 前轮差异/哈希记录；SHA不覆盖新增文件的观察 |
| hls-preprocess | 换尺寸/量化/ABI，分层黄金验证 | 缺寄存器/参考或版本不配套 | 历史配置4项+链接3项；配置测试≠RTL覆盖 |
| hls-postprocess | 换容量/状态，N与N+1测试及整帧回退 | 模型ABI未知或缺回退 | 源码静态审查；不宣称完整C/RTL通过 |
| vivado-platform | P2+AXI/时钟/复位表 | 缺约束/IP/报告配套 | Tcl静态观察；未重建平台/闭合时序 |
| ofdm-link-dma | 换协议，模拟分片/CRC/完整回传 | 协议代际不符或设备授权未知 | 历史50通过4跳过+5组DMA；ACK不等于回传 |
| ofdm-firmware | 换XSA/处理器，独立构建目录 | 处理器不符、缺工具/工件 | 历史XSA检查；未重建ELF或烧录 |
| kv260-vision | 帧槽/配置/缓冲所有权图 | 工件不配、任务未排空 | 历史2项配置及7项工件SHA；不代表板测 |
| x3plus-navigation | 换ROS/架构/设备，查初始化副作用 | 身份/急停/联锁未知 | 历史96项+包检查；初始化写舵机的源码观察 |
| lerobot-act | 分开环境、小模型、正式训练和闭环 | 数据/单位/模型来源不明 | 本轮静态审查；随机小模型不能证明策略 |
| so101-teleop | 换单位/认证/标定，测重放/断连 | HOLD失败或真实停机条件未知 | 历史11项模拟协议；HOLD不是急停 |
| roarm-servo | 建议→控制门禁→下发→反馈→完成 | 过期图像/反馈、dispatch未知 | 源码静态审查；SDK ACK不是运动完成 |
| host-integration | 按钮→服务→帧→回传映射 | 缺模块/旧帧/停止未确认 | 实际归档缺口与源码观察；无全链路实测 |

## 项目案例使用约定

1. 先读[总调度技能](/home/amd/kv260-ofdm-reproduction/skill/SKILL.md)及[公共执行约定](/home/amd/kv260-ofdm-reproduction/skill/references/EXECUTION_CONTRACT.md)。
2. 按下表选择一个专题，读取其列出的权威源码；版本冲突时以匹配工件的源码和新日志为准。
3. 告知代理任务、允许的操作等级、输入路径、输出目录及验收目标。仅提供技能不代表授权构建、联网、上板或运动。
4. 生成[实验记录](/home/amd/kv260-ofdm-reproduction/skill/templates/RUN_RECORD.md)和必要的[集成交接表](/home/amd/kv260-ofdm-reproduction/skill/templates/INTEGRATION_HANDOFF.md)。失败/缺依赖使用[缺口记录](/home/amd/kv260-ofdm-reproduction/skill/templates/GAP_RECORD.md)。
5. 修改后运行技能结构校验和相应离线测试；审查差异后才更新交付包封存。

## 项目案例入口

| 专题入口 | 解决的问题 | 默认边界 |
|---|---|---|
| [交付审计](/home/amd/kv260-ofdm-reproduction/skill/delivery-audit/SKILL.md) | 来源、哈希、软链接、凭据排除、重新封存 | 只读检查，报告写入需明确 |
| [HLS前处理](/home/amd/kv260-ofdm-reproduction/skill/hls-preprocess/SKILL.md) | 颜色、量化、letterbox、ABI、C/RTL分层验证 | 离线软件；构建单独授权 |
| [HLS后处理](/home/amd/kv260-ofdm-reproduction/skill/hls-postprocess/SKILL.md) | 多尺度解码、定点NMS、候选溢出与CPU回退 | 不接触板端执行器 |
| [Vivado平台集成](/home/amd/kv260-ofdm-reproduction/skill/vivado-platform/SKILL.md) | BD、AXI、时钟复位、资源与时序证据链 | 不自动综合/实现/烧录 |
| [OFDM主机与DMA](/home/amd/kv260-ofdm-reproduction/skill/ofdm-link-dma/SKILL.md) | 新旧协议辨识、DMA回归、数据一致性 | 模拟UART/TCP，不打开设备 |
| [OFDM固件](/home/amd/kv260-ofdm-reproduction/skill/ofdm-firmware/SKILL.md) | XSA核验、XSCT参数、ELF与硬件配套 | 不执行JTAG |
| [KV260视觉运行时](/home/amd/kv260-ofdm-reproduction/skill/kv260-vision/SKILL.md) | B3136工件、帧槽、缓存所有权、停止排空 | 离线检查；板测另设门禁 |
| [X3plus导航](/home/amd/kv260-ofdm-reproduction/skill/x3plus-navigation/SKILL.md) | ARM64上下文、导航测试、联锁、ROS边界 | 不启动底盘/雷达/机械臂 |
| [LeRobot与ACT](/home/amd/kv260-ofdm-reproduction/skill/lerobot-act/SKILL.md) | 固定版本、CPU环境、小模型证据、数据/训练边界 | 不自动训练或下载模型 |
| [SO101遥操作](/home/amd/kv260-ofdm-reproduction/skill/so101-teleop/SKILL.md) | 会话认证、过期/重放、断连保持、标定身份 | 默认只跑模拟协议 |
| [RoArm视觉伺服](/home/amd/kv260-ofdm-reproduction/skill/roarm-servo/SKILL.md) | 模型建议、动作门禁、编码器/图像证据分离 | 只观察/审计，不开动作接口 |
| [上位机跨模块集成](/home/amd/kv260-ofdm-reproduction/skill/host-integration/SKILL.md) | GUI状态、视觉采集、OFDM回传、依赖与服务生命周期 | 不运行live验证脚本 |

另保留[原visual-servo技能](/home/amd/kv260-ofdm-reproduction/skill/imported/roarm_console/visual-servo/SKILL.md)，其字节保持不变。它不是通用的场景事实或现场授权；引用前必须阅读RoArm专题的约束。

## 配套资料

- [执行约定](/home/amd/kv260-ofdm-reproduction/skill/references/EXECUTION_CONTRACT.md)：操作分级、命令记录、证据等级、模型使用边界。
- [验证矩阵](/home/amd/kv260-ofdm-reproduction/skill/references/VALIDATION_MATRIX.md)：当前白名单、PASS标志及未覆盖范围。
- [故障定位](/home/amd/kv260-ofdm-reproduction/skill/references/TROUBLESHOOTING.md)：从哈希、环境、协议到硬件资源的排查顺序。
- [机器可读目录](/home/amd/kv260-ofdm-reproduction/skill/catalog.json)：技能名称、文件和风险分类，不代表已安装。
- [结构校验器](/home/amd/kv260-ofdm-reproduction/skill/tools/check_skills.py)：验证目录、必需章节、文档引用和导入技能哈希，不执行文档中的命令。

| 可复用材料 | 适用范围/使用方法 | 失效条件及效果边界 |
|---|---|---|
| [P1/P2/P3](/home/amd/kv260-ofdm-reproduction/skill/templates/REUSABLE_PROMPTS.md) | 复制整段、填输入槽、分轮人工确认 | 未填规格只列缺口；经验来源在各模板，未做模型稳定性基准 |
| [RUN_RECORD](/home/amd/kv260-ofdm-reproduction/skill/templates/RUN_RECORD.md) | 每实验填写版本/输入/命令/结果 | 缺实际日志不能填通过；由旧验证记录提炼，字段存在已检查 |
| [INTEGRATION_HANDOFF](/home/amd/kv260-ofdm-reproduction/skill/templates/INTEGRATION_HANDOFF.md) | 每接口填写单位/所有权/完成/异常 | ABI或生命周期未知停止；由HLS/运行时源码提炼，非实机验证 |
| [GAP_RECORD](/home/amd/kv260-ofdm-reproduction/skill/templates/GAP_RECORD.md) | 缺依赖/数据/权限时记录复现与下一步 | 不用空工件补缺；来自KNOWN_GAPS，模板本身不修复问题 |
| [踩坑清单](/home/amd/kv260-ofdm-reproduction/skill/references/TROUBLESHOOTING.md) | 按症状→触发→定位→停止排查，来源见专题经验章节 | 仅排查方法，不是所有故障都亲历；不能绕过保护 |
| [数值/资源/工件合同](/home/amd/kv260-ofdm-reproduction/skill/references/EVIDENCE_SCHEMAS.md) | 用自己的JSON调用validate_evidence | 不判参考独立性/转录准确性/硬件兼容；正负夹具测试已跑 |

本轮工具、迁移和演示的实际命令/退出码/日志：[reuse-validation.json](/home/amd/kv260-ofdm-reproduction/skill/evidence/reuse-validation.json)。它不替代历史业务日志或实机报告。

```bash
python3 -B /home/amd/kv260-ofdm-reproduction/skill/tools/check_skills.py
python3 -B -m unittest discover -s /home/amd/kv260-ofdm-reproduction/skill/tools -p 'test_*.py' -v
```

末段绝对命令仅用于原完整包；迁移后使用本页顶部变量化命令。不要批量改写原始来源文件来隐藏迁移缺口。技能新增不等于新增硬件能力；用户未提供的PYNQ加分细则仍待核对。