# C11316 离线资源优化候选

父版本：C11315 `player_spectrum_spi12p5`。最终7584/9800 Slice（77.3878%），减少48 Slice、1 DSP；Setup +0.649ns、Hold +0.024ns、TNS0。

生产改动：BPB固定字段改流式匹配标志；通过loader头部验证后，在编译期消除scaler四组重复范围检查。SPI保持mode3、12.5MHz。无收益/负收益消融保留在 `build/attempts` 与 `development/opt16_work`。

- 位流：`download/spectrum_opt16.bit`，SHA256 `1de561dda1428c86c2f3127cf55b4b391cae8598c51111394ef9bde0ee971afa`。
- 交付绑定：`build/final_binding.json`，500文件冻结清单，99 source scope，11个整机override，三份位流相同。
- 冻结目录：`checkpoints/C11316_opt16_20261021_offline`，manifest SHA256 `cb4730c01a5eb5ccc4503d7df4c0e847e538b1db846f926bce2eb66bd1dc3fb1`。
- 完整记录：`E:/QQ CACHE/Download/安路资料/开发记录/专题记录/资源优化/C11316_20261021/README.md`。

六图1843200像素/loader逐拍、538诊断、15字段组合、122ms整机、72频带门级FFT、ROM/时钟审计均通过。实板验证待补；C11315源码、冻结文件与位流保持。
