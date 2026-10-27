# C29 → C30 音频回退：物理实现审查

日期：2026-10-23（北京时间）  
范围：只读检查 C29 `development/player_video29_media_flow` 与 C30 `development/player_video30_probe_prune` 的已保存 routed timing、gate Verilog、顶层/约束/PHY 源码。未运行 TD、ModelSim 或其他重任务；未改动冻结工程。

## 结论

现有证据支持“探针裁剪改变了全局综合/布局布线结果，且 C30 在板上音频失真”这一相关性。证据尚不能把根因收敛到 PCM/ACR 内容、HDMI 加密核内部行为或某条具体 ODDR 数据位。C29/C30 使用同一份加密 HDMI wrapper（SHA-256 均为 `867E0B0BDD874BC383D00918C9E1BE3FE01EDF41F343B6A0D73E262776596A63`）；两版顶层 HDMI 音频端口和 PHY 连接相同。C30 虽然 setup/hold 汇总仍为正值，音频以 `video_clk` 输入核、由 `hdmi_5x_clk` 串行输出的核内交接与外部输出延迟，不能仅凭全局 WNS/HWNS 判定裕量充足。

用户现场反馈：C29 整板声画正常；C30 所有音频均为杂音，包含内置 tone；视频、FFT、按键正常；重载 C29 后恢复。该反馈把排查优先级指向 C30 相对 C29 的音频输出物理实现差异，但它还不能区分数字包/ACR错误、核输入时序、串行 PHY 时序或板级接收差异。

## 源与网表对照

- HDMI 核加密文件逐字节相同，SHA-256 如上：
  - `development/player_video29_media_flow/src/user_source/hdl_source/hdmi1.4b_transmitter_core/hdmi_1_4b_transmitter_core_wrapper.enc.v`
  - `development/player_video30_probe_prune/src/user_source/hdl_source/hdmi1.4b_transmitter_core/hdmi_1_4b_transmitter_core_wrapper.enc.v`
- 两版顶层均由 `video_clk` 驱动核心，向核心输入 `audio_valid`、左右 24-bit PCM、`acr_valid`、20-bit CTS/N；并把四路 TMDS 10-bit 字送入 PHY。C30 连接见 `development/player_video30_probe_prune/src/user_source/hdl_source/top_tf_hdmi_audio.v:539-583`；C29 对应连接见 `development/player_video29_media_flow/src/user_source/hdl_source/top_tf_hdmi_audio.v:618-662`。C30 的 `player_audio_output` 负责 PCM/ACR，接线见 `top_tf_hdmi_audio.v:475-485`。这是保留的真实接口链路，不见端口交换或截位改动。
- 两版 `timing.sdc` 相同，均为同一组输入与 PLL 派生时钟约束；`video_clk` 与 `hdmi_5x_clk` 未设为互斥时钟（C30：`src/user_source/constraints_source/timing.sdc:1-11`）。因此时序汇总改善/变差可由布局变化导致；约束本身没有 C30 专属的时钟语义差异。
- C30 顶层删掉多个诊断逻辑和显示/记账路径，压缩后全局拓扑已改变。最终 routed 报告显示 C29/C30 时钟负载变化：`video_clk` fanout 2354→1774，`hdmi_5x_clk` 48→55，`sd_card_clk` 3303→3253。各时钟的布局、扇出与局部布线随之改变；这是物理实现差异的直接报告证据，不能单凭 fanout 推断具体音频位错误。
- 两版报告都将 `hdmi_5x_clk` 识别为 125 MHz 时钟，但 C30 报告时钟摘要对其标记 `CC-From=no / CC-To=no`，串行器/ODDR 数据口到顶层 HDMI 引脚也没有板级 output-delay 约束。该摘要不足以证明像素域到串行域的逐位相位/负载/输出建立保持条件已被完整覆盖。C30 timing 报告头称 routed、coverage 99.99%，这是 STA 覆盖指标，不自动包含未建模的外部接收时序。
- C30 PHY 代码在 `hdmi_phy_warpper.v:71-116` 将 4 路通道送入相同 `lane_lvds_10_1`；lane 在 `lane_lvds_10_1.v:34-66` 由 5×时钟做边沿同步、预装载与移位，`lane_lvds_10_1.v:117-126` 使用 `EG_LOGIC_ODDR` 发出双沿数据。C29/C30 该 PHY 源与 ODDR 结构相同。报告中找不到相应 ODDR 的可审计 routed D0/D1 pin setup/hold 路径；需避免将 ODDR 输入/输出相位视作已证实通过。
- 最终 gate 网表中两版都保留了 ACR 计数节点 `u_audio_probe/u_acr/S_acr_cts_cnt`、tone 相位节点 `u_audio_probe/u_tone/S_phase_acc` 和四路 PHY 的 `S_oddr_data[1:0]`。C29 节点见 `build/manual/AC201_tf_hdmi_gate.v:127-152,828-840,10551-10644`；C30 见同名文件 `:110-135,806-820,9910-10003`。C30 ACR 输出连到加密核输入的 LUT/寄存器连接可见 `:20470-20522`。这些节点可用于后续逐位回溯；当前只确认节点存在与结构相似，尚未做 C29/C30 全网表节点映射等价或后布局坐标关联。

## 布线后时序数据

证据为各自 `build/manual/AC201_tf_hdmi_pr.timing`，报告生成时间分别 2026-10-23 12:05:35（C29）与 13:55:14（C30）。两份报告均标记 `Confidence: Routed`，STA coverage 99.98% / 99.99%。

| 指标 | C29 | C30 | 含义 |
|---|---:|---:|---|
| 全局 setup WNS / TNS | +0.709 / 0 ns | +0.113 / 0 ns | C30 setup 最小裕量明显变小；C30 最差端点是 `u_wav_player/scan_pos_reg[7]` → `[27]`，属 WAV 扫描计数路径，不是音频 PHY 端点。 |
| 全局 hold WNS / TNS | +0.024 / 0 ns | +0.025 / 0 ns | 最小值相近，不能证明 ODDR 输入稳定窗口或板级输出时序。 |
| video_clk setup WNS | +11.692 ns | +11.417 ns | C30 仍正裕量；HDMI 音频包/FIFO存在于 pixel domain，但该值不代表输出串行链路所有路径。 |
| hdmi_5x_clk (125 MHz) setup WNS | +1.543 ns | +1.537 ns | 报告有该时钟摘要，C30 基本持平；摘要没有列出可核验的 ODDR D0/D1 最差端点。 |
| 时钟扇出：video / 5× | 2354 / 48 | 1774 / 55 | 说明裁剪后时钟负载/布局改变。 |

C30 报告中可见 HDMI core 音频包寄存器到内部 audio FIFO RAM 写数据口的 `video_clk` 同域路径，例如 `AC201_tf_hdmi_pr.timing:3178-3223`（packet body → FIFO `dia`），说明这部分被常规 pixel-clock STA 分析。报告没有给出任何从核心 PCM/ACR 输入 pin 到输出 HDMI 音频采样/ACR 包内容的动态功能证明；加密核内部表达式不可从该文件直接复核。

## 可检验修复/定位方向

按低成本与判别力排序，后续在独立候选工程执行：

1. **先验证源端数据是否相同**：在 C29/C30 同一播放状态采集 HDMI 核输入 `audio_valid/left/right/acr_valid/CTS/N` 的同步摘要或短窗 CRC，内置 tone 与 WAV 各测一轮。C30 仍保留 `player_pcm_waveform` 观察接口（`top_tf_hdmi_audio.v:466-473`），可在候选中显示/记录音频核输入样本；若源端摘要匹配，根因优先落向核心内部时序到串行 PHY；若不同，先查 `player_audio_output` 与有效/复位/播放门控。
2. **探针分组回插 A/B**：从 C29 基线逐组删除探针，保持全部音频源/PCM/ACR/PHY/约束不变；对每个候选保存 routed timing 与 ODDR/核心音频局部网表。若某组移除重现杂音，即可缩小影响的逻辑负载/布局范围。也可在 C30 单独恢复被移除的高扇出/高活动观测逻辑作负载 A/B。
3. **核对路由后关键节点**：对 C29/C30 `AC201_tf_hdmi_gate.v`、`AC201_tf_hdmi_pr.timing` 与最终网表的 `u_audio_probe` 输出、HDMI wrapper 输入、`u_hdmi_tx_controller_wrapper` 音频包/FIFO、PHY `S_pending_data`/`S_shift_data`/ODDR D0/D1/Q 做同名端点追踪。记录逻辑连接、物理坐标、时钟树偏斜、净延迟和边沿关系；重点比较 PCM/ACR 被采样端与 ODDR 数据发射端。只看两版总资源或 WNS 不够。
4. **补齐串行时钟和 I/O 约束证据**：按实际 PLL 相位/ODDR 时序补充 pixel↔5× serializer 的确定相位时钟关系检查，并为 HDMI 输出引脚建立经板卡/接收规范确认的 output delay/load；跑 routed setup/hold 和 clock-domain 汇总，确认 ODDR 两个数据输入对对应边沿有明确 margin。避免用 false/exclusive path 掩盖实际同时工作的串行链路。
5. **回归方式**：用同一块 AC601+AC201、相同供电/HDMI线/显示设备、同一音频素材和固定 tone，执行 C29→C30→候选→C29 短序列；分别记录显示、tone/WAV、频谱、音频包输入摘要和版本。用户已报告 C29 回载恢复，可用它继续作为已知正常物理对照。

## 结论边界与未完成项

本审查只完成文件/源码/既有 routed 报告静态对照。未用仿真核验 C30 实际 PCM/ACR 输入，未反汇编或建模加密核，未从板端测量 TMDS 音频 island、ODDR 电气边沿或接收设备 PCM。C30 局部 ODDR 时序是否充足、探针裁剪是否因布局改变直接导致失真，均待上述 A/B 与 routed 节点审计验证。
