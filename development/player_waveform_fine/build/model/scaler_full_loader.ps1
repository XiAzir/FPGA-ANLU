param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
)

$ErrorActionPreference = 'Stop'
$modelDir = Join-Path $ProjectRoot 'build/model'
$hdlDir = Join-Path $ProjectRoot 'src/user_source/hdl_source'
$workspaceRoot = (Resolve-Path (Join-Path $ProjectRoot '../..')).Path
$iverilog = Join-Path $workspaceRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = Join-Path $workspaceRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$python = 'C:/Users/PENGYUHAO/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe'
$loader = Join-Path $hdlDir 'tf_bmp_file_player.v'
$engine = Join-Path $hdlDir 'bmp_scale_engine.v'
$keys = Join-Path $hdlDir 'SD/sd_card_bmp.v'
$tb = Join-Path $modelDir 'tb_scaler_full_loader.v'
$tag = Get-Date -Format 'yyyyMMdd_HHmmss_fff'
$mediaLog = Join-Path $modelDir "scaler_full_loader_media_$tag.log"
$compileLog = Join-Path $modelDir "scaler_full_loader_compile_$tag.log"
$simLog = Join-Path $modelDir "scaler_full_loader_run_$tag.log"
$image = Join-Path $modelDir "scaler_full_loader_$tag.vvp"
$summary = Join-Path $modelDir 'scaler_full_loader.log'
$sourceSnapshot = Join-Path $modelDir "scaler_source_snapshot_$tag.json"

foreach ($path in @($python, $iverilog, $vvp, $loader, $engine, $keys, $tb)) {
    if (!(Test-Path -LiteralPath $path)) { throw "Required model input missing: $path" }
}

& $python (Join-Path $modelDir 'scaler_make_media.py') *> $mediaLog
if ($LASTEXITCODE -ne 0) {
    Add-Content -LiteralPath $summary -Value "[$tag] MEDIA_FAIL log=$mediaLog"
    throw "Media generation failed; see $mediaLog"
}

$snapshot = [ordered]@{
    'bmp_scale_engine.v'=(Get-FileHash -LiteralPath (Join-Path $hdlDir 'bmp_scale_engine.v') -Algorithm SHA256).Hash.ToLowerInvariant()
    'tf_bmp_file_player.v'=(Get-FileHash -LiteralPath (Join-Path $hdlDir 'tf_bmp_file_player.v') -Algorithm SHA256).Hash.ToLowerInvariant()
}
$snapshot | ConvertTo-Json | Set-Content -LiteralPath $sourceSnapshot -Encoding utf8

& $iverilog -g2012 -Wall -s tb_scaler_full_loader -o $image $loader $engine $keys $tb *> $compileLog
if ($LASTEXITCODE -ne 0) {
    Add-Content -LiteralPath $summary -Value "[$tag] COMPILE_FAIL compile=$compileLog media=$mediaLog"
    throw "Icarus compile failed; see $compileLog"
}

Push-Location $modelDir
try {
    & $vvp $image *> $simLog
    $simExit = $LASTEXITCODE
} finally {
    Pop-Location
}
if ($simExit -ne 0) {
    Add-Content -LiteralPath $summary -Value "[$tag] SIM_FAIL compile=$compileLog simulation=$simLog"
    Get-Content -Raw $simLog
    throw "Icarus simulation failed; see $simLog"
}
$marker = Select-String -LiteralPath $simLog -Pattern '^SCALER_INTEGRATION PASS images=6 pixels=1843200 ' | Select-Object -First 1
if (!$marker) {
    Add-Content -LiteralPath $summary -Value "[$tag] NO_PASS_MARKER compile=$compileLog simulation=$simLog"
    Get-Content -Raw $simLog
    throw "Expected integration marker missing; see $simLog"
}
$record = "[$tag] $($marker.Line)\r\ncompile=$compileLog\r\nsimulation=$simLog\r\nmedia=$mediaLog"
Add-Content -LiteralPath $summary -Value @("[$tag] $($marker.Line)", "compile=$compileLog", "simulation=$simLog", "media=$mediaLog")

# Error paths use a separate compact-output regression after the full-frame run.
& pwsh -NoProfile -File (Join-Path $modelDir 'scaler_bad_inputs.ps1') -ProjectRoot $ProjectRoot
if ($LASTEXITCODE -ne 0) { throw 'Malformed-input regression failed; see scaler_bad_inputs.log' }
$badRun = Get-ChildItem -LiteralPath $modelDir -Filter 'scaler_bad_inputs_run_*.log' -File |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (!$badRun -or !(Select-String -LiteralPath $badRun.FullName -Pattern '^SCALER_ERRORS PASS cases=4 retained=4 ' -Quiet)) {
    throw 'Malformed-input PASS marker not found in its raw run log.'
}
Add-Content -LiteralPath $summary -Value "[$tag] SCALER_INTEGRATION PASS images=6 pixels=1843200 bad_cases=4 retained=4"
& pwsh -NoProfile -File (Join-Path $modelDir 'scaler_write_receipt.ps1') -ProjectRoot $ProjectRoot
if ($LASTEXITCODE -ne 0) { throw 'Validation receipt generation failed.' }
Get-Content -Raw $compileLog
Get-Content -Raw $simLog
Write-Output "SCALER_FULL_LOADER_LOG $summary"
