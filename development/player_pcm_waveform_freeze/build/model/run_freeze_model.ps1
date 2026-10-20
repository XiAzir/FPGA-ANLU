param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
)

$ErrorActionPreference = 'Stop'
$modelDir = (Resolve-Path $PSScriptRoot).Path
$workspaceRoot = (Resolve-Path (Join-Path $ProjectRoot '..\..')).Path
$rtlPath = Join-Path $ProjectRoot 'src\user_source\hdl_source\player_pcm_waveform.v'
$tbPath = Join-Path $modelDir 'tb_freeze_waveform.v'
$logPath = Join-Path $modelDir 'freeze_model.log'
. (Join-Path $PSScriptRoot '../../../../scripts/anlu_tools.ps1')
$iverilog = (Resolve-AnluTool 'iverilog')
$vvp = (Resolve-AnluTool 'vvp')
$simPath = Join-Path ([System.IO.Path]::GetTempPath()) ("freeze_model_{0}.vvp" -f [guid]::NewGuid().ToString('N'))
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("Freeze model run: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss K')")
$lines.Add("Project root: $ProjectRoot")
$lines.Add("Workspace root (tools): $workspaceRoot")
$lines.Add("Working directory: $modelDir")

Push-Location $modelDir
try {
    foreach ($path in @($rtlPath, $tbPath, $iverilog, $vvp)) {
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            throw "Required file not found: $path"
        }
    }

    $lines.Add('Compile: Icarus Verilog -g2012 -s tb_freeze_waveform')
    $compileOutput = & $iverilog -g2012 -s tb_freeze_waveform -o $simPath $tbPath $rtlPath 2>&1
    foreach ($entry in $compileOutput) { $lines.Add($entry.ToString()) }
    $compileCode = $LASTEXITCODE
    if ($compileCode -ne 0) {
        $lines.Add("COMPILE FAIL exit=$compileCode")
        [System.IO.File]::WriteAllLines($logPath, $lines, [System.Text.UTF8Encoding]::new($false))
        throw "Icarus compile failed with exit code $compileCode"
    }

    $lines.Add('Run: vvp temporary image')
    $runOutput = & $vvp $simPath 2>&1
    foreach ($entry in $runOutput) { $lines.Add($entry.ToString()) }
    $runCode = $LASTEXITCODE
    $lines.Add("VVP exit=$runCode")
    [System.IO.File]::WriteAllLines($logPath, $lines, [System.Text.UTF8Encoding]::new($false))
    if ($runCode -ne 0) { throw "VVP simulation failed with exit code $runCode" }
    if (-not ($lines | Where-Object { $_ -match '^PASS checks=\d+' })) {
        throw 'Simulation exited without the PASS summary'
    }
    Get-Content -LiteralPath $logPath
}
catch {
    if (-not (Test-Path -LiteralPath $logPath)) {
        $lines.Add("RUN FAIL: $($_.Exception.Message)")
        [System.IO.File]::WriteAllLines($logPath, $lines, [System.Text.UTF8Encoding]::new($false))
    }
    throw
}
finally {
    Pop-Location
    Remove-Item -LiteralPath $simPath -Force -ErrorAction SilentlyContinue
}
