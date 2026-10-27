# SDRAM PAD 候选配置

状态：历史静态候选，未运行 TD，且脚本入口含 `PAD_PROBE_DISABLED` 停用保护。phase9/data0/setup2-only 是当前唯一继续评估的候选；本 TOFF 探针排除在交付 manifest 之外。保留下文作为研究记录。

`pad_probe.tcl` 使用 `import_db` 载入 `player_video42_sdram100/build/manual/AC201_tf_hdmi_gate.db`，仅在内存态修改，再导出候选 DB、Verilog 和 routed 结果。原始 gate DB 不作为输出目标。默认 `PAD_PROBE_CAPTURE_EDGE=rising`，仅启用 DQ PAD TO FF；设置环境变量为 `falling` 时另外将32路 DQ `INPCLKMUX`设为 `INV`，便于独立比较。

## OE 逐拍等价关系

C42 gate DB 的 DQ PAD共有32个。其 `osclk` / `ipclk` 接 `mem_clk`，`ce` 与 `rst` 端口未连；`eg_phy_pad.v` 声明 `tri1 ce`，故 CE默认有效。共享的 `sdr_t_reg` 是 `AL_MAP_SEQ`，clk=`mem_clk`，DFFMODE=FF，REGSET=RESET，SRMUX=0，CEMUX=1，没有显式 reset，Q还驱动内部反馈 LUT。32个 DQ PAD 当前 `ts` 都接共享 FF Q (`sdr_t`)；当前每PAD没有 `TO_DFFMODE`，所以默认为NONE。

候选保留原 `sdr_t_reg` 和全部内部反馈路径，只把各 PAD `.ts` 输入改为原 FF 的 D net `sdr_t_reg_syn_5`，并给32个 PAD设 `TO_DFFMODE=FF`、`TO_REGSET=RESET`。PAD已有 `osclk=mem_clk`；pad的默认CE为1；TO FF与源 FF同拍捕获同一D值，因此在稳定/初始化状态下输出使能应逐拍等价且没有额外流水周期。此处仍要由gate网表核对TOFF使用的时钟、CE和GSR语义，并用原始/候选仿真模型做对照。脚本在route前输出的 Verilog 应显示每个 DQ PAD 的TO参数、TS网络为D net，且源 FF Q仍保留反馈扇出。

## DQ 输入采样对照

C42 routed report 的 shift launch为4ns，mem上升沿捕获为10ns，预算6ns；现有 PAD 数据延迟6.453ns，slack -4.428ns。`INPCLKMUX=INV`会将采样正沿移到mem下降沿5ns，同一次launch只剩1ns预算，按当前路径延迟预计setup更差约5ns。此前“下降沿增加5ns setup”的假设与报告的launch/capture edge不符。脚本将falling模式作为独立反证/对照候选，默认只跑rising模式；执行前应以TD的 `INPCLKMUX`实现语义确认边沿，且需要重做读数据、`Sdr_rd_en`、FIFO capture数据valid模型。若输入边沿确改下降沿，frame buffer 的 data delay候选需独立重建并做bench。

## 时钟输出候选

EG4 `EG_LOGIC_ODDR`支持 `d0` 上升沿值、`d1`下降沿值；常量 `d0=1,d1=0`可产生频率相同的方波。C42 SDRAM_CLK当前为PLL移相时钟直通PAD，C41路由报告中该时钟路径有PLL/时钟net和PAD插入延迟。ODDR转发可能改变时钟输出边沿与插入延迟；数据PAD与时钟PAD的相对延迟、SDRAM输入tIS及读返回tAC共同决定可用相位，需要单独候选模型和新route STA。本脚本不改SDRAM_CLK。

验证顺序建议：先默认rising脚本，检查32个TO FF映射、读写pad时序及全部C42时钟组；随后以模型逐周期比对旧/候选 OE、DQ input数据与valid，覆盖写到读切换、读到写切换、burst首尾和刷新边界。falling候选独立跑同一组检查。任何route结论都来自新导出的physical.timing；没有新的TD执行前，这些文件仍为未验证建议。
