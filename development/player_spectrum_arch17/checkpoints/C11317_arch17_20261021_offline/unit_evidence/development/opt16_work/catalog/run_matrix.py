from __future__ import annotations
import json, shutil, subprocess, sys
from pathlib import Path
root=Path(__file__).resolve().parent
variants=json.loads((root/'variants'/'manifest.json').read_text(encoding='utf-8'))
iv=Path(r'E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe')
vvp=iv.with_name('vvp.exe')
summary=[]
for item in variants:
    tag=item['tag']; candidate=root/'variants'/item['file']
    print(f'BEGIN {tag}',flush=True)
    proc=subprocess.run([sys.executable,str(root/'run_extended_diff_variants.py'),str(iv),str(vvp),str(candidate)],capture_output=True,text=True)
    outdir=root/'build'/'matrix'/tag; outdir.mkdir(parents=True,exist_ok=True)
    for name in ('geometry_reference.log','geometry_shared36.log','names_reference.log','names_shared36.log','extended_diff_result.json'):
        src=root/'build'/name
        if src.exists(): shutil.copy2(src,outdir/name)
    (outdir/'driver_output.txt').write_text(proc.stdout+proc.stderr,encoding='utf-8')
    status={'tag':tag,'mask':item['mask'],'returncode':proc.returncode,'stdout':proc.stdout.strip(),'candidate_sha256':item['sha256']}
    summary.append(status); print(json.dumps(status),flush=True)
    if proc.returncode: break
(root/'build'/'matrix_summary.json').write_text(json.dumps(summary,indent=2)+'\n',encoding='utf-8')
if len(summary)!=len(variants) or any(x['returncode'] for x in summary): sys.exit(1)
