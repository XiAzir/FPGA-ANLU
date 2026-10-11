# dynamic_text 实板失败：物理实现与时序审计

日期：2026-10-09。审计只读两版既有工程、TD 报告/日志、约束与用户反馈；未重编译、未操作板卡。用户回退结果记录于 `development/player_dynamic_text/build/board_feedback_20261009.json`：动态字幕候选失败，同条件载入 `osd_phy_fix` 后恢复。失败观测包括 IMG 0/4、无 BMP 画面/默认 WAV、内部音阶严重失真；KEY1 模式切换和新字幕可见。

## 结论

没有从现有报告中找到能解释本次实板故障的确定性 setup/hold 违例。两版使用相同 PLL、HDMI lane/serializer、SD 读写及音频源代码；唯一源差异是顶层 RGB 链路接入新 `player_dynamic_text` 模块。整份网表与布局布线并不等价，新增逻辑改变了布线和资源密度，所以不能由内部 STA 通过推出实板等价。

当前 SDC 没有将像素与 serializer 时钟设为 exclusive：文件只创建 50 MHz 输入时钟并 derive/rename PLL 输出，没有 `set_clock_groups`、exclusive 或跨域 false-path 约束。两版最终报告均包含 `video_clk -> hdmi_5x_clk` 路径组，故这条关键内部跨时钟关系没有被整体屏蔽。报告给出的 25 MHz / 125 MHz 仍是按 50 MHz 参考输入和 PLL 参数推导，实物频率与 HDMI 接收端采样窗口未测。

最关键的约束缺口是 HDMI 外部 I/O：`AC201_tf_hdmi_chk.timing` 两版均报 4 个输入无 input delay（`key1`、`key2`、`rst_n`、`sd_miso`），14 个输出无 output delay，其中包括 `HDMI_CLK_P`、`HDMI_D0_P`、`HDMI_D1_P`、`HDMI_D2_P`。因此 99.98% coverage 只表征工具所纳入的内部时序端点，不能证明板级 TMDS 输出 skew/接收 setup-hold、电缆及实际 PLL 相位满足要求。检查报告还显示无未约束时钟、无未展开时钟组、无未约束路径；CDC Gray 地址有 19.7 ns datapath max-delay 例外，两版相同。

## 路径与数值

最终 hold 修复后：

| 报告 | osd_phy_fix | dynamic_text |
| --- | ---: | ---: |
| SWNS / STNS | 0.629 / 0 ns | 0.513 / 0 ns |
| HWNS / HTNS | 0.030 / 0 ns | 0.024 / 0 ns |
| STA coverage | 99.98% | 99.98% |

关键 `video_clk -> hdmi_5x_clk` 组各有 31 个端点，两版均无违例。成功版最差 setup slack 为 5.449 ns、hold 为 0.252 ns；失败版为 5.612 ns、0.260 ns。样例数据路径是 TMDS 编码寄存器到 `lane_lvds_8_1/S_pending_data_reg`；失败版的路径延时 2.151 ns（成功版 2.314 ns）。因此该组报告没有显示失败版内部 pixel-to-serializer 捕获更差。它也没有输出脚 output delay，不能代表板外接口检查。

路由阶段、hold 修复前，成功版 setup WNS/TNS 为 0.629/0 ns，hold WNS/TNS 为 -0.044/-0.194 ns（9 个违例端点）；失败版为 0.513/0 ns、-0.011/-0.036 ns（7 个端点）。原流程启用 `fix_hold`；修复后的两版报告 hold TNS 均归零。因此不能把路由前 hold 负值当成最终位流的未修复缺陷。失败版 `video_clk -> video_clk` 最差 setup 路径是 TMDS 编码寄存器到 packet monitor 的 `tone_bad_sec_reg[11]`，32.301 ns 数据延时、19 级逻辑、7.419 ns slack；这是有余量的内部路径，也不是 HDMI 输出脚测量。

动态版全局布局/布线有可见扰动：报告 fanout 中 `video_clk` 为 1619 对 1589，`hdmi_5x_clk` 为 61 对 59，`sd_card_clk` 为 3228 对 3210；route QoR 的 slices 为 9678/98.76% 对 9508/97.02%，wire length 为 2,518,448 对 2,382,528。此为布局实现改变的证据，不等于故障机制证明，也不能据此断言功耗原因。

## 时钟、复位、SD 与警告对照

`top_tf_hdmi_audio.v` 中 `sys_pll` / `video_pll` 实例、参数和 `rst_all` 生成段在两版一致；`sys_pll.v`、`video_pll.v`、`lane_lvds_10_1.v`、SD/WAV/BMP 播放模块、`timing.sdc` 哈希与 source-delta 清单相符（73 个原文件不变，只有 top 改动并新增动态字幕模块）。`video_pll` 仍由 50 MHz 输入产生 25 MHz pixel 与 125 MHz serializer 时钟；`rst_all` 在 PLL lock 后等待 1,000,000 个 50 MHz 周期，再由 `clk` 域释放，并被多个时钟域模块作为异步复位使用。新模块将该复位加到像素域字幕寄存器。复位拓扑未见顶层 RTL 改动；但板上相位、释放瞬态、MTBF 均无实测证明。

两版综合日志都有 34 条 warning 实例；`sys_pll/video_pll` optional `open`、`PLL_open*` 未声明符号提示及 PLL 参数相同，没有看到新增 PLL/IO/reset 综合 warning。`PHY-7002` SDRAM hard-macro location 未采纳警告需要按候选尝试区分：所选成功 `attempt_timing_high_routability` 日志为 0 条；成功目录的其他尝试曾出现 1 条（坐标 12,12 或 164,288）及 6 条（两坐标均有）；dynamic_text 最终日志出现 3 条（12,12 一条、164,288 两条）。警告本身只说 ECO placement 的请求位置不合法并会搬移，没有给出最终落点。相似搬移警告在成功尝试也存在，不能单独解释失败。

IMG 0/4 不能直接推断 TF 挂载失败。冻结的 `player_osd.v` 在 `image_valid` 为假、index/count 越界或 count 非 1..4 时显示 0/总数；顶层还在 `osd_frame_valid` 为假时把底图清零。因此可见 0/4 表示像素端 OSD 当前拿到无效帧状态/元数据，但未区分 `frame_valid`、image index/count、文件读取或跨域提交哪一段异常。

## 证据边界与下一步判别

用户同条件回退证明故障与动态候选位流相关，但不证明新字幕 RTL、PLL、reset 或某一宏搬移是唯一原因。默认 WAV 消失与内部 tone 严重失真同时发生，优先沿共用 HDMI packet/lane/clock/reset 终点查，不把原因归结为 TF/WAV 文件；IMG 0/4 单独仍需分辨源帧 valid 和状态 mailbox。现有模型/STA不是实板采样，未读取失败板上的 `frame_valid`、BMP/WAV 错误旗标、PLL lock、HDMI pixel/包计数，也没有 lane/clock 引脚波形或外部 output-delay 约束。

后续若继续定位，应在失败/成功两位流同条件下取得同一组信号：`fs_ready/fs_error`、`display_valid/osd_frame_valid`、`osd_image_index/osd_image_count`、`wav_primed/wav_error`、HDMI `audio_valid` 与 packet monitor 计数，以及 pixel/serializer PLL lock；再对 HDMI CLK/D0-D2 做接收端/示波器波形比较。先按信号区分“源帧/音频未到发送器”与“发送器/物理接口失真”，再决定是否需要改 HDL/约束。禁止用本审计断言已找到物理根因。

## 2026-10-09 现场遥测与 SD SPI 输入时序补充

根代理提供的同条件失败版现场读数为默认页 `1d950007`、LED 四灭：PLL locks=1、rst_all=0、card_init=1；fsready=1、fserror=0、displayvalid=0、bmperror=1、wavprimed=0、waverror=1、bmpmaperror=0、wavmaperror=1，WAV map 状态 `07` 解码为 `E_EOC`（簇链过早结束）。这证明卡初始化/目录挂载成功，BMP/WAV 数据读取或解析路径报错；不能据此称卡损坏，也不与同卡旧版正常相矛盾。WAV 未 primed 可解释默认音乐未启动，但不能解释独立的内部测试音阶失真。

两版 `timing.sdc` SHA256 相同：`977ABCDB8B6C4DF93CBD8FE407D5DFA5AB2710CE45214D7713F583F91A732146`。两份 `AC201_tf_hdmi_chk.timing` 均将 `sd_miso` 列为缺少 input delay 的 4 个输入之一；没有为 SD_DCLK/MISO 加入板级 source/output delay 采样预算。综合/布局时序报告没有为 MISO 输入到 `spi_master.MISO_shift` 生成可用于版间比较的外部 setup/hold 裕量，因此现有STA不能证明或排除SPI采样边沿/裕量问题。

两版 `SD/spi_master.v` SHA256相同：`37F7A21144FA5CCA3CC5C3B5F68A5AD40B3108336B600E45A1367734AC61403C`；采样均在 `posedge sys_clk`、`state==DCLK_EDGE` 且按 CPHA/边沿计数更新 `MISO_shift`。两版物理分配同为 `sd_miso` K6/LVCMOS33/PULLUP，`sd_dclk` M2、`sd_mosi` L3、`sd_ncs` R2，管脚和 I/O 标准无差异。硬件失败点更应结合 `fsready=1` 与文件错误状态定位簇链/数据读取控制；不能因 MISO无延迟约束就单独认定它是原因。

动态候选新增像素域 OSD 后，已有 route 摘要显示总切片 9508→9678（97.02%→98.76%）、总线长 2,382,528→2,518,448（+5.7%），`sd_card_clk` fanout 3210→3228（+18，约+0.56%）。这是跨模块物理实现改变的量化证据，支持把布局/布线耦合作为后续检查方向，但无SD路径延迟、MISO采样眼图或差分实测，无法证明共享控制/packing触发了故障。现场 `E_EOC` 使SD读出/簇链逻辑比这一布局假设更直接，内部tone失真仍需按独立发送链路径判别。

边界：上述现场状态由代理转述，非本次直接连接硬件采集；本次没有重建、改RTL、改约束或操作板卡。后续如有调试窗口，优先在两版下同条件记录 SD_DCLK 上升/下降沿与 MISO 稳定窗口、初始化命令/读扇区响应及实际SPI分频；再对照 `E_EOC` 首次置位时的簇号/扇区/目录项。现有资料不足以给出MISO setup/hold数值或确认根因。
