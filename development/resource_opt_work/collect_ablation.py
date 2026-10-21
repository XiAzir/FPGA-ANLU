"""Extract device utilization consistently from TD area reports."""
from pathlib import Path
import re,json,hashlib
ROOT=Path(__file__).resolve().parents[2]
CANDIDATE=ROOT/'development/player_spectrum_resource_fit'

def area(path):
    text=path.read_text(encoding='utf-8',errors='replace')
    result={}
    for key,pattern in [('device_lut','lut'),('device_reg','reg'),('le','le'),('bram9k','bram9k'),('dsp','dsp'),('generic_luts','Total_luts')]:
        match=re.search(r'^\s*#'+pattern+r'\s+(\d+)',text,re.M)
        if match:result[key]=int(match[1])
    result['report']=str(path)
    result['sha256']=hashlib.sha256(path.read_bytes()).hexdigest()
    return result

def collect():
    records=[dict(variant='00_C11312_reference_gate',**area(ROOT/'development/player_spectrum_trace/build/manual/AC201_tf_hdmi_gate.area'))]
    for folder in sorted((CANDIDATE/'build/attempts').glob('*')):
        report=folder/'manual/AC201_tf_hdmi_gate.area'
        if report.exists():
            pointer=folder/'manual/stage_evidence/latest_synthesis.json'
            status=json.loads(pointer.read_text(encoding='utf-8-sig'))['status'] if pointer.exists() else 'UNKNOWN'
            if (folder/'interruption.json').exists():
                status='INTERRUPTED'
            elif folder.name.endswith('_rejected'):
                status='REJECTED_SOURCE_SCOPE'
            records.append(dict(variant=folder.name,synthesis_evidence_status=status,**area(report)))
    latest=CANDIDATE/'build/manual/AC201_tf_hdmi_gate.area'
    if latest.exists():
        pointer=CANDIDATE/'build/manual/stage_evidence/latest_synthesis.json'
        status=json.loads(pointer.read_text(encoding='utf-8-sig'))['status']
        records.append(dict(variant='latest_gate',synthesis_evidence_status=status,**area(latest)))
    records.append(dict(variant='C11312_reference_physical',**area(ROOT/'development/player_spectrum_trace/build/manual/AC201_tf_hdmi_phy.area')))
    final=CANDIDATE/'build/manual/AC201_tf_hdmi_phy.area'
    if final.exists():records.append(dict(variant='latest_physical',**area(final)))
    output={'metric':'device_lut/device_reg come from Utilization Statistics; generic_luts from LUT Statistics; gate and physical stay separate','full_top':records,'standalone':[]}
    for family,subfolder in [('mapper','mapper_synthesis/runs'),('mapper_aligned','mapper_synthesis/or_ablation'),('bmp','bmp_synthesis/runs')]:
        for report in sorted((Path(__file__).parent/subfolder).rglob('gate.area')):
            output['standalone'].append(dict(family=family,variant=report.parent.parent.name,**area(report)))
    (CANDIDATE/'build/ablation_summary.json').write_text(json.dumps(output,ensure_ascii=False,indent=2),encoding='utf-8')
    for item in records:print(item['variant'],{k:item.get(k) for k in ('device_lut','device_reg','bram9k','dsp')})
    return output

if __name__=='__main__': collect()
