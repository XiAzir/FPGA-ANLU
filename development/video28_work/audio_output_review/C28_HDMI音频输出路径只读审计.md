# C28 HDMI 音频输出路径只读审计

日期：2026-10-23（北京时间）  
范围：`development/player_video28_hdmi_observe`；只读源代码、约束、已存在的报告/测试证据。未改生产源/bit/script，未运行 TD、整机 ModelSim 或新仿真。

## 结论

本次静态审计没有找到一个可确定解释持续杂音的 C28 音频源到 HDMI 串行 packet RTL 缺陷。现有证据把 WAV 文件、读取内容和送入 HDMI wrapper 前的 PCM 顺序降为低优先级；实际HDMI接收端看到的PCM、包与ACR，以及板上TMDS电气波形仍未测量，故根因尚未定。

C28 与 C22 的 `audio_arc_calculate.v`、`wav_pcm_bridge.v`、`player_audio_probe.v`、`hdmi_audio_tone_pcm_scale.v`、视频PLL源码、`timing.sdc`、`pin.adc` SHA256逐项相同。C28 相对C22的 PHY 文件差别只有新增探针端口/连接：差分对输出仍由原EG ODDR驱动，观察点是时钟lane的ODDR输入寄存位。音频packet格式核心为加密文件，wrapper接口配置是48K、VIC1、640×480；加密core自身源码不可作逐行审阅。

已有C11322审计记录真实B0对齐192帧Channel Status为48kHz/24-bit，已撤销启动窗口误判；原Audio InfoFrame选择follow-stream。其真实加密core + EG PHY模型 + 串行接收器定向测试，对给定PCM序列逐包一致：1611个SP1音频包、33个ACR，N=6144、CTS=25000，BCH/TERC/TMDS格式错均为0。该测试是C11322历史配置的仿真证据，不等同C28完整媒体位流或实板接收验证。C28自身离线PHY矩阵只验证PHY/被动时钟探针和接收器的符号恢复，不含HDMI core及音频packet；C28离线测试明确没有整机/SDF仿真。

用户现场报告的图片模式PCM首/末CRC吻合、underflow=0，结合原声与内置tone都出现杂音，指向两者共享的核后链路优先级较高。Tone发生器生成48kHz采样的符号位方波，音色会尖锐粗糙；它不足以解释WAV也出现同类杂音。共享后段包括加密core、TMDS通道0/1/2、ODDR/输出引脚、线缆、接收器及显示器音频输出。

## 路径与可证范围

- WAV FIFO位于`sd_card_clk`域；音频bridge以request/ack toggle跨到`video_clk`域，PCM mailbox在SD侧收到请求后更新，并由ack同步返回。像素侧只在ack到达后采样mailbox；这是带稳定期的bundled-data握手，代码中未见“跨域直接采样后立即消费”的确定缺陷。FIFO/CRC/underflow页反映的是送核前状态。
- PCM与ACR都由pixel/video clock产生，wrapper输入共用相同域；不存在音频valid到core之间额外异步FIFO。
- ACR核以48个有效PCM样本产生一次更新，配置N=6144；25MHz/48kHz目标CTS约25000。C11322定向测试对其做了长周期逐次断言。ACR输出寄存器缺复位分支，启动首个有效ACR前可有初始状态；稳态测试排除此启动窗口后，不足以解释持续噪声。
- PLL配置/约束目标为50MHz输入、25MHz像素、125MHz串行。C28最终布线报告列出视频25MHz、串行125MHz，global setup WNS +0.242ns、TNS 0；该值是数字内部时序证据。SDC没有HDMI输出delay约束，板级lane skew、波形摆幅/边沿、接收门限和实际晶振频率未测。这个缺口使电气/板级假设待测，但本身不证明有硬件故障。
- C28当前F页的raw clock word/ODDR输入边沿比例观察的是TMDS时钟lane，不观察数据lane中的音频packet。HDMI锁定、每帧480行及有时钟活动只能证明接收显示路径工作到一定程度，无法验证Audio Sample Packet和ACR被接收端正确解码。

## 证据优先级

1. **高优先级待定位：核后共同链路。** 现场WAV和内部tone均有杂音；C11322数字仿真验证过相同类别的core/PHY模型，但未覆盖C28当次完整配置的实板输出。
2. **中优先级待复现：视频/串行时钟的板级边沿、lane映射或电气裕量。** C28显示端有UI/480行，C28数字PHY仿真通过；内部STA缺少HDMI输出约束，当前时钟监视只看clock lane输入。没有示波器、接收端原始PCM或HDMI分析仪数据，不能下电气定论。
3. **低优先级：WAV/FIFO、PCM位宽或16-bit对齐。** 实板提供的核前CRC/underflow证据，以及tone复现均不支持把问题归于WAV来源；C11322对24-bit封装和串行样本逐样本检查通过。
4. **已纠正并关闭：错误的Channel Status Fs判断。** B0起点对齐后的完整192帧正确表示48kHz/24bit，metadata修补没有作为生产修复依据。

## 建议的可复现消融顺序（均尚未执行）

1. **锁定基线**：同一块板、同一C28 Build 00C11328、同一短HDMI线/显示器输入/音量，先运行内部tone模式并完整录音，再运行原WAV；同步记录D页tone/WAV活动、E/F页锁定/行数/时钟输入活动、7/8/9页PCM首末CRC/block/欠载和构建ID。当前用户反馈可作已有提示，需在C28同一构建上补齐一组可比较录音。
2. **接收端PCM审计**：保持C28、线和显示器不变，用支持HDMI音频解码/导出的分析仪或接收端采集器抓取tone与WAV的有效采样、N/CTS、Channel Status和音频包错误。把恢复PCM按输入valid序列比较。若样本/包正确但模拟输出杂音，问题边界位于接收器之后或模拟播放端；若恢复值/packet首个偏差可定位，再对该点做单变量测试。
3. **接收器矩阵**：保持C28和已知良好线，分别接原显示器与另一台支持HDMI音频的接收端；再以电脑+同线接原显示器。每个组合播放相同内置tone并记录。它只用来区分随发射源、接收端或组合变化的现象，单次试听不足以下电气结论。
4. **只在packet证据异常后做数字消融**：复制独立候选工程，每版只改一个输入变量并重新绑定/构建：A.固定已知PCM并关闭WAV bridge；B.维持PCM而对调N/CTS来源/更新节拍的候选；C.关闭音频岛/ACR作为接收端静音控制。必须先由外部解码确认对应数字packet变化，再比较接收音频。不得把现有metadata字段直接改成“修复”，因为C11322的192帧证据与follow-stream配置匹配。
5. **若候选均显示数字packet正确**：测量TMDS clock和三条data lane在AC201 HDMI输出处的差分波形/眼图或用接收端质量诊断；记录线缆/接收端配对和实测像素/串行频率。再按测量结果选择驱动、走线、时钟相位或接收端方向，避免无依据调整PHY参数。

## 证据文件

- 指定基准审计：`development/video23_work/audio_analysis/C11322_audio_path_audit.md`（本审计据此继承48kHz/24bit纠正及历史覆盖边界）。
- C28源码：`development/player_video28_hdmi_observe/src/user_source/hdl_source/{top_tf_hdmi_audio.v,wav_pcm_bridge.v,player_audio_probe.v,audio_arc_calculate.v,hdmi_audio_tone_pcm_scale.v,hdmi_phy_warpper.v,lane_lvds_10_1.v}`。
- C28约束与实现：`development/player_video28_hdmi_observe/src/user_source/constraints_source/{timing.sdc,pin.adc}`、`development/player_video28_hdmi_observe/src/td_project/final_timing.rpt`。
- C28专项验证范围：`development/player_video28_hdmi_observe/verification/offline_tests.json`（PHY-only范围与“无整机/SDF”边界）。
- 本报告以父任务提供的板测摘要为现场用户反馈：图片首CRC `9DC4`、图片last `4490`/block `0x02a2`/underflow 0；视频last `0779`/block `0x0046`/underflow 0，EDID不参与且锁定/480行观察有效。以上状态支持核前路径，不能代替串行输出测量。
