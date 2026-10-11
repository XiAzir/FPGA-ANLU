# status_diag 页 4 PCM 变化数参考审计

日期：2026-10-08（北京时间）。范围：只读素材/源码审计；没有构建、综合网表仿真、TF/Flash写入或板卡操作。数码管读数由主代理从用户视频逐帧判读，图像/音质/未长按KEY1来自用户反馈；不是代理使用仪器直接测量。

## WAV身份与独立样本统计

- 本地canonical素材：`E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/card_media/TEST.WAV`，768044字节，SHA-256 `b29c1669416da2c492187a9db66e0e97bfcd2e6fa9812b33ed300c1c21ca80a7`。
- `wave`解析：PCM未压缩，48,000 Hz，16-bit，单声道，384,000帧/8秒，数据区768,000字节，44字节头。
- 生成脚本 `bringup/tf_wav_hdmi/card_media/generate_test_wav.py:12-20,23-35,38-61` 定义8个音符，每音符750 ms + 250 ms静音，频率262/294/330/349/392/440/494/523 Hz，峰值6000，10 ms淡入淡出。按8个自然整秒窗口统计相邻16-bit样本不等次数（每窗仅统计窗内47,999对，不跨秒边界）：

| 窗口 | 有效样本 | 样本变化数 |
|---:|---:|---:|
| 1 | 48000 | 35902 |
| 2 | 48000 | 35925 |
| 3 | 48000 | 35997 |
| 4 | 48000 | 35982 |
| 5 | 48000 | 35926 |
| 6 | 48000 | 35995 |
| 7 | 48000 | 35953 |
| 8 | 48000 | 35993 |
| 合计 | 384000 | 287673 |

参考CRC：输入PCM16 little-endian数据区的 CRC-32/ISO-HDLC 为 `89BC9512`；按HDMI bridge表达式 `{sample16,8'b0}` 展开为每样本24-bit little-endian后的 CRC 为 `3417AA22`。CRC只适合作为后续被动序列核对值，不是当前硬件测量。

## 源码链路与变化数含义

- FAT32链：`top_tf_hdmi_audio.v:218-227` 把WAV文件扇区映射接到 `tf_wav_file_player`；`tf_wav_file_player.v:284-327` 按文件位置取数据、低/高字节组成16-bit FIFO样本，并在数据区末尾循环；`top_tf_hdmi_audio.v:293-305` 接播放器样本口。
- `player_audio_probe.v:30-46` 连接 `wav_pcm_bridge` 并在默认 `tone_mode=0` 时选择WAV输出；`top_tf_hdmi_audio.v:328-335,408-413` 把同一 `audio_valid/audio_left/right` 接至HDMI音频输入。
- Bridge `wav_pcm_bridge.v:35-43,53-89` 以request/ack mailbox取样，分数累加器产生名义48 kHz `audio_valid`；两声道都等于 `{sample16,8'b0}`。每个valid有效样本都计一次，无欠载时每秒名义计数48000。
- 页 4 的实现（status monitor页索引3）在每个 `audio_valid` 上将当前24-bit HDMI输入 PCM 与前一个valid PCM比较，不相等计数加一：`player_status_monitor.v:21-22,33-36,56-63,101-107`。因此 35.9k变化/秒与此canonical素材预期吻合；变化少于48k本身是正常的量化重复/静音现象，不能视作欠采样或FIFO丢样证据。主代理从视频判读页3 `3300bb80`，其低24位 `0x00bb80=48000`；页2 `2304b000` 是非黑像素数。页4样例低24位 `0x008c5e/0x008ca5/0x008c79` 为35934/36005/35961。页4是一秒25MHz窗口，和WAV整数秒未锁相，边界处音符/静音变化率也不同，故不要求等于上表某一个完全相同的数。
- `player_status_monitor.v:1` 明示观察HDMI核输入且不验证packet有效性；`top_tf_hdmi_audio.v:408-422,425-438` 只证明数据接入加密HDMI发送核并连到TMDS PHY，不证明编码后的包、TMDS信号或接收设备最终播放声音正确。
- 独立哈希核对：当前 `player_fat32_status_diag` 与成功回退 `player_fat32_audio_probe` 的 `wav_pcm_bridge.v`、`tf_wav_file_player.v`、`player_audio_probe.v`、`audio_arc_calculate.v` SHA-256完全一致。两版top除了新增监视器/595，还存在从keepaudio继承的自动切图恢复、音源键阈值50ms改1500ms；不能称top只增加监视器。源码静态核对无法证明布线后硬件对每个样本的实际顺序。

## 结论与证据边界

页4在约35.9k而非48k变化，与TEST.WAV本身样本变化率相容，不支持“变化数本身异常导致杂音”的判断。页3计数证明每名义秒产生约48000个valid事件；页4只证明输入核PCM的相邻变化次数。相同变化次数可以由不同的数值/次序序列产生，所以它不能排除字节颠倒、错序、重复/漏样本相互抵消、短时欠载或HDMI包/接收端问题。当前素材身份只核对了工程内canonical副本；本次没有独立读取并哈希实物TF中的文件。

## 最小下一步

若需要证实播放链样本序列，准备一个后续只读观测版：从复位后第一笔WAV `audio_valid` 起收集恰好384000笔，并在同一HDMI输入 PCM 上做CRC；与展开24-bit样本的参考 `3417AA22` 比较。同步报告计数、underflow及tone_mode，默认WAV运行完整8秒。CRC匹配会强力支持样本序列正确，但仍不验证HDMI包/TMDS/显示器播放；不匹配时需再抓首个失配样本/索引。此步骤尚未实施，也不是本轮构建或上板结果。
