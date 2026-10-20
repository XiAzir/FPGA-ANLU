$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$repoRoot = (Resolve-Path (Join-Path $projectRoot '../..')).Path
$iverilog = (Resolve-AnluTool 'iverilog')
$vvp = (Resolve-AnluTool 'vvp')
$outDir = Join-Path $projectRoot 'build/fat_sim'
$image = Join-Path $outDir 'catalog_tb.vvp'
$rtl = Join-Path $projectRoot 'src/user_source/hdl_source/fat32_catalog.v'
$tb = Join-Path $projectRoot 'sim/tb_fat32_catalog.v'
if (!(Test-Path -LiteralPath $iverilog)) { throw "Icarus compiler not found: $iverilog" }
if (!(Test-Path -LiteralPath $vvp)) { throw "Icarus runtime not found: $vvp" }
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
& $iverilog -g2005 -Wall -s tb_fat32_catalog -o $image $rtl $tb
if ($LASTEXITCODE -ne 0) { throw "iverilog failed with exit code $LASTEXITCODE" }
& $vvp $image
if ($LASTEXITCODE -ne 0) { throw "vvp failed with exit code $LASTEXITCODE" }
