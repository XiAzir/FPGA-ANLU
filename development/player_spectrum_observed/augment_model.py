from pathlib import Path
import json,hashlib
p=Path(__file__).resolve().parent
root=p.parents[1]
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
f=p/'build/model/model_result.json'
data=json.loads(f.read_text(encoding='utf-8'))
for item in data['bound_sources'].values():assert sha(root/item['path'])==item['sha256']
log=p/'build/model/spectrum_diag_run.log'
assert 'PASS spectrum_diag nonzero_coefficients=1 complete_frames=1 nonzero_band_max=1 front_nonzero=1 hold_keeps_analysis=1 source_reset=1 global_reset=1' in log.read_text(encoding='utf-8')
for key,path in [('telemetry_tb',p/'sim/tb_spectrum_diag.v'),('telemetry_runner',p/'sim/run_spectrum_diag.ps1'),('model_augmenter',Path(__file__))]:
    data['bound_sources'][key]={'path':path.relative_to(root).as_posix(),'sha256':sha(path)}
data['results']['passive_spectrum_telemetry']={'status':'PASS','checks':['coefficients nonzero','completed FFT count','nonzero frame maximum','nonzero displayed front','HOLD keeps FFT running','source change resets telemetry','global reset clears telemetry'],
 'compile_log':str(p/'build/model/spectrum_diag_compile.log'),'run_log':str(log),'sim_kind':'PRIVATE_ROM_BEHAVIORAL_SIM; not board coefficient readback'}
data['telemetry_contract']={'B':'24-bit saturating completed FFT frame count, reset on source change',
 'C':'flags[7:0] then max_band_value[15:0] from last complete FFT frame',
 'Cflags_bits7_to0':['PCM seen','FFT frame seen','nonzero band seen','Hann nonzero seen','twiddle nonzero seen','front commit seen','nonzero front seen','front frozen']}
f.write_text(json.dumps(data,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'status':'PASS','bound_inputs':len(data['bound_sources']),'telemetry':'PASS'},indent=2))
