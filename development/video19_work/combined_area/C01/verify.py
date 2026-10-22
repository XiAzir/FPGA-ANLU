from pathlib import Path
import subprocess,hashlib,json,shutil
r=Path('development/video19_work/combined_area/C01').resolve();src=r/'src_v';out=r/'frame000';out.mkdir(exist_ok=True)
bin=Path('bringup/tf_wav_hdmi/tools/iverilog/app/bin').resolve();tb=Path('development/video19_work/jpeg_unit/tb_jpeg_core.sv').resolve()
fixture=Path('development/video_codec_trial_20261021/decoder_fixture/frame_000.jpg').resolve()
if not fixture.exists():
 m=json.loads(Path('development/video19_work/jpeg_unit/runs/A08_frame_000_nobp/manifest.json').read_text());fixture=Path(m['fixtures'][0]['path'])
exe=out/'simv';p=subprocess.run([str(bin/'iverilog.exe'),'-g2012','-s','tb_jpeg_core','-o',str(exe),str(tb),*[str(p) for p in src.glob('*.v')]],capture_output=True);(out/'compile.log').write_bytes(p.stdout+p.stderr);assert p.returncode==0
cmd=[str(bin/'vvp.exe'),str(exe),f'+JPEG={fixture}',f'+OUT={out/"pixels.bin"}',f'+LOG={out/"sim.log"}','+MODE=2','+GAP=0','+SEED=1003','+FRAMES=1','+ABORT_BYTES=0','+PAUSE_AFTER_BYTES=0','+WIDTH=640','+HEIGHT=480']
with (out/'console.log').open('w') as log:p=subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT,timeout=240)
baseline=Path('development/video19_work/jpeg_unit/runs/A08_frame_000_nobp/pixels_xy_rgb.bin');a=hashlib.sha256((out/'pixels.bin').read_bytes()).hexdigest();b=hashlib.sha256(baseline.read_bytes()).hexdigest()
result={'status':'PASS' if p.returncode==0 and a==b else 'FAILED','sha256':a,'reference_sha256':b,'command':cmd}
(out/'summary.json').write_text(json.dumps(result,indent=2));print(result);print((out/'console.log').read_text()[-1200:]);assert result['status']=='PASS'

