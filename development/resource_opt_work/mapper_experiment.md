# FAT32 mapper 资源优化提案

此目录保存 `fat32_file_sector.v` 的可选资源改写器和离线逐周期差分夹具。提案脚本的 `apply(hdl_path, *, algorithm=True, address=True, index=True)` 只写入调用方传入的那个 HDL 文件；默认三项全开，三个布尔选项可分别消融。脚本自身不查找或修改活动工程源。

| 选项 | 改写内容 |
| --- | --- |
| `algorithm` | 用 24 位余数 ceil 计算取代 33 位加 511，再右移；用 `sectors_needed > (4096 << shift)` 取代簇数加法、减法和动态右移比较。 |
| `address` | 数据 LBA 算术采用 44 位，保留 32 位结果及 12 位溢出检测；FAT LBA 算术采用 33 位，并把 `(cluster << 2) >> 9` 化简成 `cluster >> 7`。 |
| `index` | 目标、遍历和缓存索引从 32 位缩为 12 位；Brent 计数器保留现有 14/13 位。 |

算法等价依据：`ceil(file_size/512)` 等于 `file_size[31:9] + (|file_size[8:0])`，最大值为 `0x800000`，24 位足够。对任意 4-bit shift，`ceil(sectors_needed / 2^shift) > 4096` 当且仅当 `sectors_needed > 4096*2^shift`；最大门限为 `2^27`，33 位足够。比较仍处在原有几何检查之后，错误优先级不变。

地址等价依据：FAT 偏移恒等于无符号 `current_cluster >> 7`，最大为 `0x01ffffff`，加任意 32 位 FAT 基址小于 `2^33`。数据路径中可达 cluster 始终至少为 2；起始簇通过 `cluster_count <= 0x0ffffff5` 与 `start_cluster <= cluster_count+1` 验证，后续簇经 FAT 28 位掩码和保留簇检查，缓存只保存已经验证的簇。因此 cluster 位 `[31:28]` 恒为零。数据 shift 在 S_SELECT 使用 live 4-bit 输入，取值范围仍按 0..15 处理；偏移小于 `2^43`，加任意 32 位 `data_lba` 和最大 15 位簇内偏移后小于 `2^44`。33/44 位最高位分别完整承接原 E_ADDR 溢出判定。`cluster_count+1` 仍保留原 32 位 wrap 语义。

索引等价依据：成功 S_CHECK 要求 `rq_sector < sectors_needed`、簇数不超过 4096 且 shift 不超过 7，故 `floor(rq_sector / 2^shift) <= 4095`。遍历索引从 0 或不大于目标的有效缓存索引开始，每次随 FAT 成功前进一步，仅在达到目标时读取数据；缓存索引也仅在数据读取成功后保存。因此这些寄存器的可达值均为 0..4095。输入、簇 ID、异常与超时检查、SD 握手、状态转换、缓存与 Brent 算法保持原样。

## 离线差分

在工程根目录执行：

```powershell
pwsh -NoProfile -File development/resource_opt_work/run_mapper_proposal.ps1
```

脚本将目标工程 HDL 复制到 `build/mapper_proposal`，生成 reference、algorithm-only、address-only、index-only 与 combined 五个独立模块副本；每个优化变体都与 reference 逐周期比较全部外部接口。边界夹具覆盖 live shift 0..15、data LBA 到 `0xffffffff` 的可达边界与溢出、FAT LBA 加法最大结果与溢出、最大可接受起始簇、簇范围异常、文件大小 0/1/511/512/513、4096/4097 簇门限及 `0xffffffff` 文件大小。combined 变体另复用长链夹具，跑 4096 簇合法上界、缓存续走/回退、4097 簇拒绝、长链 EOC 和晚期 Brent 环检测。

2026-10-20 实测：四种变体的边界差分均 PASS，每项 13,344 周期；combined 长链差分 PASS，6,381,198 周期、12,295 个 SD sector 事务，并验证可达 cache Brent power=4096。Icarus 仅报告模块缺少 timescale 的既有警告。仿真验证功能与周期一致性，不提供综合 LE 估算或路由结论；需在父代理的独立工程副本查看综合资源。

TD 6.2.1 独立消融结果已补在 [mapper synthesis](mapper_synthesis/README.md)：reference 836 LUT/440 FF，combined 726 LUT/397 FF，独立地址改写的 LUT+FF 有 6 个计数回归。详细 SHA、console 与 `gate.area` 在 `mapper_synthesis/runs/`；combined 的 standalone `LUT+FF` 减量为 153，仍需依据完整工程综合及布局布线结果决定采纳范围。

数据地址的簇内偏移另有 [aligned-OR 提案](mapper_aligned_proposal.py)：`((cluster-2)<<shift)` 的低 `shift` 位恒为零，`sector & ((1<<shift)-1)` 只占低 `shift` 位；两项按位互斥，因此加法可逐位替换为 OR，随后只需对 `data_lba` 做一次 44 位加法。此证明覆盖 live shift 的全部 0..15 值。组合版 Icarus 边界测试加入了目标 sector 127、S_CHECK shift=7 后在 S_SELECT 改 live shift 的情况，同时跑两项非零；combined-or 边界与最长链差分均通过。独立 TD 面积从 combined 726 LUT/397 FF/12 carry 降到 combined-or 708/397/11；相对 reference 的 LUT+FF 减量为 171，仍低于 500。
