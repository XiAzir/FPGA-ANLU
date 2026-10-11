# HDMI 包观测模块功能仿真

`../src/user_source/hdl_source/hdmi_packet_monitor.v` 是只读诊断功能模型。输入来自 transmitter core 的三路并行 TMDS 字符，位于 PHY wrapper 反转和串化之前；模块没有播放链路输出端口。尚未综合、时序评估或上板验证。

运行 `./run_monitor_tests.ps1` 会先执行 `verify_audio_packet_vector.py`。脚本用独立 reflected LFSR（右移，反馈多项式 `0x83`）复算给定 JSON 的 BCH，再独立检查 32 组三路字符并写 `audio_packet_vector.mem`；随后由 Icarus 编译并运行 directed testbench，结果保存到 `test_result.txt`。

当前向量检查结果：header BCH `D0`，四个 body BCH `96/4D/BE/D1`。定向仿真通过 31 项断言，包含：JSON 向量、tone ±1,000,000、layout-0 present/flat 分类、同岛连续多个 packet、ACR CTS=25000/N=6144、header/data/parity BCH 错误各包计一次、非法 TERC 中断后由新 preamble/guard 重同步、错误 guard、非岛输入不误触发，以及终端秒窗拍上的 packet 事件并入本窗输出。追加核对非法ch0 preamble、ACR HB1/HB2忽略、CTS=0保留、absent子包flat位忽略、65535饱和不回绕、末data/parity位错误。当前窗口及输出计数16位饱和，上层24位端口高8位固定0；header/body只存有效payload，在线BCH持续检查。

仿真不代表 TD 综合、STA、物理 TMDS PHY 或显示器/线缆结果。`tone_bad_sec` 是每秒窗口计数，不是 sticky 结论；切换到 tone 后，FIFO/bridge 中残留的旧 WAV 样本可能进入第一个窗口。实板判读时等输入模式稳定数秒，并结合后续窗口，不应把切源后的第一窗直接当成持续 tone 错误。
