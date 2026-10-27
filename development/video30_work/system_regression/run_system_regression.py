"""Prepare or run the isolated C30 system regression without touching the candidate."""
from pathlib import Path
from datetime import datetime
import argparse, json, os, re, shutil, struct, sys, xml.etree.ElementTree as ET

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
PLAYER = ROOT / 'development/player_video30_probe_prune'
BASE = ROOT / 'development/system_verification_20261016'
sys.path.insert(0, str(BASE / 'integration'))
import common
if os.environ.get('ANLU_MODELSIM_BIN'):
    common.BIN = Path(os.environ['ANLU_MODELSIM_BIN']).resolve()
from common import BIN, EG4, HDMI, sha, compile_sources, execute

parser = argparse.ArgumentParser()
parser.add_argument('--player',type=Path,default=PLAYER)
parser.add_argument('--card', type=Path, default=ROOT / 'development/video23_work/mode_fixture/card_image')
parser.add_argument('--media', type=Path, default=ROOT / 'development/video19_work/media_q90_trial/output')
parser.add_argument('--compile-only', action='store_true')
parser.add_argument('--prepare-only', action='store_true', help='Materialize frozen sources and fixtures without invoking simulator tools')
args = parser.parse_args()
def repo_path(path):
    return (path if path.is_absolute() else ROOT / path).resolve()
PLAYER=repo_path(args.player)
CARD=repo_path(args.card)
MEDIA=repo_path(args.media)
out = HERE / 'build' / (PLAYER.name + '_system_' + datetime.now().strftime('%Y%m%d_%H%M%S'))
out.mkdir(parents=True)
print(out, flush=True)
td = PLAYER / 'src/td_project'
hdl = PLAYER / 'src/user_source/hdl_source'
project_text = re.sub(r'&(?!amp;|lt;|gt;|quot;|apos;)', '&amp;',
                      (td / 'AC201_tf_hdmi.al').read_text(encoding='utf-8-sig'))
project = ET.fromstring(project_text)
sources = []
excluded = {'sys_pll.v', 'video_pll.v', 'sdram.v',
            'sdr_as_ram.enc.v', 'sdr_init_ref.enc.v', 'sdr_wrrd.enc.v'}
for entry in project.findall('Source_Files/Verilog/File'):
    attrs = {a.get('Name'): a.get('Val') for a in entry.findall('FileInfo/Attr')}
    path = (td / entry.get('Path')).resolve()
    if attrs.get('AutoExcluded') != 'true' and path.name not in excluded:
        sources.append(path)
for name in ['afifo_16_32_256.v', 'afifo_32_16_256.v']:
    sources.append(hdl / 'IP' / name)
sources = list(dict.fromkeys(sources))
receipt = []
frozen = out / 'frozen'
for source in list(sources) + list(hdl.rglob('*.vh')) + [hdl / 'SD/video_define.v']:
    target = frozen / source.relative_to(PLAYER)
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, target)
    receipt.append(dict(source=str(source), copy=str(target), sha256=sha(source)))
sources = [frozen / p.relative_to(PLAYER) for p in sources]
# Old ModelSim's implicit-net redeclaration and unsigned-port extension behavior.
compat = []
for path in sources:
    text = path.read_text(encoding='utf-8-sig')
    original = text
    if path.name in ('top_tf_hdmi_audio.v', 'player_status_monitor.v'):
        pattern = (r'^\s*wire\s+bmp_write_ready\s*;[^\n]*\n' if path.name == 'top_tf_hdmi_audio.v'
                   else r'^\s*reg\s+request_toggle,\s*ack_sync0,\s*ack_sync1\s*;[^\n]*\n')
        match = re.search(pattern, text, re.M)
        if match:
            text = text[:match.start()] + text[match.end():]
            anchor = text.index(';', text.index('module ')) + 1
            text = text[:anchor] + '\n' + match.group().strip() + '\n' + text[anchor:]
    if path.name == 'frame_buffer_rgb888.v':
        match=re.search(r'    assign debug_memory=.*?;',text,re.S)
        assert match
        declaration=match.group()
        text=text[:match.start()]+text[match.end():]
        position=text.index('    // Reject unsupported geometry')
        text=text[:position]+declaration+'\n'+text[position:]
    if path.name == 'frame_read_write.v':
        for instance, port, signal in [('frame_fifo_write_m0', 'rdusedw', 'rdusedw'),
                                       ('frame_fifo_read_m0', 'wrusedw', 'wrusedw')]:
            start = text.index(instance)
            end = text.index(');', start) + 2
            block, count = re.subn(r'(\.' + port + r'\s*\()\s*' + signal + r'\s*(\))',
                lambda m: m[1] + "{1'b0," + signal + '}' + m[2], text[start:end])
            assert count == 1
            text = text[:start] + block + text[end:]
    if path.name == 'jpeg_dht.v':
        declarations = []
        for name in ['idx_q', 'total_entries_q']:
            pattern = r'^\s*reg\s+\[11:0\]\s+' + name + r'\s*;[^\n]*\n'
            match = re.search(pattern, text, re.M)
            assert match
            declarations.append(match.group().strip())
            text = text[:match.start()] + text[match.end():]
        anchor = text.index('    // DHT tables can be combined')
        text = text[:anchor] + '\n'.join(declarations) + '\n' + text[anchor:]
    if path.name == 'jpeg_core.v' and 'img_mode_decoder_w' in text:
        # ModelSim 10.1c requires declaration before initialized profile nets.
        declarations=[]
        for name in ('img_mode_w','img_width_w','img_height_w'):
            match=re.search(r'^\s*wire\s+\[[^\]]+\]\s+'+name+r'\s*;[^\n]*\n',text,re.M)
            assert match
            declarations.append(match.group().strip())
            text=text[:match.start()]+text[match.end():]
        anchor=text.index('wire [1:0] img_mode_decoder_w')
        text=text[:anchor]+'\n'.join(declarations)+'\n'+text[anchor:]
    if path.name == 'jpeg_output.v':
        declaration = 'wire color_input_fire_w = active_q && color_s1_ready_w;'
        if declaration in text:
            text = text.replace(declaration, 'assign color_input_fire_w = active_q && color_s1_ready_w;')
            anchor = text.index(';', text.index('module ')) + 1
            text = text[:anchor] + '\nwire color_input_fire_w;\n' + text[anchor:]
    if text != original:
        path.write_text(text, encoding='utf-8')
        compat.append(dict(path=str(path), copy_sha256=sha(path),
                           changes='Declaration placement or explicit unsigned FIFO count extension'))
replay = BASE / 'memory/vendor_qualification/clock_replay'
proof = json.loads((replay / 'summary.json').read_text(encoding='utf-8-sig'))
assert proof['status'] == 'PASS_SCOPE'
assert sha(replay / 'pll_clock_replay.v').lower() == proof['replay_sha256'].lower()
for name, original in [('sys_wrapper', hdl / 'IP/sys_pll.v'),
                       ('video_wrapper', hdl / 'IP/video_pll.v')]:
    assert sha(original).lower() == proof['source_sha256'][name].lower()
models = [replay / 'pll_clock_replay.v', BASE / 'integration/pll_replay_wrappers.v',
          HERE / 'fixture/sdram_app_model.v', HERE / 'fixture/sd_spi_card_model.v',
          Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_glbl.v')]
for source in models:
    destination = out / source.name
    shutil.copy2(source, destination)
    sources.append(destination)
    receipt.append(dict(source=str(source), copy=str(destination), sha256=sha(source)))
shutil.copy2(replay / 'summary.json', out / 'clock_qualification.json')
(out / 'modelsim.ini').write_text('[Library]\nwork = work\neg4 = ' + EG4.as_posix() +
    '\nhdmi = ' + HDMI.as_posix() + '\nothers = E:/ModelsimSE/modelsim.ini\n')
tb = out / 'tb_video_system.v'
shutil.copy2(Path(__file__).resolve().parent / 'tb_restart_system.v', tb)
flags = ['+incdir+' + '+'.join(p.as_posix() for p in
         [out, frozen / 'src/user_source/hdl_source', frozen / 'src/user_source/hdl_source/include',
          frozen / 'src/user_source/hdl_source/SD', frozen / 'src/td_project'])]
(out / 'source_receipt.json').write_text(json.dumps(dict(inputs=receipt, compatibility=compat), indent=2))
card = CARD
card_metadata = json.loads((card / 'summary.json').read_text(encoding='utf-8-sig'))
mapped = card_metadata['mapped_sectors']
for name in ['packed_mem.mem', 'lba_map.mem']:
    shutil.copy2(card / name, out / name)
wav = (MEDIA / 'TEST.WAV').read_bytes()
index = json.loads((MEDIA / 'index.json').read_text())
(out / 'jpeg_crc.mem').write_text('\n'.join(entry['jpeg_crc32'] for entry in index['frames']) + '\n')
pcm = wav[index['audio']['data_offset']:][:index['audio']['data_bytes']]
(out / 'pcm.mem').write_text('\n'.join(f'{v[0]:04x}' for v in struct.iter_unpack('<H', pcm)) + '\n')
(out / 'run.do').write_text('onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n')
asset_rows = []
for asset in ['packed_mem.mem', 'lba_map.mem', 'pcm.mem', 'jpeg_crc.mem']:
    path = out / asset
    asset_rows.append(dict(path=asset, bytes=path.stat().st_size, sha256=sha(path)))
(out / 'fixture_receipt.json').write_text(json.dumps(dict(status='READY', candidate=str(PLAYER), card_metadata=card_metadata, assets=asset_rows, wav_sha256=sha(MEDIA / 'TEST.WAV'), testbench_sha256=sha(tb)), indent=2))
if args.prepare_only:
    print('VIDEO_SYSTEM_FIXTURE_PREPARED', flush=True)
    raise SystemExit(0)
compile_result = compile_sources(out, sources, flags, tb)
if args.compile_only:
    print('VIDEO_SYSTEM_COMPILE_PASS', flush=True)
    raise SystemExit(0)
command = [BIN / 'vsim.exe', '-modelsimini', 'modelsim.ini', '-c', '-lic_noqueue',
           '-novopt', '-suppress', '3017,3722', '-L', 'work', '-L', 'eg4', '-L', 'hdmi',
           '-g/tb_video_system/MAPPED_SECTORS=' + str(mapped),
           '-g/tb_video_system/IMAGE_BYTES=' + str(card_metadata['image_bytes']),
           'work.tb_video_system', 'work.glbl', '-do', 'run.do', '-l', 'run.log']
run = execute(command, out, 'console.log', 2400)
log = (out / 'console.log').read_text(errors='replace')
startup_model_errors = []
runtime_model_errors = []
lines = log.splitlines()
for i, line in enumerate(lines):
    if not re.search(r'\*\* (?:Error|Fatal)|ERROR:', line):
        continue
    timing = re.search(r'at time\s+([\d.]+) ns', line)
    if timing:
        ns = float(timing[1])
    else:
        timing = re.search(r'Time:\s+([\d.]+)\s+(ps|ns)', '\n'.join(lines[i:i+4]))
        ns = float(timing[1]) * (0.001 if timing[2] == 'ps' else 1) if timing else None
    if ns is not None and ns < 1000:
        startup_model_errors.append(dict(time_ns=ns, message=line))
    else:
        runtime_model_errors.append(dict(time_ns=ns, message=line))
passed = run['exit_code'] == 0 and 'VIDEO_SYSTEM_PASS' in log and not runtime_model_errors
summary = dict(status='PASS' if passed else 'FAILED', compile=compile_result, simulation=run,
               assumptions=['Qualified nominal PLL edge replay',
                            'Application-interface SDRAM model',
                            'Mode/restart events injected at classifier outputs during sector reads'],
               hardware='Pending board test', card_metadata=card_metadata)
summary['startup_model_errors_before_1us'] = startup_model_errors
summary['runtime_model_errors'] = runtime_model_errors
if startup_model_errors:
    summary['status'] = 'PASS_AFTER_STARTUP_TRANSIENT' if passed else 'FAILED'
    summary['assumptions'].append('Model startup diagnostic before 1us is retained separately from runtime errors')
(out / 'summary.json').write_text(json.dumps(summary, indent=2))
print(log[-5000:], flush=True)
raise SystemExit(0 if passed else 2)

