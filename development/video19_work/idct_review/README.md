# JPEG Core Area / Arithmetic Review

日期：2026-10-21（北京时间）。本目录仅保存 A08 派生的独立候选和审查证据；未修改 `player_video19` live 源、A08 冻结源或 vendor 源。

## 量化结果

TD 6.2.1 SP1、EG4S20BG256、50 MHz SDC、AreaHigh、`max_dsp=17`。`A08base` 与候选使用相同工程设置、同一完整 core source set；仅列出的候选源文件发生变化。

| Variant | 唯一改动 | Device LUT | FF (gate area) | Slices | BRAM9K | DSP | Setup WNS | Setup TNS / endpoints |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| A08base | A08 控制组 | 6504 | 2905 | 1306 | 17 | 13 | -1000 ps | -10176 ps / 16 |
| CSD | 三个 YCbCr shift-add 系数改成 CSD | 6382 | 2905 | 1245 | 17 | 13 | -791 ps | -6328 ps / 8 |
| OUT17 | 输出 Y/Cb/Cr RAM 由 32 位存储改为 17 位存储并符号扩展 | 6434 | 2861 | 1180 | 14 | 13 | -2323 ps | -48904 ps / 24 |
| OUT17_X21_BR0 | OUT17 + transpose RAM 32→21 位，bank0 恢复 BRAM | 6291 | 2825 | 1146 | 16 | 13 | -4330 ps | -59352 ps / 24 |

CSD 相对 A08 减少 122 device LUT、61 slices；`u_jpeg_output` 层级从 998 LUT/431 ripple 降至 937 LUT/370 ripple。它改善该次综合的 setup WNS 209 ps，但绝对时序仍为负。

OUT17 相对 A08 减少 126 slices、3 BRAM9K；device LUT 减少70，generic LUT cells由3124升至3248。该变体的 setup WNS 明显恶化至-2323 ps，面积收益仍伴随显著时序风险。Gate QoR 是综合估算，未进行完整整机 PNR 或 STA。

OUT17_X21_BR0 相对 OUT17 减少 34 slices、143 device LUT、34 FF（gate area report）和8 QoR registers，同时增加2 BRAM9K；相对 A08 总计为16 BRAM9K和1146 slices。其 setup WNS进一步下降至-4330 ps、24个 setup 端点违例。该变体只显示存储位宽/实现映射方向的资源机会，时序估算需要后续结构化修复后再评估。

## CSD 等价与像素对照

A08 原输出算术在 `td/candidate_src/A08/jpeg_output.v`。隔离 CSD 源只改 `idct_review/candidate_src/CSD/jpeg_output.v` 的三个 32 位 signed product：

| 系数整数 | A08 项数 | CSD 表达式 | CSD 项数 |
| ---: | ---: | --- | ---: |
| 5743 | 9 | `4096 + 2048 - 512 + 128 - 16 - 1` | 6 |
| 2925 | 8 | `4096 - 1024 - 128 - 16 - 4 + 1` | 6 |
| 1410 | 4 | `1024 + 256 + 128 + 2` | 4 |
| 7258 | 7 | `8192 - 1024 + 128 - 32 - 8 + 2` | 6 |

各 shift/add/sub 节点均保持 32 位 signed 运算；两侧按 2^32 取低位的结果相同，后续 `>>>12` 的输入位型完全一致，故对任意 32 位 Cb/Cr 输入等价。系数乘数源 SHA256：A08 `jpeg_output.v` `63d853a348515bcf66ddf27d8dbf8d8483ab7e97b95a37a9e565fe1b2f2cdd0e`；CSD `583cd898cb4a2db5d049557663ff36e8fd3da4fdcfda5011ba5cd58953ea5596`。

原生 Icarus Verilog 12.0、`-g2012`：

- 640×480 frame_000：307200 pixels，坐标唯一且无范围错误；候选与 A08 的原始像素记录 SHA256 均为 `a4d4b3b4b86a23831d06d4b3051dd4c9486b2141ebc4e5c62d67a605a9000440`。输入 JPEG SHA256 `27a5a40d877c08fca9876c1b3d768bedfcdd24978bc057fa51c452239f00fef0`。
- 64×64 frame_000_center64_q95，随机 output backpressure seed 1003：4096 pixels、1052 stalls、hold errors 0、duplicate/out-of-range 0；候选与 A08 像素记录 SHA256 均为 `ce0c87c4ac2d09df0bda67d7576245c367d5f6c9949a286abfc000b594b4af09`。输入 JPEG SHA256 `d525027d70e6f5f55cc205a248e0cc1d600636eeb666fe3efd8d9fe12a4ea89e`。

像素日志/记录：`runs/CSD_frame_000/`、`runs/CSD_micro_64_bp/`；TD 报告：`td/A08base/`、`td/CSD/`。

## 17 位输出缓存候选

`jpeg_idct_y.v` 的 `block_out` 在最终出口执行 signed 32-bit `>>> OUT_SHIFT`，y stage 默认 `OUT_SHIFT=15`；任意 signed 32-bit 值算术右移15位均落入 `[-65536, 65535]`，即 signed 17-bit。输出数据经 `jpeg_idct` 送至 `jpeg_output` 的 Y/Cb/Cr 缓存。OUT17 仅将 `jpeg_output_y_ram_ram_dp_512_9` 与 `jpeg_output_cx_ram_ram_dp_256_8` 内部 RAM/读寄存器宽度改为17，写入低17位，读出按bit16符号扩展回原32位接口；模块接口与RGB转换算术保持不变。

OUT17 的 frame_000 全帧记录与 A08 SHA 完全相同；同一 64×64随机背压用例亦逐字节相同（4096 pixels、1052 stalls、0 hold errors）。TD 的输出缓存由6 BRAM9K降到3，core总BRAM由17降至14。RAM文件 SHA256：`jpeg_output_y_ram.v` `4ea4afeed9909b6ea509a42d20778375b76c0827b68b7a811b985d1256cf951b`；`jpeg_output_cx_ram.v` `d82bbc1fbf0af82b4af951637f30954268571b4f881304b55b7f4c1fde9a0250`。日志/记录：`runs/OUT17_frame_000/`、`runs/OUT17_micro_64_bp/`；TD 报告：`td/OUT17/`。

该推导依赖 IDCT y-stage 的实际输出移位和当前 JPEG core 数据通路；整机集成仍需重跑文件/图像/背压场景并做正式时序验证。area-only gate QoR 的负时序数字需保留为风险。

## 21 位 transpose 候选

IDCT x-stage 的 `block_out` 在 `>>> OUT_SHIFT` 后输出，实例默认 `OUT_SHIFT=11`。任何 signed 32-bit 被算术右移11位的值均可由 signed 21-bit 表示。候选因此把 transpose 的4个 `32x32` data RAM/同步读寄存器改为21位存储、读出按bit20符号扩展；实例 `u_ram0` 从逻辑RAM模块换成同接口BRAM RAM模块。输入到 transpose 的索引、双口读写时序和32位模块端口均保持。

原生 Icarus 全帧307200像素与A08像素记录SHA完全一致，64×64随机背压4096像素与A08 SHA一致，1052 stalls、0 hold errors。TD相对OUT17新增2 BRAM、再减34 slices；core总计16 BRAM/1146 slices。Setup WNS -4.330 ns，24违例端点；该QoR尚不构成可集成时序结论。相关源SHA256：`jpeg_idct_transpose.v` `4b765d2227366e6cfd7953f0f17de3fbbd9f1bf2f55e8207bd5611a96a21e54c`；`jpeg_idct_transpose_ram.v` `308e4b0791ee562ca87c7fc923d34f0aff51064d188fea703a1bbf94903be45e`；`jpeg_idct_transpose_logic_ram.v` `a16652de7d26c822993f2abf62307c0ae15f62f96cc821f52f6fb33c02d22d38`。日志/像素记录见`runs/OUT17_X21_BR0_frame_000/`、`runs/OUT17_X21_BR0_micro_64_bp/`；TD报告见`td/OUT17_X21_BR0/`。

## 其他数学审查点

- IDCT x-stage 的原始块入口为 signed 16-bit；`jpeg_idct_x.v` 中 `i0 = block_in_0_1 +/- block_in_4_5` 因而为 signed 17-bit。乘以 `C4_16=2896` 的绝对上界为 `65536*2896=189792256`，适合 signed 29-bit 中间值。只在 x-stage 对 C4 的输入/移位加法结果收窄可省少量寄存器/加法宽度；尚未生成或综合候选。
- x-stage block 输出在 `>>>11` 后必为 signed 21-bit，可作为 y-stage 输入范围依据。完整内部 IDCT y-stage C4 乘积可能发生 32-bit wrap；尚未给出比现有 32-bit 更窄且全合同成立的中间界，故不建议直接裁宽 y-stage 算术。
- 两轴 `181/256` 对 signed 32-bit 使用除法向零截断。直接 `>>>8` 对负的非整除输入不同；全输入等价形式为 `((x + (x[31] ? 255 : 0)) >>> 8)`，其中加法不发生 signed 32-bit 溢出。既有 `td/arithmetic_equiv_result.json` 对 100009 个包含 wrap、负数、边界值的向量验证了 181/256 表达式；常数除法在综合器内可能已优化，此处未单独做 TD 消融，面积收益未知。
- `jpeg_output_y_ram.v` 和 `jpeg_output_cx_ram.v` 的 FIFO level `count_q/count_r` 为32位；端口分别受 `jpeg_output.v` 的384/128水位线控制，计数宽度值得独立验证。若改成窄计数器，须在 TB 中检查 threshold bypass、EOF inflight、push/pop 同拍与回绕边界；本轮未改。

## 复跑

原生像素 TB 为 `jpeg_unit/tb_jpeg_core.sv`；编译后按 `runs/*/sim.log` 中的 fixture、mode、seed 和维度参数运行 `vvp`，像素文件为7-byte little-endian `(x,y,r,g,b)`记录。TD 工程由各目录的 `td/*/run_syn.tcl` 使用，需从 Tcl 工具传入正斜杠绝对路径，以免 Windows 反斜线被 Tcl 解释为转义。

