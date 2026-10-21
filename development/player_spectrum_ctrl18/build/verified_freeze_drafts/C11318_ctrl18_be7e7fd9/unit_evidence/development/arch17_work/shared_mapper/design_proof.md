# 结构变更与资源证明

## 共享结构

参考实现由 `fat32_file_sector` 两实例组成，双方各持有 mapper 状态机、地址运算、512-byte计数、超时计数、Brent/caching状态；之后由 `sd_sector_arbiter` 选择一条实际卡事务。候选模块改为一个控制 FSM 和一个选中客户端运算/扇区缓冲通路；BMP/WAV各保留 walk/cache有效/身份/arm/busy/queued/error上下文。唯一物理接口直接进入卡侧，沿用原 arbiter 的二扇区 WAV burst 限制。

共享核心在 `C_IDLE` 以既有仲裁规则选取客户端；`C_SETUP/C_DISPATCH` 计算下一个物理扇区；`C_FAT_WAIT/C_DATA_WAIT` 复用同一512字节接收计数器及FAT字节暂存；`C_GAP/C_FAT_EVAL`完成链表更新。FAT sector结束后保留client walk上下文并重新入队，因此长链每扇区都能让出服务。

## 状态生命周期复用

cache中的簇/索引/Brent状态仅在后续逻辑请求初始化时读取。候选以 `cache_cluster=current_cluster`、`cache_index=target_index`、`cache_brent*=brent_*` 的 wire alias复用寄存器。启动新请求的同一个时钟边沿先以旧值判断cache可续走，再写新target；cache hit从保留值继续，cache miss覆盖为start cluster/初始Brent状态。请求处于busy期间只读活动walk状态；成功data sector仅更新cache valid与BMP identity tags。候选不另建每client cache数据bank。

生产参数默认消除 BMP/WAV 请求字段快照，匹配已验证的 REQUEST_STABLE/STATIC_FILE 使用方式。关闭参数可退回字段快照模式。WAV静态文件在enable期间使用实时描述符，但身份比较省略，与原STATIC_FILE实例一致。

## 故障和禁用行为

两路 `wait_count` 独立：queued client在peer占卡期间仍计数，当前owner在收到自己的`sd_valid`/`sd_end`后清零。达到原`WAIT_LIMIT`时只置对应client的sticky timeout与`file_end`；watchdog结果在共享FSM更新后生效，确保同拍不会从C_DISPATCH再发新物理请求。若owner正在物理扇区中，控制状态进入`C_DRAIN`并保持物理读直到`sd_end`，丢弃后续数据；另一queued client持续计时。disable清该client计数和映射上下文、保留sticky错误；若active owner仍在卡侧传输，同样进入`C_DRAIN`。同owner的新请求在drain期间不接收，低电平可arm，高电平保持至扇区排空后再接受。

`C_IDLE`存在参数边界上的 timeout 调度竞争：active_client仍保留上一owner时，BMP自身队列到期可与本拍WAV优先派发重合。watchdog仅在该client确实拥有本拍非`C_IDLE`引擎工作时接管核心状态；若旧状态为`C_IDLE`，它只撤销超时client的队列，保留新派发。

## 已覆盖及尚未验证

- `tb_fat32_dual_file_sector.v`：双请求并发、WAV目标索引2的两级FAT链、最多两个WAV扇区后BMP插队、两个不同data地址的512-byte完整流。PASS。
- `tb_fat32_dual_timeout.v`：无valid/end条件下owner与queued peer均分别timeout、sticky code为`0x0a`、reset清错并释放sd_read。PASS。
- `tb_fat32_dual_disable_drain.v`：物理data sector中disable、重新enable并arm新请求；旧payload被丢弃，新请求等旧`sd_end`后完成512字节。PASS。
- `tb_fat32_sd_end_edge.v`：与旧mapper对比`sd_valid && sd_end`在计数511和512同拍的行为；两边均生成E_SHORT，PASS。
- `tb_cidle_peer_timeout_race.v`：两请求从arm/read接口自然建立，只将BMP wait_count推进至门限；旧实现复现WAV busy且无queue，修正后BMP报timeout且WAV启动物理读，PASS。
- `tb_cidle_timeout_natural.v`：同时发起两请求，以WAIT_LIMIT=1和2运行旧/修复版本；无卡响应时两client都超时，未观察到orphan。这个自然低门限结果不证明默认50M在所有事务节奏下不可达。
- mapper_tests独立extended TB在当前冻结SHA下报告完整PASS：BMP 4095-hop并发、同sector cache hit与换文件/seek payload、WAV sector0→1 cache continuation、disable/re-arm、bad FAT/EOC/loop/short、挂卡双pending timeout、reset abort/re-arm、FAT/data末byte与sd_end同拍E_SHORT、WAV streak上限。
- 独立review在084上复核同一竞态：B9快照复现orphan，084继续到`C_DATA_WAIT`并发起LBA 100；此前drain、数据边界和cache审查无新增问题。
- 参数化请求快照off模式与全边界错误码枚举尚未由当前冻结候选单独覆盖；独立mapper-pair AreaHigh已通过，完整top AreaHigh、布局布线与时序仍在父C11317/A03验证。

## AreaHigh综合

TD 6.2.1 SP1独立mapper-pair综合已通过，同wrapper、20 ns时钟和AreaHigh参数：双mapper+原arbiter为2029 LUT/642 reg；当前冻结共享候选084（SHA末段`…F67BFB`）为1494 LUT/396 reg，减少535 LUT/246 reg；双方BRAM/DSP均为0。console与`gate.area`见`td/dual_ref/`和`td/shared/`；B9和6A8E前次报告分别保留在`td/shared/attempts/pre_cidle_guard_B9/`与`td/shared/attempts/preaudit_6A8E96FD/`。该mapper-pair结果不代表完整top、布线或时序。
