$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot '../../scripts/anlu_tools.ps1')
$taskBuild=Join-Path $PSScriptRoot 'build'
New-Item -ItemType Directory -Force -Path $taskBuild | Out-Null
$taskSource=(Resolve-Path (Join-Path $PSScriptRoot '../player_spectrum_resource_80/src/user_source/hdl_source/SD/spi_master.v')).Path
$taskIverilog=Resolve-AnluTool -Name 'iverilog'
$taskVvp=Resolve-AnluTool -Name 'vvp'
$taskImage=Join-Path $taskBuild 'mode3.vvp'
& $taskIverilog -g2012 -s tb_spi_mode3 -o $taskImage (Join-Path $PSScriptRoot 'tb_spi_mode3.v') $taskSource 2>&1 | Tee-Object -FilePath (Join-Path $taskBuild 'compile.log')
if($LASTEXITCODE -ne 0){ throw 'Mode 3 test compile failed' }
& $taskVvp $taskImage 2>&1 | Tee-Object -FilePath (Join-Path $taskBuild 'run.log')
if($LASTEXITCODE -ne 0){ throw 'Mode 3 test failed' }
[ordered]@{source=$taskSource;source_sha256=(Get-FileHash -LiteralPath $taskSource).Hash;
 testbench_sha256=(Get-FileHash -LiteralPath (Join-Path $PSScriptRoot 'tb_spi_mode3.v')).Hash;
 run_sha256=(Get-FileHash -LiteralPath (Join-Path $taskBuild 'run.log')).Hash;
 status='PASS_MODE3_DIGITAL_DELAY_MODEL';production_changes=0} |
 ConvertTo-Json | Set-Content -LiteralPath (Join-Path $taskBuild 'receipt.json') -Encoding utf8
