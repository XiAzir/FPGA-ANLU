# axis_probe HDMI 输入链路 RTL 审计

日期：2026-10-09  
范围：审计 `player_dynamic_text_axis_probe` 的输入侧 AXIS、6..C 状态页、HDMI wrapper 接口、PLL/时钟和与 `player_osd_phy_fix` 源码对照；并运行一个独立的真实 25 MHz tone/audio-status 仿真。实板反馈和数码管读数均注明为主代理目视反馈；本文没有独立观测实板波形或复测位流。未生成/下载位流。后续只读检查了实际 routed 网表中的 audio/status 候选锥；因 packed slice 输出跨层级共享，未作子网表仿真，界限与证据见 `netlist_audio/routed_audio_cone_audit.md`。

## 已确认的 RTL 事实

1. 时钟和复位：像素视频时钟 `video_clk`、HDMI 5x 串行时钟 `hdmi_5x_clk` 分别来自 `video_pll`，见 `src/user_source/hdl_source/top_tf_hdmi_audio.v:177-183`。顶层 `rst_all` 只有在系统 PLL 与视频 PLL 都 lock 后再计满 1,000,000 个 `clk` 周期才释放，注释按 50 MHz 标为 20 ms，见 `:141-165`。同一个 `rst_all` 接入视频时序、AXIS converter、HDMI core 和 PHY；converter 的异步复位端为高有效，见 `:254-275`、`:405-416`、`:438-481`。显示状态另经 `status_reset_pipe` 在 `video_clk` 域异步置位、同步释放两拍，见 `:121-128`；observer 与显示采样也都在 `video_clk` 域。

2. AXIS 接线：converter 输入为延迟后的 `vs/de/vout_data`，输出 `axis_s_user/valid/last/data`，见 `top_tf_hdmi_audio.v:405-416`。这些线直接接 HDMI wrapper 的 `I_axis_s_*`，其 `O_axis_s_ready` 回到 `axis_s_ready`，见 `:420-450`。PHY 取 wrapper TMDS 输出并使用 `video_clk`、`hdmi_5x_clk`，见 `:468-481`。被动 observer 在 core 输入线上取样 `valid/user/last/ready/locked`，输出只接状态页载荷，见 `:484-494`；observer 不门控 AXIS，也不改 reset。

3. converter 的 USER/LAST 语义：`S_frame_arm` 复位为 1；每次检测到 `I_vs` 任意跳变都会重新置位；其后下一次 `I_de` 上升对应的首个 active 像素发一个周期 `O_video_user`，见 `video_rgb_to_axis_640x480.v:20-29,31-50`。因此 USER 是由 VS 跳变后遇到的首个 DE 首像素产生的帧起始标记，不是 VS 本身，也不是 valid/ready 握手确认。`O_video_valid` 每拍直接登记 `I_de`，`O_video_data` 每拍登记 `I_rgb`，converter 没有 ready 输入，见 `:35-38`。LAST 在 `I_de` 时仅当旧值 `S_x_cnt==639` 置位，见 `:44-63`。计数在首个 DE 拍置 0，后续连续 DE 拍才递增；按该 RTL 的非阻塞赋值时序，640 个 DE 像素行中没有拍会观察到计数旧值 639，故预期 LAST 观察计数为 0。这与此工程既存模型报告中 TLAST=0 一致，但该模型不是实板证据。

4. observer 旗标和计数口径：`flags={locked,locked_ever,valid_seen,user_seen}`，即 bit3 当前 `locked`、bit2 sticky `locked_ever`、bit1 sticky `valid_seen`、bit0 sticky `user_seen`，见 `player_axis_input_probe.v:31,48-64`。observer 对 `valid` 单独计数，不以 `valid && ready` 作为接收条件；valid 低且 ready 低时不算 ready stall，valid 高且 ready 低才计入，见 `:71-74,98-119`。USER 计数只把 `valid && user` 作为帧起始；USER 但 valid 为低，或 USER 连续出现在 valid 样本上，会计作异常，见 `:66-69,76-98`。有效像素、行宽、帧周期都由 valid / valid 边沿统计，而非握手成功拍。

5. 状态页 `player_status_monitor.v:76-89` 将页码、4-bit flags、24-bit payload 拼成 32-bit HEX；顶层以 `SYS_HZ=25 MHz`、默认 `PAGE_SECONDS=2` 驱动页轮换，且先显示两个自测页，见 `:2-6,58-89`。因此 1 和 3 是原启动/音频 mailbox 页；6..C 映射如下：

   | 页 | 显示格式 | payload 的定义 |
   |---|---|---|
   | 6 | `{6, flags, dims}` | `dims[23:12]` 最近完成行宽，`dims[11:0]` 最近完整帧行数。更新点见 observer `:76-97,107-115`。 |
   | 7 | `{7, flags, frame_period}` | 相邻 USER 起始间统计的像素时钟周期；目标参数 420000。 |
   | 8 | `{8, flags, frame_pixels}` | 相邻 USER 起始间累计的 valid 拍；目标 640×480=307200。 |
   | 9 | `{9, flags, bad_counts}` | 高 12 位累计错误行数，低 12 位累计错误帧数；均饱和计数。 |
   | A | `{A, flags, gap_ready}` | 高 12 位最近一次 valid 间隔 blank 长度；低 12 位 valid 高而 ready 低的拍数，饱和至 FFF。 |
   | B | `{B, flags, frame_last_count}` | 两个 USER 起始之间观察到的 LAST 个数。按现有 converter 预期为 0。 |
   | C | `{C, flags, user_frames}` | 高 12 位异常 USER 次数，低 12 位合法 `valid&&user` 次数。 |

   连接关系见 `top_tf_hdmi_audio.v:486-507`；页格式见 `player_status_monitor.v:79-88`。`packet_cts/packet_n` 在该候选里是 24 位 observer 载荷，已不代表 ACR CTS/N；`packet_*` 名称是沿用的端口名。

6. `hdmi_video_locked` 的可证含义边界：它只是 HDMI wrapper 的 `O_video_locked` 输出，并被直接连到 observer 和 status monitor，见 `top_tf_hdmi_audio.v:458-459,489,499`。wrapper 的加密源文件公开接口将该端口放在“status signal”注释下，见 `hdl_source/hdmi1.4b_transmitter_core/hdmi_1_4b_transmitter_core_wrapper.enc.v:57-60`；实现正文受加密保护。仅凭当前可读源码，不能证明它表示 AXIS 已握手、完整视频帧已送达、TMDS PHY 已锁定，或显示器已锁定。它也不是来自显示器的 DDC/HPD 确认；顶层把 DDC 相关端口悬空，并固定 640×480 参数，见 `top_tf_hdmi_audio.v:418-437,441-444`。

## 与成功 `osd_phy_fix` 的差异

- `video_rgb_to_axis_640x480.v` 的 SHA-256 在 axis_probe 和 osd_phy_fix 相同：`1C8FC26C789F87227036BEA034F1AB6FC5633F2AB2684BE422C54687A290FB96`。USER 生成规则、没有 ready 回压、LAST 计数行为都是共有实现。
- 加密 HDMI wrapper 文件 SHA-256 相同：`867E0B0BDD874BC383D00918C9E1BE3FE01EDF41F343B6A0D73E262776596A63`。两者可见的 wrapper 参数和 `rst_all`、AXIS、TMDS/PHY 接线保持一致。
- axis_probe 顶层相对 osd_phy_fix 增加动态文字/视频源诊断像素处理，改动 KEY1/KEY2 的 BMP 自动/下一张组合逻辑，并以 `player_axis_input_probe` 替换原被动 TMDS packet monitor；AXIS 转换器和 HDMI/PHY 连接没有差异。原画面路径、KEY 映射与新增 observer 的源码差异可见 `git diff --no-index` 比较两版 `top_tf_hdmi_audio.v`。这些输入画面/按键差异可能影响 RGB 内容或播放状态，不会由 observer 对 AXIS 产生组合回馈。
- `player_status_monitor` 页 6..C 从 HDMI 包统计改为 AXIS observer 数据，页 B/C 的 payload 宽度扩为 24 位。显示器的 `hdmi_locked` 与 `axis_valid/user` 监视仍是直接读取，且 observer 的计数域与 HEX 页消费域均为 video_clk。
- reset 条件与两 PLL lock 等待沿用成功版本；新增 observer 以相同 `rst_all` 异步复位。当前候选仍有顶层 50 MHz 域产生 `rst_all` 后分发给视频时钟域异步复位输入这一共有设计特征；释放边沿相对 video_clk 未做显式同步，但这不是本候选相对 osd_phy_fix 的差异，尚无实板证据表明它造成故障。

## 假设与最小后续验证

- **实板反馈（主代理目视读数，非本次独立测量）：** 页循环为 `1DA80000, 6F2801E0, 7F0668A0, 8F04B000, 9F000000, AF0A0000, BF000000, CF000FFF`。页 6 几何值是 640×480；页 7 周期 0x0668A0=420000；页 8 valid 像素 0x04B000=307200；页 9 错误计数为零；页 A blank gap 0x0A0=160、ready-low=0；页 B LAST=0；页 C 合法 USER 计数饱和 FFF、异常 USER=0。所有这些计数与 converter/observer 预期相符。状态 flags `F` 表示取样时 locked=1、locked 曾为 1、valid 曾出现、USER 曾出现；这不构成 core 消费成功或显示器锁定证明。
- **实板反馈（主代理目视读数，非本次独立测量）：** 原帧 before 约 8.3s=`3300B84E`、9.3s=`3300B846`；after 约 2.3s=`3B00B83F`、3.3s=`3B00B836`，反馈范围 47158..47182。页 3 mailbox nibble `3` 为 tone=0、underflow=0、locked=1、frame_seen=1；`B` 为 tone=1、underflow=0、locked=1、frame_seen=1。payload 是 `player_status_monitor` 每 PIXEL_HZ=25,000,000 个 video_clk 周期统计的 valid 事件数，不是物理秒频率测量，见 `player_status_monitor.v:35-53`。tone 源按同一名义频率做 48 kHz 分数分频，见 `player_audio_probe.v:2-4,30-43`、`hdmi_audio_tone_pcm_scale.v:2-4,53-84`。
- **时钟映射对照：** axis_probe 与 osd_phy_fix 的 `video_pll.v`、`sys_pll.v`、对应 `.ipc` 及 `timing.sdc` 文本相同。video PLL 生成文件标注 50 MHz 输入、C0=25 MHz、C1=125 MHz，见 `hdl_source/IP/video_pll.v:13-19,39-42,60-86`；C0 经 `EG_LOGIC_BUFG` 输出到顶层 `video_clk`，C1 直接输出 `hdmi_5x_clk`。顶层所有视频时序、frame-buffer read、OSD/text、converter、HDMI core pixel input、observer 和 audio pixel 输入都接 `video_clk`；HEX 状态域 `status_clk` 也是 `video_clk`，见 `top_tf_hdmi_audio.v:121-128,177-183,254-275,320-325,359-416,439-449,471-493,497-510`。SD/WAV FIFO 侧另用 `sd_card_clk`；PHY serial 输入用 `hdmi_5x_clk`。
- **最终候选时序证据：** 先前误读了 `src/td_project/final_timing.rpt`，该文件是遗留拷贝，不能代表本候选最终实现。实际候选证据是 `build/manual/AC201_tf_hdmi_pr.timing`、同目录 `AC201_tf_hdmi_phy.ts` 以及 `build/independent_audit/final_build_review.json`；`scripts/audit_final_build.py` 第 29-38、93-111 行明确从这些文件取时序并单列 prehold。实际 Routed STA coverage 为 99.97%，最终 `SWNS=+0.280 ns`、`STNS=0`、`HWNS=+0.027 ns`、`HTNS=0`，Slow/Fast max/min 检查均为 yes。prehold `HWNS=-0.008 ns/HTNS=-0.016 ns` 已经 fix_hold；不是最终状态。实际候选 Clock Summary 为 `video_clk=25 MHz`、fanout 1586，`hdmi_5x_clk=125 MHz`、fanout 55；video_clk 内路径最小周期 23.088 ns/fmax 43.313 MHz、HWNS +0.027 ns/HTNS 0。候选 PLL C0→`EG_LOGIC_BUFG`→GCLK 路径和 50 MHz 输入约束可在实际报告核对。由此可确认这份最终候选的数字 STA 没有负 slack；STA 不证明实板频率/信号质量，也不能给加密 HDMI core 做协议语义证明。候选 SDC `constraints_source/timing.sdc:1-11` 声明 50 MHz 输入并 derive/rename 5 路 PLL 时钟；未把 pixel 与 serializer clock 标成 exclusive。
- **可能机制 A，输入侧：** 本次页值已排除 observer 复位后从未见 valid/USER、错误分辨率/周期、ready stall 和 observer 计数出的 USER 错误等解释。仍未知 core 对 USER/LAST 的严格要求，以及其 `O_video_locked` 定义。converter 所有 LAST=0 是共享实现事实，不能单独解释候选相对 osd_phy_fix 的差别。
- **真实参数音频模型：** `build/board_feedback_20261009/audio_model/run.ps1` 用随包 Icarus 编译 `hdmi_audio_tone_pcm_scale`、`player_audio_probe`、`player_status_monitor`；tone 源、probe 和 status monitor 的 `CLK_FREQ_HZ/PIXEL_HZ` 均为 25,000,000，采样率 48,000，未缩放参数。TB 独立计数器以 25 MHz 时钟逐个数满两个 25,000,000 上升沿窗口，并分别计独立 tone reference、probe 输出，再在 status monitor CDC mailbox 接收后比对。两窗均为 tone_valid=48000、probe_valid=48000、mailbox=48000、tone_mode=1、underflow=0，PASS；Icarus runtime 3m30.76s，退出码 0。日志/源码/runner/编译产物在 `build/board_feedback_20261009/audio_model/`。该仿真确认名义 RTL 稳态下 471xx 不可复现，覆盖了 tone 选择和状态 mailbox；没有模拟 WAV 输入/SD 时钟交互、PLL 实际输出、加密 HDMI core、PHY、板级模拟或数码管目视读值。
- **可能机制 B，候选差异：** 动态文字和 video source probe 改变 RGB/KEY 行为；observer 增加逻辑和布线负载。实际候选最终 STA 为全正 slack，但无法排除 bit 与构建快照不一致、PHY/TMDS 路径或模拟因素。实板“无信号”与 `locked=F` 同时出现，说明该 core 状态位本身不足以作为显示端证据。
- **关于 47.1k 的边界：** 实板目视值比名义值低约 1.7%，但两窗真实参数 RTL 仿真都准确输出 48,000，因此暂不支持将该值归因于 tone source、probe mux 或 status mailbox 的稳态 RTL 计数误差。下一步应在实际候选 bit 上用同一 video_clk 旁路计数 tone_valid/audio_valid，并校对测量区间是否覆盖 25M 个有效 video_clk 边沿；若 HDL 计数仍为 48k 而页值偏低，再检查 status mailbox 运行时序/页读值和上板 bit 来源。当前 simulation 不覆盖 WAV 分支，因此不能排除 WAV 模式特有行为。
- **最小下一步：** 若继续复现无信号，先对齐上板 `.bit` SHA-256 到最终 build_source_scope/route 审计，再在同一像素时钟下抓 `axis_s_valid/user/last/ready`、`hdmi_video_locked` 和 PHY 的 5x 采样/TMDS 输出，与成功基线对照。若继续追 47.1k，做上述板上 valid 旁路计数并额外隔离 WAV 模式。波形、bit 哈希和板上 valid 计数获得前，无信号根因仍未确定。
- **可能机制 B，AXIS 回压：** 若页 A 的 ready-low 计数非零，当前源端没有 ready 回压能力，核在 ready 低周期是否丢像素须由加密核契约或仿真/波形确认。observer 当前只记录 offered valid，不是接受计数；页 7/8 同样是 offered stream 的周期和像素数。
- **可能机制 C，锁定误读：** locked 当前位/粘滞位可帮助确认 wrapper 的该输出曾否拉高，但不能作为 TMDS 或显示器锁定证明。`locked=0,locked_ever=1` 表示取样时当前低、此前曾高；两位均 0 只表示 observer 释放复位后未见输出高。
- **后续取证：** 主代理已提供覆盖页 6..C 的完整页值视频，旧的“重新记录 6..C 页”建议已过时。若继续追无信号，下一步是将上板 `.bit` SHA-256 与最终 route/build 审计对齐，并在同一 `video_clk` 下获取 `axis_s_valid/user/last/ready`、`hdmi_video_locked` 与 PHY/TMDS 活动的短波形，再和成功基线对照；根因仍未确定。

## 证据来源及限制

源码审计另运行独立 Icarus 模型，细节见 `audio_model/run.log` 和 `audio_model/tb_audio_rate.v`；此模型结果只证明指定 RTL/参数下的模拟行为。其余只读源码与定向构建证据包括 axis_probe `top_tf_hdmi_audio.v`、`player_axis_input_probe.v`、`player_status_monitor.v`、`video_rgb_to_axis_640x480.v`、audio source modules、PLL/SDC、HDMI wrapper 加密接口文件，实际候选 `build/manual/AC201_tf_hdmi_pr.timing`/`.ts` 和 `final_build_review.json`；对 osd_phy_fix 对应源做差异和 SHA-256 核验。旧 `src/td_project/final_timing.rpt` 已识别为遗留报告，不用于最终候选时序结论。已有模型报告可佐证 converter 的 LAST=0 预期，但以测试像素源代替 SDRAM，且不覆盖加密 HDMI 核、板级时钟/供电；它不是上板证据。没有读取或导出完整综合网表。
