# C11336｜1080p15，仅恢复串行全局时钟路径

此候选基于 C33 的 1920×1080 自定义彩条诊断设计，核心参数为 33MHz 像素时钟、165MHz 串行时钟、2000×1100 总时序；FPGA 仅输出彩条，不包含音频、SD/TF 或视频解码。

唯一功能改动：将 PLL 的 C1 原始 165MHz 输出接入 `EG_LOGIC_BUFG u_hdmi_serial_bufg`，再驱动四条 PHY lane；像素 PLL 参数、PHY、栅格时序、颜色源和约束沿用 C33。版本码为 `00C11336`。原 C33（`00C11333`）源码及已测位流保留在原目录。

- 工程：[AC201_C11336_1080p15_serial_bufg.al](src/td_project/AC201_C11336_1080p15_serial_bufg.al)
- 顶层：[top.v](src/user_source/hdl_source/top.v)
- 构建脚本：[scripts](scripts/)
- 输出位流预期：`build/manual/AC201_C11336_1080p15_serial_bufg.bit`
- 目录本次建立时尚未运行 Tang Dynasty；构建、路由、时序和位流状态以本目录 build/manual 报告为准。

测试目的：检查给串行 PLL 输出补回与 C32 一致的全局时钟缓冲后，显示器是否由无信号转为可识别/稳定；测试时与 640×480 候选分开加载，根代理协调测试顺序。

## 构建结果（2026-10-27）

- Tang Dynasty 6.2.1 SP1（6.2.178.840）独立综合、布局布线、hold修复、STA和bitgen均完成；每步CLI退出码0，PID均已退出。
- 实际资源报告：gclk 2；综合报告在 `build/manual/td_C11336_1080p15_serial_bufg_20261027_114320.log`。
- Routed STA coverage 99.60%；pixel 32.999MHz、serial 165.017MHz；SWNS +1.643ns、STNS 0、hold修复后HWNS +0.024ns、HTNS 0。未建模显示器接收端/cable时序，不能以此替代板测。
- P&R日志有 `PHY-5014` 指向PLL `fbclk[0]` 的 Detail route 提示。该实例选择 `FEEDBK_PATH=VCO_PHASE_0`，`fbclk`接常量0；该输入不在当前内部VCO反馈路径中。保留警告供复核，不把它表述成实际反馈网络断路。
- 位流：[AC201_C11336_1080p15_serial_bufg.bit](build/manual/AC201_C11336_1080p15_serial_bufg.bit)，629,624 bytes，SHA-256 `CA1B412A5D9CB601562282AA33B77B4E018DE9DB2A52B722C6458892CBA2B628`。
- TD阶段实测最大进程内存：综合WS/Private 181.6/165.4MiB；route 501.0/491.6MiB；hold 440.3/437.2MiB；bitgen 431.1/437.8MiB。各日志以 `build/manual/td_C11336_...log` 保存，单独进程均已退出。
- 顶层代码差异限于 `serial_clk_raw`、`EG_LOGIC_BUFG u_hdmi_serial_bufg` 和 ID `00C11336`。C33原项目和已测位流未改。

板测步骤和回退位置见 [ON_BOARD_TEST_C11336.md](ON_BOARD_TEST_C11336.md)。
