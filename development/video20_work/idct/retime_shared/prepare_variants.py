from pathlib import Path
import re
root=Path(__file__).resolve().parent
base=Path(r'E:\VSCODE-project\FPGA-ANLU\development\video20_work\shared_idct\src_v\jpeg_idct_y.v')
s=base.read_text(encoding='utf-8-sig')
orig=s
start=s.index('reg signed [31:0] mul0;')
end=s.index('reg        out_stg0_valid_q;',start)
s=s[:start]+s[end:]
start=s.index('reg        out_stg2_valid_q;')
end=s.index('reg signed [31:0] o_s5;',start)
s=s[:start]+s[end:]
start=s.index('reg signed [31:0] o_s5;')
end=s.index('reg        out_stg3_valid_q;',start)
section=s[start:end]
section=re.sub(r'\bmul([0-4])\b',r'mul\1_q',section)
section=section.replace('case (out_stg2_idx_q)','case (out_stg1_idx_q)')
s=s[:start]+section+s[end:]
s=s.replace('out_stg3_valid_q <= out_stg2_valid_q;','out_stg3_valid_q <= out_stg1_valid_q;')
s=s.replace('out_stg3_idx_q   <= out_stg2_idx_q;','out_stg3_idx_q   <= out_stg1_idx_q;')
assert 'out_stg2_' not in s
assert 'mul0 <= mul0_q' not in s
old0='(* dsp_style = "no" *) wire signed [31:0] scale181_0_w = ($signed(o_t6_5) <<< 7) + ($signed(o_t6_5) <<< 5) + ($signed(o_t6_5) <<< 4) + ($signed(o_t6_5) <<< 2) + ($signed(o_t6_5) <<< 0);'
old1='(* dsp_style = "no" *) wire signed [31:0] scale181_1_w = ($signed(o_t5_6) <<< 7) + ($signed(o_t5_6) <<< 5) + ($signed(o_t5_6) <<< 4) + ($signed(o_t5_6) <<< 2) + ($signed(o_t5_6) <<< 0);'
dsp='(* dsp_style = "yes" *) wire signed [31:0] scale181_0_w = $signed(o_t6_5) * 32\'sd181;\n(* dsp_style = "yes" *) wire signed [31:0] scale181_1_w = $signed(o_t5_6) * 32\'sd181;'
assert old0 in orig and old1 in orig and old0 in s and old1 in s
sources={
 'baseline':('jpeg_idct_y_reference',orig),
 'retime':('jpeg_idct_y_retimed',s),
 'dsp_only':('jpeg_idct_y_dsp',orig.replace(old0+'\n'+old1,dsp)),
 'retime_dsp':('jpeg_idct_y_retimed_dsp',s.replace(old0+'\n'+old1,dsp)),
}
for label,(mod,txt) in sources.items():
 txt=txt.replace('module jpeg_idct_y\n',f'module {mod}\n',1)
 out=root/label/f'{mod}.v';out.parent.mkdir(parents=True,exist_ok=True);out.write_text(txt,encoding='ascii')
print('created baseline, retime-only, dsp-only, retime+dsp Y variants')
