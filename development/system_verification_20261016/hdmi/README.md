# HDMI 串行输出内容验证

最终入口为 `run_period.py`。它使用冻结版本的加密 HDMI 内核和真实 PHY，从四路串行引脚恢复 TMDS 字、视频区段与音频包。实际内核 clock word 是 `0000011111`；早期随机字 PHY 单元使用相反字，接收器提供显式参数，不能混用。

```powershell
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
python development/system_verification_20261016/hdmi/run_period.py --version C11310 --sequence-audio
python development/system_verification_20261016/hdmi/run_period.py --version C11310 --sequence-audio --case negative_audio
```

正例严格比对第二完整帧307200动态像素；按照视频 preamble 和 guard 划分区段，连续检查每行640像素，不搜索跳过差异。active 码字可能与 TERC/control 码值重叠，不能按码值过滤。变化音频为左右不同的24位序列，已恢复1611对并逐内容/顺序比较，最后1个输入尚在传输尾部；BCH/TERC错误0。视频/音频各翻一位的负例都必须恰好检出一处差异。

上述独立内核结果见上级 `nominal_matrix.json`。它们不等于原TF文件到串行输出的同次整机验证。后者入口：

```powershell
python development/system_verification_20261016/integration/run_system.py --version C11206 --clock-model replay --serial-scoreboard
```

完整top保留真实启动等待、媒体路径及明确的模型假设，完整结果以该次目录的 `summary.json` 为准。输入到引脚像素/音频严格有序比较；冷启动首个完整视频帧明确不计。物理电气、完整 SDF、显示器兼容性不在本模型证明范围。

`run_receiver.ps1` 是早期随机字PHY单元；`run_content.ps1`、`tmds_rgb_decode.v` 及旧探索日志不作为最终内容资格证据。所有新运行使用时间戳目录，失败与被纠正的夹具证据保留。
