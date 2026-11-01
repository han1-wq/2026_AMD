---
name: kv260-delivery-audit
description: Audit source provenance, copied-file hashes, internal links, exclusions and controlled resealing of this delivery.
---

# 交付审计、来源追溯与封存

## 适用场景

文件补充、目录迁移、重新交付或测试后需要判断“哪些是原样文件、哪些是新增结果、是否破坏封存”。本技能不负责部署程序，也不把敏感扫描无告警解释为可公开发布。

## 输入与前置条件

- 交付根目录、上一次封存清单、明确允许的改动列表。
- 若执行原文件比较，来源目录须仍存在且可读；搬到其他机器不应伪造来源路径。
- 所有复制/索引/回归作业应结束；日志仍在写入时不封存。
- 先阅读[公共约定](/home/amd/kv260-ofdm-reproduction/skill/references/EXECUTION_CONTRACT.md)。

## 权威来源

- [验证器](/home/amd/kv260-ofdm-reproduction/build/verify_delivery.py)
- [来源清单](/home/amd/kv260-ofdm-reproduction/report/source_manifest.csv)
- [源库存](/home/amd/kv260-ofdm-reproduction/report/source_inventory.json)
- [排除记录](/home/amd/kv260-ofdm-reproduction/report/excluded_files.json)
- [公钥例外审查](/home/amd/kv260-ofdm-reproduction/report/public_key_review.json)
- [封存SHA](/home/amd/kv260-ofdm-reproduction/report/SHA256SUMS)

## 执行流程

1. 比较旧SHA清单并保存结果，再开始修改。清单验证不会发现未列入的新文件，也不单独覆盖软链接；两者须另查。
2. 对来源清单检查destination唯一、文件数/字节总数与库存一致；避免补文件重复追加。
3. 阅读验证器排除列表，区分原样文件、新说明、新日志与可变验证报告。
4. 仅在有报告写入权限时执行验证器；它不是纯只读命令，会更新验证JSON。
5. 比较原文件时只读来源。当前源码与复制时哈希一致只能支持“与打包基线一致”，不能证明未知的更早历史。
6. 公钥例外必须同时匹配精确路径和固定SHA；不放开所有`.key`。不能仅凭扩展名判公钥。
7. 核查图像、地图、标定、SDK/模型授权及日志隐私；自动扫描仅覆盖有限文件名和可识别模式。
8. 所有预期差异经过审查且验证通过后，再封存；封存后重新执行SHA校验，不再改入册文件。

修改前，只读校验（在包根目录执行以解析SHA清单中的相对路径）：

```bash
cd /home/amd/kv260-ofdm-reproduction
sha256sum --quiet -c /home/amd/kv260-ofdm-reproduction/report/SHA256SUMS
```

允许写验证报告后：

```bash
python3 -B /home/amd/kv260-ofdm-reproduction/build/verify_delivery.py --compare-originals
```

审查完成且用户任务包含更新交付时，才执行：

```bash
python3 -B /home/amd/kv260-ofdm-reproduction/build/verify_delivery.py --compare-originals --seal
cd /home/amd/kv260-ofdm-reproduction
sha256sum --quiet -c /home/amd/kv260-ofdm-reproduction/report/SHA256SUMS
```

## 验收与输出

- 验证进程退出码0，验证JSON的ok为true，problems为空；必须确认报告来自本次运行。
- 比较请求包含原文件时，compared_originals为true；否则说明未比较。
- 新增文件/变化文件逐项说明；封存覆盖清单和排除项明示。
- 输出审计记录，不把索引条目、链接、源文件数量相加当独立文件数。

## 常见故障

| 现象 | 下一步 |
|---|---|
| copied_content_hash_mismatch | 停止封存，比较源码差异；不能改来源哈希消警 |
| original_changed_since_copy | 核对源文件确实变化还是不可读；不要覆盖原文件 |
| broken_or_cyclic_link | 确认目标在包内；修正授权副本链接，不链接回原工程 |
| 敏感项告警 | 人工审核并排除真实秘密；不在报告中粘贴秘密内容 |
| SHA通过但缺新文档 | SHA清单不检查额外文件；检查全包文件清单和技能目录 |

## 禁止与停止条件

不并行运行两个封存任务；不在来源清单中记录新写文档为“原样复制”；不自动恢复未经核验的敏感文件。来源变化或未知文件修改未解释前，不使用seal掩盖问题。

## 调用示例

“审查此次skill扩充，保留原技能字节，确认来源清单未变；只允许文档和校验结果变化，最后重新封存。”

## 复用方法

替换包根、原文件清单、允许改动与排除项；复用“先比基线→解释差异→停止写入→封存→重校验”的顺序。原验证器含本包特定公钥/目录规则，不能未经审查作为任意工程通用检查器。提示词采用P3，输出逐文件差异表；来源目录不可读则明确未做原文件比较。

## 已验证效果

[前轮差异记录](/home/amd/kv260-ofdm-reproduction/report/skill-expansion-diff.json)逐项比较31,605个基线文件，仅列5个预期旧文件变化且无缺失；[验证记录](/home/amd/kv260-ofdm-reproduction/report/skill-expansion-validation.json)保存来源清单和导入技能哈希。全包状态以本轮最终verification.json为准，不把历史封存代表后续修改。

## 经验来源

[验证器源码](/home/amd/kv260-ofdm-reproduction/build/verify_delivery.py)显示报告有排除项，SHA清单不会发现额外文件；[前轮差异记录](/home/amd/kv260-ofdm-reproduction/report/skill-expansion-diff.json)因此另列新增文件。由这些可观察行为提炼“哈希通过≠完整交付”，不是虚构丢失文件事故。