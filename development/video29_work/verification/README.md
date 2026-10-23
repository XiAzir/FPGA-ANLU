# C27 → C29 被动观测差异核查

## 运行

在工程根目录运行：

```powershell
python development/video29_work/verification/check_passive_delta.py
```

脚本逐文件记录 C27 与 C29 的 SHA-256；仅允许下列五个既有源文件发生变化：

- `hdl_source/top_tf_hdmi_audio.v`
- `hdl_source/frame_buffer_rgb888.v`
- `hdl_source/SD/frame_read_write.v`
- `hdl_source/SD/frame_fifo_read.v`
- `hdl_source/player_compact_status_pages.v`

另一个候选新增文件是 `hdl_source/player_memory_runtime_probe.v`。JSON 记录新增文件哈希、全部输入文件哈希、精确差异清单、五个完整 unified diff、版本和页映射。

## 等价性范围

对 top 只移除精确列出的 memory/packet 观测 wire、frame-buffer 诊断连接、`// Passive board diagnostics...` 标记下的状态采样/页映射/观测实例，以及数码管显示实例。对三个存储层文件只剥离 C29 新增的 debug 输出声明、assign 和层级连接。删除或新增的控制语句不会被通用规则忽略，剩余代码去注释和空白后逐 token 比较。`player_compact_status_pages.v` 按只读诊断显示模块整体审阅，保留完整源 diff 与页映射。

负控在 C29 top 里将 `assign sd_card_write_en=video_mode_sd ? ...` 的单个布尔选择位反相为 `!video_mode_sd`；经相同观察代码剥离后，脚本必须检测到控制 token 改变，否则失败。

## 当前结果

`passive_delta.json` 状态为 PASS：121 个基线文件中 116 个字节相同，只有上述五个源文件变化；C29 新增一个 probe 文件，没有缺失文件。单比特负控被检出。报告保留 C27 页版本 `00C11327`、C29 页版本 `00C11329`，格式器映射和 top 的实际页输入。

memory observer Icarus compile/run 原始日志在 [memory_monitor/iverilog_pass.log](../memory_monitor/iverilog_pass.log)。测试通过 session 计数、每会话写旗标清零、输出门控泄漏负控和复位断言。
