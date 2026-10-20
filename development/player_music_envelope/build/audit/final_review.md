# C11302 RTL最终审查

日期：2026-10-13（北京时间）
范围：只读检查 `development/player_music_envelope` 当前源码、包络规格及 C11301 candidate 快照；没有修改 RTL、工程、脚本或硬件。

## 结论

包络采样、同步历史读取、环形缓冲和双bank完整提交的结构与规格基本吻合。还存在一个影响帧原子性的源切换问题，以及一个辉光ROM颜色档位错误，建议修复后再做最终候选签核。高度填充目前画在基线另一侧，属于可选视觉修正。Catmull权重虽然是常数，但RTL写成乘法运算符；DSP预算必须以TD综合报告确认为准。

## 签核前阻塞项

1. **源切换立即改显示状态，可能撕裂当前帧。** `source_change`分支在发现`tone_mode != tone_mode_prev`的时钟沿立即清`front_valid`、解除`frozen_front`并更新`frame_tone_mode`（RTL第200–203行）。若切换发生在VS之间，波形会在该帧消失，标题也会提前切换；这与按VS原子切换和规格要求边界一致不符。建议增加sticky `source_pending`：音频累计可立即清空、后台builder立即中止，但显示bank有效位与`frame_tone_mode`保持到VS；在VS消费pending后再清历史/提交新模式，并保证同VS源切换优先于HOLD/旧builder。
2. **辉光alpha=15缺少ROM项。** `glow_color`明确列出0..14档，`default`为alpha16颜色`#08181A`。距离17时alpha=15，按规格应为`floor(15*[8,24,26]/16)=#071618`，当前会错误使用`#08181A`。这是一个精确像素差异，建议增加alpha15显式项。
3. **DSP预算尚无综合证据。** 插值四种权重分支包含`*22'sdN`常数乘法（第129–139行），常数有机会被综合器化为移位加减，但仅凭RTL不能保证不会占用DSP。构建签核应确认综合网表的DSP总数不超过8；同样需要确认BRAM9K总数不超过32。当前工程目录内未见C11302 TD综合报告，因此本项状态为待核实。

## 同步RAM与帧所有权

- `hist_mem`带`ram_style="block"`，读取数据在时钟沿注册（第119行）；`trace_mem`读取也在时钟沿注册（第256行）。编码符合同步读结构，实际是否映射为目标BRAM仍由TD报告确认。
- startup padding先把端点逻辑索引钳到0..127，再用`logical < 128-snap_count`掩码未填历史（第95–113行）；count为0时所有节点返回0，部分填充时只开放右侧有效样本。
- 未满窗时物理基址为0；满窗覆盖后`base_after=hist_write_ptr+1`，与新写入节点共同形成旧到新的逻辑顺序。`snap_base/snap_count`在VS锁存，RAM写入与第一拍builder读之间有完整时钟边界。
- Builder按segment和pixel顺序写`segment*4+k`，最后一列写完才置`capture_ready`。ready bank只在后续VS交换；活动构建写`capture_bank`，ready状态下builder已空闲，交换沿没有trace写入。source切换或HOLD时写口条件也会阻止无效/前台写入。
- 视频RAM地址按`next_x_pos`预取：x64映射第0列，x575映射第511列，x576及以上钳到511；因此曲线窗口首末列与读延迟匹配。

## 图形和色彩

- 曲线高度是非负Q4，距离`abs((408-y)*16-heightQ4)`在y<408时沿基线向上绘制，基线方向正确。
- `fill_pixel`当前要求`y_pos>408`，所以它只在基线以下最多四行绘色。若要填“曲线下方到基线”，屏幕坐标应在`y<408`且`0 < (408-y)*16 <= curve_height`的范围；由于规格把填充写成可选项，也可以取消填充，故此项是视觉修正而非功能阻塞。
- 主线alpha0..16颜色符合`floor(alpha*[72,220,210]/16)`。辉光alpha1..14逐档符合公式，alpha15如上有一档错误。生产参数gold回归现已确认此项：`env_errors=0`、`control_errors=0`，但有2个像素错误，均为distance17/alpha15，期望`#071618`、DUT输出`#08181A`，坐标为(71,367)与(69,370)；详见`build/model/envelope_20261013_181239_model_report.txt`与对应binding JSON。辉光RGB直接覆盖图形背景；外围低alpha值（例如alpha1 `#000101`）低于背景`#070B12`，视觉上会成为暗环/暗边。该结果符合当前给定的低亮度公式，但若期望发光而非暗描边，应调整为对背景做合成；这是美术选择，不是坐标/功能阻塞。

## 位宽与父版本源审计

- PCM绝对值为16位无符号，可表示`-32768 => 32768`；256样本累加使用25位临时和，`mean_abs`切片对应默认`AVG_LOG2=8`。20位`env_q4`允许最大目标524288。
- soft-knee只有常数移位/加减；Catmull最大加权幅度小于约127k，22位有符号`interp_num`足够；有符号`>>>7`实现负数向下取整，插值结果钳在`min(p1,p2)..max(p1,p2)`。
- SHA256对照C11301 frozen candidate中的两边`src`目录：各89文件一致映射，包含88个源文件和1个TD `.al`工程描述。88个源文件中只有3个HDL文件不同：`player_pcm_waveform.v`、`player_status_monitor.v`、`top_tf_hdmi_audio.v`；后两者仅把BUILD_ID从C11301改为C11302。其余85个`user_source`文件和3个`td_project/al_ip`文件字节一致，包含PLL、PHY、SDC、音频、scaler与控制RTL。`.al`描述文件只更改项目绝对路径。没有发现其他源漂移。

## 验证边界

先前gold代理报告的缩参模型覆盖startup、ring wrap、soft-knee/Catmull、HOLD与stale并PASS；生产参数128帧模型现为FAIL（总计2个辉光像素错误，env/control错误为0）。根代理修复颜色项并复跑前，不应作为最终像素gold通过。语法编译和模型结果不能代替TD综合、正式时序或板上验证。当前结论是源码审查，不代表实板成功。
