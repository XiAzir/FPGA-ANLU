from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,re,hashlib,shutil
p=Path(__file__).resolve().parents[2]
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
out=p/'build/board_feedback_spectrum';out.mkdir(parents=True,exist_ok=True)
photo=Path(r'C:/Users/PENGYU~1/AppData/Local/Temp/codex-clipboard-938a2e56-c502-4bf8-9745-c78b9c48e87e.jpg')
shutil.copyfile(photo,out/'spectrum_empty.jpg')
feedback={'createdBeijing':stamp,'versionByConversation':'C11309','independentBuildIdReadable':False,
'boardStatus':'PARTIAL_BOARD_PASS_SPECTRUM_EMPTY','reportedBy':'user',
'quote':'一切正常，除了频谱图没东西显示。有声音。',
'photo':'IMG2/4 MANUAL, PLAY B+00 C1.00, SPECTRUM WAV, clean image/OSD, no spectrum bars',
'limits':'Overall user report records non-spectrum functions restored; no per-item repeat counts, duration or independent D-page ID added. Both-source spectrum result and B/C page values pending.',
'next':'Preserve existing C11309 bit/ZIP/frozen source; inspect actual FFT/render BRAM ports against C11307 and obtain B/C values in WAV/tone before choosing repair.'}
(out/'feedback.json').write_text(json.dumps(feedback,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
root=p.parents[1]
for f in (root/'download/spectrum_clock_route.info.json',p/'build/manual/AC201_player_spectrum_clock_route.info.json'):
    v=json.loads(f.read_text(encoding='utf-8-sig'));v['boardStatus']=feedback['boardStatus'];v['boardFeedback']=feedback
    f.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
checkpoint=p/'checkpoints/music_spectrum_clock_route_20261014_candidate'
manifest=json.loads((checkpoint/'manifest.json').read_text(encoding='utf-8-sig'))
for row in manifest:
    f=checkpoint/row['path'];assert f.stat().st_size==row['bytes'] and hashlib.sha256(f.read_bytes()).hexdigest().upper()==row['sha256'].upper()
assert len(manifest)==240
assert hashlib.sha256((root/'download/spectrum_clock_route.bit').read_bytes()).hexdigest().upper()=='9171F813BDDEC5B81B7F3577BF7C7804A3F5A24138F7763B253D7D5FB8040B3F'
assert hashlib.sha256((root/'deliverables/music_spectrum_clock_route_20261014.zip').read_bytes()).hexdigest().upper()=='04D844F7736D4069F3CD7B6E66D32C49CC1EA9DFD75EB154FF7AF12AE0B56A38'
(out/'preservation_receipt.json').write_text(json.dumps({'createdBeijing':stamp,'status':'VERIFIED_UNCHANGED','frozenFiles':240,'bitSha256':'9171F813BDDEC5B81B7F3577BF7C7804A3F5A24138F7763B253D7D5FB8040B3F','zipSha256':'04D844F7736D4069F3CD7B6E66D32C49CC1EA9DFD75EB154FF7AF12AE0B56A38'},indent=2)+'\n',encoding='utf-8')
status=docs/'当前状态.md';v=status.read_text(encoding='utf-8-sig')
v=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11309用户反馈除空频谱外均正常、有声，240冻结/位流/ZIP确认保留；频谱阶段定位进行中，C11206完整成功基线保留）。',v,count=1,flags=re.M)
v=v.replace('**C11309串行全局时钟/独立595扫描候选已本地交付，实板待验证**','**C11309音画/非频谱功能获用户正常反馈，频谱为空待修**')
v=v.replace('PROGRAM_SRAM/5MHz、DFC11309、spectrum_clock_route.bit，未JTAG/TF/Flash。','PROGRAM_SRAM/5MHz、DFC11309、spectrum_clock_route.bit；用户新反馈“除频谱外一切正常、有声音”，照片干净BMP/OSD、SPECTRUM WAV无柱；仅上下文关联版本，B/C值和tone频谱待补，不补造持续时长/次数。live PARTIAL_BOARD_PASS_SPECTRUM_EMPTY，原240冻结/bit/ZIP核验不改，未JTAG/TF/Flash。',1)
v=re.sub(r'^0\. 加载C11309.*$', '0. 保留音画正常的C11309配置/位流。取得当前WAV及内置音阶B页FFT帧数/C页阶段+最大幅值完整八位值各两次，确认tone是否也空；同时只读比对实际FFT/renderer BRAM，依据阶段选择最小修正。未生成下一版，不重复非频谱已正常的测试。',v,count=1,flags=re.M)
status.write_text(v,encoding='utf-8')
topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013/C11309_串行全局时钟与独立595扫描'
shutil.copyfile(out/'spectrum_empty.jpg',topic/'实板频谱为空.jpg')
shutil.copyfile(out/'feedback.json',topic/'频谱为空_feedback.json')
old=topic/'README.md';old.write_text(f'## {stamp} 用户音画/控制正常，频谱为空\n\n用户反馈“一切正常，除了频谱图没东西显示。有声音”。照片干净BMP/字幕、IMG2/4、SPECTRUM WAV空；非频谱范围按用户总体反馈恢复，不补造具体回归次数/时长或独立D页版本，内置tone频谱与B/C值待补。C11309位流/ZIP/240冻结已逐项核验不变，live改PARTIAL_BOARD_PASS_SPECTRUM_EMPTY；完整频谱验收尚未通过。先用现有B/C诊断定位并审计实际BRAM读写控制，未动稳定音画路径、未生成下一版、未操作硬件。\n\n'+old.read_text(encoding='utf-8-sig'),encoding='utf-8')
with (docs/'工作日志/2026-10-14.md').open('a',encoding='utf-8') as f:
    f.write(f'\n### {stamp[11:16]}｜C11309音画恢复/频谱为空｜阶段定位进行中\n\n- 用户反馈“一切正常，除了频谱图没东西显示。有声音”。照片IMG2/4、SPECTRUM WAV空、干净图像/字幕；非频谱范围按总体反馈恢复，版本仅上下文关联、不补造逐项次数或时长。原240冻结/bit/ZIP逐项SHA确认不变，live PARTIAL_BOARD_PASS_SPECTRUM_EMPTY。证据在development/player_spectrum_clock_route/build/board_feedback_spectrum及C11309专题。\n- 已读频谱捕获/FFT/显示提交代码；音源及算法/renderer字节继承C11307，但数学/INIT静态核验不证明实际BRAM运行。已请求WAV/tone B/C完整值各两次及tone频谱，独立只读审计FFT/target/state RAM控制正在进行。\n- 未完成：FFT完成/幅值/显示具体失败阶段和根因待观测；不调整稳定音画，不盲发新位流。下一步据B/C和BRAM审计选择最小修正。未JTAG/TF写入/Flash。\n')
print('C11309 stable A/V preserved, partial pass recorded, spectrum stage pending')

