$ErrorActionPreference='Stop'
Set-Location $PSScriptRoot
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
$modelBin='E:/ModelsimSE/win64'
$baseLib=(Resolve-Path ../work).Path.Replace('\','/')
$ini="[Library]`nwork = work`nc11310 = $baseLib`nothers = E:/ModelsimSE/modelsim.ini`n"
[IO.File]::WriteAllText((Join-Path $PSScriptRoot modelsim.ini),$ini)
if(!(Test-Path work)){ & "$modelBin/vlib.exe" work }
& "$modelBin/vlog.exe" -work work tb_fft_gate.v *> compile.log
if($LASTEXITCODE){throw 'vlog failed; see compile.log'}
@'
onerror {quit -code 2 -f}
onbreak {quit -code 3 -f}
run -all
quit -code 0 -f
'@ | Set-Content run.do
$vectorRoot=(Resolve-Path ../../../../sim/vectors).Path.Replace('\','/')
& "$modelBin/vsim.exe" -c -lic_noqueue -vopt '-voptargs=+acc=rn+top' -suppress 3017,3722 -L c11310 work.tb_fft_gate c11310.glbl "+VEC=$vectorRoot/all_samples.mem" "+EXP=$vectorRoot/all_expected.mem" -do run.do -l optimized_run.log *> optimized_console.log
if($LASTEXITCODE){throw 'vsim failed; see console.log'}
$runText=Get-Content optimized_console.log -Raw
if($runText -notmatch 'PASS fft_gate' -or $runText -match '# FAIL'){throw 'test did not pass; see console.log'}
Select-String -Path optimized_console.log -Pattern 'BOUNDARY|CASE_RESULT|PASS fft_gate'
