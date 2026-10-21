from pathlib import Path
from datetime import datetime
import hashlib,json,argparse,re
R=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
C=R/'development/player_spectrum_spi12p5'
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
ap=argparse.ArgumentParser();ap.add_argument('--system',type=Path,required=True);ap.add_argument('--slow',type=Path,required=True);a=ap.parse_args()
rows={}
for name,path in [('fast_C11315',a.system),('corrected_DIV2_reference',a.slow)]:
 summary=read(path/'summary.json');perf=read(path/'spi_performance.json')
 assert summary['status']=='SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS'
 assert perf['status']=='PASS' and perf['crc_bad']==0 and perf['underruns']==0
 assert perf['min_sclk_period_ns']==(80 if name=='fast_C11315' else 160)
 perf['card_service_payload_MBps']=perf['card_sectors']*512*1000/perf['card_total_service_ns']
 rows[name]={'path':str(path),'source_receipt_sha256':sha(path/'source_receipt.json'),
 'summary_sha256':sha(path/'summary.json'),'performance_sha256':sha(path/'spi_performance.json'),
 'service_trace_sha256':sha(path/'spi_service.csv'),'performance':perf,'FFT':summary['fft']}
fast=rows['fast_C11315']['performance'];slow=rows['corrected_DIV2_reference']['performance']
syn=read(C/'build/manual/stage_evidence/latest_synthesis.json')
phy=read(C/'build/manual/stage_evidence/latest_physical.json')
assert syn['status']=='success' and phy['status']=='success'
assert read(C/'build/manual/stage_evidence'/phy['record'])['synthesisRunId']==syn['runId']
result={'created':datetime.now().astimezone().isoformat(),'status':'PASS',
 'finding':'C11314 top DIV2 was overridden by steady-state hardcoded zero. Original production payload SCLK is nominal12.5MHz. DIV2 comparison uses the corrected parameter path and is a simulation reference.',
 'variants':rows,'service_throughput_ratio_fast_to_reference':fast['card_service_payload_MBps']/slow['card_service_payload_MBps'],
 'source_delta_patch_sha256':sha(C/'build/source_delta.patch'),
 'original_top_only_experiment':read(C/'build/attempts/01_top_div_only/summary.json'),
 'synthesis':syn,'physical':phy,
 'slices':int(re.search(r'#slices\s*\|\s*(\d+)',(C/'src/td_project/route.qor').read_text())[1]),
 'timing':(C/'build/manual/AC201_tf_hdmi_phy.ts').read_text().strip(),
 'hardware_status':'BOARD_NOT_TESTED'}
(C/'build/ablation_summary.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'status':'PASS','slices':result['slices'],'throughput_ratio':result['service_throughput_ratio_fast_to_reference'],'variants':{k:v['performance'] for k,v in rows.items()}},ensure_ascii=False))
