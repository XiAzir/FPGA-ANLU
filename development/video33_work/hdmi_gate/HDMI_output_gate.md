# HDMI 输出硬门槛与 1080p30 彩条候选

日期：2026-10-27

## 当前判断

1080p30 目标时序为 1920×1080、总时序 2200×1125、像素时钟 74.25 MHz；10:1 TMDS 序列化需要 5×像素时钟 371.25 MHz，并通过 DDR 输出，线速率 742.5 Mbit/s。

当前 C32 发送时钟为 125 MHz，低于 Emulated LVDS 的 166 MHz 上限。此 C32 时钟值不能拿来代表 1080p30 目标；目标发送时钟 371.25 MHz 才是超出 Emulated LVDS 规格的数值。

## 板级证据

- C32 约束 `development/player_video32_read_return/src/user_source/constraints_source/pin.adc` 把 HDMI_CLK_P、HDMI_D0_P、HDMI_D1_P、HDMI_D2_P 分别设为 `LVDS33_E`，引脚为 B10、D11、C11、F10。
- DS301 EG4S20 BG256 引脚表（第19页）将四个 HDMI 差分对列为 BANK0 的 IO_BE10、IO_BE4、IO_BE8、IO_BE3；对应 P/N 为 B10/C9、D11/D12、C11/A11、F10/H11。手册所查表格未解释 BE 缩写；按 BG256 封装坐标将其理解为 Bottom Edge 仍属待验证推断。
- AC201 ES8388 底板图纸 `AC201_底板_旧版_ES8388.pdf` 第6页显示 HDMI 对从 FPGA 引出，经 AZ1045-04F ESD 阵列及耦合电容连到连接器；页面未见 LVDS Emulated 输出所需的 3R 衰减网络。
- DS300 EG4 数据手册 v3.9.6 第46页（印刷页码）2.7.2节：True LVDS 发送无需外部匹配网络，最大输出频率400 MHz；Emulated LVDS 发送最大输出频率166 MHz，并要求3R网络。第81页表3-2-5重复给出 LVDS25/LVDS33 为400 MHz，LVDS25E为166 MHz。
- TD I/O 映射探针已对 B10、D11、C11、F10 四个现用 HDMI P 脚分别尝试 `LVDS33`。四种映射均在 `read_adc` 阶段报 `USR-8059`，每脚的 valid values 列表包含 `LVDS25_E`、`LVDS33_E`、`LVPECL33_E`，不包含 `LVDS33`。B10 示例日志为 `development/video34_work/io_probe_native_console.log`；三个数据脚分别记录在 `io_probe/data0_lvds33/build/run_console.log`、`data1_lvds33/build/run_console.log`、`data2_lvds33/build/run_console.log`。因此工具数据库确认当前四个管脚只能采用 Emulated 标准，不能选择 True-LVDS `LVDS33`。
- 原 Emulated 四脚组合已完成 TD elaborate、映射合法化和时序报告：`io_probe/lvds33e/build/hdmi_io_probe_lvds33e.area`、`.timing`、`.ts`、`.db`。门控逻辑/IO标准可映射；此微型探针的 50MHz 输入与输出翻转不验证 HDMI 高速串行时序。
- 对当前 `LVDS33_E` 路径采用166 MHz门槛符合器件规格。现有板载输出链路没有承载371.25 MHz的合规 I/O 标准；正常1080p30需要改用可承受该链速的外部 HDMI/TMDS 发射器，或更换 FPGA 输出引脚/板级路径并重新设计高速硬件。

## TD I/O 标准映射探针

`io_probe/lvds33e` 是现有四脚 Emulated 映射对照，TD已完成合法化并生成报告；文件位于其 `build/` 子目录。`io_probe/lvds33` 对 B10 HDMI_CLK_P 设 True-LVDS 标准并在 `read_adc` 阶段收到拒绝。`io_probe/data0_lvds33`、`data1_lvds33`、`data2_lvds33` 分别仅对 D11、C11、F10数据脚设 True-LVDS，三者也在 ADC 阶段拒绝；各自 `build/run_console.log` 记录引脚和有效标准列表。原始根代理运行日志保存在 `development/video34_work/io_probe_native_console.log` 与 `io_probe_e_console.log`，未覆盖。

当前证据足以确认AC201现有四组 HDMI 输出引脚只能选 Emulated I/O 标准。I/O probe不含PLL、高速串行器或165MHz/371MHz时钟，合法化和STA结果只覆盖其50MHz小逻辑。

## 可选视频输出方案

### A. 先试1080p15，沿用现有 HDMI 接口

建议配置：HACTIVE=1920、HTOTAL=2000；HSA/HFP/HBP=8/8/64；VACTIVE=1080、VTOTAL=1100；VSA/VFP/VBP=5/4/11；像素时钟33.000 MHz、串行时钟165.000 MHz、DDR线速率330 Mbit/s。帧率精确为15 Hz。165 MHz低于 `LVDS33_E` 的166 MHz规格上限1 MHz，约有0.6%频率余量，属于极限贴边候选；当前微型I/O探针的 STA 不覆盖这组源同步输出时钟，仍需独立时序约束和高速板级测量。

从50 MHz板载参考时钟可构造EG4 PLL No compensation参数：`FEEDBK_PATH=VCO_PHASE_0`、`REFCLK_DIV=2`、`FBCLK_DIV=33`，即PLL参考分频N=2、反馈倍频M=33、PFD=25MHz，VCO=825MHz；C0=25输出33MHz、C1=5输出165MHz。VCO落在DS300给出的300–1200 MHz范围内，所有分频值小于128。C32 `video_pll.v` 使用 `CLKC0_EXT` 回授；C33改用IP支持的No compensation/VCO反馈，避免把其M/N参数套用到C0_EXT反馈公式。

APUG092第5–6页列出的 HDMI Core 参数范围为1–16383，覆盖上述总时序和活动区尺寸；手册第9页说明外部视频行长/行距/帧距分别对应HACTIVE/HTOTAL/VTOTAL，并要求每行有效输入连续。手册没有列出可用于核实音频/辅助包调度的最小水平或垂直消隐限制。此模式每帧含126,400个消隐像素时钟（80×1080+2000×20），48 kHz下每帧输入3,200个样本，约39.5个消隐像素时钟/样本；现有加密Core的包调度尚无独立仿真证明。当前 C32 的 ACR模块用N=6144，按33 MHz像素时钟算 CTS=33000，可由20位接口表达。

显示兼容性：1920×1080@15Hz及2000×1100自定义总时序不在常见标准模式表中；AC201底板HDMI DDC未接FPGA，发送端不做显示器EDID协商。请将此选项标为“待显示器实测”，记录显示器识别/无信号信息、稳定性和画面。若显示器拒绝此模式，仍需重新核算任何替代 porch/总时序对应的像素/串行时钟及LVDS33_E上限。

### C33 独立诊断实现与证据

- 已生成 [`AC201_video33_1080p15_diag.bit`](<E:/VSCODE-project/FPGA-ANLU/development/player_video33_1080p_output/build/manual/AC201_video33_1080p15_diag.bit>)，大小629,624 bytes，SHA-256 `DA3403C8390C27FE6579E7B0CFB060144464B6AFCC3A44A21D08885431CEB44D`；项目和所有修改均在 `development/player_video33_1080p_output/`，C32原工程未覆盖。它只输出八色竖条并对四路现有TMDS路径编码/序列化，Core音频/ACR输入固定无效。
- `.ipc`与PLL wrapper设定是No compensation/VCO反馈；最终gate网表含 `FBCLK_DIV=33`、`REFCLK_DIV=2`、`CLKC0_DIV=25`、`CLKC1_DIV=5`、`FEEDBK_MODE=NOCOMP`、`FEEDBK_PATH=VCO_PHASE_0`。EG4 vendor primitive model仿真测到像素周期30.3024ns、串行周期6.0610ns（33.000686/164.989276MHz）；TD `derive_clocks` 报50MHz派生为pixel 33MHz、serial 165MHz，routed STA显示32.999/165.017MHz。EG4仿真primitive的 `extlock` 在当前ModelSim仿真中未拉高，C32正常反馈配置的该模型也未拉高；硬件LED0保留实时lock指示，reset由像素域启动计数器控制。
- 帧级ModelSim测试 PASS：帧2,200,000 pixel cycles，有效2,073,600，消隐126,400；1,100行HSYNC脉冲（8 clocks/line）、5行VSYNC、SOF1、EOL1080、八种颜色全覆盖。
- Tang Dynasty synth/route/hold-fix/bitgen均完成。最终 [`AC201_video33_1080p15_pr.timing`](<E:/VSCODE-project/FPGA-ANLU/development/player_video33_1080p_output/build/manual/AC201_video33_1080p15_pr.timing>)显示覆盖率99.62%，SWNS +1.606ns、STNS 0、HWNS +0.022ns、HTNS 0；check_timing未报告高严重度时钟/约束问题。Hold修复后保留正裕量，但HWNS仅22ps。
- HDMI core加密实现未能由当前ModelSim解密，短blank下 `video_locked` 尚无仿真证明；TD综合网表与物理报告能证明工具接受工程并得到时序报告，最终Core锁定和sink兼容性须由C33硬件LED/显示器现场验证。`check_timing`列出1个无input-delay输入和11个无output-delay输出，缺少目标显示器的接收时序预算；FPGA内部STA不表示外部HDMI端setup/hold验证。物理日志含 `PHY-5014`：no-comp PLL `fbclk`为常数输入，detail route未找其PIB路径。

C33上板步骤、LED解释、供电和C32回退路径见[`ON_BOARD_TEST_C33.md`](<E:/VSCODE-project/FPGA-ANLU/development/player_video33_1080p_output/ON_BOARD_TEST_C33.md>)。尚未加载C33位流或操作板卡。

### B. 1080p30：增加外部 HDMI 发射器

采用并行像素输入的 HDMI Tx 芯片/模块：FPGA输出RGB/YUV、PCLK=74.25 MHz、HSYNC/VSYNC/DE和I²C配置，发射器内部完成TMDS序列化。Analog Devices ADV7513数据手册列出165 MHz像素时钟输入能力、最高1080p格式、1.8–3.3 V视频输入和RGB支持；此器件接口与74.25 MHz像素输入相符。实现需在核心板/底板之间增加足够并行信号的连接器/转接板并布线至少24位像素数据、同步/DE、像素时钟、I²C、HPD/中断及电源，现有四组BE脚和HDMI连接器保留为无连接或另作用途。还需评估采购渠道、许可证/HDMI Adopter要求和PCB SI。参考：[ADV7513 官方规格与数据手册](https://www.analog.com/en/products/adv7513.html)。

时钟也需改造：DS300第29页给出PLL参考/反馈/输出分频因子M/N/C均为1–128、VCO 300–1200 MHz。基于现有50 MHz参考，精确生成74.25 MHz需要 `M/(N×C)=297/200`，最小整数M=297，超过M上限128；不能把50MHz参考下的精确74.25MHz PLL时钟视为已具备。可增加27MHz参考时钟并走PLL：M=55、N=2、VCO=742.5MHz、C=10得到74.25MHz，PFD=13.5MHz；此组数在手册范围内，尚待TD生成/锁定验证。也可加入输出74.25MHz的可编程时钟源。

### C. 改造为 True-LVDS TMDS 输出

仅在找到 EG4S20BG256 可用 True-LVDS 输出对、其连接器能接到外部四组差分链路且实际 I/O 电平、共模、端接符合显示器输入要求时，才评估直连 serializer 路线。当前 HDMI 四对脚已被 TD 数据库证明仅接受 Emulated 标准；改引到器件其他引脚需要完整的 pinout、BANK供电和高速PCB核查，现有AC201HDMI走线无法原位复用。若27MHz参考时钟可引入，PLL可取M=55、N=2、VCO=742.5MHz，再用C=10输出74.25MHz像素时钟、C=2输出371.25MHz串行时钟；仍需True-LVDS输出脚和实际高速链路验证。

方案A自定义1080p15还未做HDMI Core仿真/TD时序收敛或显示器测试；方案B/C未做器件选型采购、布线和实物验证。现有I/O探针仅证明四个接口脚的标准映射限制与Emulated小逻辑合法化。
