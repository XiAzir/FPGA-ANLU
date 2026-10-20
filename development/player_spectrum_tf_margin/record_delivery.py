from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,re,shutil

p=Path(__file__).resolve().parent
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
receipt=json.loads((p/'build/delivery_verified.json').read_text(encoding='utf-8'))
topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013/C11308_TF读余量与图片失败定位'
topic.mkdir(parents=True,exist_ok=True)
for name in ('README.md','info.json','checksums.sha256'):
    shutil.copyfile(p/'build/delivery'/name,topic/name)
shutil.copyfile(p/'build/delivery_verified.json',topic/'delivery_verified.json')
shutil.copyfile(p/'build/model/spi_margin_report.md',topic/'SPI人工延迟模型.md')
for name in ('media_path_audit.md','cache_netlist_audit.md','feedback.json'):
    shutil.copyfile(p.parent/'player_spectrum_observed/build/board_feedback_20261014'/name,topic/name)
s=docs/'当前状态.md';v=s.read_text(encoding='utf-8-sig')
v=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11307频谱/音阶部分正常、BMP失败/WAV杂音；C11308 TF读余量/精确失败定位候选已本地交付，实板pending；成功基线C11206）。',v,count=1,flags=re.M)
needle='## 当前阶段\n'
entry='''

- **C11308 TF读余量/精确图片失败定位候选已本地交付，实板待验证**：源自C11307，只将TF SPI高速分频0→2（名义12.5→6.25MHz），并旁路增加512字节卡CRC检查/坏扇区计数、BMP首次失败原因/头校验mask/缩放错误码；诊断E/F0/F1，周期26秒。实际根因未确认、降速效果未上板；读取图片可能变慢。6个媒体/诊断源变动，其余user_source逐字继承（FFT/HDMI/PLL/引脚/SDC不变）。BMP21项、SD5块含2故障/复位、诊断页/B-C兼容、频谱遥测通过；288字节SPI人工延迟模型展示采样边界改善，不证明实物输入时序或完整带宽。TD同源syn→phy→hold→bit通过，最终setup+0.120/hold+0.030ns/TNS0/coverage99.97%，16755LUT/9928reg/18168LE/44BRAM/11DSP；prehold -0.020/-0.084ns证据保留。gate/routed1536系数及108ROM控制参数零差异。230文件封存/ZIP核验通过、旧C11307 281封存逐项不变。PROGRAM_SRAM/5MHz、DFC11308、spectrum_tf_margin.bit；未操作JTAG/TF写入/Flash。[包/操作/证据](专题记录/音频可视化/频谱柱_C11304_20261013/C11308_TF读余量与图片失败定位/README.md)。
'''
assert '**C11308 TF读余量' not in v
v=v.replace(needle,needle+entry,1)
v=re.sub(r'^0\. C11307完整板测未通过.*$', '0. 加载C11308 spectrum_tf_margin.bit，PROGRAM_SRAM/5MHz确认DFC11308；先默认WAV，再长KEY1。若仍无BMP/杂音，分别录数码管至少28秒，包含E（目录数/图片首错）、F0坏CRC/F1检查数，说明现象。诊断不自动拦截/重试坏扇区。频谱/内置音阶C11307已有正常反馈，旧C11206成功基线保留，不再重复请求旧版回载。',v,count=1,flags=re.M)
s.write_text(v,encoding='utf-8')
with (docs/'工作日志/2026-10-14.md').open('a',encoding='utf-8') as f:
    f.write(f'''
### {stamp[11:16]}｜C11308 TF读余量/图片首错候选交付｜本地完成，实板未完成

- 动作：从C11307隔离为development/player_spectrum_tf_margin；TF SPI分频0→2，名义12.5→6.25MHz；增加被动readCRC checked/bad与BMP粘性首错详情，E/F0/F1、26秒轮转。现有FFT/PHY/PLL/引脚/SDC继承。未操作JTAG/TF/Flash；未证明根因，降速是余量隔离尝试，图片可能慢。
- 验证：C11307视频DFC11307/1D980000定位BMP loader报错/无mapper/fs/WAV错误；两音源FFT增长FE，音阶干净为用户反馈。媒体RTL和缓存静态审计无确定差异，不能以此宣布完整功能正常。CRC F485是跳过65536后32768样本、匹配60s素材，A8000为捕获数。两个视频20秒提帧/接触图及独立审计在旧工程build/board_feedback_20261014。
- C11308模型：BMP21项（有效768像素commit、头检查/长度/mapper/watchdog/scale/首错/reset），SD5块/2故障CRC及reset，诊断页B/C/D/E/F0/F1兼容，频谱遥测PASS。SPI288字节12组合人工延迟例：div0在55/75ns失误，div2对应无错，85ns均失误；仅数字模型，非板端波形或整机带宽证明。生产源和测试SHA绑定于build/model/current_source_binding.json、BMP结果JSON。全FFT数学/像素/serializer取C11307相同源码绑定的历史范围，不冒称新完整模型或vendor protected BRAM仿真。
- TD6.2.178840同源syn/phy/nativehold/bit均通过；最终SWNS+0.120/HWNS+0.030ns/TNS0/coverage99.97%，16755LUT/9928reg/18168LE/44BRAM9K/11DSP/2GCLK。布线初次hold-0.020/HTNS-0.084ns保留build/prehold，nativehold后清除；gate与routed ROM1536字/108控制参数全match，路由后网表只读导出。
- 产物：{receipt['zip']}；ZIP SHA {receipt['zipSha256']}；bit SHA {receipt['bitSha256']}；230文件封存manifest {receipt['manifestSha256']}，旧C11307 281文件冻结逐项不变及原位流/ZIP hash不变。C11307 live记完整板测失败/频谱音阶部分进展；新候选pending，成功基线C11206不变。[操作/证据](../专题记录/音频可视化/频谱柱_C11304_20261013/C11308_TF读余量与图片失败定位/README.md)。
- 未完成/下一步：用户加载PROGRAM_SRAM/5MHz确认DFC11308，默认WAV与长KEY1检查BMP/杂音/频谱；异常记录至少28秒完整数码管尤其E/F0/F1，再据具体阶段/CRC变化修正。实际TF采样/整曲音乐/HDMI电气/长期稳定仍未验证，不称修复成功。
''')
print('C11308 delivery/current status/log recorded')

