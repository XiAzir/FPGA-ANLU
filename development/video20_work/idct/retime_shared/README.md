# 共享 IDCT Y 算术核重定时和 DSP 消融

本隔离任务对共享 v3 的 Y 算术核做四组消融：原始、仅删重复乘积寄存拍、仅将两路 `181/256` 移入 DSP、两项组合。所有新增源、TD工程、仿真和报告都在 `development/video20_work/idct/retime_shared/`；没有改父 `shared_idct`。

## 候选实现

共享 wrapper 将同一个 `jpeg_idct_y` 算术核配置为 `OUT_SHIFT=11`。纯重定时保留五路 `mul*_a/b` 操作数寄存器及五路 `mul*_q` DSP 输出寄存器，删除重复的 `mul* <= mul*_q` bank，并让 butterfly 直接读取 `mul*_q`。配套去掉 `out_stg2_valid_q/out_stg2_idx_q`，改由 `out_stg1` 驱动算术分支和 `out_stg3`。因此结果寄存器仍是 butterfly 的边界，输出事务提前一拍，ID/data/value次序不变；没有添加控制寄存器或流控假设。共享 wrapper 的 `rst_i || img_start_i` flush 连接保持原样。

DSP 变体把 `scale181_0_w/scale181_1_w` 换为 `(* dsp_style="yes" *) signed [31:0]` 结果：`$signed(o_t6_5) * 32'sd181` 和对应 `o_t5_6`。两个原移位加法和新 signed乘法都产生 32-bit 模 2^32 的同一位型，后面的 signed `/256` 与 OUT_SHIFT 不变。完整 signed32 边界 + 100,000 随机值验证 `scale181_w` 和 `/256` 输出位型相同，见 [tb_scale181_equiv.sv](tb_scale181_equiv.sv) 与 [sim_scale181_equiv.log](sim_scale181_equiv.log)。

可集成的模块文件：[retime-only Y](retime/jpeg_idct_y_retimed.v)、[DSP-only Y](dsp_only/jpeg_idct_y_dsp.v)、[组合 Y](td/retime_dsp/src_v/jpeg_idct_y.v)。最后一个文件保留模块名 `jpeg_idct_y`，可用于共享 wrapper 的 `OUT_SHIFT(11)` 实例。完整副本和源码哈希见对应 `td/*/source_manifest.json`。

## 差分验证

Icarus scalar Y 测试将原始 Y、retime-only、DSP-only、组合实现并行驱动：768个有效21-bit signed输入，含 `-2^20`、`2^20-1`、`0`、全零/全最大/全最小向量，随机 valid gaps；三段事务之间 drain 后执行 reset + img_start。768个 Y 输出的 data/index 顺序全部相同。每个 retimed 输出valid都比reference早一拍；DSP-only valid与reference同拍。结果 `errors=0`，日志为 [sim_y_retime.log](sim_y_retime.log)。

另用共享 v3 的 early wrapper 与 early transpose 对照原 JPEG IDCT 完整事务。参考与候选都处理48块/3072个样本，数据、输出 index 和ID逐项一致，read-before-X-write检查无错误。retime-only和retime+DSP各运行10,186 cycles、16,300次读安全检查；DSP-only为10,232 cycles、16,256次读安全检查。完整日志分别在 [retime](equiv_shared_retime/run.log)、[DSP-only](equiv_shared_dsp_only/run.log)、[组合](equiv_shared_retime_dsp/run.log)。

## TD 6.2 synthesis / 20 ns timing

独立 `idct_y_area_top` 设 `OUT_SHIFT=11`，EG4S20BG256、20 ns SDC、`max_dsp=29`；每组均以相同 top、相同 strategy 合成，执行 `legalize_phy_inst/update_timing` 并保存 gate area、timing status 和 summary。`gate.area` 列为 LUT/ripple/sequential/DSP；TD device summary 中 slices 与 registers 单列如下。

| 变体 | LUT / ripple / seq / DSP | device LUT / slices / registers | Setup WNS / TNS | 关键路径 |
| --- | --- | --- | --- | --- |
| Baseline | 879 / 411 / 1069 / 10 | 423 / 411 / 767 | +9.641 / 0 ps | `o_t5_6_reg -> o_s5_reg`，10.243 ns、9层（8 adder + 1 LUT） |
| Retime-only | 879 / 411 / 911 / 10 | 423 / 411 / 609 | +9.641 / 0 ps | 与基线相同，延迟不增 |
| DSP-only | 803 / 335 / 1006 / 14 | 423 / 335 / 639 | +10.058 / 0 ps | DSP寄存输出 -> `o_s6_reg`，9.826 ns、5层（4 adder + 1 LUT） |
| Retime + DSP | 803 / 335 / 848 / 14 | 423 / 335 / 481 | +10.058 / 0 ps | 与DSP-only相同 |

重定时单独减少158个门级顺序资源，关键路径没有增加；DSP映射增加4 DSP，同时减少76 LUT、76 ripple，并把Setup WNS改善417 ps。组合共减少221个门级顺序资源。此为综合后 timing summary，覆盖率约83–85%；没有布局布线或板上时序结论。逐变体报告在 `td/{baseline,retime,dsp_only,retime_dsp}/reports/`。

## 结果解读

可用于共享 v3 的低风险组合是纯 DSP scale 变体和删乘积冗余寄存拍变体。总算术拍减少一拍，输出 valid/data/index 对齐已由scalar与整块事务测试确认；DSP部分对完整32-bit有符号域位精确。TD 20 ns isolated Y top 的retime-only WNS与基线相同，DSP/组合路径改善约0.417 ns。是否纳入共享v3后的整机面积与峰值帧期限，以父完整top综合和回放结果为准。
