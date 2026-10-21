# C11315 FAT32 catalog 固定 BPB 字段压缩实验

范围：仅限本目录。未修改C11315主工程、bit、冻结清单及既有工程。基线是 `development/player_spectrum_spi12p5/src/user_source/hdl_source/fat32_catalog.v` 的逐字节副本。

## 实现

固定字段 BPB bytes-per-sector、root-entry-count、FAT16-size、FAT32-version 原来分别保存两个原始字节，再在 `bpb_header_candidate` 和 `S_BPB_CHECK` 比较固定值。候选改为各字段一位 `*_fixed_valid`，在原字节到达拍完成低/高字节累计；四组原始寄存均删除，最终生产候选另删除审阅发现的两项未使用声明 `rootent1` 与 `version_lo`。候选不新增状态或外部周期。

MBR LBA0第一次读取期间四个标志从LBA0字节流生成；若需读取分区VBR，原有索引/标志将在对应字节拍逐项重写，完整512字节和校验间隔之后才执行BPB判定。这保留了 `bpb_header_candidate` 对MBR fallback的作用及原错误分支顺序。

- 基线 SHA256：`E3C66A3B3A44D1386C966BAF09F286A46BF13AB691331340E42E107677FC8CC0`
- 最终候选：[fat32_catalog_candidate_fixed_flags.v](fat32_catalog_candidate_fixed_flags.v)，SHA256 `c73d62f6a4eae3bcedcf60f40ff29898e5c3489655e171d6b373abd670d1151a`
- Unified diff：[fixed_flags.diff](fixed_flags.diff)，SHA256 `dc31b5d2377c9503093e0baeaf7b26f7d0b9b8c8e33b3999e9629c4c32df601f`

## 功能差分

逐周期完整输出差分使用本目录固定的 C11315 基线与每个候选：511几何用例加逐拍地址/结果跟踪；175目录用例比较请求与终态。扩展负例分别扰动四字段的低/高字节、其全部15个非空坏值组合，覆盖LBA0直接VBR与MBR→VBR路径；并检查BPB错误优先级。最终候选新增511/513字节扇区用例，覆盖LBA0与MBR→VBR；应报原 `E_SECTOR`。

- 全部15个字段消融候选各自通过：geometry 1960 trace records、names 525 trace records。机器结果 `build/matrix_summary.json`；各项逐拍日志在 `build/matrix/<variant>/`。
- 最终SHA候选复跑通过：geometry 1970 trace records、names 525 trace records。日志为 `build/geometry_reference.log`、`geometry_shared36.log`、`names_reference.log`、`names_shared36.log`；摘要 `build/extended_diff_result.json`。
- 单项分别为四字段各自压缩；组合包含其余11个非空掩码。四字段坏值矩阵逐字段各检查低字节、高字节与组合值。

## 综合面积

综合为 standalone `fat32_catalog`，EG4S20BG256，20ns时钟，AreaHigh：`add_map_lut_struct=high`、`map_mode=area_prior`、`multi_thread_mapping=partition`、`resource_sharing=auto`、`shifter_style=shifter_reg`，并使用 `min_ripple_len=18`、`mapper_lut_delay=1600`。完整实际参数与控制台日志保存在 `td_area_high/`。

首轮同一TD进程按baseline、all-fields及消融变体顺序打开项目。baseline资源：device LUT 2003、REG 773、generic LUT 1265。首次all-fields候选资源：device LUT 1956、REG 710、generic LUT 1234，相对基线变化为 -47 LUT、-63 REG、-31 generic LUT。RTL减少60个原始存储位（4×16 bit改4个valid flag）；综合REG净减63，额外3来自工具优化，不等同于RTL直接删63位。TD批次后续项目出现相同20ns时钟重复定义告警；baseline第一项无此告警。最终候选在独立fresh TD进程重新综合，clean报告 `td_area_high/clean_combined/reports/gate.area` 与实际参数日志均保留；此轮无重复时钟告警，参数与批次一致，面积相同。完整参数/控制台在 `td_area_high/clean_combined/`。批次完整消融汇总为 `td_area_high/area_summary.csv`、`area_summary.json`。

## 接续状态

- 功能等价、最终候选差分、完整/短/长扇区以及正确TD干净复测均通过后，父任务可自行评估是否纳入C11316；本实验不修改主工程。
- 暂未做fulltop综合、P&R、上板和bit；standalone面积不表示fulltop Slice或时序变化。

### 全部单项与组合面积

device LUT/REG来自`gate.area`中的`#lut/#reg`；generic LUT来自`#Total_luts`。baseline与最终组合使用无重复时钟的有效报告；中间消融行使用同一批次相同20ns时钟状态。

| 字段压缩 | device LUT | device REG | generic LUT | 相对基线（LUT/REG） |
| --- | ---: | ---: | ---: | ---: |
| 基线 | 2003 | 773 | 1265 | +0 / +0 |
| 全部四项 | 1956 | 710 | 1234 | -47 / -63 |
| bps | 1998 | 759 | 1264 | -5 / -14 |
| rootent | 1991 | 759 | 1260 | -12 / -14 |
| bps+rootent | 1999 | 744 | 1260 | -4 / -29 |
| fat16 | 1961 | 759 | 1244 | -42 / -14 |
| bps+fat16 | 1989 | 744 | 1256 | -14 / -29 |
| rootent+fat16 | 1996 | 740 | 1254 | -7 / -33 |
| bps+rootent+fat16 | 1967 | 725 | 1230 | -36 / -48 |
| version | 2003 | 757 | 1258 | +0 / -16 |
| bps+version | 1988 | 744 | 1252 | -15 / -29 |
| rootent+version | 1987 | 744 | 1263 | -16 / -29 |
| bps+rootent+version | 1983 | 725 | 1245 | -20 / -48 |
| fat16+version | 1984 | 744 | 1250 | -19 / -29 |
| bps+fat16+version | 1973 | 725 | 1245 | -30 / -48 |
| rootent+fat16+version | 1986 | 725 | 1246 | -17 / -48 |

四个单项中fat16-size压缩的standalone device LUT收益最大（-42）；组合优化后为-47 LUT/-63 REG。RTL按原始寄存位数计算是64位改为4个标志位，理论减少60个寄存位；综合净减63 REG另有工具优化贡献，记录为实现后统计，不能全部归因于字段寄存器删除。
