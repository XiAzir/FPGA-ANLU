param(
 [Parameter(Mandatory=$true)][string]$SourcePath,
 [Parameter(Mandatory=$true)][string]$CaseName
)
$ErrorActionPreference='Stop'
$source=(Resolve-Path -LiteralPath $SourcePath).Path
Set-Location $PSScriptRoot
$caseDir=Join-Path $PSScriptRoot $CaseName
New-Item -ItemType Directory -Path $caseDir -Force | Out-Null
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
$modelBin='E:/ModelsimSE/win64'
$baseLib=(Resolve-Path '../../player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/modelsim/work').Path.Replace('\','/')
python (Join-Path $PSScriptRoot 'extract_video.py') --video --source $source --out $caseDir *> (Join-Path $caseDir 'extract.log')
if($LASTEXITCODE){throw 'video-cone extraction failed; see case extract.log'}
$ini="[Library]`nwork = work`neg4 = $baseLib`nothers = E:/ModelsimSE/modelsim.ini`n"
[IO.File]::WriteAllText((Join-Path $caseDir 'modelsim.ini'),$ini)
Push-Location $caseDir
if(!(Test-Path work)){ & "$modelBin/vlib.exe" work }
& "$modelBin/vlog.exe" -modelsimini modelsim.ini -work work video_full_cone.v ..\tb_video_full_cone.v *> compile.log
if($LASTEXITCODE){Pop-Location;throw 'vlog failed; see case compile.log'}
@'
onerror {quit -code 2 -f}
onbreak {quit -code 3 -f}
run -all
quit -code 0 -f
'@ | Set-Content run.do
& "$modelBin/vsim.exe" -modelsimini modelsim.ini -c -novopt -lic_noqueue -suppress 3017,3722 -L eg4 work.tb_video_full_cone eg4.glbl -do run.do -l run.log *> console.log
if($LASTEXITCODE){Pop-Location;throw 'vsim failed; see case console.log'}
$runText=Get-Content console.log -Raw
if($runText -notmatch 'PASS video_full_cone' -or $runText -match '# FAIL'){Pop-Location;throw 'test did not pass; see case console.log'}
Select-String -Path console.log -Pattern 'BOUNDARY|SOF n=|PASS video_full_cone'
Pop-Location
