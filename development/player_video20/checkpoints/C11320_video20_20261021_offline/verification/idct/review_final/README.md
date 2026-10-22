# 共享 IDCT v3 读写相位与提前读负控审查

审查范围是共享 v3 wrapper、提前读 transpose、retime + DSP Y 核与现有 `tb_shared.sv`。所有负控副本、日志和审查记录仅写在本目录；审查前后共享源、candidate Y、事务 TB 和 run script 的 SHA256 相同，记录见 [source_hashes.json](source_hashes.json) 与 [source_integrity_after.json](source_integrity_after.json)。

## 相位与槽位复核

共享 wrapper 分别跟踪输入相位 `input_y_q` 和算术核输出相位 `y_pass_q`。`input_y_q` 在已接受的64个输入beat后切换来源，`y_pass_q` 在算术核输出 `core_valid && core_idx==63` 后切换输出方向。`x_reserved_q`在X数据开始进入共享核时保留下一次X槽位，在Y输入相位结束时释放；Y beat62启动外部IDCT RAM读，使其两拍启动状态机在Y beat63结束时到达ACTIVE。phase trace记录Y beat62的 `x_launch=1`，下一拍为Y beat63，随后下一周期 `x_idx=0` 被共享核接受；未出现X首beat丢失。记录见 [phase_trace/run.log](phase_trace/run.log)。

Transpose有两个bank，读写指针独立翻转。写侧按X结果索引在4个RAM bank写入；读侧在完整Y输入burst期间连续取64个word。`block_ready_q`提前标记当前写bank，使读状态机能预启动；索引63的普通完成标记仍会置位，读完64个word后释放读bank并切换读指针。wrapper只在受控的X/Y phase和已预留的槽位中驱动这些burst；共享 v3事务 TB 同时检查首读数据已写入，并比较所有块的输出序列。

相同 `tb_shared.sv` 正控（阈值54）处理48块/3072样本，输出data/index/id逐项匹配，16,300次读安全检查通过。日志见 [positive54/run.log](positive54/run.log)。

## 53阈值负控与紧邻安全余量

只在 [negative53/frozen/jpeg_idct_transpose_early.v](negative53/frozen/jpeg_idct_transpose_early.v) 的本地副本把 early-ready 输入索引从54改成53，其他模块和 TB 与正控相同。负控按预期在 bank3/address8 首次读未写入数据时 fatal，证明 TB 的写掩码能够捕获一拍过早的启动；原始共享源始终保留54。

trace给出的相对周期关系：

| early-ready门槛 | input索引事件 | 首次bank3/address8读 | 结果 |
| --- | --- | --- | --- |
| 53 | idx53 在 cycle159 置ready；idx56 在cycle162写bank3地址8 | cycle162 active读地址8，与idx56写同沿；掩码检查用沿前状态 | `READ_BEFORE_X_WRITE bank=3 addr=8` |
| 54 | idx54 在cycle10008置ready；idx56 在cycle10010写bank3地址8 | cycle10011 active读地址8 | 写入比读早一个完整20 ns时钟周期，安全 |

阈值54因此是这条固定非停顿burst路径的紧邻安全门槛；阈值53提前一拍会让read到达bank3/address8与它的写入同沿。降低阈值只会让ready更早，状态机首读可保持或提前，不能消除这项冲突。相关轨迹见 [negative53_trace/run.log](negative53_trace/run.log) 与 [positive54_trace/run.log](positive54_trace/run.log)；测试汇总见 [negative_control_result.json](negative_control_result.json)。

## 位型语义与新增逻辑审查

共享Y核用 `OUT_SHIFT=11` 复算原X核；X结果经21-bit transpose RAM保存并符号扩展。原Y的 `>>>15` 与共享输出的 `>>>11` 再由wrapper执行的 signed32 `>>>4` 等价，因为对任意32-bit二补数位型，连续的算术右移11位、4位与一次右移15位结果完全相同。求和、差分仍在原32-bit模2^32运算域；181常数DSP结果保留低32位，signed `/256`仍执行原有向零截断。没有裁剪、饱和、舍入或输入值范围分支。

增量控制只负责共享X/Y计算核的输入相位、输出相位、burst槽位预约和transpose提前读阈值；没有添加数据防御路径。Y retime 保留 `mul*_q` DSP输出寄存器和 butterfly 结果寄存器，删除 `mul*_q -> mul*` 的重复寄存拍，valid/index流水同步提前一拍。父D02读取本候选时仍需沿用顶层已有的 `rst_i || img_start_i` flush，并维持64-beat非停顿传输约束。

## 复跑结果

`python run_review.py` 会复制 reference、共享candidate和TB到各自冻结目录；positive54必须通过，negative53必须以 `READ_BEFORE_X_WRITE` 失败。用于负控的 module threshold改动仅在 `negative53/frozen/`。轨迹补充脚本 `trace_negative53.py`、`trace_positive54.py`、`trace_phases.py` 同样只在本目录操作。

## 当前组合 Y 源码对应复核

追加复核时，当前 `player_video20/src/user_source/hdl_source/jpeg/jpeg_idct_y.v` 与 `gate_verify/src_v/jpeg_idct_y.v` 的 SHA-256 完全相同；二者也与 `td/retime_dsp/src_v/jpeg_idct_y.v` 完全相同。因此门级验证覆盖的是当前组合中的同一 Y 源文件。哈希及阈值副本身份记录在 [current_composition_check.json](current_composition_check.json)。阈值54正控通过，阈值53副本在 `READ_BEFORE_X_WRITE bank=3 addr=8` 触发预期fatal；父共享源保持54。
