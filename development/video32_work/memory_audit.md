# C31 动态画面横条：帧缓存与 FIFO 只读审查

审查对象：`development/player_video31_audio_ablation`（C31）与 `development/player_video29_media_flow`（C29），限 `frame_buffer_rgb888`、`frame_fifo_read`、`frame_read_write`、`frame_fifo_write`、切图/动画及读写缓冲区所有权。依据用户现象：静态图片正常；切图动画出现闪烁水平细条，视频时更明显；音频、音阶和频谱正常。未运行 TD、ModelSim 或任何综合/布局流程；未改冻结工程。

## 结论

目前已确认一个具体读仲裁缺陷：C31 用固定 10 个 `mem_clk` 周期结束读 burst，没有等足 `BURST_SIZE` 个 SDRAM 返回字。可变延迟 Icarus 压测复现 baseline 在还有 112 个返回 pending 时退出 burst、随后与 BL4 写 beat 重叠，并在新帧清 FIFO 时还有 207 个返回 pending。C32 候选以 issued/returned 双计数后，在同一压力流下无提前完成、无读写交叠，清 FIFO 时 pending 为 0。这为动态水平条提供了直接且可检验的 RTL 机制；实际板级触发仍取决于 SDRAM 尾延迟是否超过旧设计假设。其他需继续观察的两项是：

1. **读 burst 固定延时完成（已由压力测试复现）**：C31 [frame_fifo_read.v:76-83](../player_video31_audio_ablation/src/user_source/hdl_source/SD/frame_fifo_read.v#L76) 通过 `rd_vld && rd_delay==10` 宣告完成，`Sdr_rd_en` 虽在端口表中输入，但模块逻辑未读取它，也未参与完成计数。若最后一个返回字晚于该 10 拍，控制器会提前退出 `S_READ_BURST`。结果可能是：writer 把 `O_rd_busy` 变低后发起 JPEG BL4 写；reader 下一轮 refill 或新帧 ACK 清空读 FIFO；旧响应仍在途。隔离服务模型中 baseline 在 cycle 298 尚有 112 字 pending，在 cycle 568 尚有 216 字 pending。C32 候选 [frame_fifo_read.v:72-80](../player_video32_read_return/src/user_source/hdl_source/SD/frame_fifo_read.v#L72) 按实际返回字计数，并以 issued 与 returned 都达到 256 为完成条件，同一测试未提前释放。
2. **每帧读 FIFO 清零的跨时钟释放**：C31 `frame_fifo_read` 在读请求应答阶段拉高 `fifo_aclr`，经 `frame_read_write` 同时连到异步 FIFO 的 `rst` 和像素时钟域解包器的 `rst`。它由 `mem_clk` 状态机生成，却在 `read_clk` 域释放；若释放沿靠近像素时钟或 IP 对异步清零释放有要求，可能在新帧开头丢字/错相。静态显示也经过同一条路径，因此它只能解释“偶发或动态时更容易触发”，需要示波/仿真计数确认。
3. **SDRAM `Sdr_rd_en` 与 `Sdr_rd_dout` 的采样相位选择**：C31 framebuffer 明确选 `SDR_READ_CAPTURE_DELAY=0, SDR_READ_DATA_DELAY=1`（[frame_buffer_rgb888.v:9-11](../player_video31_audio_ablation/src/user_source/hdl_source/frame_buffer_rgb888.v#L9)），即有效信号用当前拍、数据用上一拍。若实际 SDRAM IP 的数据/valid 相位与该假设不符，读 FIFO 会间歇写入重复或相邻错位数据；视频连续运动比静态内容更容易看出。C29 已使用同样选择，所以这项是版本共用的风险，不是 C31 新引入的差异。

对普通 FIFO 满/空阈值未发现直接溢出证据：读控制器实际参数从 `frame_read_write.BURST_SIZE=256` 传播到 `frame_fifo_read`（[frame_read_write.v:10](../player_video31_audio_ablation/src/user_source/hdl_source/SD/frame_read_write.v#L10)、[frame_read_write.v:206-214](../player_video31_audio_ablation/src/user_source/hdl_source/SD/frame_read_write.v#L206)），所以 `FIFO_DEPTH=512` 时低水位门限是 `wrusedw < 256`，实际补读突发为 256 字（[frame_fifo_read.v:76-82](../player_video31_audio_ablation/src/user_source/hdl_source/SD/frame_fifo_read.v#L76)、[frame_fifo_read.v:218-243](../player_video31_audio_ablation/src/user_source/hdl_source/SD/frame_fifo_read.v#L218)），不是 128 字/384 门限。一帧 RGB888 长度 `640/4*3*480=230400` 字，RGB565 长度 `640/2*480=153600` 字，两者都是 256 的整数倍（[frame_buffer_rgb888.v:40-45](../player_video31_audio_ablation/src/user_source/hdl_source/frame_buffer_rgb888.v#L40)）。由于条件仅规定“当前 usedw 小于 256”，没有规定补读启动时 FIFO 至少还剩多少字；它可能已接近空，不能据 256 字突发量推得固定的 256 字延迟裕量。

## C29 与 C31 版本差异

这几份缓存/控制源码在 C29、C31 中基本一致；本次 `git diff --no-index --numstat` 结果：

- `frame_buffer_rgb888.v`：C31 移除若干 debug 输出端口与连线；有效读写映射、FIFO、读取模式与 SDRAM 调用逻辑相同。
- `SD/frame_fifo_read.v`：仅移除 `debug_read_state` 输出。
- `SD/frame_read_write.v`：仅移除读状态、读 valid、读字的 debug 输出。
- `SD/frame_fifo_write.v`、`SD/sdram.v`：两份文件相同。

所以这几项算法隐患 C29 也有。用户观察到 C29 正常而 C31 有问题，说明更应查 C31 上层新增的动画时序/显示读请求频率、当前构建实际综合绑定的源文件，和数据/valid相位是否恰好变化；不能把同名源码的相似当作板上二进制完全一致的证明。

## 按优先级的具体可疑点

### A. 异步 FIFO 清零释放

- [frame_fifo_read.v:186-214](../player_video31_audio_ablation/src/user_source/hdl_source/SD/frame_fifo_read.v#L186)：`S_ACK` 时 `fifo_aclr<=1`，请求撤销后在同一状态拉低并转入 `S_CHECK_FIFO`。
- [frame_read_write.v:113-114](../player_video31_audio_ablation/src/user_source/hdl_source/SD/frame_read_write.v#L113)：直接把 `read_fifo_aclr` 分发到 `read_fifo_clear`。
- [frame_read_write.v:190-203](../player_video31_audio_ablation/src/user_source/hdl_source/SD/frame_read_write.v#L190)：`read_fifo_aclr` 接 `rfifo_32_32_512.rst`；该 FIFO 写端是 `mem_clk`，读端为 `read_clk`。
- [frame_buffer_rgb888.v:88-103](../player_video31_audio_ablation/src/user_source/hdl_source/frame_buffer_rgb888.v#L88)：同一 `read_fifo_clear` 异步复位 RGB888/RGB565 解包器；解包器也另用 `read_req` 清相位。

触发条件：帧请求握手产生的清零脉冲释放紧邻 `read_clk` 上升沿，或 FIFO IP 要求各时钟域同步释放。影响表现为每帧开始处像素字错位/缺字；若像素解包相位偏移，可能表现为跨整行的颜色/像素带。动态切帧重启该脉冲，连续视频则每帧都经历，因此可以比静态画面更明显。

### B. SDRAM 数据/有效相位

- [frame_read_write.v:116-134](../player_video31_audio_ablation/src/user_source/hdl_source/SD/frame_read_write.v#L116)：采样寄存器每拍无条件保存数据；valid/data 的延迟由两个独立参数选择。
- [frame_read_write.v:190-203](../player_video31_audio_ablation/src/user_source/hdl_source/SD/frame_read_write.v#L190)：FIFO 写使能是 `read_capture_valid`，写入字是 `read_capture_data`。
- C31 framebuffer 参数明确用 0/1，而不是同拍 0/0；确认该参数与最终绑定 SDRAM IP 时序相符。切忌只凭名字判定“data-leading”。

触发条件：实际 `Sdr_rd_en` 与 `Sdr_rd_dout` 相位不匹配配置，特别是 BL4 突发首字/末字或刷新后恢复处。FIFO 字序错误会在画面有强运动、细节密集的视频上更显眼。

### C. Wipe 映射和读/写缓冲区所有权

- [player_osd_state.v:96-136](../player_video31_audio_ablation/src/user_source/hdl_source/player_osd_state.v#L96)：每个显示帧边界推进 wipe 行数；动画期间保留旧显示 buffer，并在末段切为 target buffer。
- [player_wipe_address.v:18-46](../player_video31_audio_ablation/src/user_source/hdl_source/player_wipe_address.v#L18)：wipe 元数据两级同步，在 `frame_ack` 上升沿锁存；地址映射仅将旧缓冲区开头 `wipe_rows * LINE_WORDS` 映到新缓冲区，其余仍读旧缓冲区。
- [tf_bmp_file_player.v:154-161](../player_video31_audio_ablation/src/user_source/hdl_source/tf_bmp_file_player.v#L154)：写入目标选成显示缓冲区另一半；[tf_bmp_file_player.v:239-243](../player_video31_audio_ablation/src/user_source/hdl_source/tf_bmp_file_player.v#L239) 在写完成后才更新显示缓冲区，等待显示释放后再继续下一次切换。
- [frame_buffer_rgb888.v:141-155](../player_video31_audio_ablation/src/user_source/hdl_source/frame_buffer_rgb888.v#L141)：wipe 地址只作用于 SDRAM 读地址，写地址仍使用原 framebuffer 输出。

静态图可正常与这段动画特有映射吻合；若切换期间 `frame_ack` 捕获到错误的旧/新 buffer 或 `wipe_rows` 总线跨域采样不一致，映射边界会出现水平分界或错误行。当前握手留有读请求同步延时，且 wipe 每帧仅按整行递增，因此源码未显示稳定可复现的明显 bank race；应记录每帧锁存的 `(old_base,new_base,cut_words)` 与读地址边界来验证。

### D. 欠载/溢出证据状态

- 读 FIFO 在 `wrusedw < 256` 时请求补读；若当前已读写占用量为 `U` 字，补读首字延迟为 `L` 个 SDRAM 控制时钟、显示端平均消耗率为 `R` 字/控制时钟，则不欠载的必要条件是 `L < U/R`（计入 FIFO 跨域可见延迟、读请求起动延迟时应以实测有效 U 再扣除这部分消耗）。控制器只保证发起时 `U < 256`，理论上 `U` 可逼近 0，因此最坏相位下可保证的额外首字等待裕量为 0。离散周期的精确判据是：从补读发起到首个新字在读端可用的这段时间内，显示端累计 pop 数 `N_pop(L)` 不得大于发起时真实可读字数 `U_actual`；若 `wrusedw` 是滞后估计，需先测出该估计误差并折算为 `U_actual`。平均速率近似 `L < U_actual/R` 只用于初筛；实际安全门限必须测量。对 RGB565，活跃像素每 2 像素消耗 1 字，`R ≈ f_pixel/(2*f_mem)`；RGB888 每 4 像素消耗 3 字，`R ≈ 3*f_pixel/(4*f_mem)`。对应最多剩 255 字时，仅是乐观上限：RGB565 `L < 255/R`、RGB888 `L < 255/R`，实际以触发时 U 代入。
- 像素读取没有把 `read_fifo_empty` 显式回压给 `read_pixel_en`；`rgb888_unpack32`/`rgb565_unpack32` 有 underflow 信号，但 framebuffer 未将它们送到顶层（[frame_buffer_rgb888.v:61-70](../player_video31_audio_ablation/src/user_source/hdl_source/frame_buffer_rgb888.v#L61)）。真实欠载会被解包器吞成零/旧数据，并可能形成细条，现有 C31 顶层观测不到。
- 写 FIFO 通过 `write_pixel_ready` 做背压，容量预留由 [frame_read_write.v:104-108](../player_video31_audio_ablation/src/user_source/hdl_source/SD/frame_read_write.v#L104) 实现；`frame_fifo_write` 等待完整 burst。因此写溢出概率从源码看较低，需核对输入 `write_en` 是否确实服从 ready。

## 最小可检验方案

按能区分候选原因的顺序，先加只读观测量/局部验证，不动 C29/C31 冻结源码：

1. **读空与清零计数**：临时验证副本中，在 `read_clk` 域累计 `read_pixel_en && read_fifo_empty`，在 `mem_clk` 域累计清零脉冲，并用双触发器同步到状态页/ILA。分别运行 100 帧静态图、切图动画、视频。若横条帧出现时 underflow 计数同步增加，优先查 SDRAM 供数；若只在 frame clear 后首行异常，优先查复位释放/解包相位。
2. **固定数据读地址测试**：在独立局部 TB 将 SDRAM 返回字设为地址编码（如数据 `{addr[15:0],~addr[15:0]}`），逐帧断言 FIFO 收到连续地址且帧首字/末字准确；扫 `00/01`、`01/00`、`00/00` 三种 valid/data 延迟组合，记录与真实 IP 模型一致的组合。检查突发交界、清零后首个 4 字、每行地址边界和 frame end。只用综合绑定的 IP 模型/时序说明选配置，不以主观画质选组合。
3. **仲裁与映射边界局部 TB**：在 `frame_fifo_read` 的 `S_CHECK_FIFO`，启动条件只检查 `wrusedw < FIFO_DEPTH-BURST_SIZE` 和 `~App_wr_busy`；代码没有检查 `Sdr_busy` 或 `Sdr_init_ref_vld`（[frame_fifo_read.v:218-233](../player_video31_audio_ablation/src/user_source/hdl_source/SD/frame_fifo_read.v#L218)）。因此低水位成立且 `App_wr_busy=0` 时，即使 `Sdr_busy` 或 refresh 标志为 1，也会进入 `S_READ_BURST` 并随后发 `App_rd_en`。独立 Icarus TB 已验证：usedw=256不补读，usedw=255时 `App_wr_busy=1` 可挡住启动；清除写忙后，在 `Sdr_busy=1`、`Sdr_init_ref_vld=1` 时观察到 7 个 `App_rd_en` beat。该输入/输出层测试不包含 `sdr_as_ram` 响应语义；生产工程的 SDRAM core 位于 `include/sdr_as_ram.enc.v`、`sdr_wrrd.enc.v`、`sdr_init_ref.enc.v`，文件受保护；Icarus 可测试周边开源 RTL，但不能解密/模拟该加密 core，故该测试只证明 `frame_fifo_read` 在这些标志为高时仍发出 `App_rd_en`，不推断 core 会接受、排队或丢弃请求。RGB565 视频写 BL4 的互斥信号能阻止新 burst 同时发起，但 baseline 的 `O_rd_busy` 在固定延时完成后提前拉低，未排空响应时 writer 便可恢复。集成压力台使用真实 `frame_fifo_write.v` 实测 baseline 在 213 个旧读返回 pending 时发出写 beat；C32 候选的返回计数使 `O_rd_busy` 保持到排空，因此同一台未观察到重叠。另对 `FRAME_WIDTH=640, FRAME_HEIGHT=480` 按 8 行步进测试 wipe：旧/新 bank 不变时，断言 `cut_words-1` 来自新 bank，`cut_words` 起恢复旧 bank，且映射切换落在 `LINE_WORDS=480` 的倍数。
4. **构建绑定核对**：对 C29/C31 实际工程源清单和下载用 bitstream 的时间/哈希取证，确认 C31 使用的 `frame_buffer_rgb888.v` 是本目录版本，且 `SDR_READ_*` 参数没有被另一份 framebuffer 覆盖。

切图动画时的写流证据：BMP loader 在 `COMMIT` 仅在 `write_done || finish_pulse` 后更新 `disp_buf_idx` 并进入 `WAIT_DISPLAY`（[tf_bmp_file_player.v:239-243](../player_video31_audio_ablation/src/user_source/hdl_source/tf_bmp_file_player.v#L239)）；进入该等待态后 `write_en` 每拍默认拉低，只有 `PAYLOAD` 状态才置位（[tf_bmp_file_player.v:137-138](../player_video31_audio_ablation/src/user_source/hdl_source/tf_bmp_file_player.v#L137)、[tf_bmp_file_player.v:229-234](../player_video31_audio_ablation/src/user_source/hdl_source/tf_bmp_file_player.v#L229)）。因此静态 BMP 切换/wipe 执行时，该 loader 已完成写入，不存在持续像素写流与显示读并发；JPEG 视频播放是否持续并发写读需另查视频调度与 JPEG 解码路径，BMP loader 的 `WAIT_DISPLAY` 证据仅适用于图片切换。

## 已完成的 baseline/candidate Icarus 压力测试

用 C31 真实 `frame_fifo_read.v` 对照 C32 候选 `frame_fifo_read.v`。为双实例对比，隔离目录中的 `frame_fifo_read_c32_candidate.v` 仅将模块名改为 `frame_fifo_read_c32_candidate`，RTL 功能与 C32 源一致；测试台还实例化真实 C31 `frame_fifo_write.v`，以及真实 `jpeg420_word_address.v`。

测试台见 [tb_frame_fifo_return_drain_rw.v](pressure_test/tb_frame_fifo_return_drain_rw.v)，门限/忙标志测试见 [tb_frame_fifo_read_pressure.v](pressure_test/tb_frame_fifo_read_pressure.v)，一键运行脚本见 [run_return_drain_test.ps1](pressure_test/run_return_drain_test.ps1)。候选源取自 C32 [frame_fifo_read.v](../player_video32_read_return/src/user_source/hdl_source/SD/frame_fifo_read.v)，隔离副本仅重命名模块以便同台双实例。read service 是可控有序响应队列：每个 `App_rd_en` 都按已接受请求入队，首个返回延迟 32 个 `mem_clk`，随后按每拍一个字返回；周期性 stall、`Sdr_busy`、`Sdr_init_ref_vld` 窗口暂停返回，每收到 256 字再插入 7 拍 burst gap。模型暂按 core 接受 busy/ref 期间的 App beat 处理；真实加密 core 的接收/排队语义由另一代理用 ModelSim 核实。FIFO `wrusedw` 固定为 0，作为持续显示消费下的补读压力；写侧用真实 JPEG/BL4 写状态机，`rdusedw=400` 是合成占用输入。它能验证仲裁和 pending-return 生命周期，不模拟真实异步 FIFO或加密 SDRAM core。

实际结果（脚本连续运行两台）：

- **C31 baseline 负控失败**：第一个 burst 在 cycle 298 固定延时完成时仍有 112 个请求字未返回；后续 cycle 568 再次完成时仍有 216 个未返回字，证明旧返回未排空就可重入下一 burst。
- **读写交叠**：接入真实 `frame_fifo_write` 后，C31 baseline 发出 JPEG `App_wr_en` 时还有 213 个读返回 pending。C32 候选没有出现 pending 读数据期间的写 beat。
- **中途新帧请求触发清 FIFO**：首次 `fifo_aclr` 采样时，baseline 仍有 207 个返回 pending；C32 候选为 0。候选只在 issued 和 returned 两个 256 字计数均满足后退出 burst，因而先排空再应答新请求。
- **候选检查**：全程没有 `rd_burst_finish` 早于 256 个实际 `Sdr_rd_en` 返回；baseline/candidate 同一波形下结果分别为 `early=1/0`、`reset_pending=1/0`、`read/write_overlap=1/0`。独立阈值台还实测 256 不启动、255 可启动；`App_wr_busy` 阻止启动，而 SDRAM busy/ref 高时 reader 仍发 beat。

重现时先在 PowerShell 执行 `. ./scripts/anlu_tools.ps1`，再用 `Resolve-AnluTool -Name iverilog` 和 `-Name vvp` 解析便携工具。Icarus 命令和成功运行结果已保存为 `tb_frame_fifo_return_drain_rw.vvp`。该服务测试证明固定 10 周期完成条件在所设的合法变延迟/暂停服务下会提前释放仲裁、清 FIFO；它没有计算真实 SDRAM 中最坏尾延迟，也没有观察像素 FIFO 实际满/空，因此实板欠载/溢出仍需结合真实控制器模型和 FIFO 计数确认。
## 限制

测试调用工程脚本解析便携 Icarus/VVP 12.0；baseline/candidate 压测结果见前节。本报告没有实例化真实异步 FIFO、RGB unpack 或受保护 SDRAM core，因而没有测出实际像素 FIFO 欠载/溢出。生产 core 的受保护源码存在于 `include/sdr_as_ram.enc.v`、`sdr_wrrd.enc.v`、`sdr_init_ref.enc.v`，Icarus 不适合解密仿真；另一代理正在运行真实控制器 ModelSim。板上 ILA、最终烧录镜像哈希和 SDRAM 官方读时序波形仍未检查。C29/C31 所列开源缓存模块主体算法基本相同。








