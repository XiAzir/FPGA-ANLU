# C11314 资源优化候选

最终B04：7748/9800 Slice（79.06%），Setup +0.633ns、Hold +0.011ns、TNS0。较用户确认功能与频谱正常的C11313减少495 Slice。Physical LUT13976/FF7858/LE14779/BRAM45/DSP10，原时钟、引脚与SDC保持。

位流：`../../download/spectrum_resource_80.bit`，同名info.json记录哈希和版本；当前状态为BOARD_NOT_TESTED。父版本`../../download/spectrum_resource_fit.bit`继续保留。

源码在src；构建入口为scripts/build_candidate.ps1，顺序执行`-Stage synthesis`、`-Stage physical`、`-Stage bitstream`。阶段runId与源/脚本/数据库/报告哈希由stage_evidence绑定，交付使用该入口。

选中快照：checkpoints/C11314_resource80_20261021_offline/manifest.json，282文件；build/final_binding.json为PASS。完整算法、单项消融、负收益实验、测试范围与板测步骤在资料仓`开发记录/专题记录/资源优化/C11314_20261020/README.md`。本轮实验和可复现脚本在../resource80_work；独立长链、BMP/WAV/catalog差分与最终整机122ms、真实EG4 gate FFT/ROM、routed时钟审计均通过。

整机仿真使用nominal PLL edge replay及应用接口SDRAM模型，新C11314板测待补。工程和资料均保存在本地，本轮未提交或push。
