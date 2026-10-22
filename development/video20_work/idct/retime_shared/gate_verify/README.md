# Y 算术门级对比记录

本目录独立综合了共享方案使用的 Y 候选：`OUT_SHIFT=11`、21 位有符号输入在测试台中符号扩展到 32 位。TD 6.2.178840 对 EG4S20BG256 的结果为 803 LUT、335 ripple、848 seq、14 DSP，映射后共有 423 个 LUT；20 ns 约束下报告 SWNS 为 10.058 ns。导出的网表含 14 个真实 `EG_PHY_MULT18` 实例。

使用 TD 安装目录 `sim_release/common` 与 `sim_release/eg4` 的 ModelSim 功能原语模型，完成门级网表和重命名后的原始 Y 参考模块对比。ModelSim SE-64 10.1c 运行 768 笔有效事务，分 3 段，每段之间复位并发出 `img_start`；输入包含随机 21 位全范围值、正负边界与极值，随机 valid gap。门级候选的输出时序提前参考一拍，768 项的 32 位数据与 6 位索引均按序一致，`errors=0`。

复跑：`pwsh -NoProfile -File run_gate_sim.ps1`。隔离综合脚本为 `run_syn.tcl`。综合日志、区域及时序报告、gate 网表、编译/仿真日志、输入 CSV 回执与 SHA-256 清单保存在本目录；`evidence.json` 记录来源文件、模型库、脚本、网表和回执的哈希。

ModelSim 日志包含 TD gate 导出时常见的 pad primitive 端口连接警告；仿真加载了 EG4 pad / I/O / global models 并完整结束，门级输出通过 768 项比较。该验证覆盖孤立 Y 运算块；整机读写重叠时序由共享方案事务仿真及整机回放另行评估。
