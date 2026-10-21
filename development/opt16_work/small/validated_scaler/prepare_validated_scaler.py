from pathlib import Path
import hashlib, json, re
root=Path(__file__).resolve().parents[4]
out=Path(__file__).resolve().parent
prod=root/'development/player_spectrum_spi12p5/src/user_source/hdl_source'
scaler_base=root/'development/opt16_work/scaler/bmp_scale_engine.v'
# This task's baseline is the root scaler snapshot supplied for the optimization.
s=scaler_base.read_text(encoding='utf-8-sig')
assert s.count('parameter integer PIXEL_INTERVAL=10')==1
assert s.count('if (source_width==0 || source_height==0 ||')==1
assert s.count('if (image_end> {1\'b0,file_size}) begin')==1
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
# Direct-engine 13-case default-parameter regression.
tb=(root/'development/opt16_work/scaler/tb.v').read_text(encoding='utf-8-sig')
tb=tb.replace('bmp_scale_engine_rowstep #(.FRAME_WIDTH(32),.FRAME_HEIGHT(24),.PIXEL_INTERVAL(1)) opt_dut(', 'bmp_scale_engine #(.FRAME_WIDTH(32),.FRAME_HEIGHT(24),.PIXEL_INTERVAL(1),.HEADER_VALIDATED(0)) opt_dut(')
assert 'bmp_scale_engine #(.FRAME_WIDTH(32),.FRAME_HEIGHT(24),.PIXEL_INTERVAL(1),.HEADER_VALIDATED(0))' in tb
(out/'tb_default_13case.v').write_text(tb,encoding='ascii')
# Production-domain engine regression: compare the same seven valid geometries with HEADER_VALIDATED=1.
tb_valid=tb.replace('.HEADER_VALIDATED(0)', '.HEADER_VALIDATED(1)',1)
start=tb_valid.index('    initial begin\n        run_valid(1,1,0);')
end=tb_valid.index('    initial begin\n        #500000000;',start)
tb_valid=tb_valid[:start]+'''    initial begin
        run_valid(1,1,0);
        run_valid(1024,768,0);
        run_valid(1024,1,1);
        run_valid(1,768,0);
        run_valid(1023,767,1);
        run_valid(191,321,1);
        run_valid(800,599,0);
        $display("BMP_VALIDATED_DOMAIN PASS valid=7 frame=32x24 pixels=%0d",32*24);
        $finish;
    end

'''+tb_valid[end:]
(out/'tb_valid_domain.v').write_text(tb_valid,encoding='ascii')
# The established 538-case diagnostic fixture: clone identical baseline loader, changing only module and scaler binding.
source_loader=root/'development/resource80_work/bmp/tf_bmp_file_player.base.v'
loader=source_loader.read_text(encoding='utf-8-sig')
assert loader.count('module tf_bmp_file_player #')==1
assert loader.count('bmp_scale_engine #(')==1
base_loader=loader.replace('module tf_bmp_file_player #','module tf_bmp_file_player_base #',1).replace('bmp_scale_engine #(','bmp_scale_engine_base #(',1)
valid_loader=loader.replace('module tf_bmp_file_player #','module tf_bmp_file_player_validated #',1).replace('bmp_scale_engine #(','bmp_scale_engine #(.HEADER_VALIDATED(1),',1)
(out/'tf_bmp_file_player_base.v').write_text(base_loader,encoding='ascii')
(out/'tf_bmp_file_player_validated.v').write_text(valid_loader,encoding='ascii')
# Rebind the existing 538-case public-output fixture to the two identical loader snapshots.
tb_fail=(root/'development/resource80_work/bmp/header_failure/tb_tf_bmp_failure_detail.v').read_text(encoding='utf-8-sig')
tb_fail=tb_fail.replace('tf_bmp_file_player #(','tf_bmp_file_player_base #(',1).replace('tf_bmp_file_player_header #(','tf_bmp_file_player_validated #(',1)
(out/'tb_538_diagnostic.v').write_text(tb_fail,encoding='ascii')
# Reuse the established six-image gold fixture and patch its loader selection/output observations below.
full=(root/'development/opt16_work/scaler/tb_full.v').read_text(encoding='utf-8-sig')
full=full.replace('    parameter integer SOURCE_BYTES = 1\n)(\n    input wire clk,\n    input wire rst,\n    output reg finished = 0\n);','''    parameter integer SOURCE_BYTES = 1,
    parameter integer HEADER_VALIDATED = 0
)(
    input wire clk,
    input wire rst,
    output reg finished = 0,
    output wire [131:0] observation
);''',1)
# Replace the one loader instance with constant generate branches, preserving identical port maps.
pat=r'tf_bmp_file_player #\((.*?)\) dut \((.*?)\n    \);'
m=re.search(pat,full,re.S)
assert m, 'full fixture loader instantiation missing'
params=m.group(1); ports=m.group(2)
full=full[:m.start()]+'''generate if (HEADER_VALIDATED) begin : validated_player
tf_bmp_file_player_validated #('''+params+''') dut ('''+ports+'''
    );
end else begin : baseline_player
tf_bmp_file_player_base #('''+params+''') dut ('''+ports+'''
    );
end endgenerate'''+full[m.end():]
# Export complete loader-visible state for paired cycle comparison.
anchor='    integer total_card_requests = 0;'
assert full.count(anchor)==1
full=full.replace(anchor,anchor+'''\n    assign observation={file_cluster,file_size,card_read,card_addr,write_req,write_en,write_data,display_valid,error,state_code,current_image_index,auto_mode};''',1)
# Two parallel instances per asset; both receive identical reset/fixtures and are compared every cycle.
full=full.replace('    wire [5:0] done;','''    wire [5:0] done_base, done_validated;
    wire [131:0] obs_base[0:5], obs_validated[0:5];
    integer pair_i;
    always @(negedge clk) if(!rst) begin
        for(pair_i=0;pair_i<6;pair_i=pair_i+1)
            if(obs_base[pair_i] !== obs_validated[pair_i]) begin
                $display("FAIL scaler cycle-output mismatch pair=%0d base=%h validated=%h",pair_i,obs_base[pair_i],obs_validated[pair_i]);
                $fatal(1);
            end
    end''',1)
# Capture original six parameter snippets, then generate baseline/candidate instance pairs.
inst_pat=r'    scaler_asset_fullcheck #\(\.NAME\("([^"]+)"\),\n(.*?)\n        \.SOURCE_BYTES\((\d+)\)\) (\w+) \(clk, rst, done\[(\d+)\]\);'
insts=list(re.finditer(inst_pat,full,re.S))
assert len(insts)==6, f'expected six fullcheck instances, got {len(insts)}'
repls=[]
for x in insts:
    name,body,nbytes,inst,index=x.groups()
    params='\n'+body+'\n        .SOURCE_BYTES('+nbytes+')'
    base_inst=f'''    scaler_asset_fullcheck #(.NAME("{name}_base"),{params},.HEADER_VALIDATED(0)) {inst}_base (clk,rst,done_base[{index}],obs_base[{index}]);'''
    cand_inst=f'''    scaler_asset_fullcheck #(.NAME("{name}_validated"),{params},.HEADER_VALIDATED(1)) {inst}_validated (clk,rst,done_validated[{index}],obs_validated[{index}]);'''
    repls.append((x.span(),base_inst+'\n'+cand_inst))
for (a,b),rep in reversed(repls): full=full[:a]+rep+full[b:]
full=full.replace('wait(&done);','wait((&done_base) && (&done_validated));',1)
full=full.replace('SCALER_INTEGRATION PASS images=6 pixels=1843200 full_loader=1 native=1 odd_vertical=1','SCALER_INTEGRATION PASS images=6 pairs=base/HEADER_VALIDATED pixels=1843200 cycle_outputs=matched native=1 odd_vertical=1',1)
(out/'tb_full_paired.v').write_text(full,encoding='ascii')
# Source/test receipt for reproducibility.
files=[scaler_base,source_loader,root/'development/resource80_work/bmp/header_failure/tb_tf_bmp_failure_detail.v',root/'development/opt16_work/scaler/tb_full.v']
receipt={'inputs':[{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in files],
         'candidate_engine_sha256':hashlib.sha256((out/'bmp_scale_engine.v').read_bytes()).hexdigest(),
         'candidate_loader_sha256':hashlib.sha256((out/'tf_bmp_file_player_validated.v').read_bytes()).hexdigest(),
         'scope':'four compile-time gated validation groups only; default 0 retains existing generic checks'}
(out/'source_receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'files':[p.name for p in out.iterdir() if p.is_file()],'receipt':receipt},indent=2))
