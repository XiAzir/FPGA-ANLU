import hashlib, json
from pathlib import Path

new = Path(__file__).resolve().parent.parent
base = Path('E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi')
digest = lambda p: hashlib.sha256(p.read_bytes()).hexdigest().upper()
base_hdl = base / 'src/user_source'
new_hdl = new / 'src/user_source'
changed = []; missing = []
for path in base_hdl.rglob('*'):
    if path.is_file():
        rel=path.relative_to(base_hdl)
        other=new_hdl / rel
        if not other.exists(): missing.append(str(rel))
        elif digest(path)!=digest(other): changed.append(rel.as_posix())
added=[p.relative_to(new_hdl).as_posix() for p in new_hdl.rglob('*') if p.is_file() and not (base_hdl / p.relative_to(new_hdl)).exists()]
assert set(changed)=={'hdl_source/top_tf_hdmi_audio.v','hdl_source/SD/sd_card_bmp.v',
                     'hdl_source/SD/frame_read_write.v'}, changed
assert set(added)=={'hdl_source/frame_buffer_rgb888.v','hdl_source/rgb888_word_codec.v'}, added
assert not missing, missing
baseline_bit=base / 'build/manual/AC201_tf_hdmi.bit'
assert digest(baseline_bit)=='9A8B841C11AAA3B65996811987AD7899D548B3D700B3012B24B13F7AEB169A1A'
checkpoint=new / 'checkpoints/rgb888_interface'
assert digest(checkpoint / 'AC201_tf_hdmi.bit')=='6B693DC659AC19985612F391A0EE8FD90533AEC63C6C4DEF0D993C0340C28160'
stage_changed=[]
for path in (checkpoint / 'src/user_source').rglob('*'):
    if path.is_file():
        rel=path.relative_to(checkpoint / 'src/user_source')
        assert (new_hdl / rel).exists(), str(rel)
        if digest(path)!=digest(new_hdl / rel): stage_changed.append(rel.as_posix())
assert set(stage_changed)=={'hdl_source/frame_buffer_rgb888.v','hdl_source/SD/frame_read_write.v'},stage_changed
result={'baseline_root':str(base),'development_root':str(new),'changed_user_source':changed,'added_user_source':added,'missing_user_source':missing,
        'changes_since_verified_interface':stage_changed,'new_since_interface':['hdl_source/rgb888_word_codec.v'],
        'pins_sdc_pll_audio_and_remaining_user_source_identical':True,'baseline_bit_sha256':digest(baseline_bit),
        'interface_checkpoint_bit_sha256':digest(checkpoint / 'AC201_tf_hdmi.bit'),
        'compact_RGB888_storage_implemented':True,'functional_simulation_evidence':'build/sim',
        'board_validation':'not performed for compact development bitstream'}
(new / 'build/source_change_audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print('SOURCE_SCOPE_AND_BASELINE_HASH_PASS')
