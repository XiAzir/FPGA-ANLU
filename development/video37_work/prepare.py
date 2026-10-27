from pathlib import Path
import hashlib
import json
import re
import shutil

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT/'development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg'
TARGET = ROOT/'development/player_video37_open_tx'
PROJECT = 'AC201_video37_open_tx'

selected = [
    'hdl_source/IP/video_pll.v', 'hdl_source/IP/video_pll.ipc',
    'hdl_source/hdmi_phy_warpper.v', 'hdl_source/lane_lvds_10_1.v',
    'hdl_source/status_hex595.v',
    'constraints_source/pin.adc', 'constraints_source/timing.sdc',
]
binding = []
for relative in selected:
    source = BASE/'src/user_source'/relative
    target = TARGET/'src/user_source'/relative
    target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(source,target)
    digest = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
    assert digest(source) == digest(target)
    binding.append({'relative':relative,'source_sha256':digest(source),'candidate_sha256':digest(target)})

project_dir = TARGET/'src/td_project'
project_dir.mkdir(parents=True,exist_ok=True)
project_text = (BASE/'src/td_project/AC201_C11335_640x480_60hz_33_165_bufg.al').read_text(encoding='utf-8')
project_text = project_text.replace(BASE.as_posix(), TARGET.as_posix())
project_text = project_text.replace('AC201_C11335_640x480_60hz_33_165_bufg', PROJECT)
sources = ['top.v','status_hex595.v','hdmi_phy_warpper.v','lane_lvds_10_1.v','IP/video_pll.v',
           'open_tx/video_only_tmds_tx.v','open_tx/packet_assembler_compat.v',
           'open_tx/tmds_channel.v','open_tx/auxiliary_video_information_info_frame.v']
source_nodes = []
for index,name in enumerate(sources,1):
    source_nodes.append(f'''            <File Path="../user_source/hdl_source/{name}">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="{index}"/>
                </FileInfo>
            </File>''')
# TD's project dialect stores the literal attribute UsedInP&R. Preserve that
# dialect while replacing the source block; a strict XML reader rejects it.
project_text, replaced = re.subn(r'<Verilog>.*?</Verilog>', '<Verilog>\n'+'\n'.join(source_nodes)+'\n        </Verilog>', project_text, count=1, flags=re.S)
assert replaced == 1
(project_dir/f'{PROJECT}.al').write_text(project_text, encoding='utf-8')

(TARGET/'scripts').mkdir(exist_ok=True)
(TARGET/'build/manual').mkdir(parents=True,exist_ok=True)
for name in ['build_manual_syn.tcl','build_manual_phy.tcl','fix_hold.tcl','generate_bit.tcl']:
    script = (BASE/'scripts'/name).read_text()
    script = script.replace(BASE.as_posix(),TARGET.as_posix())
    script = script.replace('AC201_C11335_640x480_60hz_33_165_bufg',PROJECT)
    script = script.replace('taskC11335','taskC11337').replace('C11335_','C11337_')
    (TARGET/'scripts'/name).write_text(script,encoding='utf-8')

(ROOT/'development/video37_work/baseline_binding.json').write_text(json.dumps({
    'state':'SCAFFOLD_WAITING_FOR_VERIFIED_OPEN_TX_RTL','baseline':str(BASE),
    'candidate':str(TARGET),'copied_files':binding,
    'clocks_mhz':[33,165],'diagnostic_geometry':{'active':[640,480],'total':[1000,550]},
    'source_scope':'C35 PLL, PHY, lanes and constraints unchanged; separate video-only candidate.'
},indent=2)+'\n')
print(json.dumps({'candidate':str(TARGET),'copied_baseline_files':len(binding),'state':'SCAFFOLD_WAITING_FOR_VERIFIED_OPEN_TX_RTL'}))
