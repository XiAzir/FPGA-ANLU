param([string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path)
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$ErrorActionPreference = 'Stop'
$modelDir = Join-Path $ProjectRoot 'build/model'
$hdlDir = Join-Path $ProjectRoot 'src/user_source/hdl_source'
$workspaceRoot = (Resolve-Path (Join-Path $ProjectRoot '../..')).Path
$iverilog = (Resolve-AnluTool -Name 'iverilog')
$vvp = (Resolve-AnluTool -Name 'vvp')
$loader = Join-Path $hdlDir 'tf_bmp_file_player.v'
$engine = Join-Path $hdlDir 'bmp_scale_engine.v'
$keys = Join-Path $hdlDir 'SD/sd_card_bmp.v'
$tb = Join-Path $ProjectRoot 'sim/tb_tf_bmp_failure_detail.v'
New-Item -ItemType Directory -Force -Path $modelDir | Out-Null
$tag = Get-Date -Format 'yyyyMMdd_HHmmss_fff'
$compileLog = Join-Path $modelDir "bmp_failure_detail_compile_$tag.log"
$simLog = Join-Path $modelDir "bmp_failure_detail_run_$tag.log"
$image = Join-Path $modelDir "bmp_failure_detail_$tag.vvp"
$summary = Join-Path $modelDir 'bmp_failure_detail.log'
$resultPath = Join-Path $modelDir "bmp_failure_detail_result_$tag.json"
foreach ($path in @($iverilog,$vvp,$loader,$engine,$keys,$tb)) {
    if (!(Test-Path -LiteralPath $path)) { throw "Required model input missing: $path" }
}
$hashes = [ordered]@{
    'tf_bmp_file_player.v'=(Get-FileHash -LiteralPath $loader -Algorithm SHA256).Hash.ToLowerInvariant()
    'bmp_scale_engine.v'=(Get-FileHash -LiteralPath $engine -Algorithm SHA256).Hash.ToLowerInvariant()
    'tb_tf_bmp_failure_detail.v'=(Get-FileHash -LiteralPath $tb -Algorithm SHA256).Hash.ToLowerInvariant()
}
& $iverilog -g2012 -Wall -s tb_tf_bmp_failure_detail -o $image $loader $engine $keys $tb *> $compileLog
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
$marker = Select-String -LiteralPath $simLog -Pattern '^BMP_FAILURE_DETAIL PASS cases=21 ' | Select-Object -First 1
if (!$marker) {
    Add-Content -LiteralPath $summary -Value "[$tag] NO_PASS_MARKER compile=$compileLog simulation=$simLog"
    Get-Content -Raw $simLog
    throw "Expected diagnostic PASS marker missing; see $simLog"
}
$result = [ordered]@{
    schema='fpga-anlu-bmp-failure-detail-model/v1'
    status='PASS'
    generated_local=(Get-Date).ToString('yyyy-MM-dd HH:mm:ss zzz')
    compile_log=$compileLog
    simulation_log=$simLog
    source_sha256=$hashes
    pass_marker=$marker.Line
    scope='RTL unchanged; public pin-level card stream and handshakes; no internal force; no TD build.'
}
$result | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $resultPath -Encoding utf8
Add-Content -LiteralPath $summary -Value "[$tag] $($marker.Line) compile=$compileLog simulation=$simLog result=$resultPath"
Get-Content -Raw $compileLog
Get-Content -Raw $simLog
Get-Content -Raw $resultPath
Write-Output "BMP_FAILURE_DETAIL_LOG $summary"
