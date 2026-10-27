# C30 源级消融核查与小型对照

状态：PASS（有限源级等价与 source-probe 单元仿真）。核查对象为 C29 `player_video29_media_flow/src/user_source/hdl_source` 与独立 C30 `player_video30_probe_prune/src/user_source/hdl_source`。本目录包含逐文件 SHA 清单、归一化消融核查脚本、Icarus 测试台与编译/运行日志；没有修改候选工程源、C29 源或 D1 综合输入。

## 源级差异

逐文件 SHA256 清单记录 C29 115 个文件、C30 106 个文件：新增 `player_audio_output.v`；删除 10 个观测/调试文件；变更 6 个文件（top、`sd_card_cmd.v`/`sd_card_top.v` 和内存 3 文件）。逐项清单与双方完整哈希见 [source_hash_manifest.json](source_hash_manifest.json)。

`source_ablation_audit.py` 通过，`source_ablation_summary.json` 记录具体结果：

- top 中媒体选择、bmp 写请求/使能/数据、显示有效和状态选择赋值逐 token 相同；`u_bmp_file_player`、`u_wav_player`、`u_video_schedule`、`u_video_reader`、`u_video_keys`、`u_osd_state`、`u_adjust_control` 实例在剥离诊断输出 port 后相同。视频模式控制 always 块去掉只读按键计数后相同。
- `player_adjust_control.v`、BMP/WAV loader、视频 reader/scheduler、OSD/control、调色、WAV bridge 等关键模块哈希相同。
- C29 `player_audio_probe` 去掉 LED 观测后，其 WAV bridge、tone、mux、ACR 实例/接线与 C30 `player_audio_output` 匹配；tone_mode 仅由同一复位初值及同一 `tone_toggle` 事件更新。`wav_pcm_bridge.v`、`hdmi_audio_tone_pcm_scale.v`、`audio_arc_calculate.v` 三文件 SHA 均一致。
- `sd_card_cmd.v` 去除独立 CRC 函数、寄存器、端口和 always 后，剩余 command/R1/读写状态机 token 完全相同；`sd_card_top.v` 去除对应 CRC port/call 后相同。
- `frame_fifo_read.v`、`frame_read_write.v`、`frame_buffer_rgb888.v` 各自仅剥离观测用 `debug_read_state/valid/word` 端口、assign 与子模块连线，即与 C30 token 相同。
- C30 LED 为低有效 `~{video_mode, tone_mode, display_valid, fs_ready}`，对应 D3 视频模式、D2 音阶、D1 显示图像有效、D0 文件系统 ready。

## Source-probe 对照仿真

C29 top 将 `player_video_source_probe.key0_n_async` 固定接 `1'b1`。测试台在复位后变更 `vs`、`bmp_valid`、image index、RGB 和 `tone_press`，C29 模块输出与 C30 顶层的 `probe_mode=0`、`tone_toggle=tone_press`、`bmp_valid ? bmp_rgb : 0` 逐周期比较。Icarus 共核查 260 个非复位周期，输出完全一致。将候选 valid gate 故意反向的负控在 259 周期出现 RGB 失配，checker 按预期捕获变更。

编译与运行日志分别见 [iverilog_compile.log](iverilog_compile.log) 与 [vvp_run.log](vvp_run.log)；工具由 `scripts/anlu_tools.ps1` 的 `Resolve-AnluTool` 解析。复跑：`pwsh -NoProfile -File development/video30_work/verification/unit_ablation/run_video_source_ablation.ps1`。

未运行整个 audio parent 对照仿真；其旧/新功能区使用精确端口/实例/表达式 token 对照，WAV bridge、tone、ACR 子模块逐 SHA 相同，满足本轮 bounded ablation 核查范围。未运行 TD、整机仿真或硬件操作。

## 本次严谨性补强

source checker 现在断言文件集合精确等于已审阅清单：1 个新增、10 个删除、6 个变更；清单外任意文件增删改均使脚本失败。全部 16 个保留媒体/控制核心源文件逐文件 SHA 必须相同。

音频状态机比较会解析真实 always 语法块与嵌套 `begin/end`、`if/else`。C29 与 C30 均须具有 pixel clock 与异步 reset 的正沿敏感列表；复位分支必须在 `rst` 下将 `tone_mode` 置零；非复位分支必须只在 `tone_toggle` 下翻转 `tone_mode`。解析器比较分支条件、分支方向、作用域和赋值 RHS，不使用固定描述字符串替代源码检查。

Checker 负控在内存中把候选 `sd_card_write_en` 的 `video_mode_sd` 选择条件反相，再调用生产使用的 assignment-token 比较函数；checker 返回差异并确认该突变被检出。生产候选文件保持原样。PASS/负控输出保存在 [source_audit_run.log](source_audit_run.log)，Icarus compile/run 日志也已重跑并保留。
