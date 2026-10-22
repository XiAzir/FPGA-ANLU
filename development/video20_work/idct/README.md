# IDCT 算术资源候选（C11319 / C04）

本隔离目录只包含 IDCT 运算候选、参考源码、仿真和独立 TD 工程；没有修改 `player_video19` 或父整机 build。源 IDCT 与 `development/player_video19/src/user_source/hdl_source/jpeg/jpeg_idct_x.v`、`jpeg_idct_y.v` 的 SHA256 已核对一致；四组全核 TD 工程都从同一个 `color_width/parent/src_v` 源集复制。

## 结果

| 变体（TD `max_dsp=29`） | X LUT/ripple/FF/DSP | Y LUT/ripple/FF/DSP | 全核 LUT / registers / slices / DSP | Setup WNS / TNS |
| --- | --- | --- | --- | --- |
| Baseline | 561 / 336 / 782 / 5 | 655 / 413 / 926 / 10 | 2426 / 2231 / 1000 / 18 | -2802 / -22416 ps |
| B：181 因式分解 | 539 / 314 / 782 / 5 | 641 / 399 / 926 / 10 | 2421 / 2174 / 964 / 18 | -2968 / -22113 ps |
| AB：窄乘法操作数 + B | 539 / 314 / 782 / 5 | 641 / 399 / 926 / 10 | 2440 / 2174 / 964 / 18 | -2735 / -20249 ps |

同配置 `B` 相对基线在 IDCT 层级减少 36 LUT、36 ripple，DSP 数保持 15；全核减少 5 LUT、57 个门级寄存器和 36 slices，DSP 保持 18。TD gate QoR 的 WNS 变差 166 ps、TNS 改善 303 ps；这组结果用于资源方向判断，不替代完整布局布线时序验证。AB 将窄操作数 A 加入后，全核 LUT 比 B 多 19，slice 数相同，因此建议仅保留 B。

TD 设置为 Tang Dynasty 6.2.1 SP1、EG4S20BG256、AreaHigh、`max_dsp=29`、`resource_sharing=auto`、`min_ripple_len=18`、20 ns SDC。每个变体的工程、源码哈希清单、实际参数、gate.area 和控制台日志都保存在 `td_core_cap29/`。另保留 `max_dsp=17` 重跑用于展示 cap 敏感性；B 的 IDCT hierarchy delta 相同，见 `td_core/`。该 cap17 全核自然用了18 DSP，故 cap29 才是主要对照。

本轮重现的基线 X hierarchy 与交付任务给出的 561/336/782/5 相同；Y 为 655/413/926/10，比任务简述中的 615/373/926/10 多40 LUT与40 ripple。B 和 AB 的对比基于同一源集、同一 TD 设置；合并前仍需父工程核对 Y 的基线来源及应用上下文。

## 推荐候选 B

两轴各有两条 `181/256` scale 运算。原始位向量使用 `128x + 32x + 16x + 4x + x`；B 改为三个 32-bit signed 中间量：

```text
t15 = (x << 4) - x
t45 = (t15 << 1) + t15
181x = x + (t45 << 2)
```

在 32-bit 模 2^32 运算中，`16x−x=15x`，`2·15x+15x=45x`，再加 `4·45x+x=181x`。每个中间量仍是 signed [31:0]，故对任意32-bit输入得到和原式完全相同的位型；下游有符号 `/256` 和 `OUT_SHIFT` 未改。X/Y 的valid、数据输出、索引流水、复位和每周期吞吐均未改动。

可直接供父集成的 B 文件为 [jpeg_idct_x.v](td_core_cap29/B_scale181/src_v/jpeg_idct_x.v) 与 [jpeg_idct_y.v](td_core_cap29/B_scale181/src_v/jpeg_idct_y.v)。差异仅为两个 `scale181_*_w` 组合算术表达式。SHA256 分别为：

- X：`51457d29370b5eb51fe63dc1597762d6a55e65bf9d1e367f317127c77c4ae570`
- Y：`b132be9cd31a62f9c87eecc7c81280dbe658028193bca816adc2f6663f65647d`

## 窄乘法操作数 A

A 将 X/Y 的乘法输入暂存器从 32-bit 收窄到 X 的 18×13、Y 的 22×13；乘积与后续运算仍为 32-bit。X 的原始输入为 signed 16-bit，`i0` 是两个16-bit数之和/差，signed 17-bit 足够；Y 的应用输入来自 X `>>>11`，故是 signed 21-bit，`i0` 最大需要 signed 22-bit。transpose RAM 只存 `[20:0]` 并按 bit20 符号扩展，见当前父源 `jpeg_idct_transpose_ram.v`。系数4017以下均可由 signed13-bit表示。

A 在无约束的独立 Y top 表面减少19 LUT、3 ripple、34 FF；但将 baseline Y 输入也约束成真实21-bit sign-extend 后，基线与A的联合 wrapper资源完全一致。X独立top亦无变化。Core层级报告中A无IDCT层级面积节省；AB全核比B多19 LUT。故当前不建议集成A。

## 逐周期差分

`sim_idct_diff_200k.log` 由 ModelSim SE-64 10.1c、`-lic_noqueue -novopt` 生成。测试将重命名原模块作为reference，逐周期并行比较原核、A、B、AB的 X/Y `valid/data/index`：X和Y各200,000个周期，seed `0x51D7C0DE`，随机覆盖完整signed16/signed21输入域、随机索引/valid/gap/start/reset，并注入最小值、最大值、0、−1边界。检查数合计 X=200,000、Y=200,000，mismatch=0。此仿真按模块端口契约运行，不模拟JPEG解码器事务。

## 失败和未完成记录

- `sim_model_initial_license_wait.log` 保存首次未使用 `-lic_noqueue` 时停在 ModelSim license 子进程的输出；之后按可用参数正常运行并通过。
- `td_core/B_scale181/td_console.failed_module_rename.log` 与 `td_core/AB_both/td_console.failed_module_rename.log` 保存候选生成器首次模块名替换失配时的黑盒错误。修正后 cap17、cap29 综合均成功。
- 本轮没有做全播放器 top、bitstream、PNR 或板上运行；无90%总面积结论。
