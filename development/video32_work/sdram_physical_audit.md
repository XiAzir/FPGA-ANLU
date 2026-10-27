# C31 SDRAM/时钟物理路径审查

审查日期：2026-10-23  
对象：`player_video31_audio_ablation`（C31）与 `player_video29_media_flow`（C29）

## 结论

C31 的 SDRAM 控制器使用器件内部 `EG_PHY_SDRAM_2M_32` 硬宏，连接走向为 `frame_buffer_rgb888 -> frame_read_write -> sdram.v/u2_ram -> EG_PHY_SDRAM_2M_32`。因此这里的关键物理链路位于 FPGA fabric、PLL 和内部硬宏。

现有 C31 routed STA 没有显示硬宏 DQ 采样时序失败：`ext_mem_clk_sft -> ext_mem_clk` 硬宏 DQ setup slack 为 +1.572 ns，hold slack 为 +12.392 ns；C31 路由 QoR setup/hold WNS 分别为 +1.036 ns / +0.004 ns，均无违例端点。SDRAM fabric 的 `ext_mem_clk -> ext_mem_clk` 最差 setup slack 为 +8.418 ns。由此，静止画面稳定、动画/视频出现水平细条，目前更符合动态并发负载下的回填/读 FIFO 供数不足或读写调度边界问题；当前 DQ setup/hold 报告保持正裕量。

仍有两个值得优先验证的物理/约束风险：一是 C31 硬宏 DQ setup 正裕量只有 1.572 ns，且报告由 routed corner 得出，建议保留裕量回归；二是源代码的 `Clk_sft` 和 `Clk` 由同一个 PLL 输出，SDC 通过 `derive_clocks` 与 `rename_clock` 识别二者，报告把 8 ns 相移正确地计入了宏 DQ 路径。现有位流和报告可证明工具模型中的时序关系，无法证明芯片上的 PLL 实际相位误差、温漂及硬宏行为模型与实物完全一致。

## 核对证据

- C31、C29 的 `timing.sdc`、`pin.adc`、`IP/sdram.ipc`、生成的 `IP/sdram.v`、`IP/sdram.vhd`、`IP/sys_pll.ipc`、`IP/video_pll.ipc`、`SD/sdram.v` 均逐文件哈希相同。C31 与 C29 使用相同的 SDRAM PHY、器件配置、板级 pin 和时钟 PLL 配置。
- `IP/sdram.v` 只实例化 `EG_PHY_SDRAM_2M_32`，它不暴露外部 SDRAM pin assignments；`pin.adc` 中也没有 SDRAM 信号。SDRAM PHY 的 `clk` 接 `Clk_sft`，控制器 `Sdr_clk` 接 `Clk`。
- `sys_pll.ipc` 与生成的 `sys_pll.v` 给出 50 MHz `clk1`（0°）和 50 MHz `clk2`（144°，20 ns 周期下相移 8 ns）。SDC 以 `rename_clock` 将 PLL 输出命名为 `ext_mem_clk` 和 `ext_mem_clk_sft`，并未将两者设成异步或互斥。
- C31 routed `final_timing.rpt` 标记 `Confidence: Routed`、STA coverage 99.99%、Slow/Fast setup 与 hold 均通过。`ext_mem_clk` fabric 自时钟路径最差 setup +8.418 ns；硬宏 DQ 输入 setup 路径 `sdram.dq[*] -> sdram_syn_*.bpad` 最差 +1.572 ns，对应 hold 最差 +12.392 ns。
- C29 routed `final_timing.rpt` 的 `ext_mem_clk` fabric 自时钟最差 +6.582 ns；硬宏 DQ setup/hold 检查同样由相移时钟捕获。C29 route QoR setup WNS +0.709 ns，hold WNS -0.004 ns（1 个 endpoint）；C31 route QoR setup WNS +1.036 ns，hold WNS +0.004 ns（0 个 endpoint）。两个已布线版本的全局裕量差异较小；该对比本身无法区分画条成因。
- C31/C29 的 `frame_buffer_rgb888.v`、`SD/frame_read_write.v`、`SD/frame_fifo_read.v` 差异只有 C31 移除了部分 debug 输出与连线。关键数据延迟参数仍为 `SDR_READ_CAPTURE_DELAY=0`、`SDR_READ_DATA_DELAY=1`；SDRAM FIFO/请求状态机主体一致。C31 netlist 面积降低（88.58% slices，C29 94.23%），SDRAM 与 PLL 宏配置未变。
- `frame_read_write.v` 的读 FIFO burst refill 以 512 深度异步 FIFO、低于 256 words 触发下一次读为主；读 FSM 还会受 `App_wr_busy` 抑制。写侧 `write_buf` 也是 512 深度；写请求和读请求经独立 FSM 竞争同一个 SDRAM 控制器。`frame_buffer_rgb888.v` 在视频 JPEG420 模式下为每两个像素打包一个 32-bit word，切换 wipe 显示会持续从 SDRAM 回读活动帧。C31 的静止图像无条、切换动画有条、视频更明显，与动态读 FIFO 被并发写入/读请求挤压的表象相符，但当前 RTL 与 STA 报告尚未包含 FIFO underflow 的实测记录。

## 可验证的修复与定位方向

1. **先做运行时证据采集。** 在视频读时钟域计数 `read_fifo_empty && read_pixel_en`、`read_underflow` 和 wipe 活动周期；在 `mem_clk` 域采集 `App_rd_en`、`App_wr_en`、`mem_busy`、读 FIFO `wrusedw` 低于安全阈值的次数、write FIFO `wrusedw` 高水位与连续 busy 周期。所有跨域计数先在各自时钟域累加，再用双触发器同步快照或停帧读出。用同一素材分别跑静止、wipe、视频三组，按每帧/每行留存计数。
2. **作单变量流量隔离。** 暂停新帧写入但保持视频读出，再保持写入而取消 wipe，观察条纹和 underflow 计数是否同步消失。此实验可区分内存带宽/调度争用与 DQ 物理采样问题，无需改变 PHY。
3. **读 FIFO 回填留足提前量。** 若 underflow 与读 FIFO降到空相关，将 `frame_fifo_read` 的 refill 门限从约半 FIFO（当前 `wrusedw < FIFO_DEPTH-BURST_SIZE`，即 256 words）提升到更早的水位，并在读请求发出至首 word 返回期间保留足够余量；验证连续写流、视频与 wipe 同时运行时不触底。门限需结合 FIFO IP 实际可用深度及请求/返回延迟确定。
4. **核实 busy 仲裁公平性与操作重叠。** 明确 encoded 控制器在 read/write 同时请求时的优先级及 refresh 插入行为；当前源码只能看到写读 FSM通过 `App_wr_busy` / `App_rd_busy` 互相门控，底层 `sdr_wrrd.enc.v` 为加密实现，优先级可查官方 IP 说明或通过真实请求波形测得。必要时在写入完成/安全行边界暂停写入，让视频读 FIFO先补满，再恢复写入。
5. **把 PHY 裕量做成独立回归项。** 保留同一器件、PLL 和路由版本，单独扫 `Clk_sft` 相位（例如以 8 ns 为中心小步进）并比较所有硬宏 DQ bit 的 slow setup、fast hold 与实际板测稳定性。相位试验仅作为后续候选构建；保持相关 PLL 时钟的真实相位关系进入约束。
6. **保持 C29/C31 的动态读路径对照。** C29 和 C31 的 SDRAM PHY及请求状态机源相同；若同素材下只有 C31 位流复现，则重点核对 C31 top 的 `read_pixel_en`、wipe 状态/地址映射与帧提交时序是否造成突发读负荷变化，以及它们是否与写 FIFO非空同时出现。当前 C31 观察中视频加重条纹，正适合作为压力场景。

## 边界与下一步

本次审查基于 RTL、约束和既有 routed 报告；未运行 TD、仿真或改动冻结工程。硬宏内部实际读写行为及实板 PLL 相位尚无独立观测数据。建议先制作低资源运行计数诊断位流，确认条纹窗口是否伴随读 FIFO 欠载，再依据结果调整 refill 水位或读写仲裁。



