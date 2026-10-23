# C28 图片 loader/scaler Icarus 回归

本目录比较 `player_video27_command_boundary`（C27）与 `player_video28_hdmi_observe`（C28）的 BMP loader/scaler。测试只编译这两个目录中的 `tf_bmp_file_player.v`、`bmp_scale_engine.v` 和本目录 testbench；两版按相同确定性刺激分别运行。C28 另外逐周期检查被动 `debug_progress={state[4:0],y[8:0],x[9:0]}` 编码。

testbench 校验完整 640×480 输出帧的每个 RGB 像素、ready 停顿期间的像素保持、有限 `write_ready` 停顿、带字节间隙的 512-byte sector response、错误状态和扇区读取计数。输入为按行列生成的非均匀 BGR24 BMP。没有生成 VCD。

## 运行

在工程根目录以 PowerShell 7 执行：

```powershell
./development/video28_work/photo_regression/run_photo_regression.ps1
```

脚本通过 `scripts/anlu_tools.ps1` 解析 Icarus 工具，生成四次仿真日志、临时 `.vvp` 镜像和 `summary.json`。任一像素、周期统计、CRC 或请求计数不符都会以非零错误终止。

## 结果

两种输入几何（16×16 和 640×480）下，C27 与 C28 的 307200 个输出像素均逐点匹配预期，像素 CRC 和 cycle CRC 也逐周期相同。完整交付图几何的文件大小为 921654 bytes，其中 header 54 bytes、像素载荷 921600 bytes；载荷访问 sector 0..1800 共 1801 次，另有 header sector 0 读取一次，合计 1802 次。ready 停顿期间内部 `scale_pixel_valid` 与 RGB 保持稳定。

| 输入 | C27/C28 cycles | 写像素 | sector reads | ready stall cycles | pixel CRC | cycle CRC |
| --- | ---: | ---: | ---: | ---: | --- | --- |
| 16×16，缩放至 640×480 | 3,434,692 | 307,200 | 3 | 76,827 | `e6d3bbc5` | `3cc39ad5` |
| 640×480 交付图几何 | 7,358,547 | 307,200 | 1,802 | 77,597 | `d4300dc5` | `b0ba89e0` |

本机交付备份 `development/player_bmp_scale/build/delivery/TF_ROOT/SCALE1.BMP` 的头部已只读核对：230454 bytes，声明大小 230454，像素 offset 54，320×240，24-bit BI_RGB。该文件元数据见 `summary.json`。640×480 用例覆盖的是交付备用图/目标几何；目前现场 TF 首图头部仍未核验，本用例不表征 TF 实际输入几何。

本次只完成 RTL 功能级 Icarus 仿真；未覆盖 TD 综合、ModelSim、整机 TF、显示端或板上时序验证。
