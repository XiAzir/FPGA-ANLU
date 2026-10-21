# C11316 scaler header-lifetime full six-image pair

结论：fresh Icarus 配对回归 PASS。Baseline 是 C11316 scaler engine SHA `f3d77c0dcaac1a43c59e30deb51b06988a81a9d91f0c6135f0eb17158057c04c`；candidate engine SHA `cde50900d2307674272134b2043c1cd26b53f1372fad913eef1b227a7f9706e2`；两侧使用完全相同的 C11316 loader SHA `8c4c61c8f8474ae44115c3ac0a056910886996302cd0845b775cf00a8b28f5b7`，生产实例 `.HEADER_VALIDATED(1)`。未修改 candidate/main/C11316父源码或冻结文件。

TB 并行运行六个真实loader/scaler pair。每个 pair 都用相同 BMP 输入并各自对 640×480 输出的 307200 个 RGB24 像素逐字比对 golden；baseline 与 candidate 的 loader 160-bit `observation`（全部公开输出）在每个非reset下降沿逐拍比较。六图总输出1843200像素。完成条件要求两侧六个 done 全部置位。

结果摘录见 `full_six_run.log`：六组各打印 `SCALER_ASSET PASS`，末尾为 `SCALER_INTEGRATION PASS images=6 pairs=C11316/CANDIDATE_HEADER_VALIDATED1 pixels=1843200 cycle_outputs=matched native=1 odd_vertical=1`；Icarus exit 0，TB `$finish` at 86204775000ps。图像覆盖320×240 bottom-up、800×600 bottom-up、191×321 top-down padding3、512×128 letterbox、native 640×480、800×599 odd vertical。编译命令日志为空（无错误/告警），stderr为空。

实际复现命令（PowerShell 7）：

```powershell
python development/arch17_work/scaler_lifetime/full_six/prepare_full_six.py
pwsh -NoProfile -File development/arch17_work/scaler_lifetime/full_six/run_full_six.ps1
```

源及媒体SHA、as-run副本SHA、参数、compile/run日志哈希和完成标记均记录在 `source_receipt.json`。生成器将 C11316 与 candidate engine 仅重命名 module identifier 后绑定到相同 C11316 loader 的两份同内容副本。第一次复制模板后的编译在 elaboration 时发现旧诊断代码使用 `dut.u_scale.*` 层级；该次只编译失败，日志保留在 `compile_attempt1_hierarchy.log`。生成器随后移除了仅用于pixel mismatch时打印的旧层级诊断，TB的golden逐像素检查和全部公开输出逐拍比较保持完整；重新编译和完整仿真通过。
