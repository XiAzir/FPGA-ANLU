# FAT32 catalog 文件大小暂存复用候选

状态：负收益备选，未合入 C11316。

基线来自 C11316 `fat32_catalog.v`，SHA256 `c73d62f6a4eae3bcedcf60f40ff29898e5c3489655e171d6b373abd670d1151a`。候选 SHA256 `e73dabe9ac8cf76518d64e47190a47adf29f5ae996266ff586554e13403640d0`，diff 在 `candidate.diff`。

实现尝试移除 32 位 `dir_size_b` 数组，让互斥阶段中的 `fat_entry_value` 暂存目录项尺寸。几何1970条逐拍记录、目录528条记录（175项既有用例与新增四BMP选择/WAV用例）均通过。新增场景确认输出保留前4个 BMP 的簇号/尺寸，第5个 BMP 不进入结果，WAV 值正确。

TD 6.2.1_SP1、EG4S20BG256、standalone AreaHigh/AdderThreshold18，两份 source SHA 绑定并由独立进程完成：baseline device LUT/REG/generic LUT=1956/710/1234；candidate=1973/686/1243。变化为 +17 device LUT、−24 REG、+9 generic LUT，面积交换后不选入。完整控制台/actualparams/gate.area 在 `td_area_high/{baseline,candidate}`；Icarus日志在 `build`。具体运行边界与源哈希见同目录 `td_area_high/batch_manifest.json` 与 `build/extended_diff_result.json`。

首次误用 Windows 反斜杠调用 Tcl 文件，TD 将其解释成转义并提示找不到脚本；该次未运行综合。随后用正斜杠路径重新启动，baseline/candidate 均完成并记录 `SYNTHESIS_COMPLETE`。后续独立 scaler 任务的最终实验报告见 `../scaler_lifetime/README.md`。
