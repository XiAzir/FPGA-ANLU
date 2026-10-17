# 旧版频谱 RTL 离线重测

本次用 ModelSim SE-64 10.1c 对 C11304-C11310 的冻结 checkpoint 逐版重新编译并运行封存 `tb_player_spectrum_analyzer.v`。最终有效运行结果见 `summary.json`；逐版完整日志、输入哈希和结果在 `run_20261016_155249/C11304` 至 `C11310`。

| 编号 | 冻结版本 | 结果 |
| --- | --- | --- |
| C11304 | `music_spectrum_20261013_candidate` | 通过；RTL 数组 ROM，未实例化 EG_PHY_BRAM |
| C11305 | `music_spectrum_baseline_phy_20261013_candidate` | 通过；RTL 数组 ROM，未实例化 EG_PHY_BRAM |
| C11306 | `music_spectrum_private_init_20261013_candidate` | 失败；首帧 24 个输出 band 均为 0，和期望值不符 |
| C11307 | `music_spectrum_observed_20261013_candidate` | 通过；载入 EG_PHY_BRAM 与 glbl |
| C11308 | `music_spectrum_tf_margin_20261014_candidate` | 通过；载入 EG_PHY_BRAM 与 glbl |
| C11309 | `music_spectrum_clock_route_20261014_candidate` | 通过；载入 EG_PHY_BRAM 与 glbl |
| C11310 | `music_spectrum_fft_recover_20261014_candidate` | 通过；载入 EG_PHY_BRAM 与 glbl |

通过版本的测试台报告 13 组 × 24 band（312 个输出）、固定点误差为 0，并覆盖 521-clock 实速采样、连续帧、两种 source-change 中止和分析期间复位。C11306 在 case 0 即失败，首帧低频 band 的期望值依次包括 7、6、5，band 4 为 2048，实际 24 个 band 全为 0。各逐版 `result.json` 记录完整 FAIL 行、退出码、加载库信息、manifest 输入 SHA256 和运行副本哈希。

**发现的旧测试台缺陷**

早期试跑 `run_20261016_154935` 中，ModelSim 无法打开 Windows 绝对路径下的 `$readmemh` 输入，却仍打印 `PASS spectrum_analyzer`。该轮 PASS 是空输入假通过，不作为版本结论；原始日志保留在对应目录。最终有效轮次把冻结向量和系数文件复制到各自运行目录，以相对文件名加载，并在隔离 TB 副本中增加 sample/expected 数组逐 word 的 `^word === 1'bx` 检查。修改差异和逆变换精确还原证明分别在每版 `compat/tb_guard.diff` 与 `compat/tb_guard_proof.json`。最终有效日志没有 readmem 打开失败。

ModelSim 10.1c 对 C11306-C11310 原 RTL 在端口连接隐式创建 `twiddle_addr` 网络后再次声明会报重复声明。按任务授权，只在隔离副本中把该声明前移；每版 `compat/relocation_proof.json` 记录原始/副本 SHA256，并验证反向变换与冻结原文逐字一致。生产 RTL 和冻结 checkpoint 未修改。未定义 `PRIVATE_ROM_BEHAVIORAL_SIM`。

C11307-C11310 的封存 TB 有未连接 `debug_coeff_nonzero` 的 ModelSim 端口告警；该调试输出不在本组结果断言中。C11304/C11305 的冻结 RTL 将系数放在内部数组，因此不含独立 `spectrum_coeff_rom.v`，也不会载入 EG_PHY_BRAM；它们仍加载 `EG4.glbl`。C11306 起的外部 ROM 使用预编译库中的真实 EG_PHY_BRAM。

**复跑**

从项目根目录执行：

```powershell
pwsh -NoProfile -File development/regression_failed_releases_20261016/rtl/run_retest.ps1
```

脚本从当前 Windows 用户环境取 `MGLS_LICENSE_FILE`，不打印变量内容；输出只写入本次 `run_YYYYMMDD_HHMMSS` 子目录和根目录 `summary.json`。

**边界**

这是受控 PCM 输入下的离线 RTL 仿真，不包含全机启动流程、HDMI/音频 PHY 行为、完整路由 SDF 或实板验证。结果只说明冻结的频谱分析器及所列测试台行为，不能称为整机通过。
