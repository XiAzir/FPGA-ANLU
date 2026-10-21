from pathlib import Path
import csv,json,re,hashlib
root=Path(__file__).resolve().parent
manifest=json.loads((root/'td_area_high'/'batch_manifest.json').read_text(encoding='utf-8'))
records=[]
for item in manifest:
 p=root/'td_area_high'/item['tag']/'reports'/'gate.area'
 text=p.read_text(encoding='utf-8',errors='replace')
 get=lambda pat:int(re.search(pat,text,re.M)[1])
 records.append({'variant':item['tag'],'mask':item['mask'],'device_lut':get(r'^#lut\s+(\d+)'),
                 'device_reg':get(r'^#reg\s+(\d+)'),'generic_lut':get(r'^#Total_luts\s+(\d+)'),
                 'source_sha256_as_run':item['source_sha256'],'report':str(p)})
# The clean, independent rerun supersedes the batch all-fields source row.
clean=root/'td_area_high'/'clean_combined'/'reports'/'gate.area'
text=clean.read_text(encoding='utf-8',errors='replace')
cleanrow=next(x for x in records if x['mask']==15)
for k,pat in [('device_lut',r'^#lut\s+(\d+)'),('device_reg',r'^#reg\s+(\d+)'),('generic_lut',r'^#Total_luts\s+(\d+)')]: cleanrow[k]=int(re.search(pat,text,re.M)[1])
cleanrow['source_sha256_as_run']=hashlib.sha256((root/'fat32_catalog_candidate_fixed_flags.v').read_bytes()).hexdigest()
cleanrow['report']=str(clean)
(root/'td_area_high'/'area_summary.json').write_text(json.dumps(records,indent=2)+'\n',encoding='utf-8')
with (root/'td_area_high'/'area_summary.csv').open('w',newline='',encoding='utf-8-sig') as f:
 w=csv.DictWriter(f,fieldnames=list(records[0]));w.writeheader();w.writerows(records)
print(json.dumps(records,indent=2))
