from pathlib import Path
root=Path(__file__).resolve().parents[5]
out=Path(__file__).resolve().parent
src=root/'development/resource80_work/bmp/synthesis_loader/base/td_project/bmp_loader_base.al'
text=src.read_text(encoding='utf-8-sig')
for name in ('A1_base','A2_validated'):
    d=out/'td'/name
    project=d/'td_project'/f'{name}.al'
    s=text.replace('development/resource80_work/bmp/synthesis_loader/base/td_project',f'development/opt16_work/small/validated_scaler/c11315/td/{name}/td_project')
    s=s.replace('bmp_loader_base',name)
    project.write_text(s,encoding='utf-8',newline='\n')
