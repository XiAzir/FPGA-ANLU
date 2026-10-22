# C11319 颜色转换弹性流水

此目录保存 `jpeg_output` 的两级颜色流水候选及独立仿真。当前候选位于 `candidate_src/C03/jpeg_output.v`，SHA256：`B9539FF30324CA6A6FFCEEDFAF0A865BCB16DD6948CECF2899F8BD8126CB012D`。C04 已集成同一 SHA 的 RTL。

第一级在接受 Y/Cb/Cr 样本时计算并寄存四个原有定点乘积的 `>>> 12` 结果，同时寄存亮度、模式和坐标。第二级用原来的 32 位整数加减式生成 RGB，并保留原饱和/截断逻辑。两级均使用 valid/ready 弹性握手；输入 RAM 弹出、块索引和 4:2:0 子采样计数只在第一级接收时推进。各级停顿时数据和坐标保持。`idle_o` 等待 EOF 已观测且两级颜色流水均清空。

与原 C03 的源码差异见 [color_pipeline.patch](sim/color_pipeline.patch)。验证入口为 `sim/run_color_pipeline.ps1`，默认先把完整 RTL 源集与 testbench 冻结到独立 run 目录，再编译运行并生成 `manifest.json`，记录源文件、testbench、fixture、工具版本、编译图和输出哈希。较早的 full-frame run 使用旧 runner，未在编译时保存快照；其产物时间戳与补录哈希单列在 [early_run_postrun_receipts.json](sim/early_run_postrun_receipts.json)，没有回填编译时间。

## 像素输出核对

每条全帧记录为 little-endian `x`,`y`，后接 `R`,`G`,`B`，共 2,150,400 字节。基线和候选均为 640×480、307,200 个坐标完整像素；`fc /b` 比较逐字节无差异。

| JPEG | C03 / 候选逐字节 SHA256 | 候选激励与结果 |
| --- | --- | --- |
| frame000 | `A4D4B3B4B86A23831D06D4B3051DD4C9486B2141EBC4E5C62D67A605A9000440` | MODE2 随机背压，76,683 stalls；hold、重复坐标、越界计数均为 0 |
| frame109 | `CDE70E8F13E1982BC48F72480221462D1D3E4EA35B4C1584A8309A4754263E87` | MODE3 / GAP7 / SEED324508639 / ABORT_BYTES=10000，重置后重放；77,263 stalls，所有错误计数为 0 |
| frame299 | `53A1A0AF77BCAB1ED8130C177865C7D55C0FB1ABCE99250CBA4FE6C7929F3485` | MODE3 / GAP7 / SEED1597463007；77,495 stalls，所有错误计数为 0 |

A08 原核与 C03 原核在 frame000、frame109、frame299 三帧的全帧输出也逐字节一致，分别得到上表中的同一 SHA。帧输入位于 `development/video_codec_trial_20261021/decoder_fixture/`。

现有 synthetic JPEG 夹具均以 MODE3 / GAP7 / SEED1597463007 与 C03 对照：`solid_zero_ac` 为 4,096 像素/997 stalls，`dc_step_negative` 为 4,096/997，`dense_ac` 为 4,096/961；三者均逐字节相同，hold_errors、duplicate_coords、bad_coords 均为 0。

另对 `dc_step_negative` 的最终坐标 `(63,63)` 精确施加 8 个输出停顿周期。测试台在末像素未握手期间若观察到 `idle` 会立即报错；实际末像素停顿 8 周期，稳定性错误为 0，释放后 `idle=1`，输出仍与 C03 基线逐字节一致。

## 主要证据

- 最终 testbench + frame000 随机背压及完整源冻结收据：`sim/runs/candidate_C03_frame_000_2_0_0_20261021_201258_740/`。
- frame109 abort/reset 与 gap/背压：`sim/runs/candidate_C03_frame_109_3_7_10000_20261021_200245_221/`。
- frame299 gap/背压：`sim/runs/candidate_C03_frame_299_3_7_0_20261021_200520_187/`。
- 定向 EOF 排空和末像素停顿：`sim/runs/candidate_C03_dc_step_negative_0_0_0_20261021_200829_941/`。
- 三帧 A08 原核运行：`sim/runs/A08_frame_{000,109,299}_0_0_0_*`。
- 早期 baseline/candidate run 的后补来源与产物收据：[early_run_postrun_receipts.json](sim/early_run_postrun_receipts.json)。

## 边界

这些结果证明 Icarus 下全核 JPEG 解码的逐字节一致性、随机背压、输入 gap、abort/reset 和 EOF 排空。整机综合、布局布线及时序结论以父任务使用的 C04 同源构建报告为准；颜色流水单独未作新的 TD 消融。
