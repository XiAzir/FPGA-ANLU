# BMP stride 恒等式与独立综合结果

基线是压缩 header 候选 `development/resource80_work/bmp/tf_bmp_file_player.header.v`，SHA256 `94543758ef1dfaece9dd6d21aa3e7412cc041f5de2fa4e6c317dedc1eab0f3f2`。可直接替换 loader 的候选在 `tf_bmp_file_player.header_stride.production.v`，SHA256 `093c86171d75dd5f9df66da51bbc0830bc391b70b4c5ae627d3bf4d0d8111dc6`。

唯一RTL变化是用 `w=4q+r` 的恒等式 `ceil(3w/4)=3q+r` 重写 `source_stride`，再按原 `[11:0]` 赋值截断。`stride_words` 是10位，因此中间只保留 mod 1024；左移2位后正好等于原12位 stride 的 mod 4096。非法宽度也需要这个截断等价，因为像素 extent 与诊断 mask 对非法 width 仍由 width[10:0] 派生。

```verilog
wire [9:0] stride_words = {1'b0,width_low[10:2]} + {width_low[10:2],1'b0} + {8'd0,width_low[1:0]};
wire [11:0] source_stride={stride_words,2'b00};
```

验证结果：

- `tb_stride_identity.v` 在 Icarus 中穷举 `width_low=0..2047`，原始14位乘加右移/对齐公式与候选12位 `source_stride` 完全一致：`BMP_STRIDE_IDENTITY PASS widths=2048`。
- `tb_tf_bmp_failure_detail.v` 对压缩 header 基线与候选逐周期比较公开输出、状态和 failure detail，538 case / 529 header masks 全部通过；其中512个 raw32 width/height/extent 随机交叉、两种 sector 长度、mapper/watchdog/scaler/sticky/reset/valid commit均通过。完整日志为 `run.log`。

AreaHigh + AdderThreshold18 standalone：EG4S20BG256、20ns、同一 `bmp_scale_engine` 和 `key_press_debounce`。console 当前参数表确认 AreaHigh（add_map_lut_struct high、map_mode area_prior、multi_thread_mapping partition、resource_sharing auto、shifter_style shifter_reg）、`min_ripple_len=18`、`mapper_lut_delay=1600`。参数表见各自 `console.log`；TD对 `report_param -file [file join ...]` 的嵌套路径没有展开，面积结果文件完整。

| 变体 | device LUT | device REG | generic LUT | top DSP | u_scale DSP | loader DSP |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 压缩 header 基线 | 2014 | 699 | 1370 | 6 | 4 | 2 |
| 恒等式 stride | 2064 | 699 | 1365 | 6 | 5 | 1 |

该变换把 loader 局部 DSP 从2降到1；standalone 总 DSP 保持6，因为同一综合里 `u_scale` 从4映射到5。器件 LUT 增加50、REG不变，generic LUT减少5。因此当前证据支持这是时序结构候选，面积代价需要结合 B03 fulltop route 衡量；本实验没有跑 fulltop/P&R，也未运行 AreaHigh-only 对照。

输入 SHA、面积字段和 patch SHA见 `result_manifest.json`；补丁差异在 `patch_header_stride.diff`。未改主候选或gold。
