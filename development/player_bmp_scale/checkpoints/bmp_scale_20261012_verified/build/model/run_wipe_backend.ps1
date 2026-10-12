$ErrorActionPreference = 'Stop'
$modelDir = $PSScriptRoot
$projectRoot = (Resolve-Path (Join-Path $modelDir '../..')).Path
$workspaceRoot = (Resolve-Path (Join-Path $projectRoot '../..')).Path
$iverilog = Join-Path $workspaceRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = Join-Path $workspaceRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$sourceRoot = Join-Path $projectRoot 'src/user_source/hdl_source'
Push-Location $modelDir
try {
    & $iverilog -g2012 -Wall -s tb_wipe_backend -o 'wipe_backend.vvp' `
        'tb_wipe_backend.v' `
        (Join-Path $sourceRoot 'SD/frame_fifo_read.v') `
        (Join-Path $sourceRoot 'player_wipe_address.v') `
        (Join-Path $sourceRoot 'player_osd_state.v') *> 'wipe_backend_compile.log'
    if ($LASTEXITCODE -ne 0) {
        Get-Content 'wipe_backend_compile.log'
        throw 'wipe backend model compile failed'
    }
    & $vvp 'wipe_backend.vvp' *> 'wipe_backend.log'
    if ($LASTEXITCODE -ne 0) {
        Get-Content 'wipe_backend.log'
        throw 'wipe backend model failed'
    }
    Get-Content 'wipe_backend.log'
    if (Select-String 'wipe_backend.log' -Pattern '(^|\s)(FAIL|FATAL)(\s|:)' -Quiet) {
        throw 'WIPE_BACKEND log contains FAIL/FATAL'
    }
    $passPattern = '^WIPE_BACKEND PASS streams=121 production_frames=121 direction_changes=2 words_per_frame=230400 app_reads=28109056 release_toggles=3 pending_burst=126$'
    if (-not (Select-String 'wipe_backend.log' -Pattern $passPattern -Quiet)) {
        throw 'Expected full production coverage PASS marker absent'
    }
} finally {
    Pop-Location
}
