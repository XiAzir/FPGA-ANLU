# Mapper standalone TD 综合消融

该实验在 `runs/<variant>/` 下为每个版本创建独立最小 Tang Dynasty 工程，只登记一个 `fat32_file_sector` 源文件。五组都使用 TD 6.2.1_SP1_6.2.178.840、EG4S20BG256、相同 20 ns 时钟约束和 `import_device`、`open_project`、`load_run_param -run syn_1`、`elaborate -top fat32_file_sector`、`optimize_rtl`、`optimize_gate -packarea` 命令。运行顺序固定为 reference、algorithm-only、address-only、index-only、combined；没有启动布局布线或位流。

可在工程根目录复跑：

```powershell
pwsh -NoProfile -File development/resource_opt_work/mapper_synthesis/run_mapper_synthesis.ps1
```

每个版本的完整 TD console 保存在 `runs/<variant>/console.log`，完整 area 输出位于 `runs/<variant>/reports/gate.area`，QoR 报告位于 `runs/<variant>/td_project/gate.qor`。源输入哈希、器件、时钟和工程路径记录在 `runs/input_manifest.json`；五组的 LUT、FF、carry pack、DSP、源哈希及相对 reference 的差值汇总在 `runs/synthesis_summary.json` 与 `.csv`。

| 版本 | LUT | FF | Carry chain pack | DSP | LUT+FF 相对 reference |
| --- | ---: | ---: | ---: | ---: | ---: |
| reference | 836 | 440 | 14 | 0 | 0 |
| algorithm-only | 777 | 449 | 12 | 0 | -50 |
| address-only | 828 | 454 | 14 | 0 | +6 |
| index-only | 807 | 397 | 14 | 0 | -72 |
| combined | 726 | 397 | 12 | 0 | -153 |

LUT 来自 `#Total_luts`，FF 来自 area 报告 `#reg`，carry 取综合 console 的 `Pack N carry chain into lslice`。combined 比 reference 少 110 LUT、43 FF 和 2 条 carry chain，DSP 均为 0；这达不到 500 个 LUT+FF 的目标。address-only 单独略增寄存器与 LUT+FF；algorithm-only 有 9 个 FF 增量但 LUT 降 59。完整量测据此表明这版适合和 index/algorithm 分项继续评估，单独 address 改写的收益不足。

该 standalone 顶层显式暴露 262 个 IO，超过 EG4S20BG256 报告的 188 个 package pads。因此这些数字用于同条件比较 mapper 逻辑综合面积；它们没有证明完整 FPGA 顶层能够通过布局布线。TD 仅执行综合，未生成物理结果或位流。

仿真差分对应 `../build/mapper_proposal/`，每种单项变体及 combined 均通过 13,344 周期边界差分；combined 的最长合法簇链/cache/EOC/Brent-loop 差分也通过 6,381,198 周期。

## 簇内偏移 OR 消融

`../mapper_aligned_proposal.py` 提供独立 `apply(hdl_path)`：原版输入上会先生成上述 combined latest-wire 版本，再把簇内偏移两项的加法改为按位 OR；已是 latest-wire 输入时只应用 OR 改写。由于移位簇偏移的低 `shift` 位全为零，而簇内 sector mask 只置这些低位，两项对 `shift=0..15` 始终无交集，故两项之和等于按位 OR。data_lba 仍经同一个 44 位加法器，低 32 位与溢出检测不变。

`run_or_pair.ps1` 顺序综合 combined 与 combined_or，沿用相同最小工程、EG4S20BG256 和 20 ns SDC；每组 console、`gate.area`、QoR 和源哈希在 `or_ablation/`。复跑命令：

```powershell
pwsh -NoProfile -File development/resource_opt_work/mapper_synthesis/run_or_pair.ps1
```

结果：combined 726 LUT/397 FF/12 carry/0 DSP，combined_or 708/397/11/0，OR 消融再减 18 LUT 和 1 条 carry，FF 不变。combined_or 源 SHA256 为 `650bec7bedd7939a4059079eafb5ab5a84613ab8e9e0de5ec89be384c0b70e27`。边界夹具已覆盖非零 sector=127 与 live shift 0..15 的组合（shift=7 用于通过检查并选择 target 0，随后于 S_SELECT 改 shift）；13,344 周期差分通过。reference 与 OR 候选的 6,381,198 周期长链差分也通过。路径见 `or_ablation/or_ablation_summary.json`。该改写保持等价，但累计 LUT+FF 减量为 171，依旧低于 500；area-only report 无 P&R 结论。
