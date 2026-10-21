param([switch]$Routed)
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$python = Resolve-AnluPython
$pythonPrefix = @()
if ([IO.Path]::GetFileNameWithoutExtension($python) -ieq 'py') { $pythonPrefix = @('-3') }
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$projectRoot=(Resolve-Path (Join-Path $taskRoot '../..')).Path
$model=Join-Path $taskRoot ('build/model/full_top_snapshot_'+$(if($Routed){'routed'}else{'gate'}))
New-Item -ItemType Directory -Force $model | Out-Null
Set-Location $model
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
$modelBin = $env:ANLU_MODELSIM_BIN
if (-not $modelBin -or -not [IO.Path]::IsPathRooted($modelBin) -or -not (Test-Path -LiteralPath $modelBin -PathType Container)) { throw 'Set ANLU_MODELSIM_BIN to the absolute ModelSim bin directory containing vlib.exe, vlog.exe, and vsim.exe.' }
$modelBin = [IO.Path]::GetFullPath($modelBin)
foreach ($exeName in 'vlib.exe','vlog.exe','vsim.exe') { if (-not (Test-Path -LiteralPath (Join-Path $modelBin $exeName) -PathType Leaf)) { throw "ModelSim executable missing: $(Join-Path $modelBin $exeName)" } }
$modelSimIni = Join-Path (Split-Path -Parent $modelBin) 'modelsim.ini'
if (-not (Test-Path -LiteralPath $modelSimIni -PathType Leaf)) { throw "ModelSim base modelsim.ini is missing: $modelSimIni" }
$baseLib = $env:ANLU_MODELSIM_BASELIB
if (-not $baseLib -or -not [IO.Path]::IsPathRooted($baseLib) -or -not (Test-Path -LiteralPath $baseLib -PathType Container)) { throw 'Set ANLU_MODELSIM_BASELIB to the absolute directory of the compiled vendor library required by this snapshot.' }
$baseLib = [IO.Path]::GetFullPath($baseLib).Replace('\','/')

[IO.File]::WriteAllText((Join-Path $model modelsim.ini),"[Library]`nwork = work`nc11310 = $baseLib`nothers = $modelSimIni`n")
if(!(Test-Path work)){& "$modelBin/vlib.exe" work}
$netlist=Join-Path $taskRoot $(if($Routed){'build/audit/routed_implementation.v'}else{'build/manual/AC201_tf_hdmi_gate.v'})
& $python @pythonPrefix (Join-Path $PSScriptRoot generate_page_forces.py) $netlist (Join-Path $model page_force.vh)
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
