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
$rtl = Join-Path $hdlDir 'player_adjust_control.v'
$legacy = Join-Path $hdlDir 'SD/sd_card_bmp.v'
$tb = Join-Path $modelDir 'tb_player_adjust_control.v'
$image = Join-Path $modelDir 'tb_player_adjust_control.vvp'
$compileLog = Join-Path $modelDir 'tb_player_adjust_control.compile.log'
$log = Join-Path $modelDir 'tb_player_adjust_control.log'

if (!(Test-Path -LiteralPath $iverilog)) { throw "iverilog not found: $iverilog" }
if (!(Test-Path -LiteralPath $vvp)) { throw "vvp not found: $vvp" }
& $iverilog -g2012 -Wall -s tb_player_adjust_control -o $image $rtl $legacy $tb *> $compileLog
if ($LASTEXITCODE -ne 0) { throw "iverilog failed; see $compileLog" }
& $vvp $image *> $log
if ($LASTEXITCODE -ne 0) { throw "simulation failed; see $log" }
Get-Content -Raw $compileLog
Get-Content -Raw $log
if (!(Select-String -LiteralPath $log -Pattern '^PASS tb_player_adjust_control$' -Quiet)) {
    throw "Simulation did not report PASS. See $log"
}
