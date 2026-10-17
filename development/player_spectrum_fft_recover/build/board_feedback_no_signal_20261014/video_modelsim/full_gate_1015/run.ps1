$ErrorActionPreference='Stop'
Set-Location $PSScriptRoot
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
$modelBin='E:/ModelsimSE/win64'
$baseLib=(Resolve-Path ../../modelsim/work).Path.Replace('\','/')
$ini="[Library]`nwork = work`nc11310 = $baseLib`nothers = E:/ModelsimSE/modelsim.ini`n"
[IO.File]::WriteAllText((Join-Path $PSScriptRoot modelsim.ini),$ini)
if(!(Test-Path work)){ & "$modelBin/vlib.exe" work }
& "$modelBin/vlog.exe" -work work video_full_cone.v tb_video_full_cone.v *> compile.log
if($LASTEXITCODE){throw 'vlog failed; see compile.log'}
@'
onerror {quit -code 2 -f}
onbreak {quit -code 3 -f}
run -all
quit -code 0 -f
'@ | Set-Content run.do
& "$modelBin/vsim.exe" -c -novopt -lic_noqueue -suppress 3017,3722 -L c11310 work.tb_video_full_cone c11310.glbl -do run.do -l run.log *> console.log
if($LASTEXITCODE){throw 'vsim failed; see console.log'}
$runText=Get-Content console.log -Raw
if($runText -notmatch 'PASS video_full_cone' -or $runText -match '# FAIL'){throw 'test did not pass; see console.log'}
Select-String -Path console.log -Pattern 'BOUNDARY|SOF n=|PASS video_full_cone'
