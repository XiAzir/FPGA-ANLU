# C28 两种内容模式稳定黑屏：存储读链路专项

日期：2026-10-23。范围：只读核查 C28 `player_video28_hdmi_observe` 的 frame buffer、SDRAM reader、RGB 编解码、模式选择和像素出口；未改生产源码、位流或构建脚本，未运行 TD/ModelSim/整机任务。

## 结论

目前没有从源码和已给实板页值中证明 SDRAM/reader 的确定根因。C28 与板测 C22 `player_video22_audio_diag` 的 frame-buffer/reader/codec/SDRAM 文件逐项 SHA-256 完全相同；控制器源码也未见 C28 特有的读链回归。C28 的离线 `photo640x480` loader/scaler 测试通过且与 C27 CRC 一致，但不覆盖物理 SDRAM 与整机 frame-buffer。

最值得先验证的共同黑屏支路是 HDMI 前的 `osd_frame_valid` 像素门控：`top_tf_hdmi_audio.v` 将它连接到 `player_video_source_probe.bmp_valid`，而 `player_video_source_probe.v` 在无效时把 RGB 固定为 `24'h000000`；动态文本、调整 OSD、频谱随后叠加，因此“内容全黑、UI/频谱仍工作”与该门控吻合。`osd_frame_valid` 来自 `player_osd_state.frame_pixel[8]`，不是诊断页上直接显示的 `display_valid`。相应页值证明存储/loader 标志有效，却无法证明此像素门控已打开，也无法证明 reader FIFO 收到 SDRAM 数据。

这个门控目前属于待验证假设：`player_osd_state` 在有效源的帧边界取得 mailbox 数据后会置 `have_frame/frame_valid`，预期后续视频帧应打开门控。若已跨过多个有效帧边界仍黑，需确认是否 `osd_frame_valid` 仍低；若它为高，再追 SDRAM `Sdr_rd_en/Sdr_rd_dout` 到 `read_fifo_empty` 和解码 RGB。

## 源码核对

C28 与 C22 对下列文件 SHA-256 相同：

- `frame_buffer_rgb888.v` `DF605F5245CF23D2DA0DFC6F437A4819C3C5BECB9FCC90A794D1AB4D0A725D89`
- `rgb888_word_codec.v` `414A74A76A828B45F9BAA2F0C56F5F80D5C6311B21001E309246D2F60A333552`
- `rgb565_word_codec.v` `971AB7800DB69C06C078160C010778EF4B208620E005E150301E3A4B857B5021`
- `SD/frame_read_write.v` `AE65501F4D915F297674265659C24FEF88EA37CE3E2CC8C362E5B0BDAC697B1C`
- `SD/frame_fifo_read.v` `9413D48C5A44EFDBED0A038679B848B5AA7BC7D3769763515E5C8021E7B96F40`
- `SD/frame_fifo_write.v` `265508397E01DED802DF9046D8E08EAD8F6404091FCD989A74D1C3E410FACB92`
- `SD/sdram.v` `2D985C2477384E677C25714241E1A50206DEF8916AA03189A5B313B2D22DFC99`
- `IP/sdram.v` `1487E8583BBF52FE6D079A2854C10EBFF2E569A3872A9088C1C9717BA14D17FE`

端口链路是：`video_timing_data.de` 经 `video_delay` 的定时延迟产生 `video_read_en`；frame buffer 根据 `read_jpeg420` 在 RGB888 与 RGB565 unpacker 间选择；reader 从 SDRAM 按帧长度突发读入 `rfifo_32_32_512`；像素由 `video_delay` 注册后进入 probe。photo/video 读格式由 pixel-clock 的 `video_mode` 选择，写格式由 SD-clock 同步后的 `video_mode_sd` 选择，模式值经两级同步并在写事务中锁存。现有源码检查未找到确定的读请求/ACK、复位/GSR/CDC 或物理 DQ 地址映射差异。

C28 实板观测（由父任务提供）：photo `page2=2B910000`、`page5=5077E7F2`、`page6=68003000`；video `page2=2BD44000`、`page5=50000003`、`page6=68023000`；两种模式多帧黑屏。读 FIFO empty 在观测时点为 1，属于瞬时值，尚不足以证明 FIFO 永久为空；现有页也没有记录 `osd_frame_valid`、reader 连续请求、SDRAM 返回有效数据或 unpacker 有效 RGB。

C11206 的既有 ModelSim 集成报告为 `SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS`，采用应用接口存储模型且明确未验证物理 SDRAM、板级模式切换和硬件故障复现。因此它可以支持协议功能基线，无法排除 C28/C22 实板的物理读时序差异。

## 最小下一步

下一次只增加或观察四个已有链路节点的一帧摘要：`osd_frame_valid`、`video_read_req_osd/read_req_ack`、`Sdr_rd_en` 计数、非零 `read_pixel_rgb` 计数。若 valid 低，沿 `player_osd_state` mailbox/frame-edge；若 valid 高而 SDRAM 返回计数为零，沿 reader/App read/SDRAM 返回时序；若返回非零而 RGB 为零，再针对 FIFO 读延迟与 unpacker 做小型 Icarus 单元负控。避免仅凭 `display_valid=1` 或 `read_fifo_empty=1` 推断整个数据链状态。
