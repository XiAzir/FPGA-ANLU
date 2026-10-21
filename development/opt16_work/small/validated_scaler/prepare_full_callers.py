from pathlib import Path
root=Path(__file__).resolve().parents[4]
out=Path(__file__).resolve().parent
source=root/'development/player_spectrum_spi12p5/src/user_source/hdl_source/tf_bmp_file_player.v'
s=source.read_text(encoding='utf-8-sig')
assert s.count('module tf_bmp_file_player #')==1 and s.count('bmp_scale_engine #(')==1
base=s.replace('module tf_bmp_file_player #','module tf_bmp_file_player_base #',1).replace('bmp_scale_engine #(','bmp_scale_engine_base #(',1)
validated=s.replace('module tf_bmp_file_player #','module tf_bmp_file_player_validated #',1).replace('bmp_scale_engine #(','bmp_scale_engine #(.HEADER_VALIDATED(1),',1)
(out/'tf_bmp_file_player_full_base.v').write_text(base,encoding='ascii')
(out/'tf_bmp_file_player_full_validated.v').write_text(validated,encoding='ascii')
