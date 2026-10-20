$ErrorActionPreference='Stop'
$here=$PSScriptRoot
$task=(Resolve-Path (Join-Path $here '../..')).Path
$root=(Resolve-Path (Join-Path $task '../..')).Path
$model=Join-Path $here upstream_version
New-Item -ItemType Directory -Force $model | Out-Null
$tb=Get-Content (Join-Path $task sim/tb_snapshot_gate_top.v) -Raw
$tb=$tb.Replace('page_sel<=8','page_sel<=9').Replace("8:expected_word=32'hc8000001;","8:expected_word=32'hc8000001;9:expected_word=32'hdfc11312;")
$tb=$tb.Replace('display_mailbox_words=7','display_mailbox_words=8 includes_DFC11312=1')
[IO.File]::WriteAllText((Join-Path $model tb_snapshot_gate_top.v),$tb)
$netlist=Join-Path $task build/audit/routed_implementation.v
python (Join-Path $task sim/generate_page_forces.py) $netlist (Join-Path $model page_force.vh)
if($LASTEXITCODE){throw 'page forces failed'}
Set-Location $model
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
$bin='E:/ModelsimSE/win64'
$base=(Join-Path $root 'development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/modelsim/work').Replace('\','/')
[IO.File]::WriteAllText((Join-Path $model modelsim.ini),"[Library]`nwork = work`nc11310 = $base`nothers = E:/ModelsimSE/modelsim.ini`n")
if(!(Test-Path work)){& "$bin/vlib.exe" work}
& "$bin/vlog.exe" -work work "+incdir+$model" $netlist tb_snapshot_gate_top.v *> compile.log
if($LASTEXITCODE){throw 'compile failed'}
@'
onerror {quit -code 2 -f}
onbreak {quit -code 3 -f}
run -all
quit -code 0 -f
'@ | Set-Content run.do
& "$bin/vsim.exe" -c -novopt -lic_noqueue -suppress 3017,3722 -L work -L c11310 work.tb_snapshot_gate_top c11310.glbl -do run.do -l run.log *> console.log
if($LASTEXITCODE){throw 'run failed'}
$r=Get-Content console.log -Raw
if($r -notmatch 'PASS full_top_snapshot' -or $r -match '# FAIL' -or $r -notmatch 'Loading work.top' -or $r -notmatch 'includes_DFC11312=1'){throw 'upstream version check failed'}
Select-String -Path console.log -Pattern 'DISPLAY_WORD|PASS full_top_snapshot'
