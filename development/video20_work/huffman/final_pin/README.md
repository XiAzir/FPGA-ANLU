# D02 final HDMI pin回归准备

该目录从 `video19_work/video_pin_scoreboard` 复制了成熟的 pin runner 和 checker。路径根按本目录实际深度设置为工程根目录，默认应用源改为 `player_video20`，默认 base run 指向 D02 冻结目录：

`development/player_video20/build/video_system_20261021_215350`

独立 Q90 参考复用现有 PASS 目录 `development/video19_work/video_pin_scoreboard/runs/C04_Q90_pin_reference_mjp107_20261021_203750`，不重新构建 reference。该 reference 从帧107开始，包含四帧107–110，与 final app 的前四项 `jpeg_crc.mem` 对照。

收到父任务确认该 app 的 `summary.json` 为匹配路径的 `PASS` 后，运行一次健康回归：

```powershell
python development/video20_work/huffman/final_pin/run_pin_scoreboard.py `
  --base-run development/player_video20/build/video_system_20261021_215350 `
  --reference-run development/video19_work/video_pin_scoreboard/runs/C04_Q90_pin_reference_mjp107_20261021_203750 `
  --run-name D02_final_health
```

Runner 会保留原有门槛：四帧 JPEG 写流逐坐标 RGB888 对照、帧缓存参考、TMDS 恢复像素与全局 AXIS 帧的逐像素校验、三个不同有效显示内容帧、PCM 样本对照与 BCH/TERC 检查。共享/retime 增加的首帧延迟由现有 900 ms testbench 总时限覆盖。

旧 C04 的 RGB 与 PCM 负控均为 `NEGATIVE_CONTROL_PASS`，其 `system_pin_scoreboard_video.vh` SHA 均为 `86854ceb...ba3be62`，与本目录拷贝逐字节相同。它们证明这份既有 checker 能拒绝参考 RGB/PCM 单位翻转，覆盖范围属于 C04 旧健康源；本轮无需重跑负控，也不将其记作 D02 候选的负控结果。

`run_pin_scoreboard.py` 只对该次 run 复制出来的冻结兼容文件运行 `model_sim_color_compat`，把 ModelSim 不支持的初始化 net 声明改为声明加连续赋值。产品源和 D02 base-run 保持只读。

本目录准备收据见 [prep_receipt.json](prep_receipt.json)。截至该收据生成时，D02 `summary.json` 尚未出现，pin健康仿真尚未启动。

## D02 健康回归结果

已按 D02 应用 `video_system_20261021_215350` 运行一次 `D02_final_health`，ModelSim compile 和 simulation 均 exit 0，`summary.json` 为 PASS。详细凭据见该 run 下的 `health_receipt.json`，完整日志及冻结输入/参考均保存在同一目录。

Checker SHA-256 仍为 `86854cebca192f1c17ad10850a943ac29a1d3cf8b0c4e61147a459d45ba3be62`。仿真在 355 ms 收尾：五次 framebuffer commit 共 1,536,000 decoded pixels；前四个源帧逐像素匹配独立 C03 gold，三个 HDMI 显示帧共 6,124,468 pixels 与最终 AXIS 队列匹配，distinct_pixels=91,883；PCM 共送出 12,840 samples，其中 pin checker 已逐样本核对 12,839；收尾时最后一笔仍在流水。BCH/TERC clean，underflow=0、late=0。AXIS 共20帧、6,124,491像素，RGB逐像素核对6,124,468像素。五帧 decode 时间为 47.116、48.234、47.877、48.402、49.000 ms。

旧 C04 RGB/PCM 负控仍仅作为 unchanged checker 的拒绝能力证据；未声称 D02 负控。物理 SDRAM 时序、SDF 与板上行为未覆盖。此前 `prep_receipt.json` 是准备阶段不可变回执，保留其 `PREPARED_ONLY` 状态；最终健康结果在 run 内独立记录。

