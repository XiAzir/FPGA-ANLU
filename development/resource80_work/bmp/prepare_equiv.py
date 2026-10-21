from pathlib import Path
root=Path(__file__).resolve().parent
src=Path(__file__).resolve().parents[3]/'development/resource_opt_work/tb_bmp_width_equiv.v'
t=(src.read_text(encoding='utf-8-sig')
   .replace('tb_bmp_width_equiv','tb_rowstep_equiv')
   .replace('bmp_scale_engine_ref','bmp_scale_engine_base')
   .replace('bmp_scale_engine_opt','bmp_scale_engine_rowstep'))
(root/'tb_rowstep_equiv.v').write_text(t,encoding='utf-8',newline='\n')
base=(root/'bmp_scale_engine.base.v').read_text(encoding='utf-8-sig').replace('module bmp_scale_engine #(','module bmp_scale_engine_base #(',1)
opt=(root/'bmp_scale_engine.rowstep.v').read_text(encoding='utf-8-sig').replace('module bmp_scale_engine #(','module bmp_scale_engine_rowstep #(',1)
(root/'bmp_scale_engine_base.v').write_text(base,encoding='utf-8',newline='\n')
(root/'bmp_scale_engine_rowstep.v').write_text(opt,encoding='utf-8',newline='\n')
print(root/'tb_rowstep_equiv.v')


