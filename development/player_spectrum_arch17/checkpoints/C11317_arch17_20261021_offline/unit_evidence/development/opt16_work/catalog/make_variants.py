from __future__ import annotations
import hashlib, json
from pathlib import Path
ROOT=Path(__file__).resolve().parent
BASE=(ROOT/'fat32_catalog_baseline.v').read_text(encoding='utf-8')
OUT=ROOT/'variants'; OUT.mkdir(exist_ok=True)
FIELDS={
'bps':{'regs':('bps_lo','bps_hi'),'flag':'bps_fixed_valid','byte':[(11,'(sd_data==0)'),(12,'bps_fixed_valid && (sd_data==2)')],'replace':['bps_lo==0 && bps_hi==2','bps_lo!=0 || bps_hi!=2']},
'rootent':{'regs':('rootent0','rootent1'),'flag':'rootent_fixed_valid','byte':[(17,'(sd_data==0)'),(18,'rootent_fixed_valid && (sd_data==0)')],'replace':['{rootent1,rootent0}==0','{rootent1,rootent0}!=0']},
'fat16':{'regs':('fat16_0','fat16_1'),'flag':'fat16_fixed_valid','byte':[(22,'(sd_data==0)'),(23,'fat16_fixed_valid && (sd_data==0)')],'replace':['fat16_0==0 && fat16_1==0','fat16_0!=0 || fat16_1!=0']},
'version':{'regs':('version_lo','version_hi'),'flag':'version_fixed_valid','byte':[(42,'(sd_data==0)'),(43,'version_fixed_valid && (sd_data==0)')],'replace':['version_lo==0 && version_hi==0','version_lo!=0 || version_hi!=0']}}
def render(mask):
 chosen=[n for b,n in enumerate(FIELDS) if mask&(1<<b)]; text=BASE
 marker='reg [7:0] signature_lo, signature_hi;'
 text=text.replace(marker,marker+'\n'+'\n'.join('reg '+FIELDS[n]['flag']+';' for n in chosen),1)
 decl='reg [7:0] bps_lo, bps_hi, spc, reserved_lo, reserved_hi, fats, rootent0, rootent1;\nreg [7:0] fat16_0, fat16_1, total16_0,total16_1, total32_b[0:3];\nreg [7:0] fatsz32_b[0:3], root_b[0:3], extflags_lo, extflags_hi, version_lo,version_hi;'
 repl=decl
 for n in chosen:
  for reg in FIELDS[n]['regs']:
   repl=repl.replace(reg+', ','').replace(','+reg,'')
 text=text.replace(decl,repl,1)
 if 'rootent' in chosen: text=text.replace('fats, rootent1;','fats;',1)
 if 'version' in chosen: text=text.replace(', version_lo;',';',1)
 for n in chosen:
  d=FIELDS[n]
  for index,reg in enumerate(d['regs']):
   old=reg+'<=0;'; replacement=d['flag']+'<=0;' if index==0 else ''
   if old not in text: raise ValueError(f'reset missing {n}: {old}')
   text=text.replace(old,replacement,1)
  for ix,expr in d['byte']:
   reg=d['regs'][0] if ix in (11,17,22,42) else d['regs'][1]
   old=f'{ix}: {reg}<=sd_data;'; new=f'{ix}: {d["flag"]}<={expr};'
   if old not in text: raise ValueError(f'byte missing {n}: {old}')
   text=text.replace(old,new,1)
  for old in d['replace']:
   if old not in text: raise ValueError(f'compare missing {n}: {old}')
   new=d['flag'] if '==' in old or '&&' in old else '!'+d['flag']
   text=text.replace(old,new,1)
 return text
manifest=[]
for mask in range(1,16):
 tag='+'.join(n for b,n in enumerate(FIELDS) if mask&(1<<b)); path=OUT/f'fat32_catalog_{tag}.v'
 path.write_text(render(mask),encoding='utf-8',newline='\n')
 manifest.append({'mask':mask,'tag':tag,'file':path.name,'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
(OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print(json.dumps(manifest,indent=2))



