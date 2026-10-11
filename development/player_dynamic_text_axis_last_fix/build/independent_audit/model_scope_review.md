# AXIS 行协议模型独立审核与适用范围

日期：2026-10-09（北京时间）

## 审核对象

审核 `development/player_dynamic_text_axis_last_fix` 中的 `build/axis_model/source_bindings.json`、`build/axis_model/run.log`、`sim/axis_protocol/tb_axis_protocol_fix_audit.v`、对照副本 `sim/axis_protocol/video_rgb_to_axis_640x480_old.v` 及生产绑定源 `src/user_source/hdl_source/video_rgb_to_axis_640x480.v`。本次为只读检查；只新增本报告，不改 RTL、工程、bit、检查点或工作日志，也未重跑/扩展模型。

## 证据与判断

### TLAST 缺失是确定的接口缺陷

旧 converter 以首个 valid beat 装入 `S_x_cnt=0`，同一拍比较的是旧计数；连续 640 个有效拍最后一拍比较值为 638。原逻辑比较 639，因此真实 640 像素行不会发 TLAST。候选生产绑定源现为 638；随测试的旧副本仍为 639。

独立性检查通过：全链 oracle 的 `full_line_len`、`full_x` 根据 `video_delay` 输出的实际 `de` 样本逐拍计数，并在每个有效拍断言 `last == (x==639)`；它没有读取 converter 的 `S_x_cnt`。行数/像素数另从有效脉冲起止计数。直接输入边界 oracle 同样按输入 DE 拍计数。testbench 对完整两帧逐拍检查 valid/data、TLAST、USER，并检查 blank 期间 TLAST/USER 为 0。`run.log` 记录 960 行、614400 像素、旧模块 TLAST=0、新模块 TLAST=960、SOF=2、failures=0；另有 639 短行、短行后完整行重新计数、300 拍行中异步复位后新行、VS 上升/下降边沿场景，均 PASS。

`source_bindings.json` 所列候选源哈希与当前文件相符，包括生产绑定 converter、旧对照、TB、color_bar、video_timing_data、video_delay 和 video_define。`scripts/run_axis_model.ps1` 明确列出 Icarus 参数与完整源文件列表，并在同一脚本中执行 VVP、检查 PASS 摘要、生成输入 SHA 绑定；`compile.log` 为空是该次成功编译无工具输出，不构成命令复现缺口。旧对照源改回原模块名后，与已知成功版 `player_osd_phy_fix` converter 逐非空行一致；二者的 TLAST 比较都为 639。这确认缺失 TLAST 是协议问题，也确认它在成功/失败两版中是共同既存逻辑。

### 40 拍启动 X 屏蔽的范围

候选 TB 将时序/延迟链复位 `rst` 释放后继续保持 converter 的 `axis_rst` 40 拍。`video_timing_data` 的 `video_de_d1` 在异步复位分支没有赋值，复位释放首拍可向 `video_delay` 的 21 级 DE 管线送入未知值；该未知值在短暂启动期到达 converter 输入。单独保持 converter 复位超过 21 级管线长度后才开始比较，可屏蔽此启动暂态。640×480 源的垂直有效区要到约第 45 行才开始，40 拍远早于首个有效像素，不会丢掉正常活动区。该策略只约束仿真启动，不修改生产 reset，也不证明真实复位/CDC 行为。

### VS 与 SOF 范围

生产 converter 的 SOF 规则是：检测任意 VS 电平变化后 arm，并在下一次有效行首像素输出一个 USER。full-chain oracle 用外部采样的 VS/DE 维护这一规则，并独立断言两帧中 USER 恰两次且处于第 0、480 行的首有效像素。直接 VS 场景在 blank 内分别驱动上升和下降边沿，再核对下一有效行首的 USER；这符合当前 top 中正常 VS 跳变位于 blank 的时序。测试没有注入有效行中途的毛刺/非同步 VS，结论不覆盖这种非正常输入。

## 官方 HDMI 文档与 `O_video_locked`

本地官方文档 `APUG092_HDMI1.4b_Transmitter_V1.0.docx`（`赛题1_工作资料/05_补充参考工程/官方赛题1_康芯2026/lab_ex5_i2s/doc/`，SHA-256 `070B22D3FF63E697ED7DB39EEE61E8653C60F58E0D6EB9CFDAF2AB16001B1543`）第 2.4.2 节 `Video Interface` 将 `I_axis_s_last` 定义为视频输入行结束信号，将 `O_video_locked` 定义为输入视频接口锁定信号。文档还规定：`I_axis_s_user` 在第一行首个有效数据拉高；`I_axis_s_last` 在一行末尾拉高；`O_axis_s_ready` 只会在 LAST 为高之后拉低，再次拉高表示可继续写入，因此一行数据必须连续。文档说明 core 以内部 Video Source 与外部输入时序做相位匹配，二者对齐并锁定后 `O_video_locked` 拉高，表示输入视频数据被正确捕捉。

因此缺失 LAST 违反该接口定义，可能破坏行界/相位匹配输入，属于确定缺陷；但手册没有说缺失 LAST 必然导致完全无输出或锁定永远为低，不能把接口违反直接等同于黑屏根因。

## 为什么不能单独解释成功/失败差异

成功 `player_osd_phy_fix` 与失败 `player_dynamic_text_fit` 的原生产 converter SHA 都是 `1C8FC26C789F87227036BEA034F1AB6FC5633F2AB2684BE422C54687A290FB96`，两者均比较 639；此前只读真实链路仿真也复现两帧/多行无 LAST。因此这是共享的历史缺陷，而非已识别出的版本差异。它可能是修复后应消除的协议风险，但仅凭它无法解释为何成功版能显示、某个失败版无信号。

根代理已澄清：最新冷启动摘要（视频页 `3900BB80`、输入 tone 48000、状态页 `1DA80000`、`packet_samples=0`、`corelock=0`）来自未修正的 `player_dynamic_text_video_probe.bit`，不是 `player_dynamic_text_axis_last_fix`。新修正候选尚无实板测试。该摘要只描述旧 bit 的现象，不能用于判断 TLAST 修正是否足够，也不能把 corelock=0 归因于 TLAST。后续须在修正候选上重新观测后再判断。

## 后续实板观察建议

在同一像素时钟域同时记录 `axis_valid`、`axis_last`、`axis_user`、`axis_data`、`O_axis_s_ready` 与 `O_video_locked`：核对每行 640 个连续 valid、LAST 只落在第 640 个有效拍、USER 只在帧首像素；观察 ready 是否按手册在 LAST 后拉低并重新恢复，以及 corelock 是否最终拉高。这样能判断协议修正是否真正进入 core 接口并建立 phase lock。当前 testbench 不建模 HDMI core ready/backpressure，也不包含加密 core、路由后时序或硬件。

## 可复核文件

- 实际仿真结果：`development/player_dynamic_text_axis_last_fix/build/axis_model/run.log`
- 源文件绑定及哈希：`development/player_dynamic_text_axis_last_fix/build/axis_model/source_bindings.json`
- 逐拍 oracle：`development/player_dynamic_text_axis_last_fix/sim/axis_protocol/tb_axis_protocol_fix_audit.v`
- 新旧 converter：`development/player_dynamic_text_axis_last_fix/src/user_source/hdl_source/video_rgb_to_axis_640x480.v`、`development/player_dynamic_text_axis_last_fix/sim/axis_protocol/video_rgb_to_axis_640x480_old.v`
- 官方文档：`E:/QQ CACHE/Download/安路资料/赛题1_工作资料/05_补充参考工程/官方赛题1_康芯2026/lab_ex5_i2s/doc/APUG092_HDMI1.4b_Transmitter_V1.0.docx`


