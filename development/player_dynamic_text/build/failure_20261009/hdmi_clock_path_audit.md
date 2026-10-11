# 2026-10-09 HDMI monitor、时钟与约束只读审计

## 结论

两套最终 routed timing 报告均正确识别 `video_clk=25 MHz` 与 `hdmi_5x_clk=125 MHz` 的关联时钟，并且报告覆盖了 HDMI core → packet monitor 和 HDMI core → serializer 的视频时钟路径。SDC 中没有 `set_false_path`、`set_multicycle_path` 或 exclusive clock-group；最终 exception 报告只列出异步 FIFO Gray 指针的 18 条 `set_max_delay -datapath_only 19.700 ns` 检查，未发现 HDMI core/monitor 路径被错误放宽或切除的证据。

有两个可确证的验证缺口/结构风险：其一，`HDMI_CLK_P`、`HDMI_D0_P`、`HDMI_D1_P`、`HDMI_D2_P` 均没有 output delay，故 STA 没有验证 FPGA 到 HDMI 接收端的板级源同步时序；其二，`lane_lvds_10_1` 的像素域及串行域状态机直接使用顶层 `rst_all` 作异步复位，未在两个本地域分别同步释放。两项都存在于成功的 `player_osd_phy_fix` 基线和失败的 `player_dynamic_text` 候选中，不能单独解释动态字幕版与回退版的差异。

数码管页 3/6/7 的 BCH、TERC、CTS/N 观测来自 core 并行 TMDS 字的被动 monitor，采样时钟与 core 输出寄存器同为 `video_clk`；monitor 没有观察 serializer 后的位流或 HDMI 接收端。因此页 3 的“高质量 tone”表示输入播放源选择为 tone，不等于已验证传输；BCH/TERC 计数和 CTS/N=0 暗示 monitor 没有持续识别有效的 ACR/音频包，但目前无法区分 core 真实输出异常与 monitor 解码/起始定位错误。没有原始 TMDS 样本/外部 HDMI 抓包，不能据此定根因。

## 时钟与物理路径核对

- 两版本 `src/user_source/constraints_source/timing.sdc` 内容一致：50 MHz 板载 `clk` 上执行 `derive_clocks`，再将 `sys_pll_m0/pll_inst.clkc[0..2]` 和 `video_pll_m0/pll_inst.clkc[0..1]` 分别命名为 `sd_card_clk`、`ext_mem_clk`、`ext_mem_clk_sft`、`video_clk`、`hdmi_5x_clk`。SDC 明确写明像素/串行时钟同时运行且具固定 PLL 关系，不应设 exclusive 或为了 Timing Clean 屏蔽跨域路径。
- `video_pll.v` 配置 50 MHz 输入、C0=25 MHz、C1=125 MHz、两输出相位均为 0°。两份 `AC201_tf_hdmi_pr.timing` 的 Clock Summary 均列出 `video_clk 25.000 MHz`、`hdmi_5x_clk 125.000 MHz`，`AC201_tf_hdmi_chk.timing` 均报告 0 个未连接 master 的 generated clock。因而这两时钟在实现 STA 中不是漏建的独立时钟。
- 两版 routed timing 的 `video_clk -> hdmi_5x_clk` 路径均覆盖 31 个 endpoint。动态版代表路径从 core `u0_hdmi_tmds_encode/O_tmds_code_data_reg[1]` 到 `u0_lane_lvds_8_1/S_pending_data_reg[8]`，走线上的 TMDS 数据由串行域寄存器采样；budget=8 ns、data path=2.151 ns、setup slack=5.612 ns、clock skew=0.021 ns。动态版此组 min/hold 最差余量为 +0.260 ns；基线对应 setup slack +5.449 ns、hold +0.252 ns。此报告没有显示该同步数据路径被 multicycle/false-path 掩盖，也没有显示候选版相对基线变差。
- 同一最终 routed 报告中还存在 `hdmi_5x_clk -> hdmi_5x_clk` 自时钟路径；动态版串行域 clock summary fanout 61，基线 59。动态版 overall SWNS/HWNS 为 +0.513/+0.024 ns，基线 +0.629/+0.030 ns。总 setup/hold 余量略低，但仍为正；这仅说明现有约束下的寄存器路径通过，不能证明外部 HDMI 电气/接口时序。
- 两版 `hdmi_packet_monitor.v` 与 `lane_lvds_10_1.v` SHA-256 相同；core wrapper 为加密 IP。最终 gate timing 中可见 core 内部 `u0_reset_sync/O_sync_reset_reg` 等像素时钟寄存器，且 core/monitor 路径归入 `video_clk -> video_clk`。动态版及基线的 timing 路径均有 core `O_tmds_code_data_reg` 到 `u_packet_monitor` 寄存器端点，说明 monitor tap 不是遗漏时钟的异步输入路径。monitor 在顶层接 `.clk(video_clk), .rst(rst_all)`，内部仅用 `always @(posedge clk)` 同步检查 `rst`。

## 约束例外与板级边界

- 两版本 `AC201_tf_hdmi_exception.timing` 的唯一例外均为两条报告实例（同一约束的 max/min check 汇总重复列示），目标为 `*/primary_addr_gray_reg[*]` 到 `*/sync_r1[*]` 的 datapath-only 19.700 ns。其作用是限制异步 FIFO Gray 指针到第一级同步寄存器的总线偏斜；没有任何 HDMI/monitor hierarchy 命中。exception summary 的 18 条路径全部 dominated，0 条 ignored，min check 没有放宽路径。
- 两份 `AC201_tf_hdmi_chk.timing` 都报出 14 个无 output delay 的端口，其中包括全部四个 HDMI TMDS 正端 `HDMI_CLK_P`、`HDMI_D0_P`、`HDMI_D1_P`、`HDMI_D2_P`。因此当前 `STA coverage 99.98%` 不能解读为 HDMI 插座输出的板级接口时序已验证。SDC 也未给 HDMI lane-to-forwarded-clock 的外部接收器建立/保持或通道间偏斜预算。
- 这项 output delay 缺失可以解释“为何 STA 通过仍不能证明显示器输入端的时序质量”；它无法直接解释内部 monitor 在 serializer 之前统计到的 BCH/TERC 错误，因为该数据尚未走过 HDMI 输出端口。它也不能独自证明 bitstream 输出一定有问题。
- `.pr.timing` 与 `.gate.timing` 是路由/门级路径摘要，工程未保存可读的完整展开 implement Verilog；HDMI core wrapper 本身受加密保护。审计没有解密或重建 vendor core，也没有运行仿真/综合。

## 复位和 monitor 的证据边界

- `lane_lvds_10_1.v` 中 `S_odd_even` 用 `posedge I_pixel_clk or posedge I_rst`；`S_pending_data`、`S_shift_data` 用 `posedge I_serial_clk or posedge I_rst`。`I_rst` 直接连 `rst_all`，而顶层 `rst_all_reg` 在原始 50 MHz `clk` 域释放。异步断言本身合理，但释放对像素域与 5x 串行域没有各自的本地同步器，存在 recovery/removal/首字对齐风险。此风险在两版源码相同，STA 的普通 setup/hold summary 不能排除复位释放瞬间的亚稳态。
- `hdmi_packet_monitor` 与 core 都以 `video_clk` 为主时钟；monitor 自身复位条件同步采样，core 收到相同 `rst_all` 后另有内部 reset synchronizer（门级 timing 命名可见，但私有 core RTL 不可读）。启动后，TMDS 并行字到 monitor 以及到 serializer 的路径被实际 STA 分析。没有证据显示 monitor 使用错误时钟或被例外约束隐藏。
- monitor 只从 `tmds_ch0_data/ch1_data/ch2_data` 采样 core 并行字，位于 PHY 的位序翻转前。页 6/7 BCH 高计数、TERC 错误和 CTS/N=0 说明 monitor 按自身协议解析器未能验证出足够的有效包；但不能直接等同于 sink 端线缆误码。需要一份同步的三路 10-bit 并行字/`video_clk` 捕获，与已知正确 ACR+audio packet 编码对照；如果该序列合法但 monitor 仍计错，修正 monitor 的 preamble/guard/packet/BCH 解码及统计；若不合法，再逐项查 core 输入 `audio_valid`、`acr_valid`、CTS/N 和复位解除后首包。

## 有边界的修复与验证建议

1. **输出约束补齐（验证范围修复）**：从 AC201 原理图、连接器/电平标准和显示端要求取得 TMDS 时钟/数据的输出延迟及通道偏斜预算，再以 forwarded TMDS clock 约束四个差分通道；确认工具报告不再把四个 HDMI 正端列为 missing output delay，并检查 routed setup/hold。没有真实预算前不要杜撰固定数值。这让 STA 覆盖接收端时序，不能修复内部 packet monitor 的坏包。
2. **复位释放 A/B（有限 RTL 候选）**：只在 `lane_lvds_10_1` 的 pixel 与 serial clock 域分别加入异步断言、同步释放的本地复位，保持现有 25/125 MHz 数据节拍和 8 ns 捕获相位；先用两个随机复位相位模型验证 `S_odd_even`、load pulse、首个 10-bit word 和 ODDR 开始相位，再同条件对比两版 bit。因为两版本都存在同样结构，结果要通过同卡 A/B 才能证明其与失败相关。
3. **优先验证 monitor 读数**：同一时刻捕获 core 输出三路 10-bit 数据与 `video_clk`，独立解码一个 tone ACR/audio island，分别重算 BCH、TERC4 与 `CTS/N`，并同页面计数逐项核对。不要基于现有计数直接调整 PLL 相位或重新摆放宏。

本次只读检查没有发现 HDMI core/monitor 的时钟遗漏或被 false-path/multicycle 错误放宽的具体证据。最具体的 SDC 漏洞是 HDMI 输出无外部 output delay；最具体的 RTL 结构风险是 serializer 两个相关时钟域直接共享未同步释放的异步复位。它们都只是候选验证项，不能在没有 raw parallel TMDS/物理波形和条件化 A/B 之前宣称为这次失败根因。
