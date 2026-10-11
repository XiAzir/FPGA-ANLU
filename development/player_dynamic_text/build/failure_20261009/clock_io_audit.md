# 2026-10-09 动态字幕上板失败：时钟、复位与 I/O 审计

## 结论

目前证据不支持把字幕 RTL 的功能逻辑直接认定为 SD/FAT 或音频故障根因。相对已确认工作的 `player_osd_phy_fix`，源码差异只有 `top_tf_hdmi_audio.v` 把 `player_osd` 的 RGB 输出接入新增 `player_dynamic_text`，以及新增该模块；音频、SD/FAT、PLL、ADC/SDC 和按键逻辑都未变（`build/source_delta.json`，`build/manual/build_source_scope.json`；top 的实际差异见两工程 `top_tf_hdmi_audio.v`）。新模块只接收 video clock、VS、DE 和 RGB，输出也只进入 HDMI RGB 路径，没有到 SD 请求、BMP 状态、PCM 或 ACR 的逻辑连线。

但新模块改变了全局综合、布局和布线，并增加 `rst_all` 与 `video_clk` 负载。用户反馈同卡、供电、HDMI、音量条件下回退后恢复，说明失败与候选 bitstream / 其物理实现相关；这不能区分布局变化、复位启动状态、物理链路或偶发因素，也不能单凭回退成功证明字幕电路存在功能错误。

最值得先验证的共同启动风险是：同一个由板载参考时钟生成的 `rst_all` 被直接送入 SD、SDRAM、像素及 HDMI 子系统，缺少各目标时钟域的同步释放。帧写提交链路还包含跨时钟的请求确认，值得单独做握手检查。另一方面，内部 tone 由像素时钟域独立生成、不经过 SD/WAV FIFO；它失真意味着仅修 SD 文件读取不足以解释全部现象。当前只能把“帧提交未完成”和“HDMI 音频通道异常”作为两条待证路径，不能合并成已确认的单一根因。

## 可确认的设计与实现证据

### 1. `IMG 0/4` 证明目录计数，不证明首帧提交

- `fat32_catalog` 的 `fs_bmp_count` 被直接送给旧 OSD；旧 OSD 在 `image_valid=0` 时仍会显示编号 0，而总数仍显示目录数。因此 `IMG 0/4` 与“目录已经找到4张图，但首个图像还未标记有效”相容。它不能单独证明 BMP 数据已完整写入 SDRAM 或已提交显示缓冲区。
- `tf_bmp_file_player` 初值 `display_valid=0`，首次读取在 `WAIT_CATALOG` 后进入 `IDLE`，然后走 header、写请求、payload 和 `COMMIT`；只有 `COMMIT` 看到 `write_done || finish_pulse` 才置 `display_valid=1`（`src/user_source/hdl_source/tf_bmp_file_player.v` 中 `display_valid` 复位、`WRITE_WAIT`、`COMMIT`）。顶层在 `display_valid=0` 时将底图强制为黑色（`top_tf_hdmi_audio.v` 的 `vout_data_base`）。这能解释字幕正常但无图像的外观。
- 写完成通知路径较明确：SD 域的 `tf_bmp_file_player.finish_sync` 对来自 mem 域的 `frame_write_toggle_mem` 进行三级同步，再用异或形成 `finish_pulse`；顶层在 `frame_write_finish` 时翻转 toggle。相较之下，启动握手的 `write_req_ack` 由 mem 时钟域 `frame_fifo_write` 驱动，并直接接到 SD 时钟域 BMP 状态机的 `WRITE_WAIT`，未在接收域再加同步级。这是一个可审计的跨域握手薄弱点，但请求本身保持为电平直到确认，且 SD 与 SDRAM 时钟被配置为同一系统 PLL 的同频输出；现有证据不足以断言它已造成当前卡死。应以路由后的具体跨时钟路径及波形进一步确认。

### 2. 复位释放跨多个时钟域，是共同启动风险

- 顶层 `rst_all_reg` 在输入 `clk` 域计数 PLL lock 后释放：等待计数值达到 1,000,000（名义 20 ms @ 50 MHz），见 `top_tf_hdmi_audio.v` 的 `rst_cnt/rst_all_reg`。该一个 `rst_all` 随后直接接入 SD 卡、FAT、BMP/WAV、SDRAM/帧缓存、视频 timing、字幕、HDMI core、音频 probe 等模块。
- `sys_pll` 和 `video_pll` 的 `reset` 都连常量 0；锁定状态只参与顶层等待。`rst_all` 的释放只在板载参考 `clk` 的边沿更新，没有分别由 `sd_card_clk`、`ext_mem_clk`、`video_clk`、`hdmi_5x_clk` 同步释放的本地域复位管线。
- 多数这些模块使用 `posedge rst` 异步置位/清零。异步复位可以可靠地把逻辑拉入复位态，但直接异步释放到不同相位的时钟域，无法保证各寄存器在同一目标时钟边沿退出复位。可能的后果包括 SD/FAT、首帧写入/提交、音频 ACR/serializer 初态不同步。这个 RTL 结构问题可以确证；它是否触发了本次实板症状尚无启动波形或复位相位测量，属于待验证原因。
- 顶层 `status_reset_pipe` 已在 `video_clk` 域同步释放 `status_sys_rst`，说明工程已有局部 reset pipe 用例；它只服务状态显示，不能替代其他域的复位释放同步。

### 3. WAV 静音和内部 tone 失真属于不同链路

- `player_audio_probe` 的 WAV 分支通过 `wav_pcm_bridge` 从 SD 域读取 PCM：请求与确认使用同步 toggle，样本用稳定 mailbox 传递。内部 tone 分支来自 `hdmi_audio_tone_pcm_scale`，直接运行于 `pixel_clk`，不经过 FAT、SD SPI、WAV 播放器或 sample mailbox；长按按键的 tone 模式也在 pixel 域切换。两个分支再汇入同一 `audio_arc_calculate` 和 HDMI transmitter。
- 因此 WAV 静音与 `fs_wav_found`、`wav_primed`、underflow、`audio_valid` 有关；tone 严重失真则把检查重点带到 pixel 域复位、ACR、HDMI 音频包和 TMDS serializer。若 WAV 确实静音、tone 也失真，单独调 SD MISO 或修 BMP 提交不能解释 tone。共享复位或 HDMI 音频/发送路径可影响 tone；两者也可能是候选布局变化造成的两项独立物理问题。
- 此次候选与通过的 `player_osd_phy_fix` 之间，`player_audio_probe.v`、`wav_pcm_bridge.v`、`hdmi_audio_tone_pcm_scale.v`、音频 ACR 和相关顶层输入都未修改（`build/source_delta.json`）。这排除了这些音频模块的源代码回归，但不能排除复位启动状态或重新布局布线对 HDMI 发射链的影响。

### 4. 当前 SDC 没有 exclusive clock group，但 I/O 时序仍未约束

- 实际约束文件 `src/user_source/constraints_source/timing.sdc` 建立 50 MHz 输入时钟、调用 `derive_clocks`，并给 SD 50 MHz、SDRAM 50 MHz/移相时钟、视频 25 MHz 和 HDMI 5x 125 MHz PLL 输出命名。文件内**没有** `set_clock_groups -exclusive`。文件注释也明确像素时钟和串行器时钟同时运行，不应靠 exclusive 或屏蔽全部跨域路径来获得 Timing Clean。
- 路由后报告 `build/manual/AC201_tf_hdmi_pr.timing` 标为 `Confidence: Routed`、STA coverage 99.98%；setup/hold status 为 yes，摘要为 SWNS 0.513 ns、STNS 0.000 ns、HWNS 0.024 ns、HTNS 0.000 ns。成功基线记录的 routed slack 是 SWNS 0.629 ns、HWNS 0.030 ns。新构建内部静态时序通过，但相对基线余量约少 0.116 ns（setup）和 0.006 ns（hold）；正余量不等于功能/信号完整性/CDC 证明，接近零的 hold 余量也不应解读成宽裕。
- 同次 `AC201_tf_hdmi_chk.timing` 明确列出 4 个缺少 input delay 的端口：`key1`、`key2`、`rst_n`、`sd_miso`；14 个输出端口缺少 output delay。按键在 RTL 中有双触发器同步和去抖，因此没有普通同步输入 delay 不能直接解释按键失灵；`sd_miso` 则是由 `spi_master` 在 `DCLK_EDGE` 直接采样的外部数据，没有外部卡片输出延迟/走线预算，报告不能证明 SPI 输入采样裕量。SDC 也没有将生成的 `sd_dclk` 与 MISO 建成板级 I/O 采样预算。
- STA 只检查它建模并约束的同步路径。它不验证异步复位释放亚稳态、SD 卡协议/卡片输出时序（未约束输入 delay）、文件内容和首帧 commit 协议，亦不检查扬声器听感或 HDMI 接收端对音频 packet/ACR 的实际解码。因而“Routed / 99.98% / setup、hold yes”与实物功能失败并不矛盾。

## 证据边界

- 成功基线 `build/board_feedback_20261009.json` 记录 bit SHA-256 `9E893B0B…F3B60AE6F`，用户确认图像、手动/自动切换、真实音乐及长按内部 tone 正常；记录来源为用户现场反馈，未测物理波形。
- 动态候选 `build/manual/AC201_player_dynamic_text.info.json` 记录 bit SHA-256 `D0559A20…54CBF28F`。新增动态字幕仿真和 STA 是模型/静态报告证据，不代表实际上板验证。
- 两个 build 的 `.ts` 和 timing 摘要只能说明各自实现对现有约束的报告状态。不同的 bit 与布局意味着回退 A/B 不能单独证明是字幕组合路径、复位网、板级信号裕量或另一启动差异造成；此次没有测量 PLL 锁定/相位、SD_DCLK/MISO 眼图、reset release 波形、HDMI 音频包和实际声学输出。

## 建议的一个有限修复

先对顶层统一复位做“异步断言、各域同步释放”：保留现有 PLL lock 与启动延时作为 `rst_all`，再分别用 SD、mem、pixel 和 serializer 目标时钟驱动两级本地 reset pipe；`rst_all` 拉高时异步置位本地 pipe，`rst_all` 拉低后各域只在自己的连续两个时钟沿后释放。跨多个时钟的模块（帧缓存、OSD 元数据邮箱、音频 probe）应在模块内部按其各自时钟域分发本地复位，不能把一个域的 `local_rst` 直接替换到整模块。

这是一个针对“首帧没提交、WAV 未 primed 和 pixel 域 tone/ACR 状态同时异常”的共同启动假设的单项 RTL 修复。可先用多时钟、随机初相位的普通行为模型检验：任意复位释放相位下，各 FSM 都保持复位到本地域两个边沿之后；随后 SD catalog→首 BMP 请求→mem 完成 toggle→`display_valid` 提交能完成；pixel 域 tone 只在有效 ACR/audio packet 后输出。模型通过仍需同条件上板 A/B 才能确认。若 reset 修复后 BMP 仍停在首帧，下一项才应单独为 `write_req_ack` 做目的域同步并建模 request/ack 在相位变化下不丢失；不要把这两项同时改掉，否则无法定位。

## 新现场码与 WAV `E_EOC` 证据（追加）

现场报告的数码管值 `1d950007` 解码为：PLL lock=1、`rst_all=0`、card init=1；`fs_ready=1`、`fs_error=0`、`display_valid=0`、`bmp_error=1`、`wav_primed=0`、`wav_error=1`、`bmp_map_error=0`、`wav_map_error=1`，`wav_map_error_code=8'h07`。这些状态由现场提供的 page0/file95 解码，与顶层 `status_hex` 字段拼接一致。它表明卡初始化和 FAT 卷 mount 已完成，但 WAV 文件映射报错；不支持“卡未初始化”解释。BMP 与 WAV 分别有 `fat32_file_sector` mapper，当前 WAV mapper 报错而 BMP mapper 没报 mapper error；`display_valid=0` 仍可由 BMP payload/写入/提交错误解释，不能从 WAV 的 `E_EOC` 推出其直接原因。

### `E_EOC` 到底表示什么

- `fat32_file_sector.v` 的 `S_FAT_EVAL` 将 4 个 FAT 字节按小端组合，再掩掉高 4 位：`next_cluster = {fat_b3,fat_b2,fat_b1,fat_b0} & 32'h0fffffff`。若结果 `>= 0x0ffffff8`，明确调用 `fail(E_EOC)`；`E_EOC=8'h07`。因此 `wavmap=07` 不是泛化的 SPI/读超时码，也不是“卡未 mount”，而是 mapper 已读到一个被判为 FAT32 end-of-chain 的 FAT entry，却仍在为目标 WAV sector 请求下一簇。
- 同一流程会先验证 `rq_sector < ceil(file_size/512)`，再比较 `walk_index` 与 `target_index=rq_sector >> sectors_per_cluster_shift`。只有目标 sector 位于文件声明大小范围内、但沿 FAT 链走到 EOC 还未抵达目标簇时，才会以 07 失败。若链长度确实短于 header/catalog 声明的 `fs_wav_size`，此行为是正确的错误报告；若物理 FAT 链有后继簇，则错误数据可能来自 FAT 位置/偏移、SD 读字节或传入的 cluster/file size/sector。
- 当前上板状态没有暴露 `rq_sector`、`target_index`、`current_cluster`、`wanted_offset` 或捕获的四个 FAT 字节。故现场状态足以确定“mapper 认为链提前结束”，还不足以确定这份 FAT entry 在卡上本来就是 EOC，或是 SD SPI 将字节/位采错。也没有证据证明 WAV 物理文件链完整或 `fs_wav_size` 与链长匹配。

### SD 采样风险与判因边界

- `sd_card_top.v` 固定 SPI mode 3（`CPOL=1, CPHA=1`）。高速度 divider 在 `sd_card_sec_read_write` 请求事务时设置为 0；按注释公式 `sys_clk / ((divider+2)*2)`，`sd_card_clk=50 MHz` 时 SD_DCLK 为 12.5 MHz。`spi_master.v` 在 FPGA `sys_clk` 的 `DCLK_EDGE` 状态直接采 MISO，CPHA=1 时在 `clk_edge_cnt` 奇数边沿采样。Mode 3 卡通常在下降沿更新、上升沿采样，逻辑相位符合常规 mode 3；但外部 MISO 没有 input delay/板级偏斜预算，STA 未证明输入采样窗口。
- 只有四字节小端组合并掩成28位后的值整体达到 `0x0ffffff8..0x0fffffff` 才产生 EOC，单独任一字节高 nibble 为F并不足以触发。SPI位错或错误FAT地址/偏移可能使返回组合值落入EOC范围，但本次缺少实际四字节，未证实此机制。12.5 MHz下相邻SCLK边沿间有40ns名义时间，但没有SD卡tCO、FPGA输入延迟、走线/电平转换器延迟和输入门限实测，不能据当前 `.timing` 断言稳定或失效。
- 最小区分实验应在同一 WAV 失败请求点同时记录 `fat_lba`、`current_cluster`、`wanted_offset`/目标 byte offset、SD 返回的该 512-byte FAT sector 中对应四字节，并将 SD_DCLK/MISO 用逻辑分析仪按 mode 3 解码；把原始四字节与该卡 FAT 内容核对。若捕获字节和卡内容相同且 entry 是 EOC，根因转向 WAV 文件链/文件大小一致性或 cluster/sector 参数；若不匹配，先做 SD 输入相位/速度的单变量 A/B（暂降 SPI 时钟，必要时只改采样点），再讨论正式修复。当前不应先全局重写 reset 或 FAT walker。

### 最小资源优化候选（不改变功能边界）

动态构建路由摘要给出 `9678` slices、`98.76%`，物理阶段还报告 `7930` seq、`8991` LUT；资源余量确实很小。`fat32_file_sector.v` 已显式限制一个文件最多 4096 clusters / FAT hops（`clusters_needed > 4096` 与 `walk_count >= 4096` 检查），但 Brent cycle tracking 的 `brent_power`、`brent_length` 及缓存副本都声明为 32 位。一个有限、可证明的缩宽候选是 `brent_power/cache_brent_power` 改 14 位，`brent_length/cache_brent_length` 改 13 位：在最多 4096 次 hop 中，power 最大可到 8192，length 最大不超过 4096（13 位也保留了 `length+1` 的 4096 比较值），均可表示；anchor 和 `walk_count` 不改。四个状态量合计由 128 位降至 54 位，理论少 74 个寄存器位及相应加法/比较位宽。它不影响允许链长、EOC/loop判定或功能，但需要做边界仿真（4095/4096 hop、power 到 8192、缓存续走）并重新综合/route确认工具确实节省 slices；在没有重跑工具前，不保证具体省多少 slices，也不把它当作 WAV 错误修复。
