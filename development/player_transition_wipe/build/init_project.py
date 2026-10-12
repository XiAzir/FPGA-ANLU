from pathlib import Path
import sys

for _anlu_root in Path(__file__).resolve().parents:
    if (_anlu_root / 'scripts' / 'anlu_paths.py').is_file():
        sys.path.insert(0, str(_anlu_root / 'scripts'))
        break
from anlu_paths import DOCS_ROOT, REPOSITORY_ROOT, recorded_path

import hashlib,json,shutil,datetime
root=REPOSITORY_ROOT;p=root/'development/player_transition_wipe';parent=root/'development/player_pcm_waveform_keyfreeze/checkpoints/waveform_keyfreeze_20261012_verified'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest().upper()
assert sha(parent/'manifest.json')=='384BCED087F68A0DE5380816F1B0700E6194C8B22D1219FB318DE511D2B1BC36'
for e in json.loads((parent/'manifest.json').read_text(encoding='utf-8-sig')):assert sha(parent/e['path'])==e['sha256']
assert not (p/'src').exists()
for name in ['src','scripts']:shutil.copytree(parent/name,p/name)
for f in (p/'scripts').rglob('*'):
 if f.is_file():f.write_text(f.read_text(encoding='utf-8-sig').replace('player_pcm_waveform_keyfreeze','player_transition_wipe'),encoding='utf-8')
al=p/'src/td_project/AC201_tf_hdmi.al';al.write_text(al.read_text(encoding='utf-8-sig').replace('/player_pcm_waveform_keyfreeze/','/player_transition_wipe/'),encoding='utf-8')
for name in ['top_tf_hdmi_audio.v','player_status_monitor.v']:
 f=p/'src/user_source/hdl_source'/name;f.write_text(f.read_text(encoding='utf-8-sig').replace('C11204','C11205'),encoding='utf-8')
model=p/'build/model';model.mkdir(parents=True)
for f in (parent/'build/model').iterdir():
 if f.suffix in ['.ps1','.v','.hex','.json','.md','.py']:shutil.copy2(f,model/f.name)
for f in model.glob('*.ps1'):f.write_text(f.read_text(encoding='utf-8-sig').replace('/player_pcm_waveform_keyfreeze/','/player_transition_wipe/'),encoding='utf-8')
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
docs=DOCS_ROOT / '开发记录';state=docs/'当前状态.md';text=state.read_text(encoding='utf-8')
msg=now+' C11205独立player_transition_wipe从C11204 verified158文件逐项SHA核验后复制src/scripts，无旧数据库。拟上下擦除每帧8行（480word/行×8=3840word为256word批次整数），一条输出帧流按区域换读地址，不增加双路全帧读取；loader等待显示端最终读请求ACK后才复用旧buffer。RTL/模型开发中，尚无新bit/板测；成功基线C11204带已知波形显示问题。'
state.write_text(text.replace('## 当前阶段','## 当前阶段\n\n**'+msg+'**',1),encoding='utf-8')
log=docs/'工作日志/2026-10-12.md';log.write_text(log.read_text(encoding='utf-8')+'\n### '+now+'｜T26/T27擦除转场开发启动｜进行中\n\n- '+msg+'\n- 前序luna实际loader/OSD/帧读取审计已保存build/audit/buffer_transition_audit.md；其逐列双片段方案为建议未实现，本轮选8行对齐的上下擦除以减少重启/过读。控制器加明确显示ACK、每帧metadata锁存；不把加密SDRAM核的随机读取契约当作已证明，后续定向模型和上板仍必要。\n- 未JTAG/TF/Flash，下一步ownership/地址映射模型、原接口回归及TD新候选构建。\n',encoding='utf-8')
print('VERIFIED158_PARENT_HASH_PASS_C11205_READY')
