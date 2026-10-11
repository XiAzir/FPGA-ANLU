# dynamic_text_fit 打包前只读审查

审查对象：`scripts/save_and_package.py`、`build/preparation.json`、`build/manual` 当前产物、`sim/mapper_width_experiment` README/测试/日志。未运行 TD、packager，也未修改 RTL、数据库或冻结候选。

## 可确认的绑定与保护

- 当前 user_source 实际 75 项；`preparation.json` 的 source_manifest 中 74项哈希与 failed 原工程一致，唯一差异 `hdl_source/fat32_file_sector.v`。`build/prepare_mapper.py` 明确从窄位宽实验文件生成该候选源，保留32-bit anchor；实验模块名归一后内容与候选源一致。packager 再次检查候选内容等于 `fat32_file_sector_narrow.v` 的模块名归一版本，并将 original 参照副本与 failed 原工程 mapper 比较；测试与候选实现绑定链条成立。
- 等价实验日志记录 `PASS: cycle-equivalent ... cycles=6381198 sectors=12295`；最大合法4096簇路径到sector4095，power boundary 4096；README明确保留4096限制且测试没有强行触发内部边界。`mapper_width_experiment`中的路径文字指向 `player_dynamic_text_compact`，说明其原始生成地；这些文件已经随 fit 目录复制。packager 验证的是可复核源码及日志标记，不会重新运行测试。
- `save_and_package.py` 先断言新 checkpoint、ZIP、short bit均不存在；只读校验 osd_phy_fix 与 dynamic_text 原冻结manifest内文件；仅复制到 fit 新 checkpoint，再写新包。它校验回退 bit hash。冻结候选不被覆盖，防护有效。
- packager 假设日志为 `build/manual/{synthesis,physical,hold,bitstream}_console.log`，marker分别为 `SYNTHESIS_COMPLETE_WITH_GATE_DATABASE`、`PLACE_ROUTE_COMPLETE_WITH_REPORTS`、`POST_ROUTE_HOLD_FIX_COMPLETE`、`BITSTREAM_GENERATED`。名称与 `build_candidate.ps1` 生成名一致，marker与各 stage Tcl一致；当前仅观察到 synthesis_console.log，TD综合已结束，其余阶段仍待完成，故现在运行packager会按预期失败。
- `hardware_result: NOT_TESTED`、`root_cause: NOT_CONFIRMED`、board_test_status/bitstream_status仍待测，包内README也声明实板待测；该边界标记正确。

## 打包前必要修正

1. `preparation.json` 自身矛盾：`user_source_hash_match_count=74`但`user_source_differences=[]`，同时 `source_manifest` 与 `intentional_user_source_differences`清楚记录了一个mapper差异。打包脚本将该旧文件原样复制入checkpoint，建议将差异数组更新为唯一相对路径，而不是留空。
2. 同一文件写 `mapperwidth_experiment=PENDING; do not modify until root approves model result`，但其后 `mapper_width_status=MODELS_PASS...` 且实验已有全通过日志；PENDING文案已陈旧，应在归档元数据中更正/移除。
3. `build_status=NOT_BUILT`已陈旧：当前 `build/manual/synthesis_console.log`包含成功 marker，且 gate 数据库已生成。应记为 synthesis complete / physical pending（或等全流程结束后写最终状态），避免冻结包声称未构建。

除这三项元数据不一致外，当前审查未发现packager使用错误日志名、冻结覆盖路径或仿真候选绑定缺口。尚不能预审最终bit、时序资源和硬件结果；待物理/hold/bitstream阶段完成后packager才可验证这些内容。
