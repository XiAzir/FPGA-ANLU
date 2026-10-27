# C30音频实板回退排查 / C31分组消融

## 现场事实

用户反馈：C30图片、视频、按键、频谱正常；原声与内置音阶均为大量杂音，音乐不可辨。三模式LED符合C30定义。同卡同接线回载C29恢复。反馈原文摘要保存于 `c30_board_feedback.json` 及 `download/video30_probe_prune.board_feedback.json`。C29/C30源、位流及历史交付包保持。

## 已完成检查

- `source_audit.md`：音频mux、WAV bridge、tone、ACR和HDMI输入接线保持；未找到明确功能删改。
- `physical_audit.md`：两版布局及关键路径不同，历史setup/hold通过；现有报告与现场杂音因果尚未建立。
- `bram_audit.md`：11片音频packet FIFO BRAM的配置与数据映射一致。该报告以gate网表提供可读映射、以routed报告提供时序抽样，覆盖范围见正文。
- `audio_run.log`：C30与C31局部RTL音频输出逐周期对照，300000周期、565样本、11ACR一致；565次逐样本一位反相负控检出。输入包括切源、暂停/恢复、短暂无样本及复位。
- `gate_fixture/`：源注释筛选的局部网表未闭合，产生Z及valid差异，结果作废；改用完整最终网表和明确的音频时钟/复位边界。完整网表运行状态另见该目录凭据。

## C31的实验范围

工程 `development/player_video31_audio_ablation`。以C30为基础，仅恢复原C29 `player_audio_probe.v` 与该模块LED连接，数码管改 `00C11331`。其余探针裁剪保持。C31用于测试音频观察组恢复后板上表现是否变化，根因状态保持未确定。

`preparation.json`、四阶段构建门禁及交付绑定记录实际输入与产物。C31未复跑整机模型；历史C30整机PASS与其本次实板音频失败并列保留。C31实板结果待用户测试，暂无恢复成功结论。

## 构建准备修正

前两次综合由本轮主动中止：第一次发现analyze清除全局GateProperty，补回策略；第二次发现插入文本与TD输出的CRLF换行未统一，归一化后重启。日志分别为 `synthesis_pre_normalization_aborted.log` 与 `synthesis_mixed_lineend_aborted.log`。两次中止未生成交付位流，旧attempt按原状态保留，后续成功记录单独绑定；未修改门禁或接纳失配输入。

## 下一步

完成C31构建、最终网表/位流绑定与短时C29/C30音频网表检查后，交付独立分组对照位流。沿用当前TF、供电及HDMI，先听图片原声、内置音阶和视频原声；结果决定后续对照分组。C29持续作为已通过的回退。

## 最终状态（14:37）

C31四阶段/源/数据库/网表/位流/ZIP绑定完成，8681Slice=88.58%，62BRAM/26DSP，setup/hold+1.036/+0.024ns、TNS0。位流与包详见candidate verification/delivery_receipt.json。实板仍待用户验证。

额外完整C29/C30网表pair已编译并启动，但14:36:23主机内存采样93%、可用0.914GiB，故主动中止；未得到功能结论，状态FAILED_FIXTURE_UNKNOWN_VALUES。只结束本fixture的vsimk7712及launcher16940；14:37:13恢复到76%、可用3.487GiB，未见TD/ModelSim残留。完整pair测试未纳入C31通过项目。后续若再做mapped audio测试，应按单版本串行或真正闭合的小逻辑锥控制内存。


### 14:39｜完整网表测试终点核对更正

完整日志实际到达2000400ns/50010周期后由TB报告FULL_PAIR_FAIL unknown audio/ACR observations=50000；simulator exit0，外层因失败token拒绝，故主状态更正FAILED_FIXTURE_UNKNOWN_VALUES。此前高RAM引发停止请求，清理命令为对已知PID条件执行，进程自然失败退出与清理先后未确定。该夹具全程观察为未知值，force/alias边界需复核，不计入C31通过项目；本轮不再重跑。RSS原始2462736384字节为约2.46GB/2.29GiB。C31源/bit/ZIP与其局部RTL/构建通过结果保持。

