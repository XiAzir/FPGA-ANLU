# C29 内置音阶实板录像：数码管对照

录像：`5688152bd956eb794483d34349f0fb55.mp4`，20.869 秒，1280×720 H.264 + 48 kHz 双声道 AAC；SHA-256 和 ffprobe 结果见 `source.json`、`ffprobe.json`。整段只拍到板卡数码管，没有拍到外接显示器画面。先以 2 fps 提取全画面定位，再以 6 fps 提取数码管原分辨率裁切并放大；页6状态另以30fps复核。接触表为 `contact.jpg`、`digits_correct_0.jpg`、`digits_correct_1.jpg`，30fps页6复核表为 `review_30fps_contact.jpg`；逐帧局部图在 `digit_crops_6fps/` 和 `review_30fps/`。

人工辨读的关键页：

- 版本页：`00C11329`（4.67 s）。
- 页 3：`30180000`，N=`0x01800`，上一秒 BCH 错误数 0（7.83 s）。
- 页 5：`5E070800`，返回字数 230400，读请求/返回/非零读均出现，未见写活动或计数失配（9.83 s）。
- 页 6：同一显示窗读到 `680022C7` 与 `680023C7`，memory=`8002`，reader state 在 2/3 间变化，flags=`C7`；OSD/source 有效、raw/gated 非零均出现，sticky 欠载标志为 1（10.77–11.00 s）。
- 页 E：`EEBB8000`，flags=`E`、样本对数=`0xBB80`（48000）、TERC 错误 0（19.00 s）。
- 页 F：`F061A800`，CTS=25000、音阶错误计数 0（19.83 s）。

其他读数：页 B `B6000047`（0.00 s）；页 C `C8840873`；页 D `D4400000`；页 2 状态 `2B910000`（5.83 s）。其后单独出现快速变化的 SD CRC 显示，原帧序列见 `observations.json`。页 7/8/9 更正为 `79DC4000`、`8051D000`、`902B2000`。此前读数更正过程保存在 `observations.json` 的 `correction_history`。

这里只检查了屏幕画面，未对声音作听音结论。
