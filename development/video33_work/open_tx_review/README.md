# C33 短水平消隐 HDMI TX 可见接口与开源核审计

日期：2026-10-27  
范围：只读核对C33可见 wrapper、C33映射资源报告、EG4 `lane_lvds_10_1` 接口，并查阅官方 `hdl-util/hdmi` 仓库 master 源码与双许可证。未下载仓库、未改RTL、未运行TD或仿真。根代理给出的C35/C36锁定与数据岛符号计数作为已报告实况引用；C33同参数PC输出测试结果仍待回传。本审计保持1920×1080、15fps内容目标；输出模式结论保留给根任务与现场结果。

## 核心结论

1. C33加密 wrapper 可见 `HTOTAL/HSA/HFP/HBP/HACTIVE/VTOTAL/VSA/VFP/VBP/VACTIVE`、`VIDEO_VIC`、`AUDIO_SAMPLE_RATE` 与 AXI视频/音频/ACR信号；未见包数或包调度策略参数。`O_axis_s_ready`控制输入stream握手；每行岛包个数没有对应公开端口。C33当前 `.VIDEO_VIC(0)` 且HBlank=80，几何设定已正确进入公开端口。内部核是否按80动态改变packet count，待C33实测符号/显示结果对照验证。
2. `hdl-util/hdmi` 当前 master 的 island scheduler 直接由 `frame_width-screen_width` 算可放包数。将自定义模式扩展到C33几何后，80像素消隐可放1个完整数据包：公式得到 `floor((80-30)/32)=1`。每行的可用payload为32个packet symbols；三包需要96 symbols，比80像素blank多16 symbols，且guard/preamble开销另计。
3. 同一开源调度器的总量预算支持48kHz两声道L-PCM16：每个Audio Sample Packet携带4个左右声道样本帧，需12,000包/s；N=6144对应每48个音频样本产生一项ACR，需约1,000包/s；AVI、Audio InfoFrame、SPD InfoFrame每帧各一包，15fps下约45包/s。总需求约13,045包/s；80-Hblank单包/行、1100行/帧、15fps提供16,500包/s，平均余量3,455包/s（约21%）。这属于源代码调度预算，尚未在EG4或显示器上验证。
4. 现EG4 `lane_lvds_10_1` 每像素接受一个10-bit并行TMDS word，使用5×像素时钟及ODDR输出；`hdl-util/hdmi` 的公开 `hdmi.tmds[2:0]`已是其serializer产生的1-bit高速串行流。两者可对接的路径是从 `tmds_channel` 编码器旁路开源serializer，暴露三路10-bit并行码后接现有PHY；也可改PHY用适配后的直接串行差分输出。直接将开源serial位流送入现有10:1 lane会重复序列化。
5. C33颜色条候选最终映射统计为8个BRAM9K：隐藏HDMI core层级中，音频`u_w96_d1024_fifo`占5个，视频AXI `u_w24_d1024_fifo`占3个。所审开源核使用4组双声道样本寄存器缓冲并从像素接口逐拍取RGB，没有同规模音频/视频异步1024-word FIFO层级；若直接接native YUV像素、音频样本时钟，目标可削减上述8个BRAM9K对应结构。新核最终LUT/寄存器/BRAM数量仍需综合得到。


## C35与C33水平blank线索

根代理提供的C35网表回放显示：lock后RGB行640、frame起点550,000 serial symbols正确；一个数据岛payload占96 symbols（3包）。同一发射调度若尝试在C33每行80个blank symbols中放入3包，单看payload已差16 symbols，guard/preamble/control尚需另外预算。由此应重点检查加密core在C33参数下是否将每行计划包数从3降到1。C33 wrapper可设H total与H active，但无显式包数/blank-slot参数；开源核的公式能据几何自适应出1包。这是与当前C35/C33现象相符的候选机制，待用户PC同C33完全相同timing的显示和符号回传后定性。
## 1. 当前加密 wrapper 可见契约

本地文件：

- `development/player_video33_1080p_output/src/user_source/hdl_source/hdmi1.4b_transmitter_core/hdmi_1_4b_transmitter_core_wrapper.enc.v`
- `development/player_video33_1080p_output/src/user_source/hdl_source/top.v`
- `development/player_video33_1080p_output/src/user_source/hdl_source/hdmi_phy_warpper.v`
- `development/player_video33_1080p_output/src/user_source/hdl_source/lane_lvds_10_1.v`
- `development/player_video33_1080p_output/build/manual/AC201_video33_1080p15_gate.area`

wrapper参数为器件、总时序与同步/porch、`VIDEO_TPG`、`VIDEO_FORMAT`、`VIDEO_VIC`、音频采样率与I²C分频；端口为 pixel clock/reset、EDID、AXI-like `{user,valid,last,data,ready}`、`I_audio_valid/I_audio_left_data/I_audio_right_data`、`I_acr_valid/I_acr_cts/I_acr_n`、lock/DDC、4路10-bit TMDS data words。没有可见的 `packets_per_line`、数据岛最小宽度或包仲裁参数。设置HTOTAL与HACTIVE会让核看到80个水平blank像素，但加密内部具体支持规则仍待现有core实验结果闭环。

当前C33 `top.v`配置：HTOTAL/HACTIVE=2000/1920，HSA/HFP/HBP=8/8/64；VTOTAL/VACTIVE=1100/1080，VSA/VFP/VBP=5/4/11；VIDEO_VIC=0；48K参数。当前彩条夹具将音频和ACR的valid均固定为0，因此其锁定/映射证据没有覆盖HDMI音频辅助包。

## 2. 官方开源仓库、功能与授权

仓库：[hdl-util/hdmi](https://github.com/hdl-util/hdmi)；源码入口及关键文件：[README](https://github.com/hdl-util/hdmi/blob/master/README.md)、[`src/hdmi.sv`](https://github.com/hdl-util/hdmi/blob/master/src/hdmi.sv)、[`src/packet_picker.sv`](https://github.com/hdl-util/hdmi/blob/master/src/packet_picker.sv)、[`src/packet_assembler.sv`](https://github.com/hdl-util/hdmi/blob/master/src/packet_assembler.sv)、[`src/tmds_channel.sv`](https://github.com/hdl-util/hdmi/blob/master/src/tmds_channel.sv)、[`src/serializer.sv`](https://github.com/hdl-util/hdmi/blob/master/src/serializer.sv)。源码树的十个主要SV模块为 `hdmi.sv`、`packet_picker.sv`、`packet_assembler.sv`、`audio_clock_regeneration_packet.sv`、`audio_sample_packet.sv`、`audio_info_frame.sv`、`auxiliary_video_information_info_frame.sv`、`source_product_description_info_frame.sv`、`tmds_channel.sv`、`serializer.sv`。

官方README标明SystemVerilog HDMI 1.4b视频/音频发送；数据岛、BCH ECC、ACR、2声道L-PCM、Audio InfoFrame、AVI InfoFrame已勾为实现，采样深度支持16–24bit。官方平台列表标明Altera与Xilinx已测，Lattice未知、Gowin进行中，未列Anlogic；EG4语言/存储推断及I/O primitive接入需要本地工具验证。

README说明仓库软件双许可MIT OR Apache-2.0；MIT文本允许使用/复制/修改/分发但须保留版权与许可声明。HDMI联盟Adopter/成品合规是另一项问题，README对终端产品/合规另有提醒。此处为源代码许可证与硬件格式要求的分项核对，不构成法律意见。

## 3. 80像素水平blank的包槽精算

`hdmi.sv` 对每行数据岛包数的公开公式（README源码第249行附近）：

```text
B_H = frame_width - screen_width
P_line = min(18, floor((B_H - 2*V_GB - 8*V_preamble
                            - 4*V_control_min - 2*DI_trailing_GB
                            - 2*DI_leading_GB - 8*DI_preamble
                            - 4*DI_control_min) / 32))
```

源码各固定开销合计30 pixel clocks；每个packet占32 pixel clocks。C33计算：

```text
B_H = 2000 - 1920 = 80
P_line = floor((80 - 30) / 32) = floor(1.5625) = 1
occupied = 30 + 1*32 = 62 clocks/line
remaining = 80 - 62 = 18 clocks/line
```

每帧1100行，故上限为1100 packet slots/frame；15fps下16,500 slots/s。三包Island需3×32=96 payload clocks，超过80 blank 16 clocks，尚未计guard/preamble/control。每行1包的算法避免了以三包岛包载荷挤进80像素blank的结构。

注意此公式只核算水平空白容量；自定义sync极性/宽度需按同一模式case配置。C33负同步定义应映射为 `hsync_pulse_start=HFP=8`、`hsync_pulse_size=HSA=8`、`vsync_pulse_start=VFP=4`、`vsync_pulse_size=VSA=5`，并令 `invert=1`。Preamble、数据岛与sync转换的周期级组合需由短blank逐符号核验。


### C33 sync/岛包相位细节

`hdmi.sv` 当前把数据岛固定在`cx=screen_width+14`启动，leading guard位于+12..+13，preamble位于+4..+11。C33负同步HFP=8/HSA=8意味着HSYNC低脉冲为active end后+8..+15，因此固定数据岛起点+14与该同步区间最后2 pixel clocks相交，preamble也覆盖同步区间。源码把H/V状态并入control/preamble/岛数据输入；对极短自定义porch的最终采样关系需逐周期验证。若电气/显示回放显示岛起始需避开HSYNC，可将slot基准从固定+14改为按`HFP+HSA`及所需控制周期/preamble动态定位，再按`P_line=floor((B_H-offset-trailing_guard)/32)`重新算包数。80-pixel blank仍可容纳1包，但锁定其恰好一个slot的计数须采用同一offset。
## 4. 48k PCM16左右复制、ACR与VIC0

### 音频接口映射

开源`hdmi`接口接受 `audio_sample_word[1:0]`、`clk_audio`、`clk_pixel`，而非当前C33 wrapper的`audio_valid + left/right_data`。packet picker在每个`clk_audio`上升沿采样两个16-bit通道，跨到pixel域后累积4个双声道样本帧形成一个Audio Sample Packet。因此最短适配为：在48kHz采样时钟域对每个已消费样本将同一PCM16值复制到left与right，作为两个array lane；`clk_audio`每个采样沿消费一个样本。当前C34 player若现播放器仅提供pixel域valid脉冲，可在输入适配层将有效样本按原次序送入48kHz sample-clock域；连续25/33MHz `clk_audio`会将每个pixel都采样成一个音频帧。

Audio Sample Packet源码生成Stereo/2-channel LPCM字段；Audio InfoFrame源码默认通道数编码为2。接口供数本身不含`valid`，所以播放器停顿/断样时的重复/静音语义应由轻量音频样本源定义。

### ACR数值与自定义口

当前C34 `audio_arc_calculate.v`给 `ACR_N=6144`；其`AUDIO_DIV=N>>7=48`，每48个`I_audio_valid`周期更新CTS。33MHz pixel与48kHz音频的理想CTS为：

```text
CTS = f_pixel * N / (128 * f_audio)
    = 33,000,000 * 6,144 / (128 * 48,000)
    = 33,000
```

`hdl-util` ACR模块依据`AUDIO_RATE`计算N，48k得到6144；依据`VIDEO_RATE`参数和`clk_audio`采样/翻转测量CTS，理想值同为33000。仓库原始模块没有外部`acr_valid/cts/n`端口；若要与现有C34 `audio_arc_calculate` 完全共享自定义N/CTS节拍，最小源适配是在`packet_picker`增加这三个输入，ACR packet payload用`N/CTS`四个subpacket重复编码，并将其valid映射到现有packet选择的type1优先级。若采用仓库自算方案，则通过`AUDIO_RATE=48000`、`VIDEO_RATE=33e6`和48kHz `clk_audio`获得N=6144与实测CTS，C34端ACR计数模块可以省去。

### AVI VIC0与自定义15Hz几何

`hdmi.sv`当前case表未定义VIDEO_ID_CODE=0；`VIDEO_RATE`默认条件式对ID0回落为0。该ID应新增显式geometry case，并新增`PIXEL_CLOCK_OVERRIDE=33.0e6`或同等参数；AVI模块将`VIDEO_ID_CODE`截为7 bit写入VIC字段，值0可直接作为当前自定义/无VIC描述。配置建议：

```text
VIDEO_ID_CODE = 0                 // AVI VIC = 0
BIT_WIDTH = 11, BIT_HEIGHT = 11  // 2000 × 1100计数器可表达
frame_width=2000, frame_height=1100
screen_width=1920, screen_height=1080
hsync_start=8, hsync_size=8, invert=1
vsync_start=4, vsync_size=5, invert=1
VIDEO_RATE=33,000,000 Hz
AUDIO_RATE=48,000 Hz, AUDIO_BIT_WIDTH=16, DVI_OUTPUT=0
```

`VIDEO_RATE`而非名义VIC负责ACR pixel clock；AVI VIC0与视频计数器/像素率应彼此独立，避免ID0触发0 pixel-rate常量。

## 5. 最小发射模块树与EG4现有10:1 lane

建议模块树（仅说明最小开源模块复用与接口，不含新TX实现文件）：

```text
custom mode timing/counter (from hdmi.sv, extended VIC0)
  ├─ pixel RGB provider(native YUV cache -> RGB, driven by cx/cy)
  └─ HDMI data-island path
       ├─ packet_picker
       │    ├─ audio_clock_regeneration_packet (or external ACR inputs)
       │    ├─ audio_sample_packet
       │    ├─ audio_info_frame
       │    ├─ auxiliary_video_information_info_frame (AVI/VIC0)
       │    └─ source_product_description_info_frame
       ├─ packet_assembler (BCH/ECC)
       └─ tmds_channel ×3
            └─ expose tmds_internal[2:0][9:0] per pixel
                 └─ existing hdmi_phy_wrapper / lane_lvds_10_1 ×4
```

最小fork位点：

1. `hdmi.sv` 给VIDEO_ID_CODE=0新增2000×1100 geometry/负同步case，并将pixel-rate改成可覆盖33MHz；显式把`BIT_WIDTH/BIT_HEIGHT`设11。
2. 在`hdmi.sv`导出` tmds_internal`三路parallel 10-bit code，旁路`serializer.sv`。现有 `hdmi_phy_wrapper` 接 `I_tmds_channel_[0..2][9:0]`；第四个clock lane用每pixel固定5高/5低10-bit TMDS clock word，并按`lane_lvds_10_1`数据位序反排。保留现有33/165MHz PLL、四个EG4 ODDR lanes和管脚绑定，像素时序/岛包仍在33MHz域生成。
3. 按`cx/cy`把YUV frame cache RGB接到`hdmi.rgb`，利用同一counter推导active/de，而非在core内再缓冲一帧。输入像素与core内建1-cycle色彩/模式寄存器对齐。
4. 加48kHz PCM16 lane adapter；同一样本复制到L/R。保留自定义ACR时，将现有N/CTS/valid穿入packet_picker；采用自动ACR时，48kHz sample-clock输入驱动其CTS测量。

库自带 `serializer.sv` 从pixel-domain10-bit TMDS code使用5×时钟并以两边沿输出1-bit lane。该输出适合直接SERDES/ODDR差分pad路线；当前C33 `lane_lvds_10_1`承担10:1序列化，因此并行旁路能最大化复用已有EG4硬件。库未提供EG4专用PAD/ODDR wrapper，Parallel-TMDS输出位序、lane clock word、330Mbit/s差分电气/边沿及165MHz源同步时序仍要结合C33现有PHY实测。

## 6. 映射资源变化静态估算

C33颜色条候选的`AC201_video33_1080p15_gate.area`报告EG4S20BG256使用8/64个BRAM9K。层级细分：

- `u_hdmi_core/.../u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo`：5 BRAM9K，96bit×1024 Audio Sample FIFO。
- `u_hdmi_core/.../u_video_axi_stream_receiver/u_w24_d1024_fifo`：3 BRAM9K，24bit×1024 Video AXI FIFO。
- 其他门级逻辑：3 TMDS encoder、Island packet assemble、video source、PLL与PHY，不占BRAM。

`hdl-util/hdmi`用内置双buffer、4样本×2声道来接收音频，每个payload仅几百位状态；像素RGB直接于每个`clk_pixel`采样。旁路serializer并让framebuffer按`cx/cy`供RGB后，结构上可移除视频24×1024 FIFO与音频96×1024 FIFO这两组（最多避免当前8个BRAM9K需求）。时钟域/供数契约若迫使另设FIFO，其容量应单独估算；新核Logic LUT/FF及EG4推断结果尚未综合，8 BRAM9K仅是层级替代上界估计。

## 7. 关键风险与边界

- `hdl-util`公开支持表无Anlogic；包内语言结构虽为常规SystemVerilog，EG4 TD支持情况、宽数组/array ports、类型转换与组合case还需真实工具验证。
- C33 HFP/HSA各8，固定调度器将packet island放在active end之后固定14像素处；自定义sync pulse边界与preamble/island相位需逐符号审查。Hblank总长度算出1包并不代替极短porch边界核验。
- HDMI sink当前是否接受该15Hz/VIC0 timing，PC同C33参数测试尚未返回；HDMI显示接受度沿用根任务的最终板测结论。
- 仓库默认无外部audio_valid，采样输入依赖48kHz `clk_audio`逐样本；现有PCM播放器的sample-valid域需明确桥接契约。
- 仓库内部ACR按参数自动生成，没有现成自定义ACR总线；留用当前精确的N/CTS需要上述packet_picker小接口适配。

## 一手来源索引

- 仓库README（dual license、平台支持、音频/AVI功能与分辨率表）：https://github.com/hdl-util/hdmi/blob/master/README.md
- timing/packet formula/TMDS internal interface/serializer hookup：https://github.com/hdl-util/hdmi/blob/master/src/hdmi.sv
- ACR、样本缓存、包选择优先级与AVI VIC映射：https://github.com/hdl-util/hdmi/blob/master/src/packet_picker.sv
- ACR的N=fn(AUDIO_RATE)、CTS measured pixel counter：https://github.com/hdl-util/hdmi/blob/master/src/audio_clock_regeneration_packet.sv
- 2ch L-PCM包字段和样本slot：https://github.com/hdl-util/hdmi/blob/master/src/audio_sample_packet.sv
- Audio InfoFrame双声道字段：https://github.com/hdl-util/hdmi/blob/master/src/audio_info_frame.sv
- AVI VIC字段：https://github.com/hdl-util/hdmi/blob/master/src/auxiliary_video_information_info_frame.sv
- TERC4/TMDS 10-bit编码：https://github.com/hdl-util/hdmi/blob/master/src/tmds_channel.sv
- 当前单bit x5 DDR serializer：https://github.com/hdl-util/hdmi/blob/master/src/serializer.sv
- MIT许可文本：https://github.com/hdl-util/hdmi/blob/master/LICENSE-MIT
- Apache 2.0许可文本：https://github.com/hdl-util/hdmi/blob/master/LICENSE-APACHE


