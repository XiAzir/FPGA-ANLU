$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../../scripts/anlu_tools.ps1')
$project = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$repo = (Resolve-Path (Join-Path $project '..\..')).Path
$outDir = Join-Path $project 'build\status_axis_model'
$null = New-Item -ItemType Directory -Force -Path $outDir
$iverilog = (Resolve-AnluTool 'iverilog')
$vvp = (Resolve-AnluTool 'vvp')
$hdl = Join-Path $project 'src\user_source\hdl_source\player_status_monitor.v'
$tb = Join-Path $PSScriptRoot 'tb_status_axis_monitor.v'
$compileArgs = @('-g2012','-s','tb_status_axis_monitor','-o',(Join-Path $outDir 'status_axis.vvp'),$tb,$hdl)
$runArgs = @((Join-Path $outDir 'status_axis.vvp'))
$cmd = [ordered]@{iverilog=$iverilog;iverilog_args=$compileArgs;vvp=$vvp;vvp_args=$runArgs;working_directory=$project}
$cmd | ConvertTo-Json -Depth 4 | Set-Content -Encoding utf8 (Join-Path $outDir 'command_args.json')
$bindings = [ordered]@{generated_utc=[DateTime]::UtcNow.ToString('o');sources=@()}
foreach($file in @($tb,$hdl,$PSCommandPath)) {$bindings.sources += [ordered]@{path=$file;sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $file).Hash}}
$bindings | ConvertTo-Json -Depth 5 | Set-Content -Encoding utf8 (Join-Path $outDir 'source_bindings.json')
$log = Join-Path $outDir 'run.log'
Set-Content -Encoding utf8 $log "Icarus status monitor integration audit`r`n"
Push-Location $project
try {
  & $iverilog @compileArgs 2>&1 | Tee-Object -FilePath $log -Append
  if($LASTEXITCODE -ne 0){throw "iverilog exited $LASTEXITCODE"}
  & $vvp @runArgs 2>&1 | Tee-Object -FilePath $log -Append
  if($LASTEXITCODE -ne 0){throw "vvp exited $LASTEXITCODE"}
} catch { Add-Content -Encoding utf8 $log "FAILED: $_"; throw } finally { Pop-Location }

