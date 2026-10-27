# C40 外部 MISO setup / hold 独立复核

日期：2026-10-27（Asia/Shanghai）  
范围：只读复核已路由压力报告的前三条路径、压力 SDC 与工程 SPI RTL。

## 结论

在报告采用的 20 ns `sd_card_clk` 周期与人工压力输入延迟下，给出的预算计算成立：

`21.422 ns - 6.280 ns - (1.831 ns + 1.263 ns + 0.314 ns) = 11.734 ns`

这表示以 FPGA 输出 SCK pad 的下降沿为起点，至 FPGA MISO 采样寄存器 D 端要求时刻为止，扣除报告所列 MISO pad、内部路由和 LUT3(reg) 数据路径延迟后，供卡片 tOD 与板级往返延迟共同使用的估算余量。它不是卡片规格保证值，也不含任何已测量的 PCB / 卡片数值。报告以 20 ns `set_input_delay -max` 人为压紧预算，不能据此宣称生产板卡有 11.734 ns 的实际时序裕量。

## 路径、时钟与边沿核对

- `rawio_stress_summary_v6.rpt` 第 85–134 行：SCK OREG 到 `sd_dclk` pad。launch 为 `sd_card_clk` 上升沿；OREG 的 pad delay 为 4.620 ns，路径时刻从时钟根的到达 1.660 ns 累计到 pad 下降沿 6.280 ns。该 6.280 ns 是报告中 FPGA 输出 pad 边沿的时刻，非 card pin 测量值。
- 第 187–240 行：MISO setup。`sd_miso` 在 K6 输入，capture 到 `MISO_shift_reg[0]...d[0]`，capture edge 为 `sd_card_clk` 上升沿 +20 ns。约束 uncertainty 为 0.100 ns，setup 为 0.116 ns，clock pessimism 为 0.043 ns；报告给出的 required time 为 21.422 ns。
- 数据路径各项为 PAD 1.831 ns、net 1.263 ns、LUT3(reg) 0.314 ns，合计 3.408 ns。路径 `Data Path Delay` 总数 23.408 ns 还包含 20 ns 人工输入延迟及报告计时参考相位；以上 3.408 ns 是从 FPGA 输入 PAD 开始到 D 端的实现数据路径。LUT3(reg) 的 0.314 ns 已作为路径增量计入，setup 另列为 -0.116 ns。它不是从 3.408 ns 中再扣一次的额外项。
- `spi_master.v` 在 `always @(posedge sys_clk ...)` 中对 MISO 移位采样。RTL 的 CPOL/CPHA 可配置；报告只证明该具体映射下寄存器由 `sd_card_clk` 上升沿捕获。SCK OREG 路径的下降沿与 MISO 上升沿采样对应半周期关系。若实际运行的 CPOL/CPHA、卡片输出时序或时钟分频配置不同，11.734 ns 解释须重新核对对应边沿。
- `raw_io_stress.sdc` 明确注明仅作分析，用 `set_input_delay -max 20.0` 暴露外部路径；`-min 0.0` 用于最小延迟分析。SDC 未在此文件定义时钟周期，周期和波形由报告中的时钟定义显示为 20 ns，rise@0 / fall@10 ns。

## Hold 可得结论

报告第 1047–1105 行给出 MISO 最差 hold 路径：fast corner、0 ns artificial min input delay、数据路径 2.300 ns（PAD 1.184 + net 0.900 + LUT3(reg) 0.216），hold slack +0.009 ns。报告汇总行显示 HWNS 0.009 ns、HTNS 0、0 个违反端点。因此该实现对该压力 SDC 的 hold 检查通过，但 MISO 最差端点只有 9 ps 报告余量，极窄。报告不能证明真实卡片 tOH、实际 PCB 最小延迟或生产约束下的外部 hold 余量；需外部最小输出延迟 / tOH 约束及板级参数才能验证这些条件。

## 适用范围与已知风险

1. 这是指定 C40 已路由报告中的静态时序证据；不代表板上测量，未验证卡片 tOD 与 PCB 往返延迟。
2. 报告中的压力 SDC 不是生产约束。生产工程的 WNS +1.531 ns / +0.011 ns 和 99.99% 仅是片内证据，不能覆盖未约束外部 MISO 行为。
3. 14 ns / 18 ns RTL 版本的通过结果没有真实路由；只能说明对应 RTL 在其检查流程中的结果，不能替代该 C40 路由实现的 pad/net 延迟证据。
4. C40 路由报告中的压力时钟模型为 20 ns（50 MHz `sd_card_clk`）；SPI SCK 的 25 MHz 是半速输出关系。板上实际 SCK、引脚负载、走线与卡片工作模式未在本次只读材料内实测。

## 证据定位

- `development/video40_work/timing_review/c40_spi_raw_path_output/rawio_stress_summary_v6.rpt`：SCK 路径约 85–134 行，MOSI 路径 136–185 行，MISO setup 187–240 行；MISO hold 1047–1105 行。
- `development/video40_work/timing_review/raw_io_stress.sdc`：人工输入/输出 max=20.0 ns、min=0.0 ns 约束及仅分析用途注释。
- `development/player_video40_spi25/src/user_source/hdl_source/SD/spi_master.v`：MISO 在 `posedge sys_clk` 更新 `MISO_shift`，由 CPOL/CPHA 决定移位边沿条件。

本次只做文件静态核对；未启动 TD、仿真或硬件测试，也未更改生产 RTL、约束或工程配置。
