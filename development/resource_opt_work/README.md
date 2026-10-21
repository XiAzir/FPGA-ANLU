# C11313 资源优化实验入口

最终选择A10 AreaOptimizeHigh：8243/9800 Slice=84.11%，Setup+0.101ns、Hold+0.011ns、TNS0。C11313离线候选已封存，实板待测。

- [完整资源、算法、消融与验证报告](<E:/QQ CACHE/Download/安路资料/开发记录/专题记录/资源优化/C11313_20261020/README.md>)
- [最终绑定检查](../player_spectrum_resource_fit/build/final_binding.json)
- [逐阶段消融汇总](../player_spectrum_resource_fit/build/ablation_summary.json)
- [封存清单](../player_spectrum_resource_fit/checkpoints/C11313_resource_fit_20261020_offline/manifest.json)
- [mapper算法与差分入口](mapper_experiment.md)
- [共享BPB ALU负收益](catalog_serial/README.md)
- [AdderChainThresholdHigh独立实验](adder_threshold/README.md)
- [计时器范围与功能消融](timer_verify/timer_public_tb_results.json)
- [计时器全top综合及两轮TD物理崩溃](../player_spectrum_resource_fit/build/attempts/11_timer_exact/experiment_result.json)

代码转换与测试脚本分别保留在本目录；原始交接工具在handoff_tools。prepare.py只用于首次建立隔离候选，finalize_candidate.py仅用于首次合并C11313，均避免重复执行。正式阶段构建入口为候选scripts/build_candidate.ps1；freeze_resource_candidate.py创建单次封存，verify_final_binding.py核验源/仿真/实现/bit/封存SHA，write_resource_report.py从实际证据生成资料报告。
