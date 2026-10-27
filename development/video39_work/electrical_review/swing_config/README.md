# EG4S20BG256 原生 LVDS33 大摆幅配置调查

调查日期：2026-10-27  
工具：TD 6.2.1 SP1（本机安装目录 `C:\Anlogic\TD_6.2.1_SP1_6.2.178.840`）

## 结论

已找到并按官方文档确认配置方法：在 ADC 的 `set_pin_assignment` 属性中设置 `VCM` 和 `VOD`。这是逐 I/O pin 指定、同一 Bank 内需要统一的属性；TD 手册错误码 USR-8090 明确指出同一 Bank 不允许多个 VOD 值。

对 EG4，TD 6.2 用户手册列出 `VOD` 可设置值 150、200、250、350、480 mV；`VCM` 可设置值 0.8、0.9、1.2 V。星号标示的软件默认值为 VOD=350 mV、VCM=1.2 V。对应合法 ADC 写法见手册示例：`set_pin_assignment {sys_clk} {LOCATION=A3; IOSTANDARD=LVDS33; VCM=0.8; VOD=350m}`。本次在隔离 ADC probe 将 VOD 改为 `480m` 并将 VCM 设为 `0.8`，TD 6.2.178840 的 `read_adc` 返回成功，解析日志包含四条对应 `set_pin_assignment`，随后通过 IO setups / VREF legality check。

因此，对 C39 Bank1 四对原生 LVDS33，手册公开可配置的“大摆幅”档位是 `VOD=480m`，需给该 Bank 所有相关 LVDS pin 一致指定；可配 VCM 值为 0.8、0.9、1.2 V。手册同时注释不建议 VOD=480 mV。不可将 DS300 表中 450 mV 最小/480 mV 典型/550 mV 最大，误读成 TD 可逐项接受的三个 ADC 值：TD 对 EG4 明确列出的可配置 VOD 集合只有 150/200/250/350/480 mV。

此前 C39 当前构建日志报告 `PHY-3001 : BANK 1 DIFFRESISTOR:NONE VOD:350M VCM:1.2`，与 TD 用户手册列出的软件默认值相符。该日志是构建属性报告，不是板端波形测量。本次 probe 验证了属性命名和值 `480m` 的 ADC 解析接受性；未执行综合、布局布线或硬件操作。

## 配置示例

```tcl
set_pin_assignment { L4_P } { LOCATION = K11; IOSTANDARD = LVDS33; VCM = 1.2; VOD = 480m; }
set_pin_assignment { L6_P } { LOCATION = L14; IOSTANDARD = LVDS33; VCM = 1.2; VOD = 480m; }
set_pin_assignment { L7_P } { LOCATION = K15; IOSTANDARD = LVDS33; VCM = 1.2; VOD = 480m; }
set_pin_assignment { L9_P } { LOCATION = H13; IOSTANDARD = LVDS33; VCM = 1.2; VOD = 480m; }
```

以上展示手册支持的配置语法和同 Bank 一致性；这是调查说明，未写入 C39 生产约束。选择哪档 VCM/VOD 以及外部终端方案，应结合接收器输入范围和实测确认。

## 证据

1. `C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\doc\TD_User_Guide_V6.2.pdf`，PDF 第 159 页（印刷页 158），第 9.1 节表 9-1/表 9-2：
   - ADC 支持属性包括 BANK、LOCATION、IOSTANDARD、DRIVESTRENGTH、PULLTYPE、PREEMPHASIS、SLEWRATE、DIFFRESISTOR、PCICLAMP、PACKREG。
   - LVDS 输出 `VCM` / `VOD` 设置示例：`set_pin_assignment {sys_clk} { LOCATION = A3; IOSTANDARD = LVDS33; VCM = 0.8; VOD = 350m }`。
   - VCM/VOD 仅适用于 LVDS25/LVDS33。表中 EG4 VOD 值：150、200、250、350*、480；VCM：0.8、0.9、1.2*。星号表示默认。手册说明超出所列范围不支持，并注释不建议 VOD=480 mV。
2. 同一用户手册 PDF 第 172 页（印刷页 171）USR-8090：同一 Bank 中设置超过一个 VOD 值会报错。表述支持“同 Bank 必须统一 VOD”的结论。
3. `C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\doc\SWUG\SWUG105_TCL_Command_User_Guide.pdf`，PDF 第 31 页（印刷页 25），4.3.2 节：`read_adc <file_path_name>` 用于读取和解析 ADC 文件。按这条官方命令说明运行隔离探针，没有调用综合或物理设计命令。
4. 隔离 probe：`development\video39_work\electrical_review\swing_config\parser_probe\pin.adc` 为四对 LVDS33 pin 设置 `VCM=0.8; VOD=480m`；`read_only_parser_probe.tcl` 仅执行 `import_device`、`read_hdl`、`read_adc`。TD 6.2.178840 输出 `ADC_PARSER_PROBE_ACCEPTED`，并显示四条约束已解析。
5. DS300：`E:\QQ CACHE\Download\安路资料\赛题1_工作资料\04_补充芯片手册\DS300_Eagle_EG4系列数据手册_v3.9.6_官方.pdf`，PDF 第 84 页（印刷页 78），表 3-1-15：标准输出 VOD 150/250/350 mV（最小/典型/最大）；大摆幅 VOD 450/480/550 mV（最小/典型/最大）；VCCIO=3.3 V、RT=100 Ω 时 VOCM=0.6–1.4 V。芯片手册电气范围与 TD 用户手册的 ADC 配置取值表作用不同。
6. C39 当前构建依据：`E:\VSCODE-project\FPGA-ANLU\development\video39_work\native_probe\B\src\user_source\pin.adc` 仅显式设置 LVDS33；`E:\VSCODE-project\FPGA-ANLU\development\video39_work\native_probe\B\build\td_run_clock_probe_b_retry03.log` 第 753 行报告 Bank1 VOD=350M、VCM=1.2。

## 本次操作范围

- 读取 TD 自带用户手册与命令手册，确认属性名、EG4 可选值、默认值与解析命令。
- 在 `swing_config/parser_probe` 创建 3 个隔离文件：最小 HDL、ADC 输入、只含 import_device/read_hdl/read_adc 的 TCL 脚本。
- 运行 TD 命令提示符完成 ADC 解析验证；命令流程已退出。没有综合、布局布线、bitgen、下载或板端操作。
- C32/C37/C38/C39 生产源与约束、bit/info、资料原件均未改动。

## 板端验证提示

如果实际采用 VOD=480 mV，需按 DS300 要求结合 RT=100 Ω 条件核对负载，再用差分探头测量 VOD/VOCM；并检查接收端允许输入范围。`480m` ADC 解析成功只证明 TD 接受该配置语法和值。

完整 TD 命令输出留档：development\video39_work\electrical_review\swing_config\parser_probe\td_parser_result.log。该日志记录了 read_adc 接受四个 LVDS33 输出的 VCM=0.8; VOD=480m 约束。
