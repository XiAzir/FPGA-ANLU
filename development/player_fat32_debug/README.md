# FAT32 实物诊断版

2026-10-07，从 `development/player_fat32` candidate_v1 隔离复制。
用途是定位用户反馈的四图固定乱码、无声、D2/D0 亮；此版本不是修复完成版。
稳定回退仍为 `development/player_480p/build/manual/AC201_tf_hdmi_data_d1.bit`。

## 下载与观察

- 位流目标：`build/manual/AC201_player_fat32_diagnostic.bit`，仅在完整构建及原约束下时序核对后使用。
- 原卡文件保留；板卡断电时把 TF 卡从读卡器移回板卡，再按已使用的 PROGRAM_SRAM 流程下载。尚未 Flash 固化。
- 启动后保持默认手动模式，等首图稳定；拍清画面左上角四行、每行八个十六进制字符。KEY0 可切换到下一张，再拍一张；KEY1 开关自动播放。
- 若诊断字也无法辨认、黑屏，记录现象与 LED，然后回载稳定 data_d1。

## 四行含义

1. `FF CC BB WW`：flags、catalog error_code、BMP mapper error_code、WAV mapper error_code。flags 从 bit7 到 bit0 是 fs_ready、display_valid、wav_found、wav_primed、wav_error、bmp_error 或 bmp_map_error、wav_map_error、audio_underflow。
2. 最近完整收到的源 RGB 像素的 32 位加和。监视点在 BMP 输出、帧缓存入口。源像素全帧到齐才发布；不能据此证明 SDRAM 输出或 HDMI 图像正确。求和一致也不是逐字节证明。
3. 首次 WAV error 时冻结的缓存扫描字节位置；没有错误时为 0。
4. `DD SP MMMM`：首次 WAV error 时的缓存输出字节、state、scan_phase、首两个逻辑 WAV 字节（正常 `4952`，即 RI）。位置、字节是首次检测到错误时的被动快照，状态可能已进入 HALTED。

源图像求和期望值（实际卡只读快照逐点转换所得）：

| 文件 | 第 2 行期望值 |
| --- | --- |
| 00_apple.bmp | FB167260 |
| 01_berry.bmp | C3EBCE2E |
| 02_melon.bmp | 0B94A9DB |
| 03_a.bmp | 98DF6A9E |

理想的稳定第一行是 `F0000000`（fs ready、display valid、WAV found/primed，其余无错）。
诊断总线用两拍同步、VS 边沿更新；多位总线是只读观测值，过渡期可能不一致，待画面稳定后读数。叠字不增加像素输出流水拍，其外 RGB 透传。

## 修改边界与验证

只在此副本接入 `player_debug_monitor.v`、`player_debug_overlay.v`；WAV 增加四个输出观测端口，top 增加监视和叠字，`.al` 注册新文件。原文件层状态机、帧缓存、SDRAM、SD 控制器、PLL、引脚及 SDC 不改。

- `sim/tb_player_debug_monitor.v`：完整帧才发布求和、下一帧清零重算、WAV 前两字节捕获、第一次错误冻结、行顺序，通过。结果 `build/monitor_sim/monitor.log`。
- `scripts/run_wav_file_sim.ps1`：WAV 原有正常、畸形、边界、FIFO 并发等回归通过。
- `scripts/run_debug_overlay_sim.ps1`：完整 640×480 字形、背景、区域外 RGB/同步透传及第二帧坐标复位通过。
- 构建顺序 `scripts/build_candidate.ps1 -Stage synthesis`、`physical`，核对实际报告；有 hold 违例才执行 `hold`，最终通过后 `bitstream`。
- 不运行复制来的 `save_candidate.py`，其检查点用途沿用原候选。此目录与位流只作诊断，不标为实物成功检查点。

板上反馈尚待采集。诊断逻辑会改变布局与资源，若本版现象改变，需结合错误码、求和与 A/B 判断，不能仅凭显示改善宣称原问题解决。

## 2026-10-08 实物失败反馈

用户确认本位流下载成功（BitWriter日志指定本路径且Downloading succeeded），D3/D2/D1/D0全亮，HDMI无信号并自动黑屏。同供电/接线回载data_d1后图像、声音均正常，四灯也全亮。此版没有得到屏幕诊断读数，不能当作实物通过。

原顶层WAV debug向量在实例连接后才声明，TD有4条critical warnings；LED probe中改为先声明再使用，不能仅凭此缺陷认定无信号根因。PLL/pin/SDC/HDMI PHY与BitGen PLL编码核查一致，无信号具体机制仍待定位。

下一版已在隔离player_fat32_probe构建，去叠字并恢复RGB直通，通过独立四灯观察。参见[probe说明](../player_fat32_probe/README.md)。原位流、日志与DB保留。
