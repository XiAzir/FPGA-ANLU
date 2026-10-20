param([switch]$Routed)
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$projectRoot=(Resolve-Path (Join-Path $taskRoot '../..')).Path
$model=Join-Path $taskRoot ('build/model/full_top_snapshot_'+$(if($Routed){'routed'}else{'gate'}))
New-Item -ItemType Directory -Force $model | Out-Null
Set-Location $model
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
$modelBin='E:/ModelsimSE/win64'
$baseLib=(Resolve-Path (Join-Path $projectRoot 'development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/modelsim/work')).Path.Replace('\','/')
[IO.File]::WriteAllText((Join-Path $model modelsim.ini),"[Library]`nwork = work`nc11310 = $baseLib`nothers = E:/ModelsimSE/modelsim.ini`n")
if(!(Test-Path work)){& "$modelBin/vlib.exe" work}
$netlist=Join-Path $taskRoot $(if($Routed){'build/audit/routed_implementation.v'}else{'build/manual/AC201_tf_hdmi_gate.v'})
python (Join-Path $PSScriptRoot generate_page_forces.py) $netlist (Join-Path $model page_force.vh)
if($LASTEXITCODE){throw 'page selector force generation failed'}
& "$modelBin/vlog.exe" -work work "+incdir+$model" $netlist (Join-Path $PSScriptRoot tb_snapshot_gate_top.v) *> compile.log
if($LASTEXITCODE){throw 'full top snapshot compile failed'}
@'
onerror {quit -code 2 -f}
onbreak {quit -code 3 -f}
run -all
quit -code 0 -f
'@ | Set-Content run.do
& "$modelBin/vsim.exe" -c -novopt -lic_noqueue -suppress 3017,3722 -L work -L c11310 work.tb_snapshot_gate_top c11310.glbl -do run.do -l run.log *> console.log
if($LASTEXITCODE){throw 'full top snapshot simulation failed'}
$text=Get-Content console.log -Raw
if($text -notmatch 'PASS full_top_snapshot' -or $text -match '# FAIL' -or $text -notmatch 'Loading work.top'){throw 'snapshot full top test or candidate library binding did not pass; see console.log'}
Select-String -Path console.log -Pattern 'BOUNDARY|SNAPSHOT captured|PASS full_top_snapshot'
