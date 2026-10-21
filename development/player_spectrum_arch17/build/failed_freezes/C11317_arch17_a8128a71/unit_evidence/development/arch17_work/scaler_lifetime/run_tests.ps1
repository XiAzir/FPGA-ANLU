param(
    [string]$Iverilog = 'E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe',
    [string]$Vvp = 'E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
)
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$tests = @(
    @{ Name='default_13case'; Top='tb_rowstep_equiv'; Sources=@('bmp_scale_engine_base_test.v','bmp_scale_engine_candidate_dut.v','tb_default_13case.v') },
    @{ Name='valid_domain'; Top='tb_rowstep_equiv'; Sources=@('bmp_scale_engine_base_test.v','bmp_scale_engine_candidate_dut.v','tb_valid_domain.v') },
    @{ Name='diagnostic_538'; Top='tb_tf_bmp_failure_detail'; Sources=@('bmp_scale_engine_base_test.v','bmp_scale_engine_candidate_test.v','tf_bmp_file_player_base_test.v','tf_bmp_file_player_candidate_test.v','key_press_debounce.v','tb_538_diagnostic.v') }
)
foreach ($test in $tests) {
    $image = Join-Path $root ($test.Name + '.vvp')
    $compileLog = Join-Path $root ($test.Name + '_compile.log')
    $runLog = Join-Path $root ($test.Name + '_run.log')
    $sources = @($test.Sources | ForEach-Object { Join-Path $root $_ })
    & $Iverilog -g2001 -s $test.Top -o $image @sources *> $compileLog
    if ($LASTEXITCODE -ne 0) { throw "$($test.Name) compile failed; see $compileLog" }
    & $Vvp $image *> $runLog
    if ($LASTEXITCODE -ne 0) { throw "$($test.Name) simulation failed; see $runLog" }
    $pass = Select-String -LiteralPath $runLog -Pattern 'PASS' | Select-Object -Last 1
    if (-not $pass) { throw "$($test.Name) did not emit PASS; see $runLog" }
    Write-Output "$($test.Name): $($pass.Line.Trim())"
}
