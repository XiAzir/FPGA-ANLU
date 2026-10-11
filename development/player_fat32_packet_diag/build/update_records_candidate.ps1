$ErrorActionPreference='Stop'
$taskRoot='E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag'
$taskRecords='E:/QQ CACHE/Download/安路资料/开发记录'
$taskInfo=Get-Content -Raw -LiteralPath "$taskRoot/build/manual/AC201_player_fat32_packet_diag.info.json" | ConvertFrom-Json
if((Get-FileHash -LiteralPath $taskInfo.bitstream).Hash -ne $taskInfo.sha256) {throw 'Bitstream mismatch'}
$taskCheckpoint="$taskRoot/checkpoints/packet_diag_20261008_candidate"
$taskManifest=@(Get-Content -Raw -LiteralPath "$taskCheckpoint/manifest.json" | ConvertFrom-Json)
foreach($taskEntry in $taskManifest) {if((Get-FileHash -LiteralPath (Join-Path $taskCheckpoint $taskEntry.path)).Hash -ne $taskEntry.sha256) {throw 'Checkpoint mismatch'}}
$taskStamp=[TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::UtcNow,'China Standard Time')
$taskDate=$taskStamp.ToString('yyyy-MM-dd')
$taskClock=$taskStamp.ToString('HH:mm')
$taskSummary=@'
**包诊断packet_diag候选已完成模型、原约束STA、bitgen及310文件检查点，尚未上板。47项包断言/独立BCH向量PASS；69个基线user源未变，仅top/显示修改并新增包观察器，原IP/PLL/PHY/ADC/SDC/595/播放源码不改。在线逐位校验减小容量后，从placed DB将含sdr_t与addr16的一个MSLICE由grid(2,24)实际移到(17,36)，重新route/fix_hold后SWNS0.102/HWNS0.027ns、TNS均0、coverage99.97%。候选SHA256 C2B3DEAFB78355C124CE8958015EED31CEBA38CD4B0B41D9179A7190E4200818，629624字节。旧211文件未完成检查点及全部失败尝试保留。这是观测候选，旧杂音根因及修复仍未证实；下一步用户下载后比较默认WAV/长按内部tone声音并记录九页包数据。**

第二视频证据保留：status_diag内部模式B、48000 audio_valid/名义秒，PCM变化与DDS模型吻合；默认WAV/内部tone均仍沙沙（用户反馈）。计数不能证明逐样本/包/PHY正确，两视频是否同一连续运行未确认。现已具备包观测位流，不需继续录旧status_diag。
'@
$taskStatePath=Join-Path $taskRecords '当前状态.md'
$taskState=Get-Content -Raw -LiteralPath $taskStatePath
$taskState=[regex]::Replace($taskState,'更新：[^。]+（北京时间）','更新：'+$taskStamp.ToString('yyyy-MM-dd HH:mm:ss')+'（北京时间）',1)
$taskState=[regex]::Replace($taskState,'\*\*第二视频分析完成：[^\r\n]+\*\*',$taskSummary,1)
$taskNext=@'
3. 新包观测工程`development/player_fat32_packet_diag`当前候选已生成、未上板：`build/manual/AC201_player_fat32_packet_diag.bit`，629624字节，SHA256 `C2B3DEAFB78355C124CE8958015EED31CEBA38CD4B0B41D9179A7190E4200818`。九页1/3/6/7/8/9/A/B/C，每页2秒；页6包内样本数/7音频包数/8坏BCH/9非法TERC/A内部tone幅值异常/B CTS/C N。在线载荷校验模型47项PASS；默认及种子2/3仍setup失败，原placed DB局部move实际成功后重新route/fix_hold通过：SWNS0.102/STNS0/HWNS0.027/HTNS0ns；99.97% coverage，16789LUT/8028reg/18206LE/19BRAM9K/0DSP/2GCLK。选用DB来源和hash在`build/manual/selected_physical.info.json`，310文件candidate检查点manifest复核一致；旧211文件incomplete检查点冻结，旧阶段元数据改名`build/historical_incomplete_1912.info.json`。无额外时序例外/放宽/PLL改动；新布局时序通过不能解释旧杂音根因。用户下一步保持原卡/接线/音量，下载后等5秒录默认模式数码管和声音25秒；长按KEY1约2秒至D3闪，松开等3秒再录25秒。详见[包诊断上板步骤](专题记录/FAT32文件播放/packet_diag上板步骤_20261008.md)。
'@
$taskState=[regex]::Replace($taskState,'(?m)^3\. 新包观测工程[^\r\n]+',$taskNext,1)
$taskState | Set-Content -LiteralPath $taskStatePath -Encoding utf8
$taskBoard=@'
# HDMI 包诊断候选上板步骤

日期：2026-10-08；状态：构建/模型/原约束时序通过，实板未验证。这是定位杂音的观测版本，尚未证明修复。

## 下载与观察

1. 使用 BitWriter 按原方法 PROGRAM_SRAM 下载：
   `E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/build/manual/AC201_player_fat32_packet_diag.bit`。
   保持原TF卡、供电、HDMI和音量；无须改卡文件。
2. 下载成功后等5秒。确认图片能显示，KEY0点按能切图，并听默认WAV是否仍沙沙。
3. 对着数码管连续录25秒，带上声音。每页显示2秒，一轮18秒，数字均为十六进制。
4. 长按KEY1约2秒，看到D3闪烁后松开。松开后等至少3秒，再录25秒数码管与内部音阶声音。

可以录成同一个视频。重点是拍清8位数码管；画面和声音若与旧版不同，一并描述。
KEY1短按开关自动切图；长按切音源也会触发一次自动切图开关，这是沿用的诊断行为。

## 数码管怎样看

上电前2秒01234567、后2秒88888888用于段码自检，随后依次轮换1、3、6、7、8、9、A、B、C页。

| 页 | 观察内容 | 当前素材的预期或判读 |
| --- | --- | --- |
| 1 | 启动与文件状态 | 正常为1dA80000 |
| 3 | 送入HDMI核的有效音频样本数 | 默认3300BB80，内部音阶3B00BB80；BB80=48000 |
| 6 | 正确音频包内的样本数 | 后六位约00BB80，包跨秒边界可有少量变化 |
| 7 | 正确音频包数 | 每包4样本时约002EE0=12000；实际按包内present分组，不仅凭12000判错 |
| 8 | 每秒坏BCH包数 | 期望后六位000000 |
| 9 | 每秒非法TERC/guard事件数 | 期望后六位000000 |
| A | 内部音阶的异常幅值样本对 | 稳定内部模式期望后六位000000；默认WAV模式不检查幅值 |
| B | 最近ACR CTS | 期望后六位0061A8=25000 |
| C | 最近ACR N | 期望后六位001800=6144 |

6到C页的第二位为包观察标志，通常E表示岛/音频/ACR均观察到且未记录格式异常；
F表示格式异常曾发生，并不证明仍在发生。若全0也需检查监测位序/对齐假设，不能直接认定核心没发包。
计数均是名义25MHz的一秒窗口，物理频率未测。计数饱和上限00FFFF。

## 版本与证据

- 位流629624字节；SHA256 `C2B3DEAFB78355C124CE8958015EED31CEBA38CD4B0B41D9179A7190E4200818`。
- 47项包定向断言及独立反射BCH向量PASS；九页与595显示模型PASS，显示相关源码/testbench与上一冻结检查点hash相同。
- 原约束final：SWNS0.102/HWNS0.027ns，STNS/HTNS均0；coverage99.97%。原播放/IP/PLL/PHY/ADC/SDC/595源码不变；观察器及局部物理位置会改变实现。
- 选用DB来自`build/attempt_streaming_move_x17y36`，310文件检查点`checkpoints/packet_diag_20261008_candidate`哈希复核一致；旧未完成检查点和失败DB保留。
- 仍未检查逐样本完整顺序、IEC parity/V/U/C、Audio InfoFrame/AVMUTE、差分PHY和接收器；原加密IP/宏位置/IO延迟告警边界保留。模型/STA通过不能替代板测或直接确定杂音原因。

已验证的回退文件仍是：
`E:/VSCODE-project/FPGA-ANLU/development/player_fat32_audio_probe/build/manual/AC201_player_fat32_audio_probe.bit`。
其默认WAV和KEY1内部音阶曾由用户同条件回载确认均干净；助手本轮未操作板卡或读写卡/Flash。
'@
$taskTopic=Join-Path $taskRecords '专题记录/FAT32文件播放'
$taskBoard | Set-Content -LiteralPath (Join-Path $taskTopic 'packet_diag上板步骤_20261008.md') -Encoding utf8
$taskLog=@'

### {CLOCK}｜HDMI包诊断候选生成与封存｜构建已完成，实板未完成

- 动作：在线载荷校验精简后同源默认/seed2/seed3依旧setup失败（-0.411/-0.265/-0.462ns）。TD官方help及425个grid只读占用查询后，用move_cells普通规范fullname参数实际将含sdr_t与addr16的一个MSLICE由(2,24)移到(17,36)，日志报告1个成功且前后属性一致；最初list/regexp/collection匹配和无slot尝试均独立保存，不计成功。
- 验证：移动后原约束常规route/fix_hold通过，SWNS0.102/STNS0/HWNS0.027/HTNS0ns、coverage99.97%；SDRAM输出组SWNS0.448ns，最差setup转到50MHz文件/音频逻辑。16789LUT/8028reg/18206LE/19BRAM9K/0DSP/2GCLK。47项包模型及独立BCH向量PASS；九页/595相关源与原PASS的冻结源hash一致。69个status_diag基线user源不变，仅top/显示2变及新增包观察器1源，原播放/IP/PLL/PHY/ADC/SDC/595源保持。
- 产物：`development/player_fat32_packet_diag/build/manual/AC201_player_fat32_packet_diag.bit`，629624字节，SHA256 C2B3DEAFB78355C124CE8958015EED31CEBA38CD4B0B41D9179A7190E4200818。选用路线DB与来源hash在selected_physical.info.json，bit从该DB生成。310文件candidate检查点manifest逐项复核一致；旧211文件incomplete检查点不覆盖，旧live阶段元数据改名historical_incomplete_1912.info.json。失败default manual/seed/局部move/查询均保存。
- 未完成/边界：尚未用户上板；观察器会改变实现，未证实旧杂音机制/修复。原IP宏位置、undriven、IO delay缺项、未实测频率等边界保留。无新falsepath/放宽/PLL改动，无卡/Flash写入，无代理板操作；没有后台构建。
- 下一步：按packet_diag上板步骤下载，等5秒录默认WAV数码管/声音25秒；长KEY1约2秒见D3闪、松开等3秒再录内部tone25秒，判读页6/7/8/9/A/B/C真实包结果。成功audio_probe回退保留。
'@
$taskLog.Replace('{CLOCK}',$taskClock) | Add-Content -LiteralPath (Join-Path $taskRecords "工作日志/$taskDate.md") -Encoding utf8
$taskDetail=@'

## {CLOCK}｜包观测候选可下载（实板pending）

在线ACR/tone校验保留九页和47项模型覆盖，综合少530LUT/153reg。默认与seed2/3仍有SDRAM控制到PADts setup违例；它是本观测工程构建阻碍，不能解释旧杂音。TD只读命令/占用查询后，普通fullname字符串move_cells成功将含sdr_t与addr16的MSLICE由(2,24)移到(17,36)，重新route和原约束fix_hold通过，final SWNS0.102/HWNS0.027/TNS0ns、coverage99.97%，16789LUT/8028reg/18206LE/19BRAM9K。

位流`player_fat32_packet_diag/build/manual/AC201_player_fat32_packet_diag.bit`已生成，629624字节，SHA256 C2B3DEAFB78355C124CE8958015EED31CEBA38CD4B0B41D9179A7190E4200818；选用DB SHA256 30FD59F47628FEC376F5E011961AE72295E51254BB58EC979DF66B2E49B0D10E。310文件candidate检查点hash逐项一致；旧211文件incomplete冻结以及全部失败DB不覆盖。观察器对核心输出被动旁接；69个原user源不变，原SDC/PLL/引脚保持，未新增时序例外或放宽。

本阶段无助手硬件操作/卡/Flash写入。实板包结果与旧杂音根因仍待用户反馈；下一步见[下载与九页判读](packet_diag上板步骤_20261008.md)，无需重复录旧status_diag。原加密IP/宏位置/IO delay/频率边界和包分析未覆盖项均保留。
'@
$taskDetail.Replace('{CLOCK}',$taskClock) | Add-Content -LiteralPath (Join-Path $taskTopic 'keepaudio黑屏诊断_20261008.md') -Encoding utf8
$taskIndex=Join-Path $taskTopic 'README.md'
$taskIndexText=Get-Content -Raw -LiteralPath $taskIndex
if(!$taskIndexText.Contains('packet_diag上板步骤_20261008.md')) {
    $taskIndexText += "`n- [包诊断候选下载与九页判读](packet_diag上板步骤_20261008.md)：2026-10-08最终构建/原约束STA通过，实板未验证；310文件检查点已保存。`n"
    $taskIndexText | Set-Content -LiteralPath $taskIndex -Encoding utf8
}
[ordered]@{saved_beijing=$taskStamp.ToString('yyyy-MM-dd HH:mm:ss');checkpoint_files=$taskManifest.Count;state_updated=$taskState.Contains('包诊断packet_diag候选已完成');board_steps=Join-Path $taskTopic 'packet_diag上板步骤_20261008.md'} | ConvertTo-Json
