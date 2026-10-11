$ErrorActionPreference = 'Stop'
$workDir = $PSScriptRoot
$projectDir = (Resolve-Path (Join-Path $workDir '../../..')).Path
$repoDir = (Resolve-Path (Join-Path $projectDir '../..')).Path
$hdlDir = Join-Path $projectDir 'src/user_source/hdl_source'
$simDir = 'C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\sim_release\eg4'
$iverilog = Join-Path $repoDir 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = Join-Path $repoDir 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$image = Join-Path $workDir 'tb_phy_official_oddr.vvp'
$logPath = Join-Path $workDir 'run.log'
Set-Content -LiteralPath $logPath -Value '' -NoNewline -Encoding ascii
$officialGlbl = Join-Path $simDir 'eg_phy_glbl.v'
$iverilogGlbl = Join-Path $workDir 'eg_phy_glbl_icarus.v'
$officialLogicIo = Join-Path $simDir 'eg_logic_io.v'
$iverilogOddr = Join-Path $workDir 'eg_logic_oddr_official_icarus.v'

$glblText = Get-Content -LiteralPath $officialGlbl -Raw
$glblText = [regex]::Replace($glblText, '(?s)\r?\n`pragma protect begin_protected.*?`pragma protect end_protected\s*', "`n")
if ($glblText -match '`pragma protect') { throw 'Could not sanitize all protected library blocks from eg_phy_glbl.v.' }
Set-Content -LiteralPath $iverilogGlbl -Value $glblText -NoNewline -Encoding ascii
$logicText = Get-Content -LiteralPath $officialLogicIo -Raw
$oddrMatch = [regex]::Match($logicText, '(?s)(`timescale\s+1 ns / 1 ps\s+module EG_LOGIC_ODDR\s*\(.*?\bendmodule)')
if (-not $oddrMatch.Success) { throw 'Could not extract EG_LOGIC_ODDR from official eg_logic_io.v.' }
Set-Content -LiteralPath $iverilogOddr -Value $oddrMatch.Groups[1].Value -NoNewline -Encoding ascii

$sources = @(
    $iverilogGlbl,
    $iverilogOddr,
    (Join-Path $hdlDir 'lane_lvds_10_1.v'),
    (Join-Path $hdlDir 'hdmi_phy_warpper.v'),
    (Join-Path $workDir 'tb_phy_official_oddr.v')
)
foreach ($path in @($iverilog, $vvp) + $sources) {
    if (-not (Test-Path -LiteralPath $path)) { throw "Required file not found: $path" }
}

& $iverilog -g2012 -o $image @sources 2>&1 |
    Tee-Object -FilePath $logPath
if ($LASTEXITCODE -ne 0) { throw "iverilog failed with exit code $LASTEXITCODE" }

foreach ($phase in @(0, 2000, 4000, 6000)) {
    $result = & $vvp $image "+phase_ps=$phase" 2>&1
    $exitCode = $LASTEXITCODE
    $result | Tee-Object -FilePath $logPath -Append
    if ($exitCode -ne 0 -or (($result -join "`n") -notmatch "OFFICIAL_ODDR_PASS phase_ps=$phase")) {
        throw "Official ODDR check failed at serial phase $phase ps (exit $exitCode)."
    }
}
