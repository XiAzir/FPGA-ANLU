from pathlib import Path
import argparse,json,shutil,re,hashlib
from datetime import datetime

root=Path(__file__).resolve().parents[2]
c=root/'development/player_spectrum_resource_80'

def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def area(p):
    s=p.read_text(encoding='utf-8',errors='replace');result={}
    for key in ('lut','reg','le','bram9k','dsp','Total_luts'):
        match=re.search(r'^#'+key+r'\s+(\d+)',s,re.M)
        if match:result[key]=int(match[1])
    return result

def main():
    ap=argparse.ArgumentParser();ap.add_argument('name');ap.add_argument('--notes',default='');a=ap.parse_args()
    target=c/'build/attempts'/a.name;target.mkdir(parents=True,exist_ok=False)
    for folder in ('src','scripts','sim'):
        shutil.copytree(c/folder,target/folder,ignore=shutil.ignore_patterns('*.db','*.dmp','*.vvp','__pycache__','work','*_Runs'))
    shutil.copytree(c/'build/manual',target/'manual')
    for folder in ('audit','gate_verify'):
        if (c/'build'/folder).exists():
            shutil.copytree(c/'build'/folder,target/folder)
    evidence=c/'build/manual/stage_evidence'
    syn=read(evidence/'latest_synthesis.json')
    result={'created':datetime.now().astimezone().isoformat(),'notes':a.notes,'synthesis':syn,'gate':area(c/'build/manual/AC201_tf_hdmi_gate.area')}
    phy=evidence/'latest_physical.json'
    if phy.exists():
        pointer=read(phy);record=read(evidence/pointer['record']);result['physical']=pointer
        bound=pointer['status']=='success' and record['synthesisRunId']==syn['runId']
        result['physical_bound_to_selected_synthesis']=bound
        if bound:
            qor=c/'src/td_project/route.qor'
            shutil.copy2(qor,target/'route.qor')
            result['slices']=int(re.search(r'#slices\s*\|\s*(\d+)',qor.read_text())[1])
            result['physical_area']=area(c/'build/manual/AC201_tf_hdmi_phy.area')
            result['timing']=(c/'build/manual/AC201_tf_hdmi_phy.ts').read_text().strip()
    (target/'summary.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps(result,ensure_ascii=False))

if __name__=='__main__':main()
