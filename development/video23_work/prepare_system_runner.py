from pathlib import Path
p=Path('development/video20_work/run_video_system.py')
t=p.read_text(encoding='utf-8-sig').replace('Exercise C11320','Exercise C11323')
anchor="    if path.name == 'frame_read_write.v':"
extra="""    if path.name == 'frame_buffer_rgb888.v':
        match=re.search(r'    assign debug_memory=.*?;',text,re.S)
        assert match
        declaration=match.group()
        text=text[:match.start()]+text[match.end():]
        position=text.index('    // Reject unsupported geometry')
        text=text[:position]+declaration+'\\n'+text[position:]
"""
t=t.replace(anchor,extra+anchor)
t=t.replace("PLAYER = ROOT / 'development/player_video20'", "PLAYER = ROOT / 'development/player_video23_mode_switch'")
Path('development/video23_work/run_video_system.py').write_text(t,encoding='utf-8')
Path('development/video23_work/tb_video_system.v').write_bytes(Path('development/video20_work/tb_video_system.v').read_bytes())
