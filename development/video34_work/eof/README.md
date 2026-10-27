# JPEG MCU EOF 修正

实现文件仅有：

- `development/player_video34_1080p15/src/user_source/hdl_source/jpeg/jpeg_mcu_id.v`
- `development/player_video34_1080p15/src/user_source/hdl_source/jpeg/jpeg_mcu_proc.v`

`jpeg_mcu_id` 现在按图像几何标记最后真实块：mono/4:4:4 按 8×8 补齐，4:2:0 宽高均按 16×16 MCU 补齐；4:2:0 的 Y-block 栅格宽度也按 MCU 宽度计算。EOF 标志在最后真实块的 EOB 后置位，与 `img_end_i` 到达相位无关，并由 `img_start_i` 清除。

`jpeg_mcu_proc` 在 `outport_blk_space_i` 可用后进入 EOF 状态，发出一次 index 0 的 valid/EOB 样本，之后保持 EOF 等待下一帧开始或复位。`img_start_i` 同时清除 EOF 发送状态与 push。

## 原版对照

保留原版 `jpeg_mcu_id.original.v` 和 `jpeg_mcu_proc.original.v`。原版对照在 16×16、4:2:0 下，让 EOI 在最终 CR 块开始之后到达：最终 CR 的 EOB 后 `end_of_image` 仍为 0；修正版在同一位置置位。`tb_original_eof.v` 还复现了原版 EOF 状态 30 拍内输出 28 个 valid/EOB 样本。

## 回归

从项目根目录使用 PowerShell 编译并运行当前回归：

```powershell
$iv = 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vv = 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
& $iv -g2012 -s tb_mcu_eof -o development/video34_work/eof/tb_mcu_eof.vvp `
  development/video34_work/eof/tb_mcu_eof.v `
  development/player_video34_1080p15/src/user_source/hdl_source/jpeg/jpeg_mcu_id.v `
  development/player_video34_1080p15/src/user_source/hdl_source/jpeg/jpeg_mcu_proc.v
& $vv development/video34_work/eof/tb_mcu_eof.vvp
```

测试覆盖：

- 16×16 4:2:0，EOI 在首块早到与最终 CR start 后晚到：各 6 块后仅结束一次。
- 17×17 4:2:0 边缘补齐：2×2 个 16×16 MCU，共 24 块。
- 16×16 mono 共 4 块，4:4:4 共 12 块。
- 1920×1080 4:2:0 共 48,960 个真实系数块（8,160 MCU×6块）。
- 下一帧 `img_start` 清标志并复位组件序列。
- proc 端块空间低时等待；空间恢复后只发一个 EOF valid/EOB 样本，索引为 0、ID 类型为 EOF；长时间保持 `img_end_i` 高不重复发送；新帧再发 EOF 正常。

实测输出：`GEOMETRY PASS 420=6+6+48960 mono=4 444=12`；`EOF_PROTOCOL PASS single sample/EOB, block-space wait, next frame`。原版首差异测试输出：`BASELINE_FIRST_DIVERGENCE block=5(final CR) end_of_image remains 0 after its EOB`；原版重复 EOF 输出 `samples=28 eobs=28 over 30 cycles`。

测试顶层：`tb_mcu_eof.v`、`tb_original_late.v`、`tb_original_eof.v`。无完整 JPEG 前端/IDCT 系统仿真、TD 构建或板级验证；根代理可在观测队列修复后再运行完整素材回归。
