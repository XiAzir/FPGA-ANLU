# AdderChainThresholdHigh standalone 消融

实验范围仅含两个模块：当前 `player_spectrum_resource_fit` 的 `fat32_catalog.v` 与 `fat32_file_sector.v`。RTL 字节不变，在 `EG4S20BG256`、20ns 时钟下分别跑 default baseline 和官方 `AdderChainThresholdHigh` 参数组；每个模块/variant 有独立最小 `.al` 与 TD 项目。只运行 `syn_1`，没有布局布线。

官方参数来自 `C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/doc/strategies/official_strategy_ph1.json`：`rtl min_ripple_len=18`、`gate mapper_lut_delay=1600`。Tcl 使用当前 runtime 形式 `set_param rtl ...` 和 `set_param gate ...`；各阈值组的 `report_param` 输出已验证两值生效。

| 模块 | variant | device LUT | device reg | ripple | seq | generic LUT | DSP |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| fat32_catalog | baseline | 2110 | 838 | 463 | 1285 | 1184 | 0 |
| fat32_catalog | AdderChainThresholdHigh | 2020 | 838 | 419 | 1285 | 1182 | 0 |
| fat32_file_sector | baseline | 1226 | 397 | 259 | 549 | 708 | 0 |
| fat32_file_sector | AdderChainThresholdHigh | 1234 | 397 | 240 | 549 | 754 | 0 |

catalog standalone 的 device LUT 减少90，reg持平；mapper standalone 的 device LUT 增加8，reg持平。两个模块 ripple 均减少，mapper 的 generic LUT 增加46。结果只支持在全 top 上验证 catalog 这一策略的物理面积影响，mapper 单模块暂不显示净收益。

复跑命令（PowerShell 7）：

```powershell
& 'E:\VSCODE-project\FPGA-ANLU\development\resource_opt_work\adder_threshold\run_synthesis.ps1'
```

源 SHA、参数 JSON、机器汇总、完整 console、`gate.area` 和 `report_param` 回读均在 `runs/`。catalog baseline/阈值组 SHA 均为 `05491010b67651b8b1bb1cb77a1cb985a9e2ea5838f6e8ddaae5af4523241968`；mapper baseline/阈值组 SHA 均为 `650bec7bedd7939a4059079eafb5ab5a84613ab8e9e0de5ec89be384c0b70e27`。
