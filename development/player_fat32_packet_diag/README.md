# HDMI 包观测诊断工程

日期：2026-10-08。基线为已观察到两源杂音、输入计数符合预期的
`../player_fat32_status_diag`。本工程用于定位问题，尚未证明修复音频。当前候选已完成
模型、原约束STA和bitgen；本候选首次上板已获用户反馈图像、KEY0、KEY1轮播及长按前后两音源均正常：`build/manual/AC201_player_fat32_packet_diag.bit`。
数码管两源短视频现已核对模式3/B、48000输入/样本/包计数、F=E、所见错误0及CTS/N正确；长期运行未验证，旧噪声根因未证实。先前用户反馈在 `build/board_feedback_20261008.json`，新增视频证据在 `build/board_videos_20261008/observations.json`；原candidate检查点保持冻结。

只在 HDMI 核心到 PHY 的原三路10位并行输出旁接被动监测；原音视频、
按键、PLL、PHY、引脚及SDC保持基线。新增扇出会改变物理实现，不能据此
声称捕获了旧失败位流的波形。既有加密IP告警、外部IO延迟和实测频率边界保留。

## 实物操作

当前候选已完成TD综合、布局布线、原约束setup/hold及bitgen。
PROGRAM_SRAM临时下载，保持原卡、供电、HDMI和音量。
KEY0点按切图；KEY1短按开关自动轮播；长按约2秒切WAV/内部音阶，
长按也会触发一次轮播开关，松开至少1.5秒后可再次切源。
内部模式D3闪烁；灯本身不能证明声音正确。

数码管前2秒01234567、后2秒88888888，随后9页按1、3、6、7、8、9、A、B、C循环，
每页2秒。数字均为十六进制。拍摄时等启动稳定，覆盖完整18秒页周期；
切内部音阶后等至少3秒，再记录后续窗口，避免旧WAV FIFO样本影响初窗。

| 页 | 第二位含义 | 后六位数值及判读 |
| --- | --- | --- |
| 1 | 启动状态K | FF/文件错误EE/mapper错误WW，正常1dA80000 |
| 3 | 输入模式M | 每名义秒送入核心的audio_valid，48kHz为00BB80 |
| 6 | 包观察F | 好BCH、合法layout0音频包里的立体声采样时刻数；稳定48kHz约00BB80，允许包边界带来小量窗口差异 |
| 7 | 包观察F | 好BCH、合法layout0音频包数；若每包4样本约002EE0，实际按present数分组，不能仅凭不是12000判错 |
| 8 | 包观察F | 每秒坏BCH包数；任一header或4个body校验错按该包一次，坏包不计入页6/7 |
| 9 | 包观察F | 每秒非法TERC/guard符号事件数；非法符号中断本岛并重新搜索 |
| A | 包观察F | 内部tone模式下present且非flat的样本对，任一L/R不是±1000000的次数；WAV模式不比较 |
| B | 包观察F | 最近合法ACR CTS，25MHz/48kHz对应0061A8=25000；CTS=0保留上一有效值 |
| C | 包观察F | 最近合法ACR N，001800=6144 |

M={tone_mode,underflow,hdmi_locked,frame_seen}；默认无欠载模式3，内部模式B。
F={island_seen,audio_seen,acr_seen,format_error_seen}，前三项锁存；通常E表示三种事件
均见过且没有格式错误，F表示格式错误曾发生，不能推断错误仍持续。
页8/9/A是非锁存的一秒窗计数，要读稳定后的多个窗口。
页6..A上限00FFFF（65535）饱和，不回绕。计数窗按名义25MHz，物理频率未测。

ACR按BCH、四个重复payload和保留位检查；HB1/HB2按接收端忽略规则处理。
音频仅支持当前双声道layout0的五种present前缀。absent子包flat/B字段不作
有效样本，flat样本不检查tone幅值。未检查完整PCM顺序、IEC parity/V/U/C、
Audio InfoFrame、General Control/AVMUTE或接收器输出波形，计数通过也不排除这些问题。
观察点使用核心原并行位序，首次实板还需确认符号对齐；若F全0不能直接认定核心
没有发送，需同时考虑观察器位序/对齐假设。监测不观察差分PHY引脚或显示器内部。

## 实现与验证

`hdmi_packet_monitor.v`在线解析数据岛：8拍preamble、2拍guard、32拍同步收
header和4个body。包间无guard；同岛可以连续多个packet。5个在线BCH校验器
使用左移0xC1；独立Python右移0x83核对外部向量及32组三路字符。
为节约器件资源，保留24位header及一份56位payload供CTS/N解析，不保存ECC副本。
四个ACR payload在前28拍逐位比较是否相等；tone在前24拍逐2位匹配左右声道的
独立±AMP候选，包含左右声道首/末位。每完整包数据覆盖移位寄存器后才使用，
无需宽payload/header清零mux；计数16位饱和。
输入mailbox仅保留28位模式/有效样本数；上一版视频已证实的像素/PCM变化计数
不在本观测版重复测量，故没有2/4/5页。包计数已由同一像素时钟寄存，直接送显示
组合逻辑，595在每轮扫描起点锁存完整32位，避免额外328位快照副本。
所有相关路径仍受STA约束。最终595源码恢复基线原样，外部链模型重跑通过。

模型：`sim/run_monitor_tests.ps1`独立BCH及47项定向断言；
`scripts/run_status_sim.ps1`9页精确字段；`scripts/run_hex_sim.ps1`外部595链25MHz。
模型不含加密HDMI核心、SDRAM或板测。首次TD工程属性错误已修正，日志保留；
首轮完整快照布局容量5060 MSlice超过4900，归档`build/attempt_capacity_full`，未生成位流。
去除重复快照后第二轮4918仍超4900，归档`build/attempt_capacity_compact`；
缩减595计数宽度后第三轮4962仍超4900（打包结果不随位宽单调下降），归档
`build/attempt_capacity_595`，没有位流。最终恢复595原样，去除重复的输入像素/变化
计数，将显示集中在新包观察信息；最终是否可布局/通过时序以构建报告为准。

构建：`scripts/build_candidate.ps1 -Stage synthesis|physical|hold|bitstream`。
后续阶段复核成功综合时源哈希，bitstream阶段拒绝负setup/hold/TNS。
不使用额外false path或放宽约束。成功后`scripts/save_packet_build.ps1`保存源码范围、
位流SHA256、真实STA/资源及检查点manifest；禁止覆盖已有检查点。
`src/td_project`复制自基线，其中旧输出仅为历史；本次构建显式只用`build/manual`新DB。

### 2026-10-08 路由及工具限制（阶段记录）

9页版实际打包4872/4900 MSlice、route后18600 LE。默认route的SRAM三态
控制到DQ[12..15]出现setup SWNS=-0.263ns/STNS=-0.708ns，原约束fix_hold后
HWNS=0.031ns/HTNS=0，setup仍未通过；尚未生成位流。
prehold、setup失败DB分别保存在`build/attempt_packet_prehold`和
`build/attempt_packet_setup_input`。这不能解释旧版杂音原因。
低effort的post-route reroute模式也在TD内部检查时崩溃，日志与minidump保存在
`build/attempt_packet_reroute`，原DB保留；不再重复phys_opt各模式。
从place DB按本机官方手册route effort=routability完成常规route/fix_hold，
独立输出`build/attempt_packet_routability`：SWNS=-0.329/STNS=-0.922ns，
HWNS=0.031/HTNS=0，setup仍未通过，没有位流。
目标sdr_t高扇出复制从gate DB因physical model未建立失败；改用placed DB后命令
完成但实际0个复制，之后常规route仍SWNS=-0.263/STNS=-0.708ns。
独立get_nets/report_nets已确认规范名及34个PAD TS负载；使用get_nets集合形式
再次验证仍0个复制，排除本次仅因字面量/集合传参差异造成0复制的解释，
未证实优化器不选择该driver的具体原因。所有尝试独立保留，未从违例DB生成位流。
当前诊断工程模型已完成、最终STA及实板观测未完成；下一步须解决原约束下的
SRAM输出setup，再观察真实核心输出包。不能从这些构建失败推断旧音频杂音原因。

协议依据：[HDMI Licensing原始规范5.2/5.3/7.6](https://fpga.mit.edu/6205/_static/F24/default_files/CEC_HDMI_Specification.pdf)、
[AMD官方AUX packets说明](https://docs.amd.com/r/3.1-English/pg236-v-hdmi-rx-ss/AUX-Packets)，
以及本地APUG092手册/原PHY位序。详细规格在基线工程
`build/tone_video_20261008/packet_probe_spec.md`。这不是原加密核心行为已实证的声明。

### 2026-10-08 继续：在线载荷校验

进一步压缩监测器，保留上述九页及校验含义；原播放/IP/PLL/SDC/595/显示模块不改。
47项断言通过，新增覆盖首尾样本bit、不同子包左右声道符号、连续包状态清除、
六种ACR子包首尾bit差异与合法包恢复。综合16227 LUT/7883 reg，较上一轮
少530 LUT/153 reg；旧未完成检查点保留。本轮最终结果见下节。

### 2026-10-08 当前候选：成功移动后的原约束STA

默认在线校验版route为SWNS=-0.411/STNS=-1.630ns；种子2、3在原约束fix_hold后
分别SWNS=-0.265/STNS=-2.022和SWNS=-0.462/STNS=-2.440ns，均未生成位流。
TD安装的MultiSeed.tcl提供place seed流程；帮助move_cells和report_cells提供
局部位置调整及占用查询。首轮字符串包装/regexp/collection传参失败或0移动；
普通规范fullname字符串能匹配已pack的控制单元，但中部所选网格无可用slot。
只读扫描425个grid后，最终用官方move_cells从未路由place DB将
`u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_rd_addr_1d_reg[16]_syn_3`
由grid(2,24)移至(17,36)。该MSLICE包含sdr_t和addr16，移动后实际报告1个单元
成功，前后坐标核对一致；未改逻辑功能/IP/PLL/ADC/SDC，仍重新检查全部STA。

移动后常规route和原约束fix_hold完成：SWNS=0.102ns、STNS=0、HWNS=0.027ns、
HTNS=0，coverage99.97%；16789LUT/8028reg/18206LE/19BRAM9K/0DSP/2GCLK。
setup最差路径已转到50MHz文件/音频逻辑；SDRAM输出组SWNS=0.448ns。
这证明本次观测工程的构建时序通过，不证明旧位流杂音原因。

选用DB原件、prehold、final报告和日志保存在`build/attempt_streaming_move_x17y36`；
`scripts/select_moved_result.ps1`复核源hash及无负时序后选入manual。
`build/manual/selected_physical.info.json`记录来源与route DB SHA256，原失败default
manual副本保存在`build/attempt_streaming_default`，旧未完成检查点不覆盖。
随后从选用DB生成候选位流；`.info.json`及candidate检查点保存最终SHA256和manifest。
首次上板图像、按键/轮播、长按前后两音源均获用户正常反馈；九页实际包结果尚未采集。无代理板操作、
卡或Flash写入。所有报告保留既有加密IP/宏位置警告、IO delay缺项与未实测频率边界。

## 2026-10-08 20:32:27｜packet_diag首次上板基础功能通过（用户反馈）

- 用户反馈：图像正确，KEY0手动切图、KEY1自动轮播正常；长按KEY1前后两种音源音阶均正常。按设计对应默认TEST.WAV与内部音阶，音源模式寄存器未拍摄；没有数码管记录、客观音频/波形或持续时长。
- 版本：packet_diag，629624字节，SHA256 `C2B3DEAFB78355C124CE8958015EED31CEBA38CD4B0B41D9179A7190E4200818`。本机原件与英文短路径 `E:/VSCODE-project/FPGA-ANLU/download/packet_diag.bit` 哈希一致；运行版本按前序下载上下文关联，用户未提供本次BitWriter日志。独立反馈文件：`E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/build/board_feedback_20261008.json`。
- 状态：本候选可作为已获用户基础功能通过的回退位流；新增包观察器的实板读数尚未采集，不能声称BCH/TERC/CTS/N及tone幅值实板检查通过，也不能把旧沙沙声归因为本次MSLICE移动或某一项RTL改动。
- 留存：原310文件candidate及211文件incomplete检查点保持冻结；只更新live元数据/说明/当前状态并添加反馈。源码、约束、DB与位流未修改，无重新构建、代理板操作、TF或Flash写入。
- 下一步：建议保持当前位流补录正常基线，默认模式录25秒数码管并带声；长按KEY1切内部源，松开等至少3秒再录25秒。此项用于核对观察器及保留正常包数据，不妨碍将本次基础播放判为通过。后续再验证实际音乐、换文件/碎片与长时运行；旧故障根因仍未证实。

## 2026-10-08 20:49:32｜packet_diag两源视频判读与归档｜已完成（观察窗范围）

- 用户提供长按前627fe2...、长按后4d68c8...视频；26.733333/25.833622秒，原字节分别SHA256 4A9755F1612F60A89672A815EFD502E8F63564969717914579B8994321047A3F / 380AEB0B16C21FEBF59D52C6C058E42DF470E46E79585CA7974D1AA23A96B10B。原视频及双模式逐页截图已核验归档，完整表和来源见[两源视频判读](<E:/QQ CACHE/Download/安路资料/开发记录/专题记录/FAT32文件播放/packet_diag两音源视频判读_20261008.md>)。
- 判读：1DA80000；页3默认3300BB80/内部3B00BB80，6E00BB80/7E00BB80，8E000000/9E000000/AE000000，BE0061A8/CE001800。稳定计数窗输入/包内样本对/包数48000，F=E，所见错误0，内部幅值异常0，CTS25000/N6144。WAV A页不检查幅值；相等的样本/包数符合每包1组，不能用4组/包的12000预期判错。b与6段码已视觉复核。
- 两段短视频/已显示窗符合预期，先前声音干净/按键图片正常为用户反馈；没有完整PCM顺序、PHY/接收器波形、校准音质或实测时钟频率/长时证据。新观察器改变实现，旧杂音机制仍未证实。
- 已更新live.info.json、工程README、当前状态和专题入口；原用户反馈文件/310候选及211未完成检查点不改，源码/约束/DB/位流不改，无重新构建及代理板卡/TF/Flash操作。
- 下一步：无需再补录基线；保留成功位流，后续实际音乐TEST.WAV、换文件/碎片与长时验证。
