# C25 实板无 HDMI 信号调查

日期：2026-10-22。状态来源为父任务转述的实板反馈与本地只读工程核对。

## 现场与页值

- 用户反馈：加载 C25 后 HDMI 无信号、无背光；状态显示 `00C11325 / 20000000 / 00000000`。
- `00C11325` 是 compact status page 0 的常量 build ID；状态页每 25,000,000 个 `video_clk` 周期轮转。该 ID 每轮都会出现，单独出现时不能表明刚发生冷复位。
- 页1 `20000000` 表示其余状态字段均为0：`fs_ready=0`、`fs_error=0`、WAV/视频文件均未报告找到，photo/video 状态及文件错误旗标为0。
- 页2 `00000000` 表示 SD CRC checked/bad 都为0，即尚无已完成并检查的 SD 数据块。
- 页1、页2持续轮转意味着状态计数时钟 `video_clk` 有活动，`rst_all` 在轮转期间没有持续为高。它证明复位已释放且像素时钟计数器在运行，不足以证明 HDMI 5×串行时钟、TMDS 引脚波形或接收端锁定正常。

## 源码与时钟/复位核对

C25 相对 C23 有两处用户源差异：SD 初始化控制器移除 CMD16 状态，compact status 页更新 build ID；其余121个用户源一致。C25 保留 C23 的 SPI 高速分频0、媒体重启与运行期读 gate。SD controller/catalog 的冷启动复位为 `rst_all_reg`；mapper 与媒体读者使用 `rst_all = rst_all_reg | media_reset_active`。C25 的静态复位/时钟结构与 C23 一致。

Top 级 `video_pll` 分别产生 25 MHz `video_clk` 和 125 MHz `hdmi_5x_clk_raw`。`rst_all_reg` 只有在 `sys_pll_lock && video_pll_lock` 连续稳定20ms后释放；释放后代码忽略后续 lock 抖动，不再自动拉回。状态页计数证明 pixel clock 运行过，仍需单独验证串行时钟与 HDMI 输出端活动。父任务提供的 [C22/C23/C24/C25 routed PLL 参数和端口对照](c25_routed_pll_comparison.json)显示两颗 PLL 的参数和 raw port 映射一致；此核对不测量板上实际振荡。

`fs_ready=0` 时 C25 的 `shared_card_read` 选 `fs_read` 挂载请求，运行期 `mode_gate_new_sector` 不参与这一路选择。因此当前页值对应的挂载阶段停顿，不能由运行期 quiesce gate 单独解释。CRC仍为0且 `fs_error=0`，页值没有暴露 `card_init_done` 或具体 SD 命令状态，当前读数只能定位到“首个完整 SD 扇区尚未完成/挂载未就绪”，还不能区分卡初始化等待与首个 CMD17/数据完成等待。

源码行为变化集中在 SD 初始化；HDMI 逻辑源没有对应改动。小源差异可能改变整体布局布线，当前状态不能把 HDMI 失效直接归因于 CMD16。C25 离线系统回归通过4次模式切换；测试使用 qualified nominal PLL edge replay，未覆盖板上 PLL、TMDS 信号和显示器锁定。

## 最终时序报告阶段

`src/td_project/final_timing.rpt` 时间为14:40，是 physical 阶段 hold 修复前报告，显示 HWNS -0.020ns、HTNS -0.051ns。交付 bit 绑定到14:46完成的 hold 阶段；最终报告为 [AC201_tf_hdmi_pr.timing](../player_video25_sdhc_init/build/manual/AC201_tf_hdmi_pr.timing)，结果 SWNS +0.256ns、HWNS +0.030ns、TNS均为0。最终位流 SHA256 为 `12174ebedd65a438427a79708a9224cff1c880b8bd28b6cb1f7963f81c699cc5`。两份报告来自不同阶段，最终判断采用与交付 bit 绑定的 post-hold 报告。

C25 最终约束文件派生了内部时钟，但未见 HDMI 输出 delay；当前 routed STA 结果描述芯片内约束路径，不覆盖 HDMI 接收端的板级时序测量。

## 下一步建议（尚未执行）

先等待用户重载 C22 并确认已知可播基线。后续从 C22 增加最少量只读诊断，优先显示/计数 `sys_pll_lock`、`video_pll_lock`、`rst_all_reg`、`media_reset_active`、`card_init_done`、CMD0/CMD8/CMD55/ACMD41/CMD17 计数、`fs_ready/fs_error` 与 CRC checked/bad。先用这些观测明确卡初始化、首次扇区、复位和 PLL 阶段，再设计单变量 C25 对照；不叠加新的初始化或模式切换算法改动。本轮没有修改任何生产源、构建或位流。
