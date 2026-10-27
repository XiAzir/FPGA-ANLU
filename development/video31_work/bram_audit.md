# C29 / C30 HDMI audio FIFO BRAM 与时序覆盖审查

日期：2026-10-23。只读检查既有 `AC201_tf_hdmi_gate.v` 与 routed `AC201_tf_hdmi_pr.timing`；未运行 TD、仿真或硬件操作。

## 核心结果

`u_audio_sample_packet_2_channel/u_w96_d1024_fifo` 是 96-bit × 1024 深度的 FIFO，网表将其拆成 **11 个 9-bit EG_PHY_BRAM 片段**，`data_offset` 为 0、9、18、27、36、45、54、63、72、81、90；最后一片有效宽度 6 bit。用户提及的“三块”可对应 routed timing 中被报告抽样到的三个 audio FIFO DI 端点 524/564/584；完整 FIFO 映射含 11 片。

C29/C30 的 11 片参数与 DI/DO、地址、CE/WE、reset 接线逐片相同。C30 `.clka/.clkb` 显示 `u_adjust_control/clk`，C29 显示 `video_clk`；C30 该实例在顶层由 `.clk(video_clk)` 驱动（`src/user_source/hdl_source/top_tf_hdmi_audio.v:389`），其 routed timing 也将音频 FIFO DI endpoint 归类为 `video_clk`，所以这里是网表别名变化。未发现 C30 的音频 FIFO BRAM 参数或 PCM/channel-status 位映射变更。

宏配置（11 片相同）：`MODE=DP8K`、`DATA_WIDTH_A/B=9`、`REGMODE_A/B=NOREG`、`RESETMODE=SYNC`、`WRITEMODE_A/B=NORMAL`、`CEAMUX/OCEAMUX/OCEBMUX=1`、`WEBMUX=0`；`addra/addrb` 为 FIFO 写/读地址总线、低 3 位固定 `3'b111`；`ceb=I_audio_sample_packet_req`，`wea=I_fifo_wr_en`；两时钟同为 pixel/video 域；`rsta/rstb` 接加密核层级的 `I_rst`。因此 reset 属性是同步模式配置，异步复位端口信号也在网表中连接到该核复位网。

C30 的已保存 gate 文本是这些宏的可读映射依据，最终 `pr.db` 为二进制数据库；routed `.pr.timing` 用于核实路径和实际参与时序的物理端点。没有调用 TD 读取 `.pr.db` 内部属性或坐标。

## 96-bit FIFO 输入字映射

`data_offset` 表示每片在 96-bit FIFO 字中的起始位。下表按 gate 网表 `.dia` 的拼接顺序展开；`D[n]` 指 `I_fifo_wr_data[n]`。C30 可读网表行号见本表，C29 对应片段分别位于 `AC201_tf_hdmi_gate.v:141448-141797`。两版每片映射一致，差别限于层级时钟别名和 open-net 编号。

| FIFO 位段 | 片实例 | 写入数据 / 映射来源（由高位到低位） | 来源类别 |
|---|---|---|---|
| 0–8 | `syn_524` | `{D[32:30], 6'b0}` = `{audio_left_data[8:6], 6'b0}` | 左 PCM 有效位与常量填充 |
| 9–17 | `syn_534` | `{D[17:10], D[33]}` = `audio_left_data[17:9]` | 左 PCM |
| 18–26 | `syn_544` | `{3'b0, D[23:18]}` = `{3'b0, audio_left_data[23:18]}` | 左 PCM与高位填充 |
| 27–35 | `syn_554` | `{D[11:10], D[33:30], 3'b0}` = `{audio_left_data[11:10], audio_left_data[9:6], 3'b0}` | 左 PCM字段的重复打包/填充 |
| 36–44 | `syn_564` | `D[20:12]` = `audio_left_data[20:12]` | 左 PCM |
| 45–53 | `syn_574` | `{2'b0, D[51:50], 2'b0, D[23:21]}` | PCM低位、左通道状态位及常量填充 |
| 54–62 | `syn_584` | `D[62:54]`；D54=右状态移位末位，D55=packet body[55]，D56–63 的相关派生网由 BCH/body 逻辑生成 | channel-status / BCH 派生字段 |
| 63–71 | `syn_594` | `{8'b00000010, D[63]}` | packet body 位63及固定字段 |
| 72–80 | `syn_604` | `9'b000000001` | 固定字段 |
| 81–89 | `syn_614` | `{D[84],D[88],3'b0,D[84],3'b0}` | packet header / BCH 值的重复打包与填充 |
| 90–95 | `syn_624` | 9-bit 输入为 `{open×3,D[84],1'b1,D[88],D[84],2'b01}`；有效低 6 bit 为 `{D[84],1'b1,D[88],D[84],2'b01}` | packet header / BCH 与固定字段；上方 3 bit 是 6-bit 尾片的未用填充位 |

关键语义追踪：C30 gate 网表中 `S_packet_body[10:23]` 由 `audio_left_data[10:23]` 寄存得到，`S_packet_body[6:9]` 由对应左 PCM bit 组成（`:132660-132881`）；左通道状态移位末位进入 `S_packet_body[50]`（`:133661-133666`），右通道状态移位末位进入 `[54]`（`:134582-134587`）。`S_packet_body[51]` 为组合逻辑形成的派生字段，逻辑输入含 PCM/body 与状态位（`:133699-133722`）。FIFO 输入 D50=左状态移位末位；D51、D55 等为组合 BCH/body 结果；D54=右状态移位末位；D56–D63 分别来自 `S_packet_body[55]_syn_8`、`[55]_syn_12`、`[50]_syn_4`、`[51]_syn_8`、`[51]_syn_6`、`[16]_syn_4`、`[54]_syn_4`、`[55]_syn_10`（对应 Q 连接在 `:134610-134695`）。FIFO 输入 D[84] 来自 `S_packet_header[20]`（`:134113-134116`）；D[88] 来自 BCH 32/24 encoder 的输出寄存器（`:134596-134600`）。因此高位常量与重复位有 packet/header/BCH 打包来源，未见未驱动位进入 FIFO 的有效 96-bit 数据；仅 offset90 片的 3 个超宽端口填充位置呈 `open_n`，和 `working_width=6` 一致。DO 侧大部分接 `S_audio_sample_packet_BCH_block_0`，尾部交由 BCH block 4/0（C30 `:135358-135707`）。

C29/C30 均有同样的 open padding 与常量。没有仅在 C30 出现的 BRAM 未连接有效数据位、不同写使能、不同读使能、不同 FIFO 时钟或不同 reset 配置。

## Routed timing 对照与覆盖范围

最终 routed 报告均标注 `Confidence: Routed`。按 audio FIFO 端点筛查：

- C29 有 `S_packet_body_1d_reg[50] → syn_564.dia[8]` 的 `video_clk` hold 路径，slack +0.030 ns，报告 `:2565-2611`。
- C30 有 `S_packet_body_1d_reg[13] → syn_564.dia[5]` 的 `video_clk` hold 路径，slack +0.030 ns（`:3177-3223`）；`S_packet_body_1d_reg[30] → syn_524.dia[6]` slack +0.086 ns（`:3348-3394`）；`S_packet_body_1d_reg[21] → syn_584.dia[0]` slack +0.086 ns（`:3405-3451`）。这些路径证明 audio packet FIFO 的写入端确实进入 routed STA，且源寄存器与 BRAM DI 作为同一 `video_clk` 域分析。
- 逐条审查 C30 `From Clock: video_clk / To Clock: hdmi_5x_clk` 时钟组（`:13086-14275`），报告抽样列出 reset recovery 与跨域 hold 检查。音频核输出已编码为 TMDS 数据的寄存器到 PHY pending-data 端点有 hold 路径，例如 `O_tmds_code_data_reg[9] → S_pending_data_reg[0].mi[1]`，slack +0.244 ns（`:13759-13816`），还有其他 lane/data 位 hold 样例。C29 同组可见 TMDS→PHY setup slack +5.495 ns（`:12681-12738`）及 hold 最小 +0.253 ns（`:13042-13099`）。C30 对应路径组列出的端点样本中未见 `Check Type: setup`，需检查该组完整路径类别/STA 输出选项，避免只用 99.99% coverage 或全局 WNS 概括 serializer setup 覆盖。
- 在这些 timing 报告的 audio FIFO 路径查询里，观察到的 BRAM 端点是 DI 写入端；本轮未定位到 BRAM `dob` 到 HDMI packet/serializer 的逐位功能路径报告。另未在 SDC 中找到 HDMI 输出 `set_output_delay`，所以这些结果没有描述外部 HDMI 接收器的输入建立/保持预算。

## 审查判断

此轮发现没有 C30 独有的 audio FIFO BRAM 宏配置、PCM/channel-status 输入位图、WE/CE/reset 或 FIFO 时钟变化。数据映射含固定 padding 与重复位，但 C29 同样存在；`open_n` 只在有效宽度 6-bit 尾片的 3 个填充位上。最明确的音频相邻路径变化信号来自报告的全局布局/物理 STA；本次可读网表不能证明这些 11 个 BRAM 的布线坐标逐个相同或不同。

后续若把排查继续聚焦 serializer，可在 C29/C30 对比 routed timing 的 `video_clk → hdmi_5x_clk` setup/hold 路径类别与各 TMDS lane pending-data 位端点，并对照 `.pr.db` 的 BRAM/PHY 坐标；当前 C30 文件级证据显示 FIFO 写端 STA 覆盖存在，而序列器输出 setup 检查需要进一步确认。
