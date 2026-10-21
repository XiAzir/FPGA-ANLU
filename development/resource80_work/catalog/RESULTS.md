# C11314 FAT32 catalog 隔离优化实验

基线文件：`fat32_catalog_baseline.v`，SHA256 `05491010b67651b8b1bb1cb77a1cb985a9e2ea5838f6e8ddaae5af4523241968`（对应 C11313 resource80 catalog）。实验全程只写入本目录。

## 推荐补丁：锁存所选分区字段复用

MBR LBA0 扫描结束后，`selected_start/selected_size` 已保存首个 FAT32 分区的起点与长度。进入该分区 VBR 后，`is_mbr=1`，现有解析仍会扫描 VBR 字节 446..509 并覆盖 selected 字段，但这些新值不参与任何合法分支：当前逻辑改为只在 `!is_mbr` 时解析 MBR 表；删除 `chosen_start/chosen_size` 及复制寄存器，后续几何使用冻结的 `selected_start/selected_size`。superfloppy 时 `is_mbr=0`，原有 MBR 分支不会接触这些值；MBR 时起点/长度已由 LBA0 选定。接口和周期行为经逐周期差分验证。

补丁：`patch_selected_latch.diff`；候选完整 RTL：`fat32_catalog_candidate_selected_latch.v`。

从仓库根目录验证补丁上下文（此命令只检查，不写入）：

```powershell
git apply --check --directory=development/player_spectrum_resource_80/src/user_source/hdl_source development/resource80_work/catalog/patch_selected_latch.diff
```

主线程应把 `--directory` 指向 C11314 候选文件所在的 HDL 目录，再运行 `git apply --check`；通过后用相同路径运行 `git apply`。本实验只验证过 C11313 基线目录，未改写或应用补丁。
补丁 SHA256 `2920010c1a2068c7ac506c3f0ef4f7f29789e2bda93481c1113d31ae9056f552`；候选 SHA256 `e3c66a3b3a44d1386c966baf09f286a46bf13ab691331340e42e107677fc8cc0`。

## 功能差分

使用冻结基线与每个候选分别运行相同的测试平台。几何测试对 511 个 BPB/MBR 组合逐周期比较全部外部输出；目录测试含完整 SD 扇区、目录项、错误及名称扰动 175 个模式，比较请求地址/顺序和终态输出。每个独立候选和试验组合均通过：

- geometry：1810 条事务/终态 trace 相同，SHA256 `34d15f8efe76bf75dd6ec5efa59b5df307215b14a153b0f520f4e84edb7fd189`；测试内部覆盖 511 个几何例，473529 周期，396 次 root 接受。
- names：525 条事务/终态 trace 相同，SHA256 `739bddabdb9628368fab9637427a62a1c8a14fcab75973437027651d3f23adde`；175 模式含 MBR、active FAT/SPC、溢出、非法 BPB、目录和 FAT 错链。
- 最终 selected_latch 专用记录：`build/selected_latch_diff_result.json`；逐周期对照日志：`build/geometry_reference.log`、`geometry_shared36.log`；目录日志：`names_reference.log`、`names_shared36.log`。

## 独立 AreaOptimizeHigh standalone 综合

TD 6.2.1 SP1，器件 EG4S20BG256，20 ns 时钟；各变体分别加载 RTL，运行 `optimize_rtl` 和 `optimize_gate -packarea`。每个 variant 的 `actualparams` 均确认策略参数：`add_map_lut_struct=high`、`map_mode=area_prior`、`multi_thread_mapping=partition`、`resource_sharing=auto`、`shifter_style=shifter_reg`。表内 device LUT/REG 来自 `gate.area` 的 `#lut/#reg`；generic LUT 是另列字段。

| 变体 | device LUT | device REG | generic LUT | 相对基线 device LUT/REG |
| --- | ---: | ---: | ---: | ---: |
| baseline | 2131 | 837 | 1347 | — |
| SPC 解码复用 | 2071 | 834 | 1294 | -60 / -3 |
| MBR 起点/长度串行拼接 | 2136 | 838 | 1345 | +5 / +1 |
| FAT offset 删除并串移 FAT 项 | 2170 | 835 | 1362 | +39 / -2 |
| cluster 中间运算缩为 32 位 | 2088 | 832 | 1296 | -43 / -5 |
| **selected latch（推荐）** | **2021** | **773** | **1247** | **-110 / -64** |
| SPC + cluster32 | 2087 | 832 | 1297 | -44 / -5 |
| SPC + partition shift + FAT shift + cluster32 | 2101 | 829 | 1323 | -30 / -8 |
| selected latch + SPC | 2042 | 774 | 1272 | -89 / -63 |
| selected latch + SPC + cluster32 | 2033 | 772 | 1251 | -98 / -65 |

完整面积报告、参数日志、console、输入 SHA 和机器可读汇总在 `td_area_high/<variant>/reports/` 及 `td_area_high/summary.{csv,json}`。selected latch 单项优于已测组合，因此建议先只采用该补丁，再与主线程其它已验证改动合并后测 fulltop route Slice。



