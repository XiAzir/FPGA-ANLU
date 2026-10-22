$ErrorActionPreference='Stop'
$dir=$PSScriptRoot
Set-Location -LiteralPath $dir
$bin='E:\ModelsimSE\win64'
$lic=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
if($lic){$env:MGLS_LICENSE_FILE=$lic}
$commands=@(
 @{name='vdel';args=@('-lib','work','-all')},
 @{name='vlib';args=@('work')},
 @{name='vlog';args=@('-modelsimini','modelsim.ini','-work','work','-f','plain.f')},
 @{name='vsim';args=@('-modelsimini','modelsim.ini','-c','-novopt','-lic_noqueue','-L','work','-L','eg4','-L','hdmi','work.tb_hdmi_metadata','work.glbl','+sequence_audio','-do','run.do','-l','run.log')}
)
foreach($c in $commands){
  $log=Join-Path $dir ($c.name+'.log')
  "Command: $($c.name) $($c.args -join ' ')" | Set-Content -LiteralPath $log -Encoding utf8
  & (Join-Path $bin ($c.name+'.exe')) @($c.args) 2>&1 | Tee-Object -FilePath $log -Append
  $code=$LASTEXITCODE
  "ExitCode: $code" | Add-Content -LiteralPath $log -Encoding utf8
  if($code -ne 0){throw "$($c.name) failed with exit $code; see $log"}
}


