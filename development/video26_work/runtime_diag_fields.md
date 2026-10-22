# C26 被动诊断字段

此候选只观测 C22 已有控制与数据状态。诊断输出不回接模式选择、SD 控制器或复位控制。`video_mode_press_count` 仅受全局 `rst_all_reg` 清零，媒体重启 `media_reset_active` 时保留；按 `video_mode_press` 脉冲递增并自然模 16 回绕。

- 页 B：`{4'hB, video_mode, key1, key2, adjust_debug_state[15:0], video_mode_press_count[3:0], media_reset_active, rst_all_reg, card_init_done, sys_pll_lock, video_pll_lock}`。
- 页 C：`{4'hC, card_debug_state[15:0], card_init_done, shared_card_read, shared_card_end, shared_card_valid, SD_nCS, SD_DCLK, SD_MOSI, SD_MISO, media_reset_active, rst_all_reg, sys_pll_lock, video_pll_lock}`。
- 页 D：`{4'hD, cmd_index[5:0], expected_r1[7:0], last_r1[7:0], 6'd0}`。`last_r1` 在 `sd_card_cmd` 的 `S_CMD` 状态且 SPI 字节确认时采样，复位值 `8'hFF`；其他 SPI 阶段保持。
- 页 C 的 `card_debug_state` 为 `{sector_state[4:0], command_state[4:0], spi_state[2:0], cmd_req, cmd_req_ack, cmd_req_error}`。
- SD 扇区状态与命令状态均保留完整 5 位，WAIT=17、CMD16=18；已用实际模块端口测试验证。
- 页 0 标识改为 `00C11326`。

`sd_card_cmd_r1_probe_tb.v` 通过强制实际控制器的状态寄存器，对 S_CMD 响应字节、命令数据阶段和读数据阶段做采样与负控。统一执行 `pwsh -NoProfile -File development/video26_work/run_tests.ps1`，通过项目 `scripts/anlu_tools.ps1` 找到工程自带 Icarus；三项实际 HDL 测试均已通过，结果为候选 `verification/runtime_diag_tests.json`。模式计数夹具从真实 top 提取控制块，验证媒体 reset 保持、同模式重播不计数、模16回绕及冷 reset 清零。

每页持续约1秒、完整循环16秒。板上建议录40秒：共同按住双键20秒，再完全松开继续录20秒，以同时覆盖按下、达到阈值和松开后的B页。

源码保真使用 `verify_passive_source.py`：精确删除新增观察代码与还原三页后，121份源码的控制/数据token逐项与C22一致；模式翻转语句被修改的负控可检出。首次重复声明导致的TD分析失败及旧allowlist检查材料保留于候选verification。
