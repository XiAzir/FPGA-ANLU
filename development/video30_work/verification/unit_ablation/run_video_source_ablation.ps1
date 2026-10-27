param(
  [string]$Repo = (Resolve-Path (Join-Path $PSScriptRoot '../../../..')).Path
)
$ErrorActionPreference = 'Stop'
. (Join-Path $Repo 'scripts/anlu_tools.ps1')
$iverilog = Resolve-AnluTool -Name iverilog
$vvp = Resolve-AnluTool -Name vvp
$outDir = $PSScriptRoot
$baselineProbe = Join-Path $Repo 'development/player_video29_media_flow/src/user_source/hdl_source/player_video_source_probe.v'
$tb = Join-Path $outDir 'tb_video_source_ablation.v'
$sim = Join-Path $outDir 'video_source_ablation.vvp'
$compileLog = Join-Path $outDir 'iverilog_compile.log'
$runLog = Join-Path $outDir 'vvp_run.log'
$compileOutput = & $iverilog -g2012 -s tb_video_source_ablation -o $sim $tb $baselineProbe 2>&1
$compileExit = $LASTEXITCODE
@("Tool: $iverilog", "Command: iverilog -g2012 -s tb_video_source_ablation -o $sim $tb $baselineProbe", "ExitCode: $compileExit", 'Output:') + $(if ($compileOutput) { $compileOutput } else { '[no diagnostics]' }) | Set-Content -Encoding utf8 $compileLog
if ($compileExit -ne 0) { throw "iverilog failed ($compileExit)" }
& $vvp $sim 2>&1 | Tee-Object -FilePath $runLog
if ($LASTEXITCODE -ne 0) { throw "vvp failed ($LASTEXITCODE)" }
if (-not (Select-String -Quiet -Path $runLog -Pattern '^PASS source-probe ablation:')) { throw 'PASS marker missing from vvp log' }
