# 手动 Freeze 专项审查与 Icarus 仿真

审查对象：`src/user_source/hdl_source/player_pcm_waveform.v`。本记录只覆盖 `freeze_toggle` 手动请求、双 bank 窗口生命周期、tone/stale 优先级和默认参数连续音频场景；未修改 RTL。

## 结果

- Icarus 仿真通过：`KEYFREEZE PASS checks=819 failures=0 dense_audio_events=144000`。
- 可重复命令：在项目根目录执行 `pwsh .\development\player_pcm_waveform_keyfreeze\build\model\run_keyfreeze_wave.ps1`。脚本将编译映像放在系统临时目录并清理；完整输出保存在同目录 `keyfreeze_wave.log`。
- 本次专项没有发现与下列冻结语义冲突的 RTL 行为。

## 已覆盖

- 已有 front、back 新窗口已 ready 时请求 freeze：VS 保留当前 `display_bank`，丢弃待交换 ready；核对两个 bank 的 128 个 RAM 字均未改变。
- 冻结跨多次 VS、输入新极值音频及超过短模型 stale 门限的静音：front、bank 选择和 RAM 内容保持；stale 计数/失效不推进。
- 冻结前确有 19-bin partial back：恢复 VS 清零 partial 元数据、重开 capture，旧 front RAM 保持；后续完整极值窗口到达 VS 后才替换 front。
- 无 front 时先请求：capture 继续；完整窗口首次提交时才同时显示并冻结。
- VS 前两个 toggle 互相抵消；toggle 与 VS 同沿时按旧 request 决策、请求在后续 VS 生效。
- tone + toggle + VS 同沿优先清 request 并按原逻辑失效；已冻结时切 tone 取消 hold，并在 VS 恢复 invalidate/capture 流程。
- 第二个实例使用 RTL 默认参数，连续输入恰好 144000 个有效音频时钟，并周期性提供 VS；没有自动 freeze，front 持续正常提交。

## 模型范围

冻结生命周期 DUT 使用 `SAMPLES_PER_BIN=1` 和 `CLK_FREQ_HZ=1000, STALE_MS=1000`，以压缩完整窗口采集时间；静音冻结断言跨越 1000-cycle stale 门限。另一个 no-auto-freeze DUT 使用 RTL 默认参数。Icarus 检查是行为级模型验证，不代表 48 kHz 实际时钟、完整帧视频扫描、TD 综合/时序或板上按键消抖与单周期 pulse 验证。顶层 short-chord 到 `freeze_toggle` 的脉冲生成也不在本模块 testbench 范围内。

日志中的唯一结果行为 `PASS`；失败项为 0。该专项未触发需要修正 RTL 的疑点。
