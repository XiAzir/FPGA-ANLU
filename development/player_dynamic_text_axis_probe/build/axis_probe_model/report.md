# AXI 视频输入观察器模型报告

结果：PASS。由指定 Icarus Verilog 12 工具链编译并运行 `sim/axis_probe/tb_axis_probe.v`。

覆盖范围：实际工程 `color_bar`、`video_timing_data`、`video_delay` 与旧版 `video_rgb_to_axis_640x480` 串接，SDRAM 像素读取由递增 RGB 驱动替代；运行多帧连续链并核对 640×480、420000 周期、307200 有效像素、TLAST 观测为 0、160 周期行间 blank、零错误计数及状态位。小参数用例覆盖短行、帧像素/行/周期异常、非法 USER、USER 行中分隔、首帧不误判、SOF ready 低、TLAST 计数、复位重启和 12 位饱和。

边界：该模型验证 RTL 的输入观测和计数语义；像素源已替代 SDRAM，不包含 HDMI 加密核或板级时钟/供电，不能据此断言实板黑屏根因或恢复。旧转换器本身已知没有发出 TLAST，本 observer 只报告观察值，不据此增加坏帧判断。复位后保留转换器约 40 拍启动边界。

接口：`flags={locked,locked_ever,valid_seen,user_seen}`；`dims={last_line_width[11:0],last_complete_frame_rows[11:0]}`；`frame_period`、`frame_pixels`、`bad_counts={bad_line,bad_frame}`、`gap_ready={intra_frame_blank,valid_not_ready}`、`frame_last_count`、`user_frames={bad_user,valid_user_frames}`。所有观察输入均为被动输入。

可复现命令：`pwsh -NoProfile -File scripts/run_axis_probe_model.ps1`。完整参数见 `build/axis_probe_model/command_args.json`，源 SHA-256 绑定见 `build/axis_probe_model/source_bindings.json`，终端输出见 `build/axis_probe_model/run.log`。
