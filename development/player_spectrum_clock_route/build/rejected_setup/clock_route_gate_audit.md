# C11309 serializer clock / routed netlist audit

Generated: 2026-10-14T19:23:30+08:00
Netlist input: `E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_clock_route\build\manual\AC201_tf_hdmi_gate.v`
Timing input: `E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_clock_route\build\manual\AC201_tf_hdmi_pr.timing`
Netlist stage: gate/unspecified

## Checks

- **INFO** — netlist SHA256=b4217bc114dc95d902cb326bfa57a2e33d551ca7ec8ecc01ec187f08a3cd4668
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
- **PASS** — lane0 sync: 2 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane0 load_en: 1 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane0 pending_data: 10 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane0 shift_data: 10 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane0 oddr_data: 2 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=INV; 有效边沿/时钟匹配
- **INFO** — lane1 sync: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **INFO** — lane1 load_en: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **PASS** — lane1 pending_data: 10 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane1 shift_data: 10 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane1 oddr_data: 2 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=INV; 有效边沿/时钟匹配
- **INFO** — lane2 sync: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **INFO** — lane2 load_en: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **PASS** — lane2 pending_data: 10 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane2 shift_data: 10 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane2 oddr_data: 2 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=INV; 有效边沿/时钟匹配
- **INFO** — lane3 sync: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **INFO** — lane3 load_en: 网表中无独立寄存器，可能由跨 lane 共享控制或常量数据优化消除
- **PASS** — lane3 pending_data: 1 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane3 shift_data: 3 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=CLK; 有效边沿/时钟匹配
- **PASS** — lane3 oddr_data: 2 cell(s), CLK=\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk, CLKMUX=INV; 有效边沿/时钟匹配
- **PASS** — lane aggregate sync: 2 explicit register cell(s)
- **PASS** — lane aggregate load_en: 1 explicit register cell(s)
- **PASS** — lane aggregate pending_data: 31 explicit register cell(s)
- **PASS** — lane aggregate shift_data: 33 explicit register cell(s)
- **PASS** — lane aggregate oddr_data: 8 explicit register cell(s)
- **PASS** — seg7_dio.osclk=\u_bmp_file_mapper/clk（system PLL GCLK 输出）
- **PASS** — seg7_sclk.osclk=\u_bmp_file_mapper/clk（system PLL GCLK 输出）
- **PASS** — seg7_rclk.osclk=\u_bmp_file_mapper/clk（system PLL GCLK 输出）
- **PASS** — mailbox source/video: 35 FF cell(s), CLK=\u_status_monitor/sys_clk
- **PASS** — mailbox destination/system: 35 FF cell(s), CLK=\u_bmp_file_mapper/clk
- **PASS** — source manifest 与当前源文件一致；scopeHash=750913cd3ebcbe49933414897c4283e353ea940dab25351d16bc80282423b267
- **PASS** — synthesis evidence PASS：runId=f92a05ce-9570-45ae-a39d-29b255038fd9
- **PASS** — gate database hash 匹配：24b4d1cd4346ac0b74374fb8fa1db4968875830f85c63ccd3d23b3e2a3cabf7d
- **PASS** — physical evidence success; synthesisRunId/gateDbHash/scopeHash 匹配
- **PASS** — timing report hash 匹配 physical evidence：AC201_tf_hdmi_pr.timing
- **PASS** — HDMI_CLK_P: DDRMODE/IOTYPE/reset 与 C11308 基线一致 (reset \u_status_monitor/startup_flags[1]_dup_4309 → \u_status_monitor/startup_flags [1])
- **PASS** — HDMI_D0_P: DDRMODE/IOTYPE/reset 与 C11308 基线一致 (reset \u_status_monitor/startup_flags[1]_dup_4309 → \u_status_monitor/startup_flags [1])
- **PASS** — HDMI_D1_P: DDRMODE/IOTYPE/reset 与 C11308 基线一致 (reset \u_status_monitor/startup_flags[1]_dup_4309 → \u_status_monitor/startup_flags [1])
- **PASS** — HDMI_D2_P: DDRMODE/IOTYPE/reset 与 C11308 基线一致 (reset \u_status_monitor/startup_flags[1]_dup_4309 → \u_status_monitor/startup_flags [1])
- **PASS** — timing summary 属于 C11309，SHA256=28521c675a6b62a80310ef303a89f415e9b6c33061e96e84a7e23e5398bd8641

## Clock topology

| Item | C11308 baseline | C11309 input |
|---|---|---|
| Netlist SHA256 | 897387353dcd78eb2489926e7d67543ac58b756ec1ca054cc4b91bb23d5f6d7b | b4217bc114dc95d902cb326bfa57a2e33d551ca7ec8ecc01ec187f08a3cd4668 |
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
| HDMI_CLK_P | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4309` | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags [1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` |
| HDMI_D0_P | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4309` | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags [1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` |
| HDMI_D1_P | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4309` | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags [1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` |
| HDMI_D2_P | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags[1]_dup_4309` | "DDRX1" / "LVDS33_E" / `\u_status_monitor/startup_flags [1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` |

## Lane register clock/polarity audit

Only explicit q/clk cell ports matching named lane register classes are checked; unrelated packed pins are not assumed to share one net.

| Lane | Register class | Cell | CLK | CLKMUX |
|---:|---|---|---|---|
| 0 | sync | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_odd_even_1d_reg` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | sync | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_odd_even_2d_reg` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | load_en | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_load_en_reg` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[0]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[2]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[3]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[4]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[5]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[6]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[7]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[8]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data_reg[9]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[0]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[2]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[3]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[4]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[5]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[6]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[7]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[8]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data_reg[9]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 0 | oddr_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_oddr_data_reg[0]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 0 | oddr_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_oddr_data_reg[1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 1 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[0]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[2]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[3]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[4]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[5]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[6]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[7]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[8]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data_reg[9]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[0]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[2]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[3]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[4]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[5]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[6]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[7]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[8]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data_reg[9]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 1 | oddr_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_oddr_data_reg[0]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 1 | oddr_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_oddr_data_reg[1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 2 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[0]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[2]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[3]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[4]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[5]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[6]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[7]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[8]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data_reg[9]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[0]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[2]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[3]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[4]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[5]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[6]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[7]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[8]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data_reg[9]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 2 | oddr_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_oddr_data_reg[0]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 2 | oddr_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_oddr_data_reg[1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 3 | pending_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_pending_data_reg[5]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 3 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_shift_data_reg[5]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 3 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_shift_data_reg[7]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 3 | shift_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_shift_data_reg[9]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"CLK"` |
| 3 | oddr_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_oddr_data_reg[0]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |
| 3 | oddr_data | `AL_MAP_SEQ \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_oddr_data_reg[1]` | `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk` | `"INV"` |

## Routed timing summary

| Report | Clock SWNS (ns) | Clock HWNS (ns) | hdmi_5x skew (ns) | Fanout | PAD do setup min slack (ns) | PAD do hold min slack (ns) |
|---|---:|---:|---:|---:|---:|---:|
| C11308 baseline | 0.120 | 0.030 | 0.326 | 53 | 2.705 | 未列出 |
| C11309 input | -0.420 | -0.025 | 0.326 | 53 | 0.339 | 未列出 |

Clock WNS/skew are routed clock-summary metrics. PAD `do[]` values include only endpoints explicitly listed by the timing report; ‘未列出’ means no such path was listed, not zero slack.

- Report SHA256: `28521c675a6b62a80310ef303a89f415e9b6c33061e96e84a7e23e5398bd8641`
- Constraint file: `E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_clock_route/src/user_source/constraints_source/timing.sdc`
- Global timing: `{"SWNS": "-0.420", "STNS": "-2.611", "HWNS": "-0.025", "HTNS": "-0.045", "Period Check WNS": "0.000"}`
- hdmi_5x_clk row: `clk4           local            0.000      4.000                 8.000         125.000                 6.894         145.054            0.553      0.000            0.244      0.000            0.326               53                1             no       no`

PAD DDR input-register paths explicitly listed in the report:
- setup HDMI_D1_P_syn_2.do[1] (rising edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 }); slack=2.536 ns; skew=0.277 ns; budget=4.000ns { hdmi_5x_clk rising@8.000ns - hdmi_5x_clk falling@4.000ns }; launch=u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_oddr_data_reg[0]_syn_4.clk (falling edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 })
- setup HDMI_D0_P_syn_2.do[1] (rising edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 }); slack=2.815 ns; skew=0.277 ns; budget=4.000ns { hdmi_5x_clk rising@8.000ns - hdmi_5x_clk falling@4.000ns }; launch=u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_oddr_data_reg[0]_syn_4.clk (falling edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 })
- setup HDMI_D2_P_syn_2.do[1] (rising edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 }); slack=0.339 ns; skew=0.277 ns; budget=4.000ns { hdmi_5x_clk rising@8.000ns - hdmi_5x_clk falling@4.000ns }; launch=u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/lt1_syn_50.clk (falling edge triggered by clock hdmi_5x_clk  { rise@0.000000ns  fall@4.000000ns  period=8.000000 })

## Run and bit identity

- C11309 synthesis: status=`success`, runId=`f92a05ce-9570-45ae-a39d-29b255038fd9`, scopeHash=`750913cd3ebcbe49933414897c4283e353ea940dab25351d16bc80282423b267`, gateDbHash=`24b4d1cd4346ac0b74374fb8fa1db4968875830f85c63ccd3d23b3e2a3cabf7d`
- C11309 physical: status=`success`, runId=`dc0bf9d4-d63c-43a6-b351-16d1624a1e14`, synthesisRunId=`f92a05ce-9570-45ae-a39d-29b255038fd9`, gateDbHash=`24b4d1cd4346ac0b74374fb8fa1db4968875830f85c63ccd3d23b3e2a3cabf7d`
- C11308 physical: status=`success`, runId=`ffbf0e8b-f787-4411-97db-32f71bc89edc`, synthesisRunId=`b0742bf6-1a65-4548-82d2-d82e2c3840d5`, scopeHash=`4861253789f480a715a0155c85e5a40d305799b69bd5f579f63ac7d009ea0fe1`, gateDbHash=`58a1e21a8a545e71b199e8b5d9715e8ea146a757c12e0fd6d8566cbeba6fe66f`, bitHash=`None`
- C11308 bitstream: status=`success`, runId=`43db896a-8d55-41a0-ace6-775ffca88aca`, synthesisRunId=`b0742bf6-1a65-4548-82d2-d82e2c3840d5`, scopeHash=`4861253789f480a715a0155c85e5a40d305799b69bd5f579f63ac7d009ea0fe1`, gateDbHash=`58a1e21a8a545e71b199e8b5d9715e8ea146a757c12e0fd6d8566cbeba6fe66f`, bitHash=`ad3c0ed07482ff88b9f252afc3862311de752216a511fe7164782d56e4b8c895`

## Limits

- This script reads existing files only. It does not invoke Tang Dynasty, regenerate a netlist, or touch hardware.
- A gate netlist verifies synthesis mapping, not routed clock skew. Routed conclusions require the routed implementation netlist and a fresh C11309 timing report.
- `CLKMUX=INV` is accepted as a legal EG4 clock selection and is required for the RTL falling-edge `S_oddr_data` preparation. For EG_PHY_LSLICE, legal model values include CLK/INV/1/0; for EG_PHY_MSLICE they include 0/1/INV/SIG. The script checks only explicit cell parameters and named q/clk ports.
- No assertion is made that unrelated ports of a packed logic cell share one clock net.
