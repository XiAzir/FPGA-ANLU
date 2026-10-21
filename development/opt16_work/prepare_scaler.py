from pathlib import Path
import hashlib,json,subprocess
R=Path(__file__).resolve().parents[2]
W=Path(__file__).parent/'scaler';W.mkdir(exist_ok=True)
P=R/'development/player_spectrum_spi12p5/src/user_source/hdl_source/bmp_scale_engine.v'
s=P.read_text(encoding='utf-8-sig')
t=s.replace('wire [21:0] image_bytes = {10\'d0,stride} * {12\'d0,src_h};',
'''// S_SETUP uses the same row multiplier for the complete image extent.
// physical_row is seeded with height at start, then overwritten by S_Y_BEGIN
// before a source row is requested.
wire [21:0] image_bytes = row_offset;''')
old='src_w<={16\'d0,source_width}; src_h<={16\'d0,source_height};'
assert t.count(old)==1
t=t.replace(old,old+'\n            physical_row<=source_height[9:0];')
assert t!=s
(W/'bmp_scale_engine.v').write_text(t,encoding='utf-8')
(W/'base.v').write_text(s.replace('module bmp_scale_engine #','module bmp_scale_engine_base #'),encoding='utf-8')
(W/'opt.v').write_text(t.replace('module bmp_scale_engine #','module bmp_scale_engine_rowstep #'),encoding='utf-8')
tb=(R/'development/resource80_work/bmp/tb_rowstep_equiv.v').read_text()
tb=tb.replace('ref_dut.physical_row!==opt_dut.physical_row ||',
'''(ref_dut.state==3 && ref_dut.image_bytes!==opt_dut.image_bytes) ||
                (ref_dut.state==6 && ref_dut.row_offset!==opt_dut.row_offset) ||''')
(W/'tb.v').write_text(tb,encoding='utf-8')
(W/'source_receipt.json').write_text(json.dumps({'baseline':str(P),'baseline_sha256':hashlib.sha256(P.read_bytes()).hexdigest(),'candidate_sha256':hashlib.sha256((W/'bmp_scale_engine.v').read_bytes()).hexdigest(),'invariant':'physical_row carries src_h during S_SETUP; first S_Y_BEGIN assigns actual row before any row request; image product and row product share the existing multiplier'},indent=2),encoding='utf-8')
iv=R/'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
vp=iv.with_name('vvp.exe')
for args,name in [([str(iv),'-g2012','-s','tb_rowstep_equiv','-o',str(W/'test.vvp'),str(W/'base.v'),str(W/'opt.v'),str(W/'tb.v')],'compile.log'),([str(vp),str(W/'test.vvp')],'run.log')]:
 p=subprocess.run(args,capture_output=True,text=True);(W/name).write_text(p.stdout+p.stderr);print(name,p.returncode,p.stdout[-2000:]);assert p.returncode==0
