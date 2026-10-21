from pathlib import Path
import re
root=Path(__file__).resolve().parents[4]
out=Path(__file__).resolve().parent
source=root/'development/player_spectrum_spi12p5/src/user_source/hdl_source/tf_bmp_file_player.v'
s=source.read_text(encoding='utf-8-sig')
s=s.replace('module tf_bmp_file_player #','module tf_bmp_file_player_param #',1)
s=s.replace('parameter integer WAIT_LIMIT=50000000','parameter integer WAIT_LIMIT=50000000,\n    parameter integer HEADER_VALIDATED=0',1)
s=s.replace('bmp_scale_engine #(','bmp_scale_engine #(.HEADER_VALIDATED(HEADER_VALIDATED),',1)
(out/'tf_bmp_file_player_param.v').write_text(s,encoding='ascii')
p=out/'tb_full_paired.v'; t=p.read_text(encoding='utf-8-sig')
start=t.index('    generate if (HEADER_VALIDATED)')
end=t.index('end endgenerate',start)+len('end endgenerate')
block=t[start:end]
m=re.search(r'tf_bmp_file_player_validated #\((.*?)\) dut \((.*?)\n    \);',block,re.S)
assert m
params,ports=m.groups()
inst='''    tf_bmp_file_player_param #(.HEADER_VALIDATED(HEADER_VALIDATED),\n'''+params+''') dut ('''+ports+'''\n    );'''
t=t[:start]+inst+t[end:]
p.write_text(t,encoding='ascii')
