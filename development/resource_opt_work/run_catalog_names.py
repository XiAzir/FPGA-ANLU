from pathlib import Path
import re,subprocess,json,hashlib
ROOT=Path(__file__).resolve().parents[2]
src=ROOT/'development/player_spectrum_trace/src/user_source/hdl_source/fat32_catalog.v'
dut=ROOT/'development/player_spectrum_resource_fit/src/user_source/hdl_source/fat32_catalog.v'
out=ROOT/'development/player_spectrum_resource_fit/build/regression/catalog_names'
out.mkdir(parents=True,exist_ok=True)
ref=out/'reference.v';ref.write_text(src.read_text(encoding='utf-8').replace('module fat32_catalog #','module fat32_catalog_reference #'),encoding='utf-8')
tb=(ROOT/'development/player_fat32_probe/sim/tb_fat32_catalog.v').read_text(encoding='utf-8')
outs={'sd_read':1,'sd_addr':32,'ready':1,'error':1,'error_code':8,'fat_lba':32,'data_lba':32,'cluster_count':32,'spc_shift':4,'bmp_count':3,'bmp_clusters':128,'bmp_sizes':128,'wav_found':1,'wav_cluster':32,'wav_size':32}
m=re.search(r'fat32_catalog #\(.*?\);',tb,re.S)
instance=m.group().replace('fat32_catalog #','fat32_catalog_reference #').replace(' dut(', ' reference(')
for sig in outs:
    instance=re.sub(r'\('+sig+r'\)', '('+sig+'_ref)',instance)
decl='\n'.join('wire '+('' if w==1 else f'[{w-1}:0] ')+sig+'_ref;' for sig,w in outs.items())
left=','.join(outs);right=','.join(s+'_ref' for s in outs)
checker=f'\n{decl}\n{instance}\nalways @(negedge clk) if({{{left}}} !== {{{right}}}) $fatal(1,"directory output mismatch mode=%0d",mode);\n'
tb=tb[:m.end()]+checker+tb[m.end():]
needle='''  end
 end
endfunction

function [7:0] sector_byte;'''
replacement='''  end
  if(mode>=100) begin
    if((mode-100)%20<11 && off==(mode-100)%20) entry_byte=entry_byte^8'h01;
    if((mode-100)%20==11 && off==0) entry_byte=0;
    if((mode-100)%20==12 && off==0) entry_byte=8'he5;
    if((mode-100)%20>=13 && (mode-100)%20<=16 && off==11)
      entry_byte=((mode-100)%20==13)?8'h0f:((mode-100)%20==14)?8'h08:((mode-100)%20==15)?8'h10:8'h37;
    if((mode-100)%20==17 && off==26) entry_byte=0;
    if((mode-100)%20==18 && off>=28) entry_byte=0;
  end
 end
endfunction

function [7:0] sector_byte;'''
assert needle in tb;tb=tb.replace(needle,replacement,1)
tb=tb.replace('initial begin\n reset_case(0);','integer k;\ninitial begin\n for(k=0;k<160;k=k+1) begin reset_case(100+k); wait_terminal(); tests=tests+1; end\n reset_case(0);')
tbfile=out/'tb_names.v';tbfile.write_text(tb,encoding='utf-8')
bin=ROOT/'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
commands=[[bin/'iverilog.exe','-g2005','-s','tb_fat32_catalog','-o',out/'test.vvp',ref,dut,tbfile],[bin/'vvp.exe',out/'test.vvp']]
for i,cmd in enumerate(commands):
    run=subprocess.run(list(map(str,cmd)),capture_output=True,text=True)
    (out/f'{i}.log').write_text(run.stdout+run.stderr,encoding='utf-8')
    print(run.stdout+run.stderr,end='')
    if run.returncode:raise SystemExit(run.returncode)
(out/'inputs.json').write_text(json.dumps({str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in (src,dut,tbfile)},indent=2),encoding='utf-8')
