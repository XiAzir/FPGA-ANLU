import hashlib,json,re
from pathlib import Path
root=Path(__file__).resolve().parent/'synthesis_loader'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
summary={"device":"EG4S20BG256","clock_period_ns":20,"strategy":"AreaHigh: gate add_map_lut_struct=high, map_mode=area_prior, opt_area=high, map_mux41=on, multi_thread_mapping=partition; rtl resource_sharing=auto, shifter_style=shifter_reg","variants":{}}
for name in ('base','header'):
 d=root/name; area=(d/'reports/gate.area').read_text(encoding='utf-8-sig'); manifest=json.loads((root/'manifest.json').read_text(encoding='utf-8'))[name]
 def one(pattern):
  m=re.search(pattern,area,re.M)
  if not m: raise SystemExit(f'{name}: missing {pattern}')
  return int(m.group(1))
 summary['variants'][name]={"source_sha256":manifest,"generic_lut":one(r'^#Total_luts\s+(\d+)'),"device_lut":one(r'^#lut\s+(\d+)\s+out of'),"device_reg":one(r'^#reg\s+(\d+)\s+out of'),"bram":one(r'^#bram\s+(\d+)\s+out of'),"dsp":one(r'^#dsp\s+(\d+)\s+out of'),"gate_area_sha256":sha(d/'reports/gate.area'),"console_sha256":sha(d/'console.log')}
b=json.loads(json.dumps(summary['variants']['base'])); h=summary['variants']['header']
summary['delta_header_minus_base']={k:h[k]-b[k] for k in ('generic_lut','device_lut','device_reg','bram','dsp')}
(root/'area_summary.json').write_text(json.dumps(summary,indent=2)+'\n',encoding='utf-8')
print(json.dumps(summary['delta_header_minus_base']))

