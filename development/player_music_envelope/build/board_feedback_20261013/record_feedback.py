from pathlib import Path
import json, hashlib, shutil
from datetime import datetime, timezone, timedelta

project = Path('E:/VSCODE-project/FPGA-ANLU')
docs = Path('E:/QQ CACHE/Download/安路资料')
folder = docs / '开发记录/专题记录/音频可视化/波形清晰度优化_20261013/C11302包络试验/实板失败_20261013'
folder.mkdir(parents=True, exist_ok=True)
build = Path(__file__).parent
stamp = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest().upper()
sources = {
 'screen.jpg': Path('C:/Users/PENGYU~1/AppData/Local/Temp/codex-clipboard-511fef71-8b52-47ab-a62c-af2da29c0295.jpg'),
 'before_key1.mp4': Path('E:/QQ CACHE/LiaoTianJiLu/Tencent Files/1791081637/nt_qq/nt_data/Video/2026-10/Ori/57b87b430866b65a6f080945d25491cd.mp4'),
 'after_key1.mp4': Path('E:/QQ CACHE/LiaoTianJiLu/Tencent Files/1791081637/nt_qq/nt_data/Video/2026-10/Ori/6d87776aabe8e2878b0e30c57b477379.mp4'),
}
media = []
for name, src in sources.items():
 dst = folder / name
 shutil.copyfile(src, dst)
 assert sha(src) == sha(dst)
 media.append({'source':str(src),'archive':str(dst),'bytes':dst.stat().st_size,'sha256':sha(dst)})
for name in ('before_all.jpg','after_all.jpg'):
 shutil.copyfile(build/name, folder/name)
feedback = {
 'recordedBeijing':stamp,'version':'C11302','boardStatus':'FAILED_BOARD_VIDEO_CORRUPTION_AUDIO_SILENT',
 'bitSha256':sha(project/'download/music_envelope.bit'),
 'userReport':'最新一版没有声音，照片显示整屏规则绿/彩色竖条；提供长按KEY1前后视频。',
 'rollbackUserReport':'同张TF卡、同供电、HDMI和音量回载bmp_scale.bit后，画面和声音都正常。',
 'rollbackBitSha256':sha(project/'download/bmp_scale.bit'),
 'media':media,
 'readings':{
  'before':{'page1':'1DA80000','page3':'3300BB80','page6':'6700F485','page7':'7700F485','page8':'8700F485','page9':'97000000','pageA':'A7008000','pageB':'B702002D','pageC':'C700002C','pageD':'DFC11302'},
  'after':{'page1':'1DA80000','page3':'3B00BB80','page6':'6700F485','page7':'7700F485','page8':'8700F485','page9':'97000000','pageA':'A7008000','pageB':'B702002D','pageC':'C700002C','pageD':'DFC11302'},
 },
 'interpretation':[
  'page3旗标3/B：WAV/tone分别0/1，underflow=0，HDMI输入video_locked=1，frame_seen=1；0xBB80=48000有效PCM/名义秒。',
  '6/7/8页flag7表示三处prefix已完成，CRC都是F485；A页0x8000=32768采样。9页format_bad=0。',
  'CRC范围跳过65536个采样后检查32768个PCM16，不是全文件或连续音频完整证明，也不覆盖加密HDMI核内部/数据包/PHY/接收端。',
  'B页首次采样高字节偏移0x02002D=131117，对应44字节头+65536*2+1；C页data_offset=44。',
  '全屏条纹覆盖OSD生成区域，不能仅归因SDRAM底图或包络曲线；优先排查HDMI共用发送链，但尚无唯一实板根因。',
 ],
 'actions':'ffprobe元数据检查、ffmpeg每秒提帧、多帧人工字形复核、源码/最终STA审计；无代理JTAG、TF写或Flash。',
 'next':'保留失败位流/冻结清单/原ZIP；C11206继续成功基线，隔离验证HDMI PHY采样补强，待模型/STA后才能交付新的实板候选。'
}
(folder/'feedback.json').write_text(json.dumps(feedback,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(build/'feedback.json').write_text(json.dumps(feedback,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for info in (project/'download/music_envelope.info.json',project/'development/player_music_envelope/build/manual/AC201_player_music_envelope.info.json'):
 before = json.loads(info.read_text(encoding='utf-8-sig'))
 (build/(info.name+'.before_feedback.json')).write_text(json.dumps(before,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 before['boardStatus'] = feedback['boardStatus']
 before['boardFeedback'] = {'recordedBeijing':stamp,'evidence':str(folder/'feedback.json'),'rollbackNormal':True,'rootCause':'UNCONFIRMED'}
 info.write_text(json.dumps(before,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
readme = '''# C11302 实板失败取证

用户报告新版无声、整屏规则绿/彩色竖条；同条件回载 C11206 后音画都正常。两段录像明确显示 DFC11302；前后 3 页分别 3300BB80、3B00BB80，音源切换有效，每名义秒 48000 PCM、欠载标志 0、HDMI 核输入视频锁定。6/7/8 页采样 CRC 同为 F485、flag7 完成，9 页格式错误 0，A 页采样数 32768；B/C 页为 02002D/00002C。

证据仅覆盖用户反馈和所显示的诊断窗口；CRC 不覆盖加密 HDMI 核内部/发送包/PHY/显示器，不能写成音频端到端正确。照片异常也覆盖由 FPGA 生成的文字区域，故优先查图音共用 HDMI 发送环节，实际机制仍未确认。原交付最终 STA 是 setup +0.672ns、hold +0.024ns、TNS0；TD 工程目录的负 hold 报告属于修复前历史。

原始照片/两视频及 SHA、逐页解码、取证边界见 [feedback.json](feedback.json)。每秒抽帧见 [长按前](before_all.jpg)、[长按后](after_all.jpg)。源码只读审计说明仅包络 RTL 与 build ID 改变，音频/PHY/PLL/引脚/SDC 源未改变；静态一致不证明新版物理实现正确。

保留 C11302 失败位流、原冻结清单和原 ZIP；只更新 live 元数据为 FAILED。C11206 仍为成功基线。本轮无代理板卡/JTAG/TF/Flash 操作。下一步在独立工程检验 HDMI PHY 采样补强，模型与原约束 STA 通过才交付；未修复、未板测的新候选不能标为成功。
'''
(folder/'README.md').write_text(readme,encoding='utf-8')
state = docs/'开发记录/当前状态.md'
txt = state.read_text(encoding='utf-8-sig')
txt = txt.replace('更新：2026-10-13 18:53:29（北京时间；C11302候选独立交付复核通过，实板pending，成功基线C11206）。',f'更新：{stamp}（北京时间；C11302实板花屏/无声失败，用户同条件回载C11206音画恢复；根因排查中）。')
start = txt.index('- **C11302音乐包络候选已本地交付、实板待验证**')
end = txt.index('- **C11301已获用户清晰度改善反馈',start)
txt = txt[:start]+'''- **C11302 实板失败，禁止作为成功版**：用户报告整屏规则绿/彩条、无声，长按 KEY1 后仍无声；同卡/供电/HDMI/音量回载 C11206 音画均正常。两段视频 build ID DFC11302；WAV/tone 输入均 48000 PCM/名义秒，无欠载，source/FIFO/HDMI 输入 prefix CRC 同 F485（flag7、32768 样本），格式错误 0。支持优先定位 PCM 输入之后的 HDMI 发送链，未证明唯一根因。最终交付 STA setup+0.672ns/hold+0.024ns/TNS0 的历史结论保留；模型与 STA 未覆盖本次实物异常。live info 改 FAILED，原 bit/255 文件 frozen checkpoint/ZIP 不改。[失败证据与解码](专题记录/音频可视化/波形清晰度优化_20261013/C11302包络试验/实板失败_20261013/README.md)。当前在独立验证串行采样补强方案，尚无新修复位流或实板通过；成功基线 C11206。

'''+txt[end:]
txt = txt.replace('2. 当前开发：C11301波形清晰度候选已封存并交付，等待用户按操作卡下载并确认音画、HOLD/恢复和清晰度；规格/预算、模型、综合/时序及封存已完成，动态双线按用户选择暂保留，C11206 verified继续作回退。','2. 当前开发：C11302花屏/无声已由用户反馈与视频确认，C11206同条件回载正常。先完成HDMI发送链分层排查与隔离候选的模型/原约束STA；候选交付后做同条件音画/长KEY1两音源对照，C11206继续回退。')
state.write_text(txt,encoding='utf-8')
log = docs/'开发记录/工作日志/2026-10-13.md'
with log.open('a',encoding='utf-8') as f:
 f.write(f'\n### {stamp[11:]}｜C11302实板花屏/无声与回退对照｜排查进行中\n\n- 动作/产物：原样归档照片和两段KEY1前后录像并核验SHA；每秒抽帧、逐页解码与失败live元数据更新，原位流/检查点/ZIP保持。证据见[失败取证](../专题记录/音频可视化/波形清晰度优化_20261013/C11302包络试验/实板失败_20261013/README.md)。\n- 验证/结论：用户同卡/供电/HDMI/音量回载C11206后音画正常。录像DFC11302，3300BB80/3B00BB80证实WAV/tone48000输入/名义秒、欠载0、core输入锁定；6/7/8CRC=F485、flag7、A=8000、format0。属于PCM输入段prefix证据，不证明核内部包/PHY/接收端。最终STA+0.672/+0.024/TNS0仍属本地历史通过，不能替代板测。\n- 未完成/影响：C11302实板失败，唯一根因未确认，优先查HDMI共用发送链；新候选尚未生成/板测。无代理JTAG/TF/Flash。\n- 下一步：独立延迟/相位/复位模型核查串行采样补强，保留C11206基线；门槛通过再独立构建候选。\n')
print(json.dumps({'recorded':stamp,'archive':str(folder),'mediaCount':len(media),'bitSha256':feedback['bitSha256']},ensure_ascii=False))
