# BMP 资源压缩实验

本目录只保存 BMP 独立候选、apply/generation 脚本、测试和面积数据。当前可继续评估的候选是 `tf_bmp_file_player.header.v`，工程基线 loader SHA-256 为 `e902f65baba30712402b3c39cdc9be01adaf66aaf0bdb4c462d205e4ece84642`，候选 SHA-256 为 `94543758ef1dfaece9dd6d21aa3e7412cc041f5de2fa4e6c317dedc1eab0f3f2`；配套 `bmp_scale_engine.v` 保持基线 SHA-256 `1916cf21f554e64d476d3697973cdba33f66c0acefbdbab5b48341cbeea29519`。

重新生成候选：

```powershell
Copy-Item development/resource80_work/bmp/tf_bmp_file_player.base.v development/resource80_work/bmp/tf_bmp_file_player.header_base.v -Force
python development/resource80_work/bmp/patch_header_fields.py
```

脚本按 CHECK 时点的完整字段判定生成：magic、planes、bit count、compression 各以单个 sticky valid 表示；width 保存低 11 位与原始 `[31:11]` 非零归约；height 保存 sign、低 10 位与原始 `[30:10]` 的 all-one/all-zero 归约。scale stride 与 image byte 运算仍只读原设计用到的 width[10:0]、abs(height)[9:0]，所有 failure_detail mask 位仍独立计算。

已通过 Icarus：

- `header_failure/random_mask_run.log`：基线和候选 public outputs 并行对照，538 项 failure_detail 场景通过；其中 512 组随机 32 位 width/height/declared/file-size 按原宽度公式重算完整 mask，覆盖 file extent 与 declared extent 交叉位。
- `verify_header_compression.py`：500,000 组随机宽高归约谓词等价。
- `verify_fixed_header_reduction.py`：500,000 组随机 magic/planes/bpp/compression 等价。
- `run_header_fields/build/model/scaler_full_loader_run_20261020_215413_022.log`：六图 1,843,200 像素逐点 gold 比对通过；4 类错误输入均保留旧显示帧与缓冲区。

`bmp_scale_engine.rowstep.v` 是面积消融候选：它用逐行 stride 更新代替 `physical_row*stride`。七组合法边界和六种错误条件逐周期等价、6 图完整回归均通过，但 standalone TD 面积为 generic LUT 576 / device LUT 1104 / regs 363 / DSP 4；基线为 549 / 1033 / 352 / 5。此方案节省 1 DSP，同时多 71 device LUT 和 11 regs，已停止推进。

## AreaHigh standalone loader

`prepare_loader_synthesis.py` binds base/header sources and debounce module hashes in `synthesis_loader/manifest.json`. The two serial TD runs used EG4S20BG256 and `standalone.sdc` 20 ns. Both console logs record the same AreaHigh settings: `add_map_lut_struct=high`, `map_mode=area_prior`, `multi_thread_mapping=partition`, `resource_sharing=auto`, `shifter_style=shifter_reg`; loaded strategy also reports `opt_area=high`, `map_mux41=on`.

| Variant | Generic LUT | Device #lut | Device #reg | DSP |
| --- | ---: | ---: | ---: | ---: |
| Baseline loader + baseline engine | 1386 | 2173 | 814 | 7 |
| Compressed header loader + same engine | 1308 | 2052 | 699 | 6 |
| Change | -78 | -121 | -115 | -1 |

Reports are in `synthesis_loader/{base,header}/reports/gate.area`; full TD outputs and source hashes are retained beside them. The full six-image Icarus run used candidate hash `94543758ef1dfaece9dd6d21aa3e7412cc041f5de2fa4e6c317dedc1eab0f3f2` and passed.
