# Arch17 双客户端共享 FAT mapper

候选模块为 `candidate.v` 中的 `fat32_dual_file_sector`，当前锁定 SHA-256：

`084B7DC884B1B33E3EBC2804283BC820B0E5A38EB248E7DC14A6303D70F67BFB`

该版本复用单一 mapper FSM、地址运算、扇区接收计数与FAT解析 datapath；BMP/WAV仍保留独立walk、cache标志/identity、arm/busy/queued、错误和timeout上下文。逻辑FAT walk在每个物理sector边界可切换，按旧仲裁规则限制WAV连续最多两个扇区后服务等待的BMP。disable或owner timeout时保持物理扇区归属并drain至`sd_end`，避免后续字节落入新事务。

默认 `REQUEST_STABLE=1`、`WAV_STATIC_FILE=1`，匹配父工程BMP101/WAV111接口契约。接口对照及顶层单参数消融方式见 [integration.md](integration.md)；结构证明与未覆盖边界见 [design_proof.md](design_proof.md)。基线源/候选/测试/面积报告的哈希和结果由 [source_receipt.json](source_receipt.json) 固定。

本地定向Icarus与Verilog-2005语法检查通过；mapper_tests扩展TB和bounded review均针对当前SHA通过，见receipt与 [独立评审记录](../shared_review/review.md)。TD 6.2.1 SP1同wrapper/20 ns/AreaHigh mapper-pair结果：双mapper+arbiter 2029 LUT/642 reg，当前shared 1494 LUT/396 reg，BRAM/DSP均0。精确report、console与actualparams在`td/dual_ref/`和`td/shared/`；B9与6A8E报告分别在`td/shared/attempts/pre_cidle_guard_B9/`、`td/shared/attempts/preaudit_6A8E96FD/`。该对照覆盖mapper pair，完整top资源和时序正在父C11317/A04验证。
