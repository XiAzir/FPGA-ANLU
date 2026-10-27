# TF SPI 25 MHz 外部时序审查（首阶段）

日期：2026-10-27（北京时间）  
范围：只读检查；未改生产 RTL、引脚/时序文件、TD 工程、位流；未运行 TD/EDA 或操作硬件。输出仅在 `development/video40_work/timing_review/`。

## 结论摘要

- 匹配的 AC201 ES8388 底板原理图（`赛题1_工作资料/03_小梅哥硬件与例程/AC201_底板_旧版_ES8388.pdf`，第4页“SPI SD卡接口”）显示卡座 J2 的 CLK、CMD/MOSI、DATA0/MISO、DAT3/CS 以 SD_CLK/SD_MOSI/SD_MISO/SD_SC 同名网标接出。四条线上没有串联电阻、MOSFET 电平转换器或总线收发器；卡座 VDD 接 VDD3.3。R26–R30 是10kΩ上拉网络（含 SD_SC、SD_MOSI、SD_MISO 和未用 DAT 线）；CLK 无串联元件。该结论由原理图连接图得出，未检查板上实物或 PCB 走线长度。
- C32（`development/player_video32_read_return`）及 C34（`development/player_video34_1080p15`）的 `timing.sdc` 同构：20ns、50MHz 主时钟，`derive_clocks`，再 rename PLL 时钟；文件注释明确写有“Board-level SPI I/O delays remain uncharacterized at this stage”。二者 `pin.adc` 均将 `sd_dclk=M2`、`sd_mosi=L3`、`sd_miso=K6`、`sd_ncs=R2` 配为 LVCMOS33；MISO 使用 PULLUP。SD 外部输入/输出 delay 当前未建模。
- 当前 SD Association 公布的 Physical Layer Simplified Specification 9.10，发布日期 2023-12-01。规范第2节 default-speed 频率上限25MHz；第5节 CSD TRAN_SPEED 说明当前 SD 卡默认值032h代表25MHz最大工作频率。SPI第7.8节指向与SD模式相同的总线时序；但本公开简化版把第6.6.6的 Table 6-13及输入/输出 timing 表明确标为从 Simplified Specification 移除，第7.5.4 Table 7-7 SPI Timing Values也标为移除。因此本公开简化版没有可引用的 `tISU/tIH/tOD/minhold` 数值；SD Association页面可核实当前版本和日期。
- 初始化慢速要求取规范第4.2节：识别阶段使用 fOD，并指向6.6.6。规范的 SPI 初始化序列用 100–400kHz；本工程README记录初始化100kHz，落在该范围。规范当前简化版将精确 fOD 数值表移除，因此将“100–400kHz”作为初始化操作范围依据，并避免声称获得了更细的SPI时序表值。
- 当前板卡方案下，12.5MHz为生产基线；目标25MHz采用50MHz上升沿控制、SCK约每个sys上升沿翻转一次，mode 3（idle高、下降沿更新、上升沿采样）。每个SCK边沿间隔20ns，完整周期40ns。此20ns是逻辑设计目标/推导值，不是卡与板的实测边沿延迟。

## 原理图与工程证据

| 核对点 | 证据 | 结论 |
|---|---|---|
| 卡座/信号路径 | ES8388版AC201 PDF，第4页“SPI SD卡接口”，J2 MicroSD_SOCKET | CLK/CMD/DATA0/DAT3 通过网标 SD_CLK/SD_MOSI/SD_MISO/SD_SC 直接连接信号网；无串联电阻或电平转换芯片 |
| 偏置/供电 | 同页 R26–R30 与 J2 | 10kΩ上拉、VDD3.3；CS、MOSI、MISO有上拉；SCK无上拉 |
| FPGA引脚/IO标准 | C32 `src/user_source/constraints_source/pin.adc`，第10–13行；C34同路径 | M2/L3/K6/R2；LVCMOS33；MISO PULLUP |
| 时钟与外部时序 | C32/C34 `src/user_source/constraints_source/timing.sdc` | 50MHz主时钟、derive/PLL rename；没有TF input/output delay；注释明确待表征 |
| SPI当前基线 | `development/player_spectrum_spi12p5/README.md`、SD `spi_master.v`/`sd_card_top.v` | 当前候选记录数据SCK12.5MHz、clk_div=0；mode 3。新RTL候选另由根和SPI代理集成/复核 |

注：旧版AC201原理图中的连接判断适用于实物印字匹配 AC201、Codec 为 ES8388 的板卡；新版文件名与板卡修订可能不同，未将别的 Codec 版底板图用于推断音频针脚。

## SD 公开规范核对

- 版本：SD Association “Physical Layer Simplified Specification”, Part 1, v9.10，2023-12-01。SDA当前简化规范下载列表列出该版本。
- 25MHz：第2节 default speed mode 写3.3V、最高25MHz；第5节 CSD TRAN_SPEED 说明当前SD卡值032h即25MHz mandatory maximum。
- SPI与标准关联：第7.8 Bus Timing写 SPI timing 与 SD mode 相同；SPI电气条件也与 SD mode 相同（第7.6/7.7）。
- 数值限制：第6.6.6图示默认模式 Card Input Timing 和 Card Output Timing；公开简化版的表6-13/14/15等以 “Removed in the Simplified Specification” 标注；第7.5.4 “Timing Values”及表7-7亦标记 Removed。因此不能从公开v9.10摘出官方 SPI `tISU`、`tIH`、卡 `tOD` 上限/下限或最小hold数值。
- 初始化：第4.2 Card Identification Mode要求卡在 fOD identification clock；初始化中的ACMD41轮询建议连续100–400kHz。
- 本地资料搜索在 `_资料内容清单.md` 中找到了 SD Card IPUG107、控制器手册和示例源码，没有发现 SD Association Physical Layer Specification PDF；没有重复下载。

主源链接：

- SDA当前简化规范列表（v9.10 / 2023-12-01）：https://www.sdcard.org/downloads/pls/
- SDA公开规范PDF（v9.10）：https://www.sdcard.org/cms/wp-content/themes/sdcard-org/dl.php?f=Part1_Physical_Layer_Simplified_Specification_Ver9.10.pdf

用于定位v9.10已移除表格的文本化副本仅作辅助检索，最终判断指向上述SDA正式版本/章节：
https://studylib.net/doc/27671932/part1physicallayersimplifiedspecificationver9.10fin-20231201

## STA约束草案（TD6.0 SDC语法；值需从卡手册/测量确定）

TD6.0 SWUG200 §3.3列有 `create_generated_clock` 的 `-source`、`-master_clock`、`-divide_by`、`-phase`；§3.8支持 `set_input_delay -clock_fall -min/-max`，§3.9支持 `set_output_delay`。其示例包含 PLL-pin source 的 generated clock 与 falling-edge input delay。

```tcl
# C32/C34主PLL输出的sd_card_clk为50MHz；SD_DCLK在该时钟域由FF产生。
create_generated_clock -name {sd_sck} \
    -source [get_pins {sys_pll_m0/pll_inst.clkc[0]}] \
    -master_clock {sd_card_clk} -divide_by 2 -phase 180 \
    [get_ports {sd_dclk}]

# 占位变量只表达延迟组成，不是已核准数值：
# D_MISO_MAX = PCB(SCK FPGA->card,max) + card tOD(max) + PCB(MISO card->FPGA,max)
# D_MISO_MIN = PCB(SCK FPGA->card,min) + card tOD(min) + PCB(MISO card->FPGA,min)
set_input_delay -clock [get_clocks {sd_sck}] -clock_fall -max $D_MISO_MAX [get_ports {sd_miso}]
set_input_delay -clock [get_clocks {sd_sck}] -clock_fall -min $D_MISO_MIN [get_ports {sd_miso}]

# MOSI output：此处用card setup/hold及两条PCB线相对延时构成有效外部delay。
# TD手册输出delay可用 -min/-max、-clock_fall；最终极性/参考边沿需看报告的edge pairing。
set_output_delay -clock [get_clocks {sd_sck}] -max $D_MOSI_MAX [get_ports {sd_mosi}]
set_output_delay -clock [get_clocks {sd_sck}] -min $D_MOSI_MIN [get_ports {sd_mosi}]
```

**候选波形解释**：50MHz源时钟20ns；generated SCK为25MHz/40ns，-phase 180对应CPOL=1的输出相位（每个sys边沿翻转，输出相邻SCK边沿相距20ns）。约束落入设计前，必须从TD时序报告核实生成时钟名称/波形、边沿映射、source/target路径和 MISO/MOSI 实际端点都被分析。若当前SD控制器仍由状态机多等一个sys拍产生SCK，则不能直接套“每拍翻转”波形；应按真实输出边沿重建模型。

**约束路径与预算**：

1. MOSI路径：MOSI在SCK下降沿更新、卡在随后上升沿采样。外部setup预算名义20ns半周期，减去FPGA输出路径、MOSI/SCK相对PCB延时及卡输入setup；hold分析使用随后下降沿，减卡输入hold及相对PCB延时。不同边沿真实分析，不给路径设false/multicycle。
2. MISO现行模式3 rising sample：卡在下降沿发起MISO变化，约20ns后主机上升沿采样。输入最大延迟由卡tOD(max)和两段板级往返组成；最小延迟用于hold/下一次变化边沿。根已指出14ns只可作为模型扫延迟点，不能标成SD标准tOD。
3. 若RTL将MISO采样推迟到下一下降沿：采样事件比现行rising-edge sample晚20ns。须用TD report证明 `sd_miso` 到实际采样FF的最大路径从前一falling launch到本次falling capture，并存在同边沿min/hold检查；还需确认同一falling时刻卡更新下一位的最早tOD与板级SCK/MISO偏斜不会抢先影响本次采样。若STA只报告rise→rise默认完整周期、约束未覆盖捕获FF，或路径落为unconstrained，这个采样余量没有得到STA证明。所有计算依赖的 card tOD/minhold 与 PCB min/max 需在实测/数据手册后填入。
4. 当前C32最终报告 setup WNS +0.393ns、hold WNS +0.021ns属于已有受约束内部路径统计；外部SPI I/O因缺input/output delay没有纳入，不得作为25MHz接口通过证据。

## C32→C34 SDRAM时钟敏感项（静态推算；2026-10-27宏审计更正）

- C32、C34与C40的 `global_def.v` 原始 `SDR_CLK_PERIOD=1000000000/50000000`，该独立宏实际求值20ns。原始 refresh macro 为 `64000000/`SDR_CLK_PERIOD/2**(`ROW_WIDTH)`；宏展开遵循整数除法左结合，成为`64000000/1000000000/50000000/2048`，第一步除法为0，故实际 `SELF_REFRESH_INTERVAL=0`。
- 因此此前审查中“当前常数表达式约1562、100MHz约3125”的表述描述加括号后的修正目标；源码宏实际值为0，现已更正。用 `64000000/(`SDR_CLK_PERIOD)/2**(`ROW_WIDTH)` 或在 `SDR_CLK_PERIOD`定义外加括号，才会令50MHz表达式得到1562、100MHz得到3125。
- C32与C40的公开 `sdr_init_ref` 前缀SHA256相同；其init_cnt在等于SELF_REFRESH_INTERVAL时清零，ref_req在等于SELF_REFRESH_INTERVAL-10时置脉冲。实际宏值0会让计数复位比较命中0；请求比较为0-10，对无符号14位init_cnt无可达匹配值；公开prefix Icarus pulse测试raw=0、括号A/B各3个周期脉冲。详见[refresh宏审计](refresh_macro/README.md)。
- C32与C40现有 gate Verilog 都将保留网 `u_frame_buffer/u_sdram/u2_ram/u2_wrrd/Sdr_ref_req` buffer到 `1'b0`；`sdram.v`中的 `App_ref_req`也是 `1'b0`。因此两份gate阶段证据显示送入refresh调度的周期请求为常量0。C32存在最终时序报告，C40当前只有gate报告，C40 final route随后由根完成；这些静态/综合证据未测量实物刷新波形、存储保持故障或具体现场因果。
- 修复宏前不要外推 refresh 周期。修正候选还须核对 SDRAM具体型号所需刷新命令频率、row/bank组织、比较off-by-one和实际已路由请求脉冲。
- SDRAM控制器主体包含保护区。只分析了`sdr_init_ref.enc.v`首个`` `pragma protect begin_protected ``之前的公开逻辑；没有读取或尝试解密保护区。控制器内部tRCD/tRP/tRAS具体周期值未从受保护代码中推断。
- C32/C34的PLL源文件记载 C0/C1=50MHz、C2=50MHz、144°相移；50MHz×144°=8ns。若升至100MHz必须重新核对PLL配置与相移。
- 初始化计数器 `pwr_200ms_cnt[17]`阈值为131072个mem时钟周期；名为200ms的注释与其50MHz下2.621ms的实际换算不一致，改频时需重新核对初始化等待阈值。
- 100MHz实施仍需重建SDC generated clocks、核查 SDRAM输出时钟/读数据采样相位、设备时序等级与全机关键路径。现有50MHz报告WNS仅适用于50MHz候选，100MHz需新报告。

## 下一步输入

1. 确认用户使用卡的具体品牌/料号或获取厂商datasheet，查SPI默认模式卡tOD(min/max)、输入setup/hold等AC表值。
2. 根对候选SPI25做整机接入后，给TA/OE与 MISO 实际采样路径查看TD pre-route和post-route edge pairing，外部延迟扫描结合真实扇区数据CRC记录最大可容纳延迟。
3. 实测板上 M2/L3/K6/R2波形或先测SCK/MOSI/MISO板级延迟与rise/fall，补全板级 min/max，确认3.3V阈值/过冲及卡负载。
4. 若提出MISO延后20ns方案，单独输出一页STA证据：capture FF、launch/capture edge、setup/hold要求、arrival/required、slack；无报告支持则视为仍待验证。
