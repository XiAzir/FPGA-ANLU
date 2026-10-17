# C11310 FFT 计数器与状态页审计（只读）

记录日期：2026-10-14（北京时间）

## 核心结果

- Gate 网表 build/manual/AC201_tf_hdmi_gate.v SHA256：3008b47357b023a1c5c787b197460b807e9b410e975d8e133144e120e0b21f73。控制审计脚本 build/audit/audit_fft_register_controls.py；机器结果 build/audit/fft_register_control_truth.json。
- 432 组组合覆盖 state={0,1,16}、sample_count={0,11,1023}、audio_valid/reset/source_change/timeout 各0/1、accepted_samples={0,1,0xffffff}。6组未饱和的稳定有效捕获中 sample_count 与 accepted_samples CE 均为1；3组 accepted_samples 饱和时其 CE=0，为 RTL 饱和保持逻辑的预期行为。CE/SR 真值与预期无差异。
- 两组计数器 gate FF 的 CE/SR/D 实际脚已定位：sample_count CE=u_pcm_waveform/u_spectrum/mux98_syn_2[0]，accepted_samples CE=mux34_syn_2[23]，两者 SR=reset_pipe[1]_syn_4；AL_MAP_SEQ 模型核对 CEMUX=CE、SRMUX=SR、SRMODE=ASYNC、REGSET=RESET 均匹配。
- D 算术没有由脚本臆测：sample_count D 锥从 bit1–9、accepted_samples D 锥从 bit1–23 进入 EG_PHY_LSLICE MODE=RIPPLE, LSFMUX=SUM；需要厂商算术原语语义才能逐值证明。CE 穷举支持“稳定有效采样条件成立时两计数器获准推进”，但不证明 gate D 的实际算术值或板上同一时刻条件为真。

## 状态页路径

- RTL 页格式：page13 为 {8'hF2, fft_progress}，page14 为 {8'hF3, fft_events}，default/page15 为 {8'hF4, fft_accepted}，定义在 src/user_source/hdl_source/player_status_monitor.v。优化 RTL 的 selector 是 cw_count_data[8:5]，完整四位页值为13/14/15。
- 优化 RTL gate 页映射审计脚本 build/audit/audit_status_mux.py，结果 build/audit/status_diagnostic_mux_truth.json。binary_mux_s4_w1 的15个 AL_MUX 原语树对256组 selector/one-hot 输入组合全通过；页13/14/15的32个 hex_value_b1 输出位共2144项检查零差异。
- F2/F4 的24位 payload walking-one 全覆盖；F3 的 debug_events[15:0] walking-one 通过，高8位保持零；三个页的固定 F2/F3/F4 前缀连接正确。因此当前静态 gate 证据不支持“16:1 MUX 截断诊断页”。F3 高8位为零来自 RTL {8'd0,recovery_count,source_change_count} 定义。
- routed 原厂模型 smoke 另有动态控制证据，console 为 build/board_feedback_no_signal_20261014/modelsim/smoke_control_console.log。该测试强制 sys/video PLL lock 输入并置 tone_mode=1，保留自然复位分发释放；PCM n=1..4 时 progress 依次000200/000400/000600/000800，accepted依次1/2/3/4，支持该受控条件下 sample_count 与 accepted_samples 在 routed primitive 模型内推进。最终 locked=0、SOF=0、FFT帧=0；没有TF卡或HDMI接收端模型，锁定位由测试平台强制，故不模拟板上启动或完整FFT成功。events=zz0001 的高8位因优化常量被消去而悬空，只能读取低16位，不能将z解释为实际硬件值。
- Gate walking-one 仅证明优化 RTL mux 与位接线；上述 routed smoke 只测计数器控制路径，没有验证 routed 页 MUX 或完整 mailbox/source_hex 显示映射。reset_pipe[1] 在消费端使用 sys_clk，但 routed 导出未保留可识别的 analyzer reset_pipe Q 产生实例，因此 Q/CLK 别名仍未完整核实。板端条件和快照仍需动态证据。

## 对现场观测的约束

用户现场观测由主代理转述：F2 state0、样本计数11/12，F4=0，source-change=0。它与稳定 state0、audio_valid=1、local reset/source-change/timeout 均为0时“接受样本应增加”的预期不吻合。现场没有同步的 audio_valid、timeout_pulse、reset_pipe[1] 和快照时点；因此当前证据仍不能区分有效音频脉冲缺失、短暂复位/切源/超时或显示快照时差，也不能认定唯一根因。

## 未完成与下一步

- 未完成：routed 页选择和位映射、status mailbox/source_hex 下游显示链、reset_pipe[1] 的 Q/CLK 时钟别名核查；本次 gate MUX 通过及 routed 计数器 smoke 均不能证明这些部分或板端快照正确。
- 未做：生产 RTL 修改、功能仿真、TD/新布线、位流或板卡操作；本轮仅做静态 gate 网表/RTL审计。
- 下一步：核对 routed 的页选择与诊断位映射，再追 mailbox/source_hex 到显示输出的快照路径；独立确认 reset_pipe[1] 的 Q/CLK 网络别名。若现场值仍矛盾，需同一边沿的 audio_valid、局部复位、计数器 Q 和快照时点证据。

