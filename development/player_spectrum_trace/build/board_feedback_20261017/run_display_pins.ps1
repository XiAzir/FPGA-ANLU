$ErrorActionPreference='Stop'
$here=$PSScriptRoot
$projectRoot=(Resolve-Path (Join-Path $here '../../../..')).Path
python (Join-Path $here extract_display_cone.py) *> (Join-Path $here extract_display.log)
if($LASTEXITCODE){throw 'cone extraction failed'}
$model=Join-Path $here display_cone
Set-Location $model
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
$bin='E:/ModelsimSE/win64'
$base=(Join-Path $projectRoot 'development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/modelsim/work').Replace('\','/')
[IO.File]::WriteAllText((Join-Path $model modelsim.ini),"[Library]`nwork = work`nc11310 = $base`nothers = E:/ModelsimSE/modelsim.ini`n")
if(!(Test-Path work)){& "$bin/vlib.exe" work}
& "$bin/vlog.exe" -work work display_cone.v (Join-Path $here tb_display_pins.v) *> compile.log
if($LASTEXITCODE){throw 'display cone compile failed'}
@'
onerror {quit -code 2 -f}
onbreak {quit -code 3 -f}
run -all
quit -code 0 -f
'@ | Set-Content run.do
& "$bin/vsim.exe" -c -novopt -lic_noqueue -suppress 3017,3722 -L work -L c11310 work.tb_display_pins c11310.glbl -do run.do -l run.log *> console.log
if($LASTEXITCODE){throw 'display pin simulation process failed'}
$result=Get-Content console.log -Raw
if($result -notmatch 'PASS routed_display_pins' -or $result -match '# FAIL'){throw 'display pin test did not pass; inspect console.log'}
Select-String -Path console.log -Pattern 'WORD_PASS|MISMATCH|PASS routed_display_pins'
