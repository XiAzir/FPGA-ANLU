from pathlib import Path
import hashlib,json,re
root=Path(__file__).resolve().parents[5]
out=Path(__file__).resolve().parent
prod=root/'development/player_spectrum_spi12p5/src/user_source/hdl_source'
engine_src=prod/'bmp_scale_engine.v'
loader_src=prod/'tf_bmp_file_player.v'
s=engine_src.read_text(encoding='utf-8-sig')
assert s.count('module bmp_scale_engine #')==1
assert s.count('parameter integer PIXEL_INTERVAL=10')==1
assert s.count('if (source_width==0 || source_height==0 ||')==1
assert s.count("if (image_end> {1'b0,file_size}) begin")==1
assert s.count('if (row_address_wide[32]) begin')==1
assert s.count('if (byte_address_wide[32] || byte_address_wide[31:0]>=file_size) begin')==1
base=s.replace('module bmp_scale_engine #','module bmp_scale_engine_base #',1)
cand=s.replace('parameter integer PIXEL_INTERVAL=10','parameter integer PIXEL_INTERVAL=10,\n    parameter integer HEADER_VALIDATED=0',1)
cand=cand.replace('''if (source_width==0 || source_height==0 ||
                source_width>MAX_SOURCE_WIDTH || source_width>1024 ||
                source_height>MAX_SOURCE_HEIGHT || source_height>768) begin''','''if (!HEADER_VALIDATED && (source_width==0 || source_height==0 ||
                source_width>MAX_SOURCE_WIDTH || source_width>1024 ||
                source_height>MAX_SOURCE_HEIGHT || source_height>768)) begin''',1)
cand=cand.replace("if (image_end> {1'b0,file_size}) begin","if (!HEADER_VALIDATED && image_end> {1'b0,file_size}) begin",1)
cand=cand.replace('if (row_address_wide[32]) begin','if (!HEADER_VALIDATED && row_address_wide[32]) begin',1)
cand=cand.replace('if (byte_address_wide[32] || byte_address_wide[31:0]>=file_size) begin','if (!HEADER_VALIDATED && (byte_address_wide[32] || byte_address_wide[31:0]>=file_size)) begin',1)
(out/'bmp_scale_engine_base.v').write_text(base,encoding='ascii')
(out/'bmp_scale_engine.v').write_text(cand,encoding='ascii')
# General-purpose direct scaler regression: candidate parameter 0, all 7 valid + 6 bad cases.
tb=(root/'development/opt16_work/scaler/tb.v').read_text(encoding='utf-8-sig')
tb=tb.replace('bmp_scale_engine_rowstep #(.FRAME_WIDTH(32),.FRAME_HEIGHT(24),.PIXEL_INTERVAL(1)) opt_dut(', 'bmp_scale_engine #(.FRAME_WIDTH(32),.FRAME_HEIGHT(24),.PIXEL_INTERVAL(1),.HEADER_VALIDATED(0)) opt_dut(')
assert '.HEADER_VALIDATED(0)' in tb
(out/'tb_default_13case.v').write_text(tb,encoding='ascii')
# Validated domain only: seven legal combinations are compared every cycle with unoptimized C11315.
tbv=tb.replace('.HEADER_VALIDATED(0)', '.HEADER_VALIDATED(1)',1)
start=tbv.index('    initial begin\n        run_valid(1,1,0);'); end=tbv.index('    initial begin\n        #500000000;',start)
tbv=tbv[:start]+'''    initial begin
        run_valid(1,1,0); run_valid(1024,768,0); run_valid(1024,1,1);
        run_valid(1,768,0); run_valid(1023,767,1); run_valid(191,321,1); run_valid(800,599,0);
        $display("BMP_C11315_VALIDATED PASS valid=7 frame=32x24 pixels=%0d",32*24);
        $finish;
    end

'''+tbv[end:]
(out/'tb_valid_domain.v').write_text(tbv,encoding='ascii')
# 538 diagnostic fixture compares identical production loader copies; only engine checking parameter differs.
loader=loader_src.read_text(encoding='utf-8-sig')
assert loader.count('module tf_bmp_file_player #')==1 and loader.count('bmp_scale_engine #(')==1
base_loader=loader.replace('module tf_bmp_file_player #','module tf_bmp_file_player_base #',1).replace('bmp_scale_engine #(','bmp_scale_engine_base #(',1)
valid_loader=loader.replace('module tf_bmp_file_player #','module tf_bmp_file_player_validated #',1).replace('bmp_scale_engine #(','bmp_scale_engine #(.HEADER_VALIDATED(1),',1)
(out/'tf_bmp_file_player_base.v').write_text(base_loader,encoding='ascii')
(out/'tf_bmp_file_player_validated.v').write_text(valid_loader,encoding='ascii')
tbf=(root/'development/resource80_work/bmp/header_failure/tb_tf_bmp_failure_detail.v').read_text(encoding='utf-8-sig')
tbf=tbf.replace('tf_bmp_file_player #(','tf_bmp_file_player_base #(',1).replace('tf_bmp_file_player_header #(','tf_bmp_file_player_validated #(',1)
(out/'tb_538_diagnostic.v').write_text(tbf,encoding='ascii')
# Six-image gold loader regression doubled as a cycle-level baseline/validated pair.
full=(root/'development/opt16_work/scaler/tb_full.v').read_text(encoding='utf-8-sig')
full=full.replace('    parameter integer SOURCE_BYTES = 1\n)(\n    input wire clk,\n    input wire rst,\n    output reg finished = 0\n);','''    parameter integer SOURCE_BYTES = 1,
    parameter integer HEADER_VALIDATED = 0
)(
    input wire clk,
    input wire rst,
    output reg finished = 0,
    output wire [131:0] observation
);''',1)
pat=r'tf_bmp_file_player #\((.*?)\) dut \((.*?)\n    \);'; m=re.search(pat,full,re.S); assert m
params,ports=m.groups()
full=full[:m.start()]+'tf_bmp_file_player_param #(.HEADER_VALIDATED(HEADER_VALIDATED),\n'+params+') dut ('+ports+'\n    );'+full[m.end():]
anchor='    integer total_card_requests = 0;'; assert full.count(anchor)==1
full=full.replace(anchor,anchor+'\n    assign observation={file_cluster,file_size,card_read,card_addr,write_req,write_en,write_data,display_valid,error,state_code,current_image_index,auto_mode};',1)
full=full.replace('    wire [5:0] done;','''    wire [5:0] done_base, done_validated;
    wire [131:0] obs_base[0:5], obs_validated[0:5];
    integer pair_i;
    always @(negedge clk) if(!rst) begin
        for(pair_i=0;pair_i<6;pair_i=pair_i+1)
            if(obs_base[pair_i] !== obs_validated[pair_i]) begin
                $display("FAIL scaler cycle-output mismatch pair=%0d base=%h validated=%h",pair_i,obs_base[pair_i],obs_validated[pair_i]); $fatal(1);
            end
    end''',1)
inst_pat=r'    scaler_asset_fullcheck #\(\.NAME\("([^"]+)"\),\n(.*?)\n        \.SOURCE_BYTES\((\d+)\)\) (\w+) \(clk, rst, done\[(\d+)\]\);'
insts=list(re.finditer(inst_pat,full,re.S)); assert len(insts)==6,len(insts)
repls=[]
for x in insts:
    name,body,nbytes,inst,index=x.groups(); params='\n'+body+'\n        .SOURCE_BYTES('+nbytes+')'
    a=f'''    scaler_asset_fullcheck #(.NAME("{name}_base"),{params},.HEADER_VALIDATED(0)) {inst}_base (clk,rst,done_base[{index}],obs_base[{index}]);'''
    b=f'''    scaler_asset_fullcheck #(.NAME("{name}_validated"),{params},.HEADER_VALIDATED(1)) {inst}_validated (clk,rst,done_validated[{index}],obs_validated[{index}]);'''
    repls.append((x.span(),a+'\n'+b))
for (a,b),rep in reversed(repls):full=full[:a]+rep+full[b:]
full=full.replace('wait(&done);','wait((&done_base) && (&done_validated));',1)
full=full.replace('SCALER_INTEGRATION PASS images=6 pixels=1843200 full_loader=1 native=1 odd_vertical=1','SCALER_INTEGRATION PASS images=6 pairs=C11315/HEADER_VALIDATED pixels=1843200 cycle_outputs=matched native=1 odd_vertical=1',1)
(out/'tb_full_paired.v').write_text(full,encoding='ascii')
# Full loader test caller: original module text plus a compile-time parameter forwarded only to scaler.
param_loader=loader.replace('module tf_bmp_file_player #','module tf_bmp_file_player_param #',1)
param_loader=param_loader.replace('parameter integer WAIT_LIMIT=50000000','parameter integer WAIT_LIMIT=50000000,\n    parameter integer HEADER_VALIDATED=0',1)
param_loader=param_loader.replace('bmp_scale_engine #(','bmp_scale_engine #(.HEADER_VALIDATED(HEADER_VALIDATED),',1)
(out/'tf_bmp_file_player_param.v').write_text(param_loader,encoding='ascii')
inputs=[engine_src,loader_src,root/'development/resource80_work/bmp/header_failure/tb_tf_bmp_failure_detail.v',root/'development/opt16_work/scaler/tb_full.v']
receipt={'inputs':[{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in inputs],
 'engine_candidate_sha256':hashlib.sha256((out/'bmp_scale_engine.v').read_bytes()).hexdigest(),
 'loader_candidate_sha256':hashlib.sha256((out/'tf_bmp_file_player_validated.v').read_bytes()).hexdigest(),
 'loader_original_sha256':hashlib.sha256(loader_src.read_bytes()).hexdigest(),
 'engine_original_sha256':hashlib.sha256(engine_src.read_bytes()).hexdigest(),
 'scope':'C11315 scaler with default-off compile-time HEADER_VALIDATED; only four input validation groups are gated'}
(out/'source_receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt,indent=2))
