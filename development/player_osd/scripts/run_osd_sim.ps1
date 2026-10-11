param()

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$modulePath = Join-Path $projectRoot 'development\player_osd\src\user_source\hdl_source\player_osd.v'
$testbenchPath = Join-Path $projectRoot 'development\player_osd\sim\tb_player_osd.v'
$outputDir = Join-Path $projectRoot 'development\player_osd\build\osd_sim'
$imagePath = Join-Path $outputDir 'tb_player_osd.vvp'
$iverilog = Join-Path $projectRoot 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $projectRoot 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'

New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
if (-not (Test-Path -LiteralPath $iverilog -PathType Leaf)) { throw "Icarus compiler missing: $iverilog" }
if (-not (Test-Path -LiteralPath $vvp -PathType Leaf)) { throw "Icarus runtime missing: $vvp" }
if (-not (Test-Path -LiteralPath $modulePath -PathType Leaf)) {
    throw "OSD module is not present yet: $modulePath. Testbench is ready; rerun after the module lands."
}
if (-not (Test-Path -LiteralPath $testbenchPath -PathType Leaf)) { throw "Testbench missing: $testbenchPath" }

Push-Location $projectRoot
try {
    Write-Host 'Compiling only player_osd.v and tb_player_osd.v...'
    $compileOutput = & $iverilog -g2012 -s tb_player_osd -o $imagePath $modulePath $testbenchPath 2>&1
    $compileCode = $LASTEXITCODE
    $compileOutput | Set-Content -LiteralPath (Join-Path $outputDir 'compile.log') -Encoding utf8
    $compileOutput | ForEach-Object { Write-Host $_ }
    if ($compileCode -ne 0 -or (($compileOutput -join "`n") -match '(?i)\bFATAL\b')) {
        throw "Icarus compile failed (exit $compileCode)."
    }

    Write-Host 'Running six full-frame, pixel-by-pixel checks...'
    $simOutput = & $vvp $imagePath 2>&1
    $simCode = $LASTEXITCODE
    $simOutput | Set-Content -LiteralPath (Join-Path $outputDir 'run.log') -Encoding utf8
    $simOutput | ForEach-Object { Write-Host $_ }
    $simText = $simOutput -join "`n"
    if ($simCode -ne 0 -or $simText -match '(?i)\bFATAL\b' -or $simText -notmatch '(?m)^PASS:') {
        throw "OSD simulation failed (exit $simCode)."
    }
    Write-Host 'PASS: complete-frame RGB overlay, glyph shape, blank passthrough, frame synchronization, reset, and metadata scenarios verified.'
    Write-Host "Preview: $(Join-Path $outputDir 'osd_preview.ppm')"
}
finally {
    Pop-Location
}
