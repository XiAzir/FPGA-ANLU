param([string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path)
$ErrorActionPreference = 'Stop'
$modelDir = Join-Path $ProjectRoot 'build/model'
$hdlDir = Join-Path $ProjectRoot 'src/user_source/hdl_source'
$workspaceRoot = (Resolve-Path (Join-Path $ProjectRoot '../..')).Path
$iverilog = Join-Path $workspaceRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = Join-Path $workspaceRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$loader = Join-Path $hdlDir 'tf_bmp_file_player.v'
$engine = Join-Path $hdlDir 'bmp_scale_engine.v'
$keys = Join-Path $hdlDir 'SD/sd_card_bmp.v'
$tb = Join-Path $modelDir 'tb_scaler_bad_inputs.v'
$tag = Get-Date -Format 'yyyyMMdd_HHmmss_fff'
$compileLog = Join-Path $modelDir "scaler_bad_inputs_compile_$tag.log"
$simLog = Join-Path $modelDir "scaler_bad_inputs_run_$tag.log"
$image = Join-Path $modelDir "scaler_bad_inputs_$tag.vvp"
$summary = Join-Path $modelDir 'scaler_bad_inputs.log'

& $iverilog -g2012 -Wall -s tb_scaler_bad_inputs -o $image $loader $engine $keys $tb *> $compileLog
if ($LASTEXITCODE -ne 0) {
    Add-Content -LiteralPath $summary -Value "[$tag] COMPILE_FAIL compile=$compileLog"
    throw "Icarus compile failed; see $compileLog"
}
Push-Location $modelDir
try { & $vvp $image *> $simLog; $simExit=$LASTEXITCODE } finally { Pop-Location }
if ($simExit -ne 0) {
    Add-Content -LiteralPath $summary -Value "[$tag] SIM_FAIL compile=$compileLog simulation=$simLog"
    Get-Content -Raw $simLog
    throw "Icarus simulation failed; see $simLog"
}
$marker = Select-String -LiteralPath $simLog -Pattern '^SCALER_ERRORS PASS cases=4 retained=4 ' | Select-Object -First 1
if (!$marker) {
    Add-Content -LiteralPath $summary -Value "[$tag] NO_PASS_MARKER compile=$compileLog simulation=$simLog"
    Get-Content -Raw $simLog
    throw "Expected error-fixture marker missing; see $simLog"
}
Add-Content -LiteralPath $summary -Value "[$tag] $($marker.Line) compile=$compileLog simulation=$simLog"
Get-Content -Raw $compileLog
Get-Content -Raw $simLog
Write-Output "SCALER_BAD_INPUTS_LOG $summary"
