from pathlib import Path
import json,re,shutil,hashlib
from datetime import datetime,timezone,timedelta
p=Path(__file__).resolve().parent
root=p.parents[1]
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013'
receipt=json.loads((p/'build/delivery_verified.json').read_text(encoding='utf-8'))
info=json.loads((root/'download/spectrum.info.json').read_text(encoding='utf-8'))
assert receipt['status']=='LOCAL_DELIVERY_VERIFIED_BOARD_PENDING'
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
for source,name in [(p/'build/delivery/README.md','操作卡.md'),(p/'build/delivery_verified.json','交付凭据.json'),
                    (p/'build/model/model_result.json','模型结果.json'),(p/'build/audit/spectrum_rom_init_audit.json','系数硬件初始化核验.json'),
                    (p/'build/model/real_music_preview.png','音乐数据模型预览.png')]:
    shutil.copyfile(source,topic/name)
summary=f'''更新时间：{stamp}（北京时间）。**C11304本地候选已交付，实板待验证；成功基线仍C11206。**

- [测试包]({root.as_posix()}/deliverables/music_spectrum_20261013.zip)；[操作卡](操作卡.md)。PROGRAM_SRAM/5MHz，D页须DFC11304；同卡/供电/HDMI默认音乐、KEY1内部音阶及回切、HOLD恢复；异常用包内bmp_scale.bit回退。
- 真实48kHz PCM→1024点Hann窗定点FFT→24段近似频谱幅值柱；低频在左、高频在右，柱快起慢落/峰值保持10帧。最终面板x16..623/y304..431、plot x128..511、pitch16/body12、高84行。VS后共享ALU49拍计算后原子提交，target双bank BRAM、level/peak/hold状态BRAM；冻结继续播放声音，恢复显示最新目标。
- 13合成1024点输入312段与独立定点gold零差异；direct DFT最大量化误差6.999；实际TEST.WAV两窗口48段零差异。最终650像素、实际PCM到renderer72段、4原子提交/5稳定窗口、同拍VS/frame_done、HOLD/恢复/peak/stale/source取消/reset均PASS；29输入SHA复核0差异。[模型结果](模型结果.json)。
- TD6.2.178840完整synthesis→physical→native fix_hold→bitgen通过且源码/脚本/数据库证据绑定；最终setup+0.557ns、hold+0.021ns、TNS0、coverage99.97%；16383LUT/9833reg/18049LE/44BRAM9K/11DSP/2GCLK。prehold HWNS-0.004/HTNS-0.008报告保留build/prehold；失败/超MSlice各轮也保留，未复用失败DB。
- eram_init on已配置；gate逐字重构1024 Hann/512 twiddle INIT与原始ROM零差异，[硬件初始化核验](系数硬件初始化核验.json)。HDL5314前端ROM warning与最终真实INIT的差异由最小探针实证；抽象BE警告在最终物理整字wea接口无BE端口，未做厂家全门级tone模型。
- 父C11303的user_source除waveform/两个ID源(3文件)外其余82文件继承；新增5文件(FFT、频带include、ROM两表、生成器)。top两处ID改为C11304，音频/FIFO/TF、PHY、PLL、引脚、SDC、3份al_ip字节一致；工程.al新增FFT并开启ERAM init，其他RAM初值与布局变化仍需此次实板回归。
- bit {info['bitBytes']}bytes SHA256 `{receipt['bitSha256']}`；ZIP655861bytes SHA256 `{receipt['zipSha256']}`；candidate325文件SHA逐项通过，manifest `{receipt['manifestSha256']}`。[交付凭据](交付凭据.json)。C11206、C11302/C11303源/位流/ZIP/原检查点保留。
- [音乐数据模型预览](音乐数据模型预览.png)由真实音乐与独立像素gold生成，非实板照片；视效参数为初值，观感、音质、真实卡/接收端、连续运行与冷启动均待反馈。未代理JTAG/TF写/Flash。内时序通过不证明HDMI外部电气裕量。

下一步：用户下载候选到实验室电脑，在相同条件按操作卡验证音画/两音源/HOLD及原集成功能；按实际观感微调，确认后再封存成功版本。当前仅本地交付通过。

---
'''
f=topic/'README.md'
old=f.read_text(encoding='utf-8')
old=old.replace('当前实现与独立模型验证进行中，整机综合正在运行；本页随阶段更新。','以下为当时阶段记录；最终结论见页首交付摘要。')
f.write_text(old.split('\n',1)[0]+'\n\n'+summary+old.split('\n',1)[1],encoding='utf-8')
state=docs/'当前状态.md'
s=state.read_text(encoding='utf-8')
s=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11304频谱柱本地候选交付/实板pending，成功基线C11206）。',s,count=1,flags=re.M)
bullet='- **C11304真实频谱柱候选已本地交付，实板待验证**：实际PCM 1024点Hann/FFT、24段幅值柱、快起慢落/峰值保持，48拍共享计算后统一commit；目标/状态存BRAM，HOLD/恢复/切源/超时已模型验证。最终setup+0.557ns/hold+0.021ns/TNS0/coverage99.97%，16383LUT/9833reg/18049LE/44BRAM/11DSP；650像素、312合成段+48真实音乐段/72集成段及29输入SHA核对通过，gate1536系数INIT零差异；candidate325文件/ZIP SHA核验通过。PROGRAM_SRAM 5MHz、D页DFC11304，音画/观感/长期未板测；未操作JTAG/TF/Flash。[候选/操作/证据](专题记录/音频可视化/频谱柱_C11304_20261013/README.md)。C11206成功基线不变，C11302失败保留、C11303保持pending历史。\n\n'
s=s.replace('## 当前阶段\n\n','## 当前阶段\n\n'+bullet,1)
s=s.replace('S5 FFT/高清默认不启用。','成功基线S5 FFT/高清默认不启用；C11304单独候选已启用FFT。',1)
s=s.replace('## 下一步\n\n','## 下一步\n\n0. 优先按C11304操作卡同条件验证默认音乐/内部音阶/回切、频谱观感、HOLD/恢复和原集成功能；候选未获实板反馈前不升为成功基线。\n\n',1)
state.write_text(s,encoding='utf-8')
entry=f'''\n### {stamp[11:16]}｜C11304真实频谱柱｜本地交付完成/实板待验证

- 用户选定频谱柱，隔离player_spectrum完成真实PCM 1024 Hann FFT/24段柱、快升慢落/峰值/HOLD/切源；共享ALU49拍原子提交，BRAM双bank和状态表降资源。母C11303 PHY/音频/文件/PLL/引脚/SDC源保持，成功回退C11206及旧ZIP/检查点不改。
- 本地模型312合成段/48实际音乐段 exact，650像素与72段动态集成/原子snapshot/冻结/超时/取消PASS；gate全部1536 ROM INIT逐字正确。TD最终native setup+0.557/hold+0.021/TNS0，16383LUT/9833reg/18049LE/44BRAM/11DSP；首轮路径/初始化/映射、超MSlice、.al规范化拒绝记录与prehold负值都保留，未把失败算成功。
- ZIP music_spectrum_20261013.zip SHA {receipt['zipSha256']}；bit SHA {receipt['bitSha256']}；candidate325逐项清单核验，manifest {receipt['manifestSha256']}。模型29绑定输入核对0差异；交付包CRC和字节检查通过。
- 未本地JTAG/TF/Flash；真实板音画/观感/长期待用户验证，不宣称修复成功。PROGRAM_SRAM/5MHz→D页DFC11304，检查默认音乐/长KEY1音阶与回切/HOLD恢复，异常bmp_scale.bit回退。详见[专题/操作](../专题记录/音频可视化/频谱柱_C11304_20261013/README.md)。
'''
with (docs/'工作日志/2026-10-13.md').open('a',encoding='utf-8') as f:f.write(entry)
print(json.dumps({'recordedBeijing':stamp,'topic':str(topic),'boardStatus':'PENDING_BOARD_VALIDATION'},ensure_ascii=False))
