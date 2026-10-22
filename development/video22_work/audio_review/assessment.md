# C11321 实板音频杂音：WAV / FIFO / HDMI 桥检查

日期：2026-10-22（北京时间）  
对象：`development/player_video21_diag`，其生产基线为 C11320。只读检查；没有修改 `src/` 或 `scripts/`，没有运行 TD。

## 现场证据

- 父任务从 C11321 早期录像读到：视频 FFT 页状态 `00034908`，其中 `audio_underflow` sticky 位为 1；照片 FFT 页 `00107A00`，underflow 位为 0。之后用户确认图片、视频两种模式都持续有杂音；视频下的一次欠载事件与两种模式的持续杂音属于不同观测。来源：`development/video22_work/board_20261022/board_observations.json` 与录像取帧；属父任务读取的实板录像证据。
- 视频页 WAV 播放状态 `2BD44000`、文件映射状态 `40000728/50000003`，`wav_error=0`、`wav_map_error=0`；WAV RIFF 标识正确。此证据支持 RIFF 解析与文件映射本次未报告错误，服务空窗仍列为调查项。
- WAV 数据起点是字节 78（包含 30 字节 LIST/INFO chunk），PCM 数据长 1,920,000 字节、960,000 个样本；文件长 1,920,078 字节。SHA256 `30eaf10a6ff1800163cecb3225cce685873b38c9a8e42635f1e5c92b0e95b5de`。该素材使用带LIST/INFO的78字节头。

## 静态与综合证据

- `tf_wav_file_player.v` 生产实例 `FIFO_DEPTH=2048`。C11321 实际 gate 网表将 `fifo_mem` 映射为 4 个 `EG_PHY_BRAM`（每块承载 2048×4 位），另有 1 块 512×8 位扇区缓存；综合记录总 BRAM 数为 62。没有发现 FIFO 被综合裁小或深度/指针宽度不一致。
- 缓冲容量对应 42.67ms；priming 门槛 1024 样本，对应 21.33ms。`fifo_space_sector` 条件是 FIFO **空位达到至少256个样本**，即占用降到1792或以下才开始补读。接近满载稳态时，读请求启动点约有1792个样本、37.33ms的余量；补读还需经历SD调度/扇区传输。一次连续无服务时间越过当时剩余量，桥每个48kHz采样tick会在 `prefetch_valid==0 && !ack_arrived` 时输出24-bit零并置sticky underflow。
- WAV 源每个满扇区至多提供 256 个样本，正常音频消费该批需 5.33ms。共享扇区 arbiter 参数 `AUDIO_BURST_MAX=2`，BMP 等待时每两个 WAV 扇区后取得服务；按设计 SPI 12.5MHz，512字节有效载荷理论传输约 0.328ms。估算范围限于同簇数据与标称时钟，实板 SPI 实际频率/等待、卡响应尾延迟和跨簇 FAT 访问仍需测量。
- FIFO push/pop 同拍、BRAM 同地址旁路、读头预取、2048 指针自然回卷及样本数更新在源码中都有明确处理。当前静态检查未见能单独说明录像欠载的明确RTL缺陷；仍需观测源PCM与服务时间。
- video 模式切换经 `rst_all` 同时清零 WAV parser/FIFO、PCM bridge 与 video scheduler。video scheduler 在首帧显示确认后开放 `video_audio_go`；bridge 完成首个样本请求/应答并置 `started` 后才发第一个音频 tick。该顺序让桥拿到首样本后才开始采样。pause 经两级同步 play gate 停止音频节拍，桥仍接收并保留在途 ack/prefetch；源码路径显示单次 pause/resume可维持预取状态。sticky 标志本身没有次数和时间戳，早期录像只定位至少一次欠载。

## 已有验证覆盖

- 旧 C11310 系统仿真只使用短生成 WAV fixture，FFT 仅覆盖 4096 样本；门级/HDMI引脚短窗逐样本核对约4k样本通过。
- C11320 真实 SDRAM/APUG011 模型连续 221ms，送出 6408 个 PCM 样本、underflow=0；约为20秒素材的0.67%，测试范围没有包含循环边界和持续扇区服务间隔。
- 因而健康短窗证明了标准服务条件下的路径，现场 sticky 欠载则说明硬件至少遇到过一次桥端取样空窗；两者范围可以并存。

## 有界 service-gap 复现

`short_loop_4096.wav` 取 canonical WAV 的前4096个样本，保留 data offset 78；SHA256 `961708b4e23ccfcdff175cdc58c07885273f8cec2b0186359fdadc353a73b523`。`tb_wav_service_gap.v` 连接生产 WAV FIFO 与 PCM bridge，采样节拍缩放为每12个同源时钟一个样本，连续服务时12,000输出样本（短素材约3圈）逐样本匹配，underflow=0。注入等效30/40/45ms service gap 时，在 primed 后 FIFO 占用1205处请求服务；首次欠载时 FIFO=0、桥 waiting=1/prefetch_valid=0，分别插入235/715/955个零输出，服务恢复后样本继续匹配。完整日志：`baseline.log`、`stall_30ms.log`、`stall_40ms.log`、`stall_45ms.log`；Icarus编译与三个 gap 仿真 exit code 均为0。测试覆盖逻辑扇区模型与缩放采样节拍；实板SPI服务持续时间和异步时钟相位需要另行测量，生产 video scheduler 的 audio_go 首帧门控也未接入此bench。

曾为模拟 audio_go 延迟尝试等 FIFO 达到2048后再启音频；在 data offset 78 时 reader 因 `空位>=256` 门槛停在占用2009（空位39），bench 的2048等待条件未触发，watchdog 记录 `outputs=0,takes=0,requests=9,state=7,fifo=2009`。该日志反映bench门槛设置未匹配生产补读条件，RTL服务gap结果仍以四个PASS日志为准。记录见 `baseline_wait_2048_gate_failed.log` 和 `baseline_gate.log`。此前未提权 Icarus 因 Windows Sandbox temp 路径失败，ModelSim 10.1c 因系统 DLL 重定位未启动；最终用受限 Icarus 完成上述服务模型运行。

## 结论与下一步

现场可证结论是“C11321视频模式至少发生过一次桥端欠载，桥在对应音频 tick 输出零”。用户后来确认两种模式都持续有杂音，需继续核验HDMI输入PCM的逐块指纹；专项文件位于 `development/video22_work/audio_crc`。
