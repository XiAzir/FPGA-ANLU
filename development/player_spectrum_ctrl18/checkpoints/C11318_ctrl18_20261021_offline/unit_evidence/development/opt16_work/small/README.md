# opt16 small: status_hex595 窄计数器审计

日期：2026-10-21（北京时间）

## 范围与结论

只在本目录建立了 `status_hex595` 基线/候选副本与独立综合工程，生产 HDL、冻结目录和 bit 均未改动。候选把 `slot_count`、`half_count` 的声明宽度分别改为 `clog2(SLOT_CYCLES)`、`clog2(HALF_DIV)`，在取值不大于 1 时取 1 位。参数默认值对应 50,000 个 slot 周期和 25 个半周期，理论所需宽度为 16 位与 5 位。

该候选的资源消融结论为无收益，建议不合入：相同 TD 6.2.1_SP1 / EG4S20BG256 / AreaHigh + AdderThreshold18 设置下，基线和候选都得到 127 LUT、84 REG、166 LUT cells、37 PAD。综合器已在基线中完成高位裁剪。候选虽减少 RTL 声明位数，综合资源没有下降。

## 等价性与功能观察

两个计数器只在复位装载固定初值、有限范围递增、达到阈值时清零。`SLOT_CYCLES > 1` 时，`slot_count` 的状态始终不高于 `SLOT_CYCLES-1`；`HALF_DIV > 1` 时，`half_count` 始终不高于 `HALF_DIV-1`。位宽公式足以表示这些阈值，1 周期参数用 1 位覆盖。由逐寄存器归纳，窄计数器每拍保留相同整数状态，因此输出和状态转移一致。

逐拍验证改用工程自带 Icarus Verilog 完成：`iverilog -g2012 -s tb` 编译基线、候选和比较 testbench 成功，`vvp compare.vvp` 输出 `PASS cycles=52000 default parameters`，覆盖默认 50,000 周期 slot、数据移位/锁存及随机显示值变化。ModelSim 10.1c 曾成功编译同一 testbench，但其 CLI 仿真进程停滞且未给出结果；已终止该自启进程。

## 其他审计结果

- `player_adjust_control` 已使用独立参数派生的窄计数器；其多键互斥、长短按和队列逻辑若要压缩状态，需要对按键序列全域验证，本轮未发现可直接证明且有收益的局部重写。
- `player_status_monitor` 的秒计数和页计数已按参数派生位宽；饱和计数及跨域邮箱承担可见诊断语义，本轮保留。
- `video_rgb_to_axis_640x480` 的 `S_x_cnt` 为 11 位。由于 `I_de` 可连续保持为高，缩成 10 位会改变长行输入下 `==639` 的重复周期，未作为功能等价优化。
- 单独记录 `video_rgb_to_axis_640x480` 的 TLAST 疑点：行首分支把计数器设为 0，之后连续 DE 每拍加 1，而 `O_video_last` 检查时钟沿前的计数器是否等于 639。按该状态转移，连续行的命中相对第 640 个 active 样本存在一拍偏差；这轮没有改动或混入行为修复。

## 可复现证据

- 生产基线：`development/player_spectrum_spi12p5/src/user_source/hdl_source/status_hex595.v`，SHA256 `AFF2A8B7EB9CCB6D5E2785728DCE86BD8E87C4A96F33C20FA4B08FDC151852B9`。
- 候选副本：`candidate/status_hex595.v`，SHA256 `4CAF2BF6E9F645573F803F53A762E139D6F631A8F10470318C42C2FF205341D7`。因独立基线/候选同时编译，模块名分别改为 `_base`、`_cand`；功能改动仅为两个计数器声明宽度和两个派生 localparam。
- 综合脚本及完整运行日志：`baseline/run/run_syn.tcl`、`baseline/run/console.log`、`baseline/run/reports/gate.area`；候选对应文件位于 `candidate/run/`。
- 参数回读：各自的 `reports/actualparams.rtl.log` 与 `reports/actualparams.gate.log` 确认 `min_ripple_len=18`、`mapper_lut_delay=1600`、`add_map_lut_struct=high`、`map_mode=area_prior`。
- 比较 testbench：`tb.v`；仿真尝试记录：`modelsim.log`。该运行未完成，不能用作通过证据。


Icarus 输出与可执行文件留在本目录：compare.vvp（由项目内 bringup/tf_wav_hdmi/tools/iverilog/app/bin 的 Icarus 构建）。
