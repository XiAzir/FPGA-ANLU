from pathlib import Path
import hashlib,json
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17';W=Path(__file__).parent;H=C/'src/user_source/hdl_source'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert json.loads((C/'build/attempts/A02_verified_offline/result.json').read_text(encoding='utf-8-sig'))['status']=='OFFLINE_VERIFIED_FALLBACK'
p=W/'shared_mapper/candidate.v';assert sha(p)==sha(W/'mapper_tests/candidate_as_tested.v')=='b9a9e3d7fedcea5ecf7b1d3272fd5846c54db2cd2c20eab4bde56350a5eb8993'
s=json.loads((C/'build/selected_changes.json').read_text(encoding='utf-8-sig'))
for name in ('fat32_file_sector.v','sd_sector_arbiter.v'):
 q=H/name
 s['user_source/hdl_source/'+name]={'action':'remove','parent_sha256':sha(R/'development/player_spectrum_opt16/src/user_source/hdl_source'/name),'reason':'Replaced by one dual-client execution engine; original retained in parent/reference only'}
 q.unlink()
for source,relative,reason in [(p,'user_source/hdl_source/fat32_dual_file_sector.v','Shared FAT execution and sector arbitration, independent client context and watchdog'),(W/'integration/top_tf_hdmi_audio.v','user_source/hdl_source/top_tf_hdmi_audio.v','Replace both mapper instances and arbiter with shared core; remove unused physical-client wires; Build ID C11317'),(W/'integration/AC201_tf_hdmi.al','td_project/AC201_tf_hdmi.al','Replace mapper source and remove retired arbiter source; unchanged constraints/IP recipe')]:
 q=C/'src'/relative;q.write_bytes(source.read_bytes());s[relative]={'source':str(source),'sha256':sha(source),'reason':reason}
(C/'build/selected_changes.json').write_text(json.dumps(s,indent=2));print('A03 shared FAT + held FIFO installed')
