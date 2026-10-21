# A04 最终绑定预审（只读）

预审对象：`development/player_spectrum_arch17` 的 A04 源、`development/arch17_work` 的 system replay、preservation、unit evidence、resource freeze、final binding 与 delivery info 脚本。预审时 TD synthesis 正运行；未运行 TD，也未修改 main、helper 或其父目录。

## 已核实的输入绑定

- A04 `fat32_dual_file_sector.v`、`arch17_work/shared_mapper/candidate.v` 与 `mapper_tests/candidate_as_tested.v` SHA256 均为 `084B7DC884B1B33E3EBC2804283BC820B0E5A38EB248E7DC14A6303D70F67BFB`。`selected_changes.json` 的 core 与 top 源哈希也匹配 A04 当前文件。
- A04 top 只实例化 `fat32_dual_file_sector`，实例名 `u_file_mapper`，参数为 `REQUEST_STABLE=1`、`WAV_STATIC_FILE=1`。A04 `.al` 显式包含 `fat32_dual_file_sector.v`，没有旧 `fat32_file_sector.v` 或 `sd_sector_arbiter.v` 源条目。
- `run_system_candidate.py` 将归档中的旧 mapper 输入位置替换为 candidate dual-core，并在 `shared_mapper` 模式排除 `sd_sector_arbiter.v`。现有 `system_fast_20261021_124327` 的 `sources.f`/`plain.f` 只含映射后的 `candidate_fat32_file_sector.v`；编译日志报告模块 `fat32_dual_file_sector`，未编译旧 arbiter。该 replay 的 source receipt 中 core 是 A04 当前 SHA。
- `verify_preservation.py` 固定检查 C11316 源快照、冻结 manifest SHA 与 bit 保护哈希；selected changes 明确删除两个旧源码并核对其父版本 SHA。当前 parent/build ID 对照为 C11316 → C11317，没有发现 parent SHA 或 core 参数引用错配。
- `verify_unit_evidence.py` 检查共享 core、as-tested 副本、A04 源与资源 receipt 的 SHA 相等，并收集 mapper 测试日志。`freeze_resource_candidate.py` 复制完整 `src/scripts/sim`、build scope、单位证据引用文件、选定 reports 和 bitstream；本次核查未发现新 core 的 HDL/ROM 依赖漏入 source tree。
- `build_manual_syn.tcl` 目标为 EG4S20BG256；实际参数日志中可见 `map_mode=area_prior`、`resource_sharing=auto`、`min_ripple_len=18`、`mapper_lut_delay=1600`、`add_map_lut_struct=high`。脚本有写出 actual parameter 日志，冻结列表也包含该日志。

## 当前必须等待的构建阶段

当前 synthesis pointer 为 run `6a499e72-76a7-4cb8-b29e-06453b4eed42`，状态 `running`，scopeHash `92f9788dae6c16dcc918d37bb7818ee475439d98eaa310e64c6f5f1dec233944`。latest physical 和 bitstream 仍指向旧 synthesis `aba70119-fd9b-434c-9993-bc0034907adf`。`build_source_scope.json` 还显示旧 core SHA `B9A9…8993`，文件时间早于 A04 core 变为 `084B…67BFB`；这是 synthesis wrapper 的预期过渡状态：成功完成后它才写入本次 scope。新 synthesis 完成后，必须以该 scope 运行 physical 与 bitstream，再做 final binding。`build_candidate.ps1` 对 physical/bitstream 有 scope 与 gate DB 一致性门禁；此时的旧 stage 输出不构成 A04 新 core 的完成证据。

## 需要补强的证据校验

1. `freeze_resource_candidate.py` 逐个检查 latest stage `status == success`，但未检查三阶段 run 链。若新 synthesis 成功而 physical/bitstream 仍保留旧成功指针，freeze 可以先复制混合代际结果。`verify_final_binding.py` 会拒绝旧 physical（核对 `physical.synthesisRunId`），但没有核对 bitstream record 的 `synthesisRunId`、`routeStage` 与当前 physical/hold record、`bitHash`。建议在 freeze 创建 target 前要求 synthesis→physical→bitstream 的 run IDs、scopeHash、scriptHash 与 gateDbHash 成链，并在 final verifier 核对 bitstream `bitHash` 等于手工目录 bitstream SHA。
2. `run_system_candidate.py` 的 `source_receipt.json` 对每个 override 记录原始 A04 source SHA；普通复制的 `candidate_*.v` 未记录 `copy_sha256`，仅 simulation transform 分支记录副本哈希。`verify_final_binding.py` 验证原源哈希与 testbench SHA，但没有逐项核对实际编译副本及 `sources.f`/`compile.log`。当前 replay 输入已现场确认正确；为使将来的报告可复验，建议所有 override 写入后记录副本 SHA，并在 final binding 验证该副本 SHA、文件出现在编译输入清单、dual-core 模块已编译且 retired arbiter 未编译。
3. `verify_unit_evidence.py` 当前以通用 `PASS: reference contract suite complete` 作为共享 mapper regression marker。最终 mapper log 已含 BMP watchdog 与 WAV dispatch 同拍的专用 PASS 行；建议增加对此行的显式 marker，以锁定本次补入的相邻客户 timeout race 回归。
4. `verify_final_binding.py` 核验 source scope、stage IDs 的部分关系、timing 和 manifest SHA，但没有从 `strategy_actual.rtl.log`/`strategy_actual.gate.log` 断言上述目标器件和关键 map 参数。当前 actual parameter reports 与 Tcl 设置相符；建议把 device/package 和实际参数值纳入最终断言，避免以后策略脚本或运行参数漂移仍产生 PASS。

## 预审结论

A04 的 core/top/project source override 与旧 mapper/arbiter 退役绑定正确；归档依赖无遗漏证据。当前构建尚未完成，旧 physical/bitstream 指针不可作为最终证据。冻结和最终校验应补上 bitstream run-chain 及 system replay 实际编译副本哈希核验，再生成交付信息。现有 system replay `system_fast_20261021_124327` 的 source override 已匹配 A04 084 core；它提供的是 RTL 仿真证据，不替代本次待完成的综合/布局布线/bitstream stage evidence。
