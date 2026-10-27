# HDMI 串行时钟与 PHY 字恢复审计

## 结论范围

在 ModelSim SE-64 10.1c 中，以 EG4 官方仿真模型驱动生产 `lane_lvds_10_1` 和 `EG_LOGIC_ODDR`，对 C32 25/125MHz、C33 33/165MHz 的原始串行时钟和经 BUFG 的串行时钟进行 10bit 字恢复比较。每种情况均连续恢复 16 个输入字，首字 `01f` 之后的15个字全部匹配；首字在捕获流的bit 17处定位。测试集覆盖 `000`、`3ff`、`155`、`2aa`、`001`、`200`、`3fe` 等边界/交替字。C32与C33均没有首个偏差。

夹具把 HDMI Core 输入字按生产 `hdmi_phy_wrapper` 的10bit反序映射后驱动lane，从lane四级输入中的单lane进行物理串行输出采样；其余lane的位值差异与字恢复无关。真实 EG4 PLL模型生成像素/串行时钟，ODDR由EG4功能模型实现，receiver scoreboard只看输出pin序列。

## 结果

| PLL源工程/路径 | pixel周期 | serial周期 | 稳态占空测量 | 16字恢复 |
|---|---:|---:|---|---|
| C32：25/125，串行BUFG | 40.000ns | 8.000ns | 两路均50/50 | PASS |
| C33：33/165，串行直连 | 30.30305ns | 6.06061ns | pixel高/低约15.151ns；serial高/低约3.029ns | PASS |
| C33：33/165，串行BUFG | 30.30305ns | 6.06061ns | 与直连同源 | PASS |

占空测量在模型启动5ms后采集20个像素周期、40个串行周期，避开模型初始启动瞬态。EG4仿真模型的BUFG是透明连线，模型中直连与BUFG的波形一致；这不测量芯片全局时钟树的传播、偏斜或抖动，也不证明漏接BUFG是屏幕无信号的原因。PLL模型的`extlock`未作为本夹具PASS条件。

## 可复跑文件

- [tb_lane_scoreboard_c32.sv](tb_lane_scoreboard_c32.sv)、[run_c32.do](run_c32.do)、[audit_c32_final.log](audit_c32_final.log)
- [tb_lane_scoreboard_c33.sv](tb_lane_scoreboard_c33.sv)、[run_c33.do](run_c33.do)、[audit_c33_final.log](audit_c33_final.log)
- [tb_pll_duty.sv](tb_pll_duty.sv)、[run_duty_c32.do](run_duty_c32.do)、[duty32.log](duty32.log)
- [run_duty_c33.do](run_duty_c33.do)、[duty33.log](duty33.log)
- [640×480单帧时序夹具](tb_vga60_timing.sv)、[运行记录](vga60.log)

ModelSim脚本使用安装目录 `C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4` 中的 `eg_phy_pll.v`、`eg_logic_io.v`、`eg_logic_clk.v`、`eg_phy_glbl.v`。`run_c32.do` 编译 C32 实际 `video_pll.v` 与 C32 `lane_lvds_10_1.v`；`run_c33.do` 使用 C33 实际文件。两脚本分别执行：

```powershell
vsim.exe -c -l audit_c32_final.log -do run_c32.do
vsim.exe -c -l audit_c33_final.log -do run_c33.do
vsim.exe -c -l duty32.log -do run_duty_c32.do
vsim.exe -c -l duty33.log -do run_duty_c33.do
vsim.exe -c -l vga60.log -do run_vga60.do
```

`vga60.log`结果：550,000像素周期；DE 307,200；HSync低电平52,800；VSync低电平2,000；AXIS SOF 1、有效像素307,200、EOL 480。33MHz/550,000 = 60fps。

## 候选源

等待根代理恢复TD串行构建许可后，再依次构建：

1. [C11336_1080p15_serial_bufg](../candidates/C11336_1080p15_serial_bufg/README.md)：仅给C33串行时钟恢复`EG_LOGIC_BUFG`，分辨率、刷新率、PLL与PHY参数保持不变。
2. [C11335_640x480_60hz_33_165_bufg](../candidates/C11335_640x480_60hz_33_165_bufg/README.md)：同33/165MHz与相同PHY全局时钟路径，改640×480/60Hz自定义扫描，供显示器接收端对照。

两项候选源已分目录创建，C33已测试源码/位流未覆盖。TD综合、布局布线、hold修复、STA和bitgen尚未运行；实板测试待根代理安排。

## TD后续候选构建（2026-10-27）

根代理许可窗口内按C11336→C11335串行构建，未覆盖C33原工程/位流。

| 候选 | Bit长度 / SHA-256 | Routed STA | 资源/运行 |
|---|---|---|---|
| C11336 | 629,624B / `CA1B412A5D9CB601562282AA33B77B4E018DE9DB2A52B722C6458892CBA2B628` | coverage99.60%，32.999/165.017MHz，SWNS+1.643ns，HWNS+0.024ns | gclk=2；最大TD WS/Private 501.0/491.6MiB |
| C11335 | 629,624B / `627F77A1DD1B19F3130F78448FB10F589954CD417D9CEB60CF49F82BAA550C78` | coverage99.64%，32.999/165.017MHz，SWNS+1.755ns，HWNS+0.041ns | gclk=2；最大TD WS/Private 502.3/491.7MiB |

两者STNS/HTNS均为0；像素/串行时钟报告频率与C33同；hold修复前最差裕量分别11ps、4ps，修复后为24ps、41ps。所有脚本退出码0且TD进程已退出。两条route日志都含 `PHY-5014 Detail route doesn't find pib for u_video_pll/pll_inst.fbclk[0]`；PLL实例`FEEDBK_PATH=VCO_PHASE_0`且`.fbclk(1'b0)`，属于当前VCO内部反馈选择下未用的fbclk输入提示。保留原始route日志供核查。

C11336源级差异已相对C33 `src/user_source`所有文件逐项对比，除`top.v`外语义文本相同；顶层只将serial clock接线由直接 `clk1_out(serial_clk)` 改为 `clk1_out(serial_clk_raw)`→`EG_LOGIC_BUFG`→`serial_clk`，并把数码管build ID从`00C11333`改为`00C11336`。项目名/项目绝对路径/构建输出路径改名属于隔离构建配置。C11335为独立低分辨率后备，等待C11336现场结果后由根代理安排。
