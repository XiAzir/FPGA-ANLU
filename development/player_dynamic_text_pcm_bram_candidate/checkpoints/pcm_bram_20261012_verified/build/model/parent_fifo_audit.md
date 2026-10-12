# C11108 WAV FIFO 只读审计

日期：2026-10-11（依据工作区已有源码、C11108 prehold 网表时序/面积报告与成功 `player_osd_phy_fix` 报告）

## 结论

1. **确认的结构风险：** `tf_wav_file_player` 的 FIFO 不是一个简单的独立 BRAM FIFO 接口。`fifo_mem` 使用寄存器数组、动态写地址、动态读地址；同一个控制时序块同时管理写入、`fifo_head` 预取和环形指针。C11108 后布局时序中，`fifo_mem_n_syn_*` LUT 节点位于 WAV 播放路径，`rd_ptr_b1[*]` 和 `fifo_head_b3[14]` 的扇出约 1026。可确认的是大型地址/选择网络及高扇出真实存在；仅凭全芯片 BRAM 汇总不能断言数组本体完全没有 BRAM 映射。
2. **它不能单独解释 C11108 与 `player_osd_phy_fix` 的板级差异。** 两份播放器的 FIFO 功能 RTL逐行等价（C11108 多了无反馈的 debug alias），成功版本的映射日志同样有 `fifo_mem_n_syn_*` LUT 读路径及 1026 扇出指针。故此结构是值得在 C11109 消除的既有风险，不是已证实的 C11108 新回归或无 HDMI 信号根因。
3. **CRC 不等也尚不足以判定 FIFO 内容损坏。** 探针 source/fifo/HDMI 窗口都按各自 `valid` 次数跳过 65536 后采 32768 个样本；页面确认两路 done、HDMI count=32768、源文件 offset/首个 high-byte 位置正确，HDMI CRC 又等于 FIFO CRC。但没有在 pop 端采集实际 WAV 样本 ordinal/offset。因此如果 FIFO 在窗口开始之前曾丢/重样，两个 CRC 可能覆盖不同绝对 ordinal。现在证据使错误落点集中到 FIFO写后/读出或其窗口对齐，尚不能区分这两种情况。
4. 没发现确定的 FIFO reset 或 pop/push 碰撞错误。`fifo_mem` 不复位本身是合理的：reset 把 count、读写指针和 `fifo_head_valid` 清零，空 FIFO 不应读取旧数据。单时钟输入也由源码证实；复位释放时序和异步 BRAM 语义仍应由候选模型覆盖。

## 源码核对

- C11108 [`tf_wav_file_player.v`](../../src/user_source/hdl_source/tf_wav_file_player.v)：第 71–88 行定义 `fifo_mem[0:FIFO_DEPTH-1]`、`wr_ptr/rd_ptr`、计数、`fifo_head`、pop/full 条件及预取/绕过判定；第 92–98 行导出样本与被动 source 观测端口；第 131–145 行同步复位 FIFO 状态、写内存、移动指针/计数、更新 head 并置错误标志。Top 在 [`top_tf_hdmi_audio.v`](../../src/user_source/hdl_source/top_tf_hdmi_audio.v) 第 332–345 行以 `sd_card_clk` 驱动播放器。
- 成功版本 [`tf_wav_file_player.v`](../../../../player_osd_phy_fix/src/user_source/hdl_source/tf_wav_file_player.v)：对应 FIFO 行为为第 69–86、90–91、124–138 行。除参数行偏移和 C11108 新增 debug 端口/赋值外，内存、指针、count、prefetch、bypass、pop/push 行为相同。
- [`wav_pcm_bridge.v`](../../src/user_source/hdl_source/wav_pcm_bridge.v) 第 15–44 行在 `sd_clk` 域同步 request toggle、取 `sample_data` 并脉冲 `sample_take`，用稳定 mailbox/ack 返回；第 46–91 行在 `pixel_clk` 域消费 mailbox 并产生 `audio_valid`。Top 第 376–384 行把播放器 FIFO 端接在 `sd_card_clk`。因此未发现 `sample_take` 或 FIFO 指针/内存端直接跨域；probe pop CRC 也在 SD 域，HDMI CRC 在 pixel 域。
- [`player_pcm_prefix_probe.v`](../../src/user_source/hdl_source/player_pcm_prefix_probe.v) 第 64–74 行用独立 `pcm_prefix_crc` 观察 `push_valid`、pop_valid 和 `audio_valid&&!tone_mode`；第 14–35 行每个实例独立按 valid ordinal 跳过并计数；第 76–107 行记录源首个哈希样本位置、同步冻结 CRC，并报告早 tone abort。source 首位置/offset 证实 data offset=44 与窗口首 high-byte=131117；fifo 侧没有等价的 absolute ordinal/offset 观测。

## 网表与时序证据

- C11108 [`synthesis_console.log`](../manual/synthesis_console.log) 第 213–216 行报告展开 `tf_wav_file_player`，并出现 `extracting RAM for identifier 'fifo_mem'`。这表示综合前端识别出数组 RAM，不等价于最后一定映射成专用 BRAM。
- C11108 [`AC201_tf_hdmi_pr.timing`](C11108/AC201_tf_hdmi_pr.timing) 第 25–29、45–49 行：全局 SWNS=+0.633ns，HWNS=-0.008ns、HTNS=-0.014ns；SD 域 max path slack=+1.087ns，min 分析有 4 个违规端点。第 85–173 行的 WAV 路径经过多个 `fifo_mem_n_syn_*` LUT，再到 `ramread0_syn_*` DRAM(reg)；另见其第 201–207 行到 `fifo_head` 的 13 逻辑级路径。
- C11108 [`physical_console.log`](C11108/physical_console.log) 第 70–74 行报告 8601 LUT / 7758 seq / 19 BRAM；第 175–180 行给出 `fifo_head_b3[14]`、`rd_ptr_b1[0..3]` 等 1026 扇出。[`AC201_tf_hdmi_phy.area`](C11108/AC201_tf_hdmi_phy.area) 第 10–20 行报告 16825 LUT、19 个 BRAM9K、0 FIFO9K。资源总数不具备 FIFO 实例级归属信息。
- 成功 [`player_osd_phy_fix` 的 `physical_console.log`](../../../../player_osd_phy_fix/build/manual/physical_console.log) 第 63–67、169–173 行也有约 8757 LUT、19 BRAM 与 `rd_ptr` 1026 扇出；其 [`AC201_tf_hdmi_pr.timing`](../../../../player_osd_phy_fix/build/manual/AC201_tf_hdmi_pr.timing) 第 3590–3598 行可见同名 `fifo_mem_n_syn_*` LUT 路径。成功报告全局 HWNS=+0.030ns、HTNS=0（同报告第 25–29 行），C11108 有少量 min 角违规，但两份版本构建阶段/布局条件并非严格配对，不能据此确定这解释实板无信号。

## 风险判定边界

- **有网表证据：** FIFO 前后有 LUT 地址/读数据选择逻辑且指针/输出高扇出；C11108 的综合时序余量紧，存在少量快角端点 violation。值得改为时序定义清晰的同步读 FIFO，并核验最终 RAM 推断与时序。
- **未证实：** `fifo_mem` 全量映射成 LUT、CRC `F485 -> D2D6` 一定是 memory corruption、首 65536 个 push 和 pop ordinal 一定相同/一定不同、复位或同时读写一定出错、上述 FIFO 结构造成 C11108 HDMI 无信号。成功版本同样有 FIFO 选择 LUT 网络，而且真实板级成功。
- **并行包数字的含义：** `push` CRC=host `F485`、FIFO/HDMI 同为 `D2D6` 且 `done` 成立，证明观察器采到了完整定长窗口及 HDMI 窗口与 FIFO 窗口内容相同；不证明 FIFO 窗口的绝对文件 ordinal 正确。因为 `player_pcm_prefix_probe` 的三个计数器独立按本地事件推进，建议下一版加入 FIFO pop 端的样本 ordinal/首尾位置，或把 ordinal tag 与样本一起穿过 FIFO，以验证 source index 与 pop index 一一相等。

## C11109 最小同步 BRAM FIFO 规范与模型验证

### 实现约束

- 保持 FIFO 单时钟 `sd_card_clk`，仅把存储/读口改成明确的同步 BRAM 读写端口。RAM 数组独立时序写、独立时序读；不在 reset 清 RAM；数据只在 `valid/count` 允许时消费。
- 用显式 `rd_pending`/head-valid 处理一拍读延迟：请求有效数据后下一周期置 head valid；不能组合索引整块数组驱动 `sample_data`。可继续由一个小 head/skid register 对外提供稳定数据。
- 明确 `push_accept = push_req && (not_full || pop_accept)`，`pop_accept = sample_take && sample_available`，计数同周期 push/pop 净变化。完整定义空、满、同时 push/pop、指针回绕和首字预取；同址读写使用显式 write-forward/bypass，不能依赖厂商未指定 read-during-write 模式。
- 复位保证 count=0、指针归零、pending/head-valid清零、sample_available=0；复位期间忽略 push/pop。ready/full/empty 优先由状态保证，错误采样或过载不得静默覆盖有效样本。
- 探针计数加上 `push_ordinal` / `pop_ordinal` 对齐，最好保存绝对 source ordinal/PCM位置随样本进 FIFO，并在每次 pop 比较；仅 CRC16 相等也可能碰撞，ordinal 与定点数据逐样本模型检查才有鉴别力。

### 有效模型测试

1. 与当前 FIFO 用同一 deterministic 输入序列做逐样本 scoreboard，多个非整数时钟相位下验证 push/pop 顺序；随机间隔 SD valid，随机请求间隔及长 backpressure，覆盖深度 256/2048。
2. 强制覆盖空转首 push、首读延迟、单元素 pop+push、满状态 pop+push、满状态无 pop 拒绝 push、读写同地址、连续 push/pop、精确地址环回多轮；检查 count 范围、available/head稳定、禁止重复/丢失/重排。
3. 在初始、中途、empty、满、读请求 pending 与同时 push/pop 各状态复位，确认重新开始后不读旧 word、没有幽灵 pop/push，首样本和序号重置一致。
4. 用 WAV host 固定窗口样本逐字节比对 source expected -> FIFO pop expected -> bridge/HDMI 输入 expected；记录首个/末个 absolute ordinal、总 push/pop、underflow/overflow。正常窗口预期 source CRC=FIFO CRC=HDMI CRC=`F485`；可注入 FIFO RAM read/write 单 bit、ordinal skip/repeat fault，确认第一错误端界可定位。
5. 看工具最终 RAM inference/资源报告及约束内时序；模型通过只证明 RTL行为，不等于板级修复。C11108 的板级“无信号”需独立由显示/PHY状态证据处理。

审计范围为只读文件核对；未修改正式源码、未构建、未操作硬件。
