# C40 SPI25 源码静态审查

日期：2026-10-27（北京时间）  
基线：`development/player_video32_read_return`（C32）  
审查对象：`development/player_video40_spi25/src/user_source`  
范围：文件/源码静态检查；未运行 TD、EDA、仿真或硬件；未改生产文件。

## 与 C32 的源差异

逐文件 SHA256 对比两工程 `src/user_source` 的全部文件，恰有4个差异文件：

1. `hdl_source/SD/spi_master.v`
2. `hdl_source/SD/sd_card_top.v`
3. `hdl_source/SD/sd_card_cmd.v`
4. `hdl_source/top_tf_hdmi_audio.v`

其余源文件和约束文件一致；包括 `timing.sdc`、`pin.adc`、PLL、`global_def.v` 与 SDRAM IP。C40继续采用C32的640x480 HDMI/SDRAM 50MHz实现；本轮变化集中在TF SPI快速分频路径、被动CRC观察端口及数码管显示。

## SPI_FAST_DIV0 与初始化频率

- C40在播放器top实例化 `sd_card_top #(.SPI_HIGH_SPEED_DIV(0), .SPI_FAST_DIV0(1))`。`SPI_FAST_DIV0`默认值为0；只有播放器显式设为1时，新快速路径才使能。
- `sd_card_sec_read_write`复位/初始化阶段使用`SPI_LOW_SPEED_DIV=248`，卡初始化完成后才切换至`SPI_HIGH_SPEED_DIV=0`。50MHz输入、原分频式`Fspi=Fsys/((DIV+2)*2)`给DIV248约100kHz，DIV0标准等待状态给12.5MHz。
- C40新增快速DIV0分支：当正在数据边沿状态且`clk_div==0`时，不插入`DCLK_IDLE`状态，继续每个`sys_clk`上升沿翻转SCK；C40的`sys_clk=sd_card_clk=50MHz`，于是SCK每20ns翻转一次、完整周期40ns、25MHz。CPOL/CPHA仍为1/1（mode 3，idle高；下降沿更新MOSI、上升沿采样MISO）。非零分频值沿原有等待状态运行，复位/初始100kHz阶段不走快速分支。
- 静态审查支持“初始化仍100kHz、数据态DIV0达到25MHz”的参数/状态机意图；本轮未跑仿真、TD时序或板卡验证，不构成功能或频率实测结论。进入TD前应确认 `SPI_HIGH_SPEED_DIV` 在卡进入数据阶段后才成为0，且 routed SCK实际边沿间隔为20ns。

## CRC计数观察的隔离性

- `sd_card_cmd.v`新增CRC16/CCITT计算（初值0、生成多项式0x1021）。在既有 `S_READ_WAIT` 握手识别0xFE token后清空块CRC；在 `S_READ && spi_wr_ack` 时累积512个payload字节，byte_cnt 512保存CRC高字节，513比较卡片CRC低字节并更新16-bit饱和的 `read_crc_checked/read_crc_bad`。
- 新always块只读 `state/spi_wr_ack/data_recv/byte_cnt`，只写新CRC工作寄存器和两个统计寄存器；`state` FSM、`spi_wr_req`、`send_data`、`byte_cnt`、`block_read_valid/data`未引用CRC统计结果。`sd_card_top`仅传出CRC统计；top连接到数码管页内容，没有回接读请求、命令、数据或错误处理控制。因此静态数据依赖显示为被动观察，无CRC结果到卡控制流的反馈路径。
- 被动路径仍加入CRC组合逻辑、16-bit计数器和端口，可能改变资源占用、扇出及布线关键路径；应在C40 route报告中复查它们造成的时序变化。静态观察隔离本身不保证物理无影响。

## 数码管三页及同域检查

- 新页面计数器在 `posedge sd_card_clk` 域计数到49,999,999后换页。对50MHz时钟这是约1秒一页，顺序0→1→2→0；26-bit计数器足以表示该上限。
- 三页分别显示构建号`00C11340`、`C000`+checked计数、`E000`+bad计数。`tf_page_count/tf_page/tf_page_word/status_hex595`都由同一`sd_card_clk`时钟域驱动。
- `read_crc_checked/read_crc_bad`由 `sd_card_cmd.sys_clk`产生；该实例的`sys_clk`在`sd_card_top`接到`clk`，而top的`sd_card_top.clk`接`sd_card_clk`。CRC统计和页面逻辑均处在同一50MHz时钟域，没有新增异步跨域链。
- `status_hex595`旧版配置`CLK_HZ=25MHz`并由`video_clk`驱动；C40改成`CLK_HZ=50MHz`、`sd_card_clk`。显示器件的串行输出频率随参数更新，需在静态输出路径与实物观察中验证拨码/显示效果。

## 无外部延迟的原始路径分析草案

专门 Tcl 草案见同目录 `c40_spi_raw_path.tcl`。它以最终 `AC201_tf_hdmi_pr.db`为输入，在内存中给 `sd_miso`相对`sd_card_clk`的input min/max均设0ns，给`sd_dclk/sd_mosi`的output min/max均设0ns，只导出一个另名分析DB并生成 `report_timing_path`端口路径报告。该DB只供原始物理延迟分析；0ns是报告约定，不是卡或板的实际外部时序约束，也不能称SPI接口约束通过。

外部setup预算模型（每次采样沿到下一有效采样沿按20ns半周期核算）：

`T_SCK(reg→pad,max) + T_board(SCK→card) + tOD_card(max) + T_board(MISO→FPGA) + T_MISO(pad→sampleFF,max) + Tsetup(sampleFF) <= 20 ns`

其中报告提供FPGA路径项；SD卡tOD、板级SCK/MISO走线与往返项需具体卡手册/测量。14ns只能作为`tOD`模型扫描点，不能表述成SD规范tOD(max)。模型描述的是setup上限估计，不包括hold/CE结论：MISO hold还需独立取外部最小tOD/板延迟、SCK/MISO相对偏斜、FF hold要求与实际捕获边沿进行STA核算；CE/握手功能也须检查同步逻辑行为。端口delay=0的分析报告只给出内部物理path delay。

## 命令语法来源

本地 TD6.0（SWUG200_TangDynasty时序约束用户手册，工具版本6.2.1 SP1）及既有help日志确认：

- `set_input_delay`/`set_output_delay`支持`-clock`、`-min/-max`和端口target；本地TD help日志见 `development/video26_work/report_timing_help.log` 或 `development/player_480p/build/manual/netlist_discovery.log`。
- TD报告命令名称是`report_timing_path`，支持`-from/-to/-ep_num/-path_num/-file`；help输出还确认`report_timing_summary`、`update_timing`和`import_db/export_db`既有用法。
- 草案不设置false path/multicycle，也不写回C40生产数据库。

后续：根在C40完成route后，单独执行Tcl草案；先核对SD端口名、`sd_card_clk`派生时钟和报告edge pairing，再把内部原始路径延迟与外部模型值分栏计算。hold与CE仍需独立证据。

## 工程容器/构建产物差异说明

补查整个 `src` 后，除上述4个 HDL 外：`td_project/AC201_tf_hdmi.al` 仅把 Project.Path 从 C32 工程目录改为 C40 工程目录；`td_project/beforeGateOpt.aig` 是生成/综合图产物并随候选变化；C32 的 `final_timing.rpt`、`gate.qor`、`place.qor`、`route.qor` 和 `top_inst.bid` 未随 C40 复制。它们不计入4个 HDL 源差异。C40 当前 `build/manual` 只有 RTL/elaborate 阶段数据库和日志，尚无 `AC201_tf_hdmi_pr.db`，所以 raw-path Tcl 等候实际route DB后执行。
