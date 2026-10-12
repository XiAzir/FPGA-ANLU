# T26 转场前双缓冲审计

审计对象是 `development/player_pcm_waveform_keyfreeze/src/user_source/hdl_source` 当前源码。用户已补测确认 C11204 的功能组合音画正常；动态波形双线和清晰度问题接受暂留优化，不能据此认定转场链路已验证，也不能把它当作根因或长稳结果。本文仅做静态源码审计，没有运行编译、仿真或硬件验证。

## 结论

工程确有两块完整紧凑 RGB888 帧区，运行时加载器也会先把新图写到非当前显示区，并等图像源送完和 SDRAM 整帧写完后才更新“当前显示图”。这证明了**预加载/硬切换**的基本 ownership 方案；它没有证明擦除转场成立。现有读通路每次请求只选一个 buffer 起点，然后顺序读完整帧；像素解包器也消费一条连续像素流。要做逐列擦除，至少要新增按扫描位置产生旧/新图地址片段、可切换片段源并保持像素与视频时序对齐的预取/读调度。转场进行期间两块 buffer 都必须被显示读端持有，不能把旧图提前交还写端。

当前源码没有证据证明 T24/T25 基线存在转场相关错误。可确认的限制是它没有实现转场状态或多片段读取。

## 源码事实与资源核算

- 实际顶层实例化 `tf_bmp_file_player`，而不是旧的 `sd_card_bmp`：[top_tf_hdmi_audio.v:207-220](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/top_tf_hdmi_audio.v#L207)。旧 `sd_card_bmp` 文件不是本次运行入口。帧缓冲器接收加载器的写请求/像素和 `write_buf_idx`，显示端接收 OSD 锁存的 `osd_buffer_idx`：[top_tf_hdmi_audio.v:314-336](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/top_tf_hdmi_audio.v#L314)。
- `frame_buffer_rgb888` 只支持 buffer 0/1；`LINE_WORDS=(640/4)*3=480` 个 32-bit word/行，`FRAME_WORDS=480*480=230400` word/帧，buffer0 基址 0、buffer1 基址 230400；几何校验要求两帧均放入 SDRAM：[frame_buffer_rgb888.v:29-55](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/frame_buffer_rgb888.v#L29)。因此两帧占 460800 word，约 1.76 MiB（921600 bytes/帧、1843200 bytes/双帧）；`EG_PHY_SDRAM_2M_32` 的 2,097,152 个 32-bit word 里还剩 1,636,352 word（约 6.24 MiB）。这里是地址容量，不代表带宽可用量。
- 每行 640 像素被编码为 480 个 32-bit word。写 packer 连续每 4 像素产生 3 word：[rgb888_word_codec.v:3-5,18-51](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/rgb888_word_codec.v#L3)。读端解包用 64-bit reservoir、word FIFO 与像素相位连续出流；它没有像素坐标或来源切换输入：[rgb888_word_codec.v:57-124](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/rgb888_word_codec.v#L57)。
- 当前显示读取每帧由 VS 边沿发起一个 `read_req`：[video_timing_data.v:64-72](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/SD/video_timing_data.v#L64)。`frame_buffer_rgb888` 将 `read_len=FRAME_WORDS`，并把所选 buffer 基址交给旧 backend：[frame_buffer_rgb888.v:69-100](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/frame_buffer_rgb888.v#L69)。`frame_fifo_read` 在 ACK 阶段锁存起始地址索引及长度，之后地址只逐 word 加一；长度按固定 `BURST_SIZE=256` 逐 burst 累加，故现状是一条线性整帧流（230400/256=900 个 burst）：[frame_fifo_read.v:43-80,127-153,184-215,216-263](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/SD/frame_fifo_read.v#L43)。现有接口没有行号、x 范围、片段长度队列或随机重启地址协议。
- 新图写入目标由 SD 域加载器选择：首图写 buffer0；已有图时写 `~disp_buf_idx[0]`，同时记录 `pending_buffer`：[tf_bmp_file_player.v:87-97](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/tf_bmp_file_player.v#L87)。BMP 源结束并不足以提交；`write_done` 由 mem 域 `write_finish_toggle` 同步后记录，只有进入 `COMMIT` 且已看到写完成，才原子更新 `disp_buf_idx`、`image_index` 和 `display_valid`：[tf_bmp_file_player.v:68-80,155-165](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/tf_bmp_file_player.v#L68)。写端 `write_finish` 来自 `frame_fifo_write` 的 `S_END`，而其写计数以 256-word burst 前进到 `write_len_latch`：[frame_fifo_write.v:81-89,253-287](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/SD/frame_fifo_write.v#L81)。
- `write_finish` 在顶层 mem_clk 域转成 toggle，再由加载器同步回来：[top_tf_hdmi_audio.v:188-194](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/top_tf_hdmi_audio.v#L188)。`player_osd_state` 用 held bundle + toggle/ACK 跨 SD 与 pixel 域传输 buffer、编号、数量、auto、valid；在 pixel 域 `read_req` 上升沿一起锁存 frame bundle，并延迟一拍送出读请求：[player_osd_state.v:1-4,16-36,39-63](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/player_osd_state.v#L1)。所以显示的 buffer 和 OSD 编号在帧读启动时成组选择；加载器自己的 `disp_buf_idx/image_index` 提交时点与像素域实际使用新 bundle 之间仍有 CDC 往返延迟，代码没有“像素域已停止读旧区”的 ACK。
- 顶层实例 `sys_pll` 输出系统/SDRAM user clocks，IP 注释核定 C0/C1 为 50 MHz、C2 为相移 50 MHz：[sys_pll.vhd:11-20](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/IP/sys_pll.vhd#L11)。`video_pll` C0 为 25 MHz：[video_pll.vhd:11-19](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/IP/video_pll.vhd#L11)。顶层连线分别把 `ext_mem_clk`、`ext_mem_clk_sft` 给 SDRAM 和 `video_clk` 给像素端：[top_tf_hdmi_audio.v:170-185,314-336](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/top_tf_hdmi_audio.v#L170)。单路 RGB888 的平均消费量按 25 Mpixel/s × 0.75 word/pixel = 18.75 Mword/s；两路并行全像素流为 37.5 Mword/s，低于 50 MHz 每周期最多一个 32-bit word 的名义接口速率，但没有为刷新、控制空拍及写入留量，不能当作可实现吞吐保证。顺序擦除分段若每行发两个片段读请求，按当前 256-word 最小 burst 估算，最坏可到 2×256×480=245760 word/frame（片段总有效量 230400 word，最多约 6.7% burst 尾部额外读取），请求/重新装 FIFO 开销也要另计。

## Ownership 生命周期与边界

| 阶段 | 写端所有者 | 显示读端所有者 | 可复用区 |
| --- | --- | --- | --- |
| 首图前 | loader 选 buffer0 | 无有效帧 | buffer1 空闲 |
| 稳态预载 | loader 选当前显示区的另一块 | 当前 `disp_buf_idx` | 非显示区只在该帧完整写完后才成为候选显示区 |
| 现有 COMMIT 后 | 暂无/下一图任务尚未写入 | 新 `disp_buf_idx`，由 pixel mailbox 在后续帧读启动时接收 | 旧显示区在新图完整提交后逻辑上空闲；源码没有单独的 pixel “旧区读完”确认 |
| 擦除期间（建议） | 无写入；下一图等待/排队 | old 与 new 两区都被逐像素读端持有 | 无可写帧区 |
| 擦除完成并帧边界提交后 | 可将旧区用于下一次预载 | new 区独占显示 | old 区可复用，需保证读端已完成最后一帧请求 |

当前路径从 `COMMIT` 到下次真正写 SDRAM 之间通常还要读文件扇区及排空 SPI/SD 仲裁，因此源代码结构给 CDC 传播留出了运行时间；但没有显式回执证明该时间边界，静态审计不能把它升级为严格保证。转场状态下旧区会持续参与读取，必须新增明确的 `transition_active` ownership 锁，并等 pixel 端报告 final-frame/read completion 后才允许将旧区交给 loader。

## SD 音频共享与失败/忙策略

顶层 BMP/WAV 两个 FAT 映射器共用一套 SD 物理读口，经 `sd_sector_arbiter` 选择 owner：[top_tf_hdmi_audio.v:222-243,404-418](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/top_tf_hdmi_audio.v#L222)。仲裁以扇区结束为抢占点；BMP 等待时 WAV 最多连续拿两扇区，随后让一个 BMP 扇区通过，再允许 WAV：[sd_sector_arbiter.v:1-41](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/sd_sector_arbiter.v#L1)。因此预载可被音频扇区延迟，但源码不是“WAV 永远优先”；仍应观察实际扇区服务、音频 FIFO underflow 与 BMP timeout 的组合边界。当前 WAV 文件播放器每次等 FIFO 有整扇区空间才请求，并且该 FIFO 是 2048 样本：[tf_wav_file_player.v:1-9,309-316](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/tf_wav_file_player.v#L309)。

加载器 `next_press` 在任何状态都只置一位 `next_pending`，新请求在后续 IDLE 装载；`auto_press` 可在忙时翻转模式，自动计时则只在 IDLE 递增：[tf_bmp_file_player.v:68-75,81-97]。失败（`file_error` 或 watchdog 超限）会清读/写请求并进入 `HALT`：[tf_bmp_file_player.v:169-171]。尚未 `COMMIT` 时旧 `disp_buf_idx` 和 `image_index` 不改，因此代码路径保持旧图有效；但是当前模块无恢复 HALT 的重试入口，坏掉的目标 buffer 内容是部分帧，不能显示，也不能直接当已预载帧。转场版应保留旧图、取消 candidate-ready、让候选 buffer 整帧重载成功后重试，且绝不从半图开始擦除。

忙策略建议明确：预载期间沿用“手动 next 合并成一位待处理”语义；auto 开关立即记下新模式，但转场期间暂停倒计时/不启动第三张加载；待擦除完成并 buffer ownership 释放后再消费 next/auto。OSD 编号在擦除整帧完成前保持旧编号，最终 new 图被选为完整帧的同一帧边界再提交新编号。若要求擦除过程中标签展示新编号，则应单独定义 OSD 语义，不能直接复用现有“帧开始采样 committed metadata”的含义。

## 最小首版：单方向连续擦除规格

建议首版只实现**从左向右、逐列推进的 wipe**，不同时叠加上下擦除、多方向参数和 alpha 混合：

1. **状态与ownership**：`SHOW_OLD → PRELOAD_NEW → WAIT_NEW_WRITE_DONE → WIPE → SHOW_NEW`。只有完整 payload、SD 源正常结束、SDRAM `write_finish_toggle` 到达后才把 candidate 标为 ready 并开始擦除；wipe 期间锁住 old/new 两区，不启动第三张写入。
2. **坐标/进度**：在每个输出帧边界锁存一个 `wipe_x`（建议按 4 像素为最小步长，以保持 RGB888 pack 分组和 32-bit word 地址对齐），本帧 x `< wipe_x` 取 new buffer，其他取 old buffer；下一帧增加 4，完成边界显示整幅 new 图，再释放 old 区。长度为 160 步（640/4）；步进帧数/总时长是可见产品参数，尚无用户要求，先做常量参数，不按未知刷新率换算秒数。
3. **地址与片段**：当前每行 480 word。compact 地址公式为 `base + y*480 + floor(x/4)*3`。每行 `new[0,wipe_x)` 和 `old[wipe_x,640)` 是两个连续段，需按片段长度发读请求，并在每个段后只向像素汇流器提供有效像素。当前 frame FIFO reader 固定 256-word bursts；若请求短于 256 仍可能读满一个 burst。首版必须选择并实现：可变末 burst/精确 word-count，或能容忍并丢弃多读尾部且不把跨段数据送入解包器的 FIFO 清空/像素裁剪协议。不可直接将两个 buffer 地址交替接到现有整帧 `read_frame_index`。
4. **预取与对齐**：用至少一行的 ping-pong BRAM/片段 FIFO，提前读完下一行所需两片段，再按原 25 MHz `de` 连续输出；给 SDRAM FIFO/underflow 建立硬性余量阈值。修改 `rgb888_unpack32` 的相位/offset处理，或严格只允许 4 像素边界、每段独立清 reservoir 并跳过无效 burst 尾部。同步生成像素坐标及 HS/VS/DE latency；不能因片段重启出现黑洞、重复像素、错行或错色。
5. **错误回退/编号提交**：预载失败保持 old 图与旧编号、candidate invalid；wipe 期间出现读错误/underflow，设计明确是停在最后安全帧继续重试，还是整帧回滚 old，不允许交替读取损坏 candidate。完成判定在 pixel 帧边界发生，并经 CDC ACK 回传后才允许释放 old；OSD 编号与“完整切到 new”的显示帧同时提交。

首版关键风险是 480 行 × 每行最多两个短片段请求，加上固定 256-word bursts 造成的过读/调度开销。基线 25 MHz video 与 50 MHz SDRAM 时钟频率已由当前 IP 源码确认，但 controller 在刷新/SD 写入争用下是否能满足逐行预取 deadline，源码不能证明，需由后续实现的仿真/板上压力验证回答。动态双线/清晰度已接受暂留优化，不应因此扩大 T26 的首版验证结论。

## 后续必须扩展的模型

- 显式 buffer 状态机（FREE、WRITING、READY、DISPLAY_OLD、DISPLAY_NEW），SD 域与 pixel/mem 域使用带 ACK 的 ownership 交接；状态不是单比特 buffer index 的推断。
- 读取请求从“全帧一个起点”扩展为 `{buffer, y, x_word_start, word_count, pixel_skip, pixel_count, frame_tag}` 片段描述符；明确 compact RGB888 跨 4-pixel/3-word 分组、段尾残留和突发对齐。
- 预取 BRAM/FIFO 深度、SDRAM 最坏争用与请求延迟模型；建立逐行 deadline、underflow 判定和失败回退。当前 512-word SDRAM read FIFO 与 2048-sample WAV FIFO不能直接当成满足需求的证明。[frame_read_write.v:118-184](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/SD/frame_read_write.v#L118) [tf_wav_file_player.v:4-7](../../../player_pcm_waveform_keyfreeze/src/user_source/hdl_source/tf_wav_file_player.v#L4)
- 转场进度、自动播放/手动 next 合并、打断策略、失败回滚、OSD 编号提交的完整时序模型；先定义“正在擦除时再按 next”要排队、合并还是取消，再编码。
- 针对首图、重复图、预载失败、SD 仲裁持续有 WAV 请求、write finish 先于 SD source end、pixel 边界与 CDC 临界交叠、每行最短/最长 segment、frame FIFO 空/满进行定向验证；随后在板上确认转场期间 HDMI 连续、audio 无新增 underflow，并做明确时长的长稳记录。此项是后续验证需求，不属于本次已完成工作。

