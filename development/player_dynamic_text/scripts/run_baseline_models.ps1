$ErrorActionPreference = 'Stop'
$taskRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskTools = 'E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin'
foreach ($taskCase in @(@('osd','player_osd'), @('state','player_osd_state'))) {
    $taskDir = Join-Path $taskRoot ('build/' + $taskCase[0] + '_sim')
    New-Item -ItemType Directory -Path $taskDir -Force | Out-Null
    Push-Location $taskDir
    try {
        & (Join-Path $taskTools 'iverilog.exe') -g2012 -s ('tb_' + $taskCase[1]) -o model.vvp (Join-Path $taskRoot ('src/user_source/hdl_source/' + $taskCase[1] + '.v')) (Join-Path $taskRoot ('sim/tb_' + $taskCase[1] + '.v')) *> compile.log
        if ($LASTEXITCODE -ne 0) { throw 'Baseline model compilation failed' }
        & (Join-Path $taskTools 'vvp.exe') model.vvp *> run.log
        if ($LASTEXITCODE -ne 0) { throw 'Baseline model simulation failed' }
        $taskLog = Get-Content -LiteralPath run.log -Raw
        if ($taskLog -notmatch 'PASS' -or $taskLog -match 'FAIL|FATAL') { throw 'Baseline model did not pass' }
        Get-Content -LiteralPath run.log -Tail 3
    } finally { Pop-Location }
}
