from pathlib import Path
import json,hashlib
ROOT=Path(__file__).resolve().parents[2]
candidate=ROOT/'development/player_spectrum_resource_fit'
official=Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/doc/strategies/official_strategy_ph1.json')
strategy=json.loads(official.read_text(encoding='utf-8'))['AreaOptimizeHigh']
commands='\n'.join('    set_param '+item['step']+' '+item['param']+' '+item['val'] for item in strategy['params'])
p=candidate/'scripts/build_manual_syn.tcl';text=p.read_text(encoding='utf-8')
anchor='    set_param -run syn_1 gate eram_init off'
assert text.count(anchor)==1
text=text.replace(anchor,anchor+'\n    # TD bundled AreaOptimizeHigh; clocks and IO constraints unchanged.\n'+commands)
p.write_text(text,encoding='utf-8')
# TD persists map_mode in both the project and the named run. Prepare these
# exact settings before taking the synthesis input snapshot.
p=candidate/'src/td_project/AC201_tf_hdmi.al';text=p.read_text(encoding='utf-8-sig')
text=text.replace('    <Property>\n    </Property>', '''    <Property>
        <GateProperty>
            <map_mode>area_prior</map_mode>
        </GateProperty>
    </Property>''')
text=text.replace('''            <Strategy Name="Default_Synthesis_Strategy">
            </Strategy>''', '''            <Strategy Name="Default_Synthesis_Strategy">
                <GateProperty>
                    <map_mode>area_prior</map_mode>
                </GateProperty>
            </Strategy>''')
p.write_text(text,encoding='utf-8')
(candidate/'build/area_strategy.json').write_text(json.dumps(dict(source=str(official),source_sha256=hashlib.sha256(official.read_bytes()).hexdigest(),strategy=strategy),indent=2),encoding='utf-8')
print(commands)
