$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../../scripts/anlu_tools.ps1')
$iverilog = Resolve-AnluTool -Name 'iverilog'
$vvp = Resolve-AnluTool -Name 'vvp'
$out = Join-Path $PSScriptRoot 'build'
$null = New-Item -ItemType Directory -Force -Path $out
$image = Join-Path $out 'mapper_sd_edge.vvp'
$log = Join-Path $out 'mapper_sd_edge.log'
& $iverilog -g2005 -Wall -s tb_mapper_sd_edge -o $image `
    (Join-Path $PSScriptRoot 'tb_mapper_sd_edge.v') `
    (Join-Path $PSScriptRoot 'fat32_file_sector_candidate.v') `
    (Join-Path $PSScriptRoot 'fat32_file_sector_reference.v') 2>&1 |
    Tee-Object -FilePath (Join-Path $out 'iverilog.log')
if ($LASTEXITCODE -ne 0) { throw "iverilog failed: $LASTEXITCODE" }
& $vvp $image 2>&1 | Tee-Object -FilePath $log
if ($LASTEXITCODE -ne 0) { throw "vvp failed: $LASTEXITCODE" }
if (!(Select-String -LiteralPath $log -SimpleMatch 'PASS: mapper SD edge differential checks' -Quiet)) {
    throw "mapper SD edge simulation did not report PASS; see $log"
}
if (Select-String -LiteralPath $log -SimpleMatch 'DIFF ' -Quiet) {
    throw "mapper SD edge differential mismatch; see $log"
}
