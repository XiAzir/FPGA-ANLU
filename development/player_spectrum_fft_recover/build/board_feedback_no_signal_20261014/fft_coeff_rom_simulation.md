# C11310 原厂 FFT 系数 ROM 与恢复整帧仿真

- 状态：两项 ModelSim 仿真均 PASS；仅仿真副本做声明顺序兼容，C11310 生产源未改。
- 环境：ModelSim SE-64 10.1c、TD 6.2.1 SP1 已编译 EG4 库。独立目录 modelsim/fft_modelsim 的 work 与既有 modelsim/arith_modelsim/work 隔离；前者 EG4 = ../work 只读使用后者。vlog 未定义 PRIVATE_ROM_BEHAVIORAL_SIM，加载日志实际显示四个 EG_PHY_BRAM 实例。
- 兼容副本：使用 development/player_spectrum_contract_fix/src/user_source/hdl_source/player_spectrum_analyzer.v。与 C11310 analyzer 的 git diff --no-index 仅将 reg [8:0] twiddle_addr; 从第181行移至首次实例端口使用之前，并增加一行注释；除此之外无内容差异。ROM SHA256 与 C11310 相同：975F99493B1A2D47E9131F0BE6B61154CC8D31E6D4017E3BF2515F63CB6FDD04。未将兼容副本回写 C11310。
- 整帧 golden 测试：实际 C11310 spectrum_coeff_rom.v + 候选 analyzer + tb_player_spectrum_analyzer.v，向量 sim/vectors/all_samples.mem，黄金值 sim/vectors/all_expected.mem。结果：PASS spectrum_analyzer cases=13 output_bands=312 max_fixedpoint_error=0 physical_rate_capture=521clk plus_continuous_frames=2 source_change_abort=2 reset_abort=1。包含13组帧/312频带、实速521clk采样、连续帧、捕获期与分析期切源中止、分析期复位中止。运行日志 modelsim/fft_modelsim/run_candidate_glbl.log，编译日志 compile_candidate_retry.log。vopt 对未连接新增观测端口 debug_coeff_nonzero 给出 warning；测试输出无数值误差且 exit 0。
- 默认恢复/watchdog 测试：同一 work 中 tb_fft_recover，默认 FRAME_TIMEOUT_SAMPLES=4096，采样向量同上。结果 PASS：异步断言/同步释放，切源局部清进度，17..31 非法状态恢复，实速正常帧，4096有效输入样本看门狗恢复，停滞解除后自主输出下一帧，telemetry饱和；全程 global_reset_edges=1，无源反馈。运行日志 modelsim/fft_modelsim/run_recovery_retry.log，编译日志 compile_recovery.log。
- 结论边界：这是 ModelSim 的原厂 EG_PHY_BRAM 功能模型和 C11310 系数 INIT 的整帧功能验证，不是 TD 新综合/布局布线、SDF 或实板测试，也不能单独确定 C11310 板端停滞根因。
