from pathlib import Path
import json,subprocess,hashlib
from mapper_proposal import apply
root=Path(__file__).resolve().parents[2]
out=Path(__file__).parent/'mapper';out.mkdir(exist_ok=True)
src=root/'development/player_spectrum_resource_fit/src/user_source/hdl_source/fat32_file_sector.v'
ref=out/'reference.v';ref.write_text(src.read_text(encoding='utf-8-sig').replace('module fat32_file_sector #(','module fat32_file_sector_reference #('),encoding='utf-8')
bin=root/'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
variants={k:{v:v==k for v in ('counters','cluster_width','subtract','mask')} for k in ('counters','cluster_width','subtract','mask')}
variants['combined']={k:True for k in ('counters','cluster_width','subtract','mask')}
results=[]
for name,flags in variants.items():
    p=out/f'{name}.v';p.write_bytes(src.read_bytes());apply(p,**flags)
    p.write_text(p.read_text(encoding='utf-8').replace('module fat32_file_sector #(','module fat32_file_sector_proposal #('),encoding='utf-8')
    for test in ('tb_mapper_edges','tb_mapper_long_equiv') if name=='combined' else ('tb_mapper_edges',):
        tb=root/f'development/resource_opt_work/{test}.v'
        image=out/f'{name}_{test}.vvp'
        compile_result=subprocess.run([str(bin/'iverilog.exe'),'-g2012','-Wall','-s',test,'-o',str(image),str(ref),str(p),str(tb)],capture_output=True,text=True)
        (out/f'{name}_{test}.compile.log').write_text(compile_result.stdout+compile_result.stderr,encoding='utf-8')
        assert compile_result.returncode==0,compile_result.stderr
        result=subprocess.run([str(bin/'vvp.exe'),str(image)],capture_output=True,text=True)
        (out/f'{name}_{test}.log').write_text(result.stdout+result.stderr,encoding='utf-8')
        print(name,test,result.stdout[-350:],flush=True)
        assert result.returncode==0,(name,test,result.stdout)
        results.append({'variant':name,'test':test,'status':'PASS','source_sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
(out/'simulation.json').write_text(json.dumps(results,indent=2),encoding='utf-8')
