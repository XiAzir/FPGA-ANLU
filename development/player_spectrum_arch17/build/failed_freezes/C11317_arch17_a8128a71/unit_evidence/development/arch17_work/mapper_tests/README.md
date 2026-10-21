# 双 FAT mapper 共享重构验证

## 目的与端口

本目录冻结 C11316 双 mapper + `sd_sector_arbiter` 的可观察契约，并提供同端口 reference wrapper 与 transaction-based TB。DUT 端口按 `fat32_dual_file_sector` 草案定义：BMP/WAV 分别有独立配置、请求、数据和错误口，共用单一物理卡口。参考 wrapper 使用两份原 mapper 与原 arbiter。运行脚本可将同一 TB 切换到 reference 或 shared candidate。

## RTL 调用契约

- 每客户端独立 `file_read` arm：空闲阶段需先采到低电平，再接收一次高电平；接受后需重新拉低才能再次请求。
- 每个客户端保留自己的请求快照、FAT walk、Brent 检环状态和文件 sector cache。请求中途文件身份变化或 seek 时，结果须对应当次请求；同文件前向 seek允许从已缓存簇继续，回退从有效链位置恢复。
- 每个 FAT 读取消耗完整 512 个 `sd_valid` 字节；短 sector、无响应超时归属当前客户端。成功 data sector 输出 512 个 `file_valid` 字节，随后 `file_end` 单周期拉高。
- 失败时 `file_end` 单周期拉高并保持 `error/error_code`。旧错误码：范围 `01`、几何 `02`、簇范围 `03`、地址溢出 `04`、短读 `05`、坏 FAT `06`、EOC `07`、Brent 环 `08`、4096-cluster 上限 `09`、timeout `0a`。
- `enable=0` 清除该客户端运行状态、arm 与 cache；错误保持 sticky，异步 reset 清除。物理扇区已被 arbiter/card 接管时，mapper disable 不自动撤回物理 transaction；之后返回的数据仍应归于旧 owner，或由 reset 统一中止后再接收新事务。
- 旧 arbiter 仅在物理 `card_end` 边界释放 owner，随后空 2 拍。WAV 有请求时优先；BMP 同时 pending 时，最多连续服务 2 个 WAV 物理扇区，然后给 BMP 机会。物理 FAT 与 data sector 都是调度边界。
- 两个旧 mapper 各自运行 no-valid watchdog：等待对端物理 owner期间也会计时。共享实现暂停非活动客户端 watchdog 会改变 `E_TIMEOUT` 归属；双客户端均 pending 且 card 永不 valid/end 时，两边都应独立报 `0a`。
- 真实集成默认 `WAIT_LIMIT=50000000`。TB 用 `WAIT_LIMIT=3000`，容纳一个 WAV FAT+data 的调度等待；专门挂卡用例等待超过该限值验证独立 timeout。

## Transaction 回归

`tb_dual_mapper_transactions.v` 并发启动 BMP sector 4095（4096-cluster 连续链）与运行中到达的 WAV sector 0；随后 WAV 请求 sector 1，触发独立 WAV context 的 cache 延续及一笔 FAT walk。Scoreboard 验证 BMP 4095 笔 FAT 交易的 LBA 顺序、最终 data LBA、各客户端逐 byte payload、物理事务数和 WAV 连续服务上限。这个并发长链场景是主验收项，顺序单请求覆盖无法替代它。

其余工作负载包括 disable/等待原物理 sector 排空/re-arm、不同 BMP 文件身份与 seek、坏 FAT、EOC、环、短读、timeout、两个客户端同时 pending 时 card 挂起、sector 中 reset 后分别重新发起两客户端请求。Reference 与 candidate 允许几拍调度时序差异，检查每客户端数据顺序、完成、错误归属/分类和物理 FAT/data 地址。

## Reference 与 candidate 结果

环境：Windows PowerShell 7、随工程提供的 Icarus Verilog `bringup/tf_wav_hdmi/tools/iverilog/app/bin`；无 TD 编译或硬件验证。TB 使用 `WAIT_LIMIT=3000` 以容纳最长两笔 WAV 扇区服务等待；挂卡用例超过此值，验证双方 watchdog。共享 core 专用回归用真实 BMP/WAV 同拍请求建立双 pending，只将 BMP wait_count deposit 到2999，检查其 timeout 与 WAV 同拍 dispatch 后的事务继续完成。

- Reference：PASS，4100 笔物理交易。主并发为 BMP 4095 FAT hops + 初始 cluster 2 到目标 cluster 4097 + data；再对同一 sector 做一次 cache hit 重读。WAV sector 0 后 seek 到 sector 1，触发 WAV 1 FAT + 2 data。BMP payload 共 2048 B（主场景两次512B + 两次小文件切换各512B），WAV payload 1024 B；主场景观测最大连续 WAV sector 为 1。
- Shared candidate：PASS，同一 4100 笔交易、payload、walk 和切换结果；主场景最大连续 WAV sector 为 2，符合旧 arbiter 的上限。新增 BMP watchdog 到期与 WAV dispatch 同拍回归通过，WAV transaction继续完成、BMP报E_TIMEOUT。测试时源码 SHA 为 `084B7DC884B1B33E3EBC2804283BC820B0E5A38EB248E7DC14A6303D70F67BFB`。
- 双方均通过 disable/re-arm、BMP文件切换/seek payload、bad FAT/EOC/loop/short、挂卡单/双客户端 timeout、in-flight reset后重新读，以及 FAT/data 最后一个 byte 与 `sd_end` 同拍时的 E_SHORT 分类。
- 早期 WAIT_LIMIT=20 试跑发生 WAV watchdog timeout；参数短于 card sector 完整传输及排队等待。WAIT_LIMIT=1000 试跑中 candidate 两笔 WAV service 会让 pending BMP watchdog 到期。最终共用配置设为3000，reference 与冻结 candidate 均通过；早期reference失败日志保存在 `attempts/`。

执行：

```powershell
pwsh -File .\run_mapper_tests.ps1
pwsh -File .\run_mapper_tests.ps1 -DutModule fat32_dual_file_sector -DutSource ..\shared_mapper\candidate.v
```

脚本默认解析工程内 Icarus 路径；也可用 `-Iverilog`、`-Vvp` 指定二进制。编译与运行日志及 `.vvp` 保存在本目录，日志文件以模块名区分。
## 冻结来源 SHA256

- `fat32_file_sector_reference.v`（来自 C11316 opt16 mapper）：`DF0C358C07806E09E113FE8DB863467AFEBB79430D55003269A25D8D418BF897`
- `sd_sector_arbiter_reference.v`（来自 C11316 opt16 arbiter）：`FC0833681CC67BFE92AAB7BECCADB8F8D00A5B7946359588DC1B72B3A17BA8E6`
- `fat32_dual_file_sector_ref.v`：`5D0891278651CED18ED6CD791CAFB1772F7DD9B3755EE02491884DB29F8A1E03`
- `tb_dual_mapper_transactions.v`（最终 reference/candidate 共用版）：`ED2600991A9DA59BDC45D084FFEC068E2C560919D1A674430FB79834A7B613A7`
- `shared_mapper/candidate.v` 与 `candidate_as_tested.v`（测试时）：`084B7DC884B1B33E3EBC2804283BC820B0E5A38EB248E7DC14A6303D70F67BFB`

Candidate 测试输入来自 `shared_mapper/candidate.v`；测试时源码副本保存在 `candidate_as_tested.v`。Reference log：`fat32_dual_file_sector_ref.run.log`；candidate log：`fat32_dual_file_sector.run.log`。`attempts/waitlimit20_reference_failed.log` 保留早期试跑：错误将 WAIT_LIMIT 设为 20，WAV 在 BMP 持有物理 sector 时触发独立 watchdog；该参数短于单个512B传输所需等待，已修正测试配置后复跑通过。另一次 WAIT_LIMIT=1000 的candidate试跑让BMP在两笔WAV服务期间超时；通过值3000后，reference与candidate均PASS。完整 TB SHA 与来源 SHA 用于核对运行输入。




