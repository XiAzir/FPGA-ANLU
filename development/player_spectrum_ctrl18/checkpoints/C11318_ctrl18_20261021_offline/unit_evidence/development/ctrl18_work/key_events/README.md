# CTRL18 key event candidate

当前目录保存未接入正式工程的按键事件化候选、loader 接口副本、reference/candidate 差分测试和复跑证据。正式基线与 `player_spectrum_ctrl18` 均未修改。

## Spec

- 两个物理按键仍是 active-low 输入，原二级同步链、20 ms 稳定采样、KEY0/KEY1 单键长按、组合键优先级、释放后重臂、音调/波形短事件与亮度/对比度编辑均保留。
- PLAY 模式下的短 KEY0/KEY1 事件由旧 active-low 100 ms 输出改为独立 toggle request。源端将 request 保持到 loader ack 经二级同步返回；loader 端用二级 request 同步链识别 toggle，更新 ack 并产生一拍 `next_press` / `auto_press`。请求不丢失依赖 req/ack 握手。
- 每个按钮仍有各自的一深 pending 合并位。第一次事件立即发出；同一按钮在 cooldown 期间的任意多个短事件合并为一个待发事件。cooldown 沿用旧 `PULSE_MS + LEGACY_GAP_MS` 的总窗口。旧实现从低脉冲开始到 pending 低脉冲再次开始实测为 201 个源时钟周期；候选保留相同周期与事件顺序。
- 同拍 next/auto 请求使用两条独立 mailbox，可同时 ack，并让两路各产生一个接收时钟周期的事件脉冲；loader 中既有 next 分支先于 auto 分支的处理次序保持。物理组合键仍在源端仲裁后压制各自单键短事件。
- 按键动作到 loader 的接受时间提前：旧链路等 50 ms `key_press_debounce`，候选链路等 request 双触发器同步及 loader 一拍消费。25 MHz 控制时钟、50 MHz SD 时钟下，候选请求到 loader 消费不超过约 80 ns；旧路径约 50 ms，预期提前约 49.9999 ms。异步差分模型测得 686 ns 的提前量；测试时参数为 1 kHz、50 ms debounce、异步 100/71.4 MHz 等效时钟周期，时钟按 10 ns / 14 ns 运行，因此以接收时钟周期报告为 49 个周期，正式时钟下的绝对值按上述生产参数推算。
- 这会改变事件到达 `load_busy` 边界的相对时点，窗口约 50 ms。控制器产生的源端事件数和次序保持，loader 原有 `next_pending` 一深合并逻辑保持；若事件落在忙闲转换前后，开始处理的时刻可能提前最多约 50 ms。loader 场景的忙态完整行为由 root 后续独立测试。
- 生产控制时钟 25 MHz 下，旧两路各有 22-bit pulse/gap counter；候选每路一个 23-bit 200 ms cooldown counter，按计数状态位数净减 42 位。loader 原每键有 32-bit debounce counter、两个 synchronizer、稳定状态和 pulse 共 36 位；候选每键是 2-bit request synchronizer、ack 和 pulse，共 4 位，RTL 状态位粗算再少 64 位。req/ack 控制器同步触发器已计入这些数字；两域合计约少 102 个状态位，综合净收益以 root 的同 ID 报告为准。
- 跨域链均保留同步级。源端 req 与 loader ack 使用 toggle 握手，loader 不会以未同步原始按键替代事件。每 lane 最小间隔是 200 ms 冷却窗口，跨域往返握手是数个 source/destination 周期；25/50 MHz 下相差约六个数量级，且源端明确等待 ack 后再翻转 req。

## 差分测试与证据

复跑：在工程根目录执行 `development/ctrl18_work/key_events/run_key_events.ps1`。脚本使用本机 Icarus Verilog 12.0；只运行 Icarus 编译、loader 模块 elaboration 和 VVP 行为仿真，不运行 TD 或综合。

本轮通过日志见 [run.log](run.log)、[compile.log](compile.log)、[loader_elab.log](loader_elab.log) 和 [iverilog_version.log](iverilog_version.log)。测试台用基线控制器副本和原 `key_press_debounce` 逻辑作为 reference；两路 source/destination 时钟异步。76 项断言覆盖：短抖动、单短按、三次快速短按压成两次、next/auto 交错、事件顺序、同拍两个 mailbox、KEY0/KEY1 长按、近阈值组合键优先、PLAY 短组合键波形动作、编辑模式、VS 更新、长组合键、被中断的组合键 hold、reset 清空 req/pending/cooldown 和 reset 后重新接收。

通过结果：reference/candidate 在 reset 前均为 next=3、auto=1；三次 next 短按各在同一 200 ms 窗口内时输出两事件。第一条 source event 及其 queued follow-up 的两次时间戳逐周期一致，间隔 201 source cycles。receiver 第一事件差值为 686 ns，即该异步模型的 49 个接收时钟周期；生产时钟下对应约 50 ms 的输入 debounce 去除。Reset 后 reference/candidate 都只接收一条新事件。

第一次 201 拍断言失败日志保存在 [iteration_01_failed_cooldown_assertion.log](iteration_01_failed_cooldown_assertion.log)。失败来自 testbench 的单位换算：`time` 变量算术采用 ns，而 `%0t` 展示采用 ps；RTL 测得间隔为 2010 ns，格式化显示 2010000 ps。断言按 ns 修正为 2010 后通过；同一处将 686 ns 接收差的边界修正为 560..900 ns。修正只触及测试断言，没有改动候选 RTL。

[source_receipt.json](source_receipt.json) 固定正式基线、候选、reference 副本、测试台、复跑脚本和接线 patch 的 SHA256；[verify_source_receipt.ps1](verify_source_receipt.ps1) 的逐文件核验日志见 [source_receipt_check.log](source_receipt_check.log)，8 个路径全部 PASS。候选 loader 源文件仍是用于人工/后续集成的完整接口副本；[top wiring patch](top_tf_hdmi_audio_event_wiring.patch) 给出顶层 toggle/ack 连线，并已通过 `git apply --check`，当前未应用。

## 集成顺序

1. 将本目录 `player_adjust_control.v` 作为候选控制器源替换到正式候选工程。
2. 将 `tf_bmp_file_player_event_candidate.v` 中同名 loader 模块用于工程候选，并按其文件加入工程文件列表。该副本已移除 `key_press_debounce` 两实例，嵌入 `key_event_mailbox_sink`，并保持 loader 内部原 `next_press` / `auto_press` 使用点。
3. 按 `top_tf_hdmi_audio_event_wiring.patch` 将两组 request/ack 四线接入顶层。两模块使用共同 `rst_all`，两条方向的同步级均位于各自接收时钟域。
4. 按 root 的独立 loader 忙态测试通过情况决定是否晋升；本目录结果只证明控制器侧事件数/时序和 sink 握手，不构成完整 BMP loader 仿真、TD 编译、综合、布局布线或板测结论。
