# C11310 HDMI 无信号 / O_video_locked 审计

日期：2026-10-14。静态核查、RTL contract 仿真及原加密 wrapper 动态集成仿真；未改生产源、检查点、位流或发布包，未运行 TD、未操作板卡。

## 结论

- AXIS 转换器有确定的共享 TLAST off-by-one 缺陷：640 像素/行时末像素前的旧计数为 638，行结束后不会再比较 639。现有两帧 640×480 仿真记录 614400 VALID、2 SOF、0 TLAST、960 EOL 错误（axis_before.log）。
- C11310 gate 中 O_video_locked_reg DFF 的下一状态已按 LUT5 INIT 32'hffb0b0b0 枚举全部 32 种输入，得到 locked_next = (axis_s_user && source_pause) || (locked && (de_prev || !source_sol))。置位、保持、清零的逐项说明、pause 方程、计数/几何标记上游和限制见同目录 video_lock_control_cone.md。网表主段为第 182475–182489 行；C11309 相应第 182797–182811 行，连接同形。
- 可见锁定位清零方程中没有 TLAST：行尾缺失不能通过该直接状态 D 锥直接清锁；但它可能经加密接收器 FIFO、pause/SOF/SOL或其他内部状态间接影响核，现有局部锥不排除这些路径。
- C11310/C11309/C11206 compact_data_d1_verified 的 converter 哈希一致，C11310/C11309 HDMI wrapper 哈希一致。C11309 曾有总体音画正常、仅频谱空的用户反馈，与共享 TLAST 缺陷并存，降低其单独解释 C11310 新无信号的可信度；反馈未独立确认板上 build ID，不能作为完整协议或核状态证明。
- HDMI 核源代码受保护。局部可见 RTL 方程可写纯布尔状态回归，但不能单独模拟完整 HDMI 锁定、FIFO、接收端或 C11310 板上无信号根因。

## 后续

本机原加密 wrapper 动态集成结果：25 MHz/40 ns，top一致的800×525、640×480 active，接入真实 timing/color_bar/video_delay/converter，音频/ACR固定0，复位20拍后释放。运行约3完整帧，接受921600拍、3 SOF、0 TLAST、0 ready stall、最长连续valid640，末态 locked=1。模型日志含protected-region与FIFO宽度警告；本结果证明这条规范输入序列下lock可达、TLAST缺失并未阻止lock，不替代routed/实板电气验证。板端根因仍未确定；继续实板记录握手、reset、locked与TMDS输出。

## 2026-10-14 原加密 HDMI wrapper 动态仿真补充

- 使用 ModelSim SE-64 10.1c 独立 work 库，编译 C11310 原始 encrypted wrapper、`video_timing_data`、`color_bar`（`VIDEO_640_480`）、`video_delay`、`video_rgb_to_axis_640x480` 和 testbench；未改生产源。日志位于同目录 `video_modelsim/compile_core_retry2.log` 与 `video_modelsim/core_console_retry2.log`。
- 25 MHz / 40 ns 像素时钟；wrapper 参数照 top 的 800×525 / active 640×480 / VIC 1 / RGB / VIDEO_TPG Disable；48K音频与 ACR 输入固定为 0。复位高 20 拍后释放，属快速启动仿真。
- 结果：`frames=4` 的 VS 边沿观测终点，期间接收 921,600 拍（3×640×480）、3 SOF、0 TLAST、0 ready stall、最长连续 valid 640，结束时 `locked=1`。未在有效行中施加背压。
- 结论：在本机原加密 wrapper 仿真及真实 640×480 上游 RTL 输入下，规范连续视频可使 `O_video_locked` 拉高，且 TLAST 缺失未阻止 lock；因此 TLAST 不是该仿真条件下阻止 lock 的充分原因，不能据此将其单独定为实板故障根因。模型日志含 protected 区与 FIFO 端口宽度警告；结果不替代 routed/整机/板端电气验证。
