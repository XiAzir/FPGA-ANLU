# RGB/DE→AXIS 行长度只读核查

## 结论

真实视频时序发生器输出的每行有效 DE 长度是 **640 个像素时钟**。`video_rgb_to_axis_640x480` 的计数器在有效区首周期装入 0，随后才递增，但它用旧计数值 `S_x_cnt == 639` 产生 `O_video_last`。因此 640 周期 DE 结束前旧计数值最大是 638，观察到的四行中 `O_video_last` 都没有脉冲；按当前逻辑需要 641 个连续 `I_de` 周期才会命中 639。AXIS `valid` 仍为每行 640 个时钟。

这是一项**成功与失败工程共同拥有的既存源逻辑问题**，不足以解释动态字幕版本相对于 `player_osd_phy_fix` 的差异，也没有证据能据此归因上板图像/音频故障。HDMI core 的 wrapper 接口明确收到了 `axis_s_last`，但实现位于加密区域，无法只凭 wrapper 源码确认内部如何消费 `I_axis_s_last`。

## 时序发生器与实际宽度证据

`SD/color_bar.v` 第 2 行包含 `video_define.v`；该文件第 1 行定义 `VIDEO_640_480`。所以 `color_bar` 采用第 42–52 行参数：`H_ACTIVE=640`、`H_FP=16`、`H_SYNC=96`、`H_BP=48`，总行长第 110 行为 `H_TOTAL=800`。第 175–183 行水平计数器从 0 走到 `H_TOTAL-1` 后回零；第 220–229 行按 active 起止点翻转 `h_active`。`video_active = h_active & v_active` 且 `de = video_active_d0`（第 150–155 行）；第 159–172 行将它寄存一次。由这些计数端点得到每行 640 个连续有效时钟。

顶层实际路径不是凭模块名推断：`video_timing_data` 在 [video_timing_data.v](../../src/user_source/hdl_source/SD/video_timing_data.v#L74) 实例化上述 `color_bar`；第 44–51 行再将 HS/VS/DE 两级寄存。顶层 [top_tf_hdmi_audio.v](../../src/user_source/hdl_source/top_tf_hdmi_audio.v#L250) 接入它，并接入 `video_delay`。后者 [video_delay.v](../../src/user_source/hdl_source/SD/video_delay.v#L25) 用 `de_d[20]` 输出 DE，第 39–50 行将 DE 移过 21 级寄存器。两段只延迟边沿，不增减脉冲宽度。最后顶层将 `de` 接至 converter 的 `I_de`（[top_tf_hdmi_audio.v](../../src/user_source/hdl_source/top_tf_hdmi_audio.v#L392)）。

Converter [video_rgb_to_axis_640x480.v](../../src/user_source/hdl_source/video_rgb_to_axis_640x480.v#L35) 每周期令 `O_video_valid <= I_de`；第 44–55 行首有效周期把坐标设为 0、后续有效周期递增；第 57–60 行只在 `I_de` 为高且**旧** `S_x_cnt == 639` 时拉高 `O_video_last`。对 640 周期输入，第 640 个有效边沿判断的旧值仍是 638；如果输入再多保持一个有效周期，才会判断旧值 639。

## HDMI wrapper 接线与可见范围

原成功顶层的 converter 实例位于第 387–397 行，失败顶层位于第 392–402 行；两段实例块逐字相同：`O_video_last -> axis_s_last`。随后成功顶层第 426–430 行、失败顶层第 431–435 行将 `axis_s_last` 接至 wrapper 的 `I_axis_s_last`。wrapper 明文端口定义第 37–41 行包含 `I_axis_s_user`、`I_axis_s_valid`、`I_axis_s_last`、`I_axis_s_data` 和 `O_axis_s_ready`，其余实现受 `pragma protect` 加密，内部 TLAST 处理方式无法由可读源证实。

另一个接口观察：converter 的端口表（第 2–13 行）没有 `ready` 输入；top 将 `O_axis_s_ready` 输出连到 `axis_s_ready`（wrapper 接线处），但并无路径反馈到 converter。因此它会按 DE 连续给 valid/data，不按 ready 停顿。这是独立的 AXIS 握手核查点；本次 TB 没有建模 HDMI core 的 ready 行为，也不能据此断言发生丢包。

## 独立行为仿真

TB 位于 [tb_axis_readonly_audit.v](tb_axis_readonly_audit.v)，直接编译 fit 副本的原始 `color_bar.v`、`video_timing_data.v`、`video_delay.v` 与 `video_rgb_to_axis_640x480.v`，不改写这些源。运行日志在 [run.log](run.log)，编译日志在 [compile.log](compile.log)。仿真 PASS 行为核查结果为：4 个源 DE 行均 640 时钟，4 个 AXIS valid 行均 640 时钟，TLAST 脉冲数为 0。该 PASS 表示预期现象被复现，不表示 AXIS 行标记正确。

## 成功/失败版本差异判别

`video_rgb_to_axis_640x480.v`、`SD/video_timing_data.v`、`SD/video_delay.v`、`SD/color_bar.v`、`SD/video_define.v` 和加密 wrapper 在 `player_osd_phy_fix` 成功源与失败 `player_dynamic_text` 源的 SHA256 全部一致；两版 top 中 converter 实例块也逐字一致（尽管 top 其他部分不同）。所以缺失 TLAST 不属于动态字幕源码差异。它可能是共有接口/协议风险，但不能作为本次板测回退差异的已证根因。此次审计未构建 TD、未修改 source/SDC、未操作板卡。