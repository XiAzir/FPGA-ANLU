# C11302 player_pcm_waveform RTL implementation audit

更新日期：2026-10-13（北京时间）

## 接口与源兼容

- 文件：`development/player_music_envelope/src/user_source/hdl_source/player_pcm_waveform.v`
- 模块端口保持 C11301 `player_pcm_waveform` 原有端口名称和顺序；新增默认参数 `AVG_LOG2=8`，保留 `CLK_FREQ_HZ=25000000`、`STALE_MS=100` 和兼容参数 `SAMPLES_PER_BIN=2`。
- 工程 top 只连接 `CLK` 的约束无需改动；音频、VS、DE、按键和RGB观察端口沿用原接口。

## 已实现结构

- PCM取自 `audio_pcm[23:8]`，有符号绝对值覆盖 `-32768 => 32768`；只累计 `audio_valid`，默认每256个样本求均值并更新20-bit Q4包络。
- 上升/下降各用向上取整的 `ceil(delta/16)` 与 `ceil(delta/64)`；默认100ms无有效样本后进入stale，清空平均块，每个VS按 `ceil(env/16)` 衰减。tone_mode变化清空观察/历史并解除HOLD。
- 128×16-bit历史BRAM按VS记录soft-knee映射后的Q4高度，count负责启动期左侧零填充，环形指针满窗时覆盖最老节点。同步读配合有限状态builder，用Catmull-Rom四组常数权重生成512列；有符号算术右移实现/128向下取整，结果钳在段端点范围内。
- 512×16-bit双bank trace BRAM仅由后台builder写capture bank；512列全部写完才置 `capture_ready`，只在后续VS交换front/back。音源切换与HOLD可中止后台构建；HOLD保留当前front、暂停历史写入但继续音频观察；解冻VS从最新包络恢复历史采样。
- 视频读址按 `next_x_pos` 预取每个像素列，对齐x64..575曲线窗口。绘制使用y408基线、单条Q4包络、16档主线和暗辉光、背景/零线及弱填充。画外与DE blank透传RGB；标题为ENV WAV/TONE及HOLD WAV/TONE。

## 静态检查与边界

- 使用 `bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe -g2012 -tnull` 对目标RTL做Icarus语法编译，退出码0，无诊断。
- 已逐项检查参数/端口、复位与源切换、双bank写入条件、历史索引与启动左padding、插值权重、颜色ROM、next_x预取、HOLD停写及解冻边界采样。
- gold代理缩参回归PASS：平均值、128节点环回、启动零填充与满窗全图扫描、软拐点/Catmull像素、HOLD停写与恢复、同VS源切换优先、stale衰减与valid恢复均为0 env/pixel/control errors。生产参数25MHz/48kHz、420000 clocks/frame的128帧长回归按根代理收束指令中断，标记 `INTERRUPTED/NO_VERDICT`，不得视为PASS。
- 未执行TD综合/布局布线或板上验证。资源、时序和实物显示效果待根代理后续验证。
- 关键寄存器：`abs_sum`、`avg_count`、`env_q4`、`stale_count`、`hist_mem/hist_count/hist_write_ptr`、`snap_base/snap_count`、`build_state/segment_index/preload_count/pixel_in_segment`、`trace_mem/display_bank/capture_bank/front_valid/capture_ready`、`x_pos/y_pos/trace_read_data`。
