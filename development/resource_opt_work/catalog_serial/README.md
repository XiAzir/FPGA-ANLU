# FAT32 catalog BPB 36-bit共享ALU实验

本实验只读当前主候选并写入本隔离目录，主候选文件保持原样。

## 输入与方案

- 综合/差分基线：`development/player_spectrum_resource_fit/src/user_source/hdl_source/fat32_catalog.v`，SHA256 `05491010b67651b8b1bb1cb77a1cb985a9e2ea5838f6e8ddaae5af4523241968`。
- 隔离候选：`fat32_catalog.v`，SHA256 `63e1e644eee016353030ab50172c855210a4108026e552372fdf154899f8d365`。
- 方案：在 `S_BPB_PREP0` 用一个36位加/减器按8步计算 FAT 起点、卷/分区范围标志、数据扇区数、FAT LBA、data LBA 和 root LBA。结果临时保存在既有结果寄存器中；原有 BPB 合法性检查、错误码、扇区握手和目录状态机保持。

## 等价依据

对加法项，操作数零扩展到36位。FAT area、FAT LBA、data LBA 和 root LBA 的最终截位范围分别与原结果寄存器宽度一致。卷/分区范围原谓词是 33 位和大于 `2^32`；两个32位无符号操作数之和落在 `[0, 2^33-2]`，故该谓词等价于和的 bit32 为1且低32位非零，恰好排除低32位全零的 `2^32` 边界。

数据扇区数原本按34位模数做 `total32-fat_area`。36位减法结果取低34位与34位减法同余，因而包括下溢时也保持位级一致。其后仍按原 `spc_shift_calc` 右移。分步计算只在 BPB 几何准备期间延迟检查，不改变任何外部 SD 请求地址顺序或目录输出。

## 仿真

以下 PowerShell 7 命令调用 `scripts/anlu_tools.ps1` 找到 Icarus：

```powershell
& 'E:\VSCODE-project\FPGA-ANLU\development\resource_opt_work\catalog_serial\run_diff.ps1'
& 'E:\VSCODE-project\FPGA-ANLU\development\resource_opt_work\catalog_serial\run_extended_diff.ps1'
```

- 基础15模式：45条 SD 请求与终态接口 trace 完全相等。
- 511几何用例：两个 DUT 绑定到同一variant，以保留原 directed/random expected 断言；基线和候选各511例通过，root_accepts均396。基线473529总周期，候选478044总周期；不同周期数来自串行几何准备。
- 175目录用例：基线和候选各175例通过；525条 SD 请求与终态接口 trace 完全相等。
- Trace/日志：`build/diff_result.txt`、`build/extended_diff_result.json`、`build/*_reference.log`、`build/*_shared36.log`。

## TD6.2.1 独立综合

两variant使用同一个 `EG4S20BG256` 设备、20ns时钟、独立最小 `.al`、单模块 `fat32_catalog`、`load_run_param -run syn_1`、`optimize_rtl`、`optimize_gate -packarea`。运行命令：

```powershell
& 'E:\VSCODE-project\FPGA-ANLU\development\resource_opt_work\catalog_serial\run_synthesis.ps1'
```

| variant | device LUT | FF | generic LUT | ripple | seq | DSP |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 当前源基线 | 2110 | 838 | 1184 | 463 | 1285 | 0 |
| 36位共享ALU | 2197 | 837 | 1485 | 356 | 1280 | 0 |
| 变化 | +87 | -1 | +301 | -107 | -5 | 0 |

综合结果显示共享加法器降低 ripple 计数，但操作数/结果选择逻辑使器件 LUT 增加87。该方案在面积目标上表现为负收益，不建议合入主候选。完整console、`gate.area`、variant SHA和机器可读汇总在 `synthesis/`。
