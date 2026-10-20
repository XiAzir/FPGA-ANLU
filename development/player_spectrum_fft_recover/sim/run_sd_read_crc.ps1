. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$ErrorActionPreference = 'Stop'
$project = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$hdl = Join-Path $PSScriptRoot '../src/user_source/hdl_source/SD'
$iverilog = (Resolve-AnluTool -Name 'iverilog')
$vvp = (Resolve-AnluTool -Name 'vvp')
$work = Join-Path $PSScriptRoot '../build/model'
$exe = Join-Path $work 'tb_sd_read_crc.vvp'
$log = Join-Path $work 'sd_read_crc.log'

New-Item -ItemType Directory -Force $work | Out-Null
& {
    & $iverilog -g2012 -s tb_sd_read_crc -o $exe `
        (Join-Path $PSScriptRoot 'tb_sd_read_crc.v') `
        (Join-Path $hdl 'sd_card_cmd.v')
    if ($LASTEXITCODE -ne 0) { throw 'sd read CRC test compile failed' }

    & $vvp $exe 2>&1 | Tee-Object -FilePath $log
    if ($LASTEXITCODE -ne 0) { throw 'sd read CRC simulation failed' }
    if(!(Select-String -LiteralPath $log -SimpleMatch 'PASS tb_sd_read_crc' -Quiet)) {
        throw 'sd read CRC simulation did not reach PASS'
    }
}
