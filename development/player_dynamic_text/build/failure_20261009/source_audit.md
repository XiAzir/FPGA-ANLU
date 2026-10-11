# 动态字幕上板失败：源码与工程选择审计

审计日期：2026-10-09。范围是 `player_dynamic_text` 与通过实板反馈的 `player_osd_phy_fix` 源码、Tang Dynasty 工程源清单及已有构建产物。未修改 RTL、checkpoint、工程配置或 bitstream；未运行构建、下载或板卡操作。实板结果来自用户/根代理反馈，本文静态检查不替代物理测量。

## 结论

- 工程配置和综合日志表明，这次动态字幕构建选中的顶层是 `top`，并且确实分析、展开了新模块 `player_dynamic_text`。新模块在既有 `player_osd` 后面串接 RGB，`video_clk/rst_all/vs/de` 与 RGB 接口连接正确；项目清单里模块只新增一次，没有发现新模块漏编、接口错接或重复实例的源码证据。
- 与已验证的 `osd_phy_fix` 基线相比，功能源差异可归结为顶层增加一次组合 RGB 叠加和一个新字幕模块。`source_delta.json` 记录 73 个源相同、一个顶层文件变化、一个新文件；基线唯一修改过的 LVDS 源在两个候选中相同。按源码，动态字幕不驱动图像按键、图像状态、音频 PCM、音频有效、ACR 或 HDMI 音频输入。
- `IMG0/4` 有明确的软件状态含义：在帧计数为 4 时，`player_osd` 默认将当前项设为 0；只有 `image_valid` 为 1 且索引有效时，索引 0 才显示成 `IMG1/4`。因此现场 `IMG0/4` 指向当前帧元数据 `frame_valid=0`，或索引/计数越界，不足以推出卡未挂载。顶层在 `frame_valid=0` 时也会把底图强制置黑。新字幕框不覆盖旧状态条区域。
- 图像有效位只在 BMP 帧写入完成后提交：BMP payload/头检查、像素写入、SDRAM 后端完成、跨域 toggle 同步，最后 `COMMIT` 设置 `display_valid`。`player_osd_state` 再把有效位和图像标签一起跨到像素域，并只在下一次帧读请求边界锁存。若提交链未完成或帧边界快照仍是旧值，就会看到 `IMG0/4` 和黑底；现有代码不足以判定卡读、FIFO、控制器、外部 SDRAM 时序或硬宏哪一环在现场停住。
- 按根代理转述，用户在同条件回退 `osd_phy_fix` 后恢复。动态版和已通过版 bitstream 哈希不同且长度相同。这是强的整版实现 A/B 证据，但由于顶层逻辑和布局布线也整体重算，不能单凭源码把故障归因于字幕逻辑，更不能据此排除物理时序、IO、SDRAM 接口或设备加载差异。

## 工程选择与源差异

`player_dynamic_text/src/td_project/AC201_tf_hdmi.al` 将顶层标签和模块都设为 `top`，顶层文件 `top_tf_hdmi_audio.v` 的编译序号是 7，新模块文件 `player_dynamic_text.v` 序号 54，且两者均标记用于综合和布局布线（该文件约第 55 行、第 402–407 行及第 481–484 行）。已有 `build/manual/synthesis_console.log` 明确记录顶层源被分析（第 96 行）、新模块源被分析（第 152 行），随后展开了 `top`（第 156 行）和 `player_dynamic_text`（第 212 行）。故候选构建不是只把源码放在目录里却没有被综合。

当前工程配置中 `player_dynamic_text.v` 只出现一条源条目，主 HDL 目录也只有一份该模块声明。综合日志明确展开它；没有重复模块或缺少该模块的证据。`build/manual/build_source_scope.json` 中顶层和新模块的 SHA-256 分别为 `FF31F5AD...E4A54`、`B6DE0110...72884`，与当前源文件哈希相符。生成/交付的 `build/manual/AC201_player_dynamic_text.bit` 与 `download/dynamic_text.bit` 均为 SHA-256 `D0559A20...BF28F`、629624 字节；已验证 `download/osd_phy_fix.bit` 为 `9E893B0B...AE6F`、629624 字节。哈希只能识别磁盘文件，不能证明板上实际配置内容。

`build/source_delta.json` 记载动态版相对基线有 75 个源、73 个未变、改动 `top_tf_hdmi_audio.v`、新增 `player_dynamic_text.v`；`player_osd_phy_fix/build/source_delta.json` 则记载 74 个源、73 个未变，唯一改动是 `lane_lvds_10_1.v`。所以作为父基线的 LVDS 修复在动态版中仍然存在，差异集中在图像叠加。

动态版顶层只在第 341–350 行把 `u_osd` 输出从原来的最终 RGB 改接到中间网 `vout_data_osd`，再将其送入 `u_dynamic_text` 输出 `vout_data`。下游视频转换器仍在第 392–401 行使用 `vout_data`。与旧顶层文件的文本 diff 只有这处 RGB 串接。两模块端口声明及连接相符：新模块接口见 [player_dynamic_text.v](../src/user_source/hdl_source/player_dynamic_text.v:1)，实例见 [top_tf_hdmi_audio.v](../src/user_source/hdl_source/top_tf_hdmi_audio.v:341)。输出是组合 RGB 选择，不增加 `RGB/VS/DE` 寄存器流水。

## 时钟、复位、按键与状态链

`video_pll.v` 的注释和参数表明输入 50 MHz、C0 为 25 MHz、C1 为 125 MHz（第 16–22、61–65 行）；顶层将 C0 接到 `video_clk`（[top_tf_hdmi_audio.v](../src/user_source/hdl_source/top_tf_hdmi_audio.v:173)）。动态实例用 `video_clk` 和 `rst_all`，计时参数为 25 MHz（顶层第 348–350 行；模块第 1–2、30–48 行）。`rst_all` 是顶层生成的高有效复位，等待输入复位释放和两个 PLL lock 稳定后撤销（顶层第 137–161 行）。新模块与旧 OSD 共用同一视频时钟、复位、VS、DE；它没有自己的复位输出或控制输出。

顶层图像输入只有 `key1`（注释为手动下一张）和 `key2`（自动播放开关），BMP 播放器将它们分别接至 `key_next/key_auto`（顶层第 2–5、200–213 行）。BMP 播放器各用 50 ms 去抖（[tf_bmp_file_player.v](../src/user_source/hdl_source/tf_bmp_file_player.v:49)）。内部音阶切换另在顶层以 1500 ms 去抖监听 `key2`（第 353–360 行），因此板上口头称呼“长按 KEY1”与源码 net 名的对应关系应以实际引脚/按键标记核实；动态字幕实例不连接任何按键。

BMP 显示有效位的生成链如下：

1. 首次加载要求目录已就绪且 BMP 数量非零；有效帧已存在后，手动切图需要 `next_pending`，自动轮播也需要对应状态（[tf_bmp_file_player.v](../src/user_source/hdl_source/tf_bmp_file_player.v:82)–92）。
2. 头部检查通过后才请求写缓冲；等 `write_req_ack` 后读取 payload，每三个 RGB 字节发出一个 `write_en`。payload 的全部像素和扇区都达到条件后进入 `COMMIT`（同文件第 129–164 行）。文件映射错误或 watchdog 到期会转 `HALT` 并置错误（第 169–170 行）。
3. 写请求到 `frame_buffer_rgb888` 的异步 FIFO/帧写后端；`write_finish` 来自 `frame_fifo_write` 的完成态 S_END（[frame_buffer_rgb888.v](../src/user_source/hdl_source/frame_buffer_rgb888.v:57)–100；[frame_fifo_write.v](../src/user_source/hdl_source/SD/frame_fifo_write.v:87)–88）。顶层在 `ext_mem_clk` 域把该脉冲翻转为 toggle（[top_tf_hdmi_audio.v](../src/user_source/hdl_source/top_tf_hdmi_audio.v:181)–187），BMP 播放器在 SD 时钟域三级同步并检测 toggle 后，在 COMMIT 设置 `display_valid`（[tf_bmp_file_player.v](../src/user_source/hdl_source/tf_bmp_file_player.v:33)–38、68、76、162–165）。
4. `display_valid` 作为 `source_valid` 进入像素域状态邮箱；`player_osd_state` 把 valid、buffer、image、count、auto 一起发布，跨域收到后保存到 `latest_pixel`，再在 `read_req` 上升沿锁存到 `frame_pixel`（[player_osd_state.v](../src/user_source/hdl_source/player_osd_state.v:30)–35、48–63）。顶层仅当 `osd_frame_valid` 为 1 时使用底图，否则将 RGB 设为黑色（[top_tf_hdmi_audio.v](../src/user_source/hdl_source/top_tf_hdmi_audio.v:274)–286）。

`player_osd` 独立于当前项有效性显示总数：总数 4 时显示分母 4；当前项先默认为 0，仅在 `image_valid` 为 1 时按索引 0–3 映射成 1–4（[player_osd.v](../src/user_source/hdl_source/player_osd.v:78)–102）。所以 `IMG0/4` 可以由“目录计数已传到、但帧提交有效位尚未传到/锁存”形成；也可能是非法索引/计数。现有照片文字能支持这些逻辑分支，不能单独定位发生在哪一级。

状态条在 `player_osd` 的 x≈16–256、y≈16–48 区域；动态字幕时间框是 x=448–623、y=16–47，滚动框 y=432–463（[player_dynamic_text.v](../src/user_source/hdl_source/player_dynamic_text.v:306)–316）。两个动态框均不覆盖状态条，因此 `IMG0/4` 不是被新黑底盖住造成的视觉假象。

## SDRAM/硬宏边界

活动工程 `.al` 将 `SD/sdram.v` 列为综合源（编译序号 28）；构建日志第 114 行分析它，并在第 199–206 行展开 `sdram` 和器件库 `EG_PHY_SDRAM_2M_32`。帧缓存在 [frame_buffer_rgb888.v](../src/user_source/hdl_source/frame_buffer_rgb888.v:102)–109 实例化 `sdram`，而 [SD/sdram.v](../src/user_source/hdl_source/SD/sdram.v:56)–86 将请求交给 SDRAM 控制器，92–106 行连接 EG4 外部 SDRAM 硬宏。该接口属于图像提交链，不能从这次日志排除硬宏周边控制器、FIFO 或物理时序的影响。

硬宏 wrapper、帧缓存、SDRAM 控制器、像素封包器在两个候选的源差异清单中都未变化，动态字幕也不接触这些信号。因新候选重新综合、放置和布线，周边时序/布线仍可能改变；静态源码相同不代表 SDRAM 接口具有相同物理裕量。现有材料没有现场 `write_req_ack`、`write_finish`、COMMIT、SDRAM init/busy、FIFO underflow 或数据总线波形，故不能称为已证实的硬宏故障或已排除。

## 音频与实现层差异

两候选的 `player_audio_probe.v`、`hdmi_audio_tone_pcm_scale.v`、`audio_arc_calculate.v`、HDMI transmitter wrapper、PLL、SDC 源都被 source delta 记为未变。新模块没有音频端口。音阶仍由像素时钟域的 48 kHz 采样使能和相位累加器产生（[hdmi_audio_tone_pcm_scale.v](../src/user_source/hdl_source/hdmi_audio_tone_pcm_scale.v:3)–6、42–83），`player_audio_probe` 仍以 `tone_mode` 在 WAV 和 tone PCM 之间选择（[player_audio_probe.v](../src/user_source/hdl_source/player_audio_probe.v:41)–43）。顶层给 HDMI 核的音频输入仍为原 `audio_valid/left/right` 和 ACR（[top_tf_hdmi_audio.v](../src/user_source/hdl_source/top_tf_hdmi_audio.v:424)–442）。这排除了源码上将音频端口误接到字幕 RGB 的情况，不能排除重新实现之后的物理影响。

已有实现产物量化显示候选整体确实改变：`AC201_tf_hdmi_gate.area` 中总 LUT 由基线 8757 增至动态版 8991；器件 LUT 利用量由 16451/19600（83.93%）增至 16743/19600（85.42%）；寄存器由 7962 增至 8005。info JSON 的静态时序摘要由基线 SWNS/HWNS 0.629/0.030 ns 变为动态版 0.513/0.024 ns，仍为正值。它证明资源、路由和报告裕量不同，不证明此差异造成音频失真或 SDRAM 写入停滞，也不证明实板电气接口安全。

## 最小后续诊断

- 根代理已收到“同条件回退恢复”的用户反馈。保留 bitstream SHA、同一张卡、供电/连接和按键操作顺序即可形成候选级 A/B 记录。板上当前 FPGA 配置无法由磁盘 SHA 代替，应记录实际下载的文件及其 SHA。
- 若只需判断图像停在哪段，下一版诊断优先锁存并显示 `fs_ready/fs_bmp_count`、`state_code`、`bmp_error/bmp_map_error`、`write_req_ack`、`frame_write_finish/write_done`、`display_valid`、`osd_frame_valid`。无需更改 SDRAM 数据格式。若 `display_valid` 一直为 0，再针对完成 toggle 和硬宏 init/busy/写完成查看波形或可观测状态；当前源码不足以选定其中一环。
- 音频探针 LED 已区分真实 WAV 的 FIFO 非零、采样被取走、样本变化、ACR，以及 tone 模式下的 valid、非零、ACR（[player_audio_probe.v](../src/user_source/hdl_source/player_audio_probe.v:49)–84）。记录这些灯态能分出生成/打包侧是否有活动；它不能证明接收设备实际解码，也不能测量 TMDS 电气质量。现场所称长按键需先对应到 `key2` 这条源码信号。

## 证据边界

同条件回退恢复将故障与动态候选的整版 bitstream 联系起来；源差异证明功能变化仅是显示叠加，但综合资源和全局物理实现同步变化。仍未证实的假设包括：动态版对时钟/复位网络或关键路径的物理扰动、SDRAM 硬宏周边时序裕量改变、TMDS 发送/接收链对新布局或切换活动的敏感性、按键实际引脚映射、以及板上配置文件与磁盘候选是否逐位一致。要把根因归到其中一项，需要至少一个对应的现场可观测信号或受控 A/B 波形；本审计不把未改变的源码解释为硬件安全证明。
