# HDMI 音频包诊断候选 C11107

状态：本地模型、综合、布局布线、原约束最终时序及位流生成通过，**尚未上板**。这是新的诊断构建；其观察结果不能作为修复证据，也不能继承成功基线的实板结论。

本候选从 `development/player_dynamic_text_bit17_led_probe/src` 独立复制，目标是同时观察音频进入 HDMI 发射核前的源事件、发射核并行 TMDS 输出中的音频包，以及原输入计数快照。媒体读取、按键/选源、动态字幕、FAT/SD、PLL、时序约束、PHY wrapper 和串行器 lane 均沿用 C11106 的 RTL。相对 C11106，本候选只改 `src/user_source/hdl_source/top_tf_hdmi_audio.v` 与 `src/user_source/hdl_source/player_status_monitor.v`；`player_bit17_led_probe.v` 保留为副本中的源码备份，但不再实例化。新源码会改变资源和布局布线，不能假设与 C11106 或 `player_osd_phy_fix` 的物理路径相同。

## LED 观察含义

LED 由 `player_audio_probe` 直接驱动，输出为低有效；表中的事件位为 1 时对应 LED 点亮。WAV 模式下 D3 表示 FIFO 曾出现非零样本，D2 表示样本曾被取走，D1 表示送入 HDMI 音频输入的 PCM 曾变化，D0 表示曾观察到匹配 48 kHz 的 ACR。长按切到内部音阶后，D3 以约 0.5 秒间隔闪烁表示音阶模式，D2 表示出现 `audio_valid`，D1 表示左右 PCM 曾非零，D0 表示曾观察到匹配 ACR。D2/D1/D0 是锁存事件，不表示持续播放或 HDMI 引脚波形正确。

## 数码管页面

复位后先显示两页自检，各约 2 秒。随后 10 页按 2 秒轮转：页 1 为启动/文件状态，页 3 为音频输入计数快照；页 6 为包内音频样本数，页 7 为每秒音频包数，页 8 为 BCH 错误数，页 9 为 TERC 错误数，页 A 为内部音阶负载错误数，页 B 为最近 CTS，页 C 为最近 N，页 D 为版本标识 `DFC11107`。页 6 至 C 的 TMDS 统计由 `hdmi_packet_monitor` 在 `video_clk` 上采样三路发射核并行 TMDS 字得到。

录制时至少覆盖 **25 秒**，确保 4 秒自检后能看到完整 10 页（20 秒）并留出切页边界余量；长按切入音阶后再录一段同样时长，方便对照默认 WAV 与内部 tone。

## 测量边界

包监视器取样点在 transmitter 的并行 TMDS 输出、PHY 串行化之前。它可用于判断异常是否已经出现在发射核的并行包字上；它**不测量** `EG_LOGIC_ODDR` 的真实输出边沿、HDMI 引脚波形、板级时钟抖动、路由 skew、接收端采样或声学输出。`hdmi_packet_monitor.v` 沿用原功能模型，没有改 RTL、采样边沿或窗口参数；其计数是诊断模型读数，不等同于物理链路验收。

C11107 当前本地构建完成，最终SWNS +0.225ns、HWNS +0.027ns、TNS0、coverage99.97%；尚无上板结果。任何 LED/页面异常都需与已知成功基线 `player_osd_phy_fix` 同条件对照；本候选新布局本身会改变物理时序和信号路径。

## 源码与接口核对

- 相对 C11106 的 `src`，87 个源文件中只有 `top_tf_hdmi_audio.v` 和 `player_status_monitor.v` 的 SHA-256 不同；`player_bit17_led_probe.v` 虽保留但未实例化。WAV/TONE 源、mux、ACR、transmitter 加密 wrapper、PHY wrapper、lane、PLL 与 SDC 等均沿用 C11106。
- `hdmi_packet_monitor.v` 未改，SHA-256：`E0755EEF660DF07B56C576E6A07565B9189C50E68112F885CD2A08831B38024B`；与成功基线 `player_osd_phy_fix` 相同。
- 包监视器在 `top_tf_hdmi_audio.v` 中使用 `clk=video_clk`，接三路 transmitter 并行 TMDS 字 `tmds_ch0/1/2_data`，输出接 status monitor。三种每秒计数和音阶错误计数为 24 位；`acr_cts_last`、`acr_n_last` 按模块接口及成功基线声明为 20 位，未扩宽或改采样边沿。
- C11107 状态页参数为 `SYS_HZ=25_000_000`、`PAGE_SECONDS=2`、`BUILD_ID=24'hC11107`；自检仍为默认开启。status monitor 的输入音频计数、mailbox、CDC/接收快照核心均未改，仅将页轮转上限由 8 扩到 9，并增加明确的 C 页和 D 页版本标识。

## 缩放时钟页面模型

`build/model/tb_status_pages.v` 直接实例化正式 `player_status_monitor.v`，把 `SYS_HZ` 缩到 2 Hz、每页保持 2 秒（4 个上升沿），检查两页自检、原状态页 1/3、包页 6 至 D、D 页 `DFC11107` 以及轮转回页 1。Icarus Verilog 12.0 的模型输出全部 PASS。该模型只验证本地页面选择/格式与翻页计数，不包含加密 HDMI 核、packet monitor 的真实 HDMI 数据解码，也不证明时钟、ODDR 或板级物理链路。

主代理复核：两个HDL文件差异核对完成；独立工程.al的Project Path已改为新目录（工程元数据差异），没有更改SDC或引脚。页面6为样本、7为包数，D为固定版本标识。


正式packet monitor用本候选源码重跑47断言/0失败，BCH/向量重建通过；日志在build/model/packet_model.log、packet_vector.log。第一次TD项目归一化被输入哈希门槛拒绝、证据封存，第二次冻结归一化输入后四阶段绑定哈希均通过。bit SHA256: f60d473da14c2ec813b80534cde228e8b05b1e630ad81664e35b9b456b32224d。仅本地验证，不是物理根因证据。

