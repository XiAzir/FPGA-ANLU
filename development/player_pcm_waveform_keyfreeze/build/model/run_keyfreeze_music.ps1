$ErrorActionPreference='Stop'
$taskProject=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$taskWorkspace=(Resolve-Path (Join-Path $taskProject '../..')).Path
$taskHdl=Join-Path $taskProject 'src/user_source/hdl_source'
. (Join-Path $PSScriptRoot '../../../../scripts/anlu_tools.ps1')
$taskIver=(Resolve-AnluTool 'iverilog')
$taskVvp=(Resolve-AnluTool 'vvp')
Push-Location $PSScriptRoot
try {
 & $taskIver -g2012 -s tb_keyfreeze_music -o 'keyfreeze_music.vvp' 'tb_keyfreeze_music.v' "$taskHdl/player_pcm_waveform.v" "$taskHdl/player_rgb_adjust.v" "$taskHdl/player_adjust_osd.v" "$taskHdl/player_osd.v" "$taskHdl/player_dynamic_text.v" *> 'keyfreeze_music_compile.log'
 if($LASTEXITCODE -ne 0){Get-Content 'keyfreeze_music_compile.log';throw 'Keyfreeze music compile failed'}
 & $taskVvp 'keyfreeze_music.vvp' *> 'keyfreeze_music.log'
 if($LASTEXITCODE -ne 0){Get-Content 'keyfreeze_music.log';throw 'Keyfreeze music failed'}
 Get-Content 'keyfreeze_music.log'
 if(!(Select-String -LiteralPath 'keyfreeze_music.log' -Pattern '^PASS ' -Quiet)){throw 'Missing PASS'}
} finally {Pop-Location}
