# C11323 模式切换控制独立审查

日期：2026-10-22（北京时间）  
对象：`development/player_video23_mode_switch`。读取 C23 源并用其真实 `player_media_restart.v`、`player_mode_quiesce.v` 运行隔离 TB；没有修改 C23 文件、没有操作硬件，也没有干预 TD 构建。

## 控制 TB

文件 `tb_c23_mode_restart.v` 直接实例化 C23 两个模块；其 runner 在不同 `video_clk`/`sd_card_clk` 相位和频率下重复仿真：

| 视频时钟 | SD 时钟 | 初始相位 | 结果 |
| --- | --- | ---: | --- |
| 25 MHz | 50 MHz | 0 ns | PASS |
| 25 MHz | 50 MHz | 7 ns | PASS |
| 25 MHz | 50 MHz | 19 ns | PASS |
| 26.316 MHz | 50 MHz | 3 ns | PASS |
| 23.810 MHz | 50 MHz | 9 ns | PASS |

每个 case 覆盖：mount_ready 前到来的模式请求被保留，mount 前 gate 不挡 catalog；图片→视频、视频→图片；video 模式下同模式 restart；physical_idle 拉低时 gate 保持、commit 与模式不变；busy 窗口里再发 mode_press 和 restart toggle，不产生额外 request，也没有确认后的延迟重复；commit 后媒体复位恰好覆盖32个 video_clk 周期；reset/ack完成前 gate 持续为高，确认后 mapper 请求可透传。

TB 另用与 top 相同的两级 `video_mode_sd_sync` 和示例照片/视频 sector 地址选择器，检查在物理事务仍活动时选择地址保持；模式只在 quiesce commit 后变化；SD 域地址 mux 更新时 gate 仍为高，直到客户端 reset 完成且 ack 返回才允许新请求。它验证控制和模式 mux 时序，没有实例化 C23 整个 `fat32_dual_file_sector` 或 top。

可复跑：`run_c23_mode_restart.ps1`，日志 `c23_mode_restart.log`。全部五种时钟情况各自显示四个事件 PASS 和一个汇总 PASS。

## 顶层连线审查

- `top_tf_hdmi_audio.v:196-208`：pixel-domain `player_media_restart` 与 SD-domain `player_mode_quiesce` 用 request/commit/ack toggle 握手；`card_idle` 与 `fs_ready` 进入 quiesce。
- `top_tf_hdmi_audio.v:252-253` 与 `547-553`：FAT catalog 和物理 SD 控制器都由 `rst_all_reg` 冷启动复位驱动，媒体切换 reset 不会重启卡或重新挂载。
- `top_tf_hdmi_audio.v:542-545`：`fs_ready=0` 时 `fs_read` 原样送卡，保证初始挂载；挂载后只抑制 mapper 的 `arb_card_read`。mapper 的 `arb_card_valid/end` 保持直通，已接受的 sector 可完成并结束握手。
- `top_tf_hdmi_audio.v:288-300`：图片/视频文件起簇、长度、读请求、地址和缓冲选择均按同步后的 `video_mode_sd` 选择。`video_mode` 只在 SD peer 提交时变化，SD 域 mux 约两拍后更新；到该时刻旧扇区已结束，gate 仍保持到 reset/ack 完成。静态检查没有发现地址在已接受扇区期间提前翻转或 gate 阻断返回数据/end 的问题。
- `top_tf_hdmi_audio.v:301-350`：视频播放器、reader、mapper等媒体客户端由 `rst_all` 清理；catalog 保持 ready。物理卡控制器保持工作，期间可用 `sd_idle` 安全判定扇区边界。

busy 窗口内的新 mode_press/restart toggle 会被 `player_media_restart` 忽略，因为它只在 `request_toggle == ack_toggle` 时接受事件；本 TB 确认此策略不会造成重复 commit、卡死或旧事件稍后重放。若产品要求忙时排队多次按键，这一接口当前没有队列。

## 风险与证据边界

C23 的 `media_reset` 在 video_clk 域生成并通过 `rst_all` 广播到 SD/write、SDRAM/mem 和 pixel 多个时钟域。`frame_read_write.v` 的 write-ready 复位同步器、SDRAM数据寄存器及 `frame_fifo_write.v` 状态使用异步 reset 断言；它们观察同一个 video 域 deassert，未见按 mem/write 时钟分别同步释放的 reset synchronizer。32 pixel 周期脉冲保证各域能看到复位，但不保证 asynchronous reset recovery/removal 窗口满足每个域时钟。数字 TB 证明 pulse 宽度和握手时序，无法模拟实际亚稳或 recovery/removal 违例；应把该 CDC 风险单列，结合 C23 STA/CDC工具与有界板测评估。

本轮 C23模块 TB 没有串接真实 SD 卡 transaction。真实生产 SD controller/catalog 的六相 drain 证据仍在此前 `sd_quiesce_integration.log`，使用 C22时期的 quiesce模块副本与已知模型；因此 C23 端到端的文件 sector、CRC、catalog 持续运行仍需 C23集成仿真/实板确认。父任务正在运行 C23 build，此报告不将它标记为完成。
