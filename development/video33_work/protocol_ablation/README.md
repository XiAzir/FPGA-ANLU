# C36 短水平blank A/B 源级消融

日期：2026-10-27。仅在本目录建立两份独立诊断工程；生产C36/C33源、位流和共享 `protocol_gate` 文件均保持原样。TD只执行synthesis/mapping并导出gate/area/timing文件；未执行route、bitgen或上板。串行引脚回放采用官方TD6.2.1 SP1 EG4功能模型和 `protocol_gate/tb_gate_pins.sv` 等价副本，timer仅按根既定方法加速启动计数。每版采集200,000串行字，所有仿真输入与结果都保存在本目录。

## A/B改动与约束

基线来源：`development/video33_work/candidates/C11336_1080p15_serial_bufg/src/user_source`。A/B共用C36所有user_source文件，只对top内视频时序改为共同的Vactive16/Vtotal36，保留VFP/VSA/VBP=4/5/11；保持pixel/serial PLL 33/165MHz、HDMI core参数/PHY/10:1 lane、audio valid/ACR valid=0。A/B之间唯一HDL差异是HBP/HTOTAL；独立TD项目的project ID/绝对path按A/B分别设置。配对源约束已核验：见[`source_manifest.json`](source_manifest.json)，`pair_source_constraint=true`。

| 项 | A | B |
|---|---:|---:|
| Hactive / HFP / HSA / HBP / Htotal | 1920 / 8 / 8 / 64 / 2000 | 1920 / 8 / 8 / 144 / 2080 |
| 水平blank | 80 | 160 |
| Vactive / VFP / VSA / VBP / Vtotal | 16 / 4 / 5 / 11 / 36 | 16 / 4 / 5 / 11 / 36 |
| pixel / serial clock | 33 / 165 MHz | 33 / 165 MHz |

## 结果

| 观察 | A：blank80 | B：blank160 |
|---|---|---|
| TD synth/map | 完成；peak WS181.0MiB，Private163.3MiB | 完成；peak WS179.7MiB，Private163.6MiB |
| pin字数 / 首lock | 200,000 / word72,001 | 200,000 / word74,881 |
| 锁后有效行 | 32行，每行1920字；Hperiod全部2000；两锁后帧起点间隔72000 | 32行，每行1920字；Hperiod全部2080；两锁后帧起点间隔74880 |
| 锁后岛payload | 31次被VideoGB打断的48符号片段（mod32=16）；其中30个落在有效视频行；另1个在第二锁后帧首行开始前的垂直空白末端，payload word143974..144021，下一首行burst从144024开始。A的两个完整96符号可见行岛都位于各帧最后可见行（相对行首偏移1950），payload跨行延续至Vblank。 | 可见视频行32个完整96符号岛；总计80个完整岛，其中垂直空白行48个。所有80个尾guard均为2符号；VideoGB前32次preamble符合至少8符号（31次长度8，1次超长控制序列跨过首lock边界）。 |
| 协议解析 | `PROTOCOL_VIOLATIONS_DETECTED`；32次岛被VideoGB截断，31次发生在lock后，缺尾guard及后续8符号video preamble | 0协议违规；严格默认解析器完成，状态`DIGITAL_TIMING_PASS_STARTUP_RGB_DIFFERENCE` |
| RGB对照 | 首锁定行7处彩条边界差异；后续行0差异 | 首锁定行7处彩条边界差异；后续行0差异 |

A在有效视频行中主要形成48符号半包并直接转VideoGB；两个96符号完整岛分别位于每帧最后一个可见行并延续至垂直空白，需结合上下文解读，不能把它们算作80像素水平blank可容纳三包的证据。B的32个锁后有效视频行均恢复96符号三包岛，并解析到两符号尾guard与视频preamble边界。两组均保留首锁定行7处RGB边界差异，后续行未见差异。

严格解析器对A在symbol72022中止，日志记录 `Unknown TERC4 payload at 72022: (716, 307, 716)`；`VIDEO_GUARD` lane0 `0x2CC`按VideoGB分类并报告违规，未作为TERC4 payload解码。显式`--report-invalid-transitions`模式保留后续捕获并生成违规计数；B严格模式exit0。对应日志为[`A strict`](A/A_strict_parser.log)、[`B strict`](B/B_strict_parser.log)和[`分析器副本`](analyze_words_ablation.py)。

TD映射规模接近：A 1407 LUT / 1252 regs / 8 BRAM9K；B 1405 LUT / 1252 regs / 8 BRAM9K。两组指标供本诊断对照，未包含布局布线或板级结果。

## 可复核产物

- [`evidence_summary.json`](evidence_summary.json)：A/B设置、source/gate hash、运行元数据及完整逐岛观测。`sim_model_manifest.json`记录官方primitive源文件hash和两份新鲜Modelsim.ini映射。
- [`source_manifest.json`](source_manifest.json)：C36原始source与A/B副本逐文件SHA256；A/B除top内水平blank参数外所有user_source hash一致，项目文件经ID/path归一化后一致。
- `A/build/manual/`、`B/build/manual/`：仅TD synth/map日志、内存采样、mapped gate、area和timing报告。
- `A/sim/`、`B/sim/`：每版独立Modelsim ini/work库、官方模型/bench编译日志、顶层仅重命名的gate副本及binding JSON、完整200k words串行流、捕获日志和元数据。
- `A/A_analysis_invalid_transitions.json`、`B/B_analysis_invalid_transitions.json`：显式违规恢复模式观测；`A/A_strict_parser.log`与`B/B_strict_parser.log`记录默认严格模式结果。

首次回放入口曾因ModelSim 10.1c不接受`vsim -work`以及Windows反斜杠`-modelsimini`路径而失败；相关错误保存在 `A/sim/A_vsim_option_failure.log`、`A/sim/A_modelsimini_path_failure.log`。修正为Modelsim.ini的`work`映射后，A/B正式200k回放均退出码0，捕获完成标志均存在。该两次环境错误没有修改映射gate或HDL源。

覆盖范围为EG4官方功能模型和16行短垂直诊断时序；未运行route/SDF、未观察真实接收器、未上板。最终C33 15Hz sink反馈与C36整片长回放结论由根任务关联解释。

