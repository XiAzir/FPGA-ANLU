# VIDEO.MJP + TEST.WAV 最小集成方案

日期：2026-10-21（北京时间）  
状态：生产源码静态核查与方案草拟；未改 RTL，未跑整机仿真/综合/时序/板测。

## 目标和基线约束

以 `development/player_spectrum_ctrl18` 为生产基线，保留 HDMI/SD/SDRAM 现有 PLL、SDC、PHY、图片播放、PCM 音频、FFT、OSD、亮度/对比度调节和诊断功能。已知基线为 6972 Slice、45 BRAM9K、9 DSP；目前总资源不含 JPEG 核和视频像素重排缓冲，须对集成候选重新综合。SDRAM 为现有 framebuffer 的唯一图像存储路径，本方案不声称已有板上 SDRAM/视频验证。

输入素材基准为 20 秒、640×480、15 fps、baseline JPEG 4:2:0 Q95、48 kHz mono PCM16。300 帧每帧对应 3200 个音频样本，即 6400 bytes；当前实验统计平均视频约 4.610 Mbps，合并原声约 5.378 Mbps，最大 JPEG 帧 43231 bytes。PC 离线生成播放文件获准，可在 SD 卡准备固定命名文件和索引。

## 生产接口与所有权

| 所有者/模块 | 当前接口和职责 | 新视频模式需要的合同 |
| --- | --- | --- |
| `fat32_catalog` | 在 SD 时钟域挂载 FAT32 root；扫描目录并登记最多 4 个 BMP 与一个 `TEST.WAV`。当前名字匹配见 [fat32_catalog.v](../../player_spectrum_ctrl18/src/user_source/hdl_source/fat32_catalog.v:14)、[目录项识别](../../player_spectrum_ctrl18/src/user_source/hdl_source/fat32_catalog.v:178)。 | 增加一个 VIDEO.MJP 根目录项的 cluster/size/status。保留 BMP 表与 TEST.WAV 字段；非法项、缺失项与文件错误继续进入现有诊断路径。 |
| `fat32_dual_file_sector` | 一个 SD SPI 扇区引擎管理 BMP 与 WAV 两个独立 FAT 链游标，在请求间轮询；端口见 [fat32_dual_file_sector.v](../../player_spectrum_ctrl18/src/user_source/hdl_source/fat32_dual_file_sector.v:5)。 | BMP 客户端信号在照片模式来自 `tf_bmp_file_player`，视频模式改由视频控制器读取 VIDEO.MJP；WAV 客户端仍读取 TEST.WAV。模式只允许在无在途 sector、已停下两个客户端后切换，避免文件上下文混叠。 |
| `tf_bmp_file_player` | SD 时钟域读取 BMP、管理手动下一张/自动模式，向帧缓存发出一条顺序 RGB888 流；端口见 [tf_bmp_file_player.v](../../player_spectrum_ctrl18/src/user_source/hdl_source/tf_bmp_file_player.v:3)。 | 保留实例及其逻辑。新增顶层数据选择/模式所有者，将原 BMP client 请求与 VIDEO.MJP 客户请求复用现有 BMP mapper 端口；只在 mode mux 已停读后改变请求源。 |
| `frame_buffer_rgb888` | SD 时钟域接 RGB888 顺序写口、视频时钟域读口；两个帧索引 0/1，RGB888 四像素打包成三个 32-bit SDRAM word，写入地址由 `frame_fifo_write` 每个 word 产生且支持既有图片行翻转，见 [frame_buffer_rgb888.v](../../player_spectrum_ctrl18/src/user_source/hdl_source/frame_buffer_rgb888.v:4)。两帧占 460800 个 32-bit word，SDRAM 后端地址空间为 2^21 word（8 MiB）。 | JPEG 写入 inactive buffer；保留 RGB888 pack/unpack、帧索引和显示读口，只让底层 writer 锁存寻址模式并在 VIDEO 下按 block-word index 生成地址。新增模式信号经 `frame_buffer_rgb888`、`frame_read_write` 传入 `frame_fifo_write`，整帧成功后才发 commit/finish toggle。 |
| `jpeg_core` 与视频控制器 | `jpeg_core` 输入为 32-bit 数据、byte strobe、last 与 valid/accept 握手，输出含宽高、像素坐标、RGB、valid/accept、idle，见 [jpeg_core.v](../../video19_work/vendor/core_jpeg/src_v/jpeg_core.v:42)。 | 解码放在 SD/card 时钟域，避免另开时钟；适配器从视频文件按 JPEG byte length 打包 32-bit 输入，尊重 `inport_accept_o`，末字节 strobe/last 精确匹配长度。像素写桥尊重 `outport_valid_o && outport_accept_i`。 |
| PCM 与 HDMI 音频 | `tf_wav_file_player` 在 SD/card 时钟域解析 RIFF/WAV、组装 16-bit mono 样本并放入现有 FIFO；`wav_pcm_bridge` 在视频时钟域按 48 kHz 消费样本，`player_audio_probe` 包含该 bridge 和 HDMI tone/ACR；见 [tf_wav_file_player.v](../../player_spectrum_ctrl18/src/user_source/hdl_source/tf_wav_file_player.v:3)、[player_audio_probe.v](../../player_spectrum_ctrl18/src/user_source/hdl_source/player_audio_probe.v:1)。 | VIDEO.MJP 仅装 JPEG 帧索引与图像数据；原声保留为 `TEST.WAV`，既有 WAV 客户/FIFO/48 kHz bridge 继续复用。新增一个 pixel-clock `play_start` 门控：WAV prime 已完成且首帧已解码到 inactive framebuffer 后，在下一显示帧边界同时启动视频帧节拍与音频消费。 |
| `player_osd_state` 与调整/显示逻辑 | 在视频帧边界采样已提交 buffer、图片编号、有效状态；控制双缓冲显示和擦拭切换。后级 OSD、RGB 调节、波形、FFT 与 HDMI 使用现有 RGB/PCM 流，顶层连接见 [top_tf_hdmi_audio.v](../../player_spectrum_ctrl18/src/user_source/hdl_source/top_tf_hdmi_audio.v:295)、[显示调节与音频连接](../../player_spectrum_ctrl18/src/user_source/hdl_source/top_tf_hdmi_audio.v:389)。 | 增加 source mode 状态字段；视频帧提交仍只在读帧边界更新 buffer。视频编号/有效状态进现有 OSD mailbox，不改 pixel-clock HDMI 输出节拍。 |

## JPEG 坐标与帧写入合同

`core_jpeg` README 将 RGB 输出定义为8×8 block内row-major；生产核显式输出`pixel_x/y`，输出握手时推进块内像素索引，见 [jpeg_output.v](../vendor/core_jpeg/src_v/jpeg_output.v:73) 与 [像素坐标赋值](../vendor/core_jpeg/src_v/jpeg_output.v:281)。本素材是4:2:0，`jpeg_mcu_id`为每个16×16 MCU按左上、右上、左下、右下顺序安排四个Y块坐标，见 [type次序](../vendor/core_jpeg/src_v/jpeg_mcu_id.v:94) 与 [block坐标](../vendor/core_jpeg/src_v/jpeg_mcu_id.v:160)。这确认了decoder输出是block顺序，不能直接按word计数作线性写入。

### 首选：顺序数据流与word地址重映射

现有 [frame_fifo_write.v](../../player_spectrum_ctrl18/src/user_source/hdl_source/SD/frame_fifo_write.v:46) 已对FIFO顺序数据逐beat产生 `App_wr_addr`，并为图片垂直翻转在行末改变地址（见 [行地址推进](../../player_spectrum_ctrl18/src/user_source/hdl_source/SD/frame_fifo_write.v:145)）；中间的 [frame_read_write.v](../../player_spectrum_ctrl18/src/user_source/hdl_source/SD/frame_read_write.v:148) 实例化该writer；[sdram.v](../../player_spectrum_ctrl18/src/user_source/hdl_source/SD/sdram.v:56) 把 `App_wr_en` 和 `App_wr_addr` 直接连入 `sdr_as_ram`。视频模式可保留顺序RGB888数据与frame FIFO，只将底层地址按JPEG隐含MCU/block顺序映射；照片模式沿用原垂直翻转。

`rgb888_pack32`每4个相邻像素生成3个32-bit word。一个8×8 Y block正好由16个4像素组构成，每block 48 word；一个4:2:0 MCU的4个Y block共192 word。640×480含40×30个MCU，共4800 block和230400 word，恰为1800个128-word burst。按逐帧word序号 `n` 计算映射：

```text
mcu_y        = n / 7680
within_row   = n % 7680
mcu_x        = within_row / 192
block_type   = (within_row % 192) / 48       // 0 TL, 1 TR, 2 BL, 3 BR
within_block = n % 48
block_y      = within_block / 6
group4       = mcu_x * 4 + (block_type[0] * 2) + ((within_block % 6) / 3)
pixel_y      = mcu_y * 16 + (block_type[1] * 8) + block_y
word_lane    = within_block % 3
word_addr    = inactive_frame_base + pixel_y * 480 + group4 * 3 + word_lane
```

`frame_fifo_write` 在每个 `App_wr_en` 被内存端接受后推进word序号。帧请求开始时在 `mem_clk` 锁存寻址模式和buffer base，保持到 `write_finish`；照片模式维持既有地址与垂直翻转。JPEG decoder的像素坐标被动检查：只允许640×480，计数越界/重复/缺失；完整JPEG帧和230400个word全部写完后才发commit。损坏帧保留当前显示buffer。基线余量19 BRAM9K、20 DSP供JPEG核与地址算术使用；公开Xilinx资源图5791 LUT/3469 FF/5 BRAM/31 DSP不代表EG4资源结论。`sdr_as_ram`实现受保护，接口每beat接收地址，但其内部任意block跳址和持续吞吐尚需EG4仿真/综合。既有图片写入每640个word有行地址跳转；JPEG会更频繁地跳址，须检查写FIFO回压、显示读仲裁和最坏帧完成时间。若此候选失败，16×640 RGB888/565 tile或SDRAM scratch tile再单独评估；前者约需27/18个BRAM9K。

寻址合同：

1. JPEG输入侧遵守 `inport_accept_o`；像素侧仅在 `outport_valid_o && outport_accept_i` 接收，并被动核对像素坐标。
2. `write_req`开始前通过CDC稳定握手发布PHOTO/VIDEO模式与inactive buffer；mem域锁存后整帧保持，不允许中途更换。
3. VIDEO逐帧word序号对应上述地址，FIFO payload顺序不改变；每个8×8块及128-word burst边界都要有地址断言。
4. 帧错误不提交display buffer；照片模式地址映射和回归保持原合同。

## VIDEO.MJP / TEST.WAV 文件布局与请求调度

采用两个普通 FAT32 根目录文件，复用现有两个文件客户：`VIDEO.MJP` 走 BMP client，`TEST.WAV` 走 WAV client。这样保留 RIFF 解析、PCM FIFO、FFT 输入和独立音频诊断；模式切换只改变 BMP client 请求源。建议 VIDEO.MJP 用自定义、有版本号的索引头，而非通用容器解析：

| 内容 | 建议字段 |
| --- | --- |
| 文件头 | magic=`MJP1`、version、width=640、height=480、fps_num=15、fps_den=1、frame_count、index_offset、index_entry_bytes、声明文件长度、header CRC/校验。 |
| 帧索引 | 每帧一条 `{jpeg_offset:uint32, jpeg_length:uint32}`；offset 为文件 byte offset，条目按帧号递增。 |
| 帧数据 | 每帧 JPEG baseline bitstream；无需固定最大帧槽。PC 工具可按 512-byte 扇区补齐 payload，索引 offset 指向真实 JPEG 起点。 |
| 配套音频 | `TEST.WAV` 为普通 RIFF PCM16 mono 48 kHz；WAV data 样本数应等于 `frame_count * 3200`。 |

视频读取端按帧号取索引项，计算 JPEG 首末 sector，按 mapper 请求 sector 字节；最后 sector 只向 JPEG 输入有效字节，依据 jpeg_length 生成 final `strb/last`。同一 JPEG 的多个 sector 线性预取，不能在下一个帧索引读完成之前覆盖当前 decoder FIFO。WAV mapper 与视频 mapper共用 SD SPI 扇区引擎，现有 `AUDIO_BURST_MAX=2` 会偏向 WAV；待测期间必须观测两路最长等待、WAV FIFO低水位、视频 JPEG buffer满/空以及 SD 实测字节率。平均合并码率约 0.672 MB/s；15 fps平均每帧 JPEG约38.4 KB，另有PCM 6.4 KB/帧。预算看起来可行，但尚无板卡读卡带宽或端到端播放证据。

帧调度按 pixel-clock 的既有 VS/帧请求边界推进；首帧完成后在下一个边界提交/启动。之后每 1/15 秒请求下一帧；下一帧未及时完成时保持当前已显示帧，增加 late/underflow 诊断计数，恢复后在合法帧边界提交。音频以既有48 kHz节拍为唯一采样时基，不能按 JPEG 解码速度推进；文件样本数和视频帧数由 PC 生成器核验。v1 建议一次播放一对 VIDEO.MJP/TEST.WAV，到 EOF 同步停止并报结束；连续循环需在两个文件各自实现 rewind 与重新 prime 的同步合同，作为后续扩展单独验证。

## 模式、按键、诊断兼容

当前按键和动作在 [player_adjust_control.v](../../player_spectrum_ctrl18/src/user_source/hdl_source/player_adjust_control.v:152)：播放模式下短按 key1 下一图片、短按 key2 切自动，长按 key1 在亮度/对比度模式间切换，长按 key2 切 tone；短双键手势冻结/恢复 waveform，长双键恢复 PLAY 与默认调节参数。没有独立来源选择输入。

建议新增 `source_mode`（PHOTO/VIDEO）归 `player_adjust_control` 管理：长双键手势切换 PHOTO/VIDEO，同时把调整模式重置到 PLAY、亮度/对比度恢复默认；短双键 waveform 手势、key1/key2短按、单键长按保持原动作。PHOTO 中 key1/key2行为保持现有图片下一张/自动；VIDEO 中 key1短按重播当前唯一 VIDEO.MJP，key2短按选择单次播放/EOF停止标志（v1不做循环），key2长按仍切 tone 诊断源。OSD 标签显示 source 类型、帧编号与播放/结束/故障状态；既有亮度/对比度、波形与动态诊断覆盖层继续作用于最终 RGB。

进入 VIDEO：置 mode-switch pending，在当前 sector 请求/帧写完成或超时后停止 BMP loader，复位/初始化 video decoder 文件游标；等待 WAV `primed`、首帧完成和帧边界后启动。退出 VIDEO：在下一个帧边界停止视频发新帧、停止 audio sample consumption，清掉视频文件请求和当前 frame staging；待 mapper client 空闲后将 BMP client ownership 交回图片 loader。保留 WAV 内容/FIFO 与播放器行为，切换不触发全局复位。

视频错误位只增加到既有 `player_debug_monitor`/状态显示：header/index错误、FAT读错误、JPEG unsupported/truncated、尺寸错误、像素坐标错误、frame late、PCM underflow/EOF。PCM下溢行为沿用既有 bridge（HDMI audio-valid/underflow），同时记录sticky fault；JPEG图像解码完成信号与audio/FFT接收诊断分别保留。

## 时钟、CDC 与保留项

保持 top 中的 `sd_card_clk`、`ext_mem_clk`、`ext_mem_clk_sft`、`video_clk`、`hdmi_5x_clk` PLL 输出连接和 [timing.sdc](../../player_spectrum_ctrl18/src/user_source/constraints_source/timing.sdc:2) 时钟定义。JPEG核和数据写入桥运行在 `sd_card_clk`；framebuffer写入仍在SD时钟域，显示读取仍在`video_clk`，外部SDRAM仍由`ext_mem_clk`/shift clock驱动。寻址模式和buffer base作为稳定bundled data通过现有write request/ack周期跨到mem域，并在每帧固定；不要逐beat跨域传地址。`play_start`、`source_mode`、帧提交采用现有toggle/两级同步方式；PCM仍通过现有`wav_pcm_bridge`跨SD与pixel clock。保持PHY、IO和SDC原约束。

## 最小可审查实施顺序

1. 独立 JPEG 解码夹具：使用现有 `video19_work` 参考核和已生成四帧 fixture，逐像素比较坐标、RGB误差、输入byte边界、backpressure/idle；添加针对4:2:0的16×16 MCU block ordering coverage。当前已静态核对 block坐标次序，fixture全帧硬件比较仍待开展。
2. 帧地址映射单元模型：用block坐标生成RGB888样本，完整通过现有pack器/写FIFO模型；按帧word序号检查230400个地址唯一、无越界、与640×480 golden RGB framebuffer逐word一致；另检查每128 word的burst边界和mem_clk/write_clk握手。
3. FAT32 单帧集成：PC生成一个 VIDEO.MJP + TEST.WAV；BMP client mux独占检查，完成一次 JPEG 到 inactive framebuffer，帧边界 commit，照片回归仍走原支路。
4. 音视频联调：等 WAV prime/首帧 ready，在同一 pixel-clock VS边界启动；检查长时间帧间隔与48 kHz PCM样本序号，EOF/underflow与每帧 late诊断。
5. 最后做视频键控/OSD集成、完整生产源快照、TD综合/布局布线/SDC报告与板卡验证。任何阶段都区分静态、仿真、综合、时序、下载、实物证据。

## 尚未验证与风险

- `core_jpeg` 的公开参考资源图为 Xilinx 型号；EG4S20的 Slice/BRAM9K/DSP 综合数据尚未取得。首选地址映射避免大像素tile，但核资源与频繁SDRAM地址跳转仍需EG4模型、综合和吞吐验证。
- 没有真实SDRAM写读端到端视频验证，也没有 SD SPI 持续速率、视频帧deadline、A/V相位或连续20秒板测证据。
- 现有SDRAM控制器读写时序、framebuffer双缓冲的板级显示、PHY/HDMI时序须沿用 baseline，不推断其在新增占用下必然成立。
- 当前JPEG核不支持 restart markers 与4:2:2；PC生成器应固定输出受支持子集并检查 frame dimensions/length。
- `fat32_catalog` 当前 root scan 上限由 `MAX_ROOT_CLUSTERS=256` 限制；VIDEO.MJP需位于可扫描根目录，v1不引入子目录或完整通用容器解析。
- 方案说明不代表已实现功能。改动生产前需复制/创建独立候选，不能覆盖 `player_spectrum_ctrl18` 冻结基线。
