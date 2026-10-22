# C22 按键分类与视频重启核对

日期：2026-10-22。源码只读核对；实板反馈由用户提供。未修改 RTL。

## 最新实板基线

- 用户反馈：重新加载 C22 后 HDMI、图片和声音恢复，持续有音频杂音。
- 视频播放期间双键长按后松手无可见变化，视频继续播放。
- 视频播放期间短按 KEY0 后，短暂无信号，随后只见 UI、计时为0；再次短按 KEY0 后再次短暂无信号，随后视频恢复、计时为0。
- 用户读数：UI-only 时 `00C11322 / 20400000`；正常播放时 `2BDXX000`（`XX` 为快速变化的状态 nibble）。这些属于用户现场读数。

## 双键长按的实际识别条件

C22 顶层把输入 `key1` 接到 `player_adjust_control.key0_n`，把 `key2` 接到 `key1_n`；两个输入均按低电平按下处理。按键各自经过两级同步和20 ms稳定消抖。默认 `CLK_FREQ_HZ=25 MHz`、`HOLD_MS=1500`，所以双键的重叠按下需至少约1.5秒，消抖时间另加约20 ms。

`player_adjust_control` 的 chord 状态逻辑如下：

1. 两个 debounced pressed 同时为1时进入 `chord_active`，清空单键计数并禁用单键动作。
2. 只有两键持续同时按下时 `chord_hold_count` 才递增；任一键在阈值前释放都会清零该计数。
3. 重叠达到1.5秒时设置 `chord_long_done`，但此时还不会发出顶层模式切换脉冲。
4. 两键都经过消抖释放后，才脉冲 `video_mode_press`。因此按下起始时间和松开时间无需精确同步；测试时同时按下、同时松开最容易排除时序歧义。操作中途先松开的按键若打断了1.5秒重叠，最后完全松开时不会切换模式。

这解释了“按住时视频继续播放”：视频模式切换信号在双键完全松开后产生。建议在正常播放时把两键同时按住约2秒，再同时松开并等待；不用在长按期间预期画面立即变化。

## 单键和邮箱确认链

- 单个短按也在消抖后的释放沿触发。KEY0 对应的 `key0` 短按在 `MODE_PLAY` 下切换 next-request toggle；KEY1 对应的 `key1` 短按切换 auto-request toggle。
- 分类器通过 toggle mailbox 跨入 `sd_card_clk` 域。`key_event_mailbox_sink` 两级同步请求；检测到 toggle 变化时更新 ack toggle 并发出一个周期 press pulse。分类器再把 ack 两级同步回来，以 `request != ack` 标记邮箱忙。尚未确认的请求会被 `next_pending/auto_pending` 保留。
- 顶层按当前 `video_mode` 在 photo 和 video 的 ack 间选择。视频模式下，`video_next_press` 会在 SD 时钟域翻转 `video_restart_toggle`；photo 模式下同一 next 事件交给 BMP 图片播放器。视频模式下 `video_auto_press` 切换暂停状态。
- 顶层仅在 `video_mode_press` 时翻转 `video_mode`。视频模式里的单短 KEY0 只请求重启当前媒体，不直接切换到 photo 模式。

## C22 短按造成 UI-only 的机制

C22 的 `rst_all = rst_all_reg | media_reset_active`。相较 C23/C24，C22 的 catalog 与 SD card 实例也接 `rst_all`；视频 reader、mapper 与媒体消费者同样复位。视频模式下收到 KEY0 next pulse 后，顶层触发 `video_restart_toggle`；像素域同步到该 toggle 后脉冲 `media_reset_active` 32个 `video_clk` 周期。此时 `video_mode` 保持当前值，C22 的 card 和 catalog 同时重新复位并重新初始化/挂载。

所以 `2BDXX000` 中 file_flags=`BD` 表示 mounted、文件找到、画面有效、video mode和WAV primed；`20400000` 中 file_flags=`04` 表示 video_mode 位仍为1，而 `fs_ready`、文件查找、display_valid、WAV primed为0。后者与 C22 视频模式重启后的重新挂载/装帧窗口相符。这个读数说明处于视频模式且媒体链尚未恢复，不表示模式已切换到 photo。C22 的重新加载恢复证明当前板卡有可播基线；短按 KEY0 后的 UI-only 窗口体现 C22 媒体重启期间 card/catalog 会一同复位。

## 直接可验证的按键假设

1. 视频正常播放时先记录一页正常 `2BD...`；两键同时按住约2秒，再同时松开。长按期间预期视频仍播；松手后预期 `video_mode` 位翻转。若切到 photo，状态页 file_flags 的 bit2 应从1变0；若从 photo 切回 video，则应从0变1。C22 会在切换期间重启 card/catalog，应等待挂载和画面恢复后再读稳定页。
2. 视频模式单短按 KEY0 后，观察 page1：`video_mode` bit2应保持1，`fs_ready` bit7会暂时为0，之后重挂载时恢复为1。该签名可区分媒体 restart 与 mode toggle。
3. 若双键短按后无切换，或长按松开后 video_mode bit2始终不变，优先检查两键是否都按到有效低电平、消抖后重叠时长是否超过约1.52秒，以及两键是否最终都松开；之后再考虑邮箱 ack/时钟域状态。

物理按键“KEY0/KEY1”与顶层逻辑 `key1/key2` 的命名不同；本记录按 C22 顶层端口连线说明，不要求用户重新提供接线或音源信息。

## 源码位置

- `development/player_video22_audio_diag/src/user_source/hdl_source/player_adjust_control.v`：同步/消抖、HOLD_CYCLES、chord 进入/计数/松开触发、单键释放沿请求与 pending/ack。
- `development/player_video22_audio_diag/src/user_source/hdl_source/top_tf_hdmi_audio.v`：`video_mode_press` 翻转 mode；`video_next_press` 视频媒体重启；C22 card/catalog 使用 `rst_all`；控制器输入映射。
- `development/player_video22_audio_diag/src/user_source/hdl_source/tf_bmp_file_player.v`：`key_event_mailbox_sink` 及图片播放器的请求/ack。

本轮仅完成源码核对和实验建议；未修改按键 RTL、运行新仿真或生成新位流。音频杂音仍未定位，按键调查也不能解释该噪声。
