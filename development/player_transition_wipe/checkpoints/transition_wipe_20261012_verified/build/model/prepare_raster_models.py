from pathlib import Path
p=Path(__file__).parent
tb=p/'tb_player_pcm_waveform.v'
text=tb.read_text(encoding='utf-8-sig')
if '.freeze_toggle(' not in text:
    text=text.replace('.tone_mode(tone_mode),','.tone_mode(tone_mode), .freeze_toggle(1\'b0),').replace('.tone_mode(1\'b0),','.tone_mode(1\'b0), .freeze_toggle(1\'b0),')
tb.write_text(text,encoding='utf-8')
tb=p/'tb_waveform_integration.v'
text=tb.read_text(encoding='utf-8-sig').replace('a1,av,ap,tone,out);','a1,av,ap,tone,1\'b0,out);')
tb.write_text(text,encoding='utf-8')
frozen=text.replace('module tb_waveform_integration;','module tb_keyfreeze_music;').replace('reg av=0;','reg freeze_toggle=0;reg av=0;').replace("a1,av,ap,tone,1'b0,out);",'a1,av,ap,tone,freeze_toggle,out);')
frozen=frozen.replace('tick(4);\n for(f=0;', '''tick(4);
 // First display the complete real-music window, then freeze that visible
 // front at a separate VS. The acoustic input keeps changing while held.
 vs=1;tick(4);vs=0;tick(4);
 freeze_toggle=1;tick(1);freeze_toggle=0;tick(2);
 vs=1;tick(4);vs=0;tick(4);
 if(!wave_display.frozen_front || wave_display.capture_active)$fatal(1,"manual freeze did not commit");
 av=1;ap=24'h7fff00;
 for(f=0;''')
frozen=frozen.replace('PASS full integration:', 'PASS MANUAL FREEZE real music integration:').replace('brightness/OSD/RUN/scroll/blanking unaffected outside panel','all512 graph columns hold PCM gold despite dense new extreme samples; brightness/OSD/RUN/scroll/blanking unaffected outside panel')
(p/'tb_keyfreeze_music.v').write_text(frozen,encoding='utf-8')
