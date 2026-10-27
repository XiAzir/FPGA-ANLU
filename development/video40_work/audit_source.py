import hashlib
import json
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'development/player_video32_read_return/src/user_source'
CAND=ROOT/'development/player_video40_spi25/src/user_source'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
base={p.relative_to(BASE).as_posix():sha(p) for p in BASE.rglob('*') if p.is_file()}
current={p.relative_to(CAND).as_posix():sha(p) for p in CAND.rglob('*') if p.is_file()}
changed=sorted(k for k in base if base[k]!=current[k])
assert set(base)==set(current)
assert set(changed)=={'hdl_source/SD/spi_master.v','hdl_source/SD/sd_card_top.v','hdl_source/SD/sd_card_cmd.v','hdl_source/top_tf_hdmi_audio.v'}
prod=ROOT/'development/video40_work/spi_candidate/spi_master_production.v'
assert current['hdl_source/SD/spi_master.v']==sha(prod)
candidate=(CAND/'hdl_source/SD/sd_card_cmd.v').read_text(encoding='utf-8-sig')
candidate=candidate.split('// Passive CRC-16/CCITT',1)[0]+'endmodule'
candidate=re.sub(r'function \[15:0\] crc16_ccitt_byte;.*?endfunction','',candidate,flags=re.S)
candidate=re.sub(r'^\s*(?:output reg \[15:0\]\s+read_crc_(?:checked|bad),|reg \[15:0\] read_crc16;|reg \[7:0\] read_crc_hi;)\s*$','',candidate,flags=re.M)
def tokens(text):
    text=re.sub(r'/\*.*?\*/|//[^\r\n]*','',text,flags=re.S)
    return re.findall(r'\w+|[^\s]',text)
assert tokens(candidate)==tokens((BASE/'hdl_source/SD/sd_card_cmd.v').read_text(encoding='utf-8-sig')),'Control flow differs after CRC stripping'
record={'status':'PASS','changed':changed,'unchanged_user_sources':len(base)-len(changed),'candidate_sources':current,'base_sources':base,'crc_stripped_command_control_tokens_match_C32':True,'SPI_production_sha256':sha(prod),'baseline_bit_sha256':sha(ROOT/'download/video32_read_return.bit'),'SDRAM_PLL_global_defs_timing_adc_identical_to_C32':True}
out=ROOT/'development/player_video40_spi25/verification/source_audit.json'
out.write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({k:v for k,v in record.items() if k not in ['candidate_sources','base_sources']},ensure_ascii=False,indent=2))
