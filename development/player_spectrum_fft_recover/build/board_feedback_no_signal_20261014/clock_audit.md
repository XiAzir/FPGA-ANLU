# C11309 / C11310 时钟与 HDMI 输入审计

日期：2026-10-14。只读审计；未运行 TD；未改生产源、检查点、位流、包或主记录。

## 结论

没有单一静态时钟根因足以确定解释 C11310 板上无信号。按主任务提供的板测：C11310 PCM 有效、frame_seen=1、hdmi_locked=0，tone/PCM 两模式相同。这指向视频/发送核锁定或输入协议附近；不能归因于 FFT 音频数据本身。

两版真实 routed 网表的时钟树和 PHY 连接均正常：3 个 EG_PHY_GCLK；125 MHz PLL CLKC1 经 serializer GCLK 到 lane I_serial_clk；HDMI_CLK_P 和 D0/D1/D2 均为 DDRX1 ODDR，输出时钟接 serializer GCLK。证据在每版 build/audit/routed_clock_route.md 和 build/audit/routed_implementation.v。

25 MHz→125 MHz 路径确实进入 routed STA。C11309、C11310 均有 video_clk -> hdmi_5x_clk 路径组，各 31 条路径，setup 最差分别 +4.008 ns、+5.244 ns，hold 均 +0.244 ns。报告全局 CC-From/CC-To=no 不代表这些跨频率路径未分析；报告明确列出了路径组，不过组名写 Same Domain，建议后续向 TD 报告语义核对。

最强的功能缺陷候选是共用两版的视频 AXI 源：TLAST 行计数疑似偏一拍，并且源端完全不处理 TREADY 背压。它直接位于 HDMI 核输入前，可能导致核无法锁定；但模块在两版相同，且本次没有运行仿真，因此它不能解释版本差异，也尚非已复现根因。

## 证据

### 时钟、PHY 与时序

- 两版 SDC 相同：基准 create_clock 50 MHz、derive_clocks、分别命名 video_clk 与 hdmi_5x_clk；注释明确两者同时运行且保持 PLL 固定关系，禁止 exclusive 或全局 false-path。文件 src/user_source/constraints_source/timing.sdc 第 1–11 行。
- PLL C0=25 MHz、C1=125 MHz，C0_DIV=40、C1_DIV=8，同一 PLL 输出。文件 src/user_source/hdl_source/ip/video_pll.v 第 18–24、44–63 行，两版相同。
- 顶层将 PLL 125 MHz 原始输出接 EG_LOGIC_BUFG，再接 PHY serializer 时钟。文件 src/user_source/hdl_source/top_tf_hdmi_audio.v 第 33–34、197–203、522–527 行。
- routed 审计报告明确列出 CLKC1 raw→u_hdmi_serial_bufg EG_PHY_GCLK→lane I_serial_clk、总 3 GCLK，以及四路 DDRX1 LVDS 输出。文件 build/audit/routed_clock_route.md 第 9–17 行，两版均通过。
- lane RTL 在串行上升沿采 pending_data、上升沿移位、下降沿取 S_shift_data[9:8] 再驱动 ODDR d1/d0。文件 src/user_source/hdl_source/lane_lvds_10_1.v 第 27–65、119–127 行。routed 审计核对正沿/负沿寄存器与 GCLK 时钟一致。
- C11309 routed timing：生成于 2026-10-14 19:29:37，STA coverage 99.98%，Slow/Fast Max/Min 均 yes；总 SWNS/HWNS +0.509/+0.030 ns。125 MHz 时钟 setup/hold +0.509/+0.188 ns、skew 0.326 ns、fanout 56。文件 build/manual/AC201_tf_hdmi_pr.timing 第 3–14、23–50 行。
- C11310 routed timing：生成于 2026-10-14 20:14:35，coverage 99.98%，Slow/Fast Max/Min 均 yes；总 SWNS/HWNS +0.236/+0.027 ns。125 MHz 时钟 setup/hold +0.633/+0.244 ns、skew 0.326 ns、fanout 49。文件 build/manual/AC201_tf_hdmi_pr.timing 第 3–14、23–50 行。全局最差 hold 裕量只有 27 ps，虽报告零违例，值得做实现回归；这不能单独证明板上故障。
- C11309 video_clk -> hdmi_5x_clk 组在 timing 第 15585–15605 行，31 条路径，setup +4.008 ns、hold +0.244 ns；C11310 对应第 16380–16400 行，31 条路径，setup +5.244 ns、hold +0.244 ns。最差路径均为 TMDS encoder 寄存器到 PHY S_pending_data，没显示采样违例。
- timing exception 文件只列 Gray 指针同步器 19.7 ns datapath-only max-delay 例外，18 条路径被 dominated；未看到 HDMI/像素到串行的 false-path。

### 视频 AXI 源缺陷候选

- 顶层把转换器 valid/user/last/data 连到 HDMI core 输入，ready 也接出：src/user_source/hdl_source/top_tf_hdmi_audio.v 第 460–468、499–503 行。但转换器模块无 ready 端口：src/user_source/hdl_source/video_rgb_to_axis_640x480.v 第 2–13 行。
- 转换器每拍令 valid=I_de、data=I_rgb，默认清 user/last：同文件第 35–38 行。若 core ready=0 时 valid=1，源端没有保持有效数据和边带信号的机制，违反常见 AXI-Stream 握手稳定要求。
- 行首检测时将 S_x_cnt 清零：同文件第 44–50 行；其余 active 像素才递增：第 53–54 行；last 则用该拍旧计数值等于 639 判断：第 57–59 行。对连续 640 像素行，末像素比较疑似晚一拍；若 DE 随即结束，该行可能无 TLAST。需小型 RTL 测试确认。
- 此 converter 两版完全相同，因此这是公共兼容性候选，而非 C11310 独有变化。

### 复位差异

- C11310 FFT analyzer 用异步 rst 断言、pixel clock 两级释放 fft_reset：player_spectrum_analyzer.v 第 52–59 行；该本地 reset 控制 analyzer 状态：第 323–327 行及第 431–433 行。
- HDMI core 和 PHY 仍共用顶层 rst_all：top_tf_hdmi_audio.v 第 492–527 行；rst_all 在 50 MHz 基准域等待 PLL lock 后释放：第 157–185 行。相关逻辑两版相同。未见 fft_reset 接入 HDMI reset 或 ODDR reset。

## 候选排序

1. 视频 AXI 源的 ready/backpressure 与 TLAST 时序：证据最具体且位于核输入前；需 assertion 仿真和 ready 计数确认后才能定性。两版同码，不能单独解释 C11309 与 C11310 差异。
2. C11310 布局后全局 hold 余量降至 +0.027 ns：值得多 seed 回归；125 MHz 专项 hold +0.244 ns、零违例，不足以证明硬件无信号由此导致。
3. FFT 局部 reset/5 位 FSM 影响 HDMI 时钟或复位：现证据较弱；其局部域和连线未触及 HDMI core/PHY reset，时钟树代码相同。

## 建议的本地失败/通过测试

1. 对 video_rgb_to_axis_640x480 写独立仿真 testbench，输入 480 行、每行 640 个 DE 像素；断言每行恰一拍 TLAST 且位于末像素、每帧首像素恰一拍 TUSER。覆盖连续行与最短消隐；当前 RTL 预计 TLAST 断言失败，修正后需通过。
2. 在 valid 像素期间随机拉低 ready 1–5 个 pixel clocks；断言 valid&&!ready 后 valid、data、user、last 稳定直至 handshake。当前 converter 无 ready 输入，预计失败。集成测试应只按 valid&&ready 计数，并确认 core 接受正确的 640×480 帧边界。
3. 两版做纯报告回归：检查 routed report 有 31 条 video_clk→hdmi_5x_clk 路径、无 hold/setup violations、保持 3 GCLK 与 DDRX1。跨至少 3 个 placement seed 观察最小 hold 变化；项目可自设 >0.10 ns 试行准入门槛，但不可声称它是器件规格。
4. 板测同步记录 ready/valid handshake 计数、TUSER/TLAST、frame_seen、hdmi_locked 和共同 reset。若输入序列合规而 locked 仍为 0，再查发送核复位窗口、接收端训练及差分物理波形；修正握手后恢复锁定则形成根因证据。

## 审计边界

依据两版源码、SDC、gate/routed timing/netlist 审计文件与主任务提供的板测状态。未解析加密 HDMI 发送核内部状态机，未执行 RTL 仿真、TD、示波器/眼图测量。AXI 协议问题是待复现的强候选，不是已证实板上根因；静态路由通过也不覆盖板端电气、抖动、接收器配置或电源问题。
