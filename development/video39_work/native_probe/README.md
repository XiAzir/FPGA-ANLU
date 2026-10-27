# EG4S20BG256 原生差分对 / 1080p30 扫描探针

日期：2026-10-27。所有源、TD工程、日志和报告均限于本目录；未改播放器、冻结工程或生产源；未生成可下载bit，未操作板卡。

## 结论

四组Bank1候选差分对共同设置 `IOSTANDARD=LVDS33` 后，TD 6.2.1 SP1 的 `read_adc`、综合、`legalize_phy_inst`、时序分析和DB导出均通过。TD实现把四路P/N分别映射为K11/J11、L14/M14、K15/M15、H13/J13。Bank1 3.3V供电证据来自DS301与AC601供电资料，既有调查和关联依据见 `development/video33_work/output_limits/README.md`。

M104/N7、VCO_PHASE_0/NOCOMP 的PLL时钟成功被综合、布局和布线流程接受；工具派生时钟约为74.289MHz及371.471MHz（STA报告值），参数标称计算值为74.285714MHz及371.428571MHz。A结构存在40ps setup负裕量；根线程指出四lane输入被逻辑合并。按根授权制作的B结构使用三路独立LFSR与固定TMDS clockword后，STA的SWNS为+7ps、STNS为0、HWNS为+67ps、HTNS为0，覆盖率84.09%。这表明结构调整后TD路由报告达到非负setup/hold，但setup余量非常窄。

上述结果仅能证明TD器件库映射、PLL参数接受和该探针布局布线时序情况。真实PLL锁定、P4到HDMI的物理路径、板级电平适配、差分走线/SI、显示器兼容、完整媒体播放器及持续运行均未验证。B探针不含媒体时序发生器或真正TMDS编码；没有下载位流或板上实验。

## 候选球位与AC201 P4接口

P/N方向由DS301封装表和TD routed area 的IO表核对。AC201 P4端口编号以匹配ES8388图纸第8页渲染 `development/video33_work/output_limits/AC201_CONN_300-8.png` 复核；管脚号/网名以 `AC201-EG4S20管脚信息表.xlsx` 的“概要信息”表核对。

| 差分对 | P球位 / P4 | N球位 / P4 | GPIO网 | 当前播放器约束 | 图纸端点 |
|---|---|---|---|---|---|
| Bank1 L4 | K11 / 23 | J11 / 25 | GPIO2_20 / GPIO2_21 | 未占用 | P4排针 |
| Bank1 L6 | L14 / 33 | M14 / 34 | GPIO2_24 / GPIO2_25 | 未占用 | P4排针 |
| Bank1 L7 | K15 / 35 | M15 / 36 | GPIO2_26 / GPIO2_27 | 未占用 | P4排针 |
| Bank1 L9 | H13 / 21 | J13 / 22 | GPIO2_18 / GPIO2_19 | 未占用 | P4排针 |

**纠错记录：**旧 `output_limits/README.md` 将GPIO2_24/25误写为P4.25/26。图纸逐行显示GPIO2_24/25实际为P4.33/34，P4.24为GND，P4.26为VDD3.3。旧针号不作为接线依据。根线程已另存裁剪图并负责更新上游调查。P4图纸证明连接器网名，不证明实板上是否插有扩展模块；该状态未现场核查。候选约束仅在FPGA内部改球位，不会改变PCB网络。

## PLL与时序结果

参数：50MHz输入，M=104、N=7，VCO=742.857143MHz，C0=10，C1=2，NOCOMP / VCO_PHASE_0反馈。没有添加false path、exclusive clock group或其他掩盖跨域/输出路径的例外。`timing.sdc` 仅约束50MHz参考输入并调用 `derive_clocks`。

| 版本 | 结构 | STA覆盖 | SWNS / STNS | HWNS / HTNS | 资源 | 结果 |
|---|---|---:|---:|---:|---|---|
| A | 四lane共享旋转字/反相/XOR | 84.86% | -0.040 / -0.080 ns | +0.083 / 0 ns | 32 LUT, 62 reg, 1 PLL, 1 GCLK, 4 OREG | 2个setup端点违反 |
| B | 3条独立10-bit LFSR + 固定TMDS时钟码字 | 84.09% | +0.007 / 0 ns | +0.067 / 0 ns | 43 LUT, 113 reg, 1 PLL, 1 GCLK, 4 OREG | STA状态无违例，setup余量7ps |

B版布局布线仍产生 `PHY-5014`：`detail route doesn't find pib for u_pll/pll_inst.fbclk[0]`。该反馈端口在探针接法中按C38相同方式接常量，并非本文已验证的芯片反馈物理锁定路径。reset没有pin约束，工具自动分配H16、LVCMOS33、PULLUP。STA覆盖率未达到100%。

## 证据文件

- 阶段1：`build/td_run_lvds33_attrs_removed.log`、`build/native_io_probe.area/.ts/.timing/.db`；最终四对N/P分配另见`build/native_clock_serializer_probe_phy.area`与B版同名`_phy.area`。
- A版：`build/native_clock_serializer_probe.v`（源码）、`build/td_run_clock_probe_retry01.log`、`build/native_clock_serializer_probe_pr.timing`、`build/native_clock_serializer_probe_phy.ts`、`build/native_clock_serializer_probe_phy.area`、`build/native_clock_serializer_probe_pr.db`。
- B版：`B/src/user_source/native_clock_serializer_probe_b.v`、`B/scripts/run_clock_probe_b.tcl`、`B/build/td_run_clock_probe_b_retry03.log`、`B/build/native_clock_serializer_probe_b_pr.timing`、`B/build/native_clock_serializer_probe_b_phy.ts`、`B/build/native_clock_serializer_probe_b_phy.area`、`B/build/native_clock_serializer_probe_b_pr.db`。
- 失败尝试保留在各自build目录；设置阶段汇总见`build/setup_errors.log`。TD约束和源、日志、关键报告及DB的SHA-256清单见`probe_summary.json`。

## 事实、推断、未验证

- **事实：**原生LVDS33四组共同读入、综合并合法化；B版实际完成TD route，STA报告非负setup/hold裕量，四对输出有器件级P/N球位映射。
- **推断：**候选Bank1差分输出的硅片映射可供后续独立硬件/电气评估。该推断只适用于TD选择的器件、封装和约束。
- **未验证：**真实器件是否锁定该PLL参数；VCO/PFD在实芯片条件下的稳定性；P4外部负载/模块状态；AC201差分路径的板级电气、阻抗、回流和到HDMI的任何连接；LVDS33输出与HDMI接收端适配；显示器告警是否消失；完整HDMI功能；长时间稳定性。

