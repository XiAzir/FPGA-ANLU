# C29 → C30 音频回退静态审查

日期：2026-10-23（北京时间）  
范围：`development/player_video29_media_flow` → `development/player_video30_probe_prune`，只读 RTL/工程文件检查。按要求未改冻结源，未运行 TD 或整机仿真。

## 结论

C30 将 `player_audio_probe` 改名/裁剪为 `player_audio_output`，但其中产生 WAV/tone PCM、选择音源、计算 ACR 的有效逻辑保持逐句一致：桥接器参数仍为 25 MHz/48 kHz 默认值及 `PLAY_GATE(1)`；tone 幅度仍为 `24'sd1000000`；音频 mux、ACR 参数 `N=6144`、tone_mode 复位与按键切换行为相同。`wav_pcm_bridge.v`、`audio_arc_calculate.v`、`hdmi_audio_tone_pcm_scale.v`、`hdmi_phy_warpper.v`、视频 AXIS 转换、音频 FIFO 与 HDMI transmitter wrapper 在 C29/C30 的 SHA-256 相同。C30 顶层到 HDMI 核心的 PCM/VALID/ACR 命名连接也保留。

因此，当前 RTL 差异没有显示出“PCM 数值/位宽、音频有效、tone 波形、ACR 计算、HDMI 音频输入接错”的直接功能删改。该结论描述源代码结构；C30 实际 bitstream 的时序、布局布线与板上 HDMI 音频表现仍待实测。用户反馈的同卡同线 C29 声音正常、C30 图片/视频/音阶都嘈杂，加上 tone 与 WAV 都受影响，优先把待查点放在共同的 HDMI audio packet/ACR 输出实现、综合后映射/时序，或生成/下载产物差异；WAV 文件解析单独故障的解释较弱。

## 逐项证据

### 音频模块改名与裁剪

- C29 `player_audio_probe.v:2-18` 与 C30 `player_audio_output.v:2-18`：模块名由 `player_audio_probe` 改成 `player_audio_output`。C29 端口包含 `led[3:0]`（第 17 项）和 `tone_mode`；C30 移除了 `led` 输出，`tone_mode` 仍在原端口之后。端口表由此发生位置变化；实际顶层使用命名连接，所以 C30 现有实例不受位置变化影响（见下方顶层证据）。若另有位置式实例，必须核对参数/实参次序。
- C29 `player_audio_probe.v:33-52` 与 C30 `player_audio_output.v:21-40`：`wav_pcm_bridge`、tone发生器、`audio_valid/audio_left/audio_right` mux、`audio_arc_calculate(ACR_N=6144)`连接保持相同。两份文件对应区段逐句相同；SHA-256 仅因注释、模块名和诊断逻辑变化而不同。
- C29 `player_audio_probe.v:54-60, 70-82` 的 `fifo_nonzero_seen`、`take_seen`、WAV输出变化判定、tone valid/nonzero、ACR rate sticky 状态和约 0.5 秒 blink 计数，在 C30 整段移除。C29 `player_audio_probe.v:85-89` 的 LED 诊断编码也移除。C30 `player_audio_output.v:42-45` 只留下 `tone_mode` 的复位/翻转寄存器，行为和 C29 第 61-68 行对 tone_mode 的赋值一致。这些观察状态没有回接到 PCM mux、`sample_take`、播放使能或 ACR 输入；删除它们可能改变综合资源、拥塞和布局时序，但源代码无法判定其对真实 HDMI 物理输出的影响。

### 顶层控制、LED 与探针清理

- C29 `top_tf_hdmi_audio.v:447-455` 实例化 `player_video_source_probe`，其 `key0_n_async` 固定为 `1'b1`，随后把其 RGB 输出用作 `vout_data_base`。C30 `top_tf_hdmi_audio.v:396-399` 固定 `probe_mode=0`，`probe_tone_toggle=debug_tone_press`，并改成 `osd_frame_valid ? vout_data_raw : 24'd0`。C29 中按该常量连接，测试图案模式不可达；C30 删除了该 RGB 探针后的路径。该变更影响视频像素输入，代码中没有连接到音频数据路径。
- C29 `top_tf_hdmi_audio.v:555-565` 与 C30 `top_tf_hdmi_audio.v:475-485`：两处均为命名端口连接；`PLAY_GATE(1)`、`primed` 条件、`play_enable` 条件、PCM 16-bit 输入、sample_take、underflow、PCM 24-bit 左右输出和 ACR 三信号连接相同。C30 将 `underflow_event` 从顶层诊断计数用途改为未连接（C29 此信号用于后续 underflow 观察计数），它不影响 `underflow` 输出或播放门控。C30 移除模块 `led` 驱动后，由 `top_tf_hdmi_audio.v:488-489` 用 `{video_mode,debug_tone_mode,display_valid,fs_ready}` 驱动 LED；LED 只表示模式、图像提交和挂载状态，不再观察 sample consume、PCM变化、tone有效和 ACR 状态。故“LED/模式符合预期”无法证明 HDMI 实际收到有效、可听的样本。
- C29 `top_tf_hdmi_audio.v:631-636` 与 C30 `top_tf_hdmi_audio.v:552-557`：送入 HDMI transmitter wrapper 的 `I_audio_valid`、左/右 PCM、`I_acr_valid/cts/n` 连接保持一致；只是由于前面的裁剪，代码行号向前移动。
- C29 顶层中的 `player_pcm_crc_probe`、`hdmi_packet_monitor`、`player_debug_monitor`、状态页和同步快照/计数器被 C30 移除。它们读取 PCM、音频包或文件链路观测点，结果只送诊断显示/计数；在静态连接检查中未发现其输出驱动 audio mux、ACR 或 HDMI wrapper 控制。观察器移除不改变明确的音频 RTL 组合/顺序方程，但会消除对实际 PCM 序列和封包的板级证据。

### 音频/ACR/HDMI/PHY与工程绑定

- C29/C30 共享音频/链路源文件哈希一致：`wav_pcm_bridge.v`=`1E432719…93A84A`，`audio_arc_calculate.v`=`552D8D86…17A7DC`，`hdmi_audio_tone_pcm_scale.v`=`0FF1AB2B…D8DDD0B`，`hdmi_phy_warpper.v`=`416B082B…3CF4300`，`IP/afifo_16_256.v`=`DAB43A76…7BF4BF8`，HDMI transmitter wrapper=`867E0B0B…6596A63`，`video_rgb_to_axis_640x480.v`=`1C8FC26C…90FB96`。此项属于静态文件哈希比较，综合网表与 bitstream 等价性另待检查。
- C30 `src/td_project/AC201_tf_hdmi.al:31,55,254,279,335` 仍绑定 PHY wrapper、顶层、tone、WAV bridge 和 `player_audio_output.v`。C29/C30 对应工程 XML 及所有约束、IP 参数未做全量语义比对；本审查仅确认 C30 最终工程声明包含新音频模块与共同链路源文件。

## 可检验假设与建议取证

1. **综合/布局布线改变导致共同音频路径的板级退化。** 探针裁剪让资源和布线负载变化，即便 audio RTL 逻辑相同，C30 时序或高速 HDMI serializer/PLL 周边映射也可能不同。检查并比较两版最终编译报告中的 video/audio相关时钟约束、关键路径、hold 修复、PHY/PLL绑定与最终 bitstream 来源；如条件允许，做一个仅回加 C29 观察器的控制构建，若音质随观察逻辑恢复/改变，说明实现时序/布局对现象有影响，而非观察逻辑的显式反馈功能。
2. **C30 HDMI 音频包/ACR 在芯片输入或 HDMI 接收端表现异常。** 临时保留可访问的 PCM/ACR/packet 观测，并确认 tone 模式下 `audio_valid` 周期、PCM交替值、`acr_n=6144`、`acr_cts` 在设计对应值附近；同时在 HDMI 接收端确认输入音频格式/采样率。旧 C29 的观察器记录的是“事件曾发生”；建议记录连续窗口，或用示波器/HDMI分析仪核实持续播放。
3. **交付或下载的 C30 bitstream 与审查源文件不一致。** 记录实际下载文件 SHA-256、生成时间与工程路径，并与 `delivery_receipt.json` 及编译输出绑定核对。C30 目录下存在 `build/manual/AC201_player_video30_probe_prune.bit`，但本次未读取下载记录，未确认用户板上所烧录文件来自该路径。
4. **若 tone 与 WAV 均噪，先区分公共 HDMI 音频链路与下游接收/解码。** 在同一台显示设备、同一线材、同一输入端，以 C29/C30 的真实烧录文件交替测试并固定设备设置；再用另一 HDMI 接收端或 HDMI 音频分析设备交叉复测。用户已反馈同卡同线的 C29/C30差异，因此连接差异证据当前较弱，但下游对时钟/包序列的容忍仍可被版本差异触发。

## 检查范围与限制

已运行只读 PowerShell 文件枚举、`rg` 行号检索、`git diff --no-index` 文本比较与 SHA-256 哈希比较。未改 C29/C30 源文件；未运行 TD、仿真、综合、布局布线、下载或上板测量。当前证据支持“功能 RTL 主链条文本一致，诊断裁剪和视频旁路有变化”；实际硅上边沿、时序裕量、PHY映射与 HDMI 接收行为仍待上述假设检验。


