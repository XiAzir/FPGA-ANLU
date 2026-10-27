# C42 phase9 时序例外独立审计

范围：只读检查 phase9/data0 候选的 TD 6.2 routed timing、MCP exception report、check_timing 和约束源。未启动 EDA，也未修改生产源或约束。

## 结论

phase9 `set_multicycle_path 2 -setup -from [get_clocks ext_mem_clk_sft] -to [get_clocks ext_mem_clk]` 已被 TD 识别并作用于 32 条 DQ 返回路径。没有 clock name 失配或 SDC 解析失败证据。DQ setup 路径从 `report_timing_summary` 的常规 clock path groups 中单独归入 MCP 例外报告，因此 summary 里看不到 `ext_mem_clk_sft -> ext_mem_clk` 的普通组；exception report 才是此候选的权威路径证据。

hold 仍然执行。TD 的 MCP 例外详情对 32 个端点给出 Min HWNS=+3.392ns、HTNS=0；最差 hold 路径的报告边沿是 source `ext_mem_clk_sft rise@9ns` / capture `ext_mem_clk rise@10ns`，预算为 -1ns。周期平移一个 10ns beat 后，该 hold 检查对应下一数据 beat `source@19ns` 对 `capture@20ns`，符合 phase9 的下一 word 保持关系。约束里没有额外 hold multicycle。

## 证据

- [AC201_tf_hdmi_exception.timing](../../player_video42_sdram100/build/manual/AC201_tf_hdmi_exception.timing) 的 MCP/SMD Summary 显示 setup MCP `Total=32, Dominated=32, Shadowed=0, Ignored=0`；MCP Details 对 32 paths 全部分析。报告方案为每 path group 展示 10 个 endpoint，故明细中的 max/min path 名称只是抽样，而总路径统计覆盖全部 32。
- 同一 exception report 的最差 DQ setup：`sdram.dq[0] -> sdram_syn_1.bpad`，source `ext_mem_clk_sft rise@9ns`，capture `ext_mem_clk rise@20ns`，budget 11ns，data delay 6.453ns，slack +0.572ns。MCP组统计 Max SWNS +0.572ns、32/32 endpoints、0 violation。
- 同一 exception report 的最差 DQ hold：`sdram.dq[23] -> sdram_syn_18.bpad`，source `ext_mem_clk_sft rise@9ns`、capture `ext_mem_clk rise@10ns`，budget -1ns，min data delay 1.852ns，slack +3.392ns。MCP组统计 Min HWNS +3.392ns、32/32 endpoints、0 violation。
- [AC201_tf_hdmi_pr.timing](../../player_video42_sdram100/build/manual/AC201_tf_hdmi_pr.timing) 在 per-clock summary 旁明确注明 SMCP/SMD slack 仅计入 global Timing Status，不列入 Clock Summary。其 13 个常规 path group 包含 `ext_mem_clk -> ext_mem_clk_sft` 输出路径，不包含 MCP 的反向 DQ 输入组；该分组差异解释了初看 summary 的缺项。全局报告为 setup SWNS +0.285ns、hold HWNS +0.037ns；global hold 最差路径属于常规时序组，根侧已在执行 `fix_hold`。
- [AC201_tf_hdmi_chk.timing](../../player_video42_sdram100/build/manual/AC201_tf_hdmi_chk.timing) 的 `abnormal set_input_delay(32)` 列出 DQ[31:0] 全部 32 个唯一 pin。每 pin 带有 fast/slow 的 max=5ns、min=1ns input delay，reference pin 是内部 hard-IP `u_frame_buffer/u_sdram/sdram.clk`，reference clock 为 `ext_mem_clk_sft`。同一 timing path 明细将其列为 `input (hard ip)`，max 5ns、min 1ns 均实际参与 DQ arrival 计算，因此 abnormal 项没有抹掉这些路径约束。
- 项目 `timing.sdc` 中没有显式 `set_input_delay` 行；其来源未能从当前可读 project SDC 追溯，可能来自 TD/SDRAM IP 时序模型或导入数据库约束。check_timing 将它归为 MEDIUM abnormal，适合按警告继续追溯来源与确认数值。min=1ns 比 EM638325 表16的 `tOH(min)=2ns`（-5）或2.5ns（-6/-7）更早，作为 SDRAM 下一拍数据最早变化时间较保守；board DQ/CLK 偏斜尚未纳入。

## 适用边界

本次 DQ 覆盖由 MCP 计数 32、DQ hard-IP input delay 目标覆盖 DQ[0:31]、路径起终点示例及单一 shift clock fanout 交叉确认。exception report 因每组 10 endpoints 的打印上限，没有逐条列出 32 个 endpoint 名称；TD 报告统计仍明确给出 32 个路径/端点且无忽略项。若后续 netlist 增加其他 `ext_mem_clk_sft -> ext_mem_clk` 路径，当前 clock-wide MCP 也会纳入新路径，届时应复核 scope 或改用明确 32 个 `.bpad` endpoints 的约束，并重新生成完整 routed exception report。

check_timing 的 abnormal 标记并非单凭文本即可定性为工具误报或路径缺失。当前可确认的是这些设置被识别、逐位列出、并进入 MCP setup/hold path calculation；输入延迟来源、封装/IP 时序模型和板级偏斜仍需独立确认。
