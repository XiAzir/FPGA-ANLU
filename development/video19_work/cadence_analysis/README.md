# C04 视频帧截止相位与 Q90 reader loop

本目录记录 C04 双 buffer 调度的节拍风险分析，以及隔离的 Q90 媒体 reader 回归。没有修改产品 RTL、C04 位流、Q95 媒体、父级构建或其他代理目录。

## 结论

`player_video_schedule` 按实际 `sample_take` 接受次数累计 `sample_in_frame`；到 3200 次置 `frame_due`。JPEG 写完成、reader 发送完且 decoder idle 后，schedule 等待 deadline，再提交 `display_buffer`，进入 `WAIT_DISPLAY`。该状态直到 `display_finish_toggle` 才翻转写 buffer 并启动下一帧。OSD 在真实 `video_timing_data.read_req` 帧边沿选取新 frame，并在 `read_req_ack` 同步到达后产生 release toggle。因此下一帧解码启动会等待显示读帧握手相位。

显示时钟为 25 MHz，`HTOTAL=800`、`VTOTAL=525`，真实刷新周期 420000 pixel clocks = 16.8 ms = 59.5238 Hz。播放器 schedule 按每帧 3200 个音频样本前进；48 kHz 对应 66.6667 ms / 15 fps。缩时相位表保留比率：每样本5抽象 tick、刷新4032 tick，内容期限16000 tick。

`gcd(16000,4032)=64`，期限相位每帧递进 `16000 mod 4032=3904`（等价 −128），63 帧后重复。最大等待下一刷新为3968 tick（16.533 ms），最小可解码窗口为12032 tick（50.133 ms）。以父任务初始估值对应的 phase origin 128 计算，frame62窗口50.933 ms，frame63窗口50.400 ms；逐 JPEG 字节数线性缩放 Q95 最大帧52.48111 ms 时，分别估为51.316667/51.575 ms，均晚于窗口。此表仅是相位与线性时延模型，解码耗时不保证正比于 JPEG 字节数，且绝对初始相位由启动时序决定。

独立的 Q95 全系统 C04 AUDIO_PHASE=780 回放已实际触发 `frame_late`：日志中的 fatal 为 `phase replay missed deadline phase_samples=780 jpeg_frame=1 decoded_pixels=583424`；运行 summary 状态 FAILED。可靠进度日志显示 `VIDEO_PROGRESS ms=130 ... pixels=550656`；失败前的累计数583424意味着 frame1 已输出276224/307200像素，尚差30976像素。frame0 实际 `decode_ns=50059770`（50.059770 ms）。`%0t`原始时间字段不用于换算，本结论依据显式 ms 进度、decode_ns与失败条件。C04 位流继续保留作 fallback。

## Q90 媒体与 reader 回归

优先候选为已有 Q90 素材：640×480、300帧、15fps，原PCM16/48kHz WAV未变。源 MJPEG 为8,291,294字节、video MJP为8,521,728字节，最大 JPEG 31,115字节在 frame108；索引仍为300帧。对比 Q95 最大43231字节少约28%，平均视频码率由约4.6103降至3.3165 Mbps。按 Q95 最大帧52.48111ms线性估算，Q90最大帧约37.775ms，在最小50.133ms窗口下余12.358ms。该估算作为风险排序依据；完整 C04 Q90 phase app 由父任务审查。

观察到父级 Q90 `video_system_20261021_203750` 的 console 已报告首两个内存帧 commit：frame1 `decode_ns=41525110`、frame2 `decode_ns=40880550`，分别约41.525110/40.880550 ms。该 app 全部回归的最终结论待父任务核对。本目录的独立 reader loop 不包含 JPEG core或帧解码。

独立 ModelSim SE-64 10.1c `-novopt` reader 回归通过，使用实际 `mjp_file_reader.v`、Q90 `index.json` 和独立源 MJPEG逐帧生成参考：

- frame0…299 + wrap frame0 + reset后 frame0 共302条 frame输出；长度、索引、逐字节 CRC32 均匹配源 MJPEG。
- 16755个 sector LBA 请求逐项匹配 MJP index布局。
- card_valid随机间隙276347周期；jpeg_accept随机与18拍周期停顿累计4358周期，最大连续停顿23周期。
- 302个 empty-tail beat；注入 `file_error` 后 reader error 置位且停止请求。
- runner首轮继承了 Q95 TB 的23000-sector固定下限，Q90索引更小使其误报。该失败运行已保留；TB副本去掉固定下限，runner按完整manifest生成的LBA序列作精确比较后通过。

PASS run：`runs/q90_reader_loop_20261021_204125_745999/`；结果 SHA-256 `f8b81ed2ba9617f763a11598bb94889f27ceecc8394837c82d704528c3654011`。关键输入与跟踪哈希见 `result.json`、`source_receipt.json`、`frame_reference_manifest.json`。

## 修复方向与所有权

最小方向是先选择已有 Q90 媒体并保持 C04 RTL/位流不变；代价是 JPEG源的PSNR从45.633 dB降到43.904 dB（约−1.729 dB）。现有 RGB565量化PSNR约37.7 dB，画质变化需结合显示效果评估。父级已有 Q90 phase app 在核对中。

若必须保持 Q95，可评估三 buffer + completed-frame queue：640×480 RGB565一帧需要153600个32-bit SDRAM word，即614400 B（0.586 MiB、4.9152 Mbit）；三帧合计460800 word，仍小于21-bit word地址空间2097152。当前 `frame_buffer_rgb888`只配置buffer0/1，base2/3为unused；三 buffer需扩展映射、写/读选择、完成队列及owner状态，增加了地址MUX和控制逻辑。C04资源已接近Slice容量上限，需重新完整综合、route与时序验证。

安全所有权需同时跟踪 `WRITING`、`READY`、当前显示读帧与 `FREE` buffer；写端只领取 `FREE`，vsync边界仅把已完成 `READY` 原子升级为当前显示 buffer，不能覆盖正在读或排队待显示的buffer。`frame_fifo_read.read_req_ack`在请求接受阶段就置位，后续才开始 burst；`frame_buffer_rgb888`当前未连接 `read_finish`。三 buffer设计需证明旧帧读事务/FIFO drain完成后才能将对应buffer释放，单凭新请求 ACK不能释放新读帧所占buffer。

降低帧率也能扩大窗口：`decode_max 52.48111 ms + max refresh wait 16.533 ms`要求内容周期至少69.015 ms，即约14.49 fps或更低。当前媒体为15fps、schedule固定3200 samples/frame；改帧率会改变20秒时长或帧采样映射，范围大于更换 Q90 资产。

## 复现文件

- `phase_budget.py` 生成63周期相位表及 Q95/Q90线性延迟估算。
- `phase_budget_analysis.json/.csv` 保留逐帧估算与来源 index SHA。
- `run_q90_reader_loop.py`、`tb_q90_mjp_stream_loop.sv` 为隔离 runner与TB副本；执行只写本目录下 `runs/`。
- `tb_cadence.sv` 是实际 schedule/OSD 模块缩时微TB的探索件；编译通过，但 ModelSim 仿真未产出有效 run结果，未用于结论。以父级全系统phase失败、integer recurrence与 Q90 readerloop为准。

## 关键哈希

- Q95 phase FAIL summary：`4d5935e823efbf12e20a4f966cce13d3ffc02ce879e5f1b83dfd9b757660317a`
- phase analysis JSON：`e4d545fdc54783c9ea1fd83ede42af3ec4ba2cc96d9cd25dc370f72581056d34`
- Q90 source MJPEG：`6ce98ef963af5e151989fc26f0c3265d586cfec984d1a911a3e4040719e77e30`
- Q90 index：`fa3da3c243d75337470bcb89fdb8f7f9f46e8946365916d5767852fa98402879`
- Q90 VIDEO.MJP：`239a413b3fc9462ab362918177f3e62e7069f10559281815e7c3198457525c31`
- Q90 reader frame trace：`039e568d8d6a92c220ce195f074dbeb9d0c304d5364b2787d48c466cd1bfff3e`
- Q90 reader LBA trace：`a6e0d2ade1fae23719d21c9f318eb989c2ff64c9295084abf6540c346374dbfe`
