# C42 SDRAM 100 MHz 规格与接口审查

范围：只读审查 C41 基线与 C42 初版100MHz综合及routed证据。未修改生产工程；本代理未启动TD、ModelSim或vvp。C42 synthesis与physical均由根侧启动且status=success；无板测结果。C41已正常属于用户反馈。

## 时钟建议

C41 `src/user_source/hdl_source/IP/sys_pll.v` 使用 50 MHz 输入，三个输出均为 50 MHz；`CLKC0/1_DIV=20`、`CPHASE=19`，`CLKC2_DIV=20`、`CPHASE=7`。`sys_pll.ipc` 声明输出 0/1 相位 0°、输出 2 相位 144°。对应 SDRAM 时钟相差 8 ns（50 MHz 周期 20 ns 的 40%）。

目标是把 mem 控制/SDRAM 时钟提高至 100 MHz，保持输出 0 `sd_card_clk=50 MHz`、输出 1 `ext_mem_clk=100 MHz`、输出 2 `ext_mem_clk_sft=100 MHz / 144°`。按现有 IP 的相位编码模式，建议让 PLL 保持 50 MHz 参考和反馈分频，C0 DIV=20、CPHASE=19；C1 DIV=10、CPHASE=9；C2 DIV=10、CPHASE=3。相位步进公式可由当前 DIV=20、CPHASE=7 对应 144°交叉核验：相位为 `(CPHASE+1)/DIV*360°`。因此 100 MHz 时 144°延迟是 4 ns，CPHASE=3；SDRAM 输出时钟应落在控制器数据更新边沿之后，以增加 SDRAM 输入建立裕量。最终以 TD PLL 参数回读、布线后时钟报告及板上读回边沿裕量验证。`sd_card_clk` 保持 C0；`video_pll` 的 25 MHz 像素与 125 MHz HDMI 五倍频、TF 读写逻辑不动。

## 命令时序与宏

公开 `global_def.v` 的 `SDR_CLK_PERIOD=1000000000/50000000` 明确固定为 20 ns；100 MHz 需改为 10 ns。`SELF_REFRESH_INTERVAL=(64000000/SDR_CLK_PERIOD/4096-1)` 是基于时钟周期、而非固定周期常数。每行计数周期当前为 781 个 SDR 时钟（终值 780）；换为 10 ns 后应是 1562 个周期（终值 1561），满足 EM638325 每 64 ms 共 4096 次 AREF 的约束且略早于理想间隔。

加密公开文件 `sdr_as_ram.enc.v`、`sdr_wrrd.enc.v`、`sdr_init_ref.enc.v` 可核对模块和宏头；内部命令译码、tRC/tRCD/tRP/tWR/tRAS 计数、CAS、MRS 编码、初始化等待无法从源码确认。公开宏只定义数据/地址宽度与刷新周期；`sdr_wrrd.enc.v` 自身头部重复定义宽度宏，需检查预处理顺序，确认 `global_def.v` 中时钟宏进入加密实例。初始化代码公开头部可以看到 `pwr_200ms_cnt[17]` 与 32 级 `sdr_init_cnt` 移位链，但其计数级数及发命令间隔仍属加密实现。命令间隔随周期宏更新目前未证实。建议以 TD 展开/仿真门级波形确认命令间各自周期；若它们是固定拍计数，需按 100 MHz 器件 datasheet 的 ns→cycle 向上取整。

## FIFO 与 CDC

入口 `top_tf_hdmi_audio.v:409-420` 将 `write_clk=sd_card_clk(50 MHz)`、`mem_clk=ext_mem_clk(50 MHz)`、`read_clk=video_clk(25 MHz)` 接入 `frame_read_write`。`frame_read_write.v:137-149` 的写 FIFO 是异步 FIFO，写端 50 MHz、读端内存侧 50 MHz；`frame_read_write.v:188-204` 读 FIFO 是异步 FIFO，写端内存侧 50 MHz、读端像素侧 25 MHz。控制器读写状态机、请求同步和返回计数都位于 `mem_clk`；`frame_fifo_write.v`、`frame_fifo_read.v` 中多位地址/长度直采后延迟锁存，属于稳定总线配合请求保持的 CDC 协议，复核时需确认源域在 ack 前保持数据。刷新/忙标志在同一 mem 域内。C41 顶层实例 `frame_buffer_rgb888` 默认 `SDR_READ_CAPTURE_DELAY=0`、`SDR_READ_DATA_DELAY=1`，并经参数传入 `frame_read_write`；该实例的读数据一路打一拍、valid 保持原相位。`frame_read_write` 自身 0/0 默认值不代表顶层实例设置。

100 MHz 升频后，写 FIFO 可由 50 MHz 生产端以每秒最多 50M 个 word 入队，100 MHz 内存侧提高可排空速率；生产端仍是长期平均输入吞吐上界，突发输入是否溢出取决于 512-entry FIFO 实际可用深度、`write_fifo_ready` 水位及写流水线余量。读 FIFO 100 MHz 写入、25 MHz 像素侧取数；目标 640x480 RGB888 连续流经 3/4 打包后需求约 18.75M word/s，内存读回平均供给需在扣除刷新/命令空隙后高于该需求。故以消费需求和可用供给判断，FIFO 时钟比率本身不说明带宽边界更紧。控制器->输出 FIFO 的读数据/valid 采样检查实际 C41 参数 0/1：data 延迟一拍、valid 原相位。保留异步 FIFO 的双时钟约束；请求/ack toggle、地址和长度总线 CDC 要单独列入跨时钟报告。C41 SDC 对 mem 时钟使用 `rename_clock`，换频后需确认工具报告实际为 100 MHz 并覆盖 mem_clk 内部、mem->25MHz、50MHz->mem 三类路径。

关键路径审查补充（C41 已有 routed 报告 `player_video41_refresh/build/manual/AC201_tf_hdmi_pr.timing`）：`ext_mem_clk` 的 R-Period=17.380 ns、Fmax=57.537 MHz；对应最慢路径 Slack=8.981 ns、data delay=10.739 ns、11 logic levels。路径起点为异步写 FIFO `write_buf/rd_addr_reg[0]`，先经过 FIFO Gray/read pointer 到 `rdusedw`，再进入 `frame_fifo_write` 水位/满量比较 (`add6_syn_155` 等)，与读忙状态一起形成 `into_burst`，跨入 `frame_fifo_read` 仲裁状态译码，终点 `App_rd_en_r_reg`。相关 RTL：`frame_read_write.v` 中 `rdusedw` 回接 frame_fifo_write；`frame_fifo_write.v` 的 `into_burst` 组合式和 `App_wr_busy=O_wr_busy`；`frame_fifo_read.v` 的 refill 状态条件、`App_rd_en_r`。这条 FIFO 水位到读仲裁的组合链是 100 MHz 第一优化对象，建议先将 `into_burst` 所需的水位条件预译码/寄存或缩短 FIFO used-word 比较进状态机的重叠逻辑；保持 FIFO 余量阈值与读写互斥语义，流水级要用预判阈值避免插入请求气泡。

报告前十还有 wipe 地址链：`u_wipe_address/cut_words_reg[9]` 到加密 SDRAM 控制器 `app_rd_addr_1d_reg`，data delay 9.360 ns、Slack 10.360 ns。RTL 当前 `offset=linear_addr-old_base`，比较 `offset<cut_words`，之后真分支 `new_base+offset`，串行包含减法、比较、加法与地址选择。对缓冲区地址范围 `[0,FRAME_WORDS)` 和 `[FRAME_WORDS,2*FRAME_WORDS)` 可等价改为 ACK 时捕获 `cut_absolute=old_base+cut_words` 与有符号 `base_delta=new_base-old_base`，输出条件 `active && linear_addr>=old_base && linear_addr<cut_absolute`，映射输出 `linear_addr+base_delta`。范围比较与基址加法并行，减少一级长算术串接。需确认最大 `cut_absolute=2*FRAME_WORDS` 仍在 ADDR_BITS 表示范围内；当前 RGB888 640x480 的 FRAME_WORDS=230400，2*FRAME_WORDS=460800 < 2^21。`frame_ack && !ack_prev` 同一采样沿继续锁存 active/rows/old/new 的同步值，握手行为不变。独立候选与小位宽穷举等价脚本见 `wipe_address_candidate.v`、`check_wipe_address_equivalence.py`。

器件规格（EM638325 Rev3.2 表16，PDF第20页）：-5/-6/-7 档 tRC=55/60/63ns，tRCD=15/18/21ns，tRP=15/18/21ns，tRAS min=40/42/42ns、max=100us；tWR 与 tCCD 共享表格单位 `tCK`，tWR=2 tCK（100MHz下20ns）；tRFC=55/60/63ns；CAS 可设2或3，tMRD=2*tCK，tREFI=15.6us。100 MHz 下按周期向上取整：-5/-6/-7 分别 tRC=6/6/7拍，tRCD、tRP=2/2/3拍，tRAS=4/5/5拍，tWR=2拍（20ns）、tRFC=6/6/7拍，tMRD=2拍。颗粒速度档需按实际完整料号确认；初始化顺序见表16注11：稳定时钟≥200us、CKE拉高、PRECHARGE ALL、MRS、至少两次 dummy AREF（AREF可在MRS前后）。

APUG011表3-1把 `Sdr_clk_sft` 定义为同频、可采用不同相位的SDRAM时钟；第12页注意事项称不同硬件频率/相位会造成读数据与valid错一拍，建议按应用调整。文档宣称方案最高200 MHz，但这不构成当前加密控制器、EG4S20 SDRAM SIP或板级走线在100MHz通过的证据。公开资料没有双边沿捕获说明。

APUG011表3-1把 `Sdr_clk_sft` 定义为同频、可采用不同相位的SDRAM时钟；第12页注意事项称不同硬件频率/相位会造成读数据与valid错一拍，建议按应用调整。文档宣称方案最高200MHz，但这不构成当前加密控制器、EG4S20 SDRAM SIP或板级走线在100MHz通过的证据。公开资料没有双边沿捕获说明。

C42 synthesis报告 `player_video42_sdram100/build/manual/AC201_tf_hdmi_gate.timing` 的时钟摘要为 mem 100MHz、C-period=10ns、R-period=13.011ns、SWNS=-3.011ns；报告置信度为 Synthesized，clock skew列为0；routed STA为时序最终依据。最慢 mem 同域端点为 `write_buf/rd_addr_reg[2]` → `frame_fifo_read_m0/state_reg[2]`，逻辑延迟12.895ns、11层（LUT6×5、ADDER×4、LUT5×2）、Slack=-3.011ns；第二条到 `App_rd_en_r_reg` 为12.662ns、Slack=-2.778ns。相关路径由FIFO rd pointer经used-word水位、`frame_fifo_write`比较和into_burst逻辑进入读仲裁；先优化水位比较与状态重叠逻辑，并保持FIFO余量/读写互斥。

C42合成IO估算：mem→shift的 `sdr_t_reg`→DQ pad delay=9.663ns、Slack=-5.663ns；shift→mem的DQ pad→`sdram_syn_1.bpad` delay=6.453ns、Min Period=10.488ns、Slack=-0.293ns。此合成报告的clock skew=0，最终结论以route后的PAD/时钟路径为准。wipe地址 `App_rd_addr_r_reg[9]` → 加密控制器 `app_rd_addr_1d_reg[14]` 为11.223ns、Slack=-1.703ns。

C42 routed报告 `player_video42_sdram100/build/manual/AC201_tf_hdmi_pr.timing` 已完成：overall SWNS=-4.428ns；mem 同域 SWNS=-0.139ns；mem→SD SWNS=-1.329ns；SD→mem/DQ输入 SWNS=-4.428ns。mem→SDRAM DQ输出端点实际 `sdr_t_reg`→DQ PAD，Slack约-2.001ns；SDRAM DQ PAD→mem 输入约-4.428ns。路由证据确认100MHz/144°的双向PAD预算均有负裕量，需先处理跨PAD时钟/数据相位问题，再评估内部 FIFO 和 wipe 逻辑优化收益。

## Phase 9 ns 候选与边沿配对

候选为保持 `ext_mem_clk=100MHz`，把 `ext_mem_clk_sft` 从 C2 DIV10/CPHASE3（144°、4ns）移到 CPHASE8（324°、9ns），SDRAM DQ PAD继续用正沿 `INPCLKMUX=CLK`。本节只分析本地C42 routed path和EM638325数据表，不表示已生成候选DB/完成仿真。

1. **写出 setup**：C42当前phase4的 `sdr_t_reg`→DQ输出PAD setup slack约-2.001ns。捕获边沿相位从4推至9增加5ns，保持route延迟的线性估算为 **+2.999ns**。新STA仍需核对32个DQ、command/address/control PAD，以及shift时钟输出路径。
2. **读入 setup**：当前 C42 setup path为`ext_mem_clk_sft` launch 4ns，经SDRAM_CLK网络/输出PAD到硬IP时钟约9.568ns；EM638325 `tAC(max)=5ns`，DQ达到硬IP PAD输入约14.568ns，再经输入PAD延迟1.453ns，当前捕获mem edge10ns、时钟到输入FF约11.366ns，故slack=-4.428ns。phase9时输出PAD采样边沿预估到14.568ns，DQ max到达19.568ns，输入PAD数据延迟后约21.021ns；mem edge20ns到采样FF约21.366ns。按现有setup/uncertainty估算约 **+0.572ns**。edge10采到上一beat；edge20是当前beat在`tAC(max)`下第一次可用的mem采样沿。
3. **multicycle setup边界**：TD SWUG200《时序约束用户手册》3.12.3（印刷页32）指出，setup `N`会将捕获setup edge推后；默认hold检查用setup前一个capture edge。phase9候选setup2把DQ→输入PAD路径从mem edge10移至mem edge20。静态候选约束可将source限制到 `ext_mem_clk_sft`、endpoints限制到32个DQ PAD `.bpad`：`set_multicycle_path 2 -setup -from [get_clocks ext_mem_clk_sft] -to [get_pins -hier -regexp {.*u_frame_buffer/u_sdram/sdram_syn_[0-9]+\.bpad}]`。该例外表达外部存储器真实`tAC`让beat在edge10前尚未到达、PAD FF在edge20捕获。需在Timing Exception Report确认source/capture pair、所有32个端点、例外优先级和路径有效状态。
4. **hold pairing**：按数据beat事件周期表示：当前beat来源为PLL shift edge `n@9ns`，实际SDRAM CLK PAD edge估算为`n@14.568ns`，DQ在`tAC`后有效，接收PAD在`mem edge n+1@20ns`捕获；下一beat来源为`n+1@19ns`，其实际CLK PAD edge约`24.568ns`，它的最早变化须相对`capture n+1@20ns`满足hold。对周期相同的跨时钟检查，这相当于setup2默认自动hold所分析的相邻source/capture边沿（source9→capture10，周期平移后为source19→capture20）。C42现有min path供参考：DQ source edge4ns→mem capture edge0ns，data min=1.852ns，Slack=8.392ns；这不是phase9的目标pair。此物理候选不增加`-hold 1 -end`：TD手册说明setup2自动使用setup前一capture edge，在周期重复后检查下一beat对当前采样沿的hold；增加hold1会把hold检查移回旧capture相位，改变待检查的beat关系。候选STA必须在hold报告中确认source edge19/capture edge20对应的实际绝对边沿，并检查`tOH(min)`/PAD最小路径。
5. **数据/valid latency**：C42顶层`frame_buffer_rgb888`实际参数为`SDR_READ_CAPTURE_DELAY=0`、`SDR_READ_DATA_DELAY=1`；`frame_read_write`保留`Sdr_rd_en` raw valid，且无条件打一拍`Sdr_rd_dout`。phase9下第一有效DQ beat由PAD在其后首个可用mem沿采样，raw valid由加密控制器内部mem周期产生；它们会否错一拍需完整gate+实际EM638325模型逐拍比较。`DATA_DELAY=0`是待测候选，需对比0/1组合、首beat和末beat、刷新停顿与读FIFO内容；SDRAM CLK相位调整和STA例外均不改变valid RTL时序。

EM638325 Rev3.2表16给出`tAC(max)=5ns`（-5档）、5.4ns（-6/-7档）、`tOH(min)=2/2.5/2.5ns`，`tIS=1.5ns`。对-6/-7，phase9估算入向余量比-5再少约0.4ns；准确速度档需以器件料号为准。`-setup2`/phase9 candidate应与新physical STA和门级/模型内容比较绑定；任何负hold或valid错位均判失败。phase-only候选先于TOFF实验评估；TOFF脚本仍独立留档且未运行。

## Phase9 STA 独立审计

phase9 route 后的 MCP / DQ hold / abnormal input delay 逐项审计见 [phase9 timing exception audit](phase9_timing_exception_audit.md)。该审计确认32个DQ例外路径均被分析，setup与自动hold都有对应检查；summary分组原因、hold边沿配对、输入延迟来源待核对项均在专题记录列明。

本轮选择 phase9/data0/setup2-only 作为唯一继续评估的候选；其中 phase9、`SDR_READ_DATA_DELAY=0` 与 setup2 仍须由 routed STA 和门级/SDRAM 模型验证。历史 `pad_probe` TOFF 脚本已在入口加停用保护，作为未执行的研究记录保留，不属于当前候选或交付 manifest。

## TD PAD 输出使能调查

## 启动 AREF 门控审查

C42 `player_video42_sdram100/src/user_source/hdl_source/SD/sdram.v` 将 SIP 内部 `controller_init_done` 原样接至 `sdr_as_ram.Sdr_init_done`，顶层 `Sdr_init_done` 则由两个寄存器延后输出。wrapper 在 `Clk` 上采样内部 done 与 `Sdr_init_ref_vld`，仅计数 done 已持续可见后的 valid 高转低；第二个下降沿通过移位寄存器置位外部 ready。复位异步清零两级计数状态。

边界推导：初始化 valid 下降沿与内部 done 上升沿同时发生时，采样寄存器在该边沿看到的是旧 done=0，因此该下降沿不计入；即使 valid 脉冲比 done 多维持一个采样周期，`controller_init_done_d` 仍需先延迟一拍生效。后续完整的两个 `Sdr_init_ref_vld` 高低周期才会使外部 ready 变高。C41 既有生产 gate 证据表明原 raw done 在 PREALL=1、MRS=1、AREF=0 时已到达约870ns；这个 wrapper 逻辑针对的是初始化协议缺少两次 AREF 的问题。rawdone仍由 IP 自身产生并继续连接控制器内部接口。

定向 fixture `tb_startup_refresh_gate.sv` 直接 include 并实例化生产 `SD/sdram.v`，由 `sdr_as_ram` stub 按独立时间表驱动 raw done/ref_valid，dummy PHY 无存储行为。覆盖初始化 valid 下降沿排除、一次周期 AREF 后仍未 ready、第二次周期 AREF 后 ready，以及一次 AREF 后复位中止、重新启动并重新累计两次。夹具绑定的生产 `sdram.v` SHA256 为 `131A14483969DD0AB59E2E53DCE835F2AC2DCD9E923F70FA8494F10E4D4428BC`；ModelSim 编译时需以 `player_video42_sdram100/src/td_project` 为当前目录，使生产源里的相对 `global_def.v` include 可解析。夹具尚未运行；完整 gate/EM638325 模型验证仍需观察应用流量只在两次周期 AREF 后开始。

安路TD 6.2安装包 `sim_release/eg4/eg_phy_pad.v:99-100` 与 `arch/eagle_macro.v:736-737` 声明 `TO_DFFMODE`（NONE/FF/LATCH）和 `TO_REGSET`（RESET/SET）；这证明EG_PHY_PAD primitive有TO寄存器参数。它不证明当前SDRAM SIP接受该参数。C42 gate netlist 的每个 DQ PAD（例如 `sdram_syn_47`）实例包含 `.DO_DFFMODE("FF")`、`.IN_DFFMODE("FF")`、`.TSMUX("INV")`，`.ts(sdr_t)`直接由共享的 `sdr_t_reg`驱动，TO参数未写出且落入默认NONE。`sdram.ipc`只有Type/Device/inst；`EG_PHY_SDRAM_2M_32`实例封装在vendor SDRAM SIP内部，项目RTL没有可把TO设置传进其内部PAD的参数。

TD 6.2 `run.exe`、`td.exe` 中可查到 `Gate Property pack_seq_in_io on`、`Rtl Directive /*synthesis iob = true*/`、`IO Constraint PackReg ON`，因此确有受支持的IO时序寄存器packing控制。工程现有 `set_param gate pack_effort high` 仅是通用packing effort；`pack_seq_in_io` 当前为auto，可按TD的gate参数用 `set_param gate pack_seq_in_io on` 进行候选综合。RTL `/* synthesis iob = true */` 是工具识别的属性字面串，适合对可见RTL寄存器施加；SIP封装内部32个PAD的属性需要由IP或底层实现配置。二进制还提示“reg has more than one sink...”等TREG拒绝条件，故共享 `sdr_t_reg` fanout 32时，即使强制on是否会复制32份并映射成TREG，仍需看新的gate网表每个DQ PAD的 `TO_DFFMODE` 和 physical timing验证。ADC `set_pin_assignment` 的 PackReg ON 有工具二进制字符串依据，但当前可读手册/ADC样例未发现可确认的完整语法，目前只记录该属性名和值。TD help `doc/cmd/help_comment_opt.json`确有 `phys_opt -force_replication_on_nets <net> -fanout_threshold <num>`，含义是目标net的HFN复制；未说明会把TREG打包至PAD。

EG4 `template/verilog/Device-Primitive/EG4/I,O/eg4_i_o.v` 存在 `EG_LOGIC_ODDR`，其 `d0` 为posedge输入、`d1`为negedge输入；常量 `d0=1,d1=0`可形成源时钟频率的转发方波，这是原语语义上的可行候选。APUG011参考工程仍把PLL移相时钟直接引作SDRAM时钟，没发现ODDR驱动SDRAM_CLK的厂商参考。ODDR可能改变时钟到PAD的插入延迟，对setup的改善需布线验证。基于C42 routed同一路径固定延迟做的一阶phase扫描模型（当前phi=4ns）为 `DQout_slack(phi)≈-2.001+(phi-4)`、`DQin_slack(phi)≈-4.428-(phi-4)`；两侧同时过零要求phi≥6.001ns且phi≤-0.428ns，估算窗口空缺6.429ns。该式用于判断当前phase shift的方向和相对矛盾；具体相位或ODDR变更需以新的C42 routed STA为准，当前模型未含重新布局布线、外部tAC及板级偏斜。若ODDR减少数据/时钟之间的PAD延迟差，仍需新网表、primitive参数、SDRAM模型及routed双向setup共同验证。

wipe算术候选保留同步两级元数据和 `frame_ack` 上升沿锁存，改用ACK捕获的 `old_base/cut_absolute/base_delta`，令绝对地址范围比较与基址差加法并行。Python小位宽全域穷举覆盖所有8-bit地址、合法cut、buffer与active/new/old组合，10,240组通过；当前实际参数 `2*FRAME_WORDS=460800 < 2^21`。该检查只证明有限域等价关系，不提供FPGA时序证据。

## 最小变更与验证

1. 在 C42 副本只修改 `sys_pll.v` 与 `sys_pll.ipc`：C1/C2 100 MHz，C2 相对 0°输出 144°；保留 C0 50 MHz。`video_pll`、SD/MMC 时钟、TF 与像素时钟不变。
2. 在 C42 副本更新 `global_def.v` 的 SDR 时钟周期宏至 10 ns；确认预处理后的加密控制器确实引用此宏。将 50 MHz 专用计数/门延迟逐项审查，不盲目全工程替换常数。
3. 查看 TD 合成、布局布线后时序报告：100 MHz mem 域最差 setup/hold、外部 SDRAM 时钟相位与输出数据偏移、25/50MHz 相关跨域路径、异步 FIFO 的 CDC/例外覆盖、PLL 锁定及时钟扇出。要求 routed 时序无负 slack；报告逐条复核命令接口，而非只看汇总 clean。
4. 命令间隔门级波形至少量测 PRE->ACT=tRP，ACT->READ/WRITE=tRCD，ACT->PRE=tRAS，WRITE->PRE=tWR，ACT->ACT 同 bank=tRC，READ 数据延迟/CAS、MRS CL 与 burst length；初始化须满足上电稳定等待、PRECHARGE ALL、两次 AREF、MRS 和所需等待。对 EM638325 Rev3.2 的 ns 参数按 10 ns clock 向上取整，核对 MRS 的 CL 编码。
5. C42 首轮仍播放同一 480p 媒体，保持其他时钟、媒体、输出模式、缓存参数与功能配置不变。记录 PLL 锁定、SDRAM init done、刷新标志、长时间帧稳定和真实板测结果。只有上板观察标注为板测；规格推断和仿真/门级证据分别报告。

## 证据状态

- 源码可见事实：C41 PLL/IP 参数、公开宏、顶层时钟接线、异步 FIFO 两端时钟与顶层读返延迟参数0/1。
- 器件规格推断：参数来自 EM638325 Rev3.2 原厂 PDF 表16；Speed grade由实际颗粒料号决定。
- 既有工具证据：`player_video41_refresh/build/manual/AC201_tf_hdmi_pr.timing` 为 C41 routed timing，mem 时钟 50 MHz，R-Period=17.380ns；不适用于推定 100 MHz。
- C41 routed IO setup路径：mem→shift为 `sdr_t_reg` 到外部 SDRAM DQ PAD，Slack=2.160ns，Data Path Delay=9.047ns（PAD 8.565ns+net 0.482ns），Clock Skew=3.307ns；输出时钟相位8ns。shift→mem为 SDRAM DQ PAD 到 EG_PHY_SDRAM 输入 `sdram_syn_1.bpad`，Slack=1.572ns，Data Path Delay=6.453ns，Skew=4.035ns；移相 launch=8ns，下一个mem capture=20ns。提高到100MHz并保留144°后，相位差/采样沿预算分别变成4ns/6ns；已有布线延迟粗略对照表明两个方向都面临setup压力。应核查C42新布线结果与EG PHY/SIP时钟模型的PAD约束，不从相位设定值直接断言外部实际裕量。C41报告显示 `sdr_t_reg` 单沿发射，没有观察到双边沿触发证据。
- C42 synthesis：根侧运行完成，status=success；摘要与关键负 slack 端点见上文。
- C42 routed timing：physical status=success；overall=-4.428ns，mem-self=-0.139ns，mem→SD=-1.329ns，SD→mem=-4.428ns。
- C42门级/板测：尚未发生。

