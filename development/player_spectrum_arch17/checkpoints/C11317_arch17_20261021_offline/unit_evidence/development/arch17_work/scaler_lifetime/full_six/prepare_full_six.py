from pathlib import Path
import hashlib, json, re

root = Path(__file__).resolve().parents[4]
out = Path(__file__).resolve().parent
hdl = root / 'development/player_spectrum_opt16/src/user_source/hdl_source'
engine_base = hdl / 'bmp_scale_engine.v'
loader = hdl / 'tf_bmp_file_player.v'
engine_candidate = root / 'development/arch17_work/scaler_lifetime/bmp_scale_engine_candidate.v'
full_template = root / 'development/arch17_work/scaler_lifetime/tb_full_paired.v'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def exact(path, expected):
    actual = sha(path)
    if actual.lower() != expected.lower():
        raise SystemExit(f'SHA mismatch for {path}: {actual} != {expected}')

exact(engine_base, 'f3d77c0dcaac1a43c59e30deb51b06988a81a9d91f0c6135f0eb17158057c04c')
exact(loader, '8c4c61c8f8474ae44115c3ac0a056910886996302cd0845b775cf00a8b28f5b7')
exact(engine_candidate, 'cde50900d2307674272134b2043c1cd26b53f1372fad913eef1b227a7f9706e2')

base_text = engine_base.read_text(encoding='utf-8-sig')
cand_text = engine_candidate.read_text(encoding='utf-8-sig')
assert base_text.count('module bmp_scale_engine #') == 1
assert cand_text.count('module bmp_scale_engine #') == 1
(out/'bmp_scale_engine_base_pair.v').write_text(base_text.replace('module bmp_scale_engine #','module bmp_scale_engine_base_pair #',1), encoding='ascii')
(out/'bmp_scale_engine_candidate_pair.v').write_text(cand_text.replace('module bmp_scale_engine #','module bmp_scale_engine_candidate_pair #',1), encoding='ascii')

loader_text = loader.read_text(encoding='utf-8-sig')
assert loader_text.count('module tf_bmp_file_player #') == 1
assert loader_text.count('bmp_scale_engine #(.HEADER_VALIDATED(1),') == 1
base_loader = loader_text.replace('module tf_bmp_file_player #','module tf_bmp_file_player_base_pair #',1).replace('bmp_scale_engine #(','bmp_scale_engine_base_pair #(',1)
cand_loader = loader_text.replace('module tf_bmp_file_player #','module tf_bmp_file_player_candidate_pair #',1).replace('bmp_scale_engine #(','bmp_scale_engine_candidate_pair #(',1)
(out/'tf_bmp_file_player_base_pair.v').write_text(base_loader, encoding='ascii')
(out/'tf_bmp_file_player_candidate_pair.v').write_text(cand_loader, encoding='ascii')

full = full_template.read_text(encoding='utf-8-sig')
pat = r'tf_bmp_file_player_param #\(\.HEADER_VALIDATED\(HEADER_VALIDATED\),\s*(.*?)\) dut \((.*?)\n    \);'
m = re.search(pat, full, re.S)
assert m, 'unable to locate parameterized loader instance in full-paired TB'
params, ports = m.groups()
branch = '''generate if (USE_CANDIDATE == 0) begin : g_baseline
        tf_bmp_file_player_base_pair #(\nPARAMS\n        ) dut (\nPORTS\n        );
    end else begin : g_candidate
        tf_bmp_file_player_candidate_pair #(\nPARAMS\n        ) dut (\nPORTS\n        );
    end endgenerate'''.replace('PARAMS', params).replace('PORTS', ports)
full = full[:m.start()] + branch + full[m.end():]
full = full.replace('parameter integer HEADER_VALIDATED = 0','parameter integer USE_CANDIDATE = 0',1)
full = full.replace('.HEADER_VALIDATED(0)', '.USE_CANDIDATE(0)')
full = full.replace('.HEADER_VALIDATED(1)', '.USE_CANDIDATE(1)')
full = full.replace('_validated', '_candidate')
full = re.sub(r'\$display\("DETAIL engine_state=.*?dut\.u_scale\.y_phase\);', '$display("DETAIL hierarchical engine probe omitted in separately renamed baseline/candidate loaders");', full, flags=re.S)
full = full.replace('pairs=C11315/HEADER_VALIDATED', 'pairs=C11316/CANDIDATE_HEADER_VALIDATED1')
(out/'tb_full_six.v').write_text(full, encoding='ascii')

memdir = root / 'development/resource80_work/catalog/stride_experiment/test_media'
media = sorted(set(re.findall(r'"(E:/VSCODE-project/FPGA-ANLU/development/resource80_work/catalog/stride_experiment/test_media/[^\"]+\.mem)"', full)))
assert len(media) == 12, f'expected 12 source/golden media files, found {len(media)}'
media_records=[]
for item in media:
    p=Path(item)
    if not p.is_file(): raise SystemExit(f'missing simulation media: {p}')
    media_records.append({'path':str(p),'bytes':p.stat().st_size,'sha256':sha(p)})

receipt = {
  'experiment':'arch17_scaler_lifetime_full_six_paired',
  'baseline_engine_source':{'path':str(engine_base),'sha256':sha(engine_base)},
  'candidate_engine_source':{'path':str(engine_candidate),'sha256':sha(engine_candidate)},
  'shared_c11316_loader_source':{'path':str(loader),'sha256':sha(loader)},
  'baseline_engine_as_run':{'path':str(out/'bmp_scale_engine_base_pair.v'),'sha256':sha(out/'bmp_scale_engine_base_pair.v')},
  'candidate_engine_as_run':{'path':str(out/'bmp_scale_engine_candidate_pair.v'),'sha256':sha(out/'bmp_scale_engine_candidate_pair.v')},
  'baseline_loader_as_run':{'path':str(out/'tf_bmp_file_player_base_pair.v'),'sha256':sha(out/'tf_bmp_file_player_base_pair.v')},
  'candidate_loader_as_run':{'path':str(out/'tf_bmp_file_player_candidate_pair.v'),'sha256':sha(out/'tf_bmp_file_player_candidate_pair.v')},
  'testbench_template':{'path':str(full_template),'sha256':sha(full_template)},
  'testbench_as_run':{'path':str(out/'tb_full_six.v'),'sha256':sha(out/'tb_full_six.v')},
  'production_parameter':{'HEADER_VALIDATED':1,'FRAME_WIDTH':640,'FRAME_HEIGHT':480,'WAIT_LIMIT':50000000},
  'comparison':'All loader public outputs packed in observation are compared cycle-by-cycle for each of six paired image drivers; each pair independently checks all 307200 24-bit pixels against its RGB golden.',
  'expected_total_pixels':1843200,
  'images':media_records,
  'simulation':{'tool':'Icarus Verilog from repository bringup/tf_wav_hdmi/tools/iverilog/app/bin','compile_flags':['-g2001','-s','tb_scaler_full_loader'],'result':'pending'}
}
(out/'source_receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'output':str(out),'baseline_engine_sha256':sha(engine_base),'candidate_engine_sha256':sha(engine_candidate),'loader_sha256':sha(loader),'tb_sha256':sha(out/'tb_full_six.v'),'media_files':len(media),'pixels':1843200},indent=2))


