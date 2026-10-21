# C11315 serializer clock / routed netlist audit

Synthesis run ID: `6410681c-a26d-4db7-93ef-d6cb9b95279a`
Generated: 2026-10-21T10:37:54+08:00
Netlist input: `E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_spi12p5\build\audit\routed_implementation.v`
Timing input: `E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_spi12p5\build\manual\AC201_tf_hdmi_pr.timing`
Netlist stage: routed

## Checks

- **INFO** — netlist SHA256=62750901207528e518b6e73644e9a984e67ef235f696e54d698f28ce3a33c130
- **INFO** — PLL clkc1 raw=hdmi_5x_clk_raw
- **INFO** — GCLK 数量=3；实例=\sys_pll_m0/bufg_feedback, u_hdmi_serial_bufg, \video_pll_m0/bufg_feedback
- **PASS** — EG_PHY_PLL \video_pll_m0/pll_inst 的 clkc[1] 映射为 hdmi_5x_clk_raw
- **PASS** — clkc1 raw → u_hdmi_serial_bufg EG_PHY_GCLK → \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk
- **PASS** — 物理网表保留 3 个 EG_PHY_GCLK（含 serializer buffer）
- **PASS** — HDMI_CLK_P: ODDRMODE=DDRX1, IOTYPE=LVDS33_E
- **PASS** — HDMI_CLK_P.osclk=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk（serializer GCLK 输出）
- **PASS** — HDMI_D0_P: ODDRMODE=DDRX1, IOTYPE=LVDS33_E
- **PASS** — HDMI_D0_P.osclk=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk（serializer GCLK 输出）
- **PASS** — HDMI_D1_P: ODDRMODE=DDRX1, IOTYPE=LVDS33_E
- **PASS** — HDMI_D1_P.osclk=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk（serializer GCLK 输出）
- **PASS** — HDMI_D2_P: ODDRMODE=DDRX1, IOTYPE=LVDS33_E
- **PASS** — HDMI_D2_P.osclk=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk（serializer GCLK 输出）
- **PASS** — lane0 sync: 1 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane0 load_en: 1 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane0 pending_data: 9 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane0 shift_data: 9 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane0 oddr_data: 1 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=INV; 有效边沿/时钟匹配
- **INFO** — lane1 sync: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **INFO** — lane1 load_en: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **PASS** — lane1 pending_data: 7 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane1 shift_data: 6 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane1 oddr_data: 2 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=INV; 有效边沿/时钟匹配
- **INFO** — lane2 sync: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **INFO** — lane2 load_en: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **PASS** — lane2 pending_data: 7 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane2 shift_data: 9 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane2 oddr_data: 1 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=INV; 有效边沿/时钟匹配
- **INFO** — lane3 sync: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **INFO** — lane3 load_en: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **PASS** — lane3 pending_data: 1 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane3 shift_data: 3 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane3 oddr_data: 1 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=INV; 有效边沿/时钟匹配
- **PASS** — lane aggregate sync: 1 explicit register cell(s)
- **PASS** — lane aggregate load_en: 1 explicit register cell(s)
- **PASS** — lane aggregate pending_data: 24 explicit register cell(s)
- **PASS** — lane aggregate shift_data: 27 explicit register cell(s)
- **PASS** — lane aggregate oddr_data: 5 explicit register cell(s)
- **PASS** — seg7_dio.osclk=\u_bmp_file_mapper/clk（system PLL GCLK 输出）
- **PASS** — seg7_sclk.osclk=\u_bmp_file_mapper/clk（system PLL GCLK 输出）
- **PASS** — seg7_rclk.osclk=\u_bmp_file_mapper/clk（system PLL GCLK 输出）
- **PASS** — mailbox source/video: 28 FF cell(s), CLK=\u_status_monitor/sys_clk
- **PASS** — mailbox destination/system: 28 FF cell(s), CLK=\u_bmp_file_mapper/clk
- **PASS** — source manifest 与当前源文件一致；scopeHash=d98ec19ee7bba0c5a8f264fe221654bbf1599ab2fdc10c0496ed50d74d2dd453
- **PASS** — synthesis evidence PASS：runId=6410681c-a26d-4db7-93ef-d6cb9b95279a
- **PASS** — gate database hash 匹配：03eeea815d47ac440ac787ce23b19fa835736df331a1e492915af3a909ada7e0
- **PASS** — physical evidence success; synthesisRunId/gateDbHash/scopeHash 匹配
- **PASS** — timing report hash 匹配 physical evidence：AC201_tf_hdmi_pr.timing
- **PASS** — HDMI_CLK_P: DDRMODE/IOTYPE/reset 与 C11308 基线一致 (reset \u_status_monitor/startup_flags[1]_dup_4309 → \u_status_monitor/startup_flags[1]_dup_3059)
- **PASS** — HDMI_D0_P: DDRMODE/IOTYPE/reset 与 C11308 基线一致 (reset \u_status_monitor/startup_flags[1]_dup_4309 → \u_status_monitor/startup_flags[1]_dup_3039)
- **PASS** — HDMI_D1_P: DDRMODE/IOTYPE/reset 与 C11308 基线一致 (reset \u_status_monitor/startup_flags[1]_dup_4309 → \u_status_monitor/startup_flags[1]_dup_3059)
- **PASS** — HDMI_D2_P: DDRMODE/IOTYPE/reset 与 C11308 基线一致 (reset \u_status_monitor/startup_flags[1]_dup_4309 → \u_status_monitor/startup_flags[1]_dup_3039)
- **PASS** — timing summary 属于 C11315，SHA256=921188fea5dd2c4e719bf3e7dc874feff5e63b4fbb3dfdb00c157a259c4a62a2

## Clock topology

| Item | C11308 baseline | C11315 input |
|---|---|---|
| Netlist SHA256 | 897387353dcd78eb2489926e7d67543ac58b756ec1ca054cc4b91bb23d5f6d7b | 62750901207528e518b6e73644e9a984e67ef235f696e54d698f28ce3a33c130 |
| PLL clkc[1] raw | \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk | hdmi_5x_clk_raw |
| serial clock after buffer | \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk | \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk |
| EG_PHY_GCLK count | 2 | 3 |
| pixel clock GCLK output | see baseline netlist | \u_status_monitor/sys_clk |
| system clock GCLK output | see baseline netlist | \u_bmp_file_mapper/clk |

GCLK cells:

- `\sys_pll_m0/bufg_feedback`: `\sys_pll_m0/clk0_buf` → `\u_bmp_file_mapper/clk`
- `u_hdmi_serial_bufg`: `hdmi_5x_clk_raw` → `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk`
- `\video_pll_m0/bufg_feedback`: `\video_pll_m0/clk0_buf` → `\u_status_monitor/sys_clk`

## HDMI PAD comparison

| Output | Old mode/type/reset | New mode/type/reset | New osclk |
|---|---|---|---|
| HDMI_CLK_P | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4309` | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_3059` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` |
| HDMI_D0_P | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4309` | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_3039` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` |
| HDMI_D1_P | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4309` | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_3059` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` |
| HDMI_D2_P | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4309` | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_3039` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` |

## Lane register clock/polarity audit

Only explicit q/clk cell ports matching named lane register classes are checked; unrelated packed pins are not assumed to share one net.

| Lane | Register class | Cell | CLK | CLKMUX |
|---:|---|---|---|---|
| 0 | sync | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_odd_even_2d_reg_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | load_en | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_load_en_reg_syn_5` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[0]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[1]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[2]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[4]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[6]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[7]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[8]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[9]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[1]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[0]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[1]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[2]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[3]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[4]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[5]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[6]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[7]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[8]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | oddr_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_oddr_data_reg[0]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 1 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[0]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[1]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[2]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[3]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[5]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[6]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[8]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[0]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[2]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[4]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[6]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[8]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[9]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | oddr_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_oddr_data_reg[0]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 1 | oddr_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_oddr_data_reg[1]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 2 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[1]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[2]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[3]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[4]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[5]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[6]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[9]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[0]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[1]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[2]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[3]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[4]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[5]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[6]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[7]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[8]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | oddr_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_oddr_data_reg[1]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 3 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_pending_data_reg[5]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 3 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[9]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 3 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_shift_data_reg[7]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 3 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_shift_data_reg[9]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 3 | oddr_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_oddr_data_reg[1]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |

## Routed timing summary

| Report | Clock SWNS (ns) | Clock HWNS (ns) | hdmi_5x skew (ns) | Fanout | PAD do setup min slack (ns) | PAD do hold min slack (ns) |
|---|---:|---:|---:|---:|---:|---:|
| C11308 baseline | 0.120 | 0.030 | 0.326 | 53 | 2.705 | 未列出 |
| C11315 input | 0.157 | 0.011 | 0.254 | 54 | 2.741 | 未列出 |

Clock WNS/skew are routed clock-summary metrics. PAD `do[]` values include only endpoints explicitly listed by the timing report; ‘未列出’ means no such path was listed, not zero slack.

- Report SHA256: `921188fea5dd2c4e719bf3e7dc874feff5e63b4fbb3dfdb00c157a259c4a62a2`
- Constraint file: `E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_spi12p5/src/user_source/constraints_source/timing.sdc`
- Global timing: `{"SWNS": "0.157", "STNS": "0.000", "HWNS": "0.011", "HTNS": "0.000", "Period Check WNS": "0.000"}`
- hdmi_5x_clk row: `clk4           local            0.000      4.000                 8.000         125.000                 6.900         144.928            0.550      0.000            0.223      0.000            0.254               54                1             no       no`

PAD DDR input-register paths explicitly listed in the report:
- setup HDMI_CLK_P_syn_2.do[1] (rising edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 }); slack=2.741 ns; skew=0.277 ns; budget=4.000ns { hdmi_5x_clk rising@8.000ns - hdmi_5x_clk falling@4.000ns }; launch=u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_oddr_data_reg[1]_syn_4.clk (falling edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 })
- setup HDMI_D2_P_syn_2.do[0] (rising edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 }); slack=2.776 ns; skew=0.277 ns; budget=4.000ns { hdmi_5x_clk rising@8.000ns - hdmi_5x_clk falling@4.000ns }; launch=u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_oddr_data_reg[1]_syn_4.clk (falling edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 })
- setup HDMI_D1_P_syn_2.do[0] (rising edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 }); slack=2.811 ns; skew=0.277 ns; budget=4.000ns { hdmi_5x_clk rising@8.000ns - hdmi_5x_clk falling@4.000ns }; launch=u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_oddr_data_reg[1]_syn_4.clk (falling edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 })
- setup HDMI_D0_P_syn_2.do[1] (rising edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 }); slack=2.828 ns; skew=0.254 ns; budget=4.000ns { hdmi_5x_clk rising@8.000ns - hdmi_5x_clk falling@4.000ns }; launch=u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_oddr_data_reg[0]_syn_4.clk (falling edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 })

## Run and bit identity

- C11315 synthesis: status=`success`, runId=`6410681c-a26d-4db7-93ef-d6cb9b95279a`, scopeHash=`d98ec19ee7bba0c5a8f264fe221654bbf1599ab2fdc10c0496ed50d74d2dd453`, gateDbHash=`03eeea815d47ac440ac787ce23b19fa835736df331a1e492915af3a909ada7e0`
- C11315 physical: status=`success`, runId=`7b56c149-5846-47ba-aeaa-c40451ca9b89`, synthesisRunId=`6410681c-a26d-4db7-93ef-d6cb9b95279a`, gateDbHash=`03eeea815d47ac440ac787ce23b19fa835736df331a1e492915af3a909ada7e0`
- C11308 physical: status=`success`, runId=`ffbf0e8b-f787-4411-97db-32f71bc89edc`, synthesisRunId=`b0742bf6-1a65-4548-82d2-d82e2c3840d5`, scopeHash=`4861253789f480a715a0155c85e5a40d305799b69bd5f579f63ac7d009ea0fe1`, gateDbHash=`58a1e21a8a545e71b199e8b5d9715e8ea146a757c12e0fd6d8566cbeba6fe66f`, bitHash=`None`
- C11308 bitstream: status=`success`, runId=`43db896a-8d55-41a0-ace6-775ffca88aca`, synthesisRunId=`b0742bf6-1a65-4548-82d2-d82e2c3840d5`, scopeHash=`4861253789f480a715a0155c85e5a40d305799b69bd5f579f63ac7d009ea0fe1`, gateDbHash=`58a1e21a8a545e71b199e8b5d9715e8ea146a757c12e0fd6d8566cbeba6fe66f`, bitHash=`ad3c0ed07482ff88b9f252afc3862311de752216a511fe7164782d56e4b8c895`

## Limits

- This script reads existing files only. It does not invoke Tang Dynasty, regenerate a netlist, or touch hardware.
- A gate netlist verifies synthesis mapping, not routed clock skew. Routed conclusions require the routed implementation netlist and a fresh C11315 timing report.
- `CLKMUX=INV` is accepted as a legal EG4 clock selection and is required for the RTL falling-edge `S_oddr_data` preparation. For EG_PHY_LSLICE, legal model values include CLK/INV/1/0; for EG_PHY_MSLICE they include 0/1/INV/SIG. The script checks only explicit cell parameters and named q/clk ports.
- No assertion is made that unrelated ports of a packed logic cell share one clock net.
