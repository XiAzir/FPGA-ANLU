# 新数码管视频复读：无 HDMI 信号

## 输入与方法

- 视频：`E:\QQ CACHE\LiaoTianJiLu\Tencent Files\1791081637\nt_qq\nt_data\Video\2026-10\Ori\614ca6d63c9bf6ac23731e3645134634.mp4`
- SHA-256：`78F5D8C603C0F1DFAD996CC1A9C88A99513B71F7E965E725A49514DBCD74055F`
- ffprobe：H.264 1280×720，30 fps，18.668044 s；另有 AAC-LC、48 kHz、双声道轨道。此处只检查了音轨元信息，没有听取或判断音频内容。
- 原帧方向为横向，数码管在原始画面里正向，无旋转元数据；裁图按这一方向截取。显示字符按工程当前 `status_hex595.v` 的 active-low 解码以及低位到扫描位的顺序对照，不套用旧版本映射。
- 候选位流 `download/dynamic_text_video_probe.bit` SHA-256：`1EFEB04BD50035789E4EBD1430B3CB8736B0F48D93DAF24FD4013AB8130F30DF`。

## 逐页读数

视频开头已处于页 3，约每 2 秒翻一页；它连续显示页 3、4、5、6、7、8、0、1、2，再回到页 3。视频未录到启动自检图样 `01234567`/`88888888`，但录到了完整的循环状态页。以下是从每页稳定段抽取的完整八字符读数：

| 视频时刻 | 八字符 | 当前 RTL 含义 | 读数解释与边界 |
|---|---|---|---|
| 00:00.20 | `79000000` | 页 3：`7` + `packet_flags` + `packet_count[23:0]` | flags=`9`，包计数=`000000`。 |
| 00:02.20 | `89000000` | 页 4：`8` + flags + BCH 错误计数 | flags=`9`，BCH=`000000`。 |
| 00:04.20 | `9900423E` | 页 5：`9` + flags + TERC 错误计数 | flags=`9`，TERC=`00423E`。 |
| 00:05.35 | `990045F8` | 页 5：同上 | TERC=`0045F8`；计数在页内更新。 |
| 00:06.20 | `A9000000` | 页 6：`A` + flags + tone 错误计数 | flags=`9`，tone 错误=`000000`。`A` 的横杠形状与 4 不同，按清晰裁图判为 A。 |
| 00:08.20 | `B9000000` | 页 7：`B` + flags + CTS[19:0] | flags=`9`，CTS=`00000`。首字符的七段形状类似小写 b；其“上横未亮”的形状及有效页序支持 B，截图保留供复核。 |
| 00:10.20 | `C9000000` | 页 8：`C` + flags + N[19:0] | flags=`9`，N=`00000`。 |
| 00:12.20 | `1C000000` | 页 0：`1` + 启动状态 nibble + 文件状态/错误码 | 启动 nibble=`C`：`sys_pll_lock=1`、`video_pll_lock=1`、`rst_all=0`、`card_init_done=0`。文件状态、FS 错误码和 WAV mapper 错误码均为 0。 |
| 00:14.20 | `31000000` | 页 1：`3` + `{tone_mode,underflow,hdmi_locked,frame_seen}` + audio_valid 样本数 | 状态 nibble=`1`：tone=0、underflow=0、`hdmi_video_locked=0`、`frame_seen=1`；累计样本数=`000000`。 |
| 00:16.20 | `69000000` | 页 2：`6` + flags + packet sample 数 | flags=`9`，样本数=`000000`。 |
| 00:18.20 | `79000000` | 页 3：同 00:00.20 | 包计数仍为 0。 |

### 对用户反馈的对应

页 0 明确显示系统 PLL 与视频 PLL 均锁定，`rst_all` 已释放；因此这段视频不支持“PLL 未锁”或“全局复位仍有效”作为无信号原因。页 0 同时显示 `card_init_done=0`，且文件状态/错误码为 0，说明抽帧时 SD 初始化尚未完成。页 1 显示内部视频帧到达 AXIS（`frame_seen=1`），但 HDMI transmitter 的 `hdmi_video_locked=0`；audio_valid 计数为 0。

页 3–8 的 `packet_flags=9`。按当前 `hdmi_packet_monitor.v` 的 sticky 位定义 `{island_seen,audio_seen,acr_seen,format_error_seen}`，`9=1001`：观察到 data island、未观察到 audio packet、未观察到 ACR，并置位 format error。页 4 BCH 计数为 0；页 5 TERC 计数明显非零并在 1 秒计数窗中变化；页 6 tone 错误计数为 0；页 7 CTS 与页 8 N 均为 0。

这些是 RTL 内部并行观察器和状态显示的采样，不是对外部 TMDS 电气波形的测量，不能单独定位 PHY 或线缆根因。用户报告四个 LED 全灭是另一个现场观察；此报告未从数码管视频反推 LED 电平。视频有 AAC 音轨不代表可以确认设备实际发声。

## 证据文件

- `ffprobe.json`：视频与音轨元信息。
- `contact.png`、`display_contact_1fps.png`、`display_contact_2fps.png`：逐段总览。
- `source_00p20.png`、`source_02p20.png`、`source_04p20.png`、`source_06p20.png`、`source_08p20.png`、`source_10p20.png`、`source_12p20.png`、`source_14p20.png`、`source_16p20.png`、`source_18p20.png`：关键时刻原帧。
- 对应 `cropwide_XXp20.png`：数码管放大裁图；另有 `cropwide_04p35.png` 和 `cropwide_05p35.png` 保留页 5 两个变化计数值。
- `summary.json`：机器可读的元信息、哈希、逐页解码及限制。
