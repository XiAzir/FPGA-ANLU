# HEADER_VALIDATED 生产调用域独立审查

结论：按当前 C11315 生产层级，`HEADER_VALIDATED(1)` 的四组被门控检查都由更上层既有约束排除；没有发现宽高截断、尺寸有符号解释、行映射、地址扩展、重新装载或错误优先级的候选引入风险。审查只读，未运行 TD、整图或仿真。

## 审查绑定

- 父 scaler：`development/player_spectrum_spi12p5/src/user_source/hdl_source/bmp_scale_engine.v`，SHA256 `1916CF21F554E64D476D3697973CDBA33F66C0ACEFBDBAB5B48341CBEEA29519`。
- 候选 scaler：`development/opt16_work/small/validated_scaler/c11315/bmp_scale_engine.v`，SHA256 `f3d77c0dcaac1a43c59e30deb51b06988a81a9d91f0c6135f0eb17158057c04c`。
- 父 loader：`development/player_spectrum_spi12p5/src/user_source/hdl_source/tf_bmp_file_player.v`，SHA256 `093c86171d75dd5f9df66da51bbc0830bc391b70b4c5ae627d3bf4d0d8111dc6`。
- 候选 loader：`development/opt16_work/small/validated_scaler/c11315/tf_bmp_file_player_validated.v`，SHA256 `d5f7fdba6c944d62e00c1b92e2084f1b644069b33812bfb5c07d434e260fdbc8`。
- 生产 top 固定 `DISPLAY_WIDTH=640`、`DISPLAY_HEIGHT=480`，并把它们作为 loader/scaler frame 参数传入；候选 loader 的 `CHECK` 也保留 `FRAME_WIDTH<1 || FRAME_HEIGHT<1` 拒绝条件。

两个 RTL 差异范围与 README 所述相符：scaler 增加末尾参数 `HEADER_VALIDATED=0`，仅以其常量门控尺寸、完整 extent、行地址溢出、像素字节地址/文件边界检查；loader 候选改模块名并只在 scaler 实例上传入 `.HEADER_VALIDATED(1)`。`HEADER_VALIDATED` 默认 0 时，原通用调用仍执行四处检查。

## 四组检查与生产契约

1. **S_IDLE 尺寸检查。** 完整 BMP header 先由 loader `HEADER` 逐字节解析；只有 512 字节扇区结束后才进入 `CHECK`。`header_ok` 要求宽 `1..1024`，绝对高 `1..768`，并拒绝零值。调用 scaler 时宽度以 `{5'd0,width_low}` 零扩展，高度以 `{6'd0,abs_height}` 零扩展，且 `height_sign` 单独传 top-down 标志。因此 scaler 的零值、宽高上限检查在被接受的 `scale_start` 上恒为假。

2. **S_SETUP 完整图像范围检查。** loader 与 scaler 都按 `ceil(3*w/4)*4` 形成行 stride；loader 的 `source_stride` 与 scaler 的 `stride` 对任意 `1<=w<=1024` 数值相同。两处图像字节乘积都是 `stride*h`，随后都是33位 `pixel_offset + image_bytes`。loader 的 `header_ok` 在 `CHECK` 先要求 `pixel_end<=file_size`，且 declared size 不小于 pixel_end、也不大于 file_size。故 scaler 的 `image_end>file_size` 不成立。`prove_bmp_extent.py` 对全部786432组 `w=1..1024, h=1..768` 检查最大32位合法 pixel offset 下的乘积/末字节界，结果文件记为 `bmp_extent_proof.json`（PASS）；它补强算术范围，header 接受条件来自 loader `header_ok`。

3. **S_ROW_CHECK 行地址溢出。** `CHECK` 的 `pixel_end<=file_size<=2^32-1` 建立总范围。缩放器只访问 `physical_row<h` 的源行。垂直相位从 `h-1` 开始，每个内容行先重复减 `dh` 并同步递增 `src_bottom`，其第 n 个内容行的 `src_bottom=floor(((n+1)h-1)/dh)`，对 `0<=n<dh` 落在 `[0,h-1]`。上下黑边行不发起源行读取。底向上物理行等于 `src_bottom`，top-down 物理行等于 `h-1-src_bottom`，两种方向都在范围内。因此 `pixel_offset + physical_row*stride <= pixel_end <= file_size`，33位行地址最高位为0。

4. **S_BYTE 地址溢出及 file_size 检查。** 行列读取路径对每个已接受源像素只取 component 0/1/2；`src_col` 从0递增，并在 `src_col+1>=src_w` 后停止，所以 `0<=src_col<w`、`component<=2`。最大RGB字节偏移为 `3*(w-1)+2=3w-1<=stride-1`。任意 `physical_row<h` 时，字节地址不超过 `pixel_offset + h*stride - 1 = pixel_end-1 < file_size`。故33位字节地址溢出与 `byte_address>=file_size` 均不触发。contract include 在实际仿真路径观察源范围、setup端点、行范围/高位及每个BYTE拍的列/component/字节范围，属于动态佐证；几何脚本本身不代替状态机相位证明。

这四项依赖 `CHECK` 成功后才产生 `scale_start`。`CHECK` 失败直接进 `HALT`，WRITE_WAIT/GAP 不产生 start；成功路径在完整 header 与界限检查后才从 GAP 发 start。生产 scaler 输入于 start 采样后至处理结束稳定：文件大小仅在 loader `IDLE` 选择图像时更新，header 字段仅在随后完整 `HEADER` 解析；成功图像完成前不会再次选择新图。错误路径进入 sticky `HALT`，没有不经 reset 的新图重入；reset 同时清 loader/scaler 状态，后续启动仍需新一轮 header 与 CHECK。新图正常重入时 scaler 已回 S_IDLE，loader 再装入并检查下一张图的字段。

## 错误与覆盖边界

候选只改四处范围检查的编译期条件。scaler 的 `file_error` 前置优先级、sector 数据计数与 `card_end` 分支、short/long sector error、S_SECTOR_GAP 与后续状态保持原 RTL；loader 的 HEADER 长度判定、CHECK 失败、尾部 `file_error/watchdog` override 和 HALT 也未改。异常 sector、`file_error` 或 watchdog 不依赖被删范围条件，所以错误优先级不因此参数变化。生产读控制器将每个 sector 的 valid 数据和单独 end 状态分开给出。

README 中列明的 default_13case、valid_domain、diagnostic_538 及6图逐拍/像素回归提供既有验证记录；本次没有重跑它们。`bmp_header_contract.vh` 是被动监视器：不控制 loader/scaler，仅验证 start 时 header 合法且被锁存、S_SETUP/ROW_CHECK/BYTE 的范围。一般直接实例化 scaler 并传非法参数、错误 extent，或改变 frame/source cap 却继续设置 `HEADER_VALIDATED=1` 的调用不属于本生产证明；这也是默认 0 保留的原因。当前 C11315 loader 显式 MAX_SOURCE_WIDTH=1024、MAX_SOURCE_HEIGHT=768，与 header 验证边界一致。

审查依据：[候选说明与回归记录](../small/validated_scaler/c11315/README.md)、[`prove_bmp_extent.py`](../prove_bmp_extent.py)、[`bmp_header_contract.vh`](../bmp_header_contract.vh)。


