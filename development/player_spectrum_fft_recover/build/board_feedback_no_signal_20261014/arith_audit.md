# C11309 / C11310 算术与计数器 routed 网表审计

日期：2026-10-14。范围为既有 routed 网表/源码只读核查，以及用原厂 EG4 ModelSim 库对提取单元进行的限定仿真；不改生产 RTL/冻结 bit/交付物，不运行 TD 构建。

## 结论

- C11310 的 10 位 `sample_count + 1` 映射为三段 `EG_PHY_LSLICE`：`add4_syn_62`（低段）、`add4_syn_63`（中段）、`add4_syn_64`（高段），实例位于 routed 网表 161742、161775、161799 行。低→中 `fco=add4_syn_54` 与中段 `fci=add4_syn_54` 同网；中→高 `fco=add4_syn_58` 与高段 `fci=add4_syn_58` 同网。中高段输入取 `debug_progress[12..18]` 并输出 `sample_count_b6[3..9]`；低段输入含 `debug_progress[9..11]`，输出可见 `b6[1:2]`。控制字为 `MODE=RIPPLE`、SUM mux、低段 LUTF0 `000A`/LUTF1 `A55A`/LUTG0/G1 `C33C`，中高段 LUTF0/F1 `A55A`、LUTG0/G1 `C33C`。`debug_progress[9..18]` 的 RTL 打包对应 sample_count[0..9]。
- 位 0 的器件级求和真值仍未证明：低段 primitive 无显式 `fci`，可见 `.f/.fx` 的 bit-0 对应输出为 `open_n156154/open_n156155`；同段 `.q` 也接 `open`。网表片段不能证明 open 节点就是实际 `sample_count_b6[0]`。因此不能把 ripple 名称/相似结构表述为 `+1` 真值已通过器件方程验证。
- C11309 相同功能低/中/高段为 `add0_syn_62/63/64`（routed 网表 161977、162014、162038）。其 carry 链同样为 `add0_syn_54→add0_syn_58`，段间同网连接。C11309 低段配置 `CEMUX=CE` 且带 `.ce`，C11310 低段配置 `CEMUX=1` 且没有 `.ce`；两者均有低段时钟/寄存器相关端口。中高段寄存器选项不同，但 ripple 参数族与 carry 拓扑相同。此差异是物理映射选项差异；由于不能由网表文本 alone 说明未连接控制输入的芯片常量行为，且没有 primitive 仿真，不能断言其造成板测。
- C11310 的计数寄存器 Q 均用 `u_status_monitor/sys_clk` 与 `reset_pipe[1]` 异步 SR，但 CE 网络不同：`sample_count_reg` 用 `mux98_syn_2[0]`（首个寄存器网表 167159）；`accepted_samples_reg` 用 `mux34_syn_2[23]`（160970）；`frame_age_samples_reg` 用 `mux31_syn_2[0]`（低位输出寄存器网表 164212）。这构成值得查证的 CE 差异，不证明哪条 CE 在实板有效/无效。reset_pipe[1] 的 Q 实例位于 168436，clk 为 `u_status_monitor/sys_clk`、SR 为 `startup_flags[1]_dup_4417`。reset_pipe[0] 的 Q 实例位于 182692，其 `.clk` 也为 `u_status_monitor/sys_clk`，`.sr` 同为 `startup_flags[1]_dup_4417`。
- 按源码，`accepted_samples` 仅在 `sample_write_en && accepted_samples!=24'hffffff` 更新；`sample_count` 则在外层未触发 `fft_reset/source_change/timeout_pulse` 且 `state==ST_CAPTURE && audio_valid` 时更新；`frame_age_samples` 在 `audio_valid` 时更新，或按 `frame_done` 清零。`sample_write_en` 源码定义还含 `!fft_reset && !source_change && !timeout_pulse && state==ST_CAPTURE && audio_valid`；因此源码上它是在 sample_count 的 ST_CAPTURE/audio_valid 更新条件基础上又增加了复位/切源/超时门控，而不是与 sample_count 完全相同。板测描述（F2 约 8–14、F4 accepted=0、locked=0 等）来自 root 转述的用户反馈，非本审计直接采集。

## 真值与范围边界

- 本地 TD `arch/eagle_macro.v` 给出 LSLICE 的端口与参数声明，标注 `MODE` 可为 `RIPPLE`、`LSFMUX/LSFXMUX` 可为 `SUM`，端口声明包括 `fci/fco/f/fx`；它不是功能定义。安装目录的 `sim_release/eg4/eg_phy_mslice.v` 功能体为 `pragma protect` 加密，未能用该模型执行 primitive 级真值验证。
- `arith_audit.json` 由相邻只读提取脚本生成；其中 10 位无符号模加 1 的 1024 状态穷举属于**参考 recurrence test**，只验证普通整数参考函数，不验证 routed LSLICE LUT、引脚位序或 fci/fco 器件语义。
- 静态网表可证 carry 网络拓扑相连，不能证实实际板上 CE、SR、状态、PLL/HDMI 接收或 locked 变化。现证据不足以把算术映射确认为 C11310 无信号/F4 不增的根因。更直接候选是 `sample_count` 与 `accepted_samples` 的 CE 条件网络不同、或 reset/state/audio_valid/sample_write_en 门控差异；这只是排查优先级，不是因果结论。

## 下一步最小验证

1. 对 `sample_count` 与 `accepted_samples` 同步采集寄存器前的 CE 源、`state/audio_valid/sample_write_en/source_change/timeout_pulse/fft_reset/reset_pipe[1]` 和对应 Q；用同一 `sys_clk` 边沿比较“CE 有效而 Q 未更新”是否发生。
2. 若需验证真实 `+1`，建立最小网表 primitive test fixture，按 TD 支持的受保护模型仿真流程实例化三段 LSLICE，并逐状态检查 10-bit `sum==(input+1) mod 1024`、carry 边界与 bit0；本轮未运行该仿真。若受保护模型不可用，须取得官方公开方程或独立厂商验证模型后再声称 primitive 真值通过。
3. 保留现有 C11309 回退与 C11310 证据，不以随机 seed 或 RTL 修改替代上述区分实验；无需重跑 TD 构建。


## ModelSim 原语验证增补（2026-10-14）

- 使用 ModelSim SE-64 10.1c 与 TD 6.2.1 SP1 已编译的 EG4 库。在独立 modelsim/arith_modelsim/work 编译 testbench，通过 EG4.glbl 与用户级 MGLS_LICENSE_FILE 启动；没有使用 root 正在跑整网表 smoke 的 work。
- testbench 的 10 个 EG_PHY_LSLICE cell 从 active C11310 routed 网表逐项提取参数和已连接端口：sample_count 三段 add4_syn_62/63/64；accepted_samples 七段 add1_syn_146…152。没有在 TB 中手写 SUM 或进位方程；各实例其余 unused output 端口均显式留空。
- ModelSim PASS：sample_count 对 1024 个输入逐一比较 routed 可见输出 [9:1]，检查低段 8 输入组 carry 与中段 128 输入组 carry；accepted_samples 检查 0、1、7、15、255、4095、65535、FFFFFF 向量的可见 [23:1] 输出及六级 carry 边界。日志 modelsim/arith_modelsim/sim.log；脚本 modelsim/arith_modelsim/generate_arith_tb.py；TB modelsim/arith_modelsim/tb_arith_routed_cells.v。
- 范围限制：active routed 低段中 sample_count_b6[0] 未由 LSLICE 的 f/fx/q 可见连接驱动，accepted_samples_b3[0] 也未由其低段 sum 输出显式驱动；故 TB 不把 open 当成实际 bit0，也不宣称完整总线 bit0 到寄存器 D 的端到端算术已证。板上 CE/reset/state/audio_valid 与无信号的因果仍未确定。

## ModelSim 原语验证（最终结果，2026-10-14）

本节更新先前“尚未运行 primitive 仿真”的阶段性描述。TD EG4 原厂库已编译入共享模型库；在 modelsim/arith_modelsim/work 使用独立工作库编译并运行 testbench，使用 EG4.glbl 与继承到进程的用户级 MGLS_LICENSE_FILE。未使用 root 正在运行整网表 smoke 的 work。

Testbench 中 10 个 EG_PHY_LSLICE 实例的配置参数和全部端口均来自 C11310 active routed 网表：sample_count 的 add4_syn_62/63/64 三段，accepted_samples 的 add1_syn_146…152 七段；未手写 SUM 或进位逻辑。

- PASS：sample_count 10 位全部 1024 个输入，比较 routed LSLICE 可见 sum [9:1]，检查低到中 carry（8输入边界）及中到高 carry（128输入边界）。
- PASS：accepted_samples 对 0、1、7、15、255、4095、65535、FFFFFF 检查可见 sum [23:1] 与六级 carry 边界。
- 证据：modelsim/arith_modelsim/tb_arith_routed_cells.v、generate_arith_tb.py、sim.log；vlog/vsim退出码均为0，最终日志无失败断言。
- 边界：active routed 低段 bit0 sum 端口在 f/fx/q 映射中为 open；testbench 未把 open 冒充真实 sample_count_b6[0] 或 accepted_samples_b3[0]，所以 PASS 限于可见输出位和 carry。外围 bit0 形成逻辑及完整计数器 D 端未在本 fixture 中验证。

该原语验证不覆盖外围寄存器 CE/SR、FFT 状态机、板端有效采样条件或 HDMI locked。F2/F4 矛盾及无信号板端根因仍未确定；下一步应在同一个 sys_clk 边沿同步采集 sample_count/accepted 的 CE、Q 及 state/audio_valid/sample_write_en/source_change/timeout_pulse/fft_reset/reset_pipe[1]。

复跑方式：进入 modelsim/arith_modelsim，继承用户级 MGLS_LICENSE_FILE，再执行 vsim -c -modelsimini modelsim.ini -lib work -L EG4 EG4.glbl tb -do 'run -all; quit -f'。
