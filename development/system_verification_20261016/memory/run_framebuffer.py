from pathlib import Path
from datetime import datetime
import sys,json,shutil
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'integration'))
from common import BASE,ROOT,archived_sources,execute,sha

out=BASE/'memory'/('framebuffer_'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()
sources,flags,receipt=archived_sources('C11206',out)
names={'frame_read_write.v','frame_read_write_compat.v','frame_fifo_write.v','frame_fifo_read.v','frame_buffer_rgb888.v','rgb888_word_codec.v','player_wipe_address.v','afifo_16_32_256.v','afifo_32_16_256.v'}
sources=[p for p in sources if p.name in names]
sources += [BASE/'memory/sdram_app_model.v',BASE/'memory/tb_framebuffer.v']
for i,p in enumerate(sources):
 target=out/p.name
 if p!=target:shutil.copy2(p,target)
 sources[i]=target
bin=ROOT/'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
compile=execute([bin/'iverilog.exe','-g2012','-s','tb_framebuffer','-o','sim.vvp']+sources,out,'compile.log')
if compile['exit_code']:raise SystemExit('Compile failed: '+str(out))
results=[]
for name,args in [('positive',[]),('negative',['+corrupt'])]:
 result=execute([bin/'vvp.exe','-i','sim.vvp']+args,out,name+'.log',600)
 log=(out/(name+'.log')).read_text(errors='replace')
 ok=(result['exit_code']==0 and 'FRAMEBUFFER_DATA_PASS' in log and 'FATAL' not in log) if name=='positive' else (result['exit_code']!=0 and 'FRAME_GOLD_MISMATCH' in log)
 results.append(dict(name=name,status='PASS' if ok else 'FAIL',execution=result))
 print(name,results[-1]['status'],log[-180:],flush=True)
 if not ok:break
summary=dict(status='PASS_SCOPE' if len(results)==2 and all(r['status']=='PASS' for r in results) else 'NOT_PASSED',results=results,inputs=[dict(path=str(p),sha256=sha(p)) for p in sources],scope='Original 640x480 framebuffer RTL, real async FIFOs, one completed frame; application memory data-leading-valid assumption, not vendor SDRAM validation')
(out/'summary.json').write_text(json.dumps(summary,indent=2))
print(out,flush=True)
raise SystemExit(0 if summary['status']=='PASS_SCOPE' else 2)
