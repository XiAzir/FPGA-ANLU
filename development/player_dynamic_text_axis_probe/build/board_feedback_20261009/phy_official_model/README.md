# 官方 EG ODDR PHY 仿真

目标：对 axis_probe 当前 `hdmi_phy_warpper.v` 与 `lane_lvds_10_1.v` 做边界明确的功能仿真，检查四 lane 的串行位序、clock lane 占空比以及异步复位后的重新启动。该模型结果只描述仿真模型行为，不是板级波形或花屏根因结论。

`run_official_oddr.ps1` 使用工程附带的 Icarus Verilog 12 和 TD 6.2.178840 的官方 `eg_logic_io.v` / `eg_phy_glbl.v`。由于两个官方文件还包含 Icarus 不支持的 `pragma protect` 加密库块，runner 按模块边界从原文件机械抽取可读的完整 `EG_LOGIC_ODDR` 和 `glbl` 模块到本目录临时源文件；ODDR 模块正文未改，`glbl` 保留保护块前的官方可读逻辑。仿真没有使用 serializer_tests 中的简化 ODDR stub。

激励为 25 MHz pixel clock、125 MHz serial clock，依次测试串行相位 0/2/4/6 ns。三路输入按 pixel 周期发送不同、递增且在测试窗口内不重复的 10-bit 字；clock lane 固定为 `10'b1111100000`。在 ODDR 模型边沿延迟稳定后的 500 ps 采样，接受固定预热后以滑窗定位源字，并要求每个 RGB lane 在每次复位周期内都有至少 12 个连续字按 LSB-first 次序匹配，且字索引偏移复位前后相同。clock lane 要求稳定 10-bit 周期、5 个高样本、5 个低样本和两个周期边沿；reset 在首段运行后重新置位。

## 结果

Icarus 运行四个相位均 PASS，每个仿真长 4.3 us：

| 串行相位 | RGB 连续匹配字数（复位前 / 后） | 源字索引偏移 | clock lane | 复位重启 |
|---:|---:|---:|---|---|
| 0 ns | 38/38/38 / 48/48/48 | 1/1/1 | 5:5、10 样本周期、2 个边沿 | PASS |
| 2 ns | 38/38/38 / 48/48/48 | 1/1/1 | 5:5、10 样本周期、2 个边沿 | PASS |
| 4 ns | 38/38/38 / 48/48/48 | 1/1/1 | 5:5、10 样本周期、2 个边沿 | PASS |
| 6 ns | 38/38/38 / 48/48/48 | 1/1/1 | 5:5、10 样本周期、2 个边沿 | PASS |

完整命令输出见同目录 `run.log`。网表、工程 RTL、约束与位流均未修改；此 testbench 只驱动当前 PHY wrapper/lane，不实例化 HDMI encoder/core，也不模拟板级电气或显示器。
