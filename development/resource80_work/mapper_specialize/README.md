# fat32_file_sector 编译期专门化

本目录从 C11314 mapper A889 派生，所有改动局限于本目录。当前主候选和工程脚本未修改，未运行 TD。RTL 新增三个默认值为 0 的参数：`CATALOG_GEOMETRY`、`STATIC_FILE`、`REQUEST_STABLE`。全部为参数常量；`CATALOG_GEOMETRY` 用 generate 分支构造常量零错误线，其他两项以常量条件选取直接输入/请求快照及 cache identity。参数为 0 时保留原 32-bit request snapshots、geometry 检查和 cache tags。

候选与基线：`fat32_file_sector.v`；基线快照 `fat32_file_sector_generic.v`（只改模块名，来自同一份 A889）。综合参数建议留给主线程实际测量：

```verilog
// BMP: file descriptor may change between images, so retain cache identity tags.
fat32_file_sector #(.CATALOG_GEOMETRY(1), .REQUEST_STABLE(1)) u_bmp_file_mapper (...);

// WAV: catalog descriptor is fixed while its mapper stays enabled.
fat32_file_sector #(.CATALOG_GEOMETRY(1), .STATIC_FILE(1), .REQUEST_STABLE(1)) u_wav_file_mapper (...);
```

## 合同证明

- `fat32_catalog` 仅在 BPB 几何检查通过后写出 `sectors_per_cluster_shift`、`cluster_count`、`fat_lba`、`data_lba`。有效 BPB 检查约束 SPC 为 1,2,…,128（shift 0..7），`cluster_count` 在 65525..`0x0ffffff5`。由 catalog 的分区校验，`volume_end = start + total <= 2^32`；数据区至少含 `cluster_count * SPC >= 65525` 个扇区，因此 `data_lba = volume_end - data_sector_count <= 2^32 - 65525 < 0xffffffff`。FAT area 的正扇区跨度保证 `fat_lba < data_lba`，所以 `fat_lba` 也严格小于 `0xffffffff`。catalog 同时检查 FAT/data/root LBA 均小于 `2^32`。其后仅有 `S_DONE` 置 `ready=1`；输出几何寄存器不会再更新。top 只有 `fs_ready && !fs_error` 时启用两 mapper。因此 `CATALOG_GEOMETRY=1` 的实例始终满足被省略的四个几何条件；文件级 `rq_start`、`rq_size`、`rq_sector` 检查仍执行。
- WAV 的 `start_cluster/file_size` 来自 catalog 的 `wav_cluster/wav_size`，二者只在目录项接受时写一次，并在 `S_DONE` 保持。WAV mapper enable 为 `fs_ready && fs_wav_found && !fs_error`；enable 低时 mapper 原有分支清 `cache_valid`。故 WAV 可用 `STATIC_FILE=1`，省去 request start/size 寄存与 cache identity tags。BMP descriptor 在不同图像间会变化，且 enable 长期有效，所以 BMP 必须保持 `STATIC_FILE=0`。
- WAV sector 是 `tf_wav_file_player` 的 `sd_addr` 寄存；BMP sector 是 HEADER 的 `header_addr` 或 scaler 的 `card_addr` 寄存。两 caller 都在同一状态边沿更新地址并拉高 read，收到 card_end 后先撤 read，经历空隙后才可发下一请求。descriptor 和 sector 在 mapper 接收 read 至对应 file_end 期间保持稳定，因此两个 top mapper 可用 `REQUEST_STABLE=1`。BMP 可在完成当前图像并通过 `WAIT_DISPLAY` 后更换 start/size；该时点已在前一个 sector 的 file_end 之后。
- enable 在事务中途撤销时，mapper 立即回到 IDLE 并失效缓存；专门化不改变该路径。复位仍异步清零状态和 generic snapshots。REQUEST_STABLE 合同在 reset/disable 时终止，caller 只能在重新发出 read 后开始新的稳定区间。

## 差分验证

从工程根执行 `pwsh -File development/resource80_work/mapper_specialize/run_specialize_sim.ps1`。该脚本依次仿真参数组合 000..111；generic A889 与候选逐周期比较外部 `file_data/file_valid/file_end/error/error_code/sd_read/sd_addr`。

八种组合均 PASS。每种覆盖：`file_size=0`、sector 越界、非法 start cluster、超 4096-sector 限制；短、513-byte 超长、末 byte 与 sd_end 同拍的 FAT/data 扇区；完整 512-byte FAT 后接完整 data 的内容序列；enable 中断再恢复；事务中异步 reset 再发新请求。generic 000 另外验证 request 接受后输入 file metadata 改变仍使用已锁存值，而 `data_lba` 在 S_CHECK 后改变会按原有 live 行为参与 S_SELECT 地址计算。CATALOG_GEOMETRY=0 的模式还核对零 cluster_count、shift 8、全 1 LBA 与超上限 cluster_count 的旧错误码。

逐模式日志在 `build/<mode>.log`，总览在 `build/summary.json`。EG4S20BG256、20 ns SDC、AreaHigh + AdderThreshold18 的同条件 standalone 双实例对照：generic 000 为 2069 device LUT / 690 FF，BMP101 + WAV111 为 2015 device LUT / 569 FF，差值 -54 LUT / -121 FF（generic LUT 1364→1280，BRAM/DSP 均为 0）。整机 top 参数已接线，源哈希与补丁及前置基线记录在 `integration_manifest.json`。BMP101 长链实际差分 PASS：6,381,198 cycles、12,295 个 SD 扇区，含 4096-cluster 合法上限/Brent power=4096、cache continuation/backseek、4097-cluster E_LIMIT、长 EOC、迟发 loop。WAV111 同场景长链差分 PASS：6,381,201 cycles、12,295 个 SD 扇区；八参数组合短边界/transaction 差分已有全 PASS。source receipt 校验到 10 项 overrides 的 SHA 均匹配当前源；对照 checkpoint 的 8 个实际 RTL 差异全部被覆盖，另 2 项为相同文件。
