from pathlib import Path
import json,hashlib,argparse,re
R=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
C=R/'development/player_spectrum_ctrl18';P=R/'development/player_spectrum_arch17';W=Path(__file__).parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def area(p):
 s=p.read_text();return {k:int(re.search(r'^\s*#'+k+r'\s+(\d+)',s,re.M)[1]) for k in ('lut','reg','bram9k','dsp')}
def perf(p):
 s=read(p/'summary.json');assert s['status']=='SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS'
 x=read(p/'spi_performance.json');assert x['status']=='PASS' and x['min_sclk_period_ns']==80 and x['crc_bad']==0 and x['underruns']==0
 return {'summary':s,'performance':x,'performance_sha256':sha(p/'spi_performance.json'),'source_receipt_sha256':sha(p/'source_receipt.json')}
a=argparse.ArgumentParser();a.add_argument('--system',required=True,type=Path);a.add_argument('--baseline',required=True,type=Path);args=a.parse_args()
slices=int(re.search(r'#slices\s*\|\s*(\d+)',(C/'src/td_project/route.qor').read_text())[1])
v={'baseline_C11317':{'slices':7231,'physical_area':area(P/'build/manual/AC201_tf_hdmi_phy.area'),'gate_area':area(P/'build/manual/AC201_tf_hdmi_gate.area'),**perf(args.baseline)},'fast_C11318':{'slices':slices,'physical_area':area(C/'build/manual/AC201_tf_hdmi_phy.area'),'gate_area':area(C/'build/manual/AC201_tf_hdmi_gate.area'),**perf(args.system)}}
x=dict(v['baseline_C11317']['performance']);y=dict(v['fast_C11318']['performance']);x.pop('variant');y.pop('variant')
x.pop('service_observation',None);y.pop('service_observation',None)
shared=(C/'src/user_source/hdl_source/fat32_dual_file_sector.v').is_file()
if not shared:assert x==y,(x,y)
performance_delta={k:y[k]-x[k] for k in x.keys()&y.keys() if isinstance(x[k],(int,float)) and isinstance(y[k],(int,float))}
experiments=[]
for folder in ('key_events','status_domain','integration_audit'):
 d=W/folder
 files=[p for p in d.rglob('*') if p.is_file() and (p.name in ('README.md','summary.json','source_receipt.json','area_summary.json','area_summary.csv','td_manifest.json') or p.name=='gate.area')]
 experiments.append({'name':folder,'evidence':[{'path':str(p),'sha256':sha(p)} for p in files]})
attempts=[]
for p in sorted((C/'build/attempts').glob('*/result.json')):attempts.append({'path':str(p),'sha256':sha(p),'result':read(p)})
result={'status':'PASS','hardware_status':'BOARD_NOT_TESTED','variants':v,'experiments':experiments,'attempts':attempts,'selected_changes':read(C/'build/selected_changes.json'),'slice_saved':7231-slices,'slice_saved_vs_same_id_control':7050-slices,'shared_execution':shared,'performance_numeric_delta':performance_delta,'performance_definition':'Both C11317 and C11318 use the shared mapper. Per-client service starts at physical issued-sector time in both variants; all reported numeric performance fields compare directly.','limits':'nominal replay clocks and digital SD/SDRAM models; board/full SDF pending'}
assert result['slice_saved']>0,result['slice_saved']
(C/'build/ablation_summary.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print('ABLATION PASS saved',result['slice_saved'])
