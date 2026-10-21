$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = (Resolve-Path (Join-Path $scriptRoot '..\..\..')).Path
$iverilog = Join-Path $repoRoot 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $repoRoot 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$baselineHdl = Join-Path $repoRoot 'development\player_spectrum_arch17\src\user_source\hdl_source'
$buildDir = Join-Path $scriptRoot 'build'
New-Item -ItemType Directory -Force $buildDir | Out-Null
Set-Location $scriptRoot

function Invoke-CompileAndRun {
    param(
        [string]$Name,
        [string[]]$CompileArgs
    )

    $sim = Join-Path $buildDir "$Name.vvp"
    $log = Join-Path $buildDir "$Name.log"
    "Icarus command: $iverilog -o $sim $($CompileArgs -join ' ')" | Set-Content -LiteralPath $log
    & $iverilog -o $sim @CompileArgs 2>&1 | Tee-Object -FilePath $log -Append
    if ($LASTEXITCODE -ne 0) { throw "Icarus compile failed for $Name (exit $LASTEXITCODE)" }
    "Run command: $vvp $sim" | Tee-Object -FilePath $log -Append
    & $vvp $sim 2>&1 | Tee-Object -FilePath $log -Append
    if ($LASTEXITCODE -ne 0) { throw "vvp failed for $Name (exit $LASTEXITCODE)" }
}

Invoke-CompileAndRun -Name 'protocol_phase0' -CompileArgs @(
    '-g2012', '-s', 'tb_status_domain', '-Ptb_status_domain.PHASE_NS=0',
    'status_hex595.v',
    (Join-Path $baselineHdl 'player_status_mailbox.v'),
    'status_word_checker.v', 'tb_status_domain.v'
)

Invoke-CompileAndRun -Name 'protocol_phase10' -CompileArgs @(
    '-g2012', '-s', 'tb_status_domain', '-Ptb_status_domain.PHASE_NS=10',
    'status_hex595.v',
    (Join-Path $baselineHdl 'player_status_mailbox.v'),
    'status_word_checker.v', 'tb_status_domain.v'
)

Invoke-CompileAndRun -Name 'page_update_collision' -CompileArgs @(
    '-g2012', '-s', 'tb_page_update_collision',
    'status_hex595.v',
    (Join-Path $baselineHdl 'player_status_monitor.v'),
    'status_word_checker.v', 'tb_page_update_collision.v'
)

Get-FileHash -LiteralPath (Join-Path $baselineHdl 'status_hex595.v') -Algorithm SHA256
Get-FileHash -LiteralPath (Join-Path $scriptRoot 'status_hex595.v') -Algorithm SHA256
