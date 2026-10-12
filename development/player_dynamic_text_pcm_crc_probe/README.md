# PCM 音乐内容诊断候选 C11108

新隔离工程，来源 C11107。C11107 实板画面和内部音阶正常、WAV 杂音重；数码管全部包计数/校验页正常，尚未证实杂音产生位置。当前成功基线仍 `download/osd_phy_fix.bit`。本候选尚未上板，不称修复版。

## 固定数据窗口

三个观察点分别从复位后的第一个实际样本事件开始计数，各跳过 65536 个事件，再计算随后 32768 个 PCM16 样本的 CRC16。窗口为 payload 样本 65536..98303，约1.37..2.05秒。CRC-16/CCITT-FALSE，poly1021/initFFFF/no xorout，按 PCM 低字节再高字节。完成后永久冻结，直到复位；不能把尚未完成的异步滚动值当作可比结果。

1. 播放器实际写 FIFO 的 `play_push` / `{sd_data, low_byte}`。
2. 实际 FIFO `sample_take && sample_available` / `sample_data`。
3. 送入 HDMI 核的 WAV 模式 `audio_valid` / `audio_left[23:8]`。

前两处运行在SD时钟域，CRC/count完成冻结；结果总线两拍采样、ready三拍同步到pixel域，只有ready有效后比较。第三处同pixel域。早于完成切到tone会永久置abort，避免断续拼接不同窗口；完成后切tone不改CRC/计数。另在捕获窗口检查WAV左右相同、PCM24低8位均0。

三段采集按样本序号对齐，不按任意墙钟秒对齐；播放器短payload会自然循环，参考应按相同循环序列计算。本机音乐首次非零样本61477，因此原首32768方案仅覆盖静音，已在综合后封存 `build/preflight/silent_prefix_rejected`，没有路由/bit/交付。

## 数码管与 LED

原10页、自检、音频LED和按键不改。页6..C的第二位改为 `{early_tone_abort, source_done, fifo_done, hdmi_done}`，全部完成且未提前切tone时为7。页3继续表示实际输入模式/样本计数。页D为 `DFC11108`。

| 页 | 新意义 | 本机原交付天之弱预计值 |
| --- | --- | --- |
| 6 | 组样本/push CRC | 6700F485 |
| 7 | FIFO pop CRC | 7700F485 |
| 8 | HDMI核输入 CRC | 8700F485 |
| 9 | 首捕获窗口PCM格式错误 | 97000000 |
| A | 已捕获样本数32768 | A7008000 |
| B | 首个被哈希样本高字节文件位置（低24位） | B702002D |
| C | 解析得到的data_offset（低24位） | C700002C |
| D | 版本标识 | DFC11108 |

页6..C已不显示HDMI包统计。原监视器文件保留但没有实例化。本素材窗口第一高字节绝对位置131117，payload起始44；其他文件不能直接套F485。本机参考文件SHA D5244FD3935052A743379D9331EE78109C8A913241ED60DE472CB9E34A17FECF，窗口有31281个非零样本；不是本轮远控TF卡新读取哈希。

LED仍原audio_probe语义：默认D3 FIFO曾非零、D2曾take、D1核输入PCM曾变化、D0曾正确ACR；tone D3闪烁、D2有效、D1非零、D0正确ACR。锁存事件不能证明连续正确。

## 修改范围与证据边界

相对C11107：新增 `player_pcm_prefix_probe.v`；播放器仅加四个被动debug端口/assign，不改parser/FIFO状态/消费逻辑；top换被动观察器和显示载荷；status仅注释/build ID改为C11108；.al新工程路径/新增源条目及TD归一化。WAV bridge/audio_probe、FAT/SD/keys、动态字幕/图像、PHY/lane/PLL/引脚/原SDC不改。布局布线会改变。

CRC16存在碰撞。首段若不匹配，不能单独区分卡内容、FAT/扇区读取、字节组装等；三段一致只为所选短窗口的诊断证据，不证明长期音频或物理链路正确。第三段止于HDMI核输入，没有证明WAV实际包内PCM/PHY引脚；C11107包结构正常不能代替这一层内容比对。

模型/构建状态以 `build/model` 日志、`build/manual/stage_evidence` 和交付info为准；本机不连接板卡，没有代理TF写入、JTAG操作或Flash操作。

2026-10-11 17:23:48 本地验证/正式四阶段/原约束最终时序/位流/封存/压缩包校验完成，实板仍PENDING。模型和交付边界见info。位流SHA F467BA1C05D27BB762E735016AFC7CF02D404B1E724D23203F56100C879749E4，ZIP 015D3751FBCBDE004778694D1B1844B9AA883231D8B69670B52D1F3B73C8DA6A，134文件checkpoint。最终SWNS+0.633/HWNS+0.035ns/TNS0/coverage99.97%。


2026-10-11 17:52:48 实板状态更正：C11108用户反馈无信号；两视频全页 source F485/FIFO pop与核输入D2D6，三段完成。用户同条件回载osd_phy_fix图片/WAV/tone三项恢复。live info为FAIL_NO_SIGNAL_CRC_DIVERGENCE，原checkpoint/ZIP保留构建PENDING历史。C11109同步BRAM候选已交付、尚未上板，根因仍未确认。详见资料目录PCM校验FIFO分歧与无信号_20261011记录。
