$ErrorActionPreference = 'Stop'
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$ModelSim = 'E:\ModelsimSE\win64'
$ReferenceSim = 'E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\build\board_feedback_no_signal_20261014\modelsim'
$SourceIp = 'E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\src\user_source\hdl_source\IP'
$VendorModel = 'C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\sim_release\eg4\eg_phy_pll.v'
$StableCheckpoint = 'E:\VSCODE-project\FPGA-ANLU\development\player_bmp_scale\checkpoints\bmp_scale_20261012_verified\src\user_source\hdl_source\IP'
$env:MGLS_LICENSE_FILE = [Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE', 'User')
if (-not $env:MGLS_LICENSE_FILE) { throw 'MGLS_LICENSE_FILE is unavailable in the User environment.' }
if (-not (Test-Path -LiteralPath "$Here\work\_info")) {
    & "$ModelSim\vlib.exe" "$Here\work" *> "$Here\vlib.log"
    if ($LASTEXITCODE -ne 0) { throw "vlib work failed: $LASTEXITCODE" }
}
if (-not (Test-Path -LiteralPath "$Here\adapter_work\_info")) {
    & "$ModelSim\vlib.exe" "$Here\adapter_work" *> "$Here\vlib_adapter.log"
    if ($LASTEXITCODE -ne 0) { throw "vlib adapter_work failed: $LASTEXITCODE" }
}
Push-Location $Here
try {
    & "$ModelSim\vmap.exe" -modelsimini modelsim.ini work work *> vmap_work.log
    if ($LASTEXITCODE -ne 0) { throw "vmap work failed: $LASTEXITCODE" }
    & "$ModelSim\vmap.exe" -modelsimini modelsim.ini adapter_work adapter_work *> vmap_adapter_work.log
    if ($LASTEXITCODE -ne 0) { throw "vmap adapter_work failed: $LASTEXITCODE" }
    & "$ModelSim\vlog.exe" -modelsimini modelsim.ini -work work `
        "$SourceIp\sys_pll.v" "$SourceIp\video_pll.v" tb_pll_reset_calibration.v `
        2>&1 | Tee-Object -FilePath compile.log | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "vlog raw TB failed: $LASTEXITCODE" }

    $sourceText = Get-Content -LiteralPath $VendorModel -Raw
    $oldDecl = 'reg[3:0] fakelockcnt;'
    if ([regex]::Matches($sourceText, [regex]::Escape($oldDecl)).Count -ne 1) { throw 'Expected exactly one fakelockcnt declaration in the original vendor source.' }
    $adapterText = $sourceText.Replace($oldDecl, "reg[3:0] fakelockcnt=4'b0;")
    Set-Content -LiteralPath eg_phy_pll_init_adapter.v -Value $adapterText -Encoding ascii
    $diffLine = 'reg[3:0] fakelockcnt; => reg[3:0] fakelockcnt=4''b0;'
    Set-Content -LiteralPath adapter_diff.txt -Value $diffLine -Encoding ascii
    & "$ModelSim\vlog.exe" -modelsimini modelsim.ini -work adapter_work `
        eg_phy_pll_init_adapter.v 2>&1 | Tee-Object -FilePath compile_adapter.log | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "vlog adapter model failed: $LASTEXITCODE" }

    function Invoke-Case([string]$Name, [string[]]$Libraries, [switch]$Pulse, [switch]$Adapter) {
        $simulationArgs = @('-modelsimini', 'modelsim.ini', '-c', '-novopt')
        foreach ($library in $Libraries) { $simulationArgs += @('-L', $library) }
        $simulationArgs += @('work.tb_pll_reset_calibration', 'EG4.glbl')
        if ($Pulse) { $simulationArgs += '+PULSE' }
        if ($Adapter) { $simulationArgs += '+MODEL_ADAPTER' }
        $simulationArgs += @('-do', 'run -all; quit -f', '-l', "$Name.log")
        & "$ModelSim\vsim.exe" @simulationArgs 2>&1 | Tee-Object -FilePath "$Name`_console.log" | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "vsim $Name failed: $LASTEXITCODE" }
        $resultLines = Select-String -LiteralPath "$Name.log" -Pattern '^# RESULT (.+)$'
        if ($resultLines.Count -ne 1) { throw "Missing or duplicate RESULT line in $Name.log" }
        $text = Get-Content -LiteralPath "$Name.log" -Raw
        foreach ($expected in @('Loading work.sys_pll', 'Loading work.video_pll', 'Loading EG4.glbl')) {
            if ($Name -ne 'adapter_no_reset' -and $text -notmatch [regex]::Escape($expected)) { throw "$Name did not load expected module: $expected" }
            if ($Name -eq 'adapter_no_reset' -and $text -notmatch [regex]::Escape($expected)) { throw "$Name did not load expected module: $expected" }
        }
        if ($Name -ne 'adapter_no_reset' -and $text -notmatch 'Loading EG4\.EG_PHY_PLL') { throw "$Name did not load the original EG4.EG_PHY_PLL." }
        if ($Name -eq 'adapter_no_reset' -and $text -notmatch 'Loading adapter_work\.EG_PHY_PLL') { throw 'Adapter run did not load the local adapter_work.EG_PHY_PLL.' }
        $locks = @{}
        foreach ($match in [regex]::Matches($text, 'LOCK (sys|video) at ([0-9.]+) ns')) { $locks[$match.Groups[1].Value] = [double]$match.Groups[2].Value }
        return [pscustomobject]@{ name=$Name; result=$resultLines[0].Matches[0].Groups[1].Value; log="$Name.log"; lock_time_raw=$locks }
    }

    $noReset = Invoke-Case 'no_reset' @('work','EG4')
    $pulse = Invoke-Case 'reset_pulse' @('work','EG4') -Pulse
    $adapter = Invoke-Case 'adapter_no_reset' @('adapter_work','work','EG4') -Adapter
    $vendorHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $VendorModel).Hash
    $adapterHash = (Get-FileHash -Algorithm SHA256 -LiteralPath eg_phy_pll_init_adapter.v).Hash
    $sysHash = (Get-FileHash -Algorithm SHA256 -LiteralPath "$SourceIp\sys_pll.v").Hash
    $videoHash = (Get-FileHash -Algorithm SHA256 -LiteralPath "$SourceIp\video_pll.v").Hash
    $stableSysHash = (Get-FileHash -Algorithm SHA256 -LiteralPath "$StableCheckpoint\sys_pll.v").Hash
    $stableVideoHash = (Get-FileHash -Algorithm SHA256 -LiteralPath "$StableCheckpoint\video_pll.v").Hash
    $summary = [ordered]@{
        status = if ($noReset.result -ne 'PASS_BOTH_LOCKED') { 'MODEL_CALIBRATION_FAILED' } else { 'MODEL_CALIBRATION_PASS' }
        interpretation = 'The no-reset case matches reset=0 on both wrapper inputs and is the relevant model-equivalent case; a testbench-only pulse is diagnostic evidence and does not represent the production top.'
        no_reset = $noReset
        testbench_reset_pulse = $pulse
        no_reset_equivalent_model_qualified = ($noReset.result -eq 'PASS_BOTH_LOCKED')
        adapter = [ordered]@{
            status = if ($adapter.result -eq 'PASS_BOTH_LOCKED') { 'MODEL_INIT_ADAPTER_FUNCTIONAL_PASS' } else { 'MODEL_INIT_ADAPTER_FUNCTIONAL_FAIL' }
            run = $adapter
            note = 'Local one-line initialization hypothesis only; it does not make the original vendor model or production hardware pass.'
        }
        adapter_status = if ($adapter.result -eq 'PASS_BOTH_LOCKED') { 'MODEL_INIT_ADAPTER_FUNCTIONAL_PASS' } else { 'MODEL_INIT_ADAPTER_FUNCTIONAL_FAIL' }
        adapter_no_reset = $adapter
        adapter_note = 'Local one-line initialization hypothesis only; it does not make the original vendor model or production hardware pass.'
        vendor_model_sha256 = $vendorHash
        adapter_model_sha256 = $adapterHash
        adapter_diff = $diffLine
        sys_pll_sha256 = $sysHash
        video_pll_sha256 = $videoHash
        stable_C11206_checkpoint_sys_pll_sha256 = $stableSysHash
        stable_C11206_checkpoint_video_pll_sha256 = $stableVideoHash
        stable_C11206_wrappers_match = (($sysHash -eq $stableSysHash) -and ($videoHash -eq $stableVideoHash))
        vendor_model_path = $VendorModel
        tool = 'ModelSim SE-64 10.1c'
        sampled_at_us = @(1,100,1000)
    }
    $summary | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath summary.json -Encoding utf8
    Write-Output ("status={0}; no_reset={1}; pulse={2}; adapter={3}; stable_wrappers_match={4}" -f $summary.status, $noReset.result, $pulse.result, $adapter.result, $summary.stable_C11206_wrappers_match)
}
finally { Pop-Location }
