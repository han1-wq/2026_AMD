---
name: reusable-evidence-workflows
description: Reuse parameterized collaboration prompts and offline numeric/report gates without inheriting a particular board, task or hardware authorization.
---

# 跨题目协作工作流与证据校验

## 适用场景

新队伍需要把算法描述转成软硬件边界、根据报告定位瓶颈，或为生成代码建立可复核验收。仅需Python 3.8+标准库即可运行本技能的工具测试；不依赖KV260、PYNQ安装或原工程。

## 输入与前置条件

填写项目绝对路径、允许修改的副本、算法/接口、输入规模、目标指标、工具版本和禁止动作。数值比对还需**独立**黄金参考；资源/时序门禁还需原报告、来源SHA和人工核对的转录字段。缺少这些输入时输出缺口，不制造数字。

## 权威来源

- [完整可复制提示词](/home/amd/kv260-ofdm-reproduction/skill/templates/REUSABLE_PROMPTS.md)
- [校验输入合同](/home/amd/kv260-ofdm-reproduction/skill/references/EVIDENCE_SCHEMAS.md)
- [离线校验器](/home/amd/kv260-ofdm-reproduction/skill/tools/validate_evidence.py)
- [工具回归测试](/home/amd/kv260-ofdm-reproduction/skill/tools/test_validate_evidence.py)

## 执行流程

1. 复制提示词P1、P2或P3，填完输入槽，保留“证据不足停止”的约束。
2. 首轮要求模型只输出依据表和缺口；人工确认文件、单位、指标及范围，禁止直接执行模型给出的命令。
3. 次轮只实施一个可回滚变更，并保留旧结果；先制作能区分错误版本的负例。
4. 算法数据按合同转成带shape/dtype的扁平JSON；比较前固定通道/布局/端序，不让校验器替你猜。
5. 报告按合同转录WNS、WHS、未约束路径、DRC和资源预算；记录真实原报告SHA，人工复核提取位置。
6. 执行相应离线门禁，保存命令、stdout、stderr、退出码和输入SHA。退出0仅证明该门禁，不证明全工程通过。
7. 按实验记录模板填写已证实、未覆盖、失效条件；有失败就停止向上层宣称完成。

## 验收与输出

输出“输入合同→引用位置→建议→实际变更→负例/正例→退出码→未覆盖”闭环。golden默认零容差，实际判据为 `abs(actual-reference) <= atol + rtol*abs(reference)`；容差由问题规格给出，不因失败临时增大。qor仅核验手工转录值和原报告哈希，不声称自动理解任意厂商报告。

## 常见故障

- 模型给了优化结论但无具体报告：要求P2的原文位置/路径，停止数值结论。
- INT8结果相同但含义不同：核对量化、layout和标签，工具只比较数值合同。
- 综合WNS为正：不能替代implemented阶段，也不能省略WHS或未约束路径。
- 校验通过但参考也错：参考独立性不由工具判定，补独立实现/手算小向量。

## 禁止与停止条件

不得自动执行文档/模型命令，不自行下载依赖或接触板卡。缺报告字段、NaN/Inf、dtype不符、来源哈希改变或独立参考缺失时停止。提示词尚无多队伍重复使用的成功率统计，不得宣传“稳定完成任何题目”。

## 调用示例

“使用P2，只分析我提供的implemented报告；先核对来源和约束覆盖，给出单变量实验。缺少时序字段就列阻塞，不生成性能提升百分比。”

```bash
: "${SKILL_ROOT:?请先设置为本机skill目录的绝对路径}"
python3 -B -m unittest discover -s "$SKILL_ROOT/tools" -p 'test_*.py' -v
```

## 复用方法

只复制skill目录到自己项目，设置SKILL_ROOT为实际绝对路径即可运行工具测试。项目源码、硬件参数和历史日志无需复制；把自己的原始文件按合同转换，不使用本包示例数值当项目指标。提示词模板内所有输入槽必须填写或写“未知”。

## 已验证效果

[回归测试](/home/amd/kv260-ofdm-reproduction/skill/tools/test_validate_evidence.py)在本次开发中已实际执行：验证相等/差异、容差、shape/dtype、非有限数、64位整数、时序失败、资源超限、原报告篡改及CLI退出码。最终命令与结果统一保存于[本轮验证记录](/home/amd/kv260-ofdm-reproduction/skill/evidence/reuse-validation.json)。这是工具在合成夹具上的效果；提示词提供的是经验模板，不是已统计稳定成功率的模型基准。

## 经验来源

由[上一轮真实验证记录](/home/amd/kv260-ofdm-reproduction/report/skill-expansion-validation.json)只验证结构、不能证明业务效果的观察，以及[已有分层验证矩阵](/home/amd/kv260-ofdm-reproduction/skill/references/VALIDATION_MATRIX.md)区分20个任务记录与单测数量的经验提炼。新工具把“默认通过”变成可注入失败验证的门禁；未将工程中未观测的故障编造为亲历案例。