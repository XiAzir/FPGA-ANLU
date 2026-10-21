# BMP header 字段压缩只读复核

## 输入

- 基线：`E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_resource_fit/src/user_source/hdl_source/tf_bmp_file_player.v`，SHA256 `e902f65baba30712402b3c39cdc9be01adaf66aaf0bdb4c462d205e4ece84642`。
- 候选：`E:/VSCODE-project/FPGA-ANLU/development/resource80_work/bmp/tf_bmp_file_player.header.v`，SHA256 `94543758ef1dfaece9dd6d21aa3e7412cc041f5de2fa4e6c317dedc1eab0f3f2`。

## 复核结论

未发现可达差异。压缩后的字段足以重建原头部判定与诊断 mask；header parser 只在收到相同字节索引时更新，CHECK 等完整扇区后执行，因此粘滞归约标志与原始全宽寄存器判断一致。

- Magic、planes、bpp：候选的逐字节 sticky AND 分别等于 `magic==16'h4d42`、`planes==1`、`bit_count==24`。局部脚本遍历全部 65,536 个 16-bit 值，三项对应关系均通过。
- Compression：四个输入字节分别与零比较并 sticky AND，等价于 32-bit 原值 `compression==0`。
- Width：`width_low` 精确保留原 `width[10:0]`；`width_high_nonzero` 精确归约原 `width[31:11]`。范围检查 `width!=0 && width<=1024`、failure mask 的 width 位均对所有 32-bit width 等价。局部脚本穷举 4,096 个低位/高位归约等价类。
- Height：`height_low` 精确保留原 `height[9:0]`，`height_sign` 是原 bit31，两个 canonical flags 分别编码 bits[30:10] 的 any-one 和 any-zero。正高度只有高位全零时可能通过范围；负高度只有高位全一时可能通过范围；其余分别至少为 1024，必定超出 768。负值绝对值低 10 位满足 `(-raw)[9:0] == (-raw[9:0])[9:0]`，包括 INT_MIN、-769 和 -1024。高度 failure mask 对所有可达等价类通过，脚本覆盖 6,144 类。
- Extent 派生：两边 `source_stride` 均只用 `width[10:0]`；两边 `source_image_bytes` 均只用 `abs_height[9:0]`。候选低位分别精确保留两者，所以 `source_stride`、`source_image_bytes`、33-bit `pixel_end` 完全一致。由此 file extent 的 mask bit 8 与 declared extent 的 bit 9，在任意 raw width/height、pixel offset、file size 和 declared size 下相同，包括高位非法字段的低位回绕情形。Scaler 只会在 header_ok 后启动；通过时 width≤1024 且 abs(height)≤768，传入的零扩展窄值与基线 source_width/source_height 相等。

本地证明脚本：`prove_header_compression.py`；执行结果：`proof_result.json`，状态 PASS。它穷举压缩判定的完整等价类：width 4,096 类、height 6,144 类、16-bit magic/planes/bpp 65,536 值。

主线程先前提供的 538-case RTL 仿真包含 512 个随机 raw32 交叉 mask、六图 1,843,200 像素与 4 个错误保留帧，均通过；本复核未重跑该整套仿真，也未运行 TD 或修改基线/候选。
