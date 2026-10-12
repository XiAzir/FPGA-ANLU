param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
)

$ErrorActionPreference = 'Stop'
$workspaceRoot = (Resolve-Path (Join-Path $ProjectRoot '../..')).Path
$modelDir = Join-Path $ProjectRoot 'build/model'
$hdlDir = Join-Path $ProjectRoot 'src/user_source/hdl_source'
. (Join-Path $PSScriptRoot '../../../../scripts/anlu_tools.ps1')
$iverilog = (Resolve-AnluTool 'iverilog')
$vvp = (Resolve-AnluTool 'vvp')
$rtlLoader = Join-Path $hdlDir 'tf_bmp_file_player.v'
$rtlOsd = Join-Path $hdlDir 'player_osd_state.v'
$rtlKeys = Join-Path $hdlDir 'SD/sd_card_bmp.v'
$tb = Join-Path $modelDir 'tb_display_ownership.v'
$image = Join-Path $modelDir 'tb_display_ownership.vvp'
$compileLog = Join-Path $modelDir 'tb_display_ownership.compile.log'
$log = Join-Path $modelDir 'tb_display_ownership.log'

if (!(Test-Path -LiteralPath $iverilog)) { throw "iverilog not found: $iverilog" }
if (!(Test-Path -LiteralPath $vvp)) { throw "vvp not found: $vvp" }
& $iverilog -g2012 -Wall -s tb_display_ownership -o $image $rtlLoader $rtlOsd $rtlKeys $tb *> $compileLog
if ($LASTEXITCODE -ne 0) { throw "iverilog failed; see $compileLog" }
& $vvp $image *> $log
if ($LASTEXITCODE -ne 0) { throw "simulation failed; see $log" }
Get-Content -Raw $compileLog
Get-Content -Raw $log
if (!(Select-String -LiteralPath $log -Pattern '^PASS tb_display_ownership$' -Quiet)) {
    throw "Simulation did not report PASS. See $log"
}
