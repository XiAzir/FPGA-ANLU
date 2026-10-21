from pathlib import Path
import json,hashlib,argparse,re
R=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
C=R/'development/player_spectrum_opt16';P=R/'development/player_spectrum_spi12p5'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def area(p):
 s=p.read_text();return {k:int(re.search(r'^\s*#'+k+r'\s+(\d+)',s,re.M)[1]) for k in ('lut','reg','bram9k','dsp')}
def perf(p):
 s=read(p/'summary.json');assert s['status']=='SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS'
 x=read(p/'spi_performance.json');assert x['status']=='PASS' and x['min_sclk_period_ns']==80 and x['crc_bad']==0 and x['underruns']==0
 return {'summary':s,'performance':x,'performance_sha256':sha(p/'spi_performance.json'),'source_receipt_sha256':sha(p/'source_receipt.json')}
a=argparse.ArgumentParser();a.add_argument('--system',required=True,type=Path);a.add_argument('--baseline',required=True,type=Path);args=a.parse_args()
v={'baseline_C11315':{'slices':7632,'physical_area':area(P/'build/manual/AC201_tf_hdmi_phy.area'),'gate_area':area(P/'build/manual/AC201_tf_hdmi_gate.area'),**perf(args.baseline)},'fast_C11316':{'slices':int(re.search(r'#slices\s*\|\s*(\d+)',(C/'src/td_project/route.qor').read_text())[1]),'physical_area':area(C/'build/manual/AC201_tf_hdmi_phy.area'),'gate_area':area(C/'build/manual/AC201_tf_hdmi_gate.area'),**perf(args.system)}}
x=dict(v['baseline_C11315']['performance']);y=dict(v['fast_C11316']['performance']);x.pop('variant');y.pop('variant');assert x==y,(x,y)
experiments=[]
for folder in ('small','mapper','catalog','scaler'):
 d=R/'development/opt16_work'/folder
 files=[p for p in d.rglob('*') if p.is_file() and (p.name in ('README.md','summary.csv','area_summary.json','matrix_summary.json','source_receipt.json') or p.name=='gate.area')]
 experiments.append({'name':folder,'evidence':[{'path':str(p),'sha256':sha(p)} for p in files]})
result={'status':'PASS','hardware_status':'BOARD_NOT_TESTED','variants':v,'experiments':experiments,'selected_changes':read(C/'build/selected_changes.json'),'slice_saved':7632-v['fast_C11316']['slices'],'limits':'nominal replay clocks and digital SD/SDRAM models; no hardware timing claim'}
assert result['slice_saved']>0,result['slice_saved']
(C/'build/ablation_summary.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print('PASS saved',result['slice_saved'])
