# C11322 音频共同路径静态核查

时间：2026-10-22（北京时间）

## 当前证据

- `verification/canonical_crc_period_1875.csv` 第455行是 `455,903680,70B6`。因此板测块号 `0x1C7`（455）、末块 `70B6` 与长期PCM参考一致。与已记录的首块 `79DC4000`、最近 `870B6000`、A页缺样数0合看，当前图片测试的PCM样本从文件路径到 `player_pcm_crc_probe` 观察点仍然匹配；该探针位于HDMI核输入总线，不覆盖核后的音频岛/串行物理输出/显示器DAC。
- 用户确认输出声路是HDMI到显示器内置扬声器。内置 do/re/mi 音阶也有相同杂音；它与WAV经 `player_audio_probe` 输入mux后共用 `audio_arc_calculate`、HDMI 1.4b wrapper、PHY、线缆、显示器接收器和扬声器。这个对照把WAV文件、SD扇区内容及仅由文件播放器导致的样本错误降为低优先级。内置音阶由 `hdmi_audio_tone_pcm_scale.v` 产生符号位方波，音色会比正弦更尖锐；这可以解释音色粗糙，无法解释用户报告的两种源出现相同异常。
- 用户确认同一HDMI线和同一显示器下，电脑播放清晰，只有开发板有杂音。这个A/B将排查优先级收敛到开发板输出链路；两种FPGA音源共用的封装、TMDS发射与InfoFrame/Channel Status成为重点。
- 当前工程和官方 lab5 的 `audio_arc_calculate.v` SHA256 完全相同：`552D8D86AFD237666B30AE08F31247808E89EB024EFDE5EFC670B82EB617A7DC`；加密 HDMI wrapper SHA256 完全相同：`867E0B0BDD874BC383D00918C9E1BE3FE01EDF41F343B6A0D73E262776596A63`。wrapper 外部端口明确包括 `I_audio_valid`、左右各24位PCM，以及 `I_acr_valid/cts/n`。因此静态核查未发现本分支相较官方参考在这两个模块上的改动。
- C11322 参数为 `AUDIO_SAMPLE_RATE="48K"`、640×480 VIC 1、设计像素时钟25 MHz；`video_pll.v` 配置输入50 MHz、C0输出25 MHz。板载参考时钟频率当前没有实测记录，25 MHz属于配置值。

## ACR 运算核对

`audio_arc_calculate.v` 令 `AUDIO_DIV=ACR_N>>7=48`。分频计数器只在 `I_audio_valid` 时前进；每48个有效样本拉高一个周期 `O_acr_valid` 并输出 `N=6144`。另一个计数器每个像素时钟加一，在该更新边界清零，输出旧计数加一作为 CTS。按配置的25 MHz、48 kHz计算：`25,000,000 × 48 / 48,000 = 25,000` 个像素周期；因此稳态期应为 `N=6144, CTS≈25000`，对 HDMI 音频采样率的码率关系一致。计数器在输入样本有效期间计数节拍，短时valid间隔抖动会反映到CTS；若采样时钟与像素时钟偏离，CTS跟踪观测到的实际比值。

该模块的输出寄存器未连接复位分支，复位解除到首个ACR有效事件之间可能出现未知/初值状态；稳态A/B应从首个有效ACR更新后取样。持续杂音归因仍待实测。

## 既有输出端验证及覆盖边界

在 `development/system_verification_20261016/hdmi/period_C11310_positive_20261016_181940` 的历史仿真中，真实加密内核、EG PHY 模型和串行接收器组成 pin-level 数字路径。序列模式将左右不同的24位PCM值送入HDMI核，并逐内容/顺序对比从模型化串行输出恢复的音频岛载荷：`received=1611, mismatches=0`；统计为 `bch_bad=0, terc_bad=0, tone_bad=0, acr_n=6144, acr_cts=25000`。同目录负控把一处PCM位翻转，记录的负例检出单处错误。采样收尾时最后1个输入在模拟传输尾部，测试明确要求这一余量。

这项测试支持“给定输入PCM时，冻结内核加PHY模型生成正确数字包与被恢复串行字”的仿真范围。测试夹具未接入TF/本次完整C11322媒体路径；电缆、显示器接收器、显示器DAC/扬声器模拟波形和板上TMDS电气波形尚无实测。历史版本/模型结果建立了数字仿真证据，当前实板噪声位置仍待对照定位。监视器校验包格式、重复字段、BCH/TERC和序列载荷，本次实板音频接收端波形尚未采集。

## 当前判断

核查证据支持ACR稳态数值、PCM样本和当前HDMI串行数字包正确。按B0_j对齐后的192帧Channel Status显示原core已正确表达48 kHz/24-bit；先前从启动窗口未对齐的C位序列推导出Fs=44.1 kHz属于错误结论，metadata矛盾候选已消融拒绝。真实板级TMDS波形、电缆、显示器接收器/DAC/扬声器尚未测量；杂音根因继续留在共同HDMI物理链路或接收端排查，不据此修改生产RTL。

## ACR Icarus 定向仿真（2026-10-22）

使用项目共享脚本 `scripts/anlu_tools.ps1` 的 `Resolve-AnluTool` 获取Icarus，对生产 `audio_arc_calculate.v` 和本目录 `tb_acr_calculate.v` 单独编译/仿真，未实例化或修改生产top。默认受限执行时，Icarus在Codex sandbox临时路径创建 `ivrlg` 文件失败；按用户授权以提升权限只运行 `run_acr_tests.ps1` 后通过。编译和仿真日志分别为 `compile.log`、`simulation.log`。

仿真用整数分数累加器产生25MHz像素时钟下48kHz有效脉冲，跑1,500,100周期（约60ms）：2,880个PCM有效样本、60次ACR更新；逐次断言N=6144、每48个有效样本更新一次、ACR更新相隔25,000或25,001个像素周期、稳态CTS为25000/25001。结果：`ACR_TEST_PASS`，CTS观测最小25000、最大25001。源码会在无效周期清零N/CTS输出，日志结尾的零值属于该空闲状态；N约束逐次应用于每个有效更新周期。

## 时钟、约束和PHY与C11310 pin模型对照

C11322与C11310归档快照中，`timing.sdc`、`pin.adc`、`video_pll.v`、`hdmi_phy_warpper.v`、`lane_lvds_10_1.v`、`audio_arc_calculate.v`及加密HDMI wrapper的SHA256逐项相同。C11322/C11310关键哈希：SDC `977ABCDB…732146`、pin `234048B3…3BF759`、video PLL `57E45A06…D9BB13`、PHY `416B082B…3F4300`、lane `AB24F9EE…112BC0E`、wrapper `867E0B0B…596A63`。历史pin仿真夹具的音频/视频时序参数也与当前top相同：800×525、640×480、VIC1、RGB、48K、`IIC_SCL_DIV=250`。

C11322的PLL源码注明C0=25MHz像素时钟、C1=125MHz串行时钟；C11322最终布线时序报告的Clock Summary相应为约束频率25/125MHz。ModelSim pin夹具以40ns像素周期和8ns串行周期运行，因此数字仿真与工程约束的时钟设定一致。此项是源码/STA配置核对，AC601输入晶振的实物频率仍未测量。当前SDC引用两个PLL输出时钟并保留固定相位关系；HDMI输出pin没有单独的`set_output_delay`约束，外部lane skew/眼图/接收器门限也没有STA或本仿真覆盖。`pin.adc`中的TMDS输出仍为AC201既有映射，LVDS33_E、drive strength 8。

VIC1与25MHz参数在当前工程和历史数字pin夹具中一致，夹具可以验证该参数组合的数字包内容；VIC本身携带模式标识，频率实际由像素时钟决定。输出时序与接口接收裕量仍需要物理链路测量。没有发现C11322对C11310的clock/PHY RTL回归。

## C11322音阶串行pin metadata定向仿真

在`metadata_pin_sim`隔离目录，用C11322当前`hdmi_audio_tone_pcm_scale.v`、当前/历史字节相同的ACR/PHY/lane/加密core，以及C11310真实加密核+EG PHY模型的串行接收decoder运行双帧仿真。像素/串行时钟为25/125MHz；内置音阶使用48kHz、24-bit双声道相同样本，第一音保持24000个样本。增加的被动观察器读取恢复后的10-bit TMDS字并导出前192个有效音频子帧旁带到`audio_subframe_sideband.csv`。编译/仿真日志为`vlog_tone.log`、`tone_run.log`；回归终止标记`STRICT_PERIOD_CONTENT_PASS`，307200个第二帧像素对比正确，1,611个音频样本包、33个ACR包，BCH/TERC错误0，TMDS格式错误0。该观察器仅关闭音阶内容的相位匹配断言，串行pin包计数和BCH/TERC检查保持开启。

串行恢复得到3个合法Audio InfoFrame和3个AVI InfoFrame。baseline Audio InfoFrame头为`84 01 0A`，payload开头为`PB0=70, PB1=01, PB2=00`，checksum正确；`SF=SS=0`表示采样率和样本尺寸沿用音频流。AVI InfoFrame为`82 02 0D`，VIC=1，与top配置一致。

首次启动窗口记录的前192个样本对子帧中，HB2的B0_j标记出现在packet index 191；当时把sample index 0误当成B起始后的样本，进而把全零的C位错解为Fs=`0000`。该CSV实际记录的是块边界前的191帧与边界样本，无法代表B0_j之后的新完整Channel Status块；对应材料保留在`metadata_pin_sim/audio_subframe_sideband.csv`和`audio_sample_packet_headers.csv`，作为已纠正的早期观察。

为核实真实字段，在独立副本`metadata_patched_pin_sim`中增加加密core输出的只读并行监视器，并将core输出经8-word patch快照和EG PHY恢复成串行字；原baseline成功目录与生产RTL未改动。串行头部确认192个连续Audio Sample Packet均为`HB1.SP=1`，B0_j仅在packet index 191置位。按B0_j样本本身作为frame 0捕获后192帧，baseline core Channel Status bytes为左`04 80 10 02 0B`、右`04 80 20 02 0B`；patched串行输出逐位与core baseline完全相同。两个声道的C byte 3 Fs低四位为`0010`（48 kHz），C byte 4为`0B`（24-bit）；C byte 0的`04`表示consumer且not-copyright位为1，C byte 1的`80`表示original标志及general category 0，C byte 2为左右声道号1/2且source号未指定。字段编码参照[ALSA上游IEC958定义](https://raw.githubusercontent.com/torvalds/linux/master/include/sound/asoundef.h)。因此原core已有正确的48 kHz/24-bit状态，Audio InfoFrame选择follow-stream与Channel Status一致；先前的Fs矛盾候选应撤销。

全量串行验证日志为`metadata_patched_pin_sim/tone_run.log`，逐样本状态和packet证据为`baseline_core_channel_status_block.csv`、`patched_channel_status_block.csv`及`audio_sample_packet_headers.csv`。192帧两声道的V/U/C/P完整奇偶关系均正确（0错误）；此前报告的8个parity错误来自checker只核对PCM与P、遗漏V/U/C，已修正计算式。8-word四路流水检查840,018次、0错误；视频两帧中307,200个像素逐点相同，0丢帧/协议错；串行解码1611个SP1音频包并与tone输入逐样本比对，1611次全匹配，仿真结束时1个输入尾样本尚未发出；ACR共33包，N=6144、CTS=25000；音频BCH/TERC错误均为0。测试副本将Audio InfoFrame显式设为SF=48k、SS=24，恢复的`PB0=61, PB1=01, PB2=0F`及checksum正确；Channel Status未被改变。baseline使用PB=`70 01 00`且同样通过完整视频、PCM、ACR、BCH/TERC检查，所以metadata修补候选没有证据支持作为本次杂音的必要修复，停止生产集成。

16-bit PCM序列旁路也曾在同一pin decoder下通过逐样本比较；样本24位容器最低8位为0，C22的左对齐打包格式得到确认。扩展的1611样本逐样本串行比较未见中途dup/drop。板端电气TMDS、接收器解码结果、显示器DAC/扬声器仍未观测；后续优先做同线同屏的输入/接收端对照和板端信号质量诊断，不继续改metadata。

## 实板建议验证次序（尚未执行）

1. 先做不改工程的显示端对照：保留C11322、显示器音量/输入不变，换一条已知良好的短HDMI线，重复内置音阶试听；图片/WAV CRC和underflow页同时确认参考状态。线缆更换后噪声若明显变化，重复一次换回原线验证可逆性。
2. 线缆对照无变化时，保持FPGA与线缆不变，将输出接第二台具备HDMI音频的显示器/接收器；再用已知良好电脑/HDMI源接原显示器与原线。记录每种配对的噪声结果。若FPGA在不同接收端均噪、电脑在原显示器清晰，问题落在FPGA发射路径的优先级上升；若电脑也在原显示器噪、FPGA在第二接收端清晰，优先查原显示器解码/音频输出。若只有原线配原显示器组合异常，继续替换线材确认组合因素。
3. 若显示器有耳机/音频输出，试听该输出并与内置扬声器比较：外接输出清晰而内置扬声器嘈杂，指向显示器扬声器/功放段；两路都噪则问题更靠近HDMI接收/解码或FPGA发射端。使用同一内置音阶作为确定性输入，避免音乐内容差异。
4. 以上对照后仍落在发射端时，再考虑诊断候选只扩观察：累计ACR有效次数、更新间隔像素时钟周期、末次N/CTS；在HDMI核输出字侧同步记录音频岛计数、格式/BCH/TERC错误。参考配置为25MHz/48kHz，N=6144、CTS约25000、每48个PCM valid更新一次。若接收侧工具可采集解码PCM，再与测试序列逐样本对齐；只有首个不匹配边界明确后才进行对应RTL单变量修改。

## 本地文件与执行记录

- ACR定向夹具 `tb_acr_calculate.v` 已由 `run_acr_tests.ps1` 调用共享工具入口完成Icarus compile/sim；汇总标记`ACR_TEST_PASS`。受限临时文件失败记录在首次`compile.log`被成功重跑覆盖前的运行结果中（工具错误已在工作日志记录）；最终成功日志保留在`compile.log`和`simulation.log`。
- 未改动 C19～C22、官方参考、生产 RTL、约束、位流或测试源。
