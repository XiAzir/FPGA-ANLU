# dynamic_text_video_probe 启动/物理只读审计

日期：2026-10-09。未改生产 HDL、`.al`、约束、检查点或 bit；未重新综合、布局布线或生成候选。仅从最终 route DB 导出 Verilog 到本目录作静态检查。

## 结论

根代理从用户视频提帧解读到同一失败运行约 12.2 秒的 `1C000000`：`sys_pll_lock=1`、`video_pll_lock=1`、`rst_all=0`、`card_init_done=0`；约 0.35 秒帧为 `79000000`。约 14.2 秒另一帧为 `31000000`：`audio_valid=0`、`tone=0`、`underflow=0`、`HDMIcore_locked=0`、`frame_seen=1`。这支持“两 PLL lock 高、全局 reset 低，AXIS 帧起始曾到达”，不证明 reset 的所有复制网均已释放，也不证明视频连续运行；HDMI core 自身报告未锁定。用户报告显示器显示“无信号”，但没有实测 HDMI 差分载波，因此不能将其表述为已证实物理上完全无载波。四灯全灭本身不能反推 reset：`player_audio_probe.v:80–81` 在 WAV 模式下以低有效 LED 显示四个锁存事件，事件全为 0 时 `led=4'b1111`，板上即全灭。

`card_init_done=0` 单独不能解释用户报告的显示器“无信号”。最终路由网表中 `HDMI_CLK_P` 由 serializer ODDR 和 125 MHz 串行时钟驱动，PAD reset 接 `rst_all` 的复制网（`AC201_tf_hdmi_pr_routed.v:13642–13662`）；status 的 `rst_all=0` 不证明此复制网及所有相关 reset 均已释放。结合 `HDMIcore_locked=0` 与 `frame_seen=1`，当前是“PLL lock 高、全局 reset 低、AXIS 帧起始曾到达，但 HDMI core 未锁；显示器报告无信号”的待解释状态。网表只证明连接关系，尚无 HDMI_CLK 差分载波、TMDS 数据、reset 复制网或连续帧的实测。

## 已证实的构建与时钟链

- `AC201_player_dynamic_text_video_probe.bit` SHA256 为 `1EFEB04BD50035789E4EBD1430B3CB8736B0F48D93DAF24FD4013AB8130F30DF`，与待审位流相同。80 项 build source scope 哈希全匹配；`src` 的 84 个文件逐一与冻结 checkpoint 相同。
- `.al` 将 `top_tf_hdmi_audio.v`、`player_dynamic_text.v`、`player_video_source_probe.v`、`pin.adc`、`timing.sdc`、sys/video PLL IP 纳入工程（`.al:55,402–430,465–478`）。综合日志报告 55 个源文件成功分析，且分别 elaborate `top`、两个 PLL、新 probe 和动态文字模块（`synthesis_console.log:154–174,214`）。新 probe 不接 SD/reset/PLL。
- PLL 实际参数由 routed DB 确认，不只依赖 `.ipc`：SYS PLL routed cell 为 `REFCLK_DIV=1`、CLKC0/1/2 DIV=20、相位 0/0/144°，refclk=`clk_dup_1`、reset=0、extlock=`sys_pll_lock`、反馈=`u_bmp_file_mapper/clk`（`AC201_tf_hdmi_pr_routed.v:15598–15684`）；video PLL 为 REFCLK_DIV=2、CLKC0 DIV=40、CLKC1 DIV=8、反馈=`u_status_monitor/sys_clk`、extlock=`video_pll_lock`（`:209670–209756`）。最终 STA 时钟表实际列出 `sd_card_clk=50MHz`、`video_clk=25MHz`、`hdmi_5x_clk=125MHz`、覆盖 99.97%（`AC201_tf_hdmi_pr.timing:1–44`）；PLL/GCLK 坐标与成功基线的最终 PR 报告相同（SYS PLL x000y071/GCLK x001y070z2；video PLL x000y000/GCLK x001y001z2）。路由日志报告已导入 timing/IO constraints（`physical_console.log:30–34`）。这证明实现数据库中时钟链存在，不证明实板 HDMI 输出波形。
- 顶层 `rst_all` 在 `top_tf_hdmi_audio.v:141–165` 以输入 `clk` 计数，只有两路 lock 同时为 1 后才计满 1,000,000 周期再释放；status 的 `status_reset_pipe` 独立由 `rst_n` 异步置位并在 `video_clk` 同步释放（`:121–128`）。现场 `1C000000` 与该状态机预期一致。

## SD/HDMI IO 与变化范围

- 工程设备为 EG4S20BG256，`pin.adc` 被 `.al` 注册且物理阶段导入 IO constraints。源映射是 clk K14、rst_n H14、SD `sd_dclk` M2 / `sd_mosi` L3 / `sd_miso` K6 / `sd_ncs` R2，HDMI P 对 B10/D11/C11/F10（`pin.adc:2–17`）。最终 routed Verilog 中这些 ports 均连接 EG_PHY_PAD；例如 HDMI_CLK_P serializer/125MHz/复位到 PAD 为 `:13642–13662`，SD_DCLK/MISO/MOSI/NCS PAD 为 `:15403–15474`。时序报告也从 K14 进入两个 PLL。静态证据不能确认板上 SD/HDMI 引脚实际电平或差分波形。
- `sd_card_top` 以 `sd_card_clk` 和 `rst_all` 驱动命令与 SPI（`top_tf_hdmi_audio.v:395–403`）；SPI 初始化低速分频参数默认 248、CPOL/CPHA=1（`SD/sd_card_top.v:4–5,111–123`）。状态字报告 `rst_all=0` 但 `card_init_done=0`，更像初始化未收到/接受卡响应，而不是目录层或 WAV/BMP 播放阶段；状态字不能证明所有复制 reset 均释放。SD SPI 输入端外部时序与电气响应没有实测；不据此断言卡、接线或板上电路损坏。
- 与成功位流 `osd_phy_fix` 比，PLL `.ipc`、PLL `.v`、pin/sdc 文件哈希完全一致；SD `sd_card_top.v`、`sd_card_cmd.v`、`spi_master.v` 也逐字节一致。top 两处变化及新视频 probe 本身不触及 SD 控制器。routed 资源变化仅约 +113 slices（98.17% 对 97.02%），原基线本就高占用；不将资源占用或共有 `sdr_wrrd`/宏警告作为根因。route 初期因 >90% 利用率跳过自动 hold fix，但随后独立 `fix_hold` 阶段完成，最终 HWNS +0.024 ns、HTNS 0、setup WNS +0.505 ns/TNS 0（`hold_console.log`、`AC201_tf_hdmi_phy.ts`）。这说明报告模型内最终时序通过，仍不能替代外部 SD/HDMI 波形验证。

## 下一步最小证据

1. 同一位流保持运行，记录 7 段数码管启动自检 `01234567`、`88888888` 是否轮换，及后续 `1C000000`、`31000000` 是否稳定；状态页可补充观测，不单独证明 reset 复制网释放或连续视频。
2. 用高阻逻辑分析仪同时看 AC201 上 SD 的 NCS、DCLK、MOSI、MISO（R2/M2/L3/K6）：确认上电初始化时 DCLK 是否输出、NCS 是否拉低、MOSI 是否发送初始化字节、MISO 是否返回响应。这样能将 `card_init_done=0` 分成“FPGA 未发起/端口无活动”与“卡侧无响应”。
3. 若仍复现显示器报告“无信号”，用已知正常线缆/显示器或 HDMI 分析仪确认 HDMI_CLK 差分对是否有载波，并同步观察 `HDMIcore_locked`；载波、TMDS/接收端及 PAD/reset 复制网需分层判断。当前没有物理载波实测；status 的 `hdmi_locked` 是 HDMI core 内部状态，不能证明线缆有信号或无信号。

## 只读产物

本目录 `AC201_tf_hdmi_pr_routed.v`、`AC201_osd_phy_fix_pr_routed.v` 分别由已有最终 PR DB 经 TD `import_db` + `write_verilog` 导出；日志为 `dump_probe_routed.log`、`dump_baseline_routed.log`。未写回 DB。TD 版本 6.2.178840。
