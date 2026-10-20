from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,re,shutil
p=Path(__file__).resolve().parent
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
receipt=json.loads((p/'build/delivery_verified.json').read_text(encoding='utf-8'))
topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013/C11309_串行全局时钟与独立595扫描'
topic.mkdir(parents=True,exist_ok=True)
for name in ('README.md','info.json','checksums.sha256'):
    shutil.copyfile(p/'build/delivery'/name,topic/name)
shutil.copyfile(p/'build/delivery_verified.json',topic/'delivery_verified.json')
for name,label in [('oddr_audit.md','C11308_ODDR审计.md'),('status_clock_audit.md','C11308_数码管审计.md'),('feedback.json','C11308_feedback.json'),('green_bands.jpg','C11308_green_bands.jpg'),('fixed_left8.jpg','C11308_fixed_left8.jpg')]:
    source=p.parent/'player_spectrum_tf_margin/build/board_feedback_current'/name
    shutil.copyfile(source,topic/label)
shutil.copyfile(p/'build/model/status_clock_route_report.md',topic/'数码管数字模型.md')
for name in ('gate_clock_route.json','routed_clock_route.json','bmp_control_process_audit.json'):
    shutil.copyfile(p/'build/audit'/name,topic/name)
old_topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013/C11308_TF读余量与图片失败定位/README.md'
old=old_topic.read_text(encoding='utf-8-sig')
old_topic.write_text(f'## {stamp} 实板失败修正\n\n用户反馈图片/切图/轮播/参数控制正常，绿色条带覆盖BMP/OSD/频谱、两音源均无声音但频谱在动；数码管左8超过30秒固定且拨码未改。不能读C11308 build ID，版本按上下文关联；CRC/错误诊断页无法取值，不能补造。该版完整实板失败，live已FAILED，原bit/ZIP/230冻结不改。下一版C11309串行显式GCLK+独立系统域595扫描+握手快照；实际根因未测。详见同级C11309专题。\n\n'+old,encoding='utf-8')
status=docs/'当前状态.md';v=status.read_text(encoding='utf-8-sig')
v=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11308绿带/静音/固定左8实板失败，C11309三GCLK/独立595/观测流水候选已本地交付，实板pending；成功基线C11206）。',v,count=1,flags=re.M)
entry='''

- **C11309串行全局时钟/独立595扫描候选已本地交付，实板待验证**：C11308基础上125MHz串行clk显式EG_LOGIC_BUFG（实际3GCLK），595扫描改既有SD50MHz GCLK，用完整32位request/ACK快照从pixel域传送；PLL参数/原PHY lane/TF分频2/FFT/引脚/SDC保持。仅3个源变更+1mailbox新增。首轮诊断CE路径setup失败-0.420ns保留，随后仅BMP观测几何加流水/首错shadow、原控制过程与C11206剔空白注释逐token一致；21项模型重验PASS。595五相位25/50MHz1000scan引脚重建192锁存/例、跨整帧快速更新/源停钟/复位PASS，状态页PASS；SD/SPI/FFT按相同源SHA继承历史范围。新TD同源syn/phy/nativehold/bit通过，setup+0.509/hold+0.030ns/TNS0/coverage99.98%，16877LUT/10033reg/18372LE/44BRAM9K/12DSP/3GCLK。gate/routed各45clock checks、1536系数/108ROM参数PASS；serial125MHz skew仍0.326ns/fanout56，不能声称偏斜降低或唯一根因已修，外部IO电气未测。240封存/ZIP逐项核验，旧C11308 230冻结/bit/ZIP不变。PROGRAM_SRAM/5MHz、DFC11309、spectrum_clock_route.bit，未JTAG/TF/Flash。[操作/证据](专题记录/音频可视化/频谱柱_C11304_20261013/C11309_串行全局时钟与独立595扫描/README.md)。
'''
assert '**C11309串行全局' not in v
v=v.replace('## 当前阶段\n','## 当前阶段\n'+entry,1)
v=re.sub(r'^0\. C11308停止推荐.*$', '0. 加载C11309 spectrum_clock_route.bit、PROGRAM_SRAM/5MHz，先看数码管是否轮转/DFC11309，再看默认WAV画面/绿带/声音/频谱，长KEY1对照内置音阶。若异常录约28秒数码管/显示现象；若仍固定左8直接反馈持续固定。新候选pending，实际输出电气/根因未确认；不重复要求已完成的C11206回载。',v,count=1,flags=re.M)
status.write_text(v,encoding='utf-8')
with (docs/'工作日志/2026-10-14.md').open('a',encoding='utf-8') as f:
    f.write(f'''
### {stamp[11:16]}｜C11309三GCLK/595独立扫描候选交付｜本地完成，实板未完成

- 动作：development/player_spectrum_clock_route从C11308隔离；serial125MHz显式BUFG，595扫描SD50MHz系统GCLK+原子32位requestACK邮箱；rst_all先声明。仅3源变化(top/status_monitor/loader诊断)、1mailbox新增；PLL配置/原PHY lane/SD6.25MHz/频谱/引脚/SDC逐字继承。
- 针对本轮setup违例，仅诊断几何stride→image_bytes→pixel_end→mask流水、首错shadow；原BMP状态/请求/像素控制过程与C11206剔空白/注释后token一致，非整网表等价证明。新21项模型重新PASS并绑定loader201A3A36…AA57。595模型5相位(0/5/10/15/19ns)实际25/50MHz与1000scan，DIO/SCLK/RCLK外部重建8位，192锁存/例；100k以上快速源变化跨一整帧仍完整、源停钟继续扫、复位与重启、串行16bit位序/onehot/setup/RCLK均PASS。1MHz配置实测1020ns≈0.980392MHz，状态机SET多1个系统周期；仅数字模型、无外部595/PAD电气验证。当前状态页B/C/D/E/F0/F1 PASS；旧SD/SPI/FFT证据在相同源SHA绑定范围继承，不称新完整数学/串行/卡仿真。
- TD6.2.178840：新增源首次open自动写CompileOrder被scope门禁拒绝，归一后重跑认证syn；首认证route -0.420/-2.611setup和-0.025/-0.045hold禁止交付，DB/报告和原loader在build/rejected_setup。流水后重新syn/phy完成，prehold+0.509setup/hold-0.012/HTNS-0.034ns保留build/prehold；nativehold后最终SWNS+0.509/HWNS+0.030ns/TNS0、coverage99.98%。资源16877LUT/10033reg/18372LE/44BRAM9K/12DSP/3GCLK，位流同源stageHash/DB hash链通过。
- 独立静态核验：gate/routed各45 PASS/0WARN/0FAIL，PLL clkc1→显式第三GCLK→四HDMI PAD.osclk及串行FF、595三PAD→系统GCLK/mailbox域对应；Hann1024/twiddle512和108ROM控制参数均零差异。新serial summary125MHz/SWNS+0.509/HWNS+0.188/skew0.326ns/fanout56，偏斜未比C11308变小，不能声称改善测量值。现报告列出的3个PAD do setup均正，未列出的PAD/hold端点不补造，四HDMI external outputdelay仍缺，板级裕量未测。
- 产物：{receipt['zip']}，ZIP SHA {receipt['zipSha256']}，bit SHA {receipt['bitSha256']}；240文件冻结manifest {receipt['manifestSha256']}，逐项校验及ZIP内容/checksum一致。父C11308 230文件冻结/原bit/ZIP核验不变；C11308 liveFAILED及图片控制部分反馈留档，ID只能上下文关联。[候选/证据/操作](../专题记录/音频可视化/频谱柱_C11304_20261013/C11309_串行全局时钟与独立595扫描/README.md)。未JTAG/TF写入/Flash、未commit/PR。
- 未完成/下一步：实板加载PROGRAM_SRAM/5MHz确认DFC11309及数码管轮转，再默认WAV/长KEY1查看图片/绿带/两音源声音/频谱；异常28秒数码管或固定左8状态反馈，凭新证据继续排查。三处修正是隔离候选，静态/模型不证明实际绿带/静音/595根因或修复成功；成功基线仍C11206。
''')
print('C11309 delivery/current status/log recorded')

