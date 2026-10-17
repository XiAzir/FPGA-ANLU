# C11307 / C11309 FFT 与 renderer BRAM 静态审计

日期：2026-10-14（北京时间）  
范围：只读比较 `player_spectrum_observed`（C11307）与 `player_spectrum_clock_route`（C11309）的频谱分析器/柱形渲染器 RTL，以及两版 TD gate 和 routed Verilog 中相关 `EG_PHY_BRAM` 参数、时钟、使能、地址和数据端口。未运行 TD、未仿真受保护库、未改 RTL/位流/ZIP、未操作硬件。

## 现场证据

C11309 反馈记录为用户报告：“一切正常，除了频谱图没东西显示。有声音。”照片显示干净的图像/OSD、`SPECTRUM WAV`、无柱形；照片状态 `IMG2/4 MANUAL`，版本号不能独立辨认。独立 DFC11309、内置 tone 频谱结果及 B/C 页数值均待补。因此当前只证明 WAV 场景出现空频谱的用户反馈，不证明 tone 也空，也不能判断 FFT 是否已完成。

## 结论

- 两版 `player_spectrum_analyzer.v` SHA256 均为 `AD4425806607C0A24634F38DD47120A41CB7E61B34D4D948EB4C135AAB93DFC1`；两版 `player_pcm_waveform.v` 均为 `D99E17252BEAD794D6FC77316E95FD5A45907E15BA38BB34C748C787EE2E9ABB`。本次复核 gate 与 routed 网表，FFT `sample_mem`、A/B 两组实/虚工作 RAM、renderer `target_mem` / `state_mem` 的相关 BRAM 端口连线均保持相同逻辑控制。没有发现 C11309 新增一个同步读拍、漏接读使能、RAM 端口换时钟、BRAM 输出寄存器被打开或写使能改变的证据。
- C11307/C11309 这些 RAM 的配置一致：数据 BRAM 使用 `REGMODE_A/B=NOREG`、`RESETMODE=ASYNC`、复位 mux 为 0、CS 常开、OCE mux 选择常量。sample/work/target 的读写 RAM 使用双端口 `DP8K`；renderer state 使用单端口 `SP8K`、`WRITEMODE_A=READBEFOREWRITE`。这说明 primitive 配置与静态端口选择一致，不代表我们读取或动态验证了硅上 BRAM 内容。
- RTL 周期与同步读安排相符：sample 在 `ST_CAPTURE && audio_valid` 写入；`ST_WIN_REQ` 同步读 `win_index`，下一状态 `ST_WIN_MUL` 使用 `sample_q`。FFT 的 `ST_FFT_ISSUE` 采样 A/B 操作数与 twiddle，随后 M0..M3 执行乘法。renderer 在同一 `clk` 过程注册 `state_q`/`target_q`，U_READ 后的 U_CALC 消费这些值；state RAM 按预期在 U_INIT/U_CALC 写。关键时序代码见 `player_spectrum_analyzer.v` 约 229–260 行与 `player_pcm_waveform.v` 约 82–88 行。
- 尚不能排除 C11309 布线/物理实现改变后引发的板级时钟或 BRAM 路径问题。C11309 新增串行 GCLK 并改变了整体布局，静态逻辑端口相同不等于硅上时序/读值相同；当前反馈又没有 B/C 数据，无法区分 PCM 未采到、系数/FFT 阶段停滞、幅值为零、前台未提交或绘制使能问题。本次没有找到可直接据此修 RTL 的确定 bug。
- 不把 INIT/系数 ROM 审计当作实际读取证明，也不把 C11307 的实板频谱工作反馈外推为 C11309 运行证明。

## 网表核查细节

检查文件：

- C11307 gate：`development/player_spectrum_observed/build/manual/AC201_tf_hdmi_gate.v`
- C11307 routed：`development/player_spectrum_observed/build/audit/routed_implementation.v`
- C11309 gate：`development/player_spectrum_clock_route/build/manual/AC201_tf_hdmi_gate.v`
- C11309 routed：`development/player_spectrum_clock_route/build/audit/routed_implementation.v`

两版 sample RAM 均由 2 个 9-bit slice 覆盖 1024×16；地址 A=`sample_count`，地址 B=`win_index`；写端 `sample_write_en`，读端在 `ST_WIN_REQ` 有效；A/B 时钟都接 `u_status_monitor/sys_clk`。两个 FFT 工作 bank 分别使用同一同步时钟，写地址/数据共享 `work_ram_write_addr` / `work_ram_write_*`，A 读地址为 `real_a_read_addr`，B 读地址为 FFT 的第二个操作数，B 读在 `ST_FFT_ISSUE` 期间启用。对应输出回到 `sample_q` 与 `real_a_q/real_b_q/imag_a_q/imag_b_q`。

renderer 的 target RAM 两端都接 `u_status_monitor/sys_clk`，capture/snapshot bank 地址分开；state RAM 两片 9-bit slice 同接该时钟，`update_index` 地址、`state_write_en` 写使能、`state_q` 读回。四份网表中这些信号及配置一致。网表中诸如 `open_n...` 的未用高位是物理 BRAM slice 填充位，不是 16-bit 业务数据被截断；有效低位数据端连接完整。

## 最小后续观测

最新视频已给出 WAV 和 tone 的 B/C 值，当前均为 B=`B7000000`、C=`C7840000`，且 trace 已持续数分钟。除非新复测显示读数变化或需要确认独立版本页，当前定位应转向 analyzer 状态/样本计数，不再把一般性的“等待完整页面周期”当成首要步骤。详情及字段解码见下节。

## 按新视频读数补充：FSM 是首要定位方向

根任务提供的最新视频可读到：WAV 与 tone 各自的 B 页为 `B7000000`、C 页为 `C7840000`；tone 有声且频谱仍空；两秒视频分别包含 B→C 页面切换，运行 trace 已持续数分钟。按当前显示格式，B 的 capture flags 为 `7`、FFT frame count 为 `0`；C 的 capture flags 为 `7`，频谱遥测为 `0x840000`。其字段含义为 `diag_pcm_seen=1`、`diag_frame_seen=0`、`diag_band_seen=0`、Hann/twiddle nonzero=0、`diag_commit_seen=1`、`diag_front_seen=0`、freeze=0、last frame max=0。`diag_commit_seen` 只表示 renderer 曾完成 U_COMMIT；启动时对零目标的空前台提交也能置位，不能当作 FFT 帧提交成功。

这把优先级从“ROM/BRAM读值”移到了 analyzer 控制推进。RTL 的 `frame_done` 只在最后一个频段的 `ST_EMIT` 产生；从 `ST_WIN_REQ` 到该状态，状态转移不依赖 Hann/twiddle 数值或 BRAM 返回数据，系数全零也应走完整帧并增加 B。因此在长时间 B=0 时，单纯系数为零不能解释现象。`ST_CAPTURE` 唯一等待条件是 `audio_valid`；C 的 `diag_pcm_seen=1` 证明自上次清零后至少见过一次有效脉冲，但它是粘滞位，不代表采样持续或计数达到1024。结合数分钟运行，仍不能只靠此字段判定 sample_count 已走满；更需观察 state/count 与是否反复触发 `source_change`。

gate/routed 的静态映射显示，C11307/C11309 analyzer 都有 17 个 one-hot 状态寄存器；时钟接 `u_status_monitor/sys_clk`（top 中 `status_clk=video_clk`，即播放器的 pixel/video 时钟）。状态 FF 使用同步 SR；`band_index_b_n` 的组合逻辑等价于 `rst_all || source_change`，而 `source_change` 是 `tone_mode XOR tone_prev`。状态捕获 bit 0 为 reset-set，其他状态位 reset-clear；`rst_all` 来自 50MHz top 时钟，在两个 PLL lock 后保持约20ms再释放，释放后除外部复位不会周期性重置。overlay 每个 video_clk 将 `tone_prev<=tone_mode`，稳定音源下 `source_change`按 RTL 只在切源时产生一拍。两版本该控制连接一致，未见 C11309 独有的 FSM reset/clock 连接差异。这些静态连接不证明芯片上的 one-hot 状态实际运行，也不排除上电释放边界的物理问题。

若 audio_valid 持续为 48 kHz，按 RTL 计数，单帧约需 1024 个样本（约21.3ms）加约56k个 video-clock 周期做 Hann/FFT/scan（约2.3ms）；因此数分钟 B=0 不应解释为正常首帧等待。建议父任务的新被动 FSM 诊断至少同时观察：`rst_all` 与 `source_change` 脉冲/计数、analyzer `state`（导出可读 5-bit 枚举而非依赖内部 one-hot重编码）、`sample_count`、`win_index`、`fft_stage`/`butterfly`，以及 `audio_valid` 接受计数和 `frame_done` 计数。优先区分“source_change/复位反复清零”“在 ST_CAPTURE 但 sample_count 不前进/不满1024”“已经进入窗口/FFT/扫描但卡在特定状态”。保持 C11309 的稳定代码与位流不变；本补充未改动它们。

## 证据路径

- C11307 反馈/历史审计：`development/player_spectrum_observed/build/board_feedback_20261014/cache_netlist_audit.md`；C11307 专题：`E:/QQ CACHE/Download/安路资料/开发记录/专题记录/音频可视化/频谱柱_C11304_20261013/C11307_ROM读控制与ODDR诊断/README.md`
- C11309 现场反馈：`development/player_spectrum_clock_route/build/board_feedback_spectrum/feedback.json`；C11309 位流/ZIP/240-file preservation receipt 在同目录，均保留原样。
- C11307 与 C11309 analyzer / renderer RTL：`src/user_source/hdl_source/player_spectrum_analyzer.v`、`player_pcm_waveform.v`（两项目相应路径）。
