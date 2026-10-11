# HDMI 数据岛被动包级观测方案

日期：2026-10-08  
目标：仅从 HDMI 加密 transmitter core 的并行 TMDS 输出观察音频包，不改动送往 PHY 的信号。当前基线：`player_fat32_status_diag` 位流 SHA-256 `0EE4EF71838B3CAD7F0C360E9FEAAA5672C2DE7C5FA6BA21C73F9EEE8B5BD907`，EG4S20BG256，LUT 16533/19600、LE 17907/19600。已知 tone 输入状态计数有效且变化符合 DDS 频率，但尚未观察到输出 packet 或 sample 内容。

## 结论与适用边界

最小可行观测点是 core 的 `O_ch0_tmds_data`、`O_ch1_tmds_data`、`O_ch2_tmds_data` 三组 10-bit 并行字符，在 `hdmi_phy_warpper.v` 之前分支采样。tap 仅扇出，不门控、不复用、不回灌 `I_tmds_channel_*`。不要在这里先 bit-reverse：APUG092/工程 PHY wrapper 把字符位序重排给串化器，观察点收到的仍应按 TMDS 字符数值解码。

被动解码器的最低有用输出建议为：岛/包计数、音频样本包计数、ACR 包计数、header BCH 错误计数、四个 subpacket BCH 错误计数、SP/layout/flat/B 标志、合法样本数、`+1,000,000/-1,000,000/其他` 三类样本计数，以及最近一组 L/R 样本和最近 CTS/N。它能区分“输入端有效样本正常”与“core 输出岛包缺失、字段异常、BCH 不自洽或样本值异常”。它不能单独证明 HDMI PHY 差分引脚、线缆或接收器后端没有问题。

一个 data-island period 可以连续含多个 32-clock packet；包和包之间没有 guard band。一个 island 开始处只有一组 leading guard，末尾只有一组 trailing guard。header 位和 subpacket 位按 lane 在同一 32-clock packet 内同时传输。因此 packet 的第 32 拍后必须先检查下一个字符是否为 trailing guard；若不是，就在该拍立即开始下一 packet，不能每 32 拍强制消耗两拍 guard。

## 字符、preamble 与 guard-band 检测

以下 10-bit 数值使用标准 HDMI `q_out[9:0]` 记法，在 core-to-PHY 并行边界直接比较：

| 模式 | TMDS ch0 | TMDS ch1 | TMDS ch2 |
|---|---:|---:|---:|
| control `(D1,D0)=00` | `0x354` | `0x354` | `0x354` |
| control `(D1,D0)=01` | `0x0AB` | `0x0AB` | `0x0AB` |
| control `(D1,D0)=10` | `0x154` | `0x154` | `0x154` |
| control `(D1,D0)=11` | `0x2AB` | `0x2AB` | `0x2AB` |
| island preamble 每拍 | H/V control 任意合法值 | `0x0AB` | `0x0AB` |
| video preamble 每拍 | H/V control 任意合法值 | `0x0AB` | `0x354` |
| data-island guard 的 ch1/ch2 | ch0 为 TERC4 `0xC..0xF` 对应符号 | `0x133` | `0x133` |

控制字符解码：`ch0 D0=HSYNC, D1=VSYNC`；`ch1 D0=CTL0, D1=CTL1`；`ch2 D0=CTL2, D1=CTL3`。每个数据 period 前要求 8 个相同 preamble 控制字符；岛 preamble 的 `CTL0..3=1,0,1,0`，所以 ch1/ch2 都为 `(D1,D0)=01 → 0x0AB`。若只需可靠被动计数，确认紧邻 leading guard 前的 8 个控制字符均为 ch1/ch2=`0x0AB`（岛 preamble），并在随后两拍验证 leading guard；同时用 ch2=`0x354` 区分 video preamble，避免把普通 blanking 控制段当岛。

Guard band 比较要按标准的 lane 分工做：ch1、ch2 必须都为 `0x133`；ch0 不要求某一个固定 10-bit 字符，它承载 H/V 对应的 TERC4 `C/D/E/F` 之一（ch0 低两位恢复 H/V）。在 ch0 上先 TERC4 反解并验证 nibble 高两位为 `11`，不应用任意固定 `ch0 == ...` 比较。连续两个这样的 guard 字符才确认 leading/trailing guard。一个岛包至少一个、最多 18 个 packet；每个 packet 固定 32 个 TMDS clock。

实际实现 FSM：`CONTROL/PREAMBLE_SCAN → ISLAND_GB2 → PACKET32_SIMULTANEOUS → PACKET_BOUNDARY`。header与四个body在同一32拍同时收集，不是先后两个32拍。第32拍完成后，边界如见guard则确认第二拍结束岛；否则当前字符立即作为连续下一个packet的第0拍。非法TERC中止当前岛重新搜control/preamble；完整坏BCH包只计一次并跳过音频/ACR计数，继续下一包。原研究草案顺序HEADER32/BODY32描述已纠正；资源压缩版不保存ECC副本，计数16位65535饱和。

## TERC4 解码、header 与 subpacket 位平面

TERC4 反查表（输入 nibble 0..F，表项为并行 10-bit TMDS 字符）：

`0:29C  1:263  2:2E4  3:2E2  4:171  5:11E  6:18E  7:13C  8:2CC  9:139  A:19C  B:2C6  C:28E  D:271  E:163  F:2C3`

每拍 island packet 的通道拆法：

- ch0 TERC4 nibble 的 bit0=HSYNC、bit1=VSYNC、bit2=该拍 packet header/BCH 当前位；bit3 保留/不用于 packet 字段。连续 32 拍收集 `HB0[7:0], HB1[7:0], HB2[7:0], BCH[7:0]`，每个 byte 的 bit0 先到。HB0=`0x02` 为 Audio Sample Packet，HB0=`0x01` 为 ACR。
- ch1/ch2 TERC4 nibble 的四个 bit plane 分别对应 subpacket 0..3。对 packet body 的 32 拍 `i=0..31`，`SPs[2*i] = ch1_nibble[s]`，`SPs[2*i+1] = ch2_nibble[s]`。所以每个 64-bit block 按两 lane 逐拍交错，恢复后先是 SB0 bit0、SB0 bit1……SB6 bit7，最后 8 bit 为 BCH parity。四个 block 各自有独立 BCH(64,56)，不能把 4 个 lane block 合成一个校验。
- header 是单独 BCH(32,24)，只覆盖 HB0/HB1/HB2。packet body 四个 subpacket 的 7 data bytes 加 1 parity byte 分别形成四个 BCH block。

手册给定生成多项式 `G(x)=1+x^6+x^7+x^8`。实现时用 8-bit LFSR 在线处理，不需要保存整包：对进入的每个数据位（byte 内 bit0 至 bit7），`feedback = reg[7] XOR data_bit; reg = (reg << 1) & 0xFF; if feedback: reg ^= 0xC1`。数据段结束后，按发送顺序逐位比较 8 个接收 parity 位与 `reg[7]`，每比较一位后 `reg <<= 1`；这也给出 JSON 向量的明确 parity bit order。header 3 bytes、每个 subpacket 7 bytes各跑一个 LFSR。有效向量校验为零错误；可再在仿真中翻转一个有效 data bit 和一个 parity bit，确认对应计数递增。上面的递推按 HDMI 标准的生成器和 bit0-first 顺序写成外部算法；在首次 RTL 仿真中应先与相邻 JSON 的全部 parity/32 符号逐项对照。

串行方向不等于 byte 的 MSB-first：HDMI 标准规定每个 10-bit TMDS 字符 `q[0]` 首先串出，`q[9]` 最后；lane wrapper 对并行输入作逐位反转以适配 PHY/串化器。包字符仍先用该表比对 10-bit 并行值。packet 内 bit0-first、TMDS 字符 q0-first 是两层独立位序。

## Audio Sample Packet `0x02` 与样本重组

- `HB0=0x02`。`HB1[4]` 是 layout（0=双声道、每个 subpacket 是一个 stereo sample pair；1=最多 8 声道、每 packet 一个采样时刻）；`HB1[3:0]` 分别为 `SP3..SP0`，也就是 `SP0=HB1[0]`、`SP3=HB1[3]`。layout 0 的合法 SP 模式是 `0000,0001,0011,0111,1111`（按 `[3:0]` 写）；应只把 SP=1 的 block 当样本有效。`HB1[7:5]` reserved，应记录异常但别依赖其值定位包。
- `HB2[7:4]=B3..B0`，标记各 subpacket 是否是 192-frame IEC 60958 Channel Status block 的首帧；`HB2[3:0]=flat.sp3..sp0`。flat 仅在对应 SP=1 时有意义。B/flat 不应混入 sample-present 解码。
- layout 0 每个 subpacket 对应一个连续立体声 sample pair。`SB0={L slot11..4}`、`SB1={L slot19..12}`、`SB2={L slot27..20}`；`SB3/SB4/SB5` 对应 R；低 4 个 IEC slot bits 是 HDMI 格式隐含的 0。重组 `L[23:0]={SB2,SB1,SB0}`，`R={SB5,SB4,SB3}`。即 SB0 是样本低 8 位，不要反着拼接。`SB6={PR,CR,UR,VR,PL,CL,UL,VL}`，其 P 是每声道 IEC 60958 even parity，V/U/C 是有效、用户、通道状态。
- 对当前 tone 的建议内容检查：只有 `SPx=1 && flat.spX=0` 时计入有效 tone sample；将 `{SB2,SB1,SB0}` 按 24-bit 二补数解释，分类为 `+24'sd1000000`、`-24'sd1000000`、其他。若实际输入有增益/衰减参数，容差必须来自实际工程配置后再设；目前给出的 DDS ±1,000,000 值与 packet sample 的等值对应关系还没有被板上包级观测验证。

## ACR `0x01` 的 CTS/N

`HB0=0x01` 表示 Audio Clock Regeneration Packet，HB1/HB2 标准上忽略。四个 subpacket 内容应重复同一组 ACR subpacket；至少分别对 SP0、SP1 检查一致性，优先只计重复一致的 packet。一个 ACR 子包：`SB0=0`；`SB1[3:0]=CTS[19:16]`（高 nibble reserved=0）；`SB2=CTS[15:8]`；`SB3=CTS[7:0]`；`SB4[3:0]=N[19:16]`（高 nibble reserved=0）；`SB5=N[15:8]`；`SB6=N[7:0]`。即 20-bit 数值按高 nibble 再中、低 byte 拼接。CTS=0 表示没有新 CTS 值。诊断只需缓存 CTS/N、做四 subpacket 相等检查和更新计数；不需要据此重建音频时钟。

## 独立向量

[packet_probe_vector.json](packet_probe_vector.json) 是 32-clock Audio Sample Packet 的完整解码边界向量：有 3+1 header 字节、四组 7+1 subpacket 字节、接收位序、TERC4 nibble 和 3×10-bit 并行字符。4 组左右样本特意不同，覆盖低/高字节、符号位、0 值与全 1 值；SB6 的 P 位按 24-bit 样本的 even parity 生成。JSON 自带 BCH 逐位生成递推与 packet lane 映射，可在无 FPGA 板条件下由独立 Python/HDL testbench 重算并对照。它是合成自检向量，不宣称为当前 bitstream 实际发出的数据。生成参数/参考依据：

- 本地索引 [_资料内容清单.md](<E:/QQ CACHE/Download/安路资料/_资料内容清单.md:91>) 指向 [APUG092 HDMI 1.4b transmitter 手册](<E:/QQ CACHE/Download/安路资料/赛题1_工作资料/05_补充参考工程/官方赛题1_康芯2026/lab_ex5_i2s/doc/APUG092_HDMI1.4b_Transmitter_V1.0.docx>)。它是公开项目保存的安路手册副本；GitHub 镜像说明记录其与康芯官方赛题包同名 DOCX 逐字节一致。工程参考 PHY [hdmi_phy_warpper.v](<E:/QQ CACHE/Download/安路资料/赛题1_工作资料/05_补充参考工程/APUG092_GitHub镜像/src/user_source/hdl_source/hdmi_phy_warpper.v>) 清楚展示并行 10-bit 输入在 PHY 前的 bit reverse。
- HDMI Licensing, LLC 原始 HDMI Specification v1.3 的 [公开 PDF](https://fpga.mit.edu/6205/_static/F24/default_files/CEC_HDMI_Specification.pdf)（规范章节 5.2.1、5.2.3.3–5.2.3.5、5.3.3–5.3.4、5.4.1/5.4.3、7.6）给出 preamble/guard、packet lane 映射、BCH 生成多项式、音频字段和 `q[0]` 首发顺序。v1.3 与此处基础 TMDS data-island/packet 布局的 v1.4b 用法相同；这项研究未找到 HDMI Adopter extranet 的 1.4b 完整规范下载权限。
- AMD 官方 [HDMI RX subsystem AUX Packets](https://docs.amd.com/r/3.1-English/pg236-v-hdmi-rx-ss/AUX-Packets) 独立确认 4-byte header、32-byte body、4 个 56+8 BCH subpacket，以及 `0x01`/`0x02` packet type；作为厂商接收端交叉核对。

## Verilog 范围与资源判断

推荐独立模块 `hdmi_island_audio_probe`，三个 10-bit 输入、pixel-clock/reset、纯诊断寄存器输出。状态保持只在 pixel clock 域；对输出计数器使用饱和计数或状态页现有采样机制慢速读取，避免大 trace RAM。最小组合逻辑包括三组 16-entry TERC4 inverse lookup、control char 4-entry decode、preamble/guard/packet 状态机、header 1 个 8-bit BCH 寄存器、4 个 8-bit BCH 寄存器、packet bit/byte 计数、header 字节缓存、样本字段/ACR 字段寄存器及结果比较。全量 payload FIFO 并无必要。

粗略额外状态约 280–380 个 FF（四个 64-bit codeword 不需存，只有 BCH LFSR、计数器、字节与 4×样本/metadata 暂存），主要逻辑约 300–700 LUT/LE 的量级；这是架构估算，不是综合结果。当前显示资源还余 3,067 LUT、1,693 LE。该只观测设计很可能放得下，但 LE 余量约 8.6%，而且已有工程时序/布线裕量未知；不能承诺一次综合/布局成功。可先砍掉样本全寄存器，只保留四个滚动 24-bit L/R 检查寄存器和最近值，再将 ACR 只留下 CTS/N 与一致性 flag，最容易维持资源上限。诊断 logic 要接原 pixel clk；本设计不建议额外跨时钟 FIFO 或 ILA trace RAM。

预计完整可行验证顺序（本任务未运行）：先对 JSON 32-word 向量做外部 testbench，逐拍核对 TERC 反查、4 个 sample、header/body BCH；加入连续两个 Audio Sample Packet、随后两拍 trailing guard，再加单比特故障和跨包边界；最后只综合不下板，检查新模块前后资源和 STA。硬件验证仍应由工程所有者按其后续授权操作。

## 未证实项 / 最小下一步

还没有从当前受保护 core 的输出获得真实 10-bit packet 字符，所以不知道现板 tone 最终封装是否为 layout 0、每包 sample-present 数、core 发出的 channel-status/parity 字段，也没有用实际 board stream 对 LFSR bit order 做 golden capture 对照。规格允许这种被动探针方案，但综合/资源/时序可行性是估算。PHY 之后的线缆/接收端问题仍需另一层证据。

下一最小步骤：以本文件和相邻 JSON 为规格，独立新建一个只读 pass-through 的 probe RTL 与 testbench；测试其能逐拍解析 32-word 合成向量、连续 packet、guard 终止和 BCH 单比特错误。通过后才把模块接到 core 输出 tap 做综合评估；本文件阶段没有修改播放源、构建或操作板卡。


