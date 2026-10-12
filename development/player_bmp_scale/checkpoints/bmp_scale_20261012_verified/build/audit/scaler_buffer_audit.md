# BMP 缩放帧缓存与读取路径审计

审计日期：2026-10-12  
范围：只读核对 `build/scaler_spec.md` 与当前 `src/user_source/hdl_source` 的帧缓存、FIFO、SDRAM公开包装、SD扇区仲裁和 FAT32 sector mapper。此时尚未发现缩放 engine 或行缓存 RTL，因此不评价其实现正确性、综合映射或实板表现。

## 结论

- **仅凭 `pixel_valid` 最短间隔 10 个 50 MHz 时钟，不能断言写 FIFO 不会溢出。** 缩放器最大输出速率为 5 Mpixel/s，RGB888 pack 后最高约 3.75 M 个 32-bit word/s；但现有写 FIFO 的 `full_flag` 未接出且写入端没有 ready/full 反压。Anlogic FIFO 内部会在 full 时屏蔽写入（`wr_en_s = !full_flag && we`），调用方看不到被丢弃的写入。
- 持续显示读取需求远高于新图写入需求：每个 640×480 RGB888 帧为 230,400 个 SDRAM word，即 900 个 256-word burst。若持续 60 Hz 显示，读需求是 13.824 Mword/s；与缩放写入同时进行时总需求约 17.574 Mword/s。这个数值本身不证明控制器能持续服务：帧读写 FSM 以 256-word burst 交替避让，刷新/`Sdr_busy` 的实际等待和保护控制器可接受的命令节拍没有可用的公开上界。
- `WRITE_V_FLIP=1` 与规格要求的 bottom-up 输出栅格一致：旧 writer 按存储行宽 480 word 将输入第 0 行写到帧末行，逐行倒序写；缩放器应输出 `j=0` 对应显示底行，且每行 x 正向。
- FAT32 mapper 能按逻辑 sector 定位并完整输出 512 字节，但单个 cluster 进度缓存只允许复用当前或向前的 cluster 索引。top-down BMP 配合 bottom-up 输出会产生跨行逆向 sector 访问；跨回较小 cluster 索引时会从文件起始 cluster 重走 FAT 链，碎片文件和小 cluster 配置下代价可能很高。它是功能可行性与加载时长风险，不等同于解析错误。
- `file_read` 必须先拉低，使 mapper 在 `S_IDLE` 重新置 `armed` 后才能发起下一次请求。Mapper 本身在 sector 完成后还有 `S_GAP`；规格中的撤销/gap应覆盖完整扇区传输结束、mapper gap 和 IDLE armed 周期。逐字节反压不可用，engine 必须把整个 sector 接收到本地 512-byte cache。
- 目前没有缩放 engine/同步行 RAM RTL，RAM 的同步读推断、读延迟 WAIT、valid/tag 和不复位数组尚待 RTL 出现后续审。

## 定量核算与写入缓冲

`frame_buffer_rgb888` 将每 4 个 RGB888 像素压成 3 个 32-bit word，内部 backend 的行宽因此是 `640 / 4 * 3 = 480` word，而不是 640。帧长为 `480 * 480 = 230,400` word，恰为 `900 * 256`。每 60 Hz 显示帧读取 230,400 word，因此持续读带宽为 13.824 Mword/s。若按规格的最短像素间隔 10 拍连续产生 640×480 输出，像素率上限 5 Mpixel/s、单帧最短产生时间 61.44 ms；pack 后写入峰值约 3.75 Mword/s。若此时显示端持续 60 Hz 读取，理论总服务需求约 17.574 Mword/s（还未计 burst 切换、刷新和其他事务）。

`frame_read_write.v` 将 FIFO `full_flag` 明确悬空；FIFO IP 的 `wr_en_s` 在 full 时直接屏蔽写入，不会停住 packer 或设置错误标志。因此输入间隔限制只给出生产率上限，无法约束在 refresh、读 burst 占用、命令拒绝或写服务停顿期间的 FIFO 峰值。写 FIFO 虽标称 512 word，但 IP 的满阈值为 511（`FULL_NUM={ADDR_WIDTH_W{1'b1}}`），可用容量约 511 word，约相当于 681 个像素的打包数据；短暂 stall 也可能丢数据。

旧帧读写仲裁逻辑可从公开 RTL 确认：

- 写端在 `S_CHECK_FIFO` 检查数据达到一批（或整个帧已入队）且 `~App_rd_busy` 后开 256-word burst；`O_wr_busy` 覆盖正在写 burst 或即将开始写 burst。
- 读端仅在 read FIFO 低于 `FIFO_DEPTH-BURST_SIZE` 且 `~App_wr_busy` 时开 burst，因此写端具有启动优先级，读写不会同时主动发起 burst。
- 两个 FSM 的 `Sdr_busy`、`Sdr_init_ref_vld` 输入未参与 burst 发起判断。是否能在刷新期间接收/延迟命令取决于 `sdr_as_ram` 加密实现；公开 wrapper 只暴露 `Sdr_busy`、`Sdr_init_ref_vld`，无法静态推出最长 stall 或持续服务保证。不能把 50 MHz 理想每拍吞吐当作有效 SDRAM 带宽。

关闭这个风险至少需要一种可验证机制：

1. 将 FIFO 满/水位作为后端 ready 暴露给缩放输出，满时停发像素并保持当前像素/行状态；或给出经控制器行为约束的最大服务空窗及长期服务率证明，并用模型断言 FIFO 水位永不达到 full。单纯再调大像素间隔不能替代最坏服务延迟证明。
2. 对持续显示读和缩放写同时进行的条件覆盖 refresh/`Sdr_busy`、双方 256-word burst、FIFO 临界水位和整帧结束；确认写入/读出总量及 FIFO 水位不丢不重。没有 protected controller 时序模型的部分应标注为假设，不能写成控制器实测结论。

## 方向翻转、扇区缓存与请求握手

规格的 bottom-up 输出约定与现有写地址映射吻合。`frame_fifo_write.v` 的首地址偏移是 `(FRAME_HEIGHT-1)*FRAME_WIDTH`，其中 `FRAME_WIDTH` 在 RGB888 backend 被设成每行 480 个存储 word；每写完一行地址减 `2*FRAME_WIDTH-1`，所以输入行序必须是目标图从底行到顶行。缩放算法中的 `srcy_bottom=floor(((j+1)*h-1)/dh)` 保持了非整数垂直缩放时的正确末像素取样；该数学式尚待实现逐点比对。

`fat32_file_sector` 会在 `S_DATA_WAIT` 每个 `sd_valid` 输出一个字节，并且只在 `sd_end` 时检查 `byte_count==512`，随后才发 `file_end` 并提交 FAT cluster cache。engine 侧必须连续接收整个 sector，不可在本地行缓存满时暂停；512-byte cache 的 tag 只能在完整有效 sector 后提交。RGB 的三字节跨 sector 时，已经取到的 B/G（或其他通道）需跨 sector 请求保留，不能在 cache tag 切换时丢失。

FAT mapper 的命中条件为同一文件且 `target_index >= cache_index`。目标 cluster 变小或 cache 属于另一文件时，`current_cluster`、`walk_index` 会从 `start_cluster` 重置；之后每个 FAT hop 都完整读取一个 FAT sector，再转到下一 cluster。故 top-down 图按目标 bottom-up 顺序输出时，同一 cluster 内的逆序 sector 可利用当前 cluster 映射，但一旦跨到前一 cluster，就可能从头重走到该 cluster。最坏的逐 cluster 反向访问会重复前缀 FAT walk，链遍历量呈二次增长；真实代价取决于 sectors-per-cluster、stride、采样重复行和 FAT 碎片。规格已正确将任意加载时长排除在承诺外；建议模型统计 `data sector` 数、`FAT sector` 数和最大连续 `file_read` 等待，至少覆盖 top-down + 碎片 FAT 链 + 1/8 sectors-per-cluster。

请求时序上，mapper 只在 `S_IDLE && armed && file_read` 接受请求；`armed` 仅在 `S_IDLE` 看见 `file_read==0` 时置位。数据 sector 正常完成后进入 3 个计数拍的 `S_GAP`，之后才回 `S_IDLE`。因此 engine 应对每个新逻辑 sector 产生独立请求：前次事务期间以及 GAP/返回 IDLE 后先保持 `card_read/file_read` 低，让 mapper 实际观察到低电平，再重新拉高；不能把相邻 sector 请求连续保持高。共享 arbiter 的 owner 在 `card_end` 后释放并插入 2 拍 gap；它只保证总线 owner 间隔，不代替 mapper 的 `armed` 低电平条件。应在 mapper+arbiter 联合模型中用 back-to-back sector 和 WAV 并发确认每个扇区只触发一次、数据不串 owner。

SD 扇区仲裁只在 sector 边界切换。BMP pending 时允许最多两个连续 WAV sector（包括 WAV 的 FAT metadata request）后再给 BMP 一次；如果 WAV 没有 pending，则 BMP 可直接取得总线。此规则限制连续优先级，不限制底层 SD sector 本身耗时；controller 无响应由 mapper 50,000,000 拍 timeout（50 MHz 下约 1 s）报错。

## 新增 RTL 后的只读复审项

- 检查缩放器是否每帧恰输出 307,200 个有效像素，黑边也写入黑色，写端 bottom-up 行序和 480-word 行边界对齐，最后打包相位回到 0。
- 检查写 FIFO 的 full/ready 或水位保护是否闭环；以 simultaneous 60 Hz display reads、refresh/busy stalls 和 sector 输入覆盖 full 临界状态，证明停发/恢复无像素丢失、重复或行错位。
- 检查 sector cache 只有在 512 个连续 `card_valid` 字节完成后有效，跨扇区 24-bit 组三通道取值正确；任何新图 start 都清除旧 tag。
- 检查 top-down/非整数缩放的逆向逻辑扇区序列、FAT cluster reverse-walk 计数、`file_read` low/armed/gap；异常和短扇区不得 commit。
- 检查行缓存 RAM 为真实同步读结构；地址发起到数据使用有对应 WAIT/valid 延迟，不对数组复位，仅用 tag/valid 隔离旧数据；黑边不污染 source-row tag，只有完整行可置有效。

## 证据边界

这是对规格、现有 RTL 和可见 FIFO IP 源码的静态/算术分析。17.574 Mword/s 是在 60 Hz 持续读假设下的需求估算，不是 SDRAM 能力结论；FIFO“会丢写”的判断来自公开 FIFO RTL 的满时写屏蔽，不是板测。`sdr_as_ram`/底层 SDRAM 控制实现使用 Anlogic 加密源，公开包装无法证明实际服务率、refresh stall 上界或读写命令保证。没有运行 RTL 仿真、综合、BRAM 映射检查或板卡测试。
