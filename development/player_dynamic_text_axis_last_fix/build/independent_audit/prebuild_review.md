# AXIS TLAST 单项修正候选独立审核（物理前）

日期：2026-10-09。只读审核 `player_dynamic_text_axis_last_fix`；未运行构建、未改源码/工程/测试/位流或检查点。此时根代理告知综合已完成、布局布线即将开始；本审计仅覆盖变更范围、工程绑定和 AXIS 模型，不代表 post-route STA/guard。

## 源码与工程范围

- `src/user_source` 两候选各 76 个文件。相对路径与文件集合完全相同，逐文件 SHA256 比较仅有一项变化：`hdl_source/video_rgb_to_axis_640x480.v`，旧哈希 `1C8FC26C789F87227036BEA034F1AB6FC5633F2AB2684BE422C54687A290FB96`、新哈希 `E8A2432DAF9A58ACA20F81BBF64B32719BAF3918135C8B7C6E266E0C05496683`。逐行差异只有 `if (S_x_cnt == 11'd639)` 改为 `638`（新文件第 58 行）。无其它新增、删除或修改 user_source 文件。
- `.al` 除 `<Project ... Path=...>` 中候选根目录外，全文行内容相同；归一化工程根路径后两文件完全相同。因此当前候选仍注册相同顶层、源、PLL、SDC、pin 与 encrypted core 文件。项目 `src/td_project/al_ip` 3 个文件、`src/user_source/ip_source` 3 个文件、`src/user_source/hdl_source/IP` 19 个文件、`constraints_source` 4 个文件逐文件 SHA256 均一致；显式检查 `timing.sdc` SHA256 `977ABCDB8B6C4DF93CBD8FE407D5DFA5AB2710CE45214D7713F583F91A732146`、`pin.adc` SHA256 `234048B30CB6BB3BFC76AE081CBDCAD4B2596FF55DCA81AD8E7856CD9E3BF759` 均与 probe 相同。
- `build/manual/build_source_scope.json` 80 项路径均存在且对当前 `src` 的 SHA256 全匹配；包括构建阶段实际绑定新 converter 文件。没有发现 scope/hash 与当前候选脱节。

## AXIS 模型绑定与证据

- `build/axis_model/source_bindings.json` 的 7 个输入文件均存在且实际 SHA256 与记录一致：候选 converter、冻结的旧 converter、testbench、`color_bar.v`、`video_timing_data.v`、`video_delay.v`、`video_define.v`。运行脚本 `scripts/run_axis_model.ps1` 编译的正是这些实现/测试源，明确用 candidate source + 独立 old snapshot 对照；运行日志由 VVP 产生，脚本再断言 full summary 行 `lines=960 pixels=614400 orig_last=0 fixed_last=960 sof=2 failures=0`。`compile.log` 为空而生成了 71,198-byte `.vvp`，与 Icarus 成功但无诊断文本相符；不单独当作测试结果，PASS 以运行日志和脚本断言为准。
- 现存 `build/axis_model/run.log` 记录：direct 639-valid 短行不发 TLAST；后续 640-beat 行发一个 TLAST；300-beat 中断后 reset 再发完整行累计增加一个 TLAST；VS 上升/下降都重开 SOF；完整真实源链 2 帧、960 行、614,400 valid pixels，原版 TLAST=0、候选=960、SOF=2、data/valid latency=1；日志最终 PASS。testbench 的完整链输入实例化真实 `video_timing_data` 和 `video_delay`，独立统计 DE 行宽/像素，不复制候选 `S_x_cnt` oracle；有针对短行、reset、VS 边沿的 directed oracle（testbench:52–129,151–284,294–300）。
- 模型边界：它验证 converter 与 `video_timing_data + video_delay` 的 RTL 接口周期语义，不实例化安路加密 HDMI transmitter core、video AXIS receiver、PHY，不验证该 IP 如何使用 TLAST/ready、为何 `O_video_locked=0`，也不含 routed/timing/板级行为。因而它证明修正输出时序符合 640 个输入 valid 的末拍规则，不证明本次无 HDMI 信号根因就是 TLAST。

## 阶段状态 / 需后续检查

- 构建输入范围与模型证据一致。此轮未运行编译。候选 `build/manual/AC201_tf_hdmi_gate.ts` 当前为 SWNS `-1.663 ns`、HWNS `+0.471 ns`、HTNS `0` 的综合/早期 gate 报告，不能当最终 routed STA；`physical_console.log` 在本检查时可见 route 迭代输出，尚无本审计认定的最终 guard/原约束 STA 结果。
- `build/preparation.json` 保留准备阶段信息 `candidate_model=PENDING`、`td_build=NOT_STARTED`，但时间早于模型文件（preparation 15:10:38；模型绑定/日志约 15:11:13），现与已完成模型证据及后续综合状态不一致；本次只报告，不改元数据。
- 下一步待布局布线完成后，对最终原约束 STA、hold guard、final route DB/bindings 及检查点/source guard 做只读复核；在此之前不从综合 timing 或 converter 模型推断板级恢复。

## 综合后文本产物对照（只读；未启动 TD 导出）

- 后续按根代理要求，仅读旧 probe 与本候选 `build/manual` 文本。两版 `AC201_tf_hdmi_gate.area` SHA256 完全相同（`7DE03073B3A0A9C1B233E1F0D0B64FB3D68908923EC76D469DBE6A2E9807289C`），其中 top `Total_luts=8818`，`u_video_rgb_to_axis_640x480` 同为 224 LUT/26 reg。`AC201_tf_hdmi_gate.ts` SHA256 也完全相同（`CCF134D98281D82B5CBD176A31307F599EFADB8FDEBCA567CD4229CCAB3B8258`）：SWNS -1.663ns、STNS -47.264ns、HWNS +0.471ns、HTNS 0。`AC201_tf_hdmi_gate.timing` 的文本差别仅为生成时间与项目 `timing.sdc` 绝对路径，其余逐行一致。
- Gate DB 均为 6,567,878 bytes，但 SHA256 不同：旧 probe `5BE25FDEF054FA36C4943587E1CCC862C0B50A504BB33AB2CE1286A26897B230`、新候选 `7E19CDFA27837747B32F90BC32379AE62661BE87512F508A28AD1D9BE41964F2`。DB 为二进制；当前阶段 gate/timing/area 文本仅支持“资源和摘要时序不变”，不支持“last 比较器已完全裁剪”。LUT INIT、内部拓扑或 DB 元数据仍可能变；当前尚无 gate Verilog 导出。
- 根代理告知 fix_hold 正运行，因此本审计没有启动任何 TD import/export，也未碰任何 DB。待最终 hold 完成并获通知后，再按要求只读导出/检查最终 PR DB 与 STA/guard；不能从面积相同或此 gate 文本差异外推 TLAST 消费行为。
