# C42 交付准备

此目录仅保存封包脚本与上板文档草案。当前任务不运行 `seal_delivery.py`，不生成/复制 `download/video42_sdram100.bit`，不创建 ZIP，也不修改资料主记录。

## 封包门槛

根任务需先提供 `development/player_video42_sdram100/verification/offline_checks.json`。脚本要求汇总及其 `checks[]` 全部为 `PASS`，并强制以下顶层绑定值与当前项目文件一致：

- `source_scope_hash` = `final_stage_binding.json.scopeHash`
- `final_routed_netlist_sha256` = `verification/final_routed.v` 的 SHA-256
- `final_routed_db_sha256` = 绑定的 hold 阶段 `AC201_tf_hdmi_pr.db` SHA-256
- `final_bit_sha256` = 绑定到 hold route 的最终 C42 bit SHA-256

每个 `checks[]` 条目含 `name`、`status`、`scope`、`source_kind`、`evidence[]` 和 `inputs[]`。输入与证据逐项校验 `{path, sha256}`，按测试实际使用的 RTL/模型/日志绑定其范围。只有 `source_kind="final_routed_gate"` 的检查才需附 `final_routed_netlist_sha256` 和 `final_routed_db_sha256`；必须至少有一条 `name="routed_memory_data"` 的最终 routed memory-data PASS 与最终 routed hash 一致。公开 RTL unit 不声明自己消费了全网表。诊断失败、历史 C41 对照失败和负控记录在独立 `ablations[]`，状态使用 `EXPECTED_FAILURE`，不混入通过项。

source scope 或顶层 routed/bit hash 不一致、引用文件内容哈希变化、任一要求通过的检查失败时，脚本在任何交付写入之前终止。

脚本同时核验 final synthesis/hold/bitstream stage run 与 gate DB 绑定、hold 阶段所有已记录 artifact hash、最终 setup/hold WNS/TNS、固定 C41 回退 bit SHA，并确认目标下载文件、封包目录和 receipt 尚不存在。封包只挑选必要的 C42 修改源、聚合验证证据和文本 STA/面积报告，不复制 route DB 或完整 gate。ZIP 写入后会用 manifest 逐文件校验 SHA-256/字节数、CRC，并核验主位流与回退位流字节一致。

当前正确完成状态为 `OFFLINE_VERIFIED_BOARD_PENDING` 和 `PACKAGE_HASH_VERIFIED_BOARD_PENDING`；上板检查完成前不会写入板测 PASS。`phase9`/`readcycle` 只作为离线技术附件，不进入操作指南参数。

## 汇总 JSON 示例结构

根任务应生成真实数据，不要照抄占位哈希。下面仅说明交付脚本消费的字段：

```json
{
  "status": "PASS",
  "source_scope_hash": "<final_stage_binding.scopeHash>",
  "final_routed_netlist_sha256": "<sha256 of verification/final_routed.v>",
  "final_routed_db_sha256": "<sha256 of the hold-stage AC201_tf_hdmi_pr.db>",
  "final_bit_sha256": "<sha256 of the bitstream bound to hold route>",
  "checks": [
    {
      "name": "<test name>",
      "status": "PASS",
      "scope": "<precise test scope>",
      "source_kind": "rtl_unit",
      "inputs": [{"path": "<workspace relative RTL/model>", "sha256": "<file hash>"}],
      "evidence": [{"path": "<workspace relative log/trace>", "sha256": "<file hash>"}]
    }
  ],
  "ablations": [
    {"name": "<negative control>", "status": "EXPECTED_FAILURE", "scope": "<fault being detected>",
     "inputs": [{"path": "<workspace relative RTL>", "sha256": "<file hash>"}],
     "evidence": [{"path": "<workspace relative expected-failure log>", "sha256": "<file hash>"}]}
  ]
}
```

At least one `checks[]` entry must use `name="routed_memory_data"`, `source_kind="final_routed_gate"`, status `PASS`, and the top-level routed netlist/database hashes. Root-generated C41 diagnostics and intentional negative controls belong under `ablations[]`.
