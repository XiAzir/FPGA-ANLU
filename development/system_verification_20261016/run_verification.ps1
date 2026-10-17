param(
    [ValidateSet('readiness','startup','pll','foundation','media','media-pins','framebuffer','controller')]
    [string]$Stage='readiness',
    [ValidateSet('C11206','C11309','C11310','C11312')]
    [string]$Version='C11206'
)
$ErrorActionPreference='Stop'
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
$env:PYTHONIOENCODING='utf-8'
if($Stage -eq 'media') {
    & python (Join-Path $PSScriptRoot 'integration/run_system.py') --version $Version
    if($LASTEXITCODE -ne 0){throw 'Full-top media simulation did not pass; inspect its timestamped run directory.'}
}
if($Stage -eq 'media-pins') {
    & python (Join-Path $PSScriptRoot 'integration/run_system.py') --version $Version --clock-model replay --serial-scoreboard
    if($LASTEXITCODE -ne 0){throw 'Full-top HDMI pin content simulation did not pass.'}
}
if($Stage -eq 'controller') {
    & python (Join-Path $PSScriptRoot 'memory/run_controller_gate.py') --matrix
    if($LASTEXITCODE -ne 0){throw 'Synthesized SDRAM controller pin-model matrix did not pass.'}
    & python (Join-Path $PSScriptRoot 'memory/run_controller_gate.py') --matrix --corrupt-data
    if($LASTEXITCODE -ne 0){throw 'Synthesized SDRAM controller negative control was not detected exactly.'}
}
if($Stage -eq 'framebuffer') {
    & python (Join-Path $PSScriptRoot 'memory/run_framebuffer.py')
    if($LASTEXITCODE -ne 0){throw 'Frame-buffer application-model check did not pass.'}
}
if($Stage -in @('startup','foundation')) {
    & python (Join-Path $PSScriptRoot 'startup/run.py')
    if($LASTEXITCODE -ne 0){throw 'Startup contract simulation failed; inspect the new run directory.'}
}
if($Stage -in @('pll','foundation')) {
    $pllEntry=Join-Path $PSScriptRoot 'pll/run.ps1'
    if(!(Test-Path -LiteralPath $pllEntry)){throw 'PLL calibration runner is not available.'}
    & pwsh -NoProfile -File $pllEntry
    if($LASTEXITCODE -ne 0){throw 'PLL calibration execution failed; inspect its logs.'}
}
& python (Join-Path $PSScriptRoot 'readiness.py')
exit $LASTEXITCODE
