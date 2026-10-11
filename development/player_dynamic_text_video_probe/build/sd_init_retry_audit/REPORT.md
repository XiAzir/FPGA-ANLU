# SD 初始化握手失败注入审计

日期：2026-10-09（北京时间）

## 目的与边界

只读核对动态字幕视频 probe 内的 `sd_card_sec_read_write.v`、`sd_card_cmd.v`，用原模块实例验证 `S_ERR → S_END` 后 CMD0/CMD8 重试，以及 CMD41 错误后的 CMD55/ACMD41 路径。未改生产 RTL、工程、bit 或检查点。此仿真只针对握手控制逻辑；SPI 字节传输由 testbench stub 应答，未实例化 SPI PHY，也未模拟真实 SD 卡、电气时序、上板环境。结论不能说明当前 HDMI 无信号由 SD 握手问题引起。

## 源码静态证据

- `sd_card_sec_read_write.v:88-128`：CMD0/CMD8/CMD55 只有 `cmd_req_ack & ~cmd_req_error` 才推进并清 `cmd_req`；错误 ack 会落入 `else`，保持请求为 1 并持续驱动当前命令。
- `sd_card_sec_read_write.v:133-151`：CMD41 遇到 ack+error 时进入 CMD55 分支，没有清 `cmd_req`；之后 CMD55 成功进入 CMD41。
- `sd_card_cmd.v:53`：`cmd_req_ack` 等于 `(state == S_END)`。
- `sd_card_cmd.v:322-329`：`S_ERR` 下一拍进入 `S_END` 并置错误；`S_END` 与其它结束态下一拍无条件回 `S_WAIT`。所以 ack 是单周期，不等待请求撤销。`S_WAIT` 清除错误并可因持续为高的请求再接收命令。

## 仿真方法与结果

使用 Icarus Verilog 12.0 (devel)，`run.ps1` 编译实际 probe 源码中的 `sd_card_sec_read_write.v`、`sd_card_cmd.v` 和本目录 testbench。SPI stub 捕获实际 MOSI 命令字节序列，在 command byte index 6 返回期望 R1；失败场景只把首次指定命令的 R1 改为 `8'h04`（bit7=0 且与期望值不等），产生 DUT 的真实 `S_ERR` 路径。未人为驱动 cmd_req_ack。

| 场景 | 关键观测 | 结果 |
| --- | --- | --- |
| 成功基线 | CMD0/8/55/41/16 各 1 次 | PASS，进入 `WAIT_READ_WRITE` |
| CMD0 非法 R1 一次 | `S_ERR`，下一拍 `S_END ack=1 error=1 req=1`；随后 CMD0 第二次并成功 | PASS |
| CMD8 非法 R1 一次 | 同样的错误 ack；随后 CMD8 第二次并成功 | PASS |
| CMD41 非法 R1 一次 | 错误 ack 后先 CMD55，再 CMD41 第二次并成功 | PASS |

完整 stdout 位于 `baseline.log`、`cmd0_illegal_r1_once.log`、`cmd8_illegal_r1_once.log`、`cmd41_illegal_r1_once.log`；编译输出为 `compile.log`。可用 `pwsh -NoProfile -ExecutionPolicy Bypass -File run.ps1` 重跑。

## 结论

本模型中，单次 CMD0/CMD8 非法 R1 不会令初始化永久停留；请求保持高电平配合 `S_END→S_WAIT`，触发同一命令重发。CMD41 非法 R1 路径则经过 CMD55 后重发 CMD41。该行为也意味着持续无效 R1 时会反复发命令，没有由这些状态机提供的失败上限/外部退出策略；本轮没有评估这种持续失败策略。以上只排除“单次错误必然因 req 未撤销而卡死”的状态机假设，不能外推真实卡、SPI PHY 或本次硬件黑屏根因。

## SHA-256

- `src/user_source/hdl_source/SD/sd_card_sec_read_write.v`：`C245C07E3B0056808D86E06AAD74348494E2A7050D493A3D4141D97CCF115203`
- `src/user_source/hdl_source/SD/sd_card_cmd.v`：`A1A50502AFD4E8B238B0627CD5F204C04738E761D49AB48F33DA35E22BA4A5FA`
- `tb_sd_init_retry.v`：`3822939457A1D41868EB7B2FEF89BCC97616CC600AD3EB91CCA66CBCC22EFC6F`
- `run.ps1`：`6B3CB9AACDA0F5A65F3B2942F613FE2BEE28923DE85C82F621949E2683FFEE76`

