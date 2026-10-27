"""Bind the final C42 source changes to the board-confirmed C41 baseline."""
from pathlib import Path
import hashlib,json

ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'development/player_video41_refresh/src/user_source'
CAND=ROOT/'development/player_video42_sdram100/src/user_source'
allowed={
    'hdl_source/include/global_def.v','hdl_source/IP/sys_pll.v','hdl_source/IP/sys_pll.vhd',
    'hdl_source/IP/sys_pll.ipc','hdl_source/top_tf_hdmi_audio.v',
    'hdl_source/SD/frame_fifo_write.v','hdl_source/SD/frame_read_write.v',
    'hdl_source/SD/sdram.v','constraints_source/timing.sdc'}
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
before={p.relative_to(BASE).as_posix():sha(p) for p in BASE.rglob('*') if p.is_file()}
after={p.relative_to(CAND).as_posix():sha(p) for p in CAND.rglob('*') if p.is_file()}
assert before.keys()==after.keys()
changed={name for name in before if before[name]!=after[name]}
assert changed==allowed,(changed-allowed,allowed-changed)
record={'status':'PASS','baseline_bit_sha256':sha(ROOT/'download/video41_refresh.bit'),
        'changes':[{'path':name,'before':before[name],'after':after[name]} for name in sorted(changed)],
        'unchanged_user_sources':len(before)-len(changed),'candidate_sources':after,
        'protected_controller_files_identical':all(before[n]==after[n] for n in before if n.endswith('.enc.v'))}
assert record['protected_controller_files_identical']
target=ROOT/'development/player_video42_sdram100/verification/source_audit.json'
target.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({k:v for k,v in record.items() if k!='candidate_sources'},ensure_ascii=False,indent=2))
