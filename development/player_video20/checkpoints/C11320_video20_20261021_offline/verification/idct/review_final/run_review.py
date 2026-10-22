from pathlib import Path
import hashlib,json,subprocess
root=Path(__file__).resolve().parent
repo=root.parents[4]
source=repo/'development/player_video19/src/user_source/hdl_source/jpeg'
shared=repo/'development/video20_work/shared_idct'
y_candidate=repo/'development/video20_work/idct/retime_shared/td/retime_dsp/src_v/jpeg_idct_y.v'
originals={
 'shared/jpeg_idct_early.v':shared/'jpeg_idct_early.v',
 'shared/jpeg_idct_transpose_early.v':shared/'jpeg_idct_transpose_early.v',
 'shared/tb_shared.sv':shared/'tb_shared.sv',
 'shared/run_equiv.py':shared/'run_equiv.py',
 'candidate/jpeg_idct_y.v':y_candidate,
 'reference/jpeg_idct.v':source/'jpeg_idct.v',
}
for name in ('jpeg_idct_ram.v','jpeg_idct_ram_dp.v','jpeg_idct_transpose.v','jpeg_idct_transpose_ram.v','jpeg_idct_x.v','jpeg_idct_y.v','jpeg_idct_fifo.v'):
 originals[f'reference/{name}']=source/name
hashes={k:hashlib.sha256(p.read_bytes()).hexdigest() for k,p in originals.items()}
(root/'source_hashes.json').write_text(json.dumps(hashes,indent=2)+'\n',encoding='utf-8')
bin=repo/'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
results={}
for variant,threshold in (('positive54',54),('negative53',53)):
 run=root/variant; frozen=run/'frozen';frozen.mkdir(parents=True,exist_ok=True)
 names=('jpeg_idct_ram.v','jpeg_idct_ram_dp.v','jpeg_idct_transpose.v','jpeg_idct_transpose_ram.v','jpeg_idct_x.v','jpeg_idct_y.v','jpeg_idct_fifo.v')
 for name in names: (frozen/name).write_bytes((source/name).read_bytes())
 reference=(source/'jpeg_idct.v').read_text(encoding='utf-8-sig').replace('module jpeg_idct\n','module jpeg_idct_reference\n',1)
 (frozen/'jpeg_idct_reference.v').write_text(reference,encoding='ascii')
 ytxt=y_candidate.read_text(encoding='utf-8-sig').replace('module jpeg_idct_y\n','module jpeg_idct_y_shared\n',1)
 (frozen/'jpeg_idct_y_shared.v').write_text(ytxt,encoding='ascii')
 trans=(shared/'jpeg_idct_transpose_early.v').read_text(encoding='utf-8-sig').replace('module jpeg_idct_transpose #','module jpeg_idct_transpose_early #',1)
 if threshold!=54:
  old="inport_idx_i == 6'd54"
  assert old in trans
  trans=trans.replace(old,f"inport_idx_i == 6'd{threshold}",1)
 (frozen/'jpeg_idct_transpose_early.v').write_text(trans,encoding='ascii')
 top=(shared/'jpeg_idct_early.v').read_text(encoding='utf-8-sig')
 top=top.replace('jpeg_idct_transpose #(.EARLY_READ(1))','jpeg_idct_transpose_early #(.EARLY_READ(1))',1)
 top=top.replace('jpeg_idct_y #(.OUT_SHIFT(11))','jpeg_idct_y_shared #(.OUT_SHIFT(11))',1)
 (frozen/'jpeg_idct_early_candidate.v').write_text(top,encoding='ascii')
 (frozen/'tb_shared.sv').write_bytes((shared/'tb_shared.sv').read_bytes())
 files=sorted(frozen.glob('*'))
 compile_cmd=[str(bin/'iverilog.exe'),'-g2012','-s','tb_shared','-o',str(run/'simv'),*[str(p) for p in files if p.suffix in ('.v','.sv')]]
 comp=subprocess.run(compile_cmd,cwd=run,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 (run/'compile.log').write_bytes(comp.stdout)
 if comp.returncode: raise SystemExit(f'{variant} compile failed:\n'+comp.stdout.decode(errors='replace'))
 sim=subprocess.run([str(bin/'vvp.exe'),str(run/'simv')],cwd=run,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 (run/'run.log').write_bytes(sim.stdout)
 output=sim.stdout.decode(errors='replace')
 if variant=='positive54':
  ok=sim.returncode==0 and 'SHARED_IDCT_PASS blocks=48 samples=3072' in output and 'READ_BEFORE_X_WRITE' not in output
 else:
  ok=sim.returncode!=0 and 'READ_BEFORE_X_WRITE' in output and 'SHARED_IDCT_PASS' not in output
 results[variant]={'threshold':threshold,'returncode':sim.returncode,'expected_result':ok,'summary':output[-1200:]}
 if not ok: raise SystemExit(f'{variant} unexpected result:\n{output[-3000:]}')
(root/'negative_control_result.json').write_text(json.dumps({'status':'PASS','source_sha256':hashes,'results':results},indent=2)+'\n',encoding='utf-8')
for name,result in results.items(): print(f'{name}: threshold={result["threshold"]} rc={result["returncode"]} expected={result["expected_result"]}\n{result["summary"]}')
