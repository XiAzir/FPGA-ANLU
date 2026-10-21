from pathlib import Path
import json,hashlib
root=Path(__file__).resolve().parents[2]
c=root/'development/player_spectrum_resource_80'
p=c/'scripts/build_manual_syn.tcl'
s=p.read_text(encoding='utf-8-sig')
anchor='    elaborate -top top'
assert anchor in s and 'set_param rtl min_ripple_len 18' not in s
s=s.replace(anchor,'    # TD bundled AdderChainThresholdHigh, combined with AreaOptimizeHigh.\n'
            '    set_param rtl min_ripple_len 18\n'
            '    set_param gate mapper_lut_delay 1600\n'
            '    report_param -stage rtl -detail -all -file $output_dir/strategy_actual.rtl.log\n'
            '    report_param -stage gate -detail -all -file $output_dir/strategy_actual.gate.log\n'+anchor)
p.write_text(s,encoding='utf-8')
official=Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/doc/strategies/official_strategy_ph1.json')
data=json.loads(official.read_text(encoding='utf-8'))
(c/'build/strategy.json').write_text(json.dumps({'official':str(official),'official_sha256':hashlib.sha256(official.read_bytes()).hexdigest(),
 'base':data['AreaOptimizeHigh'],'additional':data['AdderChainThresholdHigh']},indent=2),encoding='utf-8')
