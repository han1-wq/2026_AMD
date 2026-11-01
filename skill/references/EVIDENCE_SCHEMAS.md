# 离线校验合同与使用方法

工具：[validate_evidence.py](/home/amd/kv260-ofdm-reproduction/skill/tools/validate_evidence.py)。Python 3.8+标准库；不导入PYNQ/NumPy，不打开设备，不联网、不运行输入中的命令。它读取用户指定的文件，建议只处理可信、大小有界的项目输入。退出0为该门禁通过，退出1为数据/门禁失败，参数用法错误由argparse返回2。

## 1. 黄金参考比对

reference与candidate分别提供JSON：

```json
{"shape": [2, 2], "dtype": "int8", "data": [0, 1, -2, 127]}
```

以上是**格式夹具，不是本项目测量数据**。data必须按双方已确认的相同顺序扁平化。支持int/uint 8/16/32/64及float32/64标识；整数检查范围，浮点标识不模拟IEEE量化/舍入。拒绝NaN/Inf、布尔值、空形状、长度/dtype/shape不符。64位整数差值使用十进制比较，不转成float吞掉差异。

```bash
: "${SKILL_ROOT:?请设置skill目录绝对路径}"
: "${REFERENCE_JSON:?请设置独立黄金参考JSON绝对路径}"
: "${CANDIDATE_JSON:?请设置待测结果JSON绝对路径}"
python3 -B "$SKILL_ROOT/tools/validate_evidence.py" golden "$REFERENCE_JSON" "$CANDIDATE_JSON"
```

可显式传`--atol`、`--rtol`；默认均为0。输出错点数量、前20个索引、最大绝对误差。失效：布局/量化含义不同、参考不独立或需要检测任务mAP时，纯数值门禁不能证明算法正确。

## 2. 资源与时序门禁

提供JSON字段：`stage`必须为`implemented`；`source_report`含绝对`path`及可信`sha256`；`wns_ns`、`whs_ns`为有限数；`unconstrained_paths`、`drc_errors`为非负整数；`resources`为非空映射，每种资源含非负`used`和正数`limit`。单位需一致，预算由队伍在实验前确定。

```text
stage: implemented
source_report: {path: 报告绝对路径, sha256: 来源可信的64位小写SHA}
wns_ns / whs_ns: 从同一次实现报告人工核对的值
unconstrained_paths / drc_errors: 实际计数，缺失不是0
resources: {LUT: {used: 实际用量, limit: 预算}, ...}
```

上述是字段解释，**不是可直接运行的伪测量JSON**。按字段自行生成真实JSON，然后：

```bash
: "${SKILL_ROOT:?请设置skill目录绝对路径}"
: "${QOR_JSON:?请设置实际转录合同JSON绝对路径}"
python3 -B "$SKILL_ROOT/tools/validate_evidence.py" qor "$QOR_JSON"
```

负WNS/WHS、非零未约束路径/DRC或资源超预算返回失败。此工具不解析厂商报告、不检查漏转录的资源、不审查CDC或约束质量；人工必须核对报告原文和覆盖范围。哈希只能绑定给定报告，不证明转录可信或报告由当前源码生成。

## 3. 经典PYNQ工件预检

提供JSON：`bit`和`hwh`各含绝对`path`及可信`sha256`；`expected_instances`为非空、无重复的HWH `MODULE INSTANCE`名称列表（不是自动推断层次化ip_dict键）。要求非空同目录同名主干`.bit/.hwh`，拒绝哈希变动、缺实例、XML解析错误、DTD/entity。

```bash
: "${SKILL_ROOT:?请设置skill目录绝对路径}"
: "${PYNQ_CONTRACT:?请设置PYNQ工件合同JSON绝对路径}"
python3 -B "$SKILL_ROOT/tools/validate_evidence.py" pynq "$PYNQ_CONTRACT"
```

失效：HWH须为UTF-8 XML；不支持xclbin-only、部分重配置或任意新版元数据布局；不验证bitstream内部器件、bit/HWH语义配套、寄存器ABI、驱动/板卡兼容、DMA/缓存或实际数值。不能把通过写成“PYNQ上板通过”。

## 已验证效果与经验来源

[测试代码](/home/amd/kv260-ofdm-reproduction/skill/tools/test_validate_evidence.py)明确把假bit标成NOT A BITSTREAM，使用临时合成XML和报告，正/负路径可在陌生队伍机器直接重放。实际测试日志见[验证记录](/home/amd/kv260-ofdm-reproduction/skill/evidence/reuse-validation.json)。提炼自来源哈希/阶段混淆/数值合同观察；不捏造实机错误历史。