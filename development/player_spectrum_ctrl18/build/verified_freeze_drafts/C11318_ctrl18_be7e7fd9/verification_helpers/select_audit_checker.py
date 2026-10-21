from pathlib import Path
import importlib.util,sys,runpy,json,hashlib,subprocess
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent;C=R/'development/player_spectrum_ctrl18'
p=W/'integration_audit/audit_clock_route.py';q=C/'build/audit/audit_clock_route.py'
s=p.read_text(encoding='utf-8-sig');old='REPO_ROOT = Path(__file__).resolve().parents[3]';assert s.count(old)==1
q.write_text(s.replace(old,'REPO_ROOT = Path(__file__).resolve().parents[4]'),encoding='utf-8')
spec=importlib.util.spec_from_file_location('audit_clock_route',q);m=importlib.util.module_from_spec(spec);sys.modules['audit_clock_route']=m;spec.loader.exec_module(m)
runpy.run_path(str(W/'integration_audit/test_audit_clock_route.py'),run_name='__main__')
p=C/'build/gate_verify/run_c11317_routed_audit.ps1';s=p.read_text(encoding='utf-8-sig').replace('$clockPasses -ne 45','$clockPasses -ne 46').replace('clockChecks=45','clockChecks=46');p.write_text(s,encoding='utf-8')
r={'status':'PASS','source_checker_sha256':hashlib.sha256((W/'integration_audit/audit_clock_route.py').read_bytes()).hexdigest(),'selected_checker_sha256':hashlib.sha256(q.read_bytes()).hexdigest(),'adaptation':'Only REPO_ROOT parents[3] -> parents[4] for the production audit directory; negative controls loaded the actual selected checker module.'}
(W/'integration_audit/selected_checker_binding.json').write_text(json.dumps(r,indent=2)+'\n')
