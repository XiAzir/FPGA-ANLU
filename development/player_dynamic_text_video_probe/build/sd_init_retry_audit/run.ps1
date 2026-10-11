$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$probe = (Resolve-Path (Join-Path $here '..\..')).Path
$project = (Resolve-Path (Join-Path $here '..\..\..\..')).Path
$src = Join-Path $probe 'src\user_source\hdl_source\SD'
$iverilog = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
if (!(Test-Path -LiteralPath $iverilog)) { throw "Icarus compiler missing: $iverilog" }
if (!(Test-Path -LiteralPath $vvp)) { throw "Icarus runtime missing: $vvp" }
$out = Join-Path $here 'sd_init_retry.vvp'
$compileLog = Join-Path $here 'compile.log'
'Icarus Verilog 12.0 (devel) (s20150603-1539-g2693dd32b)' | Set-Content -LiteralPath $compileLog -Encoding utf8
& $iverilog -g2012 -s tb_sd_init_retry -o $out (Join-Path $src 'sd_card_sec_read_write.v') (Join-Path $src 'sd_card_cmd.v') (Join-Path $here 'tb_sd_init_retry.v') 2>&1 | Tee-Object -FilePath $compileLog -Append
if ($LASTEXITCODE -ne 0) { throw "iverilog failed: $LASTEXITCODE" }
foreach ($scenario in @(@{Name='baseline'; Arg=-1}, @{Name='cmd0_illegal_r1_once'; Arg=0}, @{Name='cmd8_illegal_r1_once'; Arg=8}, @{Name='cmd41_illegal_r1_once'; Arg=41})) {
    "=== $($scenario.Name) ===" | Tee-Object -FilePath (Join-Path $here "$($scenario.Name).log")
    & $vvp $out "+fail_cmd=$($scenario.Arg)" 2>&1 | Tee-Object -FilePath (Join-Path $here "$($scenario.Name).log") -Append
    if ($LASTEXITCODE -ne 0) { throw "scenario $($scenario.Name) failed: $LASTEXITCODE" }
}
