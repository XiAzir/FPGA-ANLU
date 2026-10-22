# C11319 控制链验证 Spec

## 已核对的 RTL 语义

- 顶层 KEY1/KEY2 为低有效输入，分别接 `u_adjust_control.key0_n` / `key1_n`；控制器默认 25 MHz、20 ms 去抖、1500 ms 长按、100 ms 脉冲间隔。
- 单键短按在释放沿形成动作。Play 模式下 KEY1 请求下一张，KEY2 请求自动播放切换；模式菜单下两键调整亮度/对比度。单键长按执行原菜单/tone 行为。
- 双键同时稳定按下后进入 chord。保持达到 1500 ms 时准备模式切换；双键均释放时 `video_mode_press` 发单拍。未达到长按阈值的 chord 在 Play 模式释放时切换 waveform。
- top 在 `video_clk` 域收到 `video_mode_press` 后翻转 `video_mode`，并启动 `media_reset_active`。计数器从 31 倒数，媒体 reset 持续约 32 个 `video_clk` 周期。`video_mode` 经两级同步送往 SD 时钟域。
- 视频模式下，KEY1 通过 request/ack mailbox 产生 `video_next_press`，再切换 restart toggle 返回 video 域启动媒体 reset；KEY2 的 `video_auto_press` 翻转 `video_paused`。退出 video mode 仍通过双键长 chord 的释放动作。

## 建议 TB

在隔离 run 中实例化真实 `top`、当前控制器及现有 SD/SDRAM/PLL 仿真模型。只驱动 `key1`、`key2` 的真实低有效按压/释放序列；通过 testbench 层参数 override 缩短 `u_adjust_control` 的 `DEBOUNCE_MS` 与 `HOLD_MS`，保持算法和模块连接不变。覆盖 photo→video 长 chord、释放触发、模式两级 SD 同步、约 32-cycle reset、video KEY1 restart、KEY2 pause/resume，以及返回 photo 的长 chord。监视 `video_mode_press`、`video_mode`、`video_mode_sd`、`rst_all`、`media_reset_active`、restart/paused 状态，并确认每次输入只触发预期一次。

首轮范围限真实控制输入至 top 模式/reset/mailbox 状态链；有效 MJP 首帧、HDMI 音频内容和物理 SDRAM另列为整机播放验证。
