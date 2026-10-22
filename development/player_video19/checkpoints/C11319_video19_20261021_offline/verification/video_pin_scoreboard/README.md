# HDMI 串行 pin 视频与 PCM 校验

本目录在整机 ModelSim app-model 测试中直接采样 `HDMI_CLK_P/HDMI_D0_P/HDMI_D1_P/HDMI_D2_P` 串行引脚，恢复 TMDS 符号、活动视频 RGB 与 HDMI 音频包。整机 HDL、PLL replay、SD 卡和 SDRAM application model 从指定 `--base-run` 冻结目录拷贝；参考数据也单独冻结并校验摘要。

视频参考由独立 standalone 仿真运行C03冻结 JPEG RTL，对媒体索引中与最终整机 `jpeg_crc.mem` 对应的四个 JPEG 分别冷启动解码。每帧先核对 MJP 索引 SHA/CRC 和整机冻结 `jpeg_crc.mem`，再按解码坐标重排成 RGB888 `pin_rgb_reference.mem`。整机SD JPEG写流四帧逐坐标直接对照独立 C03 core RGB888；帧缓存读取则对照离线参考量化到 RGB565 后的RGB888像素。TMDS恢复像素按 `pin_line/480` 对应全局 AXIS 帧号，从双帧环形队列读取最终 AXIS 像素，并使用 AXIS 帧起始处捕获的 `osd_frame_valid` 与内容帧号标记资格；启动期间无效画面跳过，要求完整比较三个不同内容帧。这里AXIS队列用于证明串行链路对最终像素流的传递，独立JPEG core与帧缓存比较分别验证上游内容与存储链。独立 PCM 参考取最终整机冻结 `pcm.mem` 原声 WAV 样本，HDMI 音频包中的左右声道逐样本对照。

`tb_video_system.v` 的 `rgb_gold` 由独立 C03 core `pin_rgb_reference.mem` 量化后预填，再检查帧缓存读出；它不会从 DUT 写像素赋值。TMDS串行恢复像素对照HDMI核AXIS输入数据队列。`pcm.mem` 的原始 WAV SHA、四帧 JPEG SHA/CRC、C03 JPEG RTL SHA、独立 testbench SHA、参考像素 SHA均记入reference receipt；整机候选的生产SHA、兼容性副本SHA、冻结输入SHA和receipt SHA记入pin run receipt。

## 复跑

在 `E:/VSCODE-project/FPGA-ANLU` 用 PowerShell 7 执行；`<C03_RUN>` 提供baseline独立 JPEG RTL，`<APP_RUN>` 是应用级PASS冻结目录，含 `frozen/`、`jpeg_crc.mem`、`pcm.mem` 和 `summary.json`。`--start-frame` 是 MJP 内帧索引，需与 `<APP_RUN>/jpeg_crc.mem` 前四项匹配。最终Q90候选从配套媒体MJP帧107开始：

```powershell
$run = 'C04_Q90_pin_reference_mjp107_20261021_203750'
python development/video19_work/video_pin_scoreboard/prepare_reference.py `
  <C03_RUN> $run --input-run <APP_RUN> --start-frame 107 `
  --mjp development/video19_work/media_q90_trial/output/VIDEO.MJP `
  --index development/video19_work/media_q90_trial/output/index.json
python development/video19_work/video_pin_scoreboard/run_pin_scoreboard.py `
  --base-run <APP_RUN> `
  --reference-run "development/video19_work/video_pin_scoreboard/runs/$run" `
  --run-name 'C04_Q90_pin_health'
```

负消融分别将独立参考的一位翻转，要求仿真以对应比较器错误失败并由 runner 记为 `NEGATIVE_CONTROL_PASS`：

```powershell
python development/video19_work/video_pin_scoreboard/run_pin_scoreboard.py --base-run <APP_RUN> --reference-run "development/video19_work/video_pin_scoreboard/runs/$run" --run-name 'C04_pin_negative_rgb' --negative rgb
python development/video19_work/video_pin_scoreboard/run_pin_scoreboard.py --base-run <APP_RUN> --reference-run "development/video19_work/video_pin_scoreboard/runs/$run" --run-name 'C04_pin_negative_pcm' --negative pcm
```

每次 run 采用新目录，既有失败证据保留。检查 `summary.json`、`pin_source_receipt.json`、`compile.log`、`console.log` 和 `run.log`。模型启动期间出现的 X/未就绪告警及工具原始警告应保留在日志；结论看运行期 pin 锁定、错误计数、完整帧/样本覆盖与内容比较。

判据包含串行 clock-lane 对齐、TMDS解码错误数为零、四帧SD JPEG写流完整覆盖并逐像素对照C03参考、帧缓存完整像素对照独立RGB565参考、至少三个不同有效内容帧的TMDS像素与全局帧号匹配的AXIS输入精确相等、至少12000个原声PCM样本在HDMI包上精确匹配、无超限PCM丢样、BCH/TERC包错误为零，以及app-model整机原测试通过。启动阶段无效显示帧会跳过；总结记录全局AXIS帧槽、内容有效帧及像素覆盖。此模型不覆盖物理SDRAM时序、SDF或板卡运行。

## C04 Q90 离线 pin 收尾（2026-10-21）

最终候选 `video_system_20261021_203750` 的独立健康复跑为 `runs/C04_Q90_pin_20261021_203750_health_attempt02/summary.json`，状态 `PASS`，编译与仿真退出码均为 0。串行恢复记录 `axis_frames=19`、`axis_pixels=5813251`、`rgb_checked=5813228`；4 个 C03 独立源帧精确匹配，3 个不同内容显示帧共比较 5813228 像素；PCM 精确比较 12830/12830 个样本，BCH/TERC 错误、PCM underflow 与 late 均为 0。对应 `console.log` 含 `SYSTEM_PIN_CONTENT_PASS` 和 `VIDEO_SYSTEM_PASS`。

两项参考位翻转负控均按预期命中比较器错误，并由 runner 标记 `NEGATIVE_CONTROL_PASS`（编译、仿真退出码均为 0）：

- RGB：`runs/C04_Q90_pin_20261021_203750_negative_rgb/summary.json`；`console.log` 在 71.819697204 ms 触发 `PIN RGB mismatch`。
- PCM：`runs/C04_Q90_pin_20261021_203750_negative_pcm/summary.json`；`console.log` 在 70.729017202 ms 触发 `PIN PCM mismatch`。

先前失败健康运行 `runs/C04_Q90_pin_20261021_203750_health/` 保持原样；健康复跑与两份负控均使用独立新目录。本轮仅覆盖离线 app-model 与串行 pin/PCM 比较，不提供物理板卡证据。
