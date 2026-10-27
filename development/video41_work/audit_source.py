import hashlib
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'development/player_video40_spi25/src/user_source'
CAND=ROOT/'development/player_video41_refresh/src/user_source'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
base={p.relative_to(BASE).as_posix():sha(p) for p in BASE.rglob('*') if p.is_file()}
current={p.relative_to(CAND).as_posix():sha(p) for p in CAND.rglob('*') if p.is_file()}
assert set(base)==set(current)
changed=sorted(k for k in base if base[k]!=current[k])
assert changed==['hdl_source/include/global_def.v','hdl_source/include/sdr_init_ref.enc.v','hdl_source/top_tf_hdmi_audio.v']
top=(CAND/'hdl_source/top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
original=(BASE/'hdl_source/top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
assert top.replace("32'h00C11341","32'h00C11340")==original
macro=(CAND/'hdl_source/include/global_def.v').read_text(encoding='utf-8-sig')
baseline=(BASE/'hdl_source/include/global_def.v').read_text(encoding='utf-8-sig')
new='// EM638325 requires 4096 AREF commands per 64ms; init_cnt includes its terminal value.\n`define   SELF_REFRESH_INTERVAL             (64000000/(`SDR_CLK_PERIOD)/4096-1)'
assert macro.replace(new,'`define   SELF_REFRESH_INTERVAL\t\t\t64000000/`SDR_CLK_PERIOD/2**(`ROW_WIDTH)')==baseline
protected_marker=b'`pragma protect begin_protected'
before=(BASE/'hdl_source/include/sdr_init_ref.enc.v').read_bytes().split(protected_marker,1)[1]
after=(CAND/'hdl_source/include/sdr_init_ref.enc.v').read_bytes().split(protected_marker,1)[1]
assert before==after
record={'status':'PASS','changed':changed,'unchanged_user_sources':len(base)-len(changed),
        'candidate_sources':current,'base_sources':base,
        'top_version_only':True,'SPI25_PLL_SDC_ADC_identical_to_C40':True,
        'SDRAM_protected_suffix_identical_to_C40':True,
        'refresh_terminal_50MHz':780,'request_interval_cycles':781,
        'required_commands_per_64ms':4096,
        'baseline_bit_sha256':sha(ROOT/'download/video40_spi25.bit')}
out=ROOT/'development/player_video41_refresh/verification/source_audit.json'
out.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({k:v for k,v in record.items() if k not in ['candidate_sources','base_sources']},ensure_ascii=False,indent=2))
