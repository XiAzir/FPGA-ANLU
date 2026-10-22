# JPEG Core 独立综合

目标为 `jpeg_core`，直接以模块默认参数 `SUPPORT_WRITABLE_DHT=0` 综合。只从 vendor checkout 复制 RTL 到本实验目录，未修改 vendor 或主线工程。器件 `EG4S20BG256`，`clk_i` 20ns（50MHz），TD 6.2.1 SP1；采用 AreaHigh、`min_ripple_len=18`、`mapper_lut_delay=1600`、`add_map_lut_struct=high`、`map_mode=area_prior`、`multi_thread_mapping=partition`、`resource_sharing=auto`、`shifter_style=shifter_reg`。

## 结果

| 资源 | 独立综合结果 | 器件容量 |
| --- | ---: | ---: |
| LUT（TD utilization） | 5,595 | 19,600 |
| FF | 2,725（QoR 报 2,327 registers） | 19,600 |
| BRAM9K | 19 | 64 |
| DSP | 29 | 29 |

QoR 另报 3,099 generic LUT cells 与 852 standalone slices。整机预算使用 Slice，需以完整工程实现验证；本独立 LUT 数不换算为 Slice。hierarchy area 中 `jpeg_idct` 为 2,279 LUT、12 BRAM9K、20 DSP；其中 `jpeg_idct_x` 为 525 LUT / 9 DSP，`jpeg_idct_y` 为 733 LUT / 11 DSP，输入/转置存储占 12 BRAM9K。`jpeg_output` 为 765 LUT、6 BRAM9K、8 DSP，`jpeg_dqt` 为 49 LUT、1 BRAM9K、1 DSP；`jpeg_dht` 为 603 LUT。IDCT 是 DSP 与 RAM 的主要占用点。完整核独立已超当前 20 DSP 余量 9 个，且独占现有 19 BRAM9K 余量。

QoR 综合估计的 Setup WNS 为 -966ps、TNS 为 -8872ps、16 个 setup 违例端点；I/O 中另有 5 个 timing unconstrained。它仅是综合后计时估计，不代表布局布线或板上时序。

警告摘要：DHT 源码有 3 条标识符先用后声明；色度 RAM 有两个 byte-enable 低位未驱动，工具按 0 处理；10 条 ERAM init 会被忽略，因为 `eram_init=off`；另有匿名实例/网名提示。逐条信息保存在 `td_console.log`。

## 独立候选方向

若产品输入可限定为灰度 JPEG，可在后续候选 wrapper 中新增编译期 `MONOCHROME_ONLY` 专用配置，裁掉 Cb/Cr 两组输出缓存（报告中对应 4 BRAM9K）与 YCbCr 转换路径（输出模块报告为 8 DSP）；按静态删除估算，核心可降至约 15 BRAM9K、21 DSP。还需至少再省 1 DSP 才满足当前余量。一个小范围候选是将 DQT 常量/动态乘法映射改为经正确性验证的共享或移位加法实现；另一个方向是 X/Y IDCT 乘法器时分复用，当前两段合计 20 DSP，若共享一个 5-multiplier datapath，预计可释放约 9 DSP，但会影响吞吐和控制调度。候选需先明确 JPEG profile、帧率/尺寸，再单独验证像素正确性、吞吐、BRAM 与 TD 综合；上述节省值是按层级报告推导，尚未通过综合验证。

## 算术与 RAM 消融

所有 variant 使用同一 vendor commit、EG4S20BG256、50MHz、AreaHigh 与同一 mapper 配置。A01-A03 使用默认 `max_dsp`；A04/A05 设置并在参数报告中确认 `max_dsp=17`。

| 版本 | 变化 | LUT | FF | BRAM9K | DSP | QoR setup WNS | 违例端点 |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Baseline | vendor 默认 | 5,595 | 2,725 | 19 | 29 | -966ps | 16 |
| A01 | IDCT C4 常乘改 32 位移位加法 | 5,616 | 2,755 | 19 | 29 | -966ps | 16 |
| A02 | 四个 YCbCr 常乘改 32 位移位加法 | 5,984 | 2,686 | 19 | 24 | -334ps | 8 |
| A03 | A01 + A02 | 6,081 | 2,755 | 19 | 21 | +86ps | 0 |
| A04 | A03 + `dsp_style="no"`，并将两轴 181/256 乘积改为精确 32 位移位加法后保留 `/256` | 6,354 | 2,881 | 19 | 13 | +86ps | 0 |
| A05 | A04 + 四个 32×32 transpose RAM 使用 `ram_style="dram"` | 6,840 | 2,977 | 11 | 13 | -454ps | 8 |
| A06 | A04 + 仅 transpose `u_ram0` 使用 DRAM，其余 3 banks 保留 BRAM | 6,485 | 2,905 | 17 | 13 | -454ps | 8 |

乘积消融的 Icarus 对照覆盖 100,009 组有符号 32 位输入，含负数、溢出和边界值；181/256 对照保留有符号除法向零截断。见 `arithmetic_equiv_result.json` 和 `arithmetic_equiv.log`。A04/A05 的 max_dsp setter 在 TD TCL 返回成功，并在 `reports/actualparams.gate.after.log` 显示当前值 17；实际 DSP 使用为 13。

A05 的四个 transpose RAM 各由 2 个 BRAM9K 改为 DRAM，完整 core 从 19 降到 11 BRAM9K，额外消耗约 486 LUT 与 96 FF（相对 A04）。按父工程资源盘点的 45 固定 BRAM + JPEG 11 + reader 1，合计 57/64；A04 未释放 BRAM 时对应 65/64。DSP 盘点为 9 固定 + JPEG 13 = 22/29。A05 的 LUT 为 6,840，最终能否完整集成需由完整顶层综合/布局布线确认。

A05 的 timing 仍有明确风险：QoR 仅为综合估计，Setup WNS -454ps、8 个端点违例、113 个 unconstrained timing endpoints；A04 为 +86ps、0 违例、5 个 unconstrained endpoints。增加 DRAM 属性后不能据此宣称 50MHz 时序通过。

A06 的 RAM 摘要为 3 Logic DRAM、11 Logic BRAM，其中 `u_ram0` 一组 2 个 BRAM9K 转成 DRAM；整核从 A04 的 19 BRAM9K 降至 17。QoR 为 WNS -454ps、8 个 setup 违例、32 个 unconstrained timing endpoints。父工程盘点的 45 固定 BRAM + A06 core 17 + reader 1 = 63/64，剩余 1 个 BRAM9K。A06 的 DRAM 版本比 A04 多 131 LUT、24 FF；完整顶层实现仍需验证。

已冻结两份逐像素差分候选：A05 位于 `candidate_src/A05/`，23 个 Verilog 文件 bundle SHA256 为 `30821f71dca342f1817c81dc1af39f362cfde52fbc8d9629ea6da92ebfc21248`；A06 位于 `candidate_src/A06/`，24 个 Verilog 文件 bundle SHA256 为 `dd93f248eff46707d95856e7205d6ed044c7dfbc438e39af8701064c6eaa7e7c`。TD 报告、控制台、参数快照、manifest 和逐文件输入哈希见 `candidate_td/{A01..A06}/result.json`。

## 重跑与证据

- `prepare_td.py`：复制 vendor RTL、生成独立 TD project 和 50MHz SDC。
- `run_td.py`：唯一 TD 调用入口，完整输出重定向至 `td_console.log`。
- `finalize_receipt.py`：收集源/设置/报告哈希、资源数据、告警与 QoR 估计到 `result.json`。
- `reports/gate.area`：最终层级面积报告。
- `reports/actualparams.rtl.log` 与 `reports/actualparams.gate.log`：TD 实际参数。
- `td_project/gate.qor`：综合后 QoR 与 timing estimate。
- `manifest.json` 与 `result.json`：core commit、各 RTL SHA256、输入/输出哈希和执行结果。
