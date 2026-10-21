from pathlib import Path
import zipfile, hashlib, json, shutil, subprocess

ROOT=Path(__file__).resolve().parents[2]
DOCS=Path('E:/QQ CACHE/Download/安路资料')
ZIP=Path('C:/Users/PENGYUHAO/Downloads/ANLU_C11312_Resource_Agent_Handoff_20261020.zip')
RECORD=DOCS/'开发记录/专题记录/资源优化/C11313_20261020'
RECORD.mkdir(parents=True,exist_ok=True)
source=ROOT/'development/player_spectrum_trace'
target=ROOT/'development/player_spectrum_resource_fit'
if target.exists():
    raise SystemExit('Candidate already exists; refusing overwrite')
with zipfile.ZipFile(ZIP) as z:
    # Keep the task and its provenance; diagnostic history remains in the supplied ZIP.
    selected=[n for n in z.namelist() if any('/'+p+'/' in n for p in ('01_task','02_data','03_tools')) or n.endswith(('README_先看我.md','SHA256SUMS.txt'))]
    checks={line.split('  ',1)[1]:line.split('  ',1)[0].lower() for line in z.read('ANLU_C11312_Resource_Agent_Handoff/SHA256SUMS.txt').decode('utf-8-sig').splitlines() if '  ' in line}
    for n in selected:
        rel=n.split('/',1)[1]
        b=z.read(n)
        if rel in checks:
            assert hashlib.sha256(b).hexdigest()==checks[rel],rel
        dest=(ROOT/'development/resource_opt_work/handoff_tools'/Path(rel).name) if '/03_tools/' in n else (RECORD/'交接摘录'/rel)
        dest.parent.mkdir(parents=True,exist_ok=True)
        dest.write_bytes(b)
snap=[]
for folder in ('src','sim','scripts'):
    for p in sorted((source/folder).rglob('*')):
        if p.is_file() and not any(q in p.parts for q in ('__pycache__','work')):
            snap.append({'path':p.relative_to(source).as_posix(),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
    shutil.copytree(source/folder,target/folder,ignore=shutil.ignore_patterns('__pycache__','*.db','*.vvp','*.dmp','*_Runs','work'))
for folder in ('scripts','sim'):
    for p in (target/folder).rglob('*'):
        if p.is_file() and p.suffix in ('.ps1','.tcl','.py'):
            s=p.read_text(encoding='utf-8-sig')
            p.write_text(s.replace('player_spectrum_trace','player_spectrum_resource_fit'),encoding='utf-8')
p=target/'src/td_project/AC201_tf_hdmi.al'
p.write_text(p.read_text(encoding='utf-8-sig').replace('player_spectrum_trace','player_spectrum_resource_fit'),encoding='utf-8')
# Old report files under src are reference artifacts, not candidate results.
for name in ('gate.qor','place.qor','route.qor','final_timing.rpt','top_inst.bid'):
    p=target/'src/td_project'/name
    if p.exists(): p.unlink()
out=target/'build/baseline'
out.mkdir(parents=True)
(out/'source_sha256.json').write_text(json.dumps(snap,indent=2),encoding='utf-8')
for name in ('AC201_tf_hdmi_phy.area','AC201_tf_hdmi_phy.ts','AC201_tf_hdmi_chk.timing','AC201_tf_hdmi_exception.timing'):
    shutil.copy2(source/'build/manual'/name,out/name)
shutil.copy2(source/'src/td_project/route.qor',out/'route.qor')
provenance={'zip_path':str(ZIP),'zip_sha256':hashlib.sha256(ZIP.read_bytes()).hexdigest(),'selected_files':selected,'code_head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),'docs_head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=DOCS,text=True).strip(),'candidate':str(target),'source':str(source),'target_slice_85':8330,'target_slice_80':7840}
(RECORD/'import_receipt.json').write_text(json.dumps(provenance,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'candidate':str(target),'frozen_files':len(snap),'selected_files':len(selected)},indent=2))
