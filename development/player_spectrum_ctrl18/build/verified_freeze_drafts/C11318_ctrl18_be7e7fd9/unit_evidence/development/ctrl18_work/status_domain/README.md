# status display clock-domain candidate

记录时间：2026-10-21 14:32（北京时间）  
状态：独立候选与 Icarus 验证完成；等待 root 集成与统一安排 TD 验证。

## 候选内容

- [status_hex595.v](status_hex595.v) 是基线驱动器的隔离副本，RTL 未改，SHA-256 与基线相同。顶层实例把时钟与 `hex_value` 改接 `video_clk` / `status_hex`，并显式设 `CLK_HZ(25000000)`。
- [top_tf_hdmi_audio_candidate.v](top_tf_hdmi_audio_candidate.v) 是只在本目录保存的完整 top 副本。它与基线 top 只有 status 输出这段连接不同。
- [top_status_patch.diff](top_status_patch.diff) 是针对当前基线 top 的标准 diff；`git apply --check` 已通过，尚未应用到正式候选。
- `player_status_mailbox` 顶层实例及其 `status_hex_system` 总线退出候选 top。`player_status_monitor` 内部用于 pixel 采样与 negedge status 域交接的 mailbox、`status_reset_pipe` 和复位输入均保留。

按 mailbox RTL 结构计，它包含 64 个数据寄存器（held/destination 两组 32 bit）及 6 个 toggle/同步寄存器；顶层退役后这些状态不再实例化。实际综合 FF/LUT 差值仍以 TD 结果为准。

正式工程中的 `status_clk` 已经连到 `video_clk`，因此驱动器与 status 页面寄存器由同一像素时钟驱动。页面寄存器在下降沿更新，595 在上升沿采样；两个边沿之间保留半周期。测试包含页面刚更新后开始 digit-zero 帧锁存的对齐场景。

## Icarus 验证

可在本目录运行：

```powershell
pwsh -File .\run_tests.ps1
```

使用工程内 Icarus Verilog 12.0 development build：
`bringup/tf_wav_hdmi/tools/iverilog/app/bin/{iverilog.exe,vvp.exe}`。
复跑日志与 `.vvp` 文件位于 [build](build/)；三组仿真均以 `$finish` 正常结束。

`tb_status_domain` 在 0 ns 与 10 ns 两种 25 MHz/50 MHz 相位关系下，将候选 25 MHz 驱动和原 50 MHz 驱动连到 74HC595 接收端解码器。它逐个接收 SCLK 上的 16 bit 字，在 RCLK 上检查 blank `16'hFF00` 先于 data，并检查每个 digit 的段码、位选和顺序。`01234567` 与 `89ABCDEF` 覆盖 0–F 十六种字形和 8 位扫描；在 digit 3 已输出后更新输入，当前 8 位帧仍使用 digit-zero 锁存值。测试随后在 SCLK 高期间异步置位 reset，检查 DIO/SCLK/RCLK 复位电平及新帧恢复。两种相位下全部通过。

`tb_page_update_collision` 实例化原 `player_status_monitor`，把页面计数参数缩短以加快仿真，并让页面在 digit-zero 帧开始前半周期更新。候选输出该帧的 `88888888`，整帧期间 status bus 改变 90,971 次；接收端仍逐位解出单一帧快照，全部通过。

仿真范围是状态驱动、mailbox/直接连接对照、串行接收端解码、复位与时序量测。它没有覆盖综合、TD 时序、实际板卡或 74HC595 的器件绝对时序规格。

## 实测边沿和刷新

计数表达式来自原 RTL：`HALF_DIV_RAW=(CLK_HZ+1999999)/2000000`。基线 50 MHz 得 25 个计数周期；候选 25 MHz 得 13 个计数周期。FSM 中 `ST_SHIFT_SET` 在每个常规位间增加一个时钟周期，所以 bit 内 SCLK 低电平还包含该状态的一个周期。

| 接收端测量 | 50 MHz 基线 | 25 MHz 候选 | 差值 |
| --- | ---: | ---: | ---: |
| SCLK 高脉宽 | 500 ns | 520 ns | +20 ns |
| SCLK 位间低脉宽 | 520 ns | 560 ns | +40 ns |
| 位内上升沿周期 | 1,020 ns | 1,080 ns | +60 ns |
| 位内 SCLK 频率 | 980.392 kHz | 925.926 kHz | −5.56% |
| DIO 至采样上升沿最小间隔 | 500 ns | 520 ns | +20 ns |
| RCLK 高脉宽 | 20 ns | 40 ns | +20 ns |
| blank RCLK 到 data RCLK | 16,360 ns | 17,360 ns | +1,000 ns |
| blank RCLK 到下一 digit blank RCLK | 1,032,720 ns | 1,034,720 ns | +2,000 ns |
| 8 位完整帧周期 | 8.261760 ms | 8.277760 ms | +16 µs |
| 8 位帧刷新率 | 121.040 Hz | 120.806 Hz | −0.193% |

表内纳秒值来自两个时钟相位仿真的 SCLK/RCLK 接收端测量。周期统计排除字与字之间的空闲低电平，只统计 16 bit 字内位间边沿。帧周期来自接收端完整帧事件时间戳。

电气 pin、active-low 字形、位选顺序、blank → data → latch 顺序和 digit-zero 整帧锁存均保持。候选的 DIO 建立间隔、高/低 SCLK 脉宽与 RCLK 高脉宽都不短于基线测值；因此相对基线的数字窗口保持或扩大。本记录不引用外部规格，也不推断绝对器件裕量。串行时钟频率下降约 5.56%，而完整 8 位帧刷新率仅下降约 0.193%，因为每 digit 的 1 ms slot 等待仍由 25 MHz / 1000 精确得到。

## 源文件指纹

SHA-256 明细见 [source_sha256.txt](source_sha256.txt)。候选 `status_hex595.v` 与基线同为 `AFF2A8B7EB9CCB6D5E2785728DCE86BD8E87C4A96F33C20FA4B08FDC151852B9`。顶层候选副本的哈希为 `7B5ABA478DC3B998022A06889E05557D66C474F3E291F5EA368616E83F4E50D0`；基线四个输入源哈希也列在文件中。

## 集成步骤

1. 在正式候选中核对 top 与本记录基线的 SHA，再应用 `top_status_patch.diff`。
2. 保留 `status_hex595.v` 原 RTL；确认实例参数为 `CLK_HZ(25000000)`、时钟为 `video_clk`、数值总线为 `status_hex`。
3. 从 top 移除 `status_hex_system` 与 `u_status_mailbox`。模块源文件仅在 TD 工程明确列入且无其他实例时再从工程 source list 清理。
4. 保留 `player_status_monitor` 内部跨采样/页面寄存器交接及 status reset 管线，核对现有三根 segment IO 约束未变。
5. 由 root 统一安排最多两个 TD build，对比 Slice/FF、setup/hold、三根 IO pin 与顶层门级路径；完成后再决定是否进入正式候选。当前未运行 TD、未改正式源、未生成 bit、未操作板卡。
