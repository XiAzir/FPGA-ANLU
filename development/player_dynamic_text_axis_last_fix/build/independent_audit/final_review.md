# `player_dynamic_text_axis_last_fix` 最终独立复核

审计日期：2026-10-09。只读审阅最终 PR 数据库并导出 routed Verilog；没有运行综合、布局布线、hold 修复或 bitgen，也没有执行 `export_db`/写回数据库。TD 导出日志以 `READONLY_DUMP_COMPLETE` 收尾。

## 结论

**不建议把该候选 bit 交给用户实板测试。**候选与 `player_dynamic_text_video_probe` 的最终 routed Verilog 在剔除唯一的头部生成时间注释后，210,258 行逐行完全相同；标准化 SHA-256 均为 `8E894B5FC25B745A658FCED4F98AB332C5C76B2B472C7D4DD3CCDF93F5C33AD6`，差异行数为 0。比较覆盖单元参数/INIT、连接关系、网表中导出的物理位置和其余注释；没有另外的绝对工程路径差异。最终 `.area` 报告也逐字节相同（SHA-256 `AA04EF89A74D77855699DB19DBD7A7C15AD277A661B9A985B875E7CECD3A6E2E`，LUT 17,116、寄存器 8,016、LE 18,509）。因此，639→638 的源码修正没有改变此候选最终可识别的 routed 实现。

这强烈表明修正产生的 `TLAST` 对当前映射实现没有可观察作用（例如加密 HDMI 核未使用该输入，或相关逻辑被综合裁剪），但不单凭平坦化导出断言加密核内部语义。候选模型证明了转换器会在第 640 个有效像素产生 `TLAST`，并未覆盖加密核；该协议修正仍可作为源码/模型修正保留，但当前 bit 不应被表述为硬件修复。

## 源码纳入与 routed 导出对照

相较 probe，用户源码快照仍为 76 个文件，唯一变更是 [`video_rgb_to_axis_640x480.v:58`](</E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_axis_last_fix/src/user_source/hdl_source/video_rgb_to_axis_640x480.v:58>) 将比较值从 639 改为 638。候选文件 SHA-256 `E8A2432DAF9A58ACA20F81BBF64B32719BAF3918135C8B7C6E266E0C05496683` 与 [`build_source_scope.json`](</E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_axis_last_fix/build/manual/build_source_scope.json>) 中快照一致；`.al` 第 153 行注册该模块，综合日志第 109 行也记录分析了该文件。顶层在 [`top_tf_hdmi_audio.v:406-414`](</E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_axis_last_fix/src/user_source/hdl_source/top_tf_hdmi_audio.v:406>) 将其 `O_video_last` 接至 `axis_s_last`，并在第 439-449 行将此信号接入加密 HDMI 核的 `I_axis_s_last`。

候选最终 PR DB 是在父代理确认 `fix_hold` 完成后，以 TD 6.2.178840 执行 `import_device`、`import_db` 和 `write_verilog` 导出的。可复查产物：[`AC201_tf_hdmi_axis_last_fix_pr_routed.v`](</E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_axis_last_fix/build/independent_audit/AC201_tf_hdmi_axis_last_fix_pr_routed.v>) 与 [`dump_final_pr_readonly.log`](</E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_axis_last_fix/build/independent_audit/dump_final_pr_readonly.log>)。旧 probe 对照为 [`AC201_tf_hdmi_pr_routed.v`](</E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_video_probe/build/startup_readonly_audit/AC201_tf_hdmi_pr_routed.v>)。两份原始文件各 10,997,259 字节；因生成日期不同，原始 SHA 分别为 `E2FB3DDAC877917BB96FA10E1C5C14882FE76DEC44AF63F00856960A60FCCA98` 和 `FD08F235B4773A832D360BFD086775EED5A5B382146973165A25AE2CF266F5A0`。剔除各自第 2 行 `// <生成时间>` 后，逐行相等且标准化 SHA 相同。候选和旧 probe 的 PR DB 文件自身 SHA 不同、大小差 4 字节；这表明数据库容器不是字节相同，不能用 DB 哈希代替网表差异结论。导出文本已包含的逻辑及物理位置内容则完全相同。

两份 routed Verilog 均搜索不到 `I_axis_s_last`、`axis_s_last`、`O_video_last` 或 `S_x_cnt` 标识。候选导出仍保留普通 top reset 网及 PLL/GCLK 实例：`rst_all_reg_reg_syn_3` 声明在第 2215 行，复位复制寄存器实例见第 14178 行；sys PLL/GCLK 在第 15598-15683 行，video PLL/GCLK 在第 209670-209755 行。由于同一整份导出亦等于旧 probe，这不是本次源码修正导致的新差异；而且缺少 `TLAST` 名称本身只能说明平坦化后的导出没有该命名逻辑，结合整份网表一致才支持“修正没有落入可观察实现”的结论。

## 最终原约束与 STA guard

候选 [`timing.sdc`](</E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_axis_last_fix/src/user_source/constraints_source/timing.sdc:3>) 对 50 MHz 板时钟建立 20 ns 主时钟，随后 `derive_clocks` 并分别重命名 sys PLL 的 `sd_card_clk`、`ext_mem_clk`、相移时钟及 video PLL 的 `video_clk`、`hdmi_5x_clk`；文件明确说明像素/串行时钟保持既定关系，不声明 exclusive clocks。最终 routed timing 报告使用候选 `timing.sdc` 路径，覆盖率 99.97%，Slow/Fast 两角的 max/min 检查均为 yes。报告列出 `sd_card_clk` 50 MHz、`video_clk` 25 MHz、`ext_mem_clk` 50 MHz、板时钟 50 MHz、`hdmi_5x_clk` 125 MHz 及相移时钟 50 MHz；约束检查对两颗 PLL 均报告无未约束输出时钟、无 PLL 频率不匹配，且无无效约束或组合环。最终 STA 摘要 [`AC201_tf_hdmi_phy.ts:1-2`](</E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_axis_last_fix/build/manual/AC201_tf_hdmi_phy.ts:1>) 为 SWNS +0.505 ns、STNS 0、HWNS +0.024 ns、HTNS 0；最终 PR timing 文件第 27-28 行一致。

[`hold_console.log`](</E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_axis_last_fix/build/manual/hold_console.log:53>) 记录 `fix_hold` 完成：初始最差 hold 为 −52 ps / HTNS −92 ps，10 个 endpoint 全部由 pin delay 修复；最终 HWNS +24 ps、HTNS 0，日志末尾有 `POST_ROUTE_HOLD_FIX_COMPLETE`。导入/hold 日志把 `u_bmp_file_mapper/clk` 合并到 sys PLL clk0 buffer、把 `u_status_monitor/sys_clk` 合并到 video PLL clk0 buffer。这里的 STA clean 只说明该 TD 约束模型中的路径满足检查，不能证明板上启动或 HDMI 输出正常。

约束检查仍列有 3 个 dangling nodes（其中两个来自 `EG_PHY_PAD`），另有 4 个输入和 14 个输出未设 I/O delay；SDC 本身也注明板级 SPI I/O delay 尚未表征。这些是模型边界，不足以解释本次板上现象，也不能据此推断 SDRAM 未约束或 HDMI 无物理载波。已知的公共宏重定位和 `sdr_wrrd` undriven `CLK` 历史告警不作为本候选根因。

## 建议的下一步证据

保持该协议模型结果，不测试或发布当前候选 bit。下一步应直接对比实际进入 HDMI 核的 `USER/VALID/DE` 与 `O_video_locked`（并记录同一运行中的像素时钟/复位状态）；只有当输入握手与核心锁定之间出现可复现断点，才继续定位加密核边界或其配置。若要单独验证 TLAST，先取得能够观测该输入消费行为的模型/接口证据，不从现有转换器 testbench 或全网表同一性外推其内部实现。

## 可复核的源 guard 与 routed diff 方法

候选 [`build_source_scope.json`](</E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_axis_last_fix/build/manual/build_source_scope.json>) 共 80 项；复核时逐项确认 80/80 路径存在且当前 SHA-256 与清单完全一致（覆盖 76 个 `user_source` 文件及工程注册/IP 输入）。因此最终相同网表不是因为候选源码快照指向了另一份 `video_rgb_to_axis_640x480.v`；模块已注册并由综合日志分析。

以下 PowerShell 7 代码复现上面的全文比较。它只跳过两份导出各自第 2 行的生成时间注释，其他行逐行比较；normalized SHA 的输入也只省略该行，使用 UTF-8 编码和 LF 分隔：

```powershell
$a = 'development/player_dynamic_text_axis_last_fix/build/independent_audit/AC201_tf_hdmi_axis_last_fix_pr_routed.v'
$b = 'development/player_dynamic_text_video_probe/build/startup_readonly_audit/AC201_tf_hdmi_pr_routed.v'
$la = [IO.File]::ReadAllLines((Resolve-Path $a))
$lb = [IO.File]::ReadAllLines((Resolve-Path $b))
$ts = '^// (Mon|Tue|Wed|Thu|Fri|Sat|Sun) [A-Z][a-z]{2}\s+\d{1,2} \d{2}:\d{2}:\d{2} \d{4}$'
if ($la.Count -ne $lb.Count -or $la.Count -lt 3 -or $la[0] -cne $lb[0] -or $la[1] -notmatch $ts -or $lb[1] -notmatch $ts) { throw 'Unexpected export header/length' }
$bodyA = @($la[0]) + @($la[2..($la.Count - 1)])
$bodyB = @($lb[0]) + @($lb[2..($lb.Count - 1)])
$diff = for ($i = 0; $i -lt $bodyA.Count; $i++) { if ($bodyA[$i] -cne $bodyB[$i]) { $i + 1 } }
$sha = [Security.Cryptography.SHA256]::Create()
$hashA = [Convert]::ToHexString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes(($bodyA -join "`n"))))
$hashB = [Convert]::ToHexString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes(($bodyB -join "`n"))))
"body lines=$($bodyA.Count); diff lines=$(@($diff).Count); candidate=$hashA; probe=$hashB"
```

预期复核结果：body 行数 `210258`，差异行 `0`；两边 hash 均为 `8E894B5FC25B745A658FCED4F98AB332C5C76B2B472C7D4DD3CCDF93F5C33AD6`。这个结论限定于 exported routed netlist 与它包含的逻辑/位置元数据，不等于板上波形或 HDMI 物理链路测量结果。

