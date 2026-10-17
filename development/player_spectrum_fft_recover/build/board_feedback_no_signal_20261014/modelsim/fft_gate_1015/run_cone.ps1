$ErrorActionPreference='Stop'
Set-Location $PSScriptRoot
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
$modelBin='E:/ModelsimSE/win64'
$baseLib=(Resolve-Path ../work).Path.Replace('\','/')
$ini="[Library]`nwork = cone_work`nc11310 = $baseLib`nothers = E:/ModelsimSE/modelsim.ini`n"
[IO.File]::WriteAllText((Join-Path $PSScriptRoot cone.ini),$ini)
if(!(Test-Path cone_work)){ & "$modelBin/vlib.exe" cone_work }
& "$modelBin/vlog.exe" -modelsimini cone.ini -work work fft_cone.v tb_fft_cone.v *> cone_compile.log
if($LASTEXITCODE){throw 'vlog failed; see cone_compile.log'}
@'
onerror {quit -code 2 -f}
onbreak {quit -code 3 -f}
run -all
quit -code 0 -f
'@ | Set-Content cone.do
$vectorRoot=(Resolve-Path ../../../../sim/vectors).Path.Replace('\','/')
& "$modelBin/vsim.exe" -modelsimini cone.ini -c -lic_noqueue -novopt -suppress 3017,3722 -L c11310 work.tb_fft_cone c11310.glbl "+VEC=$vectorRoot/all_samples.mem" "+EXP=$vectorRoot/all_expected.mem" -do cone.do -l cone_run.log *> cone_console.log
if($LASTEXITCODE){throw 'vsim failed; see cone_console.log'}
$runText=Get-Content cone_console.log -Raw
if($runText -notmatch 'PASS fft_cone' -or $runText -match '# FAIL'){throw 'test did not pass; see cone_console.log'}
Select-String -Path cone_console.log -Pattern 'BOUNDARY|CASE_RESULT|PASS fft_cone'
