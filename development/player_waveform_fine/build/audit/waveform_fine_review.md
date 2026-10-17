# C11301 波形清晰度 RTL 只读审查

状态：RTL 静态审查、TD 综合网表核对、快照逐文件哈希审查及完成阶段复核均已完成；未修改 RTL，未运行仿真。初次审查时 physical 仍为 running，末尾追加快照记录其后续 success 状态。审查对象为 `player_waveform_fine/src/user_source/hdl_source/player_pcm_waveform.v`，基线为 `player_bmp_scale/checkpoints/bmp_scale_20261012_verified/src/user_source/hdl_source/player_pcm_waveform.v`。

## 结论

未发现 `previous_mid` 与同步 BRAM 读地址错一列的问题。旧模块依赖的采集、双 bank、VS 提交、冻结/恢复、切源失效与 stale 控制流程保持原有顺序和条件；生命周期代码去注释并将旧 7 位清零常量对应扩为 9 位后，比较仅有空行差异。主要剩余风险是新连线对大幅跳变会在当前列形成整段竖向填充，以及 midpoint 对奇数和向下截断带来的半个 Q2 单位（1/8 像素）偏置；需由独立 golden 与实板视觉确认。

## 逐项结果

- **同步读与邻列拍点：通过静态时序推导。** RAM 每拍以 `next_x_pos` 读下一显示坐标；`previous_mid` 在同一边沿取旧 `trace_read_data`。该旧数据对应边沿前的 `x_pos`，边沿后 RAM 数据与坐标一同前进一步。因此像素 x=64 时显示列0且不使用邻列；x=65 时 `previous_mid` 为列0、当前读数据为列1。此配对持续到 x=575。
- **左、右界和行清理：未发现越界。** 预取地址将 `next_x_pos<=64` 钳为列0，`>=576` 钳为列511，中间为 `next_x_pos-64`；图形门限仍是 x=64..575。`previous_valid` 在 `!de`、不在 `in_graph` 或 VS 转换时清零，且 x=64 明确禁用前邻，避免把消隐期间钳位读出的地址当作首列邻居。DE 空白逐行清缓存；右界外不显示桥接结果。
- **Q2 垂直量化：范围和位宽成立。** signed PCM16 算术右移6位再加112，限制到0..224；有符号临时量11位足以容纳 `-400..623`，数据码9位可表达上限224。图像 `row_code=(412-y_pos)<<2` 在图形门限内为0..224，与旧物理行356..412及中心y=384相符。边缘距离1/2/3分别输出 `00bfbf/007f7f/003f3f`，为青色通道按整数向下取整的3/4、1/2、1/4亮度。
- **捕获计数与地址位宽：成立。** `BINS=512`，`capture_bin` 宽度为10位，可表示最后列511和完成标记512；`samples_in_bin` 宽度为1位，对默认2样本正确表示0/1。写地址 `{capture_bank,capture_bin[8:0]}` 和读地址 `{display_bank,predicted_bin}` 均为10位，覆盖 `[0:1023]` 两个512列 bank。最后列第二个样本写入后才置 `capture_ready` 并停止捕获，对应1024个有效样本。
- **生命周期：结构未见意外改动。** 与 C11206 相比，控制分支、赋值优先级、`capture_accept` 抑制条件、VS 原子交换、front/back 所有权、冻结、音源改变与 stale 失效流程保持一致；差异限于规格要求的默认样本数、bin/数据位宽和清零字面量宽度。静态比较对生命周期区间去掉注释并正规化旧/新清零常量后，只余一处空行差异。

## 待 golden / TD / 实板确认的风险

1. 当前 midpoint 使用 `(max+min)>>1`，奇数和向下取整，会固定偏低半个 Q2 单位，即1/8像素；这是 Q2 码的半步，不是一个 Q2 LSB。若规格要求最近取整，可考虑在右移前加1，但需让 golden 期望算法与规格一致。
2. 桥接把前后 midpoint 闭区间并入当前列 min/max，较大跳变会让单个像素列出现较长全亮竖条。这是每列1像素下该画法的直接结果；应由 model 覆盖连续大跳、正反向斜率和当前 min/max 与 midpoint 区间相交/包含的情况，评估是否符合期望。
3. **TD 综合映射已确认。** `AC201_tf_hdmi_gate.v` 中 `u_pcm_waveform/ramread0_syn_4_1024x16` 对应两个 `EG_PHY_BRAM` primitive（均为 `DP8K`）；综合将未使用的高数据位优化掉，实际逻辑存储为16×1024 bit，使用2块 BRAM9K。`AC201_tf_hdmi_gate.area` 报告整机 29/64 BRAM9K、utilization `#lut=14621`、`#reg=8677`、`#dsp=8`；报告的 `#Total_luts=8443` 是 LUT 逻辑统计项，和资源 utilization 的 LUT 计数口径不同。本次追加的完成快照记录了随后成功的 physical 与 bitstream 阶段；见末尾时间快照及证据，不把此前 running 状态当作最终结果。
4. 本报告包含 RTL 静态审查和综合网表/资源核对，不代替独立 golden、集成模型、物理路由/STA 或板上显示验收。规格已明确双线动态现象根因尚未确定，不应据本次波形清晰度改变宣称其根因已修复。

源 SHA-256：C11301 `5049B5791895BD78EB147F35CA3DAFB777B4EDCD19AAC1F6B4DADF4EBAD363EF`；C11206 `1378643357A6EF6486577BABFEE8686B8095AC0C7F8B043D427B0DE7614736C4`。
## C11206 源快照逐文件哈希审查与完成阶段快照

审查时间：2026-10-13 08:12:06 UTC（2026-10-13 16:12:06 Asia/Shanghai）。比较范围是 C11206 verified 的 `src/user_source`、`src/td_project/al_ip` 与 C11301 对应目录；按相对路径对所有普通文件计算 SHA-256。

| 范围 | C11206 文件数 | C11301 文件数 | 新增 | 删除 | 哈希不同 |
|---|---:|---:|---:|---:|---:|
| `src/user_source` | 85 | 85 | 0 | 0 | 3 |
| `src/td_project/al_ip` | 3 | 3 | 0 | 0 | 0 |
| 合计 | 88 | 88 | 0 | 0 | 3 |

全部变化文件如下；未列出的85个文件 SHA-256 一致，包括 `src/td_project/al_ip` 下全部3个文件，以及 PLL、HDMI PHY、SDC、ADC、audio、scaler 和 control 相关源文件。

| 文件 | C11206 SHA-256 | C11301 SHA-256 | 审查结论 |
|---|---|---|---|
| `user_source/hdl_source/player_pcm_waveform.v` | `1378643357A6EF6486577BABFEE8686B8095AC0C7F8B043D427B0DE7614736C4` | `5049B5791895BD78EB147F35CA3DAFB777B4EDCD19AAC1F6B4DADF4EBAD363EF` | 预期的波形清晰度修改 |
| `user_source/hdl_source/player_status_monitor.v` | `A5FA8DECBE9997105DF17D13564DFDA0FFF7EFDE53AFD5150134EC62DB78935C` | `B050E855D3586BE1218BE95286BB9DF0798E88E246219A574C9A9414C9E97D0D` | 唯一差异为默认 `BUILD_ID` 从 C11206 改为 C11301 |
| `user_source/hdl_source/top_tf_hdmi_audio.v` | `DB211234F22FBCADCFAC039DC8D81964DC274148719B830D3B076C8D70C91F4C` | `568F17BD6D5429193FDCEC789D305969DE67D8EE0AD5ACD73BBC99D11E2D8A98` | 唯一差异为 status monitor 实例 `BUILD_ID` 从 C11206 改为 C11301 |

因此 top/status 两个文件仅做版本号替换；其余源和 al_ip 文件与 C11206 快照逐字节相同。

完成阶段凭据：`latest_physical.json` 状态 `success`，run `5f404bdd-12c7-4ef3-a0d4-020d7ca88910`；`latest_bitstream.json` 状态 `success`，run `afa581bd-00b1-4475-b884-cacb2a7772f5`。physical route QoR 为 setup WNS +0.615 ns、setup TNS 0、hold WNS +0.019 ns、hold TNS 0、setup/hold violation endpoint 均0，29 RAM、8 DSP；门槛 wrapper 已通过。bitstream 路径为 `build/manual/AC201_player_waveform_fine.bit`，SHA-256 `30C45D0A9B82B9C4F78C5A14A81CEFA13C704AF9C91C34EB4C625974FDAA4B96`。这些凭据确认本地 physical 与 bitstream 成功，不包含板上下载或实机显示验收。


