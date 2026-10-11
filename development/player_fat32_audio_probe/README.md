# FAT32 audio probe

2026-10-08，从 player_fat32_probe 隔离复制。用户确认 probe 图像、KEY0手动及KEY1自动切图均正常，D3/D2/D1/D0全亮，但无声音；以上是用户现场反馈，持续运行时长未记录。

目的：用同一HDMI核心/引脚/PLL，在 WAV 与内部测试音之间切换，并观测真实 PCM 输出链。仍为诊断，不是已修复版本；不写TF、不烧Flash。

## 上板观察

位流目标：`build/manual/AC201_player_fat32_audio_probe.bit`。原约束最终时序通过及位流完成后 PROGRAM_SRAM 下载，保持既有TF/HDMI/供电。

1. 默认 WAV 模式，等10秒记录画面、声音及 D3/D2/D1/D0亮灭。
2. KEY0仍手动切图。**本诊断版KEY1改为切换WAV/内部音阶，暂不用于自动切图。**
3. 点按KEY1一次，D3应约1Hz闪烁，表示内部音阶模式；等3秒记录是否听到音阶，以及D2/D1/D0。
4. 再按KEY1返回WAV，D3恢复WAV观测定义。

## LED含义

以下均为低有效输出；“曾发生”的标志下载/复位清零后保持，不证明长期连续性。与前一probe定义不同。

| 灯 | WAV模式，亮表示 | 内部音阶模式 |
| --- | --- | --- |
| D3 | WAV样本队列曾提供非零样本 | 约1Hz闪烁表示模式 |
| D2 | bridge曾消费WAV样本 | 曾向HDMI输出audio_valid |
| D1 | WAV送入HDMI的PCM样本曾发生变化（排除只看到非零常量） | 曾向HDMI输出非零PCM |
| D0 | ACR曾有N=6144且CTS为25000 | 同左，仅在所选音阶模式统计 |

这套观测取在波形/FIFO、bridge和HDMI输入。D0不能证明显示器收到或解码音频包；D1只证明出现不同样本，不能证明完整WAV逐点正确。

前一probe的D0只有 `primed && !error && !underflow`，不能证明音频桥已启动：首请求/应答未完成时 `started=0`、`audio_valid=0`，且underflow只在started后采样时刻置位，所以可能同时“就绪、无欠载、无声音”。这是确定的观测盲区，尚未证实是实物根因。

## 修改和测试边界

只改独立副本top及注册新player_audio_probe模块，内部复用原wav_pcm_bridge、已用过的hdmi_audio_tone_pcm_scale与audio_arc_calculate；未改FAT32/BMP/WAV解析、帧缓存、SDRAM、PLL、HDMI核心、引脚或SDC。去掉KEY1自动切图输入，改为像素域消抖后切源。WAV bridge仍连续运行，tone模式绕过它向同一HDMI核心送内部PCM；ACR据当前所选audio_valid计算。

`scripts/run_audio_probe_sim.ps1`验证：primed高但sample_available低时不虚报播放；这种情况下内部音阶仍有valid/非零/正确ACR；返回WAV保持独立观测；模拟队列到HDMI输入119个样本顺序、24位打包、双声道、分数采样节拍和ACR准确。此测试不运行加密HDMI/真实SPI/SDRAM，也不证明显示器收到音频。

稳定回退仍为 `../player_480p/build/manual/AC201_tf_hdmi_data_d1.bit`。上一probe显示/按键通过而音频未通过；不能当完整成功版。

## 最终构建

629624字节，SHA256 4FC48C6678758FC1B74BD0BB9D9DA4FDD6132198BB1AEE8C294C6340EA81CF8C。原约束Routed SWNS0.262/STNS0、HWNS0.022/HTNS0ns、coverage99.99%。首次route HWNS-0.002/HTNS-0.002ns，保留attempt_hold_violation后原约束fix_hold；最终资源15981LUT/7350reg/17276LE/19BRAM9K。仿真还覆盖非零DC不误判PCM变化；详见build/audio_probe_sim/audio_probe.log。当前位流已获用户基本播放正常的上板反馈，完整元数据在同名.info.json；详细范围见下文。


## 2026-10-08 15:56:33 用户上板反馈：基本播放通过

- 默认WAV音频正常，画面正常、KEY0手动切图正常，D3/D2/D1/D0全亮。
- KEY1切内部音阶后声音正常，D3闪烁、D2/D1/D0常亮，画面正常；本版KEY1按设计不自动切图。
- 来源是用户现场反馈，持续运行时长未记录；未实测PCM逐点一致性、HDMI采样率或换文件/碎片卡场景。
- 当前top和pin.adc未接入AC201数码管的595串行驱动；照片中的字形没有播放器状态含义，可能来自先前例程锁存/未驱动状态，具体段码来源未测量。
- 该位流可以作为当前卡的FAT32图片/WAV基本播放成功检查点；旧candidate乱码、overlay无信号和LED probe静音的具体根因仍未证实，不能以此反馈反推是FIFO启动故障。
- 成功检查点：checkpoints/audio_probe_20261008_verified，封存源码/脚本/仿真已有证据/原路由DB/位流/报告；原稳定data_d1回退继续保留。
- 下一步：从成功副本恢复KEY1自动轮播，保留本版作为独立音频诊断；新位流需用户再次确认自动轮播与WAV并发。数码管驱动另行接入，不将当前字形当作错误码。
