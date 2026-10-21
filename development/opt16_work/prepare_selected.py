from pathlib import Path
import hashlib,json,argparse
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent
C=R/'development/player_spectrum_opt16';P=R/'development/player_spectrum_spi12p5/src/user_source/hdl_source'
D=W/'selected';D.mkdir(exist_ok=True)
V=W/'small/validated_scaler/c11315'
sources={
 'bmp_scale_engine.v':V/'bmp_scale_engine.v',
 'tf_bmp_file_player.v':V/'tf_bmp_file_player_validated.v',
 'fat32_catalog.v':W/'catalog/fat32_catalog_candidate_fixed_flags.v'}
expected={'bmp_scale_engine.v':'f3d77c0dcaac1a43c59e30deb51b06988a81a9d91f0c6135f0eb17158057c04c',
 'tf_bmp_file_player.v':'d5f7fdba6c944d62e00c1b92e2084f1b644069b33812bfb5c07d434e260fdbc8',
 'fat32_catalog.v':'c73d62f6a4eae3bcedcf60f40ff29898e5c3489655e171d6b373abd670d1151a'}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
selected={}
for name,p in sources.items():
 assert sha(p)==expected[name],name
 s=p.read_text(encoding='utf-8-sig')
 if name=='tf_bmp_file_player.v':
  s=s.replace('module tf_bmp_file_player_validated #','module tf_bmp_file_player #')
  baseline=(P/name).read_text(encoding='utf-8-sig')
  assert s==baseline.replace('bmp_scale_engine #(.FRAME_WIDTH','bmp_scale_engine #(.HEADER_VALIDATED(1),.FRAME_WIDTH')
 if name=='tf_bmp_file_player.v':(D/name).write_text(s,encoding='utf-8')
 else:(D/name).write_bytes(p.read_bytes())
 selected['user_source/hdl_source/'+name]={'source':str(D/name),'sha256':sha(D/name),'experiment_source':str(p),'experiment_source_sha256':sha(p)}
(D/'selection.json').write_text(json.dumps(selected,indent=2))
a=argparse.ArgumentParser();a.add_argument('--install',action='store_true');args=a.parse_args()
if args.install:
 for path,entry in selected.items():(C/'src'/path).write_bytes(Path(entry['source']).read_bytes())
 (C/'build/selected_changes.json').write_text(json.dumps(selected,indent=2))
print(json.dumps(selected))
