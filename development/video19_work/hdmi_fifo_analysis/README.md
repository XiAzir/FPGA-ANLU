# HDMI 音频 FIFO 深度实验

## 本轮 hierarchical defparam 结果（2026-10-21）

目标是在隔离副本中把 96-bit HDMI audio FIFO 的地址宽度设为 7，即 128 entries；live `player_video19` 源码保持原样。

ModelSim SE-64 10.1c：整机回归冻结源编译成功，exit code 0。测试台在 `dut.u_hdmi_1_4b_transmitter_core_wrapper.u_hdmi_tx_controller_wrapper.u_hdmi_island_data_gen.U_audio_sample_packet_2_channel.u_w96_d1024_fifo.u5.ADDR_WIDTH` 加入 `defparam ... = 7`。elaboration 以 exit code 12 失败，原始错误为：

```text
vsim-10000: Unresolved defparam reference to 'u5' in
dut.u_hdmi_1_4b_transmitter_core_wrapper.u_hdmi_tx_controller_wrapper.
u_hdmi_island_data_gen.U_audio_sample_packet_2_channel.u_w96_d1024_fifo.u5.ADDR_WIDTH
```

证据：[`runs/photo_system_20261021_190509/defparam_summary.json`](runs/photo_system_20261021_190509/defparam_summary.json)、同目录 `compile.log`、`console.log`、`defparam_probe.log`、`source_receipt.json`。可复跑入口：[`run_defparam_elaboration.py`](run_defparam_elaboration.py)。

TD 6.2.1 SP1 在独立复制的工程上运行现有 syn_1 synthesis setup。顶层副本加入同一相对层级路径的 `defparam`；TD elaboration 报 `HDL-8007 ERROR: 'u5' is not declared under prefix 'u_w96_d1024_fifo'`，位置为隔离 `top_tf_hdmi_audio.v:23`。同次 elaboration 对应的原语实例日志仍显示 `EG_LOGIC_RAMFIFO(DATA_WIDTH=96,ADDR_WIDTH=10,IMPLEMENT="9K")`。流程停在 elaboration；没有运行 optimize gate，没有 gate DB 或面积结果。

证据：[`td_defparam/receipt.json`](td_defparam/receipt.json)、[`td_defparam/td_console.log`](td_defparam/td_console.log)、[`td_defparam/project/user_source/hdl_source/top_tf_hdmi_audio.v`](td_defparam/project/user_source/hdl_source/top_tf_hdmi_audio.v)、[`td_defparam/build_defparam.tcl`](td_defparam/build_defparam.tcl)。原始 project SHA256 `A8CC7F670563143F893BFB27E2FEE625FAF55B6E311666AFDA5B38885BC66638`；原始 top SHA256 `EFC383ADEE28DC4B289588E44A38DAC4D3A584D6427DC64C8FEF15D46B08D400`。隔离副本 top SHA256 `A632100EAF35F790327F7A84750648F482AC68837E41EAA0FB30EA8FE91BC417`。加密 HDMI wrapper 原文件哈希收于 TD/ModelSim source receipts。

## 判断与接续

本轮目标 hierarchy 中的 `u5` 名称在 ModelSim protected hierarchy 与 TD encrypted-IP elaboration 均无法解析；TD 可见的 96-bit 原语配置仍为地址宽 10。此证据支持暂停 hierarchical defparam 路线，继续保留原 1024-entry 配置。128 深度本地 RAMFIFO 行为模型和 primitive/system 仿真结果属于隔离实验，不能证明加密 IP 缩深或生产综合采用。

父任务反馈整机资源优化的新优先方向是核验真实 KEY1/KEY2 电平经过 `player_adjust_control`、top 模式同步和媒体复位的控制链；详细简版 spec 在 [`video_controls/controls_spec.md`](video_controls/controls_spec.md)。

控制链验证已在当前一致冻结源上完成：ModelSim exit code 0，结果 `VIDEO_CONTROL_PASS mode_pulses=2 next=1 auto=2 resets=3 last_reset_width=32 mode=0 sd_mode=0 paused=0`。测试用 active-low KEY1/KEY2 驱动真实长/短按，不强制内部 mode/event；只缩短隔离副本 `u_adjust_control` 参数。覆盖照片→视频及返回的双键长按释放、video mode 的 SD 域两级同步、视频 KEY1 mailbox/restart、KEY2 pause/resume，以及三次32周期媒体reset。run 与 testbench/source receipt：[`runs/photo_system_20261021_191448/video_controls_result.json`](runs/photo_system_20261021_191448/video_controls_result.json)、同目录 `video_controls_receipt.json`、`console.log`、`compile.log`、`source_receipt.json`。可复跑入口：[`video_controls/run_video_controls.py`](video_controls/run_video_controls.py)。runner 内复用 photo setup，故其通用 `summary.json` 的 photo scoreboard 状态不作为此专用 TB 判据，`video_controls_result.json` 为本试验结果。

控制 TB 只验证按键至 top 模式/reset/mailbox 状态链，SDHC 用常值 MISO，没有载入有效 MJP 媒体播放流程。视频首帧提交、原声 PCM 逐样本与 HDMI packet/serial 内容需由后续整机播放仿真验证。此前一次首跑在源冻结期间混合了新旧 `frame_read_write` / `frame_fifo_read`，Elaboration 因缺少 `read_refill_request` 失败；在当前接口一致时重新冻结并完成 PASS，前次失败留档于 `runs/photo_system_20261021_191202/`。

此前 128-depth 模型整机回归和 128/256/original primitive 回归见 `runs/photo_system_20261021_185659/` 与 `runs/primitive_20261021_185028/`。其证据范围仅限本地模拟模型。
