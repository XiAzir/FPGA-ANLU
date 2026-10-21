# C11316 scaler 输入字段生命周期复用

结论：`HEADER_VALIDATED=1` 的生产 scaler 候选保留，供根任务做 C11317 组合全 top 评估。它用 loader 在成功 `CHECK` 后持续稳定的宽、高及文件头字段，替代 scaler 自己锁存的 `src_w[10:0]`、`src_h[9:0]` 和 `stride[11:0]`。默认参数 0 仍沿用原来的 S_IDLE 锁存路径。此目录实验没有修改 C11316 父工程、冻结文件或位流；也没有执行本候选的全 top、P&R、时序或板测。

## 源绑定与实现

- C11316 原 scaler：`bmp_scale_engine_baseline.v`，SHA256 `f3d77c0dcaac1a43c59e30deb51b06988a81a9d91f0c6135f0eb17158057c04c`。
- C11316 loader：`tf_bmp_file_player_c16.v`，SHA256 `8c4c61c8f8474ae44115c3ac0a056910886996302cd0845b775cf00a8b28f5b7`；其生产实例传入 `.HEADER_VALIDATED(1)`。
- 候选 scaler：`bmp_scale_engine_candidate.v`，SHA256 `cde50900d2307674272134b2043c1cd26b53f1372fad913eef1b227a7f9706e2`；改动见 `candidate.diff`，SHA256 `f8a74ddf2c5c39ed7b80e19a5c80e8f885427a5fb732ee047e294da98e3410cc`。
- 文件和运行证据的完整哈希、参数与覆盖范围记录在 `source_receipt.json`。

原锁存的 RHS 被赋给11位、10位、12位寄存器，因此值分别等于 `source_width[10:0]`、`source_height[9:0]` 和原 12 位 stride 表达式。候选 `HEADER_VALIDATED!=0` 生成分支直接接入这三个表达式；`HEADER_VALIDATED=0` 生成分支在同一 `state==S_IDLE && start` 事件更新 q 寄存器，异步 reset 行为与父版本一致。候选没有增加运行时检查、状态或周期。

生产 loader 先完整读取512字节头，再由 `CHECK` 核实宽 `1..1024`、绝对高 `1..768`、stride 与图像结束地址；只有成功后才发 `scale_start`。成功启动后，字段保持到 scaler 完成。loader 结束一张图并回到 `IDLE` 后，下一次选图才重新装载宽、高、stride、offset 与 size。新候选因此只用于这个现有已验证调用参数。

## Icarus 差分

使用 C11316 源副本作为 reference，所有对外信号逐周期比较。可复现命令为 `pwsh -NoProfile -File development/arch17_work/scaler_lifetime/run_tests.ps1`；Icarus 位于仓库 `bringup/tf_wav_hdmi/tools/iverilog/app/bin`。实际输出保存在对应 `*.compile.log`、`*.run.log` 中。

- `default_13case` PASS：候选参数默认0；7个合法几何/方向和6个非法尺寸、extent、传输错误用例与 C11316 父 scaler 逐拍相同。
- `valid_domain` PASS：候选参数1；7个合法生产域边界尺寸与 C11316 父 scaler 逐拍相同。
- `diagnostic_538` PASS：两份完整 loader 都来自上述 C11316 SHA，baseline/candidate scaler 分别绑定；原538项 header 诊断、扇区长度、mapper/watchdog、sticky error、reset 与正常 commit 均通过。追加的无复位连续重选测试处理 `32x24` 后再处理 `17x13`，活动期间被动检查输入头字段与派生宽/高/stride 稳定；loader 在 `IDLE` 更新第二张图字段时，逐周期比较的公共输出保持一致。两个场景均成功提交，第二张图 `current_image_index=1`、file size=730；`starts=3` 另含前面的短payload错误覆盖。

第一次双图夹具运行停在 `IDLE`，检查发现驱动在首张图后未重新拉高 `catalog_ready`；修正夹具后整组538诊断和双图测试通过。该问题属于测试驱动条件。

## TD standalone 面积消融

baseline 与 candidate 均为完整 `tf_bmp_file_player` top，独立新鲜 TD 进程顺序综合；TD 6.2.1_SP1 / 6.2.178.840，EG4S20BG256，AreaHigh、`min_ripple_len=18`、`mapper_lut_delay=1600`、`add_map_lut_struct=high`、`map_mode=area_prior`、`multi_thread_mapping=partition`、`resource_sharing=auto`、`shifter_style=shifter_reg`。两边读取同一20ns约束，actualparams、控制台、area报告均保存在 `td_area_high/{baseline,candidate}`。Tcl入口分别为 `td_area_high/run_baseline.tcl` 与 `run_candidate.tcl`；初次项目XML失败和修复过程见两份 `initial_project_xml_rejection.txt`。

| 指标（gate.area） | baseline | candidate | 差值 |
| --- | ---: | ---: | ---: |
| Device LUT | 1868 | 1866 | -2 |
| Register | 698 | 677 | -21 |
| Generic LUT | 1290 | 1262 | -28 |
| BRAM | 4 | 4 | 0 |
| DSP | 5 | 5 | 0 |

RTL 上移除了33位独立锁存；完整 loader 综合后，实际 register 数净减21。面积报告中的 generic LUT 减少28，device LUT 减少2。综合 QoR 的 `#registers` 也从687降到666。以上为 standalone 面积证据，不能替代 C11317 组合后的全 top 资源与时序结果。

TD 日志的首轮尝试因为生成的 `.al` 缺少必需的空配置节点，在 `open_project` 报 `PRJ-8601`，没有进入综合。项目文件按已验证的 C11315 XML 结构补齐后，baseline 与 candidate 各在独立进程完成，均出现 `AREA_DONE` 和 `SYNTHESIS_COMPLETE`。两轮均读取单份20ns约束，没有重复 clock 告警。RAM init 被关闭所产生的两条既有 `SYN-6562` 信息在两边相同。

- baseline：`td_area_high/baseline/reports/gate.area`，SHA256 `25c05baf24cf2bb011efcc7c68fc5f9986a3b282459099d7569c277bf2c2cca8`。
- candidate：`td_area_high/candidate/reports/gate.area`，SHA256 `4f4e08d90f0096fbf8f6a55e76ad4d76905fb5cabf0fd6e9e8dc77a9e4317668`。
- 参数及日志哈希见 `source_receipt.json`，便于复核本次实际执行副本与综合报告的绑定。

本候选尚未合入 C11316/C11317；根任务将决定与 mapper 优化的组合及其全 top、整机验证结果。
