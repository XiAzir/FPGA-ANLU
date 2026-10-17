# C11302 综合映射审计

日期：2026-10-13（北京时间）
范围：只读检查当前综合gate网表、area报告、source_scope及当前RTL；未修改RTL/旧报告，未运行模型或仿真。

## 绑定与综合快照

- 当前 `player_pcm_waveform.v` SHA256：`8BBD61AD22ADCA31581A8C99E5B57641BCD2C09F22DEEA4FF3A162919E398B30`。
- `build/manual/build_source_scope.json` 共89项：TD工程描述1项加88个源文件；其中波形RTL项SHA与当前文件完全匹配。综合stage记录为成功，run ID `d03bf04c-beb1-4373-9a11-ca2572818b83`。
- gate网表 `AC201_tf_hdmi_gate.v` 时间戳为2026-10-13 18:27:52；area报告 `AC201_tf_hdmi_gate.area` 时间戳为18:27:50。此报告只陈述综合映射。根代理告知物理实现仍在运行；本审计不宣称布局布线或STA通过。
- 当前area总计：16046 LUT、8843寄存器、29 BRAM9K、8 DSP。`u_pcm_waveform`占1150 LUT、390 ripple、225 seq、2 BRAM、0 DSP；合计BRAM低于规格上限32。

## 曲线cache和历史array映射

- gate.v在 `u_pcm_waveform`下有两颗 `EG_PHY_BRAM`，注释的memory分片为1024×9与1024×1。它们使用相同的flatten地址，写地址由`capture_bank + segment_index + pixel_in_segment`构成，读地址由`display_bank + predicted_bin`构成。因此两张512×10逻辑trace bank共用一张1024×10双口缓存，实际占2颗BRAM9K，而不是每个bank各2颗。
- 两颗DP8K端口都接`u_status_monitor/sys_clk`；写口连接`interp_height`与`trace_mem_n`，读口连接`predicted_bin`及`trace_read_data[9:0]`。门级配置是`REGMODE_A/B=NOREG`，trace输出直接由BRAM `dob`接出；这是带系统时钟的BRAM读路径，没有额外外置trace输出寄存器。高度最大832，所需10位；更高trace位未映射为存储数据。
- 历史128×16 array没有映射成额外BRAM。gate.v显示`EG_PHY_MSLICE`配置`MODE("DPRAM")`与`EG_PHY_LSLICE`配置`MODE("RAMW")`，形成分布式LUT RAM；history写时钟是`sys_clk`。其读组合输出进入16个`AL_MAP_SEQ`的`hist_read_data_reg[0..15]`，时钟同为`sys_clk`，所以RTL的一周期同步读语义由LUT RAM输出后的外置寄存器实现。area中waveform的2颗BRAM正好对应trace cache，没有history BRAM。
- 这是相对文字规格“历史128×16同步BRAM”的实现偏差，但映射仍保留时钟寄存的同步读。当前综合总BRAM29/32；若后续物理时序满足约束，可把此点记录为RAM类型实现差异，无需仅为BRAM类型再开迭代。

## 音频PCM存储保持

- `u_wav_player` area仍为5 BRAM。其中gate.v有4颗`EG_PHY_BRAM`映射`ramread1_syn_4_2048x16`，构成2048×16 PCM FIFO；每颗承担4位数据切片，读写地址共用wr/rd指针。另有1颗`ramread0_syn_4_512x8`扇区缓存。
- PCM四颗2048×16 BRAM保持在当前gate；未发现该改动裁掉或替换原音频缓存。

## 移位加减插值等价与位宽

当前RTL将Catmull-Rom权重改写为常数移位加减，系数逐项等价：

- `9c=(c<<3)+c`，`3c=(c<<1)+c`。
- `111c=(c<<7)-(c<<4)-c`，即128−16−1；`29c=(c<<5)-(c<<1)-c`，即32−2−1；`72c=(c<<6)+(c<<3)`。
- 四列numerator仍分别为`128p1`、`-9p0+111p1+29p2-3p3`、`-8p0+72p1+72p2-8p3`、`-3p0+29p1+111p2-9p3`，与规格权重一致。
- 输入高度在0..832；22-bit signed中间量可容纳最大的加权绝对和（至多160×832=133120），远小于22-bit signed范围±2097152。`interp_num >>> 7`保留有符号除128向下取整，后续端点clamp不变。综合显示`u_pcm_waveform`为0 DSP，整机DSP仍为8，符合目标预算。

## C11301源范围核对

与C11301 candidate frozen目录按source_scope所列路径对比：88个源文件中3个不同，分别为`player_pcm_waveform.v`以及仅更新BUILD_ID的`player_status_monitor.v`、`top_tf_hdmi_audio.v`；其余85个源文件字节一致。TD `.al`工程文件只改工程绝对路径。`build_source_scope.json`按89项记录，额外包含该工程描述文件。

## 验证边界

以上门级内容来自2026-10-13 18:27综合生成的gate与area证据。路由/物理阶段按根代理状态仍在进行；本报告不判断route最终状态、setup/hold/TNS、实际板卡时序或HDMI实物表现。
