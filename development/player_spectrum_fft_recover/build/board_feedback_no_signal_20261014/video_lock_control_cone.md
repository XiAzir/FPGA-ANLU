# C11310 O_video_locked 可见控制锥展开

日期：2026-10-14。只读核查 gate 网表 LUT INIT 的完整真值表并与 C11309 交叉检查。未修改 RTL 或位流。

## 逐拍布尔条件

C11310 gate 的锁定状态 DFF 是 O_video_locked_reg，时钟为 u_status_monitor/sys_clk（本设计的 video/pixel clock），异步复位为 HDMI 核 I_rst；Q 输出 hdmi_video_locked。D 输入由 O_video_locked_reg_syn_4 的 LUT5（INIT=32'hffb0b0b0）驱动，端口映射为：A=de_prev，B=I_video_source_sol，C=hdmi_video_locked，D=O_video_source_pause，E=axis_s_user。按 LUT INIT 逐一枚举全部 32 种输入，得到精确下一状态：

locked_next = (axis_s_user && source_pause) || (locked && (de_prev || !source_sol))

所以在可见 D 输入层面：

- 未锁定时，只有 axis_s_user=1 且 source_pause=1 才会置位。
- 已锁定时，除非 de_prev=0 && source_sol=1 && !(axis_s_user && source_pause)，否则保持置位；满足该组合时清零。
- axis_s_last / I_axis_s_last 不进入该 LUT，也没有出现在该状态 D 的直接输入列表。此公式说明的是综合网表显式组合逻辑，不等于加密核所有隐藏功能均与 TLAST 无关。

相关网表：build/manual/AC201_tf_hdmi_gate.v 第 182475–182489 行（DFF、LUT5 和各输入连接）；C11309 对应第 182797–182811 行，INIT 与输入连接同形。

## Pause 与 SOL / SOF 上游

Pause 状态 DFF O_video_source_pause_reg 的 D 来自 LUT4 O_video_source_pause_reg_syn_4（INIT=16'h2232），A=I_video_source_sof，B=hdmi_video_locked，C=O_video_source_pause，D=axis_s_user。逐项枚举 16 种输入得到：

pause_next = !locked && (source_sof || (pause && !axis_s_user))

对应网表 build/manual/AC201_tf_hdmi_gate.v 第 182498–182511 行。因此 source_pause 是内部锁定/源 SOF/user 的状态，不是外部 ready 的别名。锁定 D 输入组合依赖 axis_s_user 与这个 pause 状态，但逻辑没有把 axis_s_valid 或 axis_s_ready 直接带入 lock/pause LUT。

I_video_source_sof 由 O_video_sof_reg 输出（第 180679–180683 行），不是输入 AXIS 的 TUSER，而是 HDMI 核依自有计数器生成的内部 SOF 标记。按 SOF LUT 端口连接与 INIT/EQN 展开，第 180630–180670 行可写成下列部分位谓词的合取：

- col_a = col[7] && !col[3] && !col[0]
- col_b = !col[13] && !col[12] && !col[11] && !col[10] && col_a && !col[9] && !col[8]
- line_part = line_b3[2]_syn_6 && line[0] && line[5] && !line[9]
- col_part = col_b && col[1] && col[2] && col[4] && !col[5] && !col[6]
- source_sof = line_part && col_part（输出 DFF O_video_sof_reg）

这里按 gate 的内部信号名缩写：col=14-bit S_col_cnt，line=14-bit S_line_cnt；line_b3[2]_syn_6 是 line 计数比较锥中间节点，未将其解码成具体绝对行号。以上是位级布尔解码，不是未经验证的“第 x 像素/第 y 行”语义。注意 source_sof 在 pause 更新方程中使用，而 AXIS TUSER 是另一根独立输入 axis_s_user。

I_video_source_sol 由 O_video_sol_reg 输出（第 180684–180714 行）。对应最后一级 LUT 输入 A=SOF 比较片段、B=S_v_en、C=SOL 比较片段、D=col[1]；前级 SOL 比较片段来自 col[2], col[4], col[5], col[6]。按其 INIT/EQN 展开，组合式为：

source_sol = !col[1] && S_v_en && sof_cmp && col[5] && !col[6] && !col[4] && !col[2]

其中 sof_cmp 是前述 SOF 比较网络中间节点 O_video_sof_n2_syn_4，不应与寄存后的 source_sof 混为一谈；S_v_en 是 S_line_cnt 的垂直使能/范围比较结果，gate 第 182213–182217 行由 line 计数高位进位比较锥生成。C11310 顶层实例配置总时序 H=800（96 sync、16 front、48 back、active 640）与 V=525（2 sync、10 front、33 back、active 480），见 top_tf_hdmi_audio.v 第 475–490 行；这些参数说明预期视频几何，但由于 protected core 内部计数初值、CE 极性、保护逻辑和综合网表优化，不能只凭计数器名字将上述位谓词换算为确定的一行/像素位置。

计数器接线（静态核查）：S_col_cnt[13:0] 全部为 AL_MAP_SEQ CEMUX="INV"、CE 接 O_video_source_pause（约第180790行）；TD common 模型表明 pause=0 时允许更新、pause=1 时保持。S_line_cnt[13:0] 全部为 CEMUX="CE"、CE 接 S_line_cnt_b1_n（第181059行）；其公开 LUT 仅由 guard-band 中间项、列比较中间项与 col[4] 构成（第180981–180985行），不能据名称当作800像素行尾。S_v_en 来自受保护 EG_PHY_MSLICE RIPPLE 比较（第182205–182217行），算术阈值静态未解。动态结果另见下节：真实上游连续640像素/行输入下，原加密 wrapper 的 lock 可达。

## 与共享 TLAST 缺陷的关系

C11310 AXIS converter 的逐行 TLAST 缺陷已由两帧 640×480 contract 仿真复现（日志 axis_before.log：614400 VALID、2 SOF、0 TLAST、960 EOL 错误）。但该缺陷不会通过可见 lock/pause 的 D 输入组合直接清除 hdmi_video_locked：TLAST 不在两个 LUT 的输入集合，clear 条件由 de_prev、内部 source_sol、锁定状态、pause 与 user 决定。

缺失 TLAST 仍可能令加密视频接收器 FIFO、内部 pause 或后续处理异常；本次本地可见综合网表没有把该跨层间接效应排除。于是，已知 TLAST bug 是需要修正和测试的共享协议缺陷，却不是已证实的 C11310 新无信号根因。C11309 具有相同 converter SHA，且有用户总体反馈“一切正常，除了频谱图没东西显示。有声音。”，说明此 bug 与至少一次非频谱音画总体正常反馈并存；由于该反馈没有独立 build ID、逐帧握手或锁定遥测，它只能降低“TLAST 单独充分解释 C11310 新故障”的可信度，不能作为电气或核内部等价证明。

## 可提取模拟与限制

本地可以按以上两个逐拍方程构建纯布尔控制模型，并注入 axis_s_user、source_sof、source_sol、de_prev 与 pause/locked 状态，验证初始化、置位、保持、清零转移；也可以用 640×480 几何计数器生成 source SOF/SOL 的候选输入。然而这只是从 gate 可见控制锥抽出的逻辑模型，不是 HDMI 加密核的功能模型：尚未得到所有计数器 LUT 的可靠符号化阈值，也没有 FIFO/ready/视频数据路径、核复位/DDC、TMDS 接收端模型。因此不能拿它单独模拟/复现 C11310 的 HDMI locked 或“无信号”板测根因。

下一步：板端根因仍未确定。若继续动态追踪，保持行内 valid 连续、不得在行内施加 ready 背压；同步记录 user/valid/ready/last、reset、locked 与 TMDS 输出，并核对保护模型告警影响。已有0 TLAST而locked=1的wrapper仿真，不支持把TLAST单独认定为实板无信号根因。

## 2026-10-14 动态集成仿真补充（更新静态阶段结论）

本节结果优先于前文“本轮未判定 lock 可达性”的暂定状态。使用 ModelSim SE-64 10.1c，在独立目录 `build/board_feedback_no_signal_20261014/video_modelsim` 编译并运行原始加密 HDMI wrapper 与生产上游视频 RTL；生产源、冻结检查点、位流和发布包未改。

### 激励与证据

- 仿真像素时钟 25 MHz（周期 40 ns），复用 `video_timing_data`、由 `video_define.v` 选择的 `VIDEO_640_480` `color_bar`、`video_delay`、`video_rgb_to_axis_640x480` 和原始 `hdmi_1_4b_transmitter_core_wrapper.enc.v`。wrapper 参数与 top 一致：H=800（96/16/48/640）、V=525（2/10/33/480）、VIC=1、VIDEO_TPG=Disable、RGB、48K；音频 valid/PCM/ACR 输入固定为 0。
- 复位高电平保持 20 个像素时钟后释放，属于快速启动激励，不代表实物完整上电/PLL复位时序。运行至 4 次 VS 上升沿观测点，覆盖约 3 个完整 640×480 帧；波形计数、逐拍断言/节奏汇总及完整控制台输出分别见 `tb_video_core.v`、`compile_core_retry2.log`、`core_console_retry2.log`。

### 结果与解释

- RESULT：921,600 个 `valid && ready` 接收拍，等于 3×640×480；3 个 SOF；0 个 TLAST；ready stall=0；最长连续 valid=640 拍/行；最终 `O_video_locked=1`。仿真未在有效行内制造 ready 背压，保持每行像素连续。
- 因此，**在本机 10.1c 原加密 wrapper 仿真与这组真实视频上游 RTL 中，规范 800×525 连续有效行下 `O_video_locked` 可达，并在 converter 持续输出 0 个 TLAST 的情况下锁定**。这说明已知 TLAST 缺失在该仿真条件下并非阻止 lock 的充分条件，也不支持把 TLAST 单独认定为 C11310 实板无信号根因。
- 结果来自原加密 wrapper 的仿真视图，不是整板 routed 网表或实物结论。优化/运行日志仍报告 protected 区域与 `eg_logic_ramfifo.v` 端口宽度警告；应将其作为模型限制。它证明这条输入序列下锁定位能拉高，不证明 HDMI 电气输出、显示器接收或整机其余通路正常。

后续若要对比 lock 起始拍或深挖行/帧相位，可在同一隔离 testbench 加入源状态波形；当前结论只需保留上述可复现的可达性结果。
