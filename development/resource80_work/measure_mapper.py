from pathlib import Path
import importlib.util,subprocess,json,re,hashlib
from mapper_proposal import apply
root=Path(__file__).resolve().parents[2]
here=Path(__file__).parent/'mapper_synthesis';here.mkdir(exist_ok=True)
spec=importlib.util.spec_from_file_location('original_standalone',root/'development/resource_opt_work/adder_threshold/prepare.py')
setup=importlib.util.module_from_spec(spec);spec.loader.exec_module(setup)
setup.ROOT=here;setup.RUNS=here/'runs';setup.RUNS.mkdir(exist_ok=True)
src=root/'development/player_spectrum_resource_fit/src/user_source/hdl_source/fat32_file_sector.v'
td='C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe'
flags={k:{v:v==k for v in ('counters','cluster_width','subtract','mask')} for k in ('counters','cluster_width','subtract','mask')}
flags['baseline']={k:False for k in ('counters','cluster_width','subtract','mask')}
flags['combined']={k:True for k in ('counters','cluster_width','subtract','mask')}
results=[]
for name in ('baseline','counters','cluster_width','subtract','mask','combined'):
    rtl=here/f'{name}.v';rtl.write_bytes(src.read_bytes());apply(rtl,**flags[name])
    info=setup.generate('fat32_file_sector',name,rtl)
    folder=Path(info['al']).parent.parent;tcl=folder/'run_syn.tcl'
    s=tcl.read_text(encoding='ascii')
    s=s.replace('  report_param -stage rtl',
      '  set_param gate add_map_lut_struct high\n  set_param gate map_mode area_prior\n'
      '  set_param gate multi_thread_mapping partition\n  set_param rtl resource_sharing auto\n'
      '  set_param rtl shifter_style shifter_reg\n  report_param -stage rtl',1)
    tcl.write_text(s,encoding='ascii')
    result=subprocess.run([td,tcl.as_posix()],cwd=folder,capture_output=True)
    log=result.stdout+result.stderr;(folder/'console.log').write_bytes(log)
    assert result.returncode==0 and b'SYNTHESIS_COMPLETE' in log,name
    report=folder/'reports/gate.area';text=report.read_text(encoding='utf-8',errors='replace')
    record=dict(variant=name,source_sha256=hashlib.sha256(rtl.read_bytes()).hexdigest(),
                device_lut=int(re.search(r'^#lut\s+(\d+)',text,re.M)[1]),
                device_reg=int(re.search(r'^#reg\s+(\d+)',text,re.M)[1]),
                generic_lut=int(re.search(r'^#Total_luts\s+(\d+)',text,re.M)[1]),report=str(report))
    results.append(record);print(json.dumps(record),flush=True)
    (here/'summary.json').write_text(json.dumps(results,indent=2),encoding='utf-8')
