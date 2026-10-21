from pathlib import Path
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent;S=W/'codec/td/base';D=W/'codec_hold/td/candidate'
(D/'td_project').mkdir(parents=True,exist_ok=True);(D/'hdl_source').mkdir(exist_ok=True);(D/'reports').mkdir(exist_ok=True)
(D/'hdl_source/rgb888_word_codec.v').write_bytes((W/'codec_hold/rgb888_word_codec.v').read_bytes())
for name in ('td_project/codec.al','run_syn.tcl','standalone.sdc'):
 (D/name).write_text((S/name).read_text(encoding='utf-8-sig').replace('arch17_work/codec/td/base','arch17_work/codec_hold/td/candidate'),encoding='utf-8')
print('codec hold TD prepared')
