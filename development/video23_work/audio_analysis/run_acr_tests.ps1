$ErrorActionPreference='Stop'
$repo='E:\VSCODE-project\FPGA-ANLU'
. (Join-Path $repo 'scripts\anlu_tools.ps1')
$here=$PSScriptRoot
$iverilog=Resolve-AnluTool -Name 'iverilog'
$vvp=Resolve-AnluTool -Name 'vvp'
$tb=Join-Path $here 'tb_acr_calculate.v'
$dut=Join-Path $repo 'development\player_video22_audio_diag\src\user_source\hdl_source\audio_arc_calculate.v'
$image=Join-Path $here 'tb_acr_calculate.vvp'
$compileLog=Join-Path $here 'compile.log'
$simLog=Join-Path $here 'simulation.log'
"Tool: $iverilog`nArguments: -g2012 -s tb_acr_calculate -o $image $tb $dut`n" | Set-Content -LiteralPath $compileLog -Encoding utf8
& $iverilog -g2012 -s tb_acr_calculate -o $image $tb $dut 2>&1 | Tee-Object -FilePath $compileLog -Append
$code=$LASTEXITCODE
"ExitCode: $code" | Add-Content -LiteralPath $compileLog -Encoding utf8
if($code -ne 0){throw "iverilog failed: $code"}
"Tool: $vvp`nArguments: $image`n" | Set-Content -LiteralPath $simLog -Encoding utf8
& $vvp $image 2>&1 | Tee-Object -FilePath $simLog -Append
$code=$LASTEXITCODE
"ExitCode: $code" | Add-Content -LiteralPath $simLog -Encoding utf8
if($code -ne 0){throw "vvp failed: $code"}
if(-not (Select-String -LiteralPath $simLog -Pattern '^ACR_TEST_PASS ' -Quiet)){throw 'ACR pass marker missing'}
