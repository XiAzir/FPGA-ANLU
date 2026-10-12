# 冻结模型与 RTL 只读审查

## 结果

`run_freeze_model.ps1` 使用本机 Icarus Verilog 编译冻结 RTL 和 `tb_freeze_waveform.v`，最近一次运行于 2026-10-12 11:22（Asia/Shanghai）通过，`PASS checks=288`，VVP exit code 为 0。完整输出保存在同目录的 `freeze_model.log`。

## 覆盖证据

- 主实例使用缩放门限 200 个有效 PCM 事件、`SAMPLES_PER_BIN=1`。门限前仍为 live；请求与 VS 上升沿同周期时，已完成窗正常换入 front，但该沿读取旧 `freeze_requested`，所以本沿仍未置 `frozen_front`。之后新窗完整采满并在 VS 换入后冻结。根代理接受此同步请求延迟，即等待下一完整窗的 VS；不能写成生产参数下“最多一帧”，因为 1024 个 48kHz 样本窗约 21.333ms，超过名义 16.8ms 视频帧。
- 换 tone 与第 200 个有效事件同沿时，tone 变更分支优先清零计数与 request，并安排非 VS front 失效；随后的 VS 清掉旧 front。新 tone 窗请求、采满、换帧后冻结，`frame_tone_mode` 选中 TONE 标题路径。
- 冻结后注入 300 个变化 PCM 事件、4 次 VS、再经历无样本 stale 时间。冻结状态保持；对 front bank 和 capture bank 的 128 项各逐项比较快照（共 256 个 RAM 条目），并检查两个 bank 编号不变。
- 显示验证逐帧扫描 640×480 的时序两帧，在图形区固定 `x=200` 按 y 采样。每帧该列均只有一个连续青色区间。标题像素检查分别取 HOLD WAV 的 W 字形和 HOLD TONE 的 T 字形中可区分于另一模式的点。
- reset 清除 frozen/request/count 并恢复 capture。`DIAG_FREEZE_AFTER_SAMPLES=0` 在 260 个有效事件后不请求冻结。
- 单独的默认门限实例显式使用 `DIAG_FREEZE_AFTER_SAMPLES=144000` 和 `SAMPLES_PER_BIN=8`。以密集有效事件驱动计数器，验证 143999 不请求、144000 请求，且计数宽度可表示 0..144000。

## 只读 RTL 审查

没有发现需要我修改 RTL 的问题。门限/VS 同沿的行为已在上文记录：request 在该边沿通过非阻塞赋值注册，VS 分支按旧 request 判定，所以冻结可能落在随后完整窗的 VS。tone 变更优先于同沿的门限事件；冻结态分支阻止 stale 清理、样本写入和 VS 换 bank；source/tone 变更及 reset 可重新进入 live 采集。

冻结模式只钉住波形观察窗，不控制或暂停音频播放。测试没有把图形消影当作根因证明：它无法单独定位原双轨迹现象来自其他视频逻辑、像素时序、板级显示或其他路径。

## 验证边界

根代理复核补充：独立重跑288项PASS，日志freeze_model_root.log。额外run_frozen_music.ps1采用默认8样本/bin、缩短冻结门限1024，输入本地音乐1024点按520/521周期间隔、与主工程同叠加链连接；冻结后持续注入密集极值PCM，连续两帧768000周期、58368波形像素（全部512列）仍与host独立黄金min/max一致，HOLD标题1096白像素，区域外调节/状态/RUN/滚动/blanking一致。此测试覆盖真实音乐数据和完整冻结画布，但门限缩短、冻结后的新输入为密集压力事件，不是生产3秒完整SoC实测。日志frozen_music_integration.log。主旧unit303和默认门限前的真实音乐两帧集成也由根代理重跑PASS。

主实例的 200 门限是为了快速覆盖状态边沿而缩放的，不对应 3 秒真实输入。生产门限测试逐周期连续送事件，只证明有效事件计数边界，不模拟 48 kHz 的实际间隔或 WAV 前奏时长。仿真未包含目标器件 BRAM 原语映射、加密核、完整 SoC/音频路径、HDMI 显示器或上板行为；真实音乐集成及 unit303 验证由根代理另行执行。
