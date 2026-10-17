from pathlib import Path
from datetime import datetime
import os,sys,json,shutil,argparse
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'integration'))
from common import BASE,BIN,archived_sources,compile_sources,execute,sha
p=argparse.ArgumentParser();p.add_argument('--probe',action='store_true');a=p.parse_args()
if not os.environ.get('MGLS_LICENSE_FILE'):raise SystemExit('Initialize license environment')
out=BASE/'memory'/('framebuffer_modelsim_'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()
sources,flags,receipt=archived_sources('C11206',out)
names={'frame_read_write.v','frame_read_write_compat.v','frame_fifo_write.v','frame_fifo_read.v','frame_buffer_rgb888.v','rgb888_word_codec.v','player_wipe_address.v','afifo_16_32_256.v','afifo_32_16_256.v'}
sources=[p for p in sources if p.name in names]+[BASE/'memory/sdram_app_model.v']
for i,p in enumerate(sources):
 target=out/p.name
 if p!=target:shutil.copy2(p,target)
 sources[i]=target
tb=out/'tb_framebuffer.v';shutil.copy2(BASE/'memory/tb_framebuffer.v',tb)
compile=compile_sources(out,sources,['-sv']+flags,tb)
(out/'run.do').write_text('onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n')
print(out,flush=True)
result=execute([BIN/'vsim.exe','-modelsimini','modelsim.ini','-c','-novopt','-lic_noqueue','-L','work','work.tb_framebuffer','+overlap']+(['+probe'] if a.probe else [])+['-do','run.do','-l','run.log'],out,'console.log',600)
log=(out/'console.log').read_text(errors='replace')
ok=result['exit_code']==0 and 'FRAMEBUFFER_DATA_PASS' in log and 'FATAL' not in log and '** Error' not in log and '** Fatal' not in log
summary=dict(status='PASS_SCOPE' if ok else 'NOT_PASSED',scope='Full frame, real FIFO/backend/codec, reading uncommitted data concurrently with writes; restart read before gold comparison. Application memory contract only.',simulation=result,inputs=[dict(path=str(p),sha256=sha(p)) for p in sources+[tb]])
(out/'summary.json').write_text(json.dumps(summary,indent=2));print(log[-4000:],flush=True)
raise SystemExit(0 if ok else 2)
