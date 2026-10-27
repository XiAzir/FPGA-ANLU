$ErrorActionPreference = 'Stop'
$fixture = (Resolve-Path $PSScriptRoot).Path
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$toolBin = 'E:\ModelsimSE\win64'
$modelsimIni = Join-Path $root 'development\system_verification_20261016\hdmi\modelsim.ini'
$eg4Glbl = 'C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\sim_release\eg4\eg_phy_glbl.v'
$compileLog = Join-Path $fixture 'full_compile.log'
$runLog = Join-Path $fixture 'full_run.log'
$receiptPath = Join-Path $fixture 'input_binding_receipt.json'
Set-Location $fixture

& (Join-Path $fixture 'prepare_full_pair.ps1')

$workLib = Join-Path $fixture 'workfull'
if (Test-Path -LiteralPath $workLib) {
    $resolved = (Resolve-Path -LiteralPath $workLib).Path
    if (-not $resolved.StartsWith($fixture, [System.StringComparison]::OrdinalIgnoreCase)) { throw "Refusing to remove library outside fixture: $resolved" }
    & (Join-Path $toolBin 'vdel.exe') -lib workfull -all *> (Join-Path $fixture 'vdel.log')
    if ($LASTEXITCODE -ne 0) { throw 'Failed to clear prior workfull library; see vdel.log' }
}
& (Join-Path $toolBin 'vlib.exe') workfull *> (Join-Path $fixture 'vlib.log')
if ($LASTEXITCODE -ne 0) { throw 'ModelSim vlib failed; see vlib.log' }
& (Join-Path $toolBin 'vlog.exe') -modelsimini $modelsimIni -L EG4 -work workfull $eg4Glbl (Join-Path $fixture 'full_c29.v') (Join-Path $fixture 'full_c30.v') *> $compileLog
if ($LASTEXITCODE -ne 0) { throw "ModelSim compile failed (exit=$LASTEXITCODE); see full_compile.log" }
& (Join-Path $toolBin 'vlog.exe') -sv -modelsimini $modelsimIni -L EG4 -work workfull (Join-Path $fixture 'tb_full_pair.v') *> (Join-Path $fixture 'tb_compile.log')
if ($LASTEXITCODE -ne 0) { throw "SystemVerilog testbench compile failed (exit=$LASTEXITCODE); see tb_compile.log" }

$vsimDo = 'onerror {quit -code 2 -f}; onbreak {quit -code 3 -f}; run -all; quit -code 0 -f'
& (Join-Path $toolBin 'vsim.exe') -c -novopt -modelsimini E:/VSCODE-project/FPGA-ANLU/development/system_verification_20261016/hdmi/modelsim.ini -L EG4 -lib workfull workfull.tb_full_pair workfull.glbl -do $vsimDo *> $runLog
$simExit = $LASTEXITCODE
$logText = [System.IO.File]::ReadAllText($runLog)
if ($simExit -ne 0) { throw "ModelSim simulation failed (exit=$simExit); see full_run.log" }
if ($logText -notmatch '(?m)^FULL_PAIR_PASS\b' -or $logText -match 'FULL_PAIR_FAIL') {
    throw 'ModelSim returned zero without the unique FULL_PAIR_PASS token; see full_run.log'
}
$receipt = Get-Content -Raw -LiteralPath $receiptPath | ConvertFrom-Json
$receipt | Add-Member -NotePropertyName simulation -NotePropertyValue ([ordered]@{
    status = 'PASS'
    log = $runLog
    log_sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $runLog).Hash.ToLowerInvariant()
    pass_line = (($logText -split "`r?`n") | Where-Object { $_ -match '^FULL_PAIR_PASS\b' } | Select-Object -First 1)
    simulator = 'ModelSim SE-64 10.1c'
    eg4_library = 'TD 6.2.1 SP1 precompiled EG4 library'
})
$receipt | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $receiptPath
Write-Output 'FULL_PAIR_PASS validated in log and receipt.'
