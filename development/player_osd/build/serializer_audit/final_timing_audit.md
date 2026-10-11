# OSD 最终 serializer 时序证据补充

审计日期：2026-10-09。只读复核；未修改 RTL，也未重新构建。

## 报告版本更正

此前引用 `src/td_project/final_timing.rpt`，该文件是修复 hold 前的旧报告，不作为本次结论依据。当前实际 bitstream 对应的最终物理实现报告为：

- `development/player_osd/build/manual/AC201_tf_hdmi_pr.db`（2026-10-09 11:19:13）
- `development/player_osd/build/manual/AC201_tf_hdmi_pr.timing`（2026-10-09 11:19:12）
- `development/player_osd/build/manual/AC201_tf_hdmi_phy.ts`（2026-10-09 11:19:12）

同目录没有名为 `AC201_tf_hdmi_pr.phy.ts` 的文件；物理状态文件实际名称是 `AC201_tf_hdmi_phy.ts`。该状态文件和最终 PR timing 摘要为 `SWNS 0.138 ns, STNS 0.000 ns, HWNS 0.031 ns, HTNS 0.000 ns`，见 `.phy.ts` 全文；PR timing 第25–29行相同。时钟摘要第37–42行列出 `video_clk=25 MHz`、`hdmi_5x_clk=125 MHz`。这更正了旧报告中的全局 hold 负值：当前最终报告摘要是 setup/hold 均无负 slack、TNS 为 0。

## 四lane相关证据

最终 PR timing 第13089–13098行的 `video_clk -> hdmi_5x_clk` 组统计为 31 个端点、31 条分析路径，最差 setup slack 5.573 ns，最差 hold slack 0.377 ns，setup/hold 违规端点均为 0。最差 setup 示例在第13103–13109行：从 TMDS 编码寄存器 `u0_hdmi_tmds_encode/O_tmds_code_data_reg[0]`（video_clk）到 `u0_lane_lvds/S_shift_data_reg[8]` 的 capture 输入（hdmi_5x_clk），预算 8 ns、数据路径延迟 2.190 ns、slack 5.573 ns。后续列出的路径还出现 u1、u2 lane 及其他 `S_shift_data_reg` bit，例如第13158–13163、13212–13217、13266–13271行。此路径组覆盖了从像素域 TMDS 寄存器跨入 serializer 数据寄存器的物理时序；统计仅称 31 个 endpoint，报告本身不提供“40 个独立位端点全部逐位覆盖”的声明，故不把它扩展成所有 lane/所有位已逐项证明。

控制 toggle 的首次串行域采样也属于这个跨时钟组。最差 hold 路径在第13647–13678行：`S_odd_even_reg`（video_clk）到序列化域首级同步寄存器 D，报告网表路径显示其结果是 `S_odd_even_1d`，capture clock 为 hdmi_5x_clk，hold slack 0.377 ns。该信号是用于产生 load-enable 的像素域 toggle。此路径的静态分析说明相关时钟下首级采样路径的 hold 满足报告约束；其端点不是“成功检测到一次 toggle 并在指定串行周期启动装载”的功能断言。

125 MHz 内部路径组在第12049–12058行统计 49 个端点、80 条路径，最差 setup slack 5.182 ns，最差 hold slack 0.447 ns，零违规。第12063–12069行的最差 setup 是 `S_shift_data_reg[7]` 到 `S_oddr_data_reg[0]`，预算 8 ns，数据路径延迟 2.538 ns。控制到移位寄存器的数据选择路径也被分析：第12114–12120行从 `S_load_en_1d_reg` 到 `S_shift_data_reg[9]` 的 D 输入，检查类型为 setup、预算 8 ns、数据路径 2.311 ns；该路径在第12114行的 slack 为 5.337 ns。可见 load-enable 控制扇出进入 shift-data 输入选择逻辑的内部时序并非完全漏约束。

## 普通 STA 能说明与不能说明的边界

这份最终报告能说明：在报告采用的 25/125 MHz 相关时钟模型、当前布线和工具延迟模型下，所分析的数据寄存器跨域路径、toggle 首级采样路径及 serializer 内部寄存器路径满足 setup/hold；最终实现摘要的最差 setup/hold slack 都为正，TNS 为 0。

STA 不模拟 serializer 的事件功能，不能仅靠 slack 证明 toggle 每次都在设计预期的那个 125 MHz 边沿被检测、同步链的状态恰在期望窗口驱动 load-enable、该次 load 选中与当前像素对应的完整 10-bit word，或 ODDR 实际输出 bit 次序/像素窗口正确。报告中直接的数据路径检查证明的是时序预算，不是 conditional load 的功能等价性或实际硬件波形。确认这些关系仍需功能仿真/波形或硬件观测；当前报告本身既不能证明也不能排除 OSD 花屏、默认无声的实物根因。
