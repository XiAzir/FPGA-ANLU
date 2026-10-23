# C29 视频模式实板录像数码管观察

- 源文件及元信息、SHA-256：`source.json`；ffprobe 原始结果：`ffprobe.json`。
- 录像为 1280×720 H.264 + 48 kHz 双声道 AAC，时长 20.602 秒，大小 5,709,174 字节。
- ffmpeg 以 2 fps 提取 41 张全画面至 `frames_2fps/`；数码管原分辨率区域裁切并放大后保存于 `display_native/`；接触表为 `display_contact_*.jpg`，易混淆字符的放大复核图在 `review_glyphs/`。
- 重点页读数：页 3 `30180000`（N=0x01800，BCH=0）；页 5 `5F84B000`（flags=F8，返回 153600 字）；页 6 `680222C7`（memory=8022、reader_state=2、pixel_flags=C7）；页 E `EEBB8000`（flags=E、48000 samples、bad TERC=0）；页 F `F061A800`（CTS=25000、tone_bad=0）。版本页 `00C11329` 在 12.5 秒清晰可读。逐帧内容见 `observations.json`。
- 页 6 的 pixel_flags C7 含 `underflow_seen=1`、`raw_nonzero_seen=1`、`gated_nonzero_seen=1`，均为粘滞历史标志；该帧不能定位历史事件发生时刻。页 A 音频欠载为 0。
- 字形复核更正：页 5 `5F84B000`、页 7 `79DC4000`、页 8 `87F2F000`、页 E `EEBB8000`、页 1 `2BD44000`；原帧、时间与更正依据记于 `observations.json` 的 `corrections`。
- 前段、中段、后段检查画面都只拍到开发板和数码管，未拍到 HDMI 显示器，屏幕内容变化没有可核对画面。ffprobe 显示有音轨；本次未听取音频，声音表现留空。

