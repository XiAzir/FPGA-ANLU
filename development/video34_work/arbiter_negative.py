from pathlib import Path
import subprocess
ROOT=Path(__file__).resolve().parents[2]
HERE=Path(__file__).parent
source=ROOT/'development/player_video34_1080p15/src/user_source/hdl_source/yuv_sdram_burst_arbiter.v'
output=HERE/'arbiter'
variant=output/'early_release_negative.v'
variant.write_bytes(source.read_bytes().replace(b'RD_DRAIN: if(returned==4',b'RD_DRAIN: if(issued==4',1))
iv=ROOT/'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
vvp=iv.with_name('vvp.exe')
program=output/'negative.vvp'
subprocess.run([str(iv),'-g2012','-s','tb_yuv_arbiter','-o',str(program),str(HERE/'tb_yuv_arbiter.v'),str(variant)],cwd=ROOT,check=True)
r=subprocess.run([str(vvp),str(program)],cwd=ROOT,capture_output=True,text=True)
(output/'negative.log').write_text(r.stdout+r.stderr,encoding='utf-8')
assert r.returncode and 'WRITE_BEFORE_READ_RETURNS' in r.stdout
print('PASS negative control detected actual read/write overlap before returned data drained')
