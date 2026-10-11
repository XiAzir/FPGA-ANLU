# runtime video-source isolation probe 只读复核

日期：2026-10-09（北京时间）  
结论范围：RTL 结构/接线与已有独立模型复核；不代表 TD 物理实现、位流或实板结果。

## 源码边界

以 `player_dynamic_text_fit/src/user_source` 为基线，对完整 source tree 做 SHA256 逐文件比对：基线 75 个文件，probe 工程 76 个；73 个相同、2 个改动、1 个新增、0 个缺失。改动仅为：

- `hdl_source/top_tf_hdmi_audio.v`：新增 runtime probe 接线和双键屏蔽；未改 SDRAM、framebuffer、PLL、音频数据通路或 HDMI TX 实例配置。
- `hdl_source/player_dynamic_text.v`：加入 `probe_mode`，仅将右上状态字由 `RUN` 显示为 `REF`，其余计时、滚动字幕和像素区域行为保留。
- 新增 `hdl_source/player_video_source_probe.v`：在原 OSD 输入之前切换 framebuffer RGB 与索引色参考源。

当前新源 SHA256 记录在 `build/model_results.json`：probe module `8B8DF6AF3C328079B2CFDF6F3CC68F3D5E4B9D5E925F77CFF1AFF53607AF348E`；top `EA115FA31BD796BF1E8F480B8D7CB392BDBC6FC057CE26AF1516C60310C0C35E`；dynamic text `8CD40DCC12F7A1B88C3A2F7FC0CAD62C7DBF198FE9C9D735C5B75BC40E4FED3B`。

probe source selector使用 `osd_image_index`（与显示帧索引配套）和 `vout_data_raw`，位置在 `player_osd` 前。BMP模式仍遵守 `osd_frame_valid ? vout_data_raw : black` 的首帧黑屏规则；参考模式颜色对应索引0白 `FFFFFF`、1灰 `808080`、2红 `FF0000`、3绿 `00FF00`。选择器不复位或暂停 SD/FAT32、SDRAM、帧读取、WAV/PCM/HDMI audio、PLL；其输出继续经过原 OSD、动态文字、HDMI 路径。参考调色板不受 BMP valid 限制。

## 按键定义和边界

物理 KEY0 对应此工程 top 端口 `key1`，低有效，原功能是手动切图；长按 KEY1/tone 对应 top 端口 `key2`，低有效，原 `debug_tone_press` 来自 video_clk 域的 `key_press_debounce`，阈值 1500ms。probe module用两级 `key0_meta/key0_sync` 同步 KEY0；它不对 KEY0另加长去抖。mode请求按 `debug_tone_press` 当拍旧的同步 KEY0值分类：`probe_request = tone_press && !key0_sync`；`tone_toggle = tone_press && key0_sync`。所以 KEY1单独长按仍只发一次 tone toggle，按下已同步为低的双键长按切图像参考模式且不切 tone。

既有 BMP 50ms debounce 输入只在两键原始电平都低时屏蔽：`bmp_key_next = key1 | !key2`、`bmp_key_auto = key2 | !key1`。若先单按 KEY0，并在 KEY1进入屏蔽前已经过50ms debounce，可能已有一次手动切图；这符合 root 定义的诊断边界，不作为错误。现场手势说明应固定为：先按住 KEY0，再按住 KEY1约2秒直到 `RUN→REF`，然后一起松开；释放至少1.5秒后再重复。

每个请求以一位 pending parity保留到 VS rising，commit条件使用 `pending_toggle ^ probe_request`，VS边沿同时出现新请求时也纳入本帧 commit。RTL和模型覆盖 pending+新请求与VS上升同拍相消，held VS不重复切换，pending清除以及释放后重新长按。

同步边界是明确行为：若 raw KEY0与 tone_press同拍改变，module使用旧 `key0_sync`；同步值尚高则归类为单键 tone，同步值已低则归类为参考模式请求。TB覆盖 raw按下与事件同拍及同步低后的raw释放与事件同拍，并断言这种采样行为。这不是抖动鲁棒的 chord gesture；它依赖上述先按KEY0的现场步骤。

## 模型证据

`build/probe_model` 三个 Icarus 测试日志均有 PASS：

- `source_probe_run.log`：使用生产 `key_press_debounce` RTL及缩放阈值；覆盖 KEY0短按、KEY1短/长按、tone单次、双键BMP屏蔽、同步边界分类、VS边界、pending同拍奇偶、释放/rearm、reset、首帧黑屏与BMP透传、四个24-bit颜色。
- `pixels_probe_run.log`：RUN与REF两个配置并行，与独立像素 oracle 对比 1,843,200 个有效像素；检查计时快照、滚动相位、OSD/动态字形、未覆盖像素透传、blanking及VS边界。
- `timer_probe_run.log`：既有计时器回归通过 00:59→01:00、99:20、99:59→00:00、复位重启及12,000周期回绕。

每个 testbench与run-log的SHA256在 `build/model_results.json`。这些是单模块/像素功能模型，不含完整 top、实际 TF、加密 SDRAM PHY、加密 HDMI TX、完整时序/布线或板卡；不能代替真实候选位流验证。

## 工程登记与实现状态

TD首次打开含新模块工程时自动规范化 `.al`：与源拷贝的差异只有项目根路径改成新工程目录，以及登记新 Verilog 文件 `player_video_source_probe.v`（CompileOrder=55）；没有观察到 pin、SDC、device等其他配置语义变化。登记已由 TD 输出反映。首次 synthesis 已通过；首次 physical source guard因 `.al` hash变化而停止，未开始物理实现。此停止是保护检查对新增模块项目登记差异的响应，不是 RTL 或物理布局结果。后续仍需按 root 的 guard流程重新绑定工程并重新综合，再确认完整 source diff/hash后运行 P&R；本审计不绕过保护。

## 实板判断边界

此 probe的目标是隔离路径，不是修复候选。若纯色参考模式无条纹，只能说明新诊断位流在此模式/布局下其 OSD 后输出链表现干净，增加“原底图获取或底图数据处理路径”假设的权重；它不能证明旧 `dynamic_text_fit` 位流已修复，也不能唯一确定错误在 SDRAM、RGB888 unpack、FIFO、renderer或其他底图上游级。若参考模式仍有相同条纹，则应继续检查 OSD/后级组合、HDMI TX/接收端与板级 I/O 时序。新增 mux会改变路由和负载，故任何新位流现场结果都需带上位流 SHA、模式、图像索引、屏幕/接线和条纹坐标，并与原失败位流和成功基线分别对照。

目前未看到 probe 位流的最终 P&R/STA、bitstream SHA或实板反馈；这些结果到齐后需追加复核。此前 STA 审计关于“顶层无 SDRAM DQ input delay”的措辞应按 `build/probe_model/report.md` 更正：DQ封装在 EG_PHY hard-IP 内，未列为普通top端口不等于缺少SDRAM PHY约束；实际 sampling phase需依据IP配置/器件模型和板级证据评估。

## 第二次综合 / 最终 route + fix_hold 只读复核（2026-10-09 14:34）

本次 source guard输入复核：`build/manual/build_source_scope.json` 共80项，对照当前 `src` 逐文件重算SHA256，80项全部匹配，0 mismatch。第二次综合、physical完成；第一次自动规范化工程的 `.al` 保存在 `build/initial_project_normalization/`，后续 source guard与当前hash一致。

最终路由/hold fix报告 `build/manual/AC201_tf_hdmi_pr.timing`、`AC201_tf_hdmi_chk.timing` 与 `AC201_tf_hdmi_exception.timing` 的结果：

- routed STA coverage 99.97%；slow/fast setup和hold均为 yes。全局 SWNS=+0.505ns、STNS=0，HWNS=+0.024ns、HTNS=0。`hold_console.log` 以 `POST_ROUTE_HOLD_FIX_COMPLETE` 结束；`fix_hold`摘要称10/10端点通过pin delay修复，刷新指标与最终PR报告一致。
- 没有发现新增的时序例外免责。SDC哈希保持源基线 `977ABCDB8B6C4DF93CBD8FE407D5DFA5AB2710CE45214D7713F583F91A732146`；只有50MHz主时钟、PLL时钟重命名及既有像素/serializer时钟关系注释。Exception报告仍只有CDC gray-pointer的 `set_max_delay ... -datapath_only 19.700`，36条检查全被dominated，0 shadowed、0 ignored；无 false-path/clock-group切断记录。Check report显示0异常约束、0未命中约束、0跨时钟宽泛放松；另列3个dangling节点，无combinational loop。
- 未覆盖I/O延迟提示仍为4个输入（`key1`,`key2`,`rst_n`,`sd_miso`）、14个输出（含 `HDMI_CLK_P`, `HDMI_D0_P`–`HDMI_D2_P`）。SDRAM DQ没有作为普通top-level port列在清单中，不能把这条报告措辞解释成已验证器件/板级SDRAM DQ时序。
- routed DQ路径复查与前阶段和成功基线相同：32条 `ext_mem_clk_sft -> ext_mem_clk` 路径；`sdram.dq[0]` 从相位8ns边沿出发，到 `sdram_syn_1.bpad` 相位0ns下个周期边沿捕获，预算12ns，路由模型hard-IP输入5.000ns + PAD(reg)1.453ns，setup slack1.706ns。它只证明当前TD硬IP模型的名义时序结果。

综合日志继续报告加密 `sdr_wrrd.enc.v` 内 `Sdr_rd_dout_reg[*].clk` undriven并将undriven使用0的警告；physical日志继续报告 `u_frame_buffer/u_sdram/sdram` 初始location不合法、两个stage移动实例的 `PHY-7002 CRITICAL-WARNING`。这些警告在成功基线相关构建中也曾出现，当前未证明它们导致条纹。最终route STA清洁不等于真实SDRAM采样眼图、电气裕量或现场条纹已经验证。

本次复核期间尚未看到bitgen输出、最终候选位流SHA256或实板运行结果；留待root完成打包后补记。即便后续reference模式现场无条纹，结论仍限于路径隔离，不能写作旧失败位流已修复。

## 位流生成核验（2026-10-09 14:35）

Bitgen日志以 `BITSTREAM_GENERATED` 结束；生成文件 `build/manual/AC201_player_dynamic_text_video_probe.bit`，大小629624字节，SHA256 `1EFEB04BD50035789E4EBD1430B3CB8736B0F48D93DAF24FD4013AB8130F30DF`。该哈希由生成后的文件现场复算。当前没有板上下载或现场反馈；位流是否能实现无条纹隔离现象仍为**未验证**。该文件是诊断候选，用于区分图像源与后级显示路径，不是修复版结论。
