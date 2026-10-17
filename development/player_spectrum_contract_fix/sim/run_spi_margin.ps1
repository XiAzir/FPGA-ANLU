$ErrorActionPreference = 'Stop'

$task = Split-Path -Parent $PSScriptRoot
$project = Split-Path -Parent (Split-Path -Parent $task)
$hdl = Join-Path $task 'src/user_source/hdl_source/SD'
$model = Join-Path $task 'build/model'
$iverilog = Join-Path $project 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = Join-Path $project 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$image = Join-Path $model 'spi_margin.vvp'
$compileLog = Join-Path $model 'spi_margin_compile.log'
$runLog = Join-Path $model 'spi_margin_run.log'

New-Item -ItemType Directory -Force $model | Out-Null
if (!(Test-Path -LiteralPath $iverilog)) { throw "Icarus compiler not found: $iverilog" }
if (!(Test-Path -LiteralPath $vvp)) { throw "Icarus runtime not found: $vvp" }

Push-Location $hdl
try {
    & $iverilog -g2012 -s tb_spi_margin -o $image `
        (Join-Path $PSScriptRoot 'tb_spi_margin.v') `
        (Join-Path $hdl 'spi_master.v') 2>&1 | Tee-Object -FilePath $compileLog
    if ($LASTEXITCODE -ne 0) { throw 'SPI margin test compile failed' }

    & $vvp $image 2>&1 | Tee-Object -FilePath $runLog
    if ($LASTEXITCODE -ne 0) { throw 'SPI margin test simulation failed' }
} finally {
    Pop-Location
}
