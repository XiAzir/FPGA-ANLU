$ErrorActionPreference='Stop'
$dir=$PSScriptRoot
Set-Location -LiteralPath $dir
$bin='E:\ModelsimSE\win64'
$lic=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
if($lic){$env:MGLS_LICENSE_FILE=$lic}
$commands=@(
 @{name='vdel';args=@('-lib','work','-all')},
 @{name='vlib';args=@('work')},
 @{name='vlog';args=@('-modelsimini','modelsim.ini','-work','work','-f','tone_plain.f')},
 @{name='vsim';args=@('-modelsimini','modelsim.ini','-c','-novopt','-lic_noqueue','-L','work','-L','eg4','-L','hdmi','work.tb_hdmi_tone_metadata','work.glbl','-do','run.do','-l','tone_run.log')}
)
foreach($c in $commands){
  $log=Join-Path $dir ($c.name+'_tone.log')
  "Command: $($c.name) $($c.args -join ' ')" | Set-Content -LiteralPath $log -Encoding utf8
  & (Join-Path $bin ($c.name+'.exe')) @($c.args) 2>&1 | Tee-Object -FilePath $log -Append
  $code=$LASTEXITCODE
  "ExitCode: $code" | Add-Content -LiteralPath $log -Encoding utf8
  if($code -ne 0){throw "$($c.name) failed with exit $code; see $log"}
}
$run=Join-Path $dir 'tone_run.log'
if(-not (Select-String -LiteralPath $run -Pattern 'STRICT_PERIOD_CONTENT_PASS' -Quiet)){throw 'Expected full serial pin test pass marker missing'}
if(-not (Select-String -LiteralPath $run -Pattern 'SUBFRAMES=192' -Quiet)){throw 'Did not capture 192 audio subframes'}
if(-not (Select-String -LiteralPath $run -Pattern 'PATCHED_PIN_PASS' -Quiet)){throw 'Patched metadata end-to-end assertions did not pass'}
