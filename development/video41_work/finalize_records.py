"""Update the project status after C41 package hash verification."""
from pathlib import Path
import json

ROOT=Path(__file__).resolve().parents[2]
DOCS=Path('E:/QQ CACHE/Download/安路资料')
record_root=DOCS/'开发记录'
topic=record_root/'专题记录/视频播放实现_C11319_20261021/C11341_SDRAM刷新修复_20261027/README.md'
receipt=json.loads((ROOT/'development/player_video41_refresh/verification/delivery_receipt.json').read_text(encoding='utf-8-sig'))
assert receipt['status']=='PACKAGE_HASH_VERIFIED_BOARD_PENDING'
status=record_root/'当前状态.md'
text=status.read_text(encoding='utf-8-sig')
rest=text[text.index('## 最新现场与优先级：先消除提示，内容保持1080p15'):]
lead='''# 当前状态

更新：2026-10-27 19:38（C40 TF25用户上板功能通过；C41周期刷新/ACK事件修复离线交付完成，Slice89.77%、setup/hold+1.177/+0.003ns、TNS0。最终完整gate和routed命令验证通过；C41待上板，SDRAM100随后推进）。

## 当前执行优先级：C41上板，随后SDRAM100

用户18:07在C40交付后反馈“一切正常”，`download/video40_spi25.board_feedback.json`标记BOARD_FUNCTION_PASS_USER_REPORTED。原C40 bit SHA412b028d2d0866012a35f1e51b84e8566eaff3f04d0611d1169cdfb7396306ed及ZIP保持，作为当前TF25实板功能基线。CRC页面、时长/冷启动次数、实际频率/吞吐未分别报告；1.353→2.434MB/s是此前32扇区模型结果。

C41独立工程`development/player_video41_refresh`沿用TF25/SDRAM50/原HDMI/480p15媒体。实际改动3份user_source、110份保持：刷新宏按EM638325原厂4096 AREF/64ms设置终值780（每781拍/15.62µs请求），公开ACK移位入口改为上升沿事件，top版本00C11341。保护payload逐字节SHA保持090edd71e139c8d240d8853e8046b954968976e8e8273f454ef4c82b6715e360。

数字因果：C32/C40旧刷新宏展开0、周期请求常量0；C41宏恢复后，周期req与读写结束相撞可使直接/完成两路raw ACK连高2拍，原移位入口逐拍触发造成AREF连续2拍。合法4字流已复现，修复后完整生产gate同流114写/114读、req6/AREF6通过。最终routed长突发256字流576写/512读、req6/AREF6，命令间隔566–838拍，最大观察请求服务延迟245拍/4.9µs；routed空闲2/2/2、781拍。raw ACK可含额外独立上升沿，检查按真实AREF匹配请求。模型为强制外部应用/时钟/复位、加速启动、无存储行为器件观察器，无SDF/数据保持/物理波形证据；历史板上故障因果尚未确定。

最终Slice8797/9800（89.77%，C40少21），BRAM62/DSP26；setup/hold+1.177/+0.003ns、TNS0、片内覆盖99.99%。源/脚本/DB/报告/bit绑定PASS。routed TF引脚setup估计留卡tOD+PCB往返11.734ns，真实外部min/max仍待表征。

交付`download/video41_refresh.bit`634280B，SHAf572afe5baa74dc61df58132c172298690c92171d5c631630fec6b02d3c6b7ac；包`deliverables/video41_refresh_20261027.zip`801592B，SHAd90beeed47e9ed9c10995131bc2862a7a7a78f356f12db6ed601403125bb1949。16项payload+manifest/ZIP完整性/逐项SHA通过，含C40相同字节回退、指南、反馈模板和离线证据。包与info标记BOARD_PENDING；本轮未上板/写卡/Flash。

下一步PROGRAM_SRAM加载C41，确认00C11341；同外接5V/同TF素材/原HDMI，图片静置5分钟后切图、原声/音阶、视频3分钟、5次模式往返及3次冷启动。C/E计数同C40，E期望0，异常同条件回载C40比较。C41现场确认后再推进SDRAM100；当前100MHz尚未实现。详细证据与失败过程见[C41专题](专题记录/视频播放实现_C11319_20261021/C11341_SDRAM刷新修复_20261027/README.md)，TF25见[C40专题](专题记录/视频播放实现_C11319_20261021/C11340_TF25提速_20261027.md)。

'''
status.write_text(lead+rest,encoding='utf-8')
topic_entry='''
## 19:38：最终离线交付

- 最终physical setup/hold +1.177/+0.003ns，TNS0，覆盖99.99%。Slice8797/9800（89.77%，比C40少21，此为整版综合/布局结果）；LUT16850、REG8744、BRAM62、DSP26。未执行hold修复，最终physical已通过。
- 源/构建脚本/综合/路由DB/报告/位流绑定校验PASS，`verification/final_stage_binding.json` SHA dddc0d44599b0b3054055b02467f35a897708cffd417de0c81368c8562c92ff1；最终routed网表SHA a8ccaa65b235e18caa20b037ba24630b0773bd33b7f2c9c22f280255a8418fe3。
- 最终routed 256字长突发：`gate_refresh/run_C41_20261027_193406`，576次WRITE/512次READ、req6/rawACK6/AREF6，间隔838/835/838/566/835拍；最大观察请求→命令245拍=4.9µs。最终routed空闲`run_C41_20261027_193626`，应用enable均0且未force内部rw_vld，req2/ACK2/AREF2，相邻781拍。连同最终syn短突发114写/114读，汇总并绑定为`video41_work/final_gate_commands.json` PASS。
- 这些是完整生产网表实际命令的功能证据；仿真外部驱动时钟50MHz/相移8ns及reset，公开上电计数加速，器件为显式无存储行为观察器，不包含SDF或数据保持。routed实例较syn增加BANKREF模型，首轮缺该模型失败后补官方模型；第二轮已路由优化使6个旧alias失效，随后按真实net映射应用/初始化/请求/时钟并对原reset全部复制网施加同一测试reset，清单/bench/runner/hash均在各run保存。失败日志保留，未替换控制器实现。
- `raw_io_report.tcl`只在分析进程附加人工20ns max/0ns min delay，提取最终routed SCK/MISO；原project bytes执行后恢复，生产SDC/PR DB保持。SCK pad6.280ns，MISO内部3.408ns，required21.422ns，可供card tOD+PCB往返预算估计11.734ns；报告SHAe0eb15e28922cb0e082edd5306e2c80487de01dc9f267e876d6b8b1c24b87862。该估计与生产片内时序分项记录。
- 位流`download/video41_refresh.bit`634280B，SHA f572afe5baa74dc61df58132c172298690c92171d5c631630fec6b02d3c6b7ac。ZIP`deliverables/video41_refresh_20261027.zip`801592B，SHA d90beeed47e9ed9c10995131bc2862a7a7a78f356f12db6ed601403125bb1949；16份payload+manifest、ZIP完整性/逐文件SHA、C41及C40相同字节回退逐项通过。info/receipt为OFFLINE_VERIFIED_REFRESH_BOARD_PENDING / PACKAGE_HASH_VERIFIED_BOARD_PENDING。
- 当前C40用户功能通过保持，C41待PROGRAM_SRAM同卡/同外接5V/原HDMI实测。指南包含图片静置5分钟/切图、原声和音阶、视频3分钟/模式往返、3次冷启动、C/E三页与回退反馈。未操作硬件/TF/Flash、未提交/push；TD与仿真均串行完成并已退出，最终routed仿真进程峰值约1.15GiB。下一步C41板测后再评估SDRAM100及高清整机。
'''
with topic.open('a',encoding='utf-8') as f:f.write(topic_entry)
log_entry='''
### 19:38｜C41刷新修复离线封包｜已完成，实板待测

- 完成最终syn/physical/bit，setup/hold+1.177/+0.003ns、TNS0/覆盖99.99%；Slice8797/9800（89.77%，C40少21），BRAM62/DSP26。源/脚本/DB/报告/bit绑定PASS，final_stage_binding SHA dddc0d44599b0b3054055b02467f35a897708cffd417de0c81368c8562c92ff1。
- 完整生产syn短混合114写/114读，req6/AREF6；完整routed长256字混合576写/512读、req6/AREF6，AREF间距566–838拍，最大观察服务延迟245拍4.9µs；routed空闲2/2/2、781拍。均无ACK仿真覆盖，命令间距约束/unknown/请求匹配通过。routed适配补官方BANKREF和优化后的6个alias，reset复制网同测试reset，原失败日志/force/hash保留。无存储行为观察器/无SDF/数据保持范围详记专题。
- C41bit SHA f572afe5baa74dc61df58132c172298690c92171d5c631630fec6b02d3c6b7ac，634280B；ZIP deliverables/video41_refresh_20261027.zip，801592B/SHA d90beeed47e9ed9c10995131bc2862a7a7a78f356f12db6ed601403125bb1949；16份payload+manifest/ZIP/逐项SHA/C40相同字节回退通过。最终routed IO预算估计11.734ns，实际卡/PCB外部min/max仍待。三份源变化/110保持，TF25/SDRAM50/原HDMI/素材沿用。
- 当前无C41板测/写卡/Flash/提交/push，C40用户通过基线保持。所有EDA/仿真重任务串行且已退出，routed仿真峰值约1.15GiB。下一步PROGRAM_SRAM确认00C11341并按包内指南做静置/音频/视频/切换/冷启动，异常同条件回载C40。100MHz在此项现场验证后推进；历史板上故障因果未定。详见[C41专题](../专题记录/视频播放实现_C11319_20261021/C11341_SDRAM刷新修复_20261027/README.md)。
'''
with (record_root/'工作日志/2026-10-27.md').open('a',encoding='utf-8') as f:f.write(log_entry)
print('C41_FINAL_RECORDS_UPDATED')
