from pathlib import Path
root=Path(__file__).resolve().parent
pairs=[('x','jpeg_idct_x_reference.v','jpeg_idct_x.v'),('y','jpeg_idct_y_reference.v','jpeg_idct_y.v')]
old0='(* dsp_style = "no" *) wire signed [31:0] scale181_0_w = ($signed(o_t6_5) <<< 7) + ($signed(o_t6_5) <<< 5) + ($signed(o_t6_5) <<< 4) + ($signed(o_t6_5) <<< 2) + ($signed(o_t6_5) <<< 0);'
old1='(* dsp_style = "no" *) wire signed [31:0] scale181_1_w = ($signed(o_t5_6) <<< 7) + ($signed(o_t5_6) <<< 5) + ($signed(o_t5_6) <<< 4) + ($signed(o_t5_6) <<< 2) + ($signed(o_t5_6) <<< 0);'
new='''(* dsp_style = "no" *) wire signed [31:0] scale181_0_t15_w = ($signed(o_t6_5) <<< 4) - $signed(o_t6_5);
(* dsp_style = "no" *) wire signed [31:0] scale181_0_t45_w = ($signed(scale181_0_t15_w) <<< 1) + scale181_0_t15_w;
(* dsp_style = "no" *) wire signed [31:0] scale181_0_w = $signed(o_t6_5) + ($signed(scale181_0_t45_w) <<< 2);
(* dsp_style = "no" *) wire signed [31:0] scale181_1_t15_w = ($signed(o_t5_6) <<< 4) - $signed(o_t5_6);
(* dsp_style = "no" *) wire signed [31:0] scale181_1_t45_w = ($signed(scale181_1_t15_w) <<< 1) + scale181_1_t15_w;
(* dsp_style = "no" *) wire signed [31:0] scale181_1_w = $signed(o_t5_6) + ($signed(scale181_1_t45_w) <<< 2);'''
for axis,ref_file,a_file in pairs:
 for label,src,out,oldname,newname in [('b',root/ref_file,root/f'jpeg_idct_{axis}_b.v',f'jpeg_idct_{axis}_reference',f'jpeg_idct_{axis}_b'),('ab',root/a_file,root/f'jpeg_idct_{axis}_ab.v',f'jpeg_idct_{axis}',f'jpeg_idct_{axis}_ab')]:
  text=src.read_text(encoding='utf-8-sig')
  text=text.replace(f'module {oldname}\n',f'module {newname}\n',1)
  assert old0 in text and old1 in text
  text=text.replace(old0+'\n'+old1,new)
  out.write_text(text,encoding='ascii')
print('B and AB arithmetic variants regenerated')
