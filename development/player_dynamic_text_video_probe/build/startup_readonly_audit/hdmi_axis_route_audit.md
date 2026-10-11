# HDMI AXIS→core→monitor/PHY 路由网表续审

日期：2026-10-09。只读检查前一审计从已有 candidate / osd_phy_fix 最终 PR DB 导出的 routed Verilog；未改生产资产，也未重新构建。

## 本次冷启动实板证据（根代理转述）

同一 probe 位流冷启动后，默认四灯全亮、显示器仍报告无信号；status `1DA80000` 解码为两 PLL lock=1、rst_all=0、card_init_done=1，文件状态包含 fs_ready/display_valid/wav_primed=1、error=0。长按 KEY1 后 D3 闪、D2/D1/D0 亮，页仍为 `1DA80000`。这是新运行，不能套用先前运行的 packet flags/core lock 值；本节只针对该次报告继续只读核对 HDMI 物理实现路径。

## AXIS 接口与 TLAST

- 当前 top 将 `video_rgb_to_axis_640x480` 的 `axis_s_user/valid/last/data` 接到加密 `hdmi_1_4b_transmitter_core_wrapper`（`src/user_source/hdl_source/top_tf_hdmi_audio.v:406–449`）。converter 同时复位、时钟在 `video_clk`（top:406–410）；其 RTL 在 `video_rgb_to_axis_640x480.v:33–37` 每拍把 `I_de` 注册为 `O_video_valid`，并默认清 `O_video_last`；计数器在 active-DE 首像素置 0，随后递增（`:44–56`），仅当旧值为 639 时置 last（`:58–59`）。对恰好 640 像素的 active line，首像素旧计数为 0，640th active pixel 旧值为 638；旧值 639 要到第 641 个 active pixel 才出现，故每行 640 DE 时 last 不会置位。probe 与基线该 converter 源文件 SHA256 相同：`1C8FC26C789F87227036BEA034F1AB6FC5633F2AB2684BE422C54687A290FB96`。
- 两份最终 routed Verilog 中均找不到 `axis_s_last`、`I_axis_s_last`、`O_video_last` 或 `S_x_cnt`，也没有独立 `axis_s_valid`/`axis_s_ready` 路由名。像素 data 与 SOF/user 仍保留：candidate 顶层 `axis_s_data` wire 在 `:44`，写入 video FIFO 的 BRAM `dia(axis_s_data[..])` 在 `:121579,121611,121643`；`axis_s_user` 和 core 内部 SOF/line 相关逻辑在 `:5501–5503,120883–120891,140327`。该 FIFO 的 write enable 映射成 `u_dynamic_text/de_prev_syn_4`，时钟为 `u_status_monitor/sys_clk`（top 定义 `status_clk=video_clk`，`:122`），见 `:121573–121583`。baseline 对应 BRAM 使用 `u_osd/de_prev_syn_4`（`AC201_osd_phy_fix_pr_routed.v:120118–120126`）。这与各自上游“逐拍注册 DE”的实现相符；RTL 中 valid 和相应 de_prev 都在相同时钟/复位下延迟一拍，因此 valid 的独立 net 名被折叠并不等于像素 FIFO 写使能消失。
- exported route 中没有存活的 x-count/last net，因此可确认实现网表没有可识别、可探测的独立 TLAST 路由链；仅凭这个 flattened dump 不能区分该输入被常量传播后删除，还是加密 core 对该端口不依赖/工具消除了其逻辑，也不能从网表证明 `I_axis_s_last` 端口采到的常量值。根代理另据本地安路 APUG092 手册确认 `I_axis_s_last` 标记行末、ready 与 last 协作；这使 RTL 端每行缺 TLAST 成为协议层疑点，但当前网表本身尚不能证明它导致 `O_video_locked=0` 或显示器无信号。

## HDMI core、并行监视器与 PHY 的物理连接

- `top_tf_hdmi_audio.v:421–465` 令 core pixel clock=`video_clk`、reset=`rst_all`，输出 `tmds_ch0/1/2_data` 与 `tmds_clk_data`；PHY 在 `:468–481` 接相同的 pixel clock/reset、`hdmi_5x_clk` serial clock，并以同一四组 TMDS 并行向量驱动四条 serializer lane。被动 `hdmi_packet_monitor` 在 `:485–488` 监听相同 ch0/1/2 向量，不在 PHY 前串联；status monitor 在 `:495–499` 采 `axis_s_*` 和 `hdmi_video_locked`。
- routed 证据与此拓扑一致：candidate 的 video FIFO BRAM read outputs 直接映射至 core `hdmi_video_data_assemble` (`:121583–121615`)；PHY 的 `S_pending_data` 捕获逻辑中可见 packet monitor 的同名 ch0/ch1/ch2 像素向量作为数据源（例如 `:101113–101146,101387,101684`），与 monitor 只旁路观察、PHY 共享该并行数据支路相符。随后 PHY ODDR lane 数据接 PAD：`HDMI_D0_P` `.do` 用 lane0 的 `S_oddr_data`、`osclk=I_serial_clk`、`rst=startup_flags[1]`（`:13689–13692`）；D1/D2 与 CLK 同结构（`:13658–13754`）。这些是实际 routed PAD cell，不只是源码连接图。
- route 时钟一致：视频 FIFO/像素域以 `u_status_monitor/sys_clk` 为时钟，而 source 明确 `status_clk=video_clk`；串行 PAD `osclk` 来自 `u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk`（candidate `:13660–13662`），此前 PR netlist PLL 参数/输出映射已确认来自 video PLL 125 MHz lane 时钟。外部 25/125 MHz 波形仍未上板实测。
- reset 一致性：top 在 converter、HDMI core、PHY、monitor 四处均传 `rst_all`（上述 top 行）；routed PAD `.rst` 使用 `u_status_monitor/startup_flags[1]_dup_4612`（`:13661`），该信号由 `clk_dup_1` 下寄存器从 `rst_all_reg_reg_syn_3` 复制（`:15041`）。core 的 `u0_reset_sync` 又有自己的同步 reset 状态；例如同步后 `I_rst_dup_26` 由其寄存器输出（`:102175–102184`）。静态拓扑没有发现断开的 reset/时钟输入，但 status 的 `rst_all=0` 不能证明所有复制/同步 reset 在实板上的波形与时序，也不能证明各 lane 已完成有效串化。

## 判断与边界

这次冷启动状态中 `card_init_done=1`、`display_valid=1`，因此前次“SD未初始化”停点不适用于当前无信号复现。两版最终路由的 AXIS data、frame/user、core→旁路监视器/PHY、PLL lane clock 与 reset 拓扑均未显示明显断接；RTL 的 TLAST 每行缺失是仍需独立验证的协议差异，但路由导出没有独立 last 消费链，无法定因。status 的 HDMI `locked` 是 HDMI core 输入视频相位校准状态，不是 PLL-lock 或 HDMI 物理载波测量。

最小后续判别：等待当前运行 `3/6/8/9` 页并对齐同一运行的 core lock/packet flags；TLAST 仅按独立协议模型结果进入单项候选，不把模型或 clean STA 当实板根因。若已确认 core locked=0，再以 core model/TLAST 单项证据解释内部锁定；若 core locked=1 仍无画面，再单独测差分时钟/数据载波与显示器接收状态。

