from pathlib import Path
root=Path(__file__).resolve().parent
source=Path(__file__).resolve().parents[3]/'development/resource_opt_work/bmp_synthesis/runs/width32/td_project/bmp_width32.al'
template=source.read_text(encoding='utf-8-sig')
for name in ('engine_base','engine_rowstep'):
    folder=root/'synthesis'/name
    al=folder/'td_project'/'bmp.al'
    text=template.replace('resource_opt_work/bmp_synthesis/runs/width32/td_project',f'resource80_work/bmp/synthesis/{name}/td_project')
    text=text.replace('bmp_width32',f'bmp_{name}')
    al.write_text(text,encoding='utf-8',newline='\n')
print('restored TD project XML schema from successful standalone template')

