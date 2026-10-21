# Mapper RTL 独立复核

复核对象：`resource80_work/mapper_proposal.py`、`resource80_work/mapper/README.md`、C11313 基线 `resource80_work/mapper/reference.v` 与导入后的 `player_spectrum_resource_80/src/user_source/hdl_source/fat32_file_sector.v`。复核未改动主候选、mapper 脚本或 TD 工程。

当前候选与 `resource80_work/mapper/combined.v` 在替换模块名并规范行尾后逐字一致。基线归档副本 `mapper/reference.v` 与本目录差分 bench 使用的 reference RTL 一致（只改模块名）。当前候选 SHA256：`A889BC80AAF9065D3D6FCDE3CC05D22E5C4787D3E8C221EFBC00D8E871745D37`；基线归档 SHA256：`0324BD77F3F34CE45CF69A0FB55ACCE396E52A4A2DBB9332A1F2F92C68A02228`。

## 范围归纳

- `S_CHECK` 只接受 `rq_sector < sectors_needed`，并要求 `sectors_needed <= 4096 << sectors_per_cluster_shift`；shift 范围受限于 0..7。故 `target_index = rq_sector >> shift` 最大为 4095。`walk_index` 从 0 或有效缓存索引开始，每次 FAT 转移只增 1，只有 `walk_index != target_index` 时读 FAT；抵达目标便进入 data 读。data 成功时缓存同时写入 `cache_index=target_index` 与 `cache_walk_count=walk_count`，此时索引/计数相等。reset 为二者清零，cache 恢复和重启分别成对赋值。因此 `walk_count == walk_index`、`cache_walk_count == cache_index` 恒成立，且均不超过 4095；`S_SELECT` 中 `walk_count >= 4096` 不可达。
- `rq_start` 只在 `S_CHECK` 通过 `rq_start >= 2`、`rq_start <= cluster_count+1` 与 `cluster_count <= 0x0ffffff5` 后使用；上界是 `0x0ffffff6`。之后的 FAT 值先用 `0x0fffffff` 掩码，并通过 reserved/EOC、下界及 `cluster_count+1` 检查后才进入 `current_cluster`。该值因此始终在 28 位范围内。`cache_cluster`、`cache_start`、Brent anchor 均复制上述有效值。即使 `cluster_count` 在事务期间变化，FAT 值仍先被 28 位掩码，保留既有的 live metadata 行为。
- 最多 4095 次成功 FAT 转移可抵达最高目标索引 4095。Brent power 在 `2^n-1` 次转移后升为 `2^n`，因此最高可达值为 4096；13 位足够。`brent_length` 只升至 `power-1` 后归零，仍在原 13 位范围内。cache 恢复保存相同的 Brent 状态。
- FAT wanted offset 是 `{current_cluster[6:0],2'b00}`，取值 0..508。FAT sector 请求从 byte_count 0 开始，仅对每个 `sd_valid` beat 递增；接受完整 512 bytes 时，0..511 每个偏移各出现一次，所以 wanted_offset 至 wanted_offset+3 四个字节必然采集。byte_count 只在旧值小于 512 时递增，能达到的最大值为 512；10 位表示精确。短读仍由 `byte_count != 512` 触发 E_SHORT，超长有效 beat 仍由 `byte_count >= 512` 触发 E_SHORT。
- `sd_valid && sd_end` 同拍沿用同一非阻塞赋值次序。最后一个 beat 到达时旧 byte_count 为 511，结束检查仍判 E_SHORT；拆开结束时旧 byte_count 为 512，完整传输通过。差分 bench 覆盖了 FAT 和 data 两种状态的短读、513-byte 超长、最后有效 byte 与 sd_end 同拍，以及完整 512-byte FAT 后完整 data 读。
- `data_addr_tmp` 的窄减法只在有效 `current_cluster >= 2` 下执行；S_CHECK 对起始簇验证下界，后续有效 FAT 值也检查下界。28 位先减再零扩展与 44 位零扩展后减在该可达域相同。
- 模块公开参数、端口名/方向/位宽没有变化。async reset、`enable` 分支、文件请求锁存、SD 握手及错误路径控制条件未改变；新增的计数 wire 由原对应 index 直接组合派生。

## 局部差分验证

运行：`pwsh -File development/resource80_work/wav/review_mapper/run_mapper_sd_edge.ps1`

日志：`build/mapper_sd_edge.log`，SHA256 `12925107C296EA08358E0F04264FB7CAB531E7B3054C2C0C2BDEFE9F30F05147`。结果：`PASS: mapper SD edge differential checks`。bench 每个负边沿逐周期比较外部 file/SD 输出与 error/error_code；同时比较两组计数、cluster/cache/anchor、Brent power 与 byte_count 扩位后的数值。短读、同拍最后 byte/end、超长及完整 FAT/data 场景均无差异。

已有长程验证按 `mapper/README.md` 和 `mapper/simulation.json` 记录：单项与组合边界差分 13,344 拍通过；组合最长链差分 6,381,198 拍、12,295 次扇区传输通过。此复核没有重复长测，也未运行 TD。
