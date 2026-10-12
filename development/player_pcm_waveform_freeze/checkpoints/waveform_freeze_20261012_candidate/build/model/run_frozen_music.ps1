$ErrorActionPreference='Stop'
$taskProject=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$taskWorkspace=(Resolve-Path (Join-Path $taskProject '../..')).Path
$taskHdl=Join-Path $taskProject 'src/user_source/hdl_source'
$taskIver=Join-Path $taskWorkspace 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$taskVvp=Join-Path $taskWorkspace 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$taskTb=Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'tb_waveform_integration.v')
$taskTb=$taskTb.Replace('module tb_waveform_integration;', 'module tb_frozen_music_integration;')
$taskTb=$taskTb.Replace('player_pcm_waveform wave_display(', 'player_pcm_waveform #(.DIAG_FREEZE_AFTER_SAMPLES(1024)) wave_display(')
$taskTb=$taskTb.Replace('vs=1;tick(4);vs=0;tick(4);', 'vs=1;tick(4);vs=0;tick(4); if (!wave_display.frozen_front || wave_display.capture_active) $fatal(1,"front not frozen"); av=1;ap=24''h7fff00;')
$taskTb=$taskTb.Replace('PASS full integration:', 'PASS FROZEN real music integration (1024-event diagnostic threshold):')
$taskTb=$taskTb.Replace('brightness/OSD/RUN/scroll/blanking unaffected outside panel', 'all512 graph columns retain independent PCM gold despite dense new extreme PCM; brightness/OSD/RUN/scroll/blanking unaffected outside panel')
Set-Content -LiteralPath (Join-Path $PSScriptRoot 'tb_frozen_music_integration.v') -Value $taskTb -Encoding utf8
Push-Location $PSScriptRoot
try {
 & $taskIver -g2012 -s tb_frozen_music_integration -o 'frozen_music.vvp' 'tb_frozen_music_integration.v' "$taskHdl/player_pcm_waveform.v" "$taskHdl/player_rgb_adjust.v" "$taskHdl/player_adjust_osd.v" "$taskHdl/player_osd.v" "$taskHdl/player_dynamic_text.v" *> 'frozen_music_compile.log'
 if($LASTEXITCODE -ne 0){Get-Content 'frozen_music_compile.log';throw 'Frozen music compile failed'}
 & $taskVvp 'frozen_music.vvp' *> 'frozen_music_integration.log'
 if($LASTEXITCODE -ne 0){Get-Content 'frozen_music_integration.log';throw 'Frozen music model failed'}
 Get-Content 'frozen_music_integration.log'
} finally {Pop-Location}
