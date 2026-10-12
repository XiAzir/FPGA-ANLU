from pathlib import Path
import hashlib, json, shutil, datetime
root = Path('E:/VSCODE-project/FPGA-ANLU')
project = root / 'development/player_pcm_waveform_keyfreeze'
parent = root / 'development/player_pcm_waveform_freeze/checkpoints/waveform_freeze_20261012_candidate'
def sha(f): return hashlib.sha256(f.read_bytes()).hexdigest().upper()
assert sha(parent/'manifest.json') == 'FB9BE10F216026114DB434CEDFAC99545054CF871B1B5BC6C6F8212AC951861B'
manifest = json.loads((parent/'manifest.json').read_text(encoding='utf-8-sig'))
for e in manifest: assert sha(parent/e['path']) == e['sha256']
assert not (project/'src').exists()
for name in ['src', 'scripts']: shutil.copytree(parent/name, project/name)
for f in (project/'scripts').rglob('*'):
    if f.is_file(): f.write_text(f.read_text(encoding='utf-8-sig').replace('player_pcm_waveform_freeze', 'player_pcm_waveform_keyfreeze'), encoding='utf-8')
al=project/'src/td_project/AC201_tf_hdmi.al'
al.write_text(al.read_text(encoding='utf-8-sig').replace('/player_pcm_waveform_freeze/', '/player_pcm_waveform_keyfreeze/'), encoding='utf-8')
for name in ['top_tf_hdmi_audio.v', 'player_status_monitor.v']:
    f=project/'src/user_source/hdl_source'/name
    f.write_text(f.read_text(encoding='utf-8-sig').replace('C11203', 'C11204'), encoding='utf-8')
model=project/'build/model'; model.mkdir(parents=True)
for name in ['tb_player_pcm_waveform.v', 'run_waveform_model.ps1', 'tb_waveform_integration.v', 'run_integration.ps1', 'music_pcm.hex', 'music_bins.hex', 'music_reference.json']:
    shutil.copy2(parent/'build/model'/name, model/name)
for name in ['run_waveform_model.ps1','run_integration.ps1']:
    f=model/name; f.write_text(f.read_text(encoding='utf-8-sig').replace('/player_pcm_waveform_freeze/', '/player_pcm_waveform_keyfreeze/'), encoding='utf-8')
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
message=f'{now} 用户要求将freeze绑按键。独立player_pcm_waveform_keyfreeze/C11204从C11203冻结143文件核验后隔离复制，不复制数据库。拟PLAY双键短按切冻结/恢复，双键长按保留复默认、长KEY1换源解除冻结；在VS持有当前front，取消144000事件自动冻结。开发/模型/构建进行中，无新bit/板测，成功基线C11201；未JTAG/TF/Flash。'
state=docs/'当前状态.md'; state.write_text(state.read_text(encoding='utf-8').replace('## 当前阶段','## 当前阶段\n\n**'+message+'**',1), encoding='utf-8')
log=docs/'工作日志/2026-10-12.md'; log.write_text(log.read_text(encoding='utf-8')+'\n### '+now+'｜C11204按键冻结启动｜进行中\n\n- '+message+'\n- 下一步手势仲裁、VS前台冻结/恢复/换源模型和TD原约束构建，待完成后交付。\n',encoding='utf-8')
print('PARENT143_HASH_PASS_C11204_PROJECT_READY')
