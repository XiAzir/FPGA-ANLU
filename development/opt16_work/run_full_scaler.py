from pathlib import Path
import subprocess,json,hashlib
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent/'scaler'
F=R/'development/resource80_work/catalog/stride_experiment'
P=R/'development/player_spectrum_spi12p5/src/user_source/hdl_source'
tb=(F/'tb_scaler_full_loader.v').read_text().replace('test_media/',(F/'test_media').as_posix()+'/')
(W/'tb_full.v').write_text(tb)
iv=R/'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
inputs=[W/'tb_full.v',P/'tf_bmp_file_player.v',P/'SD/sd_card_bmp.v',W/'bmp_scale_engine.v']
receipt={'inputs':[{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in inputs], 'fixtures':[{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in (F/'test_media').glob('*.mem')]}
(W/'full_source_receipt.json').write_text(json.dumps(receipt,indent=2))
for args,name in [([str(iv),'-g2012','-s','tb_scaler_full_loader','-o',str(W/'full.vvp')]+[str(p) for p in inputs],'full_compile.log'),([str(iv.with_name('vvp.exe')),str(W/'full.vvp')],'full_run.log')]:
 p=subprocess.run(args,capture_output=True,text=True);(W/name).write_text(p.stdout+p.stderr);print(name,p.returncode,p.stdout[-1600:],flush=True);assert p.returncode==0
