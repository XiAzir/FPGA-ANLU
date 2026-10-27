# 1080p彩条像素源与 C33 诊断位流

当前 `build/manual/AC201_video33_1080p15_diag.bit` 是独立 1080p15 兼容性诊断候选，C33 固定构建码为 `00C11333`。上板步骤、PLL频率与最终STA报告见 [ON_BOARD_TEST_C33.md](ON_BOARD_TEST_C33.md)。

源码包括 1920×1080 彩条时序源、AXIS适配器、HDMI 1.4b Core/PHY和EG4 PLL配置。无SDRAM/TF媒体链及音频。

- `src/video_timing_1080p30_colorbar.v`：原始30Hz纯像素源参考。
- `src/video_timing_1080p_custom_colorbar.v`：可参数化时序源；C33实例使用2000×1100总时序。
- `simulation/tb_video_timing_1080p15.sv`：整帧总像素、有效区、消隐、同步和AXIS行帧标记检查。
- `simulation/tb_video_pll.sv`：TD EG4 PLL模型频率测量。
- `scripts/build_manual_syn.tcl`、`build_manual_phy.tcl`、`fix_hold.tcl`、`generate_bit.tcl`：C33顺序构建入口。

HDMI Core受保护实现未能由本机ModelSim仿真；显示器对15Hz自定义模式的接受情况尚未实测。
