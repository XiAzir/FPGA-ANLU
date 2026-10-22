from pathlib import Path
from datetime import datetime
import argparse, json, re, shutil, sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
BASE = ROOT / 'development/system_verification_20261016'
sys.path.insert(0, str(BASE / 'integration'))
from common import BIN, EG4, compile_sources, execute, sha
parser = argparse.ArgumentParser()
parser.add_argument('--write-priority', action='store_true')
args = parser.parse_args()

out = HERE / 'runs' / datetime.now().strftime('%Y%m%d_%H%M%S')
out.mkdir(parents=True)
hdl = ROOT / 'development/player_video19/src/user_source/hdl_source'
info = json.loads((BASE / 'memory/controller_gate_latest.json').read_text())
gate = Path(info['directory']) / 'build/controller_gate.v'
assert sha(gate) == info['gate_sha256'].upper()
originals = [hdl / p for p in [
    'frame_buffer_rgb888.v', 'rgb888_word_codec.v', 'rgb565_word_codec.v',
    'jpeg420_word_address.v', 'player_wipe_address.v',
    'SD/frame_read_write.v', 'SD/frame_fifo_write.v', 'SD/frame_fifo_read.v',
    'IP/afifo_16_32_256.v', 'IP/afifo_32_16_256.v', 'include/global_def.v']]
originals += [gate, BASE / 'memory/sdram_issi_reference_wrapper.v',
    Path('E:/QQ CACHE/Download/安路资料/赛题1_工作资料/05_补充参考工程/APUG011_SDRAM参考工程/source_code/model/IS42s32200.v'),
    Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_glbl.v')]
sources = []
receipt = []
for original in originals:
    target = out / original.name
    shutil.copy2(original, target)
    receipt.append(dict(source=str(original), sha256=sha(original)))
    if target.name == 'frame_read_write.v':
        text = target.read_text(encoding='utf-8-sig')
        if args.write_priority:
            text = text.replace('assign App_rd_busy = O_rd_busy || (write_jpeg420 && read_refill_request);',
                                'assign App_rd_busy = O_rd_busy;')
        for signal in ['rdusedw', 'wrusedw']:
            instance = 'frame_fifo_write_m0' if signal == 'rdusedw' else 'frame_fifo_read_m0'
            start = text.index(instance)
            end = text.index(');', start) + 2
            block, count = re.subn(r'(\.' + signal + r'\s*\()\s*' + signal + r'\s*(\))',
                lambda m: m[1] + "{1'b0," + signal + '}' + m[2], text[start:end])
            assert count == 1
            text = text[:start] + block + text[end:]
        target.write_text(text, encoding='utf-8')
    sources.append(target)
(out / 'source_receipt.json').write_text(json.dumps(dict(inputs=receipt,
    write_priority_ablation=args.write_priority,
    scope='Live pixel pack/FIFOs/arbiters + SHA-bound synthesized SDRAM controller + APUG011 pin memory, nominal clocks, no SDF',
    compatibility='Explicit unsigned 9-to-10-bit FIFO count extension for old ModelSim'), indent=2))
(out / 'modelsim.ini').write_text('[Library]\nwork = work\neg4 = ' + EG4.as_posix() + '\nothers = E:/ModelsimSE/modelsim.ini\n')
tb = out / 'tb_video_framebuffer.v'
shutil.copy2(HERE / tb.name, tb)
compiled = compile_sources(out, sources, ['+incdir+' + out.as_posix()], tb)
(out / 'run.do').write_text('onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n')
print(out, flush=True)
result = execute([BIN / 'vsim.exe', '-modelsimini', 'modelsim.ini', '-c', '-lic_noqueue',
    '-suppress', '3017,3722', '-L', 'work', '-L', 'eg4',
    'work.tb_video_framebuffer', 'work.glbl', '-do', 'run.do', '-l', 'run.log'], out, 'console.log', 900)
log = (out / 'console.log').read_text(errors='replace')
passed = result['exit_code'] == 0 and 'VIDEO_GATE_FRAMEBUFFER_PASS' in log and not re.search(r'\*\* (?:Error|Fatal)|ERROR:', log)
(out / 'summary.json').write_text(json.dumps(dict(status='PASS_SCOPE_PIN_MODEL' if passed else 'FAILED',
    compile=compiled, simulation=result, testbench_sha256=sha(tb)), indent=2))
print(log[-3500:], flush=True)
raise SystemExit(0 if passed else 2)
