# C11306 / C11307 系数 ROM 隔离地址扫描

本复核将冻结的 `spectrum_coeff_rom.v` 单独作为 DUT，逐拍扫描 Hann 地址 0–1023 和 twiddle 地址 0–511，并在每个上升沿后 1 ns 与同一 checkpoint 的冻结 `.mem` 黄金文件比较。没有定义 `PRIVATE_ROM_BEHAVIORAL_SIM`，日志确认加载预编译库 `EG4.EG_PHY_BRAM` 和 `EG4.glbl`。因此扫描没有经过 analyzer 状态机、其 ROM 使能译码或 analyzer 测试台对 band 输出的采样过程。

| 版本 | Hann | Twiddle | 结果 |
| --- | --- | --- | --- |
| C11306 `music_spectrum_private_init_20261013_candidate` | 1024/1024 匹配，未知 0 | 512/512 不匹配，未知 0；首错地址 0，读出 `00000000`，黄金 `7fff0000` | `READBACK_MISMATCH` |
| C11307 `music_spectrum_observed_20261013_candidate` | 1024/1024 匹配，未知 0 | 512/512 匹配，未知 0 | `PASS` |

两份 checkpoint 的 Hann/twiddle `.mem` SHA256 相同，ROM 文件内提取的 144 行 INIT/INITP 常量按序和值完全一致。这组模型内扫描排除了“只有 analyzer 测试台采样时序不对”作为 C11306 首帧全零的解释：直接读取 C11306 模块的 twiddle ROM 也得到 512 个零值，而 C11307 同地址扫描得到完整黄金内容。

实际 twiddle 读控制差异如下，四个 Hann/twiddle BRAM 的地址连接在两版相同。

- C11306 PDPW8K：端口 A/B 地址均接 `twiddle_addr`；`cea=twiddle_en`、`ceb=twiddle_en`；`csa=csb=3'b111`；`wea=web=0`。输出把 `doa` 低 9 位与 `dob` 高 9 位拼接。
- C11307 PDPW8K：端口 A/B 地址仍均接 `twiddle_addr`；端口 A 禁用（`CEAMUX=0`, `cea=0`），端口 B 固定 `ceb=1` 且 `CEBMUX=1`；`csa=csb={twiddle_en,2'b00}` 用片选控制读；`wea=1`, `web=0`。数据输出拼接相同。

这记录的是两个冻结版本中真实的有效控制差异和已观测模型结果；扫描不能将其提升为整机黑屏根因，也不能验证综合映射后的硅上 BRAM 行为、PLL/全机启动、PHY 或路由时序。

可复跑脚本：`run_coeff_scan.ps1`。最后一次有效结果见 `summary.json` 和 `run_20261016_160639/C11306`, `C11307`；逐版 compile、simulation、console、输入哈希及结果 JSON 均在对应目录。旧的运行目录保留了脚本解析器修正前的原始扫描日志，不应用其汇总状态，以最近目录结果为准。
