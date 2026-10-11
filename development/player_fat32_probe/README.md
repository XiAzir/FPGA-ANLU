# FAT32 LED probe

2026-10-08，隔离自 `player_fat32_debug`。屏幕叠字诊断版已获用户反馈：D3/D2/D1/D0 全亮但显示器无信号；固定供电和 HDMI 连接，回载 data_d1 后画面、声音全部正常，BitWriter 日志确认诊断位流下载成功。

本版用于定位，尚不是修复完成版。保留文件层、被动 monitor 和原 HDMI/SDRAM/PLL/引脚/约束，移除 overlay 及其视频域诊断总线；RGB 直接送入原转换器。诊断信号先声明再连接，消除原诊断顶层隐式向量声明的 TD critical warnings；不能据此认定它是无信号的根因。

位流目标：`build/manual/AC201_player_fat32_probe.bit`。完整构建并检查时序通过后才可 PROGRAM_SRAM 下载；Flash 和 TF 文件不修改。

## 四灯定义（与旧版不同）

| 灯 | 亮表示 |
| --- | --- |
| D3 | FAT32 挂载完成且无挂载错误 |
| D2 | 最近收到的完整源图像 RGB 加和匹配卡上四张原图之一 |
| D1 | 首两个逻辑 WAV 字节为 `RI`（0x52, 0x49） |
| D0 | WAV 音频 FIFO 已预装，且没有 WAV/mapper/音频欠载错误 |

D2 只监视 BMP 输出、帧缓存入口。匹配为32位求和检查，不能当作逐点无碰撞证明，也不证明 SDRAM 读出或 HDMI 正确；完整一帧之前不亮，加载下一帧时显示最近一次完整帧的结果。此定义仅用于 TF 文件未改的当前卡，换素材后必须重新计算预期值。

预期 RGB 和：00_apple `FB167260`，01_berry `C3EBCE2E`，02_melon `0B94A9DB`，03_a `98DF6A9E`。D1 只检查 WAV 首两个字节，不能证明全部头部格式或样本正确。灯状态来自 SD 域稳定寄存器；音频欠载标志跨域来自原 bridge。

## 使用与边界

保持已验证的供电、TF、HDMI 接线，等待 BitWriter 下载明确完成，等约10秒记录 D3/D2/D1/D0、画面和声音；KEY0 切下一张再记录。KEY0/KEY1 播放功能保持原文件播放器行为。无信号或异常时可回载 `E:/VSCODE-project/FPGA-ANLU/development/player_480p/build/manual/AC201_tf_hdmi_data_d1.bit`。

构建采用 `scripts/build_candidate.ps1` 的 synthesis→physical→按报告决定是否 hold→bitstream。不运行沿用副本的 save_candidate.py；本版尚未实物验证，不作为成功检查点。原诊断位流与稳定位流保留不改。

## 构建结果

位流629624字节，SHA256 79E819D1F79EE3100406B1C30A730FF39F568F2C3B0C5027B404A6C25E59FF19。原约束Routed SWNS0.306ns/STNS0、HWNS0.031ns/HTNS0、coverage99.99%；首次route HWNS-0.020ns/HTNS-0.044ns，原约束fix_hold后清零，首次DB/报告保存在build/attempt_hold_violation。Monitor/WAV回归通过，当前未上板。详见build/manual/AC201_player_fat32_probe.info.json。


## 2026-10-08 用户反馈

用户确认图像、KEY0点按切图、KEY1自动切图均正常；D3/D2/D1/D0全亮，但无声音。本版显示/按键按用户反馈通过，音频未通过。原D0不能证明bridge.started或audio_valid：首次握手卡住时underflow仍为0。正在隔离player_fat32_audio_probe加入PCM消费/变化/ACR观测及KEY1选择内部音阶，不改变本版位流。

