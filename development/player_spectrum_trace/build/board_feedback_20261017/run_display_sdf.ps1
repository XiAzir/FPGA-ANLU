$ErrorActionPreference='Stop'
$here=$PSScriptRoot
$root=(Resolve-Path (Join-Path $here '../../../..')).Path
$model=Join-Path $here display_sdf
New-Item -ItemType Directory -Force $model | Out-Null
Set-Location $model
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
$bin='E:/ModelsimSE/win64'
$base=(Join-Path $root 'development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/modelsim/work').Replace('\','/')
[IO.File]::WriteAllText((Join-Path $model modelsim.ini),"[Library]`nwork = work`nc11310 = $base`nothers = E:/ModelsimSE/modelsim.ini`n")
if(!(Test-Path work)){& "$bin/vlib.exe" work}
& "$bin/vlog.exe" -work work (Join-Path $here display_cone/display_cone.v) (Join-Path $here tb_display_pins.v) *> compile.log
if($LASTEXITCODE){throw 'compile failed'}
@'
onerror {quit -code 2 -f}
onbreak {quit -code 3 -f}
run -all
quit -code 0 -f
'@ | Set-Content run.do
$sdf=(Join-Path $here display_cone/display.sdf).Replace('\','/')
& "$bin/vsim.exe" -c -novopt -lic_noqueue -suppress 3017,3722 -L work -L c11310 -sdfmax "/tb_display_pins/dut=$sdf" work.tb_display_pins c11310.glbl +quick -do run.do -l run.log *> console.log
if($LASTEXITCODE){throw 'SDF run failed; see console.log'}
$result=Get-Content console.log -Raw
if($result -notmatch 'PASS sdf_display_fixed' -or $result -match '# FAIL'){throw 'SDF fixed word test did not pass'}
Select-String -Path console.log -Pattern 'PASS|SDF|Warning|Error'
