from pathlib import Path
from waveform_proposal import make_proposal

ROOT=Path(__file__).resolve().parents[2]
original=ROOT/'development/player_spectrum_trace/src/user_source/hdl_source/player_pcm_waveform.v'
candidate=ROOT/'development/player_spectrum_resource_fit/src/user_source/hdl_source/player_pcm_waveform.v'
candidate.write_text(make_proposal(original.read_text(encoding='utf-8')),encoding='utf-8')
