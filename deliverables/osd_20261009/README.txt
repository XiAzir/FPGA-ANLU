OSD 第一版上板测试（2026-10-09）

本包包含：firmware/osd.bit 新候选；firmware/packet_diag.bit 已验证回退版。
新候选已通过逐像素/状态模型、TD综合与布局布线、原约束setup/hold检查；尚未上板验证。
无需修改TF卡，继续使用原根目录四张BMP和TEST.WAV。不格式化，不写Flash。
解压到纯英文路径（例如 C:/fpga_test），不要在ZIP内部直接选择bit，避免中文路径打开失败。

下载：BitWriter Add 添加 firmware/osd.bit，使用现有 AL-LINK/JTAG、PROGRAM_SRAM，
等待 Downloading succeeded!。本机也有 E:/VSCODE-project/FPGA-ANLU/download/osd.bit。

预期：原图/音乐正常，左上白字黑底 IMG 1/4 MANUAL（数量按实际扫描结果显示）。
KEY0点按切图，编号应随实际显示图片更新并循环回1。
KEY1短按开/关自动轮播，状态在AUTO与MANUAL之间切换，声音保持正常。
长按KEY1约2秒切内部音阶，松开至少1.5秒后可再长按切回WAV；
沿用基线行为：长按也会触发一次轮播开关，AUTO文字可能同时改变。
继续确认音乐返回开头正常，并检查切图过程中没有杂音/花屏。
数码管继续保留原诊断页；正常首轮不必专门录数码管。

如出现异常：保留新位流和现象，保持卡/接线/音量，回载firmware/packet_diag.bit对照。
PROGRAM_SRAM掉电丢失；重新上电需再下载所选位流。

OSD文字无需从卡上读取；本次为图片序号和轮播状态，并非滚动字幕/歌词功能。
基线音频/SDRAM/IP/PLL/引脚/时序约束源码未改，但新布局仍需实板回归。
