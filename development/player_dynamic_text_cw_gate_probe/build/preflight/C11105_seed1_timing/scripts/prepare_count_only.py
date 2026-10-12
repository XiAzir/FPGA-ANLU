from pathlib import Path
import shutil
import json
import hashlib

root = Path(__file__).resolve().parents[1]
saved = root / 'build/preflight/one_trigger_mslice_4989'
saved.mkdir(parents=True, exist_ok=False)
shutil.copytree(root / 'src', saved / 'src', ignore=shutil.ignore_patterns('run', 'runs', 'work', '.cache'))
shutil.copytree(root / 'scripts', saved / 'scripts')
for name in ['synthesis_console.log', 'physical_console.log', 'cw_gate_before_place.cwc',
             'AC201_tf_hdmi_debug_gate.db', 'AC201_tf_hdmi_debug_gate.v', 'build_source_scope.json']:
    source = root / 'build/manual' / name
    if source.exists():
        shutil.copy2(source, saved / name)
shutil.copytree(root / 'build/manual/stage_evidence', saved / 'stage_evidence')
top = root / 'src/user_source/hdl_source/top_tf_hdmi_audio.v'
text = top.read_text(encoding='utf-8')
start = text.index('// Passive cadence diagnostics; video/audio/PHY datapaths are unchanged.')
end = text.index('player_status_monitor #', start)
replacement = '''// Count-only ChipWatcher candidate C11103. Cadence observer omitted to fit.
// Pages 6..B show FFFFFFF markers: these payloads are NOT measurements.
wire diag_window_toggle;
assign packet_flags=4'hF;
assign packet_samples=24'hFFFFFF;
assign packet_count=24'hFFFFFF;
assign packet_bad_bch=24'hFFFFFF;
assign packet_bad_terc=24'hFFFFFF;
assign packet_tone_bad=24'hFFFFFF;
assign packet_cts=24'hFFFFFF;
assign packet_n=24'hC11103;

'''
top.write_text(text[:start] + replacement + text[end:], encoding='utf-8')
meta_path = root / 'build/preparation.json'
meta = json.loads(meta_path.read_text(encoding='utf-8'))
meta.update(build_id='C11103', status='COUNT_ONLY_PREPARED_NOT_BUILT',
            previous_failure='one-trigger C11102: PHY-9009 MSlice 4989 > 4900',
            omitted='player_cadence_probe instance only; pages 6..B FFFFFFF unavailable markers',
            retained='legacy producer/mailbox/received/display and all 32 ChipWatcher data bits',
            top_sha256=hashlib.sha256(top.read_bytes()).hexdigest())
meta_path.write_text(json.dumps(meta, indent=2), encoding='utf-8')
print('C11103 count-only prepared; prior C11102 preserved')
