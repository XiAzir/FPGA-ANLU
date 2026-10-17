# C11302 RTL复审（修复后）

日期：2026-10-13（北京时间）
范围：只读复核当前 `development/player_music_envelope/src/user_source/hdl_source/player_pcm_waveform.v` 与最新 `build/envelope_spec.md`，并与 C11301 candidate frozen `src` 做字节核对。本审查未修改RTL、工程、脚本或硬件；旧的 `final_review.md` 保留此前FAIL证据。

## 已确认修复

- 源切换使用`source_pending/source_waiting/source_boundary`。检测到`tone_mode`变化后，builder与trace写被立即停止，未发布back和标题保持；到VS边界才清`front_valid`、采纳当前`tone_mode`、重置历史与解除HOLD。pending跨越多次tone变化保持为1，边界取当拍最终tone值。该顺序修复了此前源切换时即时清front/改frame标题造成的帧中途跳变。
- `history_push`与trace back写都受`source_waiting`门控。pending期间不推历史、不写back；source boundary清历史；后续VS从新源累计值开始构建。环形写指针/计数、VS snapshot和read-during-build顺序保持一致。
- `audio_valid`平均、包络攻击/释放、stale计时/衰减逻辑不受`freeze_requested`或`frozen_front`门控；HOLD停可视历史/渲染时，音频观察仍运行。解除HOLD的VS把当前包络写入新历史并启动重建。
- 图形取消了错误的反向填充。现在使用`distance=abs((408-y)*16-heightQ4)`的单曲线，正高度落在y408上方；线外用背景色，y408使用零线颜色。
- 主线ROM显式提供alpha 0..16，按背景B=`[7,11,18]`加`floor(alpha*[65,209,192]/16)`，alpha16核心为`[72,220,210]`。辉光也显式提供alpha 0..16，按B加`floor(alpha*[4,13,12]/16)`。两表每通道单调不减；主线alpha1与辉光alpha16相接为`#0B181E`，alpha0/1辉光回到背景`#070B12`，没有低于背景的黑边。此前alpha15缺项已修正。

## 同步RAM与帧所有权

- `hist_mem`和`trace_mem`均在`posedge clk`注册读数据并带`ram_style="block"`属性；startup padding在端点钳位后仍按`logical < 128-snap_count`屏蔽。满环后`base_after=hist_write_ptr+1`对应刚覆盖最老节点后的逻辑起点。
- VS时snapshot捕获新count/base；同沿history写入后，builder首拍读在下个时钟，能看到已写节点。启动count为0时逻辑端点全部被mask；部分历史右对齐，最新节点在127。
- Builder以`segment*4+k`写512个输出列，完成后才置ready；后续VS才交换front/back。ready时build FSM为空闲；提交沿没有trace写。运行中的builder遇VS会先写旧back至多一个像素，再被重启覆盖，不会交换不完整表。source_waiting阻止前后台写冲突。
- 显示读按next_x预取：x64对应trace列0，x575对应511，边界钳位正确。RTL编码支持同步BRAM推断；最终映射仍应以TD综合报告为准。

## 保留检查点与需核实事项

- 先前source_boundary冻结按键风险已修复：`freeze_requested<=0`现在是音频控制always块中`source_boundary`判断的最后赋值，因此当VS边界与`freeze_toggle`同拍时，pending源切换优先清除新HOLD请求。即使pending期间先置位请求，消费source boundary时也会清零。最新gold边界回归覆盖该路径并PASS。
- 旧失败模型绑定`build/model/envelope_binding_20261013_182028.json`使用RTL SHA256 `14EFB2D995A47DA94140899E855ADFEE7CA1E39956C515929C7CD3991917B265`，结果FAIL（`control_errors=1`）；它对应边界清除优先级修复前的RTL，不代表当前源码。
- 当前RTL SHA256为`77AEF394B29277CCF0BB42143D82905904ECBE9CA963BE813306350BD1009389`。绑定`build/model/envelope_binding_20261013_182224.json`对该SHA执行缩参回归并PASS：`env_errors=0`、`pixel_errors=0`、`control_errors=0`。该模型使用`frame_cycles=3000`，binding标注`nominal_128_frame_coverage=false`，不能代替生产参数全128帧回归。
- Catmull权重仍用`*22'sdN`常数乘法表达（RTL约129–140行），算术为22-bit signed，Q4高度范围0..832下足以容纳最大加权和并算术右移7位。它们可能被综合成shift-add，但资源不能从源代码证明；TD结果需确认DSP总数≤8及BRAM9K≤32。
- 本复审未运行TD综合或板测；模型PASS不代表正式时序、HDMI链路或实板成功。

## C11301父快照字节核对

以 `development/player_waveform_fine/checkpoints/waveform_fine_20261013_candidate/src` 对比当前工程 `src`：共有88个源文件，即85个`user_source`文件和3个`td_project/al_ip`文件。只有3个user_source HDL不同：`player_pcm_waveform.v`，以及只改BUILD_ID为C11302的`player_status_monitor.v`、`top_tf_hdmi_audio.v`。剩余82个user_source文件与3个al_ip文件字节一致，覆盖PLL、PHY、SDC、音频、scaler、控制逻辑。TD `.al`文件仅改项目绝对路径；另有TD生成的`td_project/gate.qor`，不属于源文件比较。
