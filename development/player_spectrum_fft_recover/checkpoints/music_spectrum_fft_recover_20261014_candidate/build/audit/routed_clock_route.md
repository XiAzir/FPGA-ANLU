# C11310 serializer clock / routed netlist audit

Generated: 2026-10-14T20:16:35+08:00
Netlist input: `E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\build\audit\routed_implementation.v`
Timing input: `E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\build\manual\AC201_tf_hdmi_pr.timing`
Netlist stage: routed

## Checks

- **INFO** — netlist SHA256=c340972399476f9c773e8412d790eaf702bad790197f32b1fad92edcbeca5a5e
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
- **PASS** — lane0 pending_data: 8 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane0 shift_data: 7 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane0 oddr_data: 1 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=INV; 有效边沿/时钟匹配
- **INFO** — lane1 sync: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **INFO** — lane1 load_en: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **PASS** — lane1 pending_data: 8 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane1 shift_data: 6 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane1 oddr_data: 2 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=INV; 有效边沿/时钟匹配
- **INFO** — lane2 sync: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **INFO** — lane2 load_en: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **PASS** — lane2 pending_data: 7 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane2 shift_data: 7 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane2 oddr_data: 1 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=INV; 有效边沿/时钟匹配
- **INFO** — lane3 sync: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **INFO** — lane3 load_en: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **PASS** — lane3 pending_data: 1 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane3 shift_data: 3 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane3 oddr_data: 1 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=INV; 有效边沿/时钟匹配
- **PASS** — lane aggregate sync: 1 explicit register cell(s)
- **PASS** — lane aggregate load_en: 1 explicit register cell(s)
- **PASS** — lane aggregate pending_data: 24 explicit register cell(s)
- **PASS** — lane aggregate shift_data: 23 explicit register cell(s)
- **PASS** — lane aggregate oddr_data: 5 explicit register cell(s)
- **PASS** — seg7_dio.osclk=\u_bmp_file_mapper/clk（system PLL GCLK 输出）
- **PASS** — seg7_sclk.osclk=\u_bmp_file_mapper/clk（system PLL GCLK 输出）
- **PASS** — seg7_rclk.osclk=\u_bmp_file_mapper/clk（system PLL GCLK 输出）
- **PASS** — mailbox source/video: 25 FF cell(s), CLK=\u_status_monitor/sys_clk
- **PASS** — mailbox destination/system: 23 FF cell(s), CLK=\u_bmp_file_mapper/clk
- **PASS** — source manifest 与当前源文件一致；scopeHash=f2c8acfd8ba65792c076c6539a436386cb9d44d7ce1ae8ed6e21b219beda7f68
- **PASS** — synthesis evidence PASS：runId=bc83c14e-d3cd-436a-a224-26b5ca68b119
- **PASS** — gate database hash 匹配：7c76322984f3fb7e82c81e6dd7c834e77eb84a891e2021787c13cc633e4b8185
- **PASS** — physical evidence success; synthesisRunId/gateDbHash/scopeHash 匹配
- **PASS** — timing report hash 匹配 physical evidence：AC201_tf_hdmi_pr.timing
- **PASS** — HDMI_CLK_P: DDRMODE/IOTYPE/reset 与 C11308 基线一致 (reset \u_status_monitor/startup_flags[1]_dup_4309 → \u_status_monitor/startup_flags[1]_dup_4327)
- **PASS** — HDMI_D0_P: DDRMODE/IOTYPE/reset 与 C11308 基线一致 (reset \u_status_monitor/startup_flags[1]_dup_4309 → \u_status_monitor/startup_flags[1]_dup_4335)
- **PASS** — HDMI_D1_P: DDRMODE/IOTYPE/reset 与 C11308 基线一致 (reset \u_status_monitor/startup_flags[1]_dup_4309 → \u_status_monitor/startup_flags[1]_dup_4323)
- **PASS** — HDMI_D2_P: DDRMODE/IOTYPE/reset 与 C11308 基线一致 (reset \u_status_monitor/startup_flags[1]_dup_4309 → \u_status_monitor/startup_flags[1]_dup_4335)
- **PASS** — timing summary 属于 C11310，SHA256=4dcacb9c215331b2a9c6e5d59a8fc08c022a941907795bb22c8cce4cc437fc03

## Clock topology

| Item | C11308 baseline | C11310 input |
|---|---|---|
| Netlist SHA256 | 897387353dcd78eb2489926e7d67543ac58b756ec1ca054cc4b91bb23d5f6d7b | c340972399476f9c773e8412d790eaf702bad790197f32b1fad92edcbeca5a5e |
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
| HDMI_CLK_P | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4309` | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4327` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` |
| HDMI_D0_P | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4309` | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4335` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` |
| HDMI_D1_P | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4309` | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4323` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` |
| HDMI_D2_P | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4309` | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4335` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` |

## Lane register clock/polarity audit

Only explicit q/clk cell ports matching named lane register classes are checked; unrelated packed pins are not assumed to share one net.

| Lane | Register class | Cell | CLK | CLKMUX |
|---:|---|---|---|---|
| 0 | sync | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_odd_even_2d_reg_syn_5` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | load_en | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_load_en_reg_syn_5` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[0]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[1]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[2]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[4]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[5]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[6]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[7]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[8]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[0]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[1]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[2]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[4]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[5]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[6]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[8]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | oddr_data | `EG_PHY_LSLICE \u_adjust_control/add6_syn_116` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 1 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[0]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[1]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[2]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[4]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[5]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[6]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[8]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[0]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[0]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[2]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[4]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[6]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[8]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[9]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | oddr_data | `EG_PHY_LSLICE \u_bmp_file_player/u_scale/add10_syn_194` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 1 | oddr_data | `EG_PHY_MSLICE \u_bmp_file_player/u_scale/lt13_syn_104` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 2 | pending_data | `EG_PHY_LSLICE \u_dynamic_text/add5_syn_152` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[4]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[5]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[1]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[0]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[3]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[8]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[0]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[1]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[4]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[5]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[2]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[6]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `EG_PHY_LSLICE \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[8]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | oddr_data | `EG_PHY_MSLICE \u_adjust_control/lt4_syn_65` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 3 | pending_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_pending_data_reg[5]_syn_3` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 3 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[8]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 3 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[9]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 3 | shift_data | `EG_PHY_MSLICE \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_shift_data_reg[5]_syn_4` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 3 | oddr_data | `EG_PHY_MSLICE \u_bmp_file_player/u_scale/lt16_syn_104` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |

## Routed timing summary

| Report | Clock SWNS (ns) | Clock HWNS (ns) | hdmi_5x skew (ns) | Fanout | PAD do setup min slack (ns) | PAD do hold min slack (ns) |
|---|---:|---:|---:|---:|---:|---:|
| C11308 baseline | 0.120 | 0.030 | 0.326 | 53 | 2.705 | 未列出 |
| C11310 input | 0.236 | 0.027 | 0.326 | 49 | 0.305 | 未列出 |

Clock WNS/skew are routed clock-summary metrics. PAD `do[]` values include only endpoints explicitly listed by the timing report; ‘未列出’ means no such path was listed, not zero slack.

- Report SHA256: `4dcacb9c215331b2a9c6e5d59a8fc08c022a941907795bb22c8cce4cc437fc03`
- Constraint file: `E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_fft_recover/src/user_source/constraints_source/timing.sdc`
- Global timing: `{"SWNS": "0.236", "STNS": "0.000", "HWNS": "0.027", "HTNS": "0.000", "Period Check WNS": "16.586"}`
- hdmi_5x_clk row: `clk4           local            0.000      4.000                 8.000         125.000                 6.734         148.500            0.633      0.000            0.244      0.000            0.326               49                1             no       no`

PAD DDR input-register paths explicitly listed in the report:
- setup HDMI_CLK_P_syn_2.do[1] (rising edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 }); slack=2.834 ns; skew=0.277 ns; budget=4.000ns { hdmi_5x_clk rising@8.000ns - hdmi_5x_clk falling@4.000ns }; launch=u_bmp_file_player/u_scale/lt16_syn_104.clk (falling edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 })
- setup HDMI_D2_P_syn_2.do[0] (rising edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 }); slack=2.928 ns; skew=0.254 ns; budget=4.000ns { hdmi_5x_clk rising@8.000ns - hdmi_5x_clk falling@4.000ns }; launch=u_adjust_control/lt4_syn_65.clk (falling edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 })
- setup HDMI_D1_P_syn_2.do[0] (rising edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 }); slack=0.305 ns; skew=0.277 ns; budget=4.000ns { hdmi_5x_clk rising@8.000ns - hdmi_5x_clk falling@4.000ns }; launch=u_bmp_file_player/u_scale/lt13_syn_104.clk (falling edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 })

## Run and bit identity

- C11310 synthesis: status=`success`, runId=`bc83c14e-d3cd-436a-a224-26b5ca68b119`, scopeHash=`f2c8acfd8ba65792c076c6539a436386cb9d44d7ce1ae8ed6e21b219beda7f68`, gateDbHash=`7c76322984f3fb7e82c81e6dd7c834e77eb84a891e2021787c13cc633e4b8185`
- C11310 physical: status=`success`, runId=`0f4ca9e2-396b-4acd-9e72-5371271d4750`, synthesisRunId=`bc83c14e-d3cd-436a-a224-26b5ca68b119`, gateDbHash=`7c76322984f3fb7e82c81e6dd7c834e77eb84a891e2021787c13cc633e4b8185`
- C11308 physical: status=`success`, runId=`ffbf0e8b-f787-4411-97db-32f71bc89edc`, synthesisRunId=`b0742bf6-1a65-4548-82d2-d82e2c3840d5`, scopeHash=`4861253789f480a715a0155c85e5a40d305799b69bd5f579f63ac7d009ea0fe1`, gateDbHash=`58a1e21a8a545e71b199e8b5d9715e8ea146a757c12e0fd6d8566cbeba6fe66f`, bitHash=`None`
- C11308 bitstream: status=`success`, runId=`43db896a-8d55-41a0-ace6-775ffca88aca`, synthesisRunId=`b0742bf6-1a65-4548-82d2-d82e2c3840d5`, scopeHash=`4861253789f480a715a0155c85e5a40d305799b69bd5f579f63ac7d009ea0fe1`, gateDbHash=`58a1e21a8a545e71b199e8b5d9715e8ea146a757c12e0fd6d8566cbeba6fe66f`, bitHash=`ad3c0ed07482ff88b9f252afc3862311de752216a511fe7164782d56e4b8c895`

## Limits

- This script reads existing files only. It does not invoke Tang Dynasty, regenerate a netlist, or touch hardware.
- A gate netlist verifies synthesis mapping, not routed clock skew. Routed conclusions require the routed implementation netlist and a fresh C11310 timing report.
- `CLKMUX=INV` is accepted as a legal EG4 clock selection and is required for the RTL falling-edge `S_oddr_data` preparation. For EG_PHY_LSLICE, legal model values include CLK/INV/1/0; for EG_PHY_MSLICE they include 0/1/INV/SIG. The script checks only explicit cell parameters and named q/clk ports.
- No assertion is made that unrelated ports of a packed logic cell share one clock net.
