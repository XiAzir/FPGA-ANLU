# C34 1080p15 生产集成审计与最小 spec

审计范围：只读检查 `development/video34_work` 的 current source audit、native wrapper/arbiter 回归结果、C34 顶层和帧缓存、APUG011 v1.2 手册摘录及参考工程。未编辑共享 RTL，未运行仿真、TD 或硬件操作。目标内容仍为 1920×1080、15fps；视频输出扫描模式由 HDMI 输出门槛另行决策。

## 结论

native JPEG/YUV420 路径已具备可接入的模块级实现与 32×32 双帧接口回归，但当前 C34 顶层仍将 `jpeg_core` 的 RGB888 输出写进 `frame_buffer_rgb888`，新 native 模块没有生产实例。最小生产接线需要将 JPEG core 配为 native IDCT 输出、将视频写入和 YUV 扫描接入共享 SDRAM APUG 客户端，并让照片链路继续使用同一 SDRAM 控制器。

当前C34的SDRAM app时钟实况为 **50 MHz**（`sys_pll` C1；`global_def.v` 的 `SDR_CLK_PERIOD=20 ns`）；SD/文件读取和 JPEG 解码当前都在 `sd_card_clk=50 MHz`。后续优先将native decoder与SDRAM客户端放在同一 **100 MHz mem/decode域**，把跨域边界留在SD输入端：读卡/文件侧维持50MHz，输入word经过异步FIFO进入100MHz域；这样native IDCT样本、block buffer和APUG客户端共用100MHz，从而缩小native样本的CDC范围。帧108最大输入服务仿真在100MHz为5,992,307拍/59.923ms，限速TF输入本身约56.6ms；估算纯解码项约4.06M拍，在50MHz约81.1ms，超出15fps的66.667ms预算。纯解码估算依据82.87拍/块，尚无50MHz整机测量。

扫描负载与服务周期：cache对每个可见显示帧发194,400条BL4命令，返回777,600个32bit word，共3,110,400B。1080p60为11.664M命令/s、186.624MB/s读流量；1080p30为5.832M命令/s、93.312MB/s。加上1080p15 native写入47.002MB/s，总payload分别233.626MB/s和140.314MB/s。50MHz×32bit的原始200MB/s下，1080p60总payload需116.8%，已越过物理总线原始上限；1080p30需70.2%，该效率尚未支付BL4间隔、刷新、busy与bank转换。

现有 `yuv_sdram_burst_arbiter` 每条读先在IDLE接收命令，发4个连续 `App_rd_en`，再等待4个实际 `Sdr_rd_en` 返回并完成状态交接才接下一条。按“每拍返回、返回相对请求延迟1拍、刷新与busy均无”的理想应用接口模型，steady-state每条BL4占6–7个mem_clk；6拍对应同拍首返回的紧下界，7拍对应现有 wrapper 使用的1拍数据/valid相位。APUG手册未列固定读延迟，故两者作为协议预算情形。30Hz扫描在50MHz的全应用周期预算为8.573 mem_clk/BL4，100MHz有17.147拍。写侧每16-word native块至少16个连续写拍，arbiter转换使理想额度约18拍/块；15fps需734,400块/s，即约13.219M mem_clk/s。合并读写后，50MHz在读6拍情形已用48.211M/50M拍（96.4%），留3.6%支付refresh/busy/切换；读7拍情形需54.043M拍/s（108.1%），尚未计刷新便超预算。100MHz下30Hz对应48.2%–54.0%理想占用；60Hz对应83.2%–94.9%，7拍情形仅剩约5.1%余量，均未计refresh/busy与时序闭合。结论：1080p30在当前50MHz配置缺少周期预算余量；优先以native decoder、YUV arbiter和APUG统一100MHz域。

已存回归仅界定功能模型覆盖范围：32×32两帧共192条BL4读命令、768个实际返回、16-word背景写一组；testbench为每word安排2–8拍返回到期，约每三拍返回插入1–2拍空隙，以5/53周期标记refresh、4/37周期标记busy，另在每写拍后置3拍busy。模拟时间约6,640 mem_clk、平均34.6拍/BL4（含两帧启动/缓存/像素和一组写入）。此数据证明协议处理能应对该仿真模型的延迟/门控/间隙；模型范围不提供APUG真实刷新周期、50/100/200MHz物理服务率或1080p显示欠载证据。APUG指南列出的最高200MHz和95%效率只用于引用手册标称；当前EG4S20上100MHz运行能力、真实时序与吞吐均待板级验证。

## 当前源码连接点和接口

- C34 顶层 `development/player_video34_1080p15/src/user_source/hdl_source/top_tf_hdmi_audio.v` 中，JPEG `u_jpeg_core` 仍采用 `FIXED_WIDTH=640, FIXED_HEIGHT=480`，`.outport_accept_i(bmp_write_ready)`，RGB 的 `video_pixel_{valid,x,y,r,g,b}` 写入旧帧缓存；native 输出 `native_valid_o/native_sample_o/native_index_o/native_id_o` 端口已经存在于 `jpeg_core.v`，顶层尚未连出。
- `native_yuv420_frame_buffer` 在 `mem_clk` 域接收 native 样本与写帧启动/索引，输出 `write_frame_done` 与 APUG `app_rd_* / app_wr_*`，接收 APUG 的 `init_done/refresh_valid/sdr_busy/sdr_rd_valid/sdr_rd_data`。像素域接 `pixel_clk/pixel_rst`、`pixel_x/y/de`，输出延迟后的 `rgb_valid/rgb_x/y/rgb`、`pixel_underflow`、`pixel_bank_ready`、`prefetch_frame_done`。默认 `SDR_READ_DATA_DELAY=1`。
- `yuv_sdram_burst_arbiter` 对同一 video 客户端的读写仲裁：读命令优先；每条 BL4 读命令从首地址连续发4个 `App_rd_en`，并等4个真实 `Sdr_rd_en` 返回后才接下一命令；16-word native 写块连续发出。仅当 `Sdr_init_done && !Sdr_init_ref_vld && !Sdr_busy` 时开始新事务。`
- 图片链路的 `frame_buffer_rgb888` 当前私有实例化 `sdram`，封装RGB pack/unpack、legacy `frame_read_write` 与APUG app端口。共享方案将其`sdram`提升到顶层，照片backend暴露app read/write与状态，顶层按稳定owner选路。旧写入路径已有 `wfifo_32_32_512`：`clkw=write_clk`、`clkr=mem_clk`，读缓存 `rfifo_32_32_512`：写时钟`mem_clk`、读时钟`video_clk`。FIFO RTL声明independent-clock mode，因此旧照片链可保留50MHz decode/write_clk，把mem_clk切至100MHz；写FIFO供给率在50MHz侧、回收率在100MHz侧，容量阈值仍按已有FIFO域逻辑工作。100MHz PLL、SDRAM时钟相移、IP配置、SDC和FIFO CDC时序约束需核实。照片与视频owner互斥，owner在client静止、没有未回收返回数据时切换；视频owner内使用YUV arbiter。

## 最小生产改动 spec

1. **保留一个APUG controller实例并升至100MHz**：将 `sdram` 从 `frame_buffer_rgb888` 移到顶层。保持SD时钟50MHz；新增/重配mem PLL输出100MHz `ext_mem_clk`，并提供与之匹配的100MHz相移 `ext_mem_clk_sft`。将 `global_def.v` `SDR_CLK_PERIOD`调整为10ns，并同步复核 `SELF_REFRESH_INTERVAL`、时序约束、IP配置及EG4S20实际时序。照片backend app逻辑、YUV writer/scan arbiter与APUG app接口同处100MHz域。将照片backend的app接口引出；顶层owner mux只选照片或视频的 `{App_wr_en,addr,dm,din,App_rd_en,addr}`。两者在owner期间未选端口全部拉空闲值。以初始化完成后的owner启动为入口。
2. **只视频模式启用native decode**：固定尺寸改为1920×1080和native YUV420输出配置；native ports接`native_yuv420_frame_buffer`的`native_valid/sample/index/id`，其`decode_idle`接JPEG `idle_o`，`decode_block_space`接JPEG core的输出接收/块授权输入。SD/文件读取维持50MHz，50MHz word stream经单个输入异步FIFO送到100MHz decoder；JPEG core native输出、block buffer、YUV scan arbiter和APUG客户端全部运行在同一100MHz mem/decode域。保留 `{jpeg_data[31:0],strb[3:0],last}` 与 valid/accept 语义，word FIFO深度与满空阈值按现有读卡器背压契约确定。
3. **帧写交接**：在 `video_write_req/write_req_ack` 这一帧 writer buffer 被 scheduler 接收时，产生一个 `write_frame_start`，`write_frame_index=video_write_buffer` 在该帧保持稳定；不要以单个 `video_frame_sent` 事件代替“所有 native 样本与SDRAM写入完成”。`native_yuv420_frame_buffer.write_frame_done` 在 `FRAME_WORDS=783,360` 写字完成、decoder idle 且 block/arbiter 排空后产生单拍；在 mem_clk 翻转现有 `frame_write_toggle_mem`，同步到 sd_card_clk 交 `player_video_schedule.write_finish_toggle`。scheduler 的写/显示 buffer ping-pong是提交事实源，读索引使用 `video_display_buffer`。
4. **帧预取和像素输出**：在视频显示的帧边界，向 wrapper 的 memory side 发 `read_frame_start_mem`，`read_frame_index=video_display_buffer`；pixel side 同一垂直消隐窗口发 `read_frame_start_pixel`，输入来自实际显示时序坐标与de。native wrapper输出 RGB 替换 `vout_data_raw` 的视频像素来源，图片仍用 legacy read 数据；仅在video mode选择native有效像素。将扫描、cache同步RAM、色彩转换总延迟与 `hs/vs/de` 对齐（模块输出目前是同步 RAM读后1拍，再走 `yuv420_to_rgb888` 流水）；视频读帧启动、frame buffer tag 和 RGB像素必须在相同显示帧边界换代。视频OSD沿用与native RGB合成的已有像素时钟域逻辑（若没有共用合成输入，则OSD画面会消失，需在此处补一个 RGB mux/compositor 接点）。以 `pixel_underflow`、两 bank ready 和 `prefetch_frame_done` 作为观测信号，采用单一路径输出，欠载作为状态上报。
5. **安全 owner 切换**：使用 `video_mode` 的 pixel域事件同步到 mem_clk（现成 `video_mode_sd` 位于sd_card_clk域；owner选择需在mem_clk域另经同步）；只在帧交界关停当前owner的新增请求，等 legacy读/写 pending清零或 video arbiter idle且无未返回BL4，再同步切换 owner；然后对新client清状态并在 `Sdr_init_done` 可用时启动。APUG controller在模式切换期间保持运行，由client owner静止握手保护正在进行的请求和控制器状态。保持模式选择稳定跨过整个命令与全部返回；无额外retry/watchdog/fallback。

## SDRAM 地址布局

地址单位是32bit word；APUG011配置 `ADDR_WIDTH=21`，因此0..2,097,151 words（8 MiB）。目前图片backend的640×480 RGB888每帧230,400 words，照片双缓存用 `[0,230399]` 和 `[230400,460799]`。1080p YUV420 tile为`120 MCU列 × 68 MCU行 × 96 words = 783,360 words/frame`；两个视频bank使用`[0,783359]` 和 `[783360,1,566,719]`，落在总容量内。图片与视频复用同一低地址空间，靠 owner互斥保证分时访问；切模式重新解码/载入后再显示。native frame words包含padding到1088行，图像可见扫描只请求1080行。

## APUG011 application contract与证据

来源：`APUG011_基于ERAM接口实现的高性能SDRAM读写v1.2.pdf`，工作工程同版摘录在 `development/video34_work/sdram_contract_excerpt.json`，参考工程 `赛题1_工作资料/05_补充参考工程/APUG011_SDRAM参考工程/source_code/rtl/top.v`、`app_wrrd.v`、`enc_file/sdr_as_ram.enc.v`、`enc_file/sdr_init_ref.enc.v`。

- app写命令字段：`App_wr_en`, `App_wr_addr[20:0]`, `App_wr_din[31:0]`, `App_wr_dm[3:0]`；app读字段：`App_rd_en`, `App_rd_addr[20:0]`；读返回：`Sdr_rd_en` 表示当前 `Sdr_rd_dout[31:0]` 有效。状态：`Sdr_init_done`, `Sdr_init_ref_vld`, `Sdr_busy`；时钟/复位：`Sdr_clk`, `Sdr_clk_sft`, 高有效 `Rst`；刷新输入 `App_ref_req`。
- 手册第7页（PDF页10）说明初始化结束后才操作；读写前判断刷新，且`Sdr_busy`忙时等待（第12页再次列明）。`Sdr_init_ref_vld` 在参考初始化刷新模块可见表达式为 `init_vld || ref_vld`，所以它覆盖初始化阶段与刷新占用窗口；C34 `sdram.v` 固定 `App_ref_req=0`、参数 `self_refresh_open=1`，刷新由IP内部调度。
- 手册第5页（PDF页8）规定32bit路径按4个数据为一组；组内地址由首地址递增，允许跳地址时首地址 `App_*_addr[1:0]==0`，每组后可换任意4字对齐首地址。手册第12页也要求地址跳转以4字为单位。因此video scan地址gen每命令基址必须4字对齐，四拍地址为base..base+3；cache在真实有效读返回计满4拍后才推进。
- 手册第1页（PDF页4）给能力声明：SDRAM工作频率最高200MHz，32bit理论6.4Gb/s，持续读/写接近理论有效带宽；有停顿时宣称可到6Gb/s、利用率95%以上。该段数据是手册能力标称；当前板级50MHz配置和外部SDRAM实测各自按已有证据记录。APUG RTL主体加密；公开证据没有给具体tRCD/tRP、read latency、refresh周期各cycle长度或`Sdr_rd_en`固定延迟。故目前只能以有效返回信号实际计数、刷新/忙状态门控作安全契约，`SDR_READ_DATA_DELAY=1`来自模块回归夹具；手册未列该固定延迟，需由C34真实IP接口/管脚时序确认。

## 核验结果与未决实参

- `current_source_audit.json`显示基于C32的独立C34候选和新增5个source，生产top文件被修改但新native路径未在top实例化；C32 bit哈希仍记录为回退。审计本身没有对生产top完成功能闭环。
- `native_wrapper_regression_result.json`: 32×32，两帧，768 unique写、768读、2048 RGB匹配、0欠载；实际返回驱动、1周期数据对齐夹具通过。
- `arbiter_integration_result.json`: 两帧、192个BL4命令、768真实返回、16-word写与视频读重叠，2048 YCbCr像素、0欠载；覆盖了init/refresh/busy gate。32×32应用接口夹具并不提供真实APUG refresh频率或持续吞吐证明。
- **未决参数**：100MHz PLL输出/锁定和SDRAM相移时钟；50MHz SD/文件输入到100MHz decoder的word FIFO深度、reader背压与满空阈值；APUG真实单BL4启动间隔、`Sdr_rd_en`/数据采样相位与valid延迟；真实刷新及busy累计占空比；照片backend owner切换静止条件；EG4S20时序收敛与缓存资源映射（cache约46,080 bytes原始Y/C缓存估值，具体BRAM映射待综合）。输出扫描时序/路线由根代理协调。

## 最小下一步

先在C34顶层做单controller、owner互斥的静态接线：抽出旧照片backend APUG接口；mem/decode共用100MHz，照片 `write_clk` 和SD/文件读取维持50MHz，保留50MHz到100MHz的输入word异步FIFO；连接native decoder与现有`native_yuv420_frame_buffer`，按scheduler buffer索引完成帧写/帧读交接，并将RGB/DE/坐标送入现有pixel域合成。接线前锁定100MHz PLL与相移时钟、reader FIFO背压、照片backend owner静止握手和APUG真实读返回采样边沿；实际显示扫描参数由根代理同步决策。完成静态连线审查后，再评估最小端到端APUG接合验证；本spec未执行接线、TD或板测。







