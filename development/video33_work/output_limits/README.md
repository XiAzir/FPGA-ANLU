# EG4S20 现有 HDMI 输出能力与最小变更方案

调查日期：2026-10-27。原报告范围为只读本地资料与既有 `io_probe` 记录；后续新增证据见下方更正及 `development/video39_work/native_probe`。生产工程和已交付位流保持。

## 2026-10-27 重新读图更正

根代理与新gpt-6-luna代理分别目视核对ES8388原理图第8页，发现原表P4针号有误，现已修正。正确GPIO2_18/19对应P4.21/22，20/21对应P4.23/25，24/25对应P4.33/34，26/27对应P4.35/36；其中P4.24为GND、P4.26为VDD3.3。旧的19/20、21/22、25/26、27/28映射作废；先前报告仅列候选，未交付接线指令。重读图位于 `development/video39_work/electrical_review/P4_verified_crop.png`。DS301 **BG256**表在PDF第20页（BG324表具有不同球位），P/N仍为K11/J11、L14/M14、K15/M15、H13/J13，已与TD IO表复核。

C37用户反馈正常，C38用户反馈1080p15画面正常且持续漂浮“输入不支持”，与PC同组15Hz现象一致。用户已选择优先消除提示，转为评估1080p30扫描、每15fps内容帧显示两次。新的四组P4原生LVDS33同时映射/合法化已通过；74.285714/371.428571MHz独立serializer探针首轮routed setup -0.040ns、hold +0.083ns，正在针对共享lane寄存器这一具体结构做受控对照。原报告中的“TD/现场待验”条目属于形成时状态；最新结论以C39评估记录为准。

## 结论摘要

- **1080p60 扫描、15fps 内容重复四次**需要 148.5MHz 像素时钟、742.5MHz 串行时钟和每 lane 1.485Gbps。EG4 PLL 输出上限 400MHz、True LVDS 输出上限 400MHz/800Mbps；因此742.5MHz超过PLL输出上限，同时超出True LVDS时钟/线速规格。742.5MHz VCO 本身落在 VCO 300–1200MHz 范围内；VCO数值落入范围只证明VCO条件满足，PLL输出和I/O仍分别受自身上限约束。
- **1080p30 扫描、15fps 内容重复两次**需要 74.25/371.25MHz 时钟、742.5Mbps/lane。PLL输出 371.25MHz 与 True LVDS 400MHz/800Mbps 数值上有余量；现用 B10/D11/C11/F10 均只接受 Emulated I/O 标准（上限166MHz），现有线路因此不达此速率。50MHz参考下精确的74.25/371.25MHz没有整数分频解，但有近似整数候选 M=104、N=7、C0=10、C1=2，可生成74.285714/371.428571MHz（相对标准时钟+0.0481%）；50MHz/N所得7.142857MHz PFD 的可用范围未在公开规格中单列，故该候选需后续时钟发生器验证。无需仅因无精确整数解就预设更换参考时钟。
- 现有 AC201 HDMI 路径把 FPGA 四对信号经 ESD 器件和串联电容接到 HDMI 母座；原理图页6未见 Emulated LVDS 要求的3R衰减网络。图纸/软件约束中的 `LVDS33_E` 在165MHz下有 C35 稳定彩条实测，说明既有接收组合能工作；这项现场结果不改变器件公布的166MHz上限或缺失3R网络的事实。
- **硅片存在True-LVDS候选引脚，当前HDMI引脚仍绑定Emulated LVDS；也发现可复用的Bank1 GPIO引出对。** DS300支持左/右侧True-LVDS输出并列出LVDS33最高400MHz；Bank1的L4/L6/L7/L9落在左侧IO，AC601/AC201图纸将这四对引到P4通用显示扩展排针，图纸中未见对应LCD/触摸控制器等板载有源负载。它们在当前播放器 `pin.adc` 中未分配。该发现给出“可复用候选”，不证明TD支持这些具体ball上的True-LVDS33，也不证明P4适合371.25MHz差分布线或已经接到HDMI母座。
- 现用HDMI四对仍为Bank0/BE位置，TD独立探针仅接受Emulated标准。Bank3 R1–R4替代引脚有SRAM/CMOS/UART实际负载，不能据此作为复用方案。Bank1 L4/L6/L7/L9与Bank3占用必须分别判断，不能从“引脚表有GPIO功能”直接推出电气链路完整。
- AC601核心板原理图将VCCIO1和VCCIO3分别经FB2/FB4接至VCC3P3；DS301也说明Bank1/3 VCCIO与合封SDRAM电源内部相连、只能用3.3V。此供电与DS300的LVDS33规格匹配，但不单独证明这些Bank引脚在TD中支持True-LVDS33或满足HDMI/TMDS接收电气要求。
- AC201匹配ES8388底板HDMI网络经ESD器件和串联电容连J4；原理图中未见Emulated LVDS的3R衰减网络，现有板上无3R可供“绕开”。AC601核心板图第1页U5（ACA420-CORE）将DVI_CLK_N/P引到接口针79/80；引脚表将四对完整映射为CLK=79/80、D0=81/82、D1=83/84、D2=85/86。候选Bank3管脚则在同一核心板表中接SRAM、CMOS、UART或SD等既有功能。AC201-ES8388仅有PDF原理图，没有匹配的PcbDoc/Altium layout；现有完整AC201_EG4S20 PCB archive对应WM8960版。故当前只能确认原理图连接与网名，缺少精确走线、阻抗/长度、焊盘可达性及可切断/跨接点；暂不给出直接接线方案。
- Q&A明确赛题一 HDMI 输出驱动逻辑由 FPGA 侧实现，外接 HDMI 驱动板路线排除。1080p30的最小评估方向保留在器件级：M=104、N=7、VCO=742.857143MHz、C0=10输出74.285714MHz、C1=2输出371.428571MHz；该候选在公开的M/N/C、VCO、输出频率范围内，PFD可用范围及工具发生器对参数的接受状态尚未确认。时钟候选只涉及频率产生；板级连接仍需PCB与电气证据，现阶段暂不给出把这四路接至HDMI母座的方案。若现板缺少可用True-LVDS/TMDS物理对，平台需具备FPGA内建符合目标速率的输出串行器。
- 当前 JRY 外屏 EDID 首选1080p60，声明范围V58–62Hz、H30–83kHz，未列1080p30/15；用户本轮补充NVIDIA手动设置1920×1080/30Hz逐行、H=2200/V=1125、74.25MHz后，实际桌面连续20秒稳定、无闪烁/无信号。显示器1080p30接收已由现场测试确认，EDID未列该模式的差异保留；这项屏幕端测试不覆盖FPGA发送链。C33的15Hz/16.5kHz仍未做显示器测试。1080p60扫描仍需能输出1.485Gbps/lane的平台及支持1080p60的显示器。

## 规格核算

| 输出模式 | Pixel / serial clock | 每lane数据速率 | PLL输出规格 | 现有 LVDS33_E | True LVDS | 判断 |
| --- | ---: | ---: | --- | --- | --- | --- |
| 1080p15当前栅格 | 33 / 165MHz | 330Mbps | 两个输出低于400MHz | 165MHz低于166MHz，余量仅1MHz | 规格上可承载该时钟 | 频率可落在现路径公布上限内；C33/C36在JRY无信号，C35同钟彩条成功但为640×480/60Hz栅格。 |
| 1080p30 | 74.25 / 371.25MHz | 742.5Mbps | 两个输出低于400MHz | 371.25 > 166MHz | 371.25 < 400MHz且742.5 < 800Mbps | 器件差分速率可行性仅对True LVDS数值成立；引脚、走线、电平、精确时钟源仍需变更/验证。 |
| 1080p60 | 148.5 / 742.5MHz | 1.485Gbps | 742.5 > 400MHz | 742.5 > 166MHz | 742.5 > 400MHz且1.485Gbps > 800Mbps | EG4S20此条输出链超规格；应更换具备更高速内建串行器/输出的FPGA平台。 |

EG4 PLL分频系数 M/N/C 均为1–128，DS300公开输入频率10–400MHz、VCO300–1200MHz、输出4–400MHz。取 `C0=10`、`C1=2` 产生5:1输出时，两个目标输出都满足PLL输出≤400MHz要求的VCO比率为 `6 ≤ M/N ≤ 16`（下限来自VCO≥300MHz，上限来自串行时钟VCO/2≤400MHz）。满足目标附近的整数候选如下：

| M | N | VCO MHz | C0=10 像素 MHz | C1=2 串行 MHz | 相对74.25/371.25 | PFD=FIN/N MHz |
|---:|---:|---:|---:|---:|---:|---:|
| 104 | 7 | 742.857143 | 74.285714 | 371.428571 | +0.0481% | 7.142857 |
| 89 | 6 | 741.666667 | 74.166667 | 370.833333 | −0.1121% | 8.333333 |
| 119 | 8 | 743.750000 | 74.375000 | 371.875000 | +0.1684% | 6.250000 |
| 74 | 5 | 740.000000 | 74.000000 | 370.000000 | −0.3367% | 10.000000 |

M104/N7是所列近似候选中误差最小的配置；输入FIN=50MHz符合DS300的10–400MHz输入时钟范围，分频器/输出/VCO也均在公开数值范围内。公开DS300表格没有另列PFD=FIN/N的上下限；EG4宏模型仅注释REFCLK_DIV/FBCLK_DIV/CLKC0/1_DIV为1–128。因此50/7=7.142857MHz公开资料不足以判断该PFD是否满足内部限制，也没有发生器/芯片接受状态证据。后续若发生器另设PFD下限，M74/N5是表中FIN/N=10MHz、像素时钟偏差−0.3367%的备选，需结合目标显示器容限评估。50MHz下精确74.25MHz或371.25MHz仍无整数解，但非必须增加27MHz参考；27MHz参考、M55/N2、VCO742.5MHz、C0=10/C1=2可作为精确输出的备用时钟方案。1080p60仍需742.5MHz串行时钟输出，超过PLL与True-LVDS规格，与时钟整数精度无关。

DS300没有给出独立的 `EG_LOGIC_ODDR` 最高时钟频率或可独立于 I/O 标准上限的规格；ODDR章节说明输出DDR工作方式，不构成高速额度。公开的上限应按 PLL 输出频率和所选 I/O 标准/线速指标判断。DS300列有16路gclk资源数，但没有找到可用于本判断的gclk最高频率条款；所以不将C35的165MHz gclk实测/实现外推到371.25或742.5MHz。

## 现有四对引脚、图纸路径与探针证据

- `pin.adc`：`HDMI_CLK_P=B10`、`HDMI_D0_P=D11`、`HDMI_D1_P=C11`、`HDMI_D2_P=F10`，均为 `LVDS33_E`。DS301 BG256引脚表对应 P/N：B10/C9、D11/D12、C11/A11、F10/H11，全部Bank0、BE引脚组。
- `development/video33_work/hdmi_gate/io_probe/{lvds33,data0_lvds33,data1_lvds33,data2_lvds33}` 分别对四个P脚逐一尝试 `IOSTANDARD=LVDS33`，各自 `read_adc` 返回 `USR-8059`；每条 valid values 都只列LVCMOS/LVTTL/PCI/SSTL和`LVDS25_E/LVDS33_E/LVPECL33_E`，没有原生 `LVDS25` 或 `LVDS33`。因此此四对当前位置在所用TD器件库中可用标准限于 Emulated 类型；此证据不涵盖其它封装位置。
- `io_probe/lvds33e` 对四组当前脚同时应用 `LVDS33_E`，成功完成 map、legalize、timing summary 和DB导出（日志末尾 `IO_PROBE_COMPLETE_lvds33e`）。探针只用50MHz计数翻转与四个输出，不含PLL、ODDR或高速serdes；它证明I/O标准组合可映射，不证明高频/HDMI功能。
- AC201匹配 ES8388 底板原理图第1页把 DVI_TX2/1/0/CLK 差分网由核心板接口引入；第6页将各N/P网经AZ1045-04F ESD器件及C55–C62串联电容接至J4 HDMI母座对应D2/D1/D0/CK脚。未见Emulated LVDS所需3R电阻网络。第6页的DDC/HPD仅接接口/上拉网络，没有连到FPGA；EDID采集由外部主机完成。
- AC601核板图第1页的U5（ACA420-CORE）接口上，DVI_CLK_N/P为79/80；AC201引脚信息表的DVI_CLK、D0、D1、D2四对分别占用79–86。HDMI数据通路因此固定经过这8个核心板/底板连接位置，图纸没有把Bank3候选信号并到这些位置。改变 `pin.adc` 只改变硅片绑定，不会改板上网络。缺少ES8388版PCB layout，现有原理图不足以核实是否存在对应可达焊盘、可控切断/跨接点或高速回流路径；不要按封装球位坐标直接接线。

## PCB与连接器占用核对

AC201/ES8388匹配版原理图能确认网络功能和连接器号，但资料清单记录的完整 `AC201_EG4S20.rar` 是WM8960版PCB工程；ES8388版没有对应PcbDoc。AC601核心板完整PDF含FPGA、板间连接和供电图。

| 差分候选 | EG4S20BG256封装球位 P/N | AC601/AC201现占用 | 证据定位 |
| --- | --- | --- | --- |
| Bank3 R1 | B3 / D3 | SRAM_A0 / SRAM_DQ2 | `AC201-EG4S20管脚信息表.xlsx` 第9行C9=B3/B9=SRAM_A0；第30行C30=D3/B30=SRAM_DQ2。 |
| Bank3 R2 | E3 / E4 | CMOS_D1 / UART_RXD | 第124行C124=E3/B124=CMOS_D1/D124=120；第95行C95=E4/B95=UART_RXD/D95=122。 |
| Bank3 R3 | F5 / F4 | SRAM_A15 / SRAM_A16 | 第24–25行：C24=F5、B24=SRAM_A15；C25=F4、B25=SRAM_A16。 |
| Bank3 R4 | B2 / A2 | SRAM_A2 / SRAM_A1 | 第11行C11=B2/B11=SRAM_A2；第10行C10=A2/B10=SRAM_A1。 |

为核对有无其它未占用的右侧差分对，按DS301 Bank3球位表将Bank3 R1–R24与同一引脚表交叉映射如下：

| Bank3对 | N球位/映射 | P球位/映射 |
| --- | --- | --- |
| R1 | D3 / SRAM_DQ2 | B3 / SRAM_A0 |
| R2 | E4 / UART_RXD | E3 / CMOS_D1 |
| R3 | F4 / SRAM_A16 | F5 / SRAM_A15 |
| R4 | A2 / SRAM_A1 | B2 / SRAM_A2 |
| R5 | C2 / SRAM_DQ0 | C3 / SRAM_A3 |
| R6 | E2 / SRAM_DQ12 | C1 / SRAM_DQ1 |
| R7 | D1 / SRAM_DQ3 | E1 / SRAM_DQ13 |
| R8 | F2 / SRAM_DQ14 | F1 / SRAM_DQ15 |
| R9 | G6 / SRAM_LB_N | G5 / SRAM_OE_N |
| R10 | G3 / SRAM_DQ8 | G1 / SRAM_DQ9 |
| R11 | H5 / SRAM_UB_N | H1 / SRAM_DQ11 |
| R12 | J1 / SRAM_DQ5 | K1 / SRAM_DQ6 |
| R13 | L1 / SRAM_A5 | H2 / SRAM_DQ10 |
| R14 | H3 / SRAM_DQ4 | H4 / SRAM_CE_N |
| R15 | J4 / SRAM_A18 | J3 / SRAM_A14 |
| R16 | K2 / SRAM_DQ7 | K3 / SRAM_A12 |
| R17 | J6 / SRAM_WE_N | K5 / SRAM_A13 |
| R18 | R1 / SRAM_A9 | P1 / SRAM_A8 |
| R19 | P2 / UART_TXD | R2 / SD_CS |
| R20 | L3 / SD_MOSI | M2 / SD_CLK |
| R21 | M3 / GPIO0_35 | K6 / SD_MISO |
| R22 | N3 / GPIO0_33 | M4 / GPIO0_34 |
| R23 | N4 / GPIO0_31 | P4 / GPIO0_30 |
| R24 | M1 / SRAM_A6 | N1 / SRAM_A7 |

结果：Bank3的R1–R24共24对两侧都登记了现有功能，候选R1–R4接外部SRAM或CMOS/UART；这些点位负载明确。Bank1的L1–L18也映射至SW/DONE、GPIO、IIC、BEEP、RGMII；其中L4、L6、L7、L9的GPIO2信号从AC201 P4通用扩展排针引出，当前原理图显示排针为唯一端点，无板载LCD/触摸器件负载。对这四对，应按GPIO扩展候选审查；其余Bank1已映射器件/用户功能，未据此归为可复用候选。

Bank3 R1、R3、R4接AC601本地外部SRAM，R2接CMOS/UART底板功能，R13的两侧分别接SRAM_A5和SRAM_DQ10；替换这些引脚会与既有板载网络重叠。Bank1候选与当前HDMI专用网络是分开的GPIO扩展通道，详见下表。

### Bank1 GPIO候选：球位、接口与板端负载

| Bank1对 | DS301球位 P/N | GPIO2信号与AC601底板接口pin | AC201 ES8388端点 | 图纸实际负载 | 当前C34播放器 `pin.adc` |
| --- | --- | --- | --- | --- | --- |
| L4 | K11 / J11 | GPIO2_20 / GPIO2_21；接口pin 47 / 46 | P4 Header 18×2，pin 23 / 25；LCD_D15 / LCD_BL功能标签 | P4排针为图示端点；无板载LCD/背光器件 | 未使用 |
| L6 | L14 / M14 | GPIO2_24 / GPIO2_25；接口pin 41 / 40 | P4，pin 33 / 34；T_PEN / T_SCK | P4排针为图示端点；无板载触摸屏/控制器 | 未使用 |
| L7 | K15 / M15 | GPIO2_26 / GPIO2_27；接口pin 39 / 38 | P4，pin 35 / 36；T_CS / GPIO2_27 | P4排针为图示端点；无板载触摸屏/控制器 | 未使用 |
| L9 | H13 / J13 | GPIO2_18 / GPIO2_19；接口pin 49 / 48 | P4，pin 21 / 22；LCD_D13 / LCD_D14 | P4排针为图示端点；无板载LCD面板 | 未使用 |

AC201第8页把P4标为“通用显示扩展接口”，元件为Header 18×2；LCD/触摸名称是该扩展口的功能标签，图中没有面板或触摸IC。板级资料显示P4为这些GPIO2网的端点；实际是否插有扩展模块需现场确认。若P4未接扩展模块，这四对属于可复用候选；原理图未显示相关板载有源负载。它们未连接至J4 HDMI通道；P4走线、阻抗、差分回流、ESD/AC耦合及HDMI端电平仍需匹配PCB资料核验。因此当前结论是“可复用候选，电气/PCB待核验”，本报告不含接线指令。

AC601原理图第4页把VCCIO1与VCCIO3分别经FB2/FB4连VCC3P3；官方DS301印刷页24又说明Bank1/3 VCCIO与合封SDRAM电源内部相连、只能接3.3V。输出Bank供电与LVDS33电平类别相配，但具体替代引脚的True-LVDS标准仍需TD数据库确认。

AC201 HDMI图第6页显示当前CLK/D0/D1/D2的N/P网络经ESD阵列与串联电容接至J4，图纸没有3R电阻网络；R46–R48三只10kΩ元件在DDC_CLK、DDC_DATA、HP_DET支路，不在TMDS四对数据线上，故没有板载3R可绕开。AC601接口的79–86仅对应当前四对，替代Bank3对落在其它已用网络上。由于缺少ES8388版PcbDoc，原理图证据尚不足以定位切线点、焊盘/过孔可达性、替代对到J4的长度/阻抗/差分回流，现阶段不提供焊接或飞线方案。

## 精确证据定位

1. 官方 `DS300_Eagle_EG4系列数据手册_v3.9.6_官方.pdf`：PLL参数和VCO/输出频率，印刷页28–29、2.4.1表2-4-1（PDF页34–35）；DDR输出模式，印刷页42–43（PDF页48–49）；高速LVDS描述/True与Emulated差别、400/166MHz与3R，印刷页46–47、2.7.2表2-7-1/2-7-2（PDF页52–53）；最大I/O速率，印刷页81、表3-2-5（PDF页87）。
2. 官方 `DS301_EG4S20数据手册_v2.7.8_官方.pdf`：封装Bank3 pin表印刷页18（PDF页22），Bank1 pin表印刷页20（PDF页24）；Bank供电注释印刷页24（PDF页28），说明Bank1/3 VCCIO与SDRAM电源相连、VCCIO1/3只能接3.3V。
3. 探针源与日志：`development/video33_work/hdmi_gate/io_probe/lvds33e/src/user_source/pin.adc:2-5` 列出四个当前脚及标准；`development/video34_work/io_probe_native_console.log:69-71` 和 `development/video33_work/hdmi_gate/io_probe/data0_lvds33/build/run_console.log:70-72`、`data1_lvds33/build/run_console.log:71-73`、`data2_lvds33/build/run_console.log:72-74` 分别记录四个P脚被数据库拒绝及完整valid-values列表。Emulated组合成功见 `development/video33_work/hdmi_gate/io_probe/lvds33e/build/run_console.log:69-72,288-315,329-347`，其中347行标记 `IO_PROBE_COMPLETE_lvds33e`；面积/映射报告 `build/hdmi_io_probe_lvds33e.area:4-31`、`.timing`、`.ts`。C35 PLL整数参数计算见 `development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/src/user_source/hdl_source/IP/video_pll.v:3-5,23-44`。探针限制和模式建议见 `development/video33_work/hdmi_gate/HDMI_output_gate.md:5-25,31-43,53-59`。
4. 板级证据：`E:\QQ CACHE\Download\安路资料\小梅哥\AC201-EG4S20管脚信息表.xlsx` 的实际工作表名为“概要信息”；D75:D82把现用HDMI四对映射到板间接口79–86，GPIO2候选球位与接口号见行185–188、191–194。AC601图第1页为U5 ACA420-CORE连接器，第2页为FPGA Bank/球位，第4页为FB2/FB4供电；AC201匹配ES8388图第8页显示GPIO2_18–27接无源P4 Header 18×2，图纸没有板载LCD/触摸IC。**2026-10-27重新读图更正后的端点**：GPIO2_18/19→P4.21/22，GPIO2_20/21→P4.23/25，GPIO2_24/25→P4.33/34，GPIO2_26/27→P4.35/36。P4功能标签包括LCD_D13/D14/D15/BL与T_PEN/SCK/CS，实际是否接有外部模块仍待确认。相关图页：[AC601接口页](AC601_schematic_hi-1.png)、[FPGA球位页](AC601_FPGA_HI-2.png)、[Bank供电页](AC601_power_hi-4.png)、[AC201 P4页](AC201_CONN_HI-8.png)。当前播放器约束 `development/player_video34_1080p15/src/user_source/constraints_source/pin.adc:2-21` 未分配这些GPIO2信号。P4线路不通往HDMI J4；缺少ES8388版PCB布线资料，故P4差分SI及到J4的路径未确认。资料清单 `E:\QQ CACHE\Download\安路资料\_资料内容清单.md:59-64,438`记录ES8388版只有原理图，完整AC201 PCB archive对应WM8960版。
5. EDID及实板对照：`development/video33_work/edid_review/capture_20261027_123105_181/analysis.json:88-140,241,393-402`记录JRY、V58-62Hz/H30-83kHz、首选1080p60、1080p30/15未列及串行时钟预算；`primary_mode_reference.json`、`development/video33_work/edid_handoff_validation/EDID_result_20261027_120600_109/capture.json`为前序证据。C33/C36无信号、C35彩条成功与LED解释见资料目录 `开发记录/专题记录/视频播放实现_C11319_20261021/C11333_C11336_显示输出对照_20261027.md`。

## 最小下一步

1. 1080p30显示器接收已由用户实际桌面测试确认；下一步硬件侧只读核查聚焦Bank1 P4 GPIO候选的真实PCB网络、接口负载、差分SI和TD针脚标准。时钟发生器验证M104/N7及PFD限制另行安排；50MHz近似候选与改变PLL参考源分开评估。
2. 板级改线方案暂不成立。最小补证是取得AC201/ES8388匹配版本的原始PCB工程或高清生产板层/钻孔/阻抗资料，确认AC601模块连接器两侧每一候选网络、实际空闲/占用、相对HDMI四线的走线/阻抗/回流、ESD/AC耦合后的可接入点，并审查差分输出的真实电平与JRY HDMI输入电气门限。ES8388版本匹配的PCB布线证据尚未取得；现有AC201_EG4S20 WM8960版记录单独保留为异版参考。
3. 若需继续1080p30而板级无四组可用的合规差分路径，改用带满足≥371.25MHz发送时钟、≥742.5Mbps/lane FPGA内建差分发送能力的平台，并使用明确支持1080p30的显示器。1080p60内容扫描仍要求更高速、内建输出串行器的平台和支持1080p60的显示器。
4. 若保持现有四组板线与EG4S20：可继续用33/165MHz模式作已知范围内的实验，但1080p15自定义栅格需要支持15Hz/16.5kHz的显示端；现有JRY外屏规格声明不满足该时序。C35的稳定彩条是同钟/同输出链的现场证据，不表示该板级线路满足高速或3R电气规范。

说明：用户提及的原厂整板73.333/366.667MHz曾正常作为单独现场事实保留；此结果不替代上述DS300/DS301器件规格。2026-10-05的电脑USB供电不足诊断不属于本次HDMI输出速率判断。







