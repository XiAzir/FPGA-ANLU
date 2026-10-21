param(
    [string]$Iverilog = '',
    [string]$Vvp = '',
    [string]$DutModule = 'fat32_dual_file_sector_ref',
    [string]$DutSource = ''
)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$project = (Resolve-Path (Join-Path $here '../../..')).Path
if (-not $Iverilog) {
    $candidateExe = Join-Path $project 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
    if (Test-Path $candidateExe) { $Iverilog = $candidateExe }
    else {
        $cmd = Get-Command iverilog -ErrorAction SilentlyContinue
        if ($cmd) { $Iverilog = $cmd.Source }
    }
}
if (-not $Vvp) {
    if ($Iverilog) {
        $guess = Join-Path (Split-Path -Parent $Iverilog) 'vvp.exe'
        if (Test-Path $guess) { $Vvp = $guess }
    }
    if (-not $Vvp) {
        $cmd = Get-Command vvp -ErrorAction SilentlyContinue
        if ($cmd) { $Vvp = $cmd.Source }
    }
}
if (-not (Test-Path $Iverilog)) { throw 'Icarus Verilog executable not found. Pass -Iverilog <path>.' }
if (-not (Test-Path $Vvp)) { throw 'Icarus vvp executable not found. Pass -Vvp <path>.' }
if (-not $DutSource -and $DutModule -ne 'fat32_dual_file_sector_ref') {
    $DutSource = Join-Path $project 'development/arch17_work/shared_mapper/candidate.v'
}
$out = Join-Path $here ($DutModule + '.vvp')
$log = Join-Path $here ($DutModule + '.run.log')
$compileLog = Join-Path $here ($DutModule + '.compile.log')
$files = @(
    (Join-Path $here 'fat32_file_sector_reference.v'),
    (Join-Path $here 'sd_sector_arbiter_reference.v'),
    (Join-Path $here 'fat32_dual_file_sector_ref.v'),
    (Join-Path $here 'tb_dual_mapper_transactions.v')
)
if ($DutSource) { $files += (Resolve-Path $DutSource).Path }
 $defines = @()
if ($DutModule -ne 'fat32_dual_file_sector_ref') { $defines += '-DTEST_SHARED_CORE' }
& $Iverilog -g2012 -s tb_dual_mapper_transactions "-DDUAL_DUT=$DutModule" @defines -o $out @files *> $compileLog
if ($LASTEXITCODE -ne 0) { Get-Content $compileLog; throw "Icarus compile failed ($LASTEXITCODE)." }
& $Vvp $out *> $log
if ($LASTEXITCODE -ne 0) { Get-Content $log; throw "Simulation failed ($LASTEXITCODE)." }
Get-Content $compileLog
Get-Content $log

