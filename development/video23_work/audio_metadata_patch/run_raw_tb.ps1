$ErrorActionPreference='Stop'
$dir=$PSScriptRoot
Set-Location -LiteralPath $dir
$tmp=Join-Path $dir 'tmp'
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
$env:TEMP=$tmp
$env:TMP=$tmp
$iv='C:\Users\PENGYUHAO\.cursor\extensions\iccoderagenticverilogplatform.iccoder-2.0.9\tools\iverilog\win\bin\iverilog.exe'
$vvp='C:\Users\PENGYUHAO\.cursor\extensions\iccoderagenticverilogplatform.iccoder-2.0.9\tools\iverilog\win\bin\vvp.exe'
& $iv -g2012 -s tb_audio_metadata_patch -o (Join-Path $dir 'tb.vvp') `
  (Join-Path $dir 'hdmi_audio_metadata_patch.v') `
  (Join-Path $dir 'tb_audio_metadata_patch.v') `
  (Join-Path $dir '..\audio_analysis\metadata_pin_sim\hdmi_packet_monitor.v') *> (Join-Path $dir 'compile.log')
if($LASTEXITCODE -ne 0){throw "Icarus compile failed; see compile.log"}
& $vvp (Join-Path $dir 'tb.vvp') *> (Join-Path $dir 'raw_run.log')
if($LASTEXITCODE -ne 0){throw "Icarus run failed; see raw_run.log"}
if(-not (Select-String -LiteralPath (Join-Path $dir 'raw_run.log') -Pattern 'RAW_TMDSPATCH_PASS' -Quiet)){throw 'Required PASS marker missing from raw_run.log'}
Get-Content (Join-Path $dir 'raw_run.log')
