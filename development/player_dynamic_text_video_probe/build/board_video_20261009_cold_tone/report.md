# 冷启动无 HDMI 信号视频复读

## 输入与方法

- 视频：`E:\QQ CACHE\LiaoTianJiLu\Tencent Files\1791081637\nt_qq\nt_data\Video\2026-10\Ori\3c9f7f88035a4f6e280bd5f928e3c91c.mp4`
- SHA-256：`459A8AE89C0FB0506172DCA3E588E711DFBD33C7CC70916A33F36BEFA14DDD4C`
- ffprobe：H.264 1280×720，约 30 fps，16.868256 s；另有 AAC、48 kHz、双声道轨道。仅检查音轨元信息，没有试听。
- 抽取按原始横向画面；以当前 `development/player_dynamic_text_video_probe` 的 `player_status_monitor.v`、`status_hex595.v` 和 `hdmi_packet_monitor.v` 解码。表格先列逐页完整八字符，再解释字段。字符 B 按小写 b 形识别：顶横未亮；它易被看成 6，保留原帧供复核。
- 位流 SHA-256：`download/dynamic_text_video_probe.bit` = `1EFEB04BD50035789E4EBD1430B3CB8736B0F48D93DAF24FD4013AB8130F30DF`。

## 逐页完整读数

视频从运行中的页 0 开始，页间隔约 2 秒，依次覆盖页 0、1、2、3、4、5、6、7、8。页内监视器数据会更新，因此页 1 和页 5 额外复读了页内变化。

| 时刻 | 完整八字符 | 页与 RTL 字段 | 解码 |
|---|---|---|---|
| 00:00.20 | `1DA80000` | 页 0：前缀 1、启动状态、文件状态/错误码 | 启动 nibble `D`：sys PLL=1、video PLL=1、rst_all=0、card_init_done=1。文件 flags=`A8`：fs_ready=1、display_valid=1、wav_primed=1；fs/BMP/WAV/map 错误位均为 0；FS 与 WAV mapper 错误码均 0。 |
| 00:02.20 | `3900BB80` | 页 1：前缀 3、`{tone_mode,underflow,hdmi_locked,frame_seen}`、24 位 audio_valid 计数 | 状态 nibble `9`：tone_mode=1、underflow=0、hdmi_video_locked=0、frame_seen=1；计数 `00BB80` = 48000。 |
| 00:02.70 | `3900BB80` | 页 1，同上 | 保持 48000。首两计数字形为 B（小写 b 形），不是 6；与页 7 的 B 首字符形状对照。 |
| 00:03.20 | `3900BB80` | 页 1，同上 | 保持 48000。 |
| 00:03.70 | `3900BB80` | 页 1，同上 | 保持 48000。 |
| 00:04.20 | `69000000` | 页 2：前缀 6、packet_samples[23:0] | packet sample 数为 0，flags=`9`。 |
| 00:06.20 | `79000000` | 页 3：前缀 7、packet_count[23:0] | packet 数为 0，flags=`9`。 |
| 00:08.20 | `89000000` | 页 4：前缀 8、bad_bch[23:0] | BCH 错误计数为 0，flags=`9`。 |
| 00:10.20 | `99003232` | 页 5：前缀 9、bad_terc[23:0] | TERC 错误计数 `003232`，flags=`9`。 |
| 00:11.20 | `9900368F` | 页 5，同上 | TERC 错误计数更新为 `00368F`，flags=`9`。 |
| 00:12.20 | `A9000000` | 页 6：前缀 A、tone_bad[23:0] | tone 错误计数为 0，flags=`9`。 |
| 00:14.20 | `B9000000` | 页 7：前缀 B、CTS[19:0] | CTS=`00000`，flags=`9`。首字符 B 的顶横熄灭，避免与 6 混淆。 |
| 00:16.20 | `C9000000` | 页 8：前缀 C、N[19:0] | N=`00000`，flags=`9`。 |

## 诊断解释

冷启动页 `1DA80000` 显示两路 PLL 均锁定、全局复位已释放、SD 卡初始化完成；文件系统已 ready、图像有效、WAV 已 primed，所有文件/map 错误位均为 0。该状态与第一段视频不同，不能把第一段“card_init_done=0”的结果套用到本次。

页 1 的 `3900BB80` 表示 tone 模式已选中，underflow 未置位，内部视频帧已到达 AXIS，但 HDMI transmitter 的 `hdmi_video_locked=0`。同一状态页计到 `0xBB80=48000` 个 `audio_valid` 样本/秒。这说明音频输入 valid 计数达到 48 kHz，不表示 HDMI 端已正确输出或设备实际发声。

页 2 的 packet samples 与页 3 的 packet count 都是 0；页 4 BCH 错误为 0；页 5 TERC 错误非零且在 1 秒窗口从 `0x3232` 增至 `0x368F`；页 6 tone_bad=0；页 7 CTS=0；页 8 N=0。所有 packet 页 flags 均为 `9`。当前 `hdmi_packet_monitor.v` 定义其位序为 `{island_seen,audio_seen,acr_seen,format_error_seen}`，所以 `9=1001` 表示观察到 data island、未观察到 audio packet、未观察到 ACR、format error 已置位。

这些都是芯片内部并行观察器和状态显示的读数，不是外部 TMDS 电气测量，单凭它们不能定位 HDMI PHY 或线缆根因。用户报告冷启动四灯亮、长按 KEY1 后 D3 闪烁，作为独立现场反馈保留；本报告不从数码管帧重建 LED 电平。

## 证据文件

- `ffprobe.json`、`contact_1fps.png`：元信息与逐秒页序总览。
- `source_00p20.png`、`source_02p20.png` … `source_16p20.png`：每页代表时刻原帧；对应 `crop_XXp20.png` 为数码管放大图。
- 页 1 计数复核：`crop_02p70.png`、`crop_03p20.png`、`crop_03p70.png`。
- 页 5 计数复核：`crop_10p20.png`、`crop_11p20.png`。
- `summary.json`：机器可读哈希、元数据、逐页读数与解释。
