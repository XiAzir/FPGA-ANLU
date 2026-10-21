$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$iverilog = Join-Path $projectRoot 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $projectRoot 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$outputFile = Join-Path $PSScriptRoot 'tb_key_events.vvp'
$loaderElabFile = Join-Path $PSScriptRoot 'loader_elab.vvp'
$versionLog = Join-Path $PSScriptRoot 'iverilog_version.log'
$compileLog = Join-Path $PSScriptRoot 'compile.log'
$loaderElabLog = Join-Path $PSScriptRoot 'loader_elab.log'
$runLog = Join-Path $PSScriptRoot 'run.log'

$versionOutput = & $iverilog -V 2>&1 | Out-String
Set-Content -Path $versionLog -Value $versionOutput -Encoding utf8NoBOM
if ($LASTEXITCODE -ne 0) { throw "Icarus version command exited with $LASTEXITCODE" }

$compileOutput = & $iverilog -g2012 -s tb_key_events -o $outputFile `
    (Join-Path $PSScriptRoot 'reference_player_adjust_control.v') `
    (Join-Path $PSScriptRoot 'player_adjust_control.v') `
    (Join-Path $PSScriptRoot 'tf_bmp_file_player_event_candidate.v') `
    (Join-Path $PSScriptRoot 'tb_key_events.v') 2>&1
$compileExit = $LASTEXITCODE
$compileRecord = @(
    "command: $iverilog -g2012 -s tb_key_events -o $outputFile $(Join-Path $PSScriptRoot 'reference_player_adjust_control.v') $(Join-Path $PSScriptRoot 'player_adjust_control.v') $(Join-Path $PSScriptRoot 'tf_bmp_file_player_event_candidate.v') $(Join-Path $PSScriptRoot 'tb_key_events.v')"
    "exit_code: $compileExit"
) + @($compileOutput | ForEach-Object { "$_" })
$compileRecord | Set-Content -Path $compileLog -Encoding utf8NoBOM
if ($compileExit -ne 0) {
    $compileOutput
    exit $compileExit
}

$loaderElabOutput = & $iverilog -g2012 -i -s tf_bmp_file_player -o $loaderElabFile `
    (Join-Path $PSScriptRoot 'tf_bmp_file_player_event_candidate.v') 2>&1
$loaderElabExit = $LASTEXITCODE
$loaderElabRecord = @(
    "command: $iverilog -g2012 -i -s tf_bmp_file_player -o $loaderElabFile $(Join-Path $PSScriptRoot 'tf_bmp_file_player_event_candidate.v')"
    "exit_code: $loaderElabExit"
) + @($loaderElabOutput | ForEach-Object { "$_" })
$loaderElabRecord | Set-Content -Path $loaderElabLog -Encoding utf8NoBOM
if ($loaderElabExit -ne 0) {
    $loaderElabOutput
    exit $loaderElabExit
}

$runOutput = & $vvp $outputFile 2>&1
$runExit = $LASTEXITCODE
$runRecord = @(
    'command: vvp tb_key_events.vvp'
    "exit_code: $runExit"
) + @($runOutput | ForEach-Object { "$_" })
$runRecord | Set-Content -Path $runLog -Encoding utf8NoBOM
$runOutput
if ($runExit -ne 0) { exit $runExit }
