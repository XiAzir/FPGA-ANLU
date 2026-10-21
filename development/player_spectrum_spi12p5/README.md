# C11315 SPI高速配置

修正SD控制器工作态对高速参数的硬编码覆盖；top明确DIV0，名义数据SCLK12.5MHz，初始化100kHz。C11314原数据阶段也因硬编码0而运行在12.5MHz。C11315使参数统一生效，DIV2参考实测6.25MHz、DIV0实测12.5MHz。

7632/9800 Slice（77.88%）；Setup+0.157ns/Hold+0.011ns/TNS0。11项源码override完整整机图像/音频/频谱、CRC、gate FFT/ROM与routed时钟审计通过。新bit实板待测。

位流：`../../download/spectrum_spi12p5.bit`及info.json；冻结：checkpoints/C11315_spi12p5_20261021_offline/manifest.json（324文件），build/final_binding.json为PASS。构建入口scripts/build_candidate.ps1，按synthesis→physical→bitstream运行。

工作脚本与参考对照在../spi12p5_work；资料仓报告`开发记录/专题记录/SPI提速_20261021/C11315_实施记录.md`记录参数覆盖发现、真实速度、吞吐与服务时间、完整源/阶段/bit哈希及板测步骤。原C11314源/bit和冻结清单保持，当前未上板、未提交或push。
