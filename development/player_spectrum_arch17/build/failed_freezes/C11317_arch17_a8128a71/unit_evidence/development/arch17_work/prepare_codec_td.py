from pathlib import Path
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent/'codec'
P=R/'development/player_spectrum_opt16/src/user_source/hdl_source/rgb888_word_codec.v'
for tag,source in [('base',P),('byte',W/'rgb888_word_codec.v')]:
 D=W/'td'/tag;(D/'hdl_source').mkdir(parents=True,exist_ok=True);(D/'td_project').mkdir(exist_ok=True);(D/'reports').mkdir(exist_ok=True)
 (D/'hdl_source/rgb888_word_codec.v').write_bytes(source.read_bytes())
 s=(R/'development/resource_opt_work/bmp_synthesis/runs/width32/td_project/bmp_width32.al').read_text(encoding='utf-8-sig')
 s=s.replace('resource_opt_work/bmp_synthesis/runs/width32/td_project',f'arch17_work/codec/td/{tag}/td_project').replace('bmp_width32','codec').replace('bmp_scale_engine.v','rgb888_word_codec.v').replace('bmp_scale_engine','rgb888_unpack32')
 (D/'td_project/codec.al').write_text(s,encoding='utf-8');(D/'standalone.sdc').write_text('create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n')
 t=f'''cd {D.as_posix()}/td_project
if {{[catch {{
 import_device eagle_s20.db -package EG4S20BG256
 open_project codec.al -single_run
 load_run_param -run syn_1
 set_param gate add_map_lut_struct high
 set_param gate map_mode area_prior
 set_param gate multi_thread_mapping partition
 set_param rtl resource_sharing auto
 set_param rtl shifter_style shifter_reg
 set_param rtl min_ripple_len 18
 set_param gate mapper_lut_delay 1600
 report_param -stage rtl -detail -all -file {D.as_posix()}/reports/actualparams.rtl.log
 report_param -stage gate -detail -all -file {D.as_posix()}/reports/actualparams.gate.log
 elaborate -top rgb888_unpack32
 read_sdc ../standalone.sdc
 commit_param -step rtl
 optimize_rtl
 commit_param -step gate
 optimize_gate -packarea {D.as_posix()}/reports/gate.area
}} message]}} {{puts "BUILD_ERROR: $message"; exit 1}}
puts SYNTHESIS_COMPLETE
close_project
exit
'''
 (D/'run_syn.tcl').write_text(t,encoding='utf-8')
print('codec TD prepared')
