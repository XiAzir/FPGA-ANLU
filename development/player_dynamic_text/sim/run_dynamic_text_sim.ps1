$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$simDir = Join-Path $projectRoot 'development\player_dynamic_text\sim'
$buildDir = Join-Path $projectRoot 'development\player_dynamic_text\build\dynamic_sim'
$iverilog = (Resolve-AnluTool 'iverilog')
$vvp = (Resolve-AnluTool 'vvp')
$dut = Join-Path $projectRoot 'development\player_dynamic_text\src\user_source\hdl_source\player_dynamic_text.v'
$legacy = Join-Path $projectRoot 'development\player_dynamic_text\src\user_source\hdl_source\player_osd.v'

foreach ($path in @($iverilog, $vvp, $dut, $legacy)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Required file missing: $path" }
}
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

$cases = @(
    @{ Name = 'pixels'; Sources = @((Join-Path $simDir 'tb_player_dynamic_text_pixels.v'), $legacy, $dut) },
    @{ Name = 'timer'; Sources = @((Join-Path $simDir 'tb_player_dynamic_text_timer.v'), $dut) }
)

Push-Location $projectRoot
try {
    foreach ($case in $cases) {
        $exe = Join-Path $buildDir ("tb_dynamic_text_{0}.vvp" -f $case.Name)
        $compileLog = Join-Path $buildDir ("{0}_compile.log" -f $case.Name)
        $runLog = Join-Path $buildDir ("{0}_run.log" -f $case.Name)
        & $iverilog -g2012 -s ("tb_player_dynamic_text_{0}" -f $case.Name) -o $exe @($case.Sources) 2>&1 | Tee-Object -FilePath $compileLog
        if ($LASTEXITCODE -ne 0) { throw "Icarus compile failed for $($case.Name), exit=$LASTEXITCODE" }
        & $vvp $exe 2>&1 | Tee-Object -FilePath $runLog
        if ($LASTEXITCODE -ne 0) { throw "VVP failed for $($case.Name), exit=$LASTEXITCODE" }
        if (-not (Select-String -LiteralPath $runLog -Pattern '^PASS ' -Quiet)) { throw "Simulation $($case.Name) exited 0 without PASS" }
    }
}
finally {
    Pop-Location
}

Write-Output "PASS: both dynamic text simulation cases completed; logs in $buildDir"
