# C11315 BMP scaler validated-domain candidate

状态：Icarus 定向回归、六图 C11315 配对回归与 TD A1/A2 均已完成。

## 源绑定

- 基线 scaler 来自生产 C11315 `bmp_scale_engine.v`，SHA256 `1916cf21f554e64d476d3697973cdba33f66c0acefbdbab5b48341cbeea29519`。
- 生产 loader 来自 `tf_bmp_file_player.v`，SHA256 `093c86171d75dd5f9df66da51bbc0830bc391b70b4c5ae627d3bf4d0d8111dc6`。
- 候选 [bmp_scale_engine.v](bmp_scale_engine.v) SHA256 `f3d77c0dcaac1a43c59e30deb51b06988a81a9d91f0c6135f0eb17158057c04c`。只新增默认值为 0 的 `HEADER_VALIDATED` 参数，并门控 S_IDLE 的尺寸检查、S_SETUP 的完整 extent 检查、S_ROW_CHECK 的 33 位行地址溢出检查、S_BYTE 的地址溢出及 file_size 检查。参数为 0 时通用语义与原 scaler 相同；参数为 1 时这些常量条件在编译期消去。
- 候选 loader [tf_bmp_file_player_validated.v](tf_bmp_file_player_validated.v) SHA256 `d5f7fdba6c944d62e00c1b92e2084f1b644069b33812bfb5c07d434e260fdbc8`，唯一功能差异是在 `u_scale` 上显式传入 `.HEADER_VALIDATED(1)`。
- 输入哈希与副本 SHA 在 [source_receipt.json](source_receipt.json)。

## 生产域不变量

1. `tf_bmp_file_player.CHECK` 仅在宽度 `1..1024`、绝对高度 `1..768`、像素偏移与 DIB 边界合法、格式为 24-bit BI_RGB 且 `pixel_end <= file_size` 与 `declared_size >= pixel_end` 时通过。其后才经过 WRITE_WAIT/GAP 发出 `scale_start`。
2. `source_width`、`source_height`、`pixel_offset`、`file_size` 在该次 HEADER 完成后的 CHECK 至 payload 结束期间保持稳定。新图字段只在前一张结束并回到 IDLE 后重新解析。复位同时清除 loader/scaler 状态；复位后的 scaler start 仍由新一轮完整 HEADER/CHECK 产生。正常完成回到 S_IDLE，下一次 start 同样来自下一张已检查的头。
3. `stride = ceil(3w/4)*4`，故 `stride >= 3w`。`src_col` 在 S_ROW_CHECK 置 0；每个像素按 component `0,1,2` 读取，只有 component 2 完成后才把列号加一；列检查在 `src_col+1 >= src_w` 停止。因此有效访问满足 `0 <= src_col < w <= 1024` 且 `component <= 2`。
4. 输出内容区至多 `dh` 行。Y 相位初值 `src_h-1`；每个内容行加 `src_h` 并反复减 `dh`。第 `n` 行累计增量后 `src_bottom=floor(((n+1)*src_h-1)/dh)`，对 `0<=n<dh` 有 `0<=src_bottom<src_h`。底向上 `physical_row=src_bottom`；顶向下 `physical_row=src_h-1-src_bottom`；两者都落在 `[0,src_h-1]`。letterbox 行不访问源行。S_SETUP 中的 `image_bytes` 仍使用完整 `src_h`，不依赖起始 `physical_row`。
5. 一个像素内最大字节偏移为 `3*(w-1)+2 = 3w-1 <= stride-1`。对 `r=physical_row<h`，`byte_address <= pixel_offset+r*stride+3w-1 <= pixel_offset+(r+1)*stride-1 <= pixel_offset+h*stride-1 < pixel_end <= file_size`。因此 row address 与每个 RGB byte address 均无 33 位溢出、也小于 file_size，覆盖 S_ROW_CHECK 与 S_BYTE 两组诊断。

该证明限定在生产 loader 的已验证调用域。直接对 scaler 传非法尺寸或错误 extent 且 `HEADER_VALIDATED=1` 属域外；可复用通用行为时保持默认 0。

## 已完成测试

- `default_13case`：Icarus 基线 C11315 对候选 `HEADER_VALIDATED=0`，7 组尺寸/方向合法图 + 6 种非法/传输故障，逐拍比较输出与关键寄存器；`BMP_EQUIV PASS valid=7 errors=6`。
- `valid_domain`：C11315 基线对参数 1 候选，7 个合法尺寸边界组合逐拍比较；`BMP_C11315_VALIDATED PASS valid=7`。
- `diagnostic_538`：生产 C11315 loader 与候选 loader 并行；538 项 header 失败诊断、error/状态/public 输出逐拍相同，含 529 个 header masks、512 个随机 32 位原始头、短/长 sector、mapper/watchdog、sticky error、reset 和 valid commit；`BMP_FAILURE_DETAIL PASS cases=538`。
- 六图完整 loader 回归：Icarus 配对 testbench 通过，六组 baseline/validated loader 各自逐像素匹配 golden，累计 1,843,200 pixels；每拍比较 160 位 loader 可观察输出均相同。结果见 `full_paired_run.log`，Icarus stderr 为空；仿真于 86,204,775 ns 正常 `$finish`。

## TD A1/A2

由 [prepare_td.py](prepare_td.py) 生成并已顺序执行：

- A1：同一候选 scaler RTL（`HEADER_VALIDATED` 默认 0）+ 原 C11315 loader。
- A2：同一 scaler RTL + 只在生产 loader 调用点设置 `HEADER_VALIDATED(1)` 的副本。
- 两者同 EG4S20BG256、同 20 ns SDC、同 AreaHigh 参数 `add_map_lut_struct=high`、`map_mode=area_prior`、`multi_thread_mapping=partition`、`resource_sharing=auto`、`shifter_style=shifter_reg`、`min_ripple_len=18`、`mapper_lut_delay=1600`。
- A1 报告：1365 generic LUT、2064 device LUT、699 REG、4 BRAM、6 DSP。A2 报告：1290 generic LUT、1868 device LUT、698 REG、4 BRAM、5 DSP；变化为 −75 generic LUT、−196 device LUT、−1 REG、−1 DSP。
- 工程、Tcl、报告与源 SHA manifest 在 `td/A1_base`、`td/A2_validated` 与 [td_manifest.json](td_manifest.json)。TD 6.2.1_SP1，目标 EG4S20BG256，两个独立综合进程顺序执行，使用相同 20 ns SDC 与回读参数。

Root-share 版本的早期试验保存在父目录 `../README.md` 与父目录源副本中；该版本含 row-seed/shared-image-bytes 改动，最终比较以本目录的 C11315 原始源绑定为准。
