# Arch17 shared mapper 候选集成说明

## 候选与接口

`candidate.v` 声明 `fat32_dual_file_sector`。它保留 BMP/WAV 各自的请求端口、字节流、`file_end`、sticky `error/error_code`，并将两路 mapper 的 SD 物理端口收敛为一个 `sd_read/sd_addr/sd_data/sd_valid/sd_end`。

共享配置输入直接映射现有 `fs_*`：

| 候选端口 | 现有顶层信号 |
| --- | --- |
| `fat_lba/data_lba/cluster_count/sectors_per_cluster_shift` | `fs_fat_lba/fs_data_lba/fs_cluster_count/fs_cluster_shift` |
| BMP `enable/start_cluster/file_size/file_read/file_sector` | `fs_ready && !fs_error`、`bmp_file_cluster`、`bmp_file_size`、`bmp_card_read`、`bmp_card_addr` |
| WAV `enable/start_cluster/file_size/file_read/file_sector` | `fs_ready && fs_wav_found && !fs_error`、`fs_wav_cluster`、`fs_wav_size`、`wav_card_read`、`wav_card_addr` |
| BMP 输出数据/valid/end/error/code | `bmp_card_data/bmp_card_valid/bmp_card_end/bmp_map_error/bmp_map_error_code` |
| WAV 输出数据/valid/end/error/code | `wav_card_data/wav_card_valid/wav_card_end/wav_map_error/wav_map_error_code` |
| 单一物理读接口 | 候选 `sd_*` 接 `arb_card_read/arb_card_addr` 所在的物理侧；不要再实例化 `sd_sector_arbiter` |

Mount 仍由原 `shared_card_read/shared_card_addr` mux 门控：`fs_ready ? candidate_sd_* : fs_read/fs_addr`。回传数据仍用 `shared_card_data`，候选物理输入 valid/end 接 `fs_ready && shared_card_valid/end`。`fat32_catalog`、BMP/WAV 播放器、诊断监视器和卡控制器的连接保持原有映射。

## 消融开关

顶层使用单个 elaboration 参数或宏 `ARCH17_SHARED_MAPPER` 选择实现。`1` 分支实例化 `fat32_dual_file_sector` 并把它的唯一物理接口接到 Mount 后的卡侧；`0` 分支保留当前两份 `fat32_file_sector` 和 `sd_sector_arbiter` 原样连接。让两个分支共享相同播放器/诊断 wire，便于在同一工程对照；不要在 `1` 分支保留旧 arbiter。模块默认 `REQUEST_STABLE=1`、`WAV_STATIC_FILE=1`，对应 BMP101/WAV111 已验证调用契约：请求字段由上游保持到完成，WAV 文件描述符在 enable 期间稳定。可将两参数置0编译快照通用分支。通用旧 `fat32_file_sector.v` 继续作为 reference。原始 mapper、当前顶层和 arbiter 源码由 source receipt 固定哈希。

## 调度与功能语义

- 共享单 FSM 每次完成一个完整 FAT 或 data 物理扇区后回到调度点；各 client 的请求视图、walk 位置、当前簇、cache有效标志/identity tag独立保存。cache cluster/index/Brent字段复用 quiescent 的 current/walk/Brent寄存器：新 walk初始化前先读旧值决定是否续走，成功data sector只置cache有效与identity tag。
- 调度沿用原 arbiter：WAV 有待办且 BMP 没有待办，或 `audio_streak < 2` 时发 WAV；BMP 被选中时清零 streak。WAV 独占时 streak 饱和到 2，但不会阻止 WAV 连续发起后续 sector。
- 一个 4096-hop FAT walk 在每个 FAT sector 后可让出。WAV 请求在 BMP walk 未完成时可获得最多两个连续扇区后服务 BMP，避免 BMP 长链长期持卡。
- 每次逻辑请求只在对应 client 的 read 曾拉低后接受一次高电平；生产默认使用上游稳定请求字段，快照通用模式由 `REQUEST_STABLE=0` 编译。disable 清 client 的 armed、busy、queued、cache、watchdog与当前 walk，错误状态保留；正在卡侧执行的扇区进入`C_DRAIN`并排空到`sd_end`，期间不给该client输出字节或接收新请求；低电平可arm，高电平保持到扇区排空后再接受。
- 两路独立 `WAIT_LIMIT` watchdog覆盖当前物理owner与排队等待中的peer。timeout置对应sticky错误和`file_end`；owner timeout后物理扇区保持drain直到卡侧`sd_end`，peer仍继续累计并可独立timeout。
- `file_end` 在成功返回完整 data sector时脉冲；FAT short/timeout/range/cluster/address/FAT/EOC/loop/limit错误码保持与原 mapper 一致。512 字节逐字节输出、ceil(size/512)及4096簇容量限制继续使用原算法。

## 验证边界

`tb_fat32_dual_file_sector.v` 用 512-byte sector 模型验证两个客户同时排队时的两次 FAT walk、WAV 两扇区优先上限、BMP 插队、完整数据字节数与独立数据流。`tb_fat32_dual_timeout.v` 验证active owner与排队peer独立timeout和reset清除；`tb_fat32_dual_disable_drain.v`验证disable/re-enable drain归属；`tb_fat32_sd_end_edge.v`比较511/512-byte边界同拍valid/end行为；`tb_cidle_peer_timeout_race.v`覆盖C_IDLE队列超时与新派发同拍。Icarus PASS 记录见 `source_receipt.json`。同wrapper的独立AreaHigh对照为双mapper+arbiter 2029 LUT/642 reg，冻结shared 084为1494 LUT/396 reg；完整top、布局布线和时序正在父C11317/A04中验证。
