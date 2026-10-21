"""Replay the established C11312 full-media fixture against selected candidate RTL."""
from pathlib import Path
import sys, json, inspect, re

ROOT=Path(__file__).resolve().parents[2]
FIXTURE=ROOT/'development/system_verification_20261016/integration'
sys.path.insert(0,str(FIXTURE))
import common

candidate=ROOT/'development/player_spectrum_resource_fit'
hdl=candidate/'src/user_source/hdl_source'
changed=('fat32_catalog.v','fat32_file_sector.v','bmp_scale_engine.v',
         'tf_bmp_file_player.v','player_pcm_waveform.v','top_tf_hdmi_audio.v',
         'player_status_monitor.v','sd_card_bmp.v','player_audio_probe.v')
# C11312 uses a manifest object with a files list; older fixture releases
# use a bare list. Keep the original per-file SHA verification in both cases.
loader_text=inspect.getsource(common.archived_sources)
loader_text=loader_text.replace(" manifest=json.loads((cp/'manifest.json').read_text(encoding='utf-8-sig'))", " manifest=json.loads((cp/'manifest.json').read_text(encoding='utf-8-sig'))\n if isinstance(manifest,dict):manifest=manifest['files']")
exec(compile(loader_text,str(FIXTURE/'common.py'),'exec'),common.__dict__)
original_loader=common.archived_sources

def candidate_sources(version,cwd,exclude=()):
    sources,flags,receipt=original_loader(version,cwd,exclude)
    overrides=[]
    for i,source in enumerate(sources):
        production_name=source.name.replace('_compat.v','.v')
        if production_name in changed:
            selected=hdl/('SD/sd_card_bmp.v' if production_name=='sd_card_bmp.v' else production_name)
            copy=cwd/('candidate_'+production_name)
            selected_text=selected.read_text(encoding='utf-8-sig')
            if production_name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
                pattern=(r'^\s*wire\s+bmp_write_ready\s*;[^\n]*\n' if production_name=='top_tf_hdmi_audio.v' else r'^\s*reg\s+request_toggle,\s*ack_sync0,\s*ack_sync1\s*;[^\n]*\n')
                declaration=re.search(pattern,selected_text,re.M)
                if declaration:
                    moved=selected_text[:declaration.start()]+selected_text[declaration.end():]
                    anchor=moved.index(';',moved.index('module '))+1
                    selected_text=moved[:anchor]+'\n'+declaration.group().strip()+'\n'+moved[anchor:]
            copy.write_text(selected_text,encoding='utf-8')
            overrides.append(dict(path=str(selected),sha256=common.sha(selected),
                                  reference_path=str(source),reference_sha256=common.sha(source)))
            sources[i]=copy
    assert len(overrides)==len(changed),overrides
    receipt['candidate_overrides']=overrides
    (cwd/'source_receipt.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
    return sources,flags,receipt

common.archived_sources=candidate_sources
text=(FIXTURE/'run_system.py').read_text(encoding='utf-8')
text=text.replace("  manifest=json.loads((Path(receipt['checkpoint'])/'manifest.json').read_text(encoding='utf-8-sig'))", "  manifest=json.loads((Path(receipt['checkpoint'])/'manifest.json').read_text(encoding='utf-8-sig'))\n  if isinstance(manifest,dict):manifest=manifest['files']")
text=text.replace("out=BASE/'integration'/('run_'+a.version+'_'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()", "out=Path("+repr(str(candidate/'build'))+")/('system_'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()")
sys.argv=['run_system_candidate.py','--version','C11312','--clock-model','replay',
          '--max-ms','200','--serial-scoreboard']+sys.argv[1:]
exec(compile(text,str(FIXTURE/'run_system.py'),'exec'))
