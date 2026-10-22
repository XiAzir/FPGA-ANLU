"""Install the selected, separately tested JPEG implementation into C11319."""
from pathlib import Path
import argparse, hashlib, json, shutil, re
from datetime import datetime

HERE = Path(__file__).resolve().parent
PLAYER = HERE.parent / 'player_video19'
HDL = PLAYER / 'src/user_source/hdl_source'

parser = argparse.ArgumentParser()
parser.add_argument('candidate', type=Path)
args = parser.parse_args()
selected = args.candidate.resolve()
sources = sorted(selected.glob('*.v'))
assert sources and (selected / 'jpeg_core.v').is_file()
target = HDL / 'jpeg'
target.mkdir(exist_ok=True)
receipt = []
for source in sources:
    destination = target / source.name
    shutil.copy2(source, destination)
    receipt.append(dict(source=str(source), destination=str(destination),
                        sha256=hashlib.sha256(source.read_bytes()).hexdigest()))
input_path = target / 'jpeg_input.v'
input_text = input_path.read_text()
input_text, replacements = re.subn(r'(wire token_\w+_w\s*=\s*)(\()',
    r'\1inport_valid_i && \2', input_text)
assert replacements == 12
input_path.write_text(input_text, encoding='utf-8')
receipt.append(dict(transform='Qualify JPEG marker tokens with inport_valid_i; input_gap_unit A/B proven',
                    destination=str(input_path), sha256=hashlib.sha256(input_path.read_bytes()).hexdigest()))
shutil.copy2(HERE / 'vendor/core_jpeg/LICENSE', target / 'LICENSE')
shutil.copy2(HERE / 'stream_frontend/mjp_file_reader.v', HDL / 'mjp_file_reader.v')
shutil.copy2(HERE / 'stream_frontend/rgb565_word_codec.v', HDL / 'rgb565_word_codec.v')
project = PLAYER / 'src/td_project/AC201_tf_hdmi.al'
text = project.read_text(encoding='utf-8-sig')
paths = ['../user_source/hdl_source/jpeg/' + source.name for source in sources]
paths += ['../user_source/hdl_source/' + name for name in
          ['mjp_file_reader.v', 'jpeg420_word_address.v', 'player_video_schedule.v', 'rgb565_word_codec.v']]
order = max(map(int, re.findall(r'Name="CompileOrder" Val="(\d+)"', text)))
for path in paths:
    if f'Path="{path}"' in text:
        continue
    order += 1
    entry = f'''            <File Path="{path}">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&amp;R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="{order}"/>
                </FileInfo>
            </File>
'''
    text = text.replace('        </Verilog>', entry + '        </Verilog>')
project.write_text(text, encoding='utf-8')
output = PLAYER / 'build/jpeg_install_receipt.json'
output.write_text(json.dumps(dict(time=datetime.now().astimezone().isoformat(),
    candidate=str(selected), files=receipt), indent=2), encoding='utf-8')
print(output)
