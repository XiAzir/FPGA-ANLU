from pathlib import Path
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent/'mapper_lifetime'
F=R/'development/opt16_work/mapper/td/candidate'
for tag,source in [('base',R/'development/player_spectrum_opt16/src/user_source/hdl_source/fat32_file_sector.v'),('alias',W/'fat32_file_sector.v')]:
 D=W/'td'/tag;(D/'td_project').mkdir(parents=True,exist_ok=True);(D/'reports').mkdir(exist_ok=True)
 (D/'fat32_file_sector.v').write_bytes(source.read_bytes())
 for name in ('mapper_pair.v','mapper.sdc'):(D/name).write_bytes((F/name).read_bytes())
 for name in ('run_syn.tcl','td_project/top_specialized.al'):
  text=(F/name).read_text(encoding='utf-8-sig').replace('opt16_work/mapper/td/candidate',f'arch17_work/mapper_lifetime/td/{tag}')
  (D/name).write_text(text,encoding='utf-8')
print('mapper lifetime paired TD prepared')
