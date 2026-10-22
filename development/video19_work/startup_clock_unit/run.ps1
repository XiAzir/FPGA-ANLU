param([string]$RunName = "modelsim_$(Get-Date -Format 'yyyyMMdd_HHmmss')")
$ErrorActionPreference = 'Stop'

$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$UnitRoot = $PSScriptRoot
$OldSource = Join-Path $ProjectRoot 'development/player_video19/build/video_system_20261021_191508/frozen/src/user_source/hdl_source/top_tf_hdmi_audio.v'
$NewSource = Join-Path $ProjectRoot 'development/player_video19/build/syn_20261021_193057.frozen/src/user_source/hdl_source/top_tf_hdmi_audio.v'
$ReplayRoot = Join-Path $ProjectRoot 'development/player_video19/build/video_system_20261021_191508'
$Replay = Join-Path $ReplayRoot 'pll_clock_replay.v'
$Wrappers = Join-Path $ReplayRoot 'pll_replay_wrappers.v'
$RunDir = Join-Path $UnitRoot "runs/$RunName"

function Get-StartupBlock([string]$Path, [string]$Clock) {
    $Lines = @(Get-Content -LiteralPath $Path)
    $StartPattern = "always @(posedge $Clock) begin"
    $Start = [Array]::IndexOf($Lines, $StartPattern)
    $End = [Array]::FindIndex($Lines, [Predicate[string]]{ param($Line) $Line -eq '// The control classifier survives a media restart so held gestures rearm once.' })
    if ($Start -lt 0 -or $End -le $Start) { throw "startup block markers not found in $Path for $Clock" }
    $Block = ($Lines[$Start..($End - 1)] -join "`n").TrimEnd()
    if ($Block -notmatch 'sys_pll_lock && video_pll_lock' -or $Block -notmatch "20'd1_000_000") {
        throw "unexpected startup block contents in $Path"
    }
    return [pscustomobject]@{
        Path = (Resolve-Path $Path).Path
        Clock = $Clock
        StartLine = $Start + 1
        EndLine = $Start + ($Block -split "`n").Count
        SourceSha256 = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
        Block = $Block
        BlockSha256 = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($Block)))
    }
}

function New-DutSource($Entry, [string]$ModuleName) {
    return @"
module $ModuleName(
    input clk, input sd_card_clk, input rst_n,
    input sys_pll_lock, input video_pll_lock,
    output [19:0] rst_cnt_o, output rst_all_reg_o
);
reg [19:0] rst_cnt = 20'd0;
reg rst_all_reg = 1'b1;
assign rst_cnt_o = rst_cnt;
assign rst_all_reg_o = rst_all_reg;
$($Entry.Block)
endmodule
"@
}

New-Item -ItemType Directory -Force -Path $RunDir | Out-Null
$Old = Get-StartupBlock $OldSource 'clk'
$New = Get-StartupBlock $NewSource 'sd_card_clk'
$DutFile = Join-Path $RunDir 'startup_duts.v'
$TbFile = Join-Path $RunDir 'tb_startup_clock.v'
Set-Content -LiteralPath $DutFile -Value ((New-DutSource $Old 'startup_old') + "`n" + (New-DutSource $New 'startup_new')) -Encoding ascii
Copy-Item -LiteralPath (Join-Path $UnitRoot 'tb_startup_clock.v') -Destination $TbFile

$Manifest = [ordered]@{
    generated_at_local = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss zzz')
    old_source = $Old | Select-Object Path,Clock,StartLine,EndLine,SourceSha256,BlockSha256
    new_source = $New | Select-Object Path,Clock,StartLine,EndLine,SourceSha256,BlockSha256
    replay = [ordered]@{
        path = (Resolve-Path $Replay).Path
        sha256 = (Get-FileHash -LiteralPath $Replay -Algorithm SHA256).Hash
        wrappers_path = (Resolve-Path $Wrappers).Path
        wrappers_sha256 = (Get-FileHash -LiteralPath $Wrappers -Algorithm SHA256).Hash
        contract = 'Recorded nominal PLL replay; 20 ns refclk, sys/video lock and derived clocks from the preserved replay.'
    }
    testbench_sha256 = (Get-FileHash -LiteralPath $TbFile -Algorithm SHA256).Hash
}
$Manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $RunDir 'source_manifest.json') -Encoding utf8

$ModelSimBin = Split-Path (Get-Command vsim.exe).Source
$Vlib = Join-Path $ModelSimBin 'vlib.exe'
$Vlog = Join-Path $ModelSimBin 'vlog.exe'
$Vsim = Join-Path $ModelSimBin 'vsim.exe'
Push-Location $RunDir
try {
    & $Vlib work *> 'vlib.log'
    if ($LASTEXITCODE -ne 0) { throw "vlib failed: $LASTEXITCODE" }
    & $Vlog -work work $DutFile $TbFile $Replay $Wrappers *> 'compile.log'
    if ($LASTEXITCODE -ne 0) { throw "vlog failed: $LASTEXITCODE" }
    & $Vsim -c -lib work tb_startup_clock -do 'run -all; quit -f' *> 'run.log'
    if ($LASTEXITCODE -ne 0) { throw "vsim failed: $LASTEXITCODE" }
} finally {
    Pop-Location
}
if (-not (Select-String -LiteralPath (Join-Path $RunDir 'run.log') -SimpleMatch 'STARTUP_CLOCK_UNIT_PASS' -Quiet)) {
    throw "simulation completed without PASS marker; inspect $RunDir/run.log"
}
Write-Output "STARTUP_CLOCK_UNIT_PASS run=$RunDir"
