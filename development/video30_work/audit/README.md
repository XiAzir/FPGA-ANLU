# C29 探针移除边界审查（供 C30 使用）

**结论：**C30 可移除 C29 的纯观测链，保留音频源切换、有效像素门控、按键分类和四灯反馈。C29 源码、位流和交付包保持冻结。本审查只读源码及现有 gate.area，没有运行 TD、仿真或硬件操作。

## 必须保留的行为

- `player_adjust_control` 负责短按切图/自动播放、长按模式/亮度/对比度/音阶切换和组合键事件。只考虑移除其 `debug_state` 只读快照输出，保留控制器、按键同步和 mailbox/ack 路径。
- `player_audio_probe` 名称带 probe，但集成后承载 WAV/tone 音频源 mux、WAV bridge、tone 发生器、ACR 检查和四灯状态。保留用户操作触发的音阶切换及现有 LED 反馈；不要整块删实例。
- `player_video_source_probe.rgb_out` 实际实现 `bmp_valid ? bmp_rgb : 0` 的 RGB 有效门控。顶层 `key0_n_async` 固定为高，因此 probe_mode 的彩条/纯色测试请求不可达；C30 可移除该 wrapper 与无效测试分支，将有效门控直连表达。
- `debug_tone_press`、`probe_tone_toggle`、`debug_tone_mode` 名字带调试含义，分别承载实际按键事件、实际音源切换脉冲、当前音频源选择状态。建议 C30 改为功能名称，避免被后续资源清理误删。

## 可移除的观测链

按现有 [C29 gate.area](../../player_video29_media_flow/build/manual/AC201_tf_hdmi_gate.area) 层级，独立 observer 的资源为：

| 实例 | LUT | 序列寄存器 | 用途 |
|---|---:|---:|---|
| `u_packet_monitor` | 446 | 346 | TMDS 音频包/BCH/TERC/ACR 只读统计 |
| `u_pcm_crc_probe` | 125 | 149 | HDMI 核输入 PCM 首块/分块 CRC 与计数 |
| `u_memory_runtime_probe` | 115 | 113 | SDRAM 读写会话及像素门控活动 |
| `u_status_hex` | 323 | 82 | 数码管扫描与诊断页显示 |
| `u_status_pages` | 3 | 3 | 页面轮转及诊断数据选择 |

另外可删 SD 读 CRC16 观察计数及其输出链。`sd_card_cmd.v` 中的 CRC 逻辑注释写明其只观察现存 SPI 接收握手，比较结果只增加 `read_crc_bad` 计数，不影响读数据交付或 SD 状态机；gate.area 未单独报告其资源。删除时保留 SD command/read FSM 和 SPI 接收流程。

当状态页和数码管退役后，可一并删除 top 中只为诊断页服务的 PCM CRC 快照、欠载计数、读首响应等待计数、FIFO low-water 计数、状态页 CDC、SD/debug state buses 和 `frame_buffer_rgb888` 的 debug-only 输出端口。`pcm_count_snapshot` 以及 `wav_first_wait_*` / `wav_fifo_lowwater` 在本次读取范围内没有消费者，可能已由综合优化掉。`player_debug_monitor.debug_rows()` 顶层悬空，现有 gate hierarchy 无其实例条目，源码级清理预期不带来显著额外资源下降。

## 资源数据与下一步

C29 gate.area 层级表显示上述 observer 的实例开销。它不等于 C30 实际可节约值；删改后需以 C30 新综合结果核实。area 报告没有独立列出 `u_video_source_probe`，集成综合中该模块的测试选择路径可能已被常量传播/优化；RGB 门控功能仍须在 C30 顶层保留。

建议 C30 先删 HDMI packet、PCM CRC、内存 runtime observer；随后按是否还需要板载数码管诊断决定是否移除 status pages/595 和 SD CRC status。最后将 video-source wrapper 改成直连有效门控，保留 tone/WAV mux、按键语义和 LED。该顺序只适用于独立 C30 候选。

结构化逐项证据、端口列表和控制无影响依据见 [c29_probe_removal_boundary.json](c29_probe_removal_boundary.json)。C29 五次切换、三次重播的正常结果按用户反馈记作冻结背景；本审查没有复测该结果。
