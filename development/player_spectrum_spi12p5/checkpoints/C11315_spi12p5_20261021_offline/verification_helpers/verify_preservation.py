from pathlib import Path
import hashlib,json,difflib
R=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
P=R/'development/player_spectrum_resource_80';C=R/'development/player_spectrum_spi12p5'
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=read(C/'build/baseline/C11314_source_sha256.json')
assert all(sha(P/e['path'])==e['sha256'] for e in snapshot)
manifest=P/'checkpoints/C11314_resource80_20261021_offline/manifest.json'
assert sha(manifest)=='3ac05765fdd42deeb4b7b6fa14239465d0d3faffefef7ee52172e16c561d515f'
entries=read(manifest)['files']
assert all(sha(manifest.parent/e['path'])==e['sha256'] for e in entries)
bits={}
for name in ('bmp_scale.bit','spectrum_trace.bit','spectrum_resource_fit.bit','spectrum_resource_80.bit'):
 expected=read(P/'build/preservation.json')['protected_bits'].get(name)
 if name=='spectrum_resource_80.bit':expected='60ed79eecfcbd271bbc2b9a9333d5da03668e00b580a6be751ebcd61f0fa4d28'
 assert sha(R/'download'/name)==expected,name
 bits[name]=expected
changed=[];patch=[]
allowed={'user_source/hdl_source/top_tf_hdmi_audio.v','user_source/hdl_source/player_status_monitor.v','user_source/hdl_source/SD/sd_card_sec_read_write.v','td_project/AC201_tf_hdmi.al'}
for e in read(P/'build/manual/build_source_scope.json'):
 path=e['path'].replace('\\','/')
 if sha(C/'src'/path)!=e['sha256'].lower():
  assert path in allowed,path
  changed.append(path)
  a=(P/'src'/path).read_text(encoding='utf-8-sig');b=(C/'src'/path).read_text(encoding='utf-8-sig')
  patch.extend(difflib.unified_diff(a.splitlines(True),b.splitlines(True),fromfile='C11314/'+path,tofile='C11315/'+path))
  expected=a.replace('player_spectrum_resource_80','player_spectrum_spi12p5') if path.endswith('.al') else a.replace("24'hC11314","24'hC11315")
  if path.endswith('top_tf_hdmi_audio.v'):expected=expected.replace('.SPI_HIGH_SPEED_DIV(2)','.SPI_HIGH_SPEED_DIV(0)')
  if path.endswith('sd_card_sec_read_write.v'):expected=expected.replace("\t\t\t\tspi_clk_div <= 16'd0;","\t\t\t\tspi_clk_div <= SPI_HIGH_SPEED_DIV[15:0];")
  assert b.rstrip('\n')==expected.rstrip('\n'),path
result={'status':'PASS','parent_source_files':len(snapshot),'parent_frozen_files':len(entries),
 'parent_manifest_sha256':sha(manifest),'protected_bits':bits,'changed_candidate_scope':changed,
 'delta':'top DIV2->0; controller steady-state divider follows parameter; Build ID14->15; project location adjusted',
 'unchanged_configuration':'all remaining source scope, including constraints, PLL and PHY'}
(C/'build/preservation.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
(C/'build/source_delta.patch').write_text(''.join(patch),encoding='utf-8')
print(json.dumps(result))
