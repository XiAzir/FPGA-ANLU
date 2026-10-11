# AXIS 观察器集成独立审查

结论：**PASS（附计数口径说明）**。候选与 video_probe 基线的 user_source 差分为 74 个公共文件内容不变、2 个公共文件修改（top、status monitor）、1 个新增 AXIS 观察器。状态显示器的 24 位 payload 和 flags 经真实 `player_status_monitor` 仿真逐页核对通过。顶层观察器仅读取 HDMI 发送器输入端 AXIS 信号，没有驱动发送器、视频源、复位、音频或播放控制。

## 基线差分与生产链路

对两版 `src/user_source` 做相对路径和 SHA-256 比较：video_probe 有 76 个文件，axis_probe 有 77 个。基线全部 76 个文件都存在于候选；其中 74 个逐字节相同，唯一新增 `hdl_source/player_axis_input_probe.v`，唯一改动文件为 `hdl_source/top_tf_hdmi_audio.v` 和 `hdl_source/player_status_monitor.v`。pin、SDC、PLL、RGB-to-AXIS 转换器、图像/SD/音频/控制模块都与旧版哈希一致；选取的代表性 SHA-256 和完整计算范围见 JSON。

顶层差异只有 `packet_cts` / `packet_n` 从20位扩到24位，以及用被动 `player_axis_input_probe` 替代原被动 `hdmi_packet_monitor`。新实例直接取 `axis_s_valid/user/last`、`axis_s_ready`、`hdmi_video_locked`，位置在 HDMI core 接口后；它的输出只连到状态页 payload wires。AXIS converter、HDMI core、PHY、PLL、状态/播放复位、SD、帧缓存、音频和按键控制连线保持原样。status display 与 observer 在同一个 `video_clk` 域，新的诊断寄存器没有跨域直读问题。

## 数码管页面解释

监视器实际内部页面索引为0..8；上电自检会先输出 `01234567`、`88888888` 两种图样。正常显示的左首位是页面代码，并非页索引：

| 页面代码 | 显示内容 |
| --- | --- |
| `1` | 同步后的启动 flags、文件 flags、文件系统和 WAV 映射码 |
| `3` | 原有音频 mailbox：tone、underflow、HDMI lock、见过 SOF flags 与音频样本计数 |
| `6` | observer flags、最近一行有效宽度、最近帧行数 |
| `7` | observer flags、帧间周期数 |
| `8` | observer flags、帧有效像素数 |
| `9` | observer flags、坏行数、坏帧数 |
| `A` | observer flags、帧内 blank 周期数、`valid && !ready` 周期数 |
| `B` | observer flags、帧内 TLAST 观察次数 |
| `C` | observer flags、合法 USER 帧数、异常 USER 数 |

代码 `B` / `C` 当前都由 `{4-bit page, 4-bit flags, 24-bit payload}` 组成；无填充/截断。对 `packet_cts=packet_n=24'hABCDEF` 和 `flags=4'hA`，实际输出分别为 `32'hBAABCDEF`、`32'hCAABCDEF`。代码 `1` 与 `3` 保留现有显示行为，仿真分别检查启动/文件状态和已由 AXIS SOF 触发的音频 mailbox。正常运行时内部页按 `0..8` 循环，即上表的 `1,3,6..C` 九个显示代码；按根代理指示，“13轮”理解更正为至少重复完整页循环，本模型覆盖三轮。

## 模型验证

新增定向测试使用真实 `player_status_monitor` RTL；把 `PIXEL_HZ`、`SYS_HZ` 缩放为4，`PAGE_SECONDS=1`，保留 self-test。测试编译和运行成功，日志为 `PASS: 2 self-test patterns; startup/audio pages; three complete 9-page rounds; full 24-bit page B/C payloads and flags.` 从候选工程目录执行 `pwsh -NoProfile -File sim/status_axis/run_status_axis_model.ps1` 可复现；命令参数、参与源码 SHA-256 和完整输出保存在候选的 `build/status_axis_model/`。

之前存档的 observer 三帧模型没有重跑；静态复核候选 `sim/axis_probe/tb_axis_probe.v` 与 `build/axis_probe_model/run.log`：它连接实际 `video_timing_data -> video_delay -> video_rgb_to_axis_640x480 -> player_axis_input_probe`，SDRAM 像素由递增像素代替；日志 PASS，核对 640×480、420000 周期、307200 valid 像素、行间 blank 160、TLAST=0、错误计数为0，并有定向 USER/ready/饱和用例。该链路的三帧观测说明模型覆盖了重复帧边界。

## 解释边界

计数器按 `valid` 周期累计 `pixel_count` 和 `line_width`；READY 不为1时不从这两项中扣除，`valid && !ready` 则单独累计到页面 A 低12位。因此页面6..9反映发送器输出端提供的信号周期，不代表接收端成功握手的像素数。AXIS converter 没有 ready 输入，该 observer 是只读观察器；使用这些值定位问题时应结合页面 A 的 READY 低周期计数。数码管只显示十六进制页面码和数值，不会自带文本单位；页面字段图例应随板卡/验证说明提供。模型也不证明硬件时序、 HDMI核内部行为、供电或实板显示状态。
