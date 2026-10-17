$ErrorActionPreference='Stop'
Set-Location (Join-Path $PSScriptRoot routed)
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
$modelBin='E:/ModelsimSE/win64'
$baseLib=(Resolve-Path ../../work).Path.Replace('\','/')
$ini="[Library]`nwork = work`nc11310 = $baseLib`nothers = E:/ModelsimSE/modelsim.ini`n"
[IO.File]::WriteAllText((Join-Path (Get-Location).Path modelsim.ini),$ini)
if(!(Test-Path work)){ & "$modelBin/vlib.exe" work }
& "$modelBin/vlog.exe" -work work fft_cone.v ../tb_fft_cone.v *> compile.log
if($LASTEXITCODE){throw 'vlog failed; see compile.log'}
@'
onerror {quit -code 2 -f}
onbreak {quit -code 3 -f}
run -all
quit -code 0 -f
'@ | Set-Content run.do
$vectorRoot=(Resolve-Path ../../../../../sim/vectors).Path.Replace('\','/')
& "$modelBin/vsim.exe" -c -lic_noqueue -novopt -suppress 3017,3722 -L c11310 work.tb_fft_cone c11310.glbl "+VEC=$vectorRoot/all_samples.mem" "+EXP=$vectorRoot/all_expected.mem" -do run.do -l run.log *> console.log
if($LASTEXITCODE){throw 'vsim failed; see console.log'}
$runText=Get-Content console.log -Raw
if($runText -notmatch 'PASS fft_cone' -or $runText -match '# FAIL'){throw 'test did not pass; see console.log'}
Select-String -Path console.log -Pattern 'BOUNDARY|CASE_RESULT|PASS fft_cone'
