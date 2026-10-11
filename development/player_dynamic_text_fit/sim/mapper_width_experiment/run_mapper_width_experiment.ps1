$ErrorActionPreference = 'Stop'
$dir = $PSScriptRoot
$iverilog = 'E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = 'E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'

function Invoke-Icarus {
    param([string]$Name, [string[]]$Sources)
    $image = Join-Path $dir ($Name + '.vvp')
    $compileLog = Join-Path $dir ($Name + '_compile.log')
    $runLog = Join-Path $dir ($Name + '_run.log')
    & $iverilog -g2001 -Wall -s $Name -o $image @Sources 2>&1 | Tee-Object -FilePath $compileLog
    if ($LASTEXITCODE -ne 0) { throw "iverilog failed for $Name with exit $LASTEXITCODE" }
    & $vvp $image 2>&1 | Tee-Object -FilePath $runLog
    if ($LASTEXITCODE -ne 0) { throw "vvp failed for $Name with exit $LASTEXITCODE" }
}

Invoke-Icarus 'tb_fat32_file_sector_existing' @(
    (Join-Path $dir 'fat32_file_sector_original.v'),
    (Join-Path $dir 'tb_fat32_file_sector_existing.v')
)
Invoke-Icarus 'tb_fat32_file_sector_narrow_existing' @(
    (Join-Path $dir 'fat32_file_sector_narrow.v'),
    (Join-Path $dir 'tb_fat32_file_sector_narrow_existing.v')
)
Invoke-Icarus 'tb_mapper_width_equiv' @(
    (Join-Path $dir 'fat32_file_sector_original.v'),
    (Join-Path $dir 'fat32_file_sector_narrow.v'),
    (Join-Path $dir 'tb_mapper_width_equiv.v')
)
Write-Output 'PASS: original and narrowed mappers both pass the existing byte-gap model and the cycle-equivalence model exited 0.'
